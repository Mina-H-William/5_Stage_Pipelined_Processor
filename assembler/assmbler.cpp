#include<bits/stdc++.h>

using namespace std;
unordered_map<string, pair<string,string>> instructionSet = {
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

unordered_map<string ,int>needsTwoLocations= {
        {"IADD",3},
        {"LDM",2},
        {"LDD",3},
        {"STD",3},
};

string parseRegister(const string& reg) {
    if (reg[0] != '$' || !isdigit(reg[1])) {
        return bitset<3>(0).to_string();
    }
    int regNum = stoi(reg.substr(1));
    if (regNum < 0 || regNum > 7) {
        throw out_of_range("Register out of range: " + reg);
    }
    return bitset<3>(regNum).to_string();
}


vector<string> assembleInstruction(const string& line) {
    istringstream iss(line);
    string instruction, token;
    vector<string> tokens;

    while (iss >> token) {
        tokens.push_back(token);
    }

    if (tokens.empty()) {
        throw invalid_argument("Empty instruction line");
    }

    // seprate the offset from the register
    if(tokens.size() > 2){
        string str = tokens[2];
        if(str.find('(') != -1){
            string offset = str.substr(0,str.find('('));
            tokens[2] = str.substr(str.find('(')+1,2);
            tokens.push_back(offset);
            cout<<offset<<" "<<tokens[2]<<"\n";

        }
    }

    string opcode = instructionSet[tokens[0]].first;
    string bits10_8 = "000",bits7_5 = "000",bits4_2 = "000" ;
    string func = instructionSet[tokens[0]].second;


    if(tokens.size() > 1){
        bits10_8 = parseRegister(tokens[1]);
    }
    if(tokens.size() > 2){
        bits7_5 = parseRegister(tokens[2]);
    }
    if(tokens.size()>3){
        bits4_2 = parseRegister(tokens[3]);
    }

    if(tokens[0] == "POP" || tokens[0] == "LDM" || tokens[0] == "IN"){
        bits7_5 = parseRegister(tokens[1]);
    }else if(tokens[0] == "OUT"){
        bits4_2 = parseRegister(tokens[1]);
    }

    instruction = opcode + bits10_8 + bits7_5 + bits4_2 + func;
    vector<string>assembled = {instruction};
    if(needsTwoLocations[tokens[0]]){
        string imm = bitset<16>(stoi(tokens[needsTwoLocations[tokens[0]]])).to_string();
        assembled.push_back(imm);
    }
    return assembled;

}




void assembleFile(const string& inputFile, const string& outputFile) {
    const int maxMemorySize = 65535;
    const string nop = "0000000000000000";

    ifstream infile(inputFile);
    ofstream outfile(outputFile);
    if (!infile || !outfile) {
        throw runtime_error("Unable to open input or output file");
    }

    string line;
    int instructionCount = 0;

    while(instructionCount <= 8){
        cout<<"please enter a 16 bit string for the IM["<<instructionCount<<"]:\n";
        string im ;
        cin >> im ;
        if(im.length() != 16 ){
            throw invalid_argument("the string must conatin 16 digit");
        }
        for(auto digit: im){
            if(digit != '0' && digit != '1'){
                throw invalid_argument("the string must be binary");
            }
        }
        outfile << im << endl;
        instructionCount++;
    }

    while(instructionCount < 20){
        outfile << nop << endl;
        instructionCount++;
    }
    while (getline(infile, line)) {
        if (!line.empty()) {
            try {
                vector<string> binaryLines = assembleInstruction(line);
                for (const auto& binaryLine : binaryLines) {
                    outfile << binaryLine << endl;
                    instructionCount++;
                }
            } catch (const exception& e) {
                cerr << "Error: " << e.what() << endl;
            }
        }
    }

    for (int i = instructionCount; i < maxMemorySize; i++) {
        outfile << nop << endl;
    }
}

int main() {
    try {
        assembleFile("input.txt", "output.txt");
        cout << "Assembly completed successfully." << endl;
    } catch (const exception& e) {
        cerr << "Error: " << e.what() << endl;
    }
    return 0;
}
