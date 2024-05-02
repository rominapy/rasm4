/// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
//------------------------------------------------------------------------
// RASM4 - data_count subroutine
//------------------------------------------------------------------------
// data_count Subroutine takes headPtr of a linked-list,
//  and calculates the number of bytes used, and number of nodes created.
//  Returns bytes to x0 and nodes to x1
//
//  x0 must contain address of headPtr
//  LR must contain return address
//
//  ALL madated AAPCS registers are preserved
//  modifies x0 and x1

	.global data_count

	.text
data_count:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x20, #0		// byte counter = 0
	MOV x21, #0		// node counter = 0

	LDR x0,[x0]		// load first node

	CMP x0, #0		// compare for 0
	BEQ end_count		// branch to zero if found

	MOV x19, x0		// copy head ptr

count:
	LDR x0, [x0]		// load string within node
	BL  String_length	// calculate string length

	ADD x20, x20, x0	// x20 = string_length
	ADD x20, x20, #1	// x21 = add for null byte
	ADD x20, x20, #16	// add for node

	ADD x21, x21, #1	// x21 = node

	LDR x0,[x19, #8]	// x0 = next node address
	CMP x0, #0		// compare for null
	MOV x19, x0		// x0 = new node
	BNE count		// brnach back to cound

end_count:
	MOV x0, x20		// x0 = bytes
	MOV x1, x21		// x1 = nodes

	LDR x30, [SP], #16	// POP LR
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP

	RET			// Return
	.end
