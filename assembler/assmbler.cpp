#include <bits/stdc++.h>

using namespace std;

// Instruction set mapping to opcode and function code
unordered_map<string, pair<string, string>> instructionSet = {
        {"NOP",    {"00000", "00"}},
        {"HLT",    {"00001", "00"}},
        {"SETC",   {"00010", "00"}},
        {"ADD",    {"00011", "00"}},
        {"SUB",    {"00011", "01"}},
        {"AND",    {"00011", "10"}},
        {"INC",    {"00011", "11"}},
        {"IADD",   {"00100", "00"}},
        {"OUT",    {"00101", "00"}},
        {"IN",     {"00110", "00"}},
        {"NOT",    {"00111", "00"}},
        {"MOV",    {"01000", "00"}},
        {"PUSH",   {"01001", "00"}},
        {"POP",    {"01010", "00"}},
        {"LDM",    {"01011", "00"}},
        {"LDD",    {"01100", "00"}},
        {"STD",    {"01101", "00"}},
        {"JZ",     {"10000", "00"}},
        {"JN",     {"10001", "00"}},
        {"JC",     {"10010", "00"}},
        {"JMP",    {"10011", "00"}},
        {"CALL",   {"10100", "00"}},
        {"RET",    {"10101", "00"}},
        {"INT",    {"10110", "00"}},
        {"RTI",    {"10111", "00"}},
        {"RESET",  {"11111", "00"}}
};



unordered_map<string, bool> oneOperand = {
        {"CALL", true},
        {"JC", true},
        {"JMP", true},
        {"JN",true},
        {"JZ",true},
        {"PUSH",true}
};


// Instructions that need two locations (operands)
unordered_map<string, int> needsTwoLocations = {
        {"IADD", 3},
        {"LDM", 2},
        {"LDD", 3},
        {"STD", 3},
};

// Check if string is a valid number (integer)
bool isNumber(const string& str) {
    try {
        std::stoi(str);  // Try converting to integer
        return true;
    } catch (const std::invalid_argument&) {
        return false;  // Not a valid integer
    } catch (const std::out_of_range&) {
        return false;  // Number out of range
    }
}

bool isORG(const string& line, int & index) {

    istringstream iss(line);
    string instruction, token;
    vector<string> tokens;

    while (iss >> token) {
        tokens.push_back(token);
    }

    if (tokens[0] == "#") {
        return false;  // Skip comments
    }


    if (tokens[0] == ".ORG") {
        int loc = stoi(tokens[1], nullptr, 16);
        index = loc;
        return true;
    }

    return false;
}

// Parse register and convert it to binary
string parseRegister(const string& reg) {
    if (reg[0] != 'R' || !isdigit(reg[1])) {
        return bitset<3>(0).to_string();
    }
    int regNum = stoi(reg.substr(1));
    if (regNum < 0 || regNum > 7) {
        throw out_of_range("Register out of range: " + reg);
    }
    return bitset<3>(regNum).to_string();
}


// Assemble the instruction based on tokens
void assembleInstruction(const string& line, vector<string>& mem, int &index) {
    istringstream iss(line);
    string instruction, token;
    vector<string> tokens;

    while (iss >> token) {
        tokens.push_back(token);
    }

    if (tokens.empty() || tokens[0] == "#") {
        return;  // Empty line or comment
    }
    if (isNumber(tokens[0])) {
        int loc = stoi(tokens[0], nullptr, 16);
        bitset<16> binary(loc);
        mem[index] = binary.to_string();
        index++;
        return;
    }

    if (tokens.size() > 2) {
        string str = tokens[2];
        if (str.find('(') != string::npos) {
            string offset = str.substr(0, str.find('('));
            tokens[2] = str.substr(str.find('(') + 1, 2);
            if(tokens.size()>=3){
                tokens[3] = offset;
            }else {
                tokens.push_back(offset);
            }
        }
    }



    string opcode = instructionSet[tokens[0]].first;
    string bits10_8 = "000", bits7_5 = "000", bits4_2 = "000";
    string func = instructionSet[tokens[0]].second;

    // Parse registers if they exist
    if (tokens.size() > 1) {
        bits10_8 = parseRegister(tokens[1]);
    }
    if (tokens.size() > 2) {
        bits7_5 = parseRegister(tokens[2]);
    }
    if (tokens.size() > 3) {
        bits4_2 = parseRegister(tokens[3]);
    }

    if(!oneOperand[tokens[0]]) {
        string temp = bits10_8;
        bits10_8 = bits7_5;
        bits7_5 = temp;
    }


    // Handle specific instructions (e.g., POP, LDM, IN)
    if (tokens[0] == "POP" || tokens[0] == "LDM" || tokens[0] == "IN") {
        bits7_5 = parseRegister(tokens[1]);
    } else if (tokens[0] == "OUT") {
        bits10_8 = parseRegister(tokens[1]);
    }else if(tokens[0] == "STD"){
        bits10_8 = parseRegister(tokens[1]);
        bits4_2 = parseRegister(tokens[2]);
    }

    // Create the assembled instruction
    string instructionBinary = opcode + bits10_8 + bits7_5 + bits4_2 + func;
    vector<string> assembled = {instructionBinary};

    // Handle instructions that require two operands
    if (needsTwoLocations[tokens[0]]) {
        int x = stoi(tokens[needsTwoLocations[tokens[0]]],nullptr,16);
        string imm = bitset<16>(x).to_string();
        assembled.push_back(imm);
    }

    // Store the assembled instructions in memory
    for (auto& str : assembled) {
        mem[index] = str;
        index++;
    }
}


// Assemble the entire file
void assembleFile(const string& inputFile, const string& outputFile) {
    const int maxMemorySize = 65535;
    const string nop = "0000000000000000";

    ifstream infile(inputFile);
    ofstream outfile(outputFile);
    if (!infile || !outfile) {
        throw runtime_error("Unable to open input or output file");
    }

    string line;
    int index = 0;

    vector<string> memo(maxMemorySize, nop);

    while (getline(infile, line)) {
        if (!line.empty()) {
            try {
                if (isORG(line, index)) {
                    continue;
                }else{
                    assembleInstruction(line,memo,index);
                }
            } catch (const exception& e) {
                cerr << "Error: " << e.what() << endl;
            }
        }
    }

    // Output the assembled instructions to the file
    for (auto str : memo) {
        outfile << str << endl;
    }
}

// Main entry point
int main() {
    try {
        assembleFile(".\\input.txt", ".\\output.txt");
        cout << "Assembly completed successfully." << endl;
    } catch (const exception& e) {
        cerr << "Error: " << e.what() << endl;
    }
    return 0;
}
