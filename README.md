# Pipelined-intel-core I26
This is a simple pipelined processor that serves as the project for the Computer Architecture course (CMP 3010) taught at Cairo University.

## Implemented Instructions
### ☝️ One Operand
```
NOP
HLT
SETC
NOT Rdst
INC Rdst
OUT Rdst
IN Rdst
```
### ✌️ Two Operands
```
MOV Rsrc, Rdst
ADD Rdst, Rsrc1, Rsrc2
SUB  Rdst, Rsrc1, Rsrc2
AND  Rdst, Rsrc1, Rsrc2
IADD Rdst, Rsrc2 ,Imm
```

### 💾 Memory
```
PUSH  Rdst
POP  Rdst
LDM  Rdst, Imm
LDD  Rdst, offset(Rsrc)
STD Rsrc1, offset(Rsrc2)
```

### 🦘 Jumps
```
JZ  Rdst
JN  Rdst
JC Rdst
JMP  Rdst
CALL Rdst
RET
INT index
RTI
```

## Contributors
<!-- readme: collaborators -start -->
<table>
<tr>
    <td align="center">
        <a href="https://github.com/Mina-H-William">
            <img src="https://avatars.githubusercontent.com/u/118685507?v=4" width="100;" alt="Kariiem"/>
            <br />
            <sub><b>Mina Hany William</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/eslamwageh">
            <img src="https://avatars.githubusercontent.com/u/53353517?v=4" width="100;" alt="EssamWisam"/>
            <br />
            <sub><b>Eslam Wageh</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/Ashraf-Bahy">
            <img src="https://avatars.githubusercontent.com/u/111181298?v=4" width="100;" alt="Muhammad-saad-2000"/>
            <br />
            <sub><b>Ashraf Bahy</b></sub>
        </a>
    </td>
    <td align="center">
        <a href="https://github.com/ali-bahr">
            <img src="https://avatars.githubusercontent.com/u/125573715?v=4" width="100;" alt="Ahmedmma72"/>
            <br />
            <sub><b>ALi Bahr</b></sub>
        </a>
    </td></tr>
</table>
<!-- readme: collaborators -end -->


### For the design and more info about the architectural desicions we took, check <a href="https://bit.ly/3JFTedJ">this</a> along with the attached PDFs (Design Folder).
