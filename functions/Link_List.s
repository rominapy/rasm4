// Programmer: Melina Pouya
// CS3B - Spring 2024
// RASM4 - linked_list

//
// linked_list subroutine takes an address to a string, headPtr and tailPtr, and
//  creates a linked-list or connects to an existing one.
//
// x0 must contain the address of a string
// x1 must contain the address of a headPtr
// x2 must contian the address of a tailPtr
// LR must contain the return address
//
//  ALL AAPCS mandated registers are preserved
//  Various registers impacted by malloc

	.global linked_list

	.text
linked_list:
	STR x19, [SP, #-16]!	// Push
	STR x20, [SP, #-16]!	// Push
	STR x21, [SP, #-16]!	// Push
	STR x30, [SP, #-16]!	// Push LR

	MOV x19, x1		// address of headPtr
	MOV x20, x2		// address of tailPtr

	BL  String_copy		// copy string

	MOV x21, x0		// copy of malloc string

	MOV x0, #16		// 16 bytes for node
	BL  malloc		// create node

	STR x21, [x0]		// store string inside of node
	MOV x3, #0		// load x3 with 0
	STR x3, [x0, #8]	// store inside 2 part of node

	LDR x1, [x19]		// load address in head
	CMP x1, #0		// compare address
	BNE link

	STR x0, [x19]		// store inside head
	STR x0, [x20]		// store inside tail
	B   finish		// branch to finish

link:
	LDR x1, [x20]		// load address store in tail
	STR x0, [x1, #8]	// store inside second half of tail node
	STR x0, [x20]		// store new tail

finish:
	LDR x30, [SP], #16	// POP LR
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP


	RET			// Return
	.end
