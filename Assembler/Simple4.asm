MOV R0, @R1
ADD @-(R1), (R3)+
SUB -(R1), 2(R0)
CMP @R1, @(R0)+
INV @3(R0)
HLT