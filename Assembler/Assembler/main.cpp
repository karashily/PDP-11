#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <map>
#include <vector>
#include <cassert>
#include <bitset>
using namespace std;

#define rep(i, a, b) for(int i = a; i<b; i++)
#define all(v) v.begin(), v.end()
#define PB push_back

map<string, int> labels;
vector<string> program;

//===================================================
//--------Enum's with OpCodes of instructions--------
//===================================================

enum JMPOp {
	JSR,
	RTS,
	INT,
	IRET
};

enum BrOp {
	BR,
	BEQ,
	BNE,
	BLO,
	BLS,
	BHI,
	BHS
};

enum TwoOp {
	MOV,
	ADD,
	ADC,
	SUB,
	SBC,
	AND,
	OR,
	XNOR,
	CMP
};

enum OneOp {
	INC,
	DEC,
	CLR,
	INV,
	LSR,
	ROR,
	RRC,
	ASR,
	LSL,
	ROL,
	RLC

};

enum NoOp {
	HLT,
	NOP
};

//===================================================
//===============Functions Declaration===============
//===================================================

void storeLabelsOffsets();

string getLabel(string s);

void convertUpperCase(string & str);

//Inputs to the function
//	string str: instruction
//	int i:	0 ==> No operand	(1 bit)
//			1 ==> 1 operand		(4 bits)
//			2 ==> 2 operand		(4 bits)
//			3 ==> Branching		(3 bits)
//			4 ==> Bonus op.s	(2 bits)
bitset<4> getOperationOpCode(string op, int i);

//return 111111<offset>
bitset<16> extractOffset(string str);

// i = 1 ==> 1-operand
// i = 2 ==> 2-operand
// j = 1 ==> dest
// j = 2 ==> src
bitset<3> getMode(string instr, int i, int j);

// i = 1 ==> 1-operand
// i = 2 ==> 2-operand
// j = 1 ==> dest
// j = 2 ==> src
bitset<3> getRegisterNum(string instr, int i, int j);

bool isLabel(string str);

bool isNoOperand(string  str);

bool isOneOperand(string  str);

bool isTwoOperand(string  str);

bool isBranching(string  str);

bool isBonus(string  str);

void removeSpaces(string & instr);

//===================================================
//=====================ASSEMBLER=====================
//===================================================

bitset<16> assembler(string s) {
	if (!s.empty()) {
		assert("No instruction error!");
		return bitset<16>(0);
	}
	
	bitset<16> IR;

	//convert it upper case just in case anything is written in lower case
	convertUpperCase(s);

	//does the instruction has label or not
	bool hasLabel = isLabel(s);

	//if it has label, delete the label from the instruction
	if (hasLabel) {
		while (s[0] != ' ') s.erase(0, 1);
		removeSpaces(s);
	}

	//cut first 4 characters of the instruction, in case it's XNOR
	string opName = s;
	opName.erase(opName.begin() + 4, opName.end());

	//if not XNOR, remove the space
	if (opName[3] == ' ') opName.erase(3, 1);

	//if it's BR or OR
	if (opName[2] == ' ') opName.erase(2, 1);

	if (isNoOperand(s)) {
		bitset<4> operation = getOperationOpCode(opName, 0);
		string tempIR = "11110o1111111111";
		tempIR[6] = operation[0];
		IR = bitset<16>(tempIR);
	}

	else if (isOneOperand(s)) {
		bitset<4> operation = getOperationOpCode(opName, 1);
		string tempIR = "1110111111111111";
		tempIR[11] = operation[3];
		tempIR[10] = operation[2];
		tempIR[9] = operation[1];
		tempIR[8] = operation[0];

		bitset<3> destMode = getMode(s, 1, 1);

		tempIR[7] = destMode[2];
		tempIR[6] = destMode[1];
		tempIR[5] = destMode[0];

		bitset<3> regNum = getRegisterNum(s, 1, 1);

		tempIR[4] = regNum[2];
		tempIR[3] = regNum[1];
		tempIR[2] = regNum[0];

		IR = bitset<16>(tempIR);
	}

	else if (isTwoOperand(s)) {
		bitset<4> operation = getOperationOpCode(opName, 2);
		string tempIR = "1111111111111111";
		tempIR[15] = operation[3];
		tempIR[14] = operation[2];
		tempIR[13] = operation[1];
		tempIR[12] = operation[0];

		bitset<3> srcMode = getMode(s, 2, 2);
		bitset<3> destMode = getMode(s, 2, 1);

		tempIR[11] = srcMode[2];
		tempIR[10] = srcMode[1];
		tempIR[9] = srcMode[0];

		tempIR[5] = destMode[2];
		tempIR[4] = destMode[1];
		tempIR[3] = destMode[0];

		bitset<3> destRegNum = getRegisterNum(s, 2, 1);
		bitset<3> srcRegNum = getRegisterNum(s, 2, 2);

		tempIR[8] = srcRegNum[2];
		tempIR[7] = srcRegNum[1];
		tempIR[6] = srcRegNum[0];

		tempIR[2] = destRegNum[2];
		tempIR[1] = destRegNum[1];
		tempIR[0] = destRegNum[0];

		IR = bitset<16>(tempIR);
	}

	else if (isBranching(s)) {
		bitset<4> operation = getOperationOpCode(opName, 3);
		bitset<16> offset = extractOffset(s);

		if (find(all(labels), offset) == labels.end())
			assert("Error! Offset/Label not found in program");

		IR = offset;
		IR.set(15);
		IR.set(14);
		IR.reset(13);
		IR[12] = operation[2];
		IR[11] = operation[1];
		IR[10] = operation[0];
	}

	else if (isBonus(s)) {
		bitset<4> operation = getOperationOpCode(opName, 4);
		string tempIR = "11111oo111111111";
		tempIR[10] = operation[1];
		tempIR[9] = operation[0];

		IR = bitset<16>(tempIR);
	}

	else
		assert("Error! Invalid instruction name");

	return IR;
}

//===================================================
//=======================MAIN========================
//===================================================

int main() {
	ios_base::sync_with_stdio(0);
	cin.tie(NULL), cout.tie(NULL);

	string inFileName;
	cout << "Please enter name of PDP-11 code file: ";
	cin >> inFileName;

	ifstream inFile(inFileName);
	if (!inFile)
		assert("Error reading input file");

	string line;
	//not sure if this method would store empty lines or not, try and error later
	while (getline(inFile, line)) {
		removeSpaces(line);
		if (line[0] == ';') continue;
		program.PB(line);
	}

	storeLabelsOffsets();
	bitset<16> IR;

	ofstream outFile("IR codes.txt");

	for (auto line : program) {
		IR = assembler(line);
		outFile << IR << endl;
	}

	outFile.close();

	system("pause");
	return 0;
}


//===================================================
//=================Helpful functions=================
//===================================================

void storeLabelsOffsets() {
	int instructionsCount = program.size();
	rep(i, 0, instructionsCount) {
		string line = program[i];
		removeSpaces(line);
		if (isLabel(line)) {
			string label = getLabel(line);
			labels[label] = i;
		}
	}
}

string getLabel(string s) {
	if (!isLabel(s)) return "";
	string label = "";
	int i = 0;
	while (s[i] != ':')
		label += s[i++];
	return label;
}

void convertUpperCase(string & str) {
	int sz = str.size();
	rep(i, 0, sz) {
		if (isalpha(str[i]))
			str[i] = toupper(str[i]);
	}
}

//Inputs to the function
//	string str: instruction
//	int i:	0 ==> No operand	(1 bit)
//			1 ==> 1 operand		(4 bits)
//			2 ==> 2 operand		(4 bits)
//			3 ==> Branching		(3 bits)
//			4 ==> Bonus op.s	(2 bits)
bitset<4> getOperationOpCode(string op, int i) {
	bitset<4> opCode;

	//if no-operand
	if (i == 0) {
		if (op == "HLT")
			opCode = HLT;
		else if (op == "NOP")
			opCode = NOP;
		else
			assert("Error! This is not a 0-operand operation in PDP-11");
	}

	//if one-operand
	else if (i == 1) {
		if (op == "INC")
			opCode = INC;
		else if (op == "DEC")
			opCode = DEC;
		else if (op == "CLR")
			opCode = CLR;
		else if (op == "INV")
			opCode = INV;
		else if (op == "LSR")
			opCode = LSR;
		else if (op == "ROR")
			opCode = ROR;
		else if (op == "RRC")
			opCode = RRC;
		else if (op == "ASR")
			opCode = ASR;
		else if (op == "LSL")
			opCode = LSL;
		else if (op == "ROL")
			opCode = ROL;
		else if (op == "RLC")
			opCode = RLC;
		else
			assert("Error! This is not a 1-operand operation in PDP-11");
	}

	//if two-operand
	else if (i == 2) {
		if (op == "MOV")
			opCode = MOV;
		else if (op == "ADD")
			opCode = ADD;
		else if (op == "ADC")
			opCode = ADC;
		else if (op == "SUB")
			opCode = SUB;
		else if (op == "SBC")
			opCode = SBC;
		else if (op == "AND")
			opCode = AND;
		else if (op == "OR")
			opCode = OR;
		else if (op == "XNOR")
			opCode = XNOR;
		else if (op == "CMP")
			opCode = CMP;
		else
			assert("Error! This is not a 2-operand operation in PDP-11");
	}

	//if branching
	else if (i == 3) {
		if (op == "BR")
			opCode = BR;
		else if (op == "BEQ")
			opCode = BEQ;
		else if (op == "BNE")
			opCode = BNE;
		else if (op == "BLO")
			opCode = BLO;
		else if (op == "BLS")
			opCode = BLS;
		else if (op == "BHI")
			opCode = BHI;
		else if (op == "BHS")
			opCode = BHS;
		else
			assert("Error! This is not a branching operation in PDP-11");
	}

	//if bonus
	else if (i == 4) {
		if (op == "JSR")
			opCode = JSR;
		else if (op == "RTS")
			opCode = RTS;
		else if (op == "INT")
			opCode = INT;
		else if (op == "IRET")
			opCode = IRET;
		else
			assert("Error! This is not a JSR, RTS, INT or IRET operation in PDP-11");
	}

	else {
		assert("Invalid value of i, it should be from {0, 1, 2, 3, 4}");
	}

	return opCode;
}

//return 111111<offset>
bitset<16> extractOffset(string str) {
	string label = getLabel(str);

	if (labels.find(label) == labels.end())
		assert("Error! Label not found");

	bitset<16> offset = labels[label];
	offset[15] = 1;
	offset[14] = 1;
	offset[13] = 1;
	offset[12] = 1;
	offset[11] = 1;
	offset[10] = 1;
	return offset;
}

// i = 1 ==> 1-operand
// i = 2 ==> 2-operand
// j = 1 ==> dest
// j = 2 ==> src
bitset<3> getMode(string instr, int i, int j) {
	//Remove operation
	while (instr[0] != ' ') instr.erase(0, 1);
	removeSpaces(instr);
	bitset<3> mode;

	//if I'm in 2-operand mode, but I'm getting destination
	if (i == 2 && j == 1) {
		//remove src
		while (instr[0] != ' ') instr.erase(0, 1);
		removeSpaces(instr);
	}

	if (instr[0] == 'R')
		mode = 0;
	else if (instr[0] == '(')
		mode = 2;
	else if (instr[0] == '-')
		mode = 4;
	else if (instr[0] == 'X')
		mode = 6;
	else if (instr[0] == '@') {
		if (instr[1] == 'R')
			mode = 1;
		else if (instr[1] == '(')
			mode = 3;
		else if (instr[1] == '-')
			mode = 5;
		else if (instr[1] == 'X')
			mode = 7;
	}
	else
		assert("Error! Can't decide which mode");

	return mode;
}

// i = 1 ==> 1-operand
// i = 2 ==> 2-operand
// j = 1 ==> dest
// j = 2 ==> src
bitset<3> getRegisterNum(string instr, int i, int j) {
	//Remove operation
	while (instr[0] != ' ') instr.erase(0, 1);
	removeSpaces(instr);
	bitset<3> num;

	//if I'm in 2-operand mode, but I'm getting destination
	if (i == 2 && j == 1) {
		//remove src
		while (instr[0] != ' ') instr.erase(0, 1);
		removeSpaces(instr);
	}

	if (instr[0] == 'R')
		num = instr[1] - 48;
	else if (instr[0] == '(')
		num = instr[2] - 48;
	else if (instr[0] == '-' || instr[0] == 'X')
		num = instr[3] - 48;
	else if (instr[0] == '@') {
		if (instr[1] == 'R')
			num = instr[2] - 48;
		else if (instr[1] == '(')
			num = instr[3] - 48;
		else if (instr[1] == '-' || instr[1] == 'X')
			num = instr[4] - 48;
	}
	else
		assert("Error! Can't decide which number");

	return num;
}

bool isLabel(string str) {
	for (auto ch : str) {
		if (ch == ':')
			return true;
	}
	return false;
}

bool isNoOperand(string  str) {
	return str == "HLT" ||
		str == "NOP";
}

bool isOneOperand(string  str) {
	return str == "INC" ||
		str == "DEC" ||
		str == "CLR" ||
		str == "INV" ||
		str == "LSR" ||
		str == "ROR" ||
		str == "RRC" ||
		str == "ASR" ||
		str == "LSL" ||
		str == "ROL" ||
		str == "RLC";
}

bool isTwoOperand(string  str) {
	size_t pos = str.find_first_of(',');
	return pos != string::npos;
}

bool isBranching(string  str) {
	return str == "BR" ||
		str == "BEQ" ||
		str == "BNE" ||
		str == "BLO" ||
		str == "BLS" ||
		str == "BHI" ||
		str == "BHS";
}

bool isBonus(string  str) {
	return str == "JSR" ||
		str == "RTS" ||
		str == "INT" ||
		str == "IRET";
}

void removeSpaces(string &instr) {
	if (instr[0] != ' ') return;
	while (instr[0] == ' ') {
		instr.erase(0, 1);
	}
}
