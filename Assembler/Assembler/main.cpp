#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <map>
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
	temp,
	temp2,
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

int extractX(string s);

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

string extractOpName(string str);

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
	if (s.empty()) {
		cout << "No instruction error!" << endl;
		return bitset<16>("1111111111111111");
	}
	
	bitset<16> IR = bitset<16>("1111111111111111");

	//does the instruction has label or not
	bool hasLabel = isLabel(s);

	//if it has label, delete the label from the instruction
	if (hasLabel) {
		while (s[0] != ' ' && s[0] != '\t') s.erase(0, 1);
		removeSpaces(s);
		if (s[0] == ';') return bitset<16>("1111111111111111");
	}

	//cut first 4 characters of the instruction, in case it's XNOR
	string opName = extractOpName(s);

	if (isNoOperand(opName)) {
		bitset<4> operation = getOperationOpCode(opName, 0);
		string tempIR = "11110o0000000000";
		tempIR[5] = '0' + operation[0];
		IR = bitset<16>(tempIR);
	}

	else if (isOneOperand(opName)) {
		bitset<4> operation = getOperationOpCode(opName, 1);
		string tempIR = "1110111100111111";
		tempIR[4] = '0' + operation[3];
		tempIR[5] = '0' + operation[2];
		tempIR[6] = '0' + operation[1];
		tempIR[7] = '0' + operation[0];

		bitset<3> destMode = getMode(s, 1, 1);

		tempIR[10] = '0' + destMode[2];
		tempIR[11] = '0' + destMode[1];
		tempIR[12] = '0' + destMode[0];

		bitset<3> regNum = getRegisterNum(s, 1, 1);

		tempIR[13] = '0' + regNum[2];
		tempIR[14] = '0' + regNum[1];
		tempIR[15] = '0' + regNum[0];

		IR = bitset<16>(tempIR);
	}

	else if (isTwoOperand(s)) {
		bitset<4> operation = getOperationOpCode(opName, 2);
		string tempIR = "1111111111111111";
		tempIR[0] = '0' + operation[3];
		tempIR[1] = '0' + operation[2];
		tempIR[2] = '0' + operation[1];
		tempIR[3] = '0' + operation[0];

		bitset<3> srcMode = getMode(s, 2, 2);
		bitset<3> destMode = getMode(s, 2, 1);

		tempIR[4] = '0' + srcMode[2];
		tempIR[5] = '0' + srcMode[1];
		tempIR[6] = '0' + srcMode[0];

		tempIR[10] = '0' + destMode[2];
		tempIR[11] = '0' + destMode[1];
		tempIR[12] = '0' + destMode[0];

		bitset<3> destRegNum = getRegisterNum(s, 2, 1);
		bitset<3> srcRegNum = getRegisterNum(s, 2, 2);

		tempIR[7] = '0' + srcRegNum[2];
		tempIR[8] = '0' + srcRegNum[1];
		tempIR[9] = '0' + srcRegNum[0];

		tempIR[13] = '0' + destRegNum[2];
		tempIR[14] = '0' + destRegNum[1];
		tempIR[15] = '0' + destRegNum[0];

		IR = bitset<16>(tempIR);
	}

	else if (isBranching(opName)) {
		bitset<4> operation = getOperationOpCode(opName, 3);
		while (s[0] != ' ' && s[0] != '\t') s.erase(0, 1);
		removeSpaces(s);
		bitset<16> offset = extractOffset(s);

		IR = offset;
		if (IR == bitset<16>("1111111111111111")) return IR;
		IR.set(15);
		IR.set(14);
		IR.reset(13);
		IR[12] = operation[2];
		IR[11] = operation[1];
		IR[10] = operation[0];
	}

	else if (isBonus(opName)) {
		bitset<4> operation = getOperationOpCode(opName, 4);
		string tempIR = "11111oo000000000";
		tempIR[5] = '0' + operation[1];
		tempIR[6] = '0' + operation[0];

		IR = bitset<16>(tempIR);
	}

	else
		cout << "Error! Invalid instruction name" << endl;

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
	if (!inFile.is_open())
		cout << "Error reading input file" << endl;

	string line;
	//not sure if this method would store empty lines or not, try and error later
	while (getline(inFile, line)) {
		//remove any initial spaces or tabs
		removeSpaces(line);
		if (line[0] == ';' || line == "") continue;
		//convert it upper case just in case anything is written in lower case
		convertUpperCase(line);
		//save in program vector
		program.PB(line);
	}

	storeLabelsOffsets();
	bitset<16> IR;

	ofstream outFile("IR codes.txt");

	for (auto line : program) {
		//if the line has value of X only
		if (!isalpha(line[0])) {
			int X = extractX(line);
			outFile << X << endl;
			continue;
		}
		IR = assembler(line);
		if (IR == bitset<16>("1111111111111111")) continue;
		outFile << IR << endl;
	}

	outFile.close();

	return 0;
}


//===================================================
//=================Helpful functions=================
//===================================================

void storeLabelsOffsets() {
	int instructionsCount = program.size();
	rep(i, 0, instructionsCount) {
		string line = program[i];
		if (isLabel(line)) {
			string label = getLabel(line);
			labels[label] = i;
		}
	}
}

string getLabel(string s) {
	string label = "";
	while (!s.empty() && s[0] != ':') label += s[0], s.erase(0, 1);
	return label;
}

int extractX(string s) {
	string temp = "";
	while (!s.empty() && s[0] != ' ' && s[0] != '\t')
		temp += s[0], s.erase(0, 1);
	return stoi(temp);
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
			cout << "Error! This is not a 0-operand operation in PDP-11" << endl;
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
			cout << "Error! This is not a 1-operand operation in PDP-11" << endl;
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
			cout << "Error! This is not a 2-operand operation in PDP-11" << endl;
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
			cout << "Error! This is not a branching operation in PDP-11" << endl;
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
			cout << "Error! This is not a JSR, RTS, INT or IRET operation in PDP-11" << endl;
	}

	else {
		cout << "Invalid value of i, it should be from {0, 1, 2, 3, 4}" << endl;
	}

	return opCode;
}

//return 111111<offset>
bitset<16> extractOffset(string str) {
	string label = getLabel(str);

	if (labels.find(label) == labels.end()) {
		cout << "Error! Label not found" << endl;
		return bitset<16>("1111111111111111");
	}
		

	bitset<16> offset = labels[label];
	offset[15] = 1;
	offset[14] = 1;
	offset[13] = 1;
	offset[12] = 1;
	offset[11] = 1;
	offset[10] = 1;
	return offset;
}

string extractOpName(string str) {
	string op = "";
	while (!str.empty() && str[0] != ' ' && str[0] != '\t')
		op += str[0], str.erase(0, 1);
	return op;
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
		cout << "Error! Can't decide which mode" << endl;

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
		cout << "Error! Can't decide which number" << endl;

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
	return str.find_first_of(',') != string::npos;
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
	if (instr[0] != ' ' && instr[0] != '\t' ) return;
	while (instr[0] == ' ' || instr[0] == '\t') {
		instr.erase(0, 1);
	}
}
