// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
// RASM4 - clear memory subroutine
//---------------------------------------------------------------------------
// clar_memory subroutine takes point to start of a link list, traverses it,
//    and free's up all dynamic memory
//---------------------------------------------------------------------------
//  x0 must contain address of pointer
//  LR must contain return address
//  subroutine preserves Mandated AAPCS registers
//  Free impacts various registers
//---------------------------------------------------------------------------
	.global clear_memory		// sets starting point for subroutine

	.text
clear_memory:
	STR x19, [SP, #-16]!		// Push
	STR x20, [SP, #-16]!		// Push
	STR x21, [SP, #-16]!		// Push
	STR x30, [SP, #-16]!		// Push


	MOV x19, x0			// copy headPtr
	LDR x19, [x19]			// loads addresss stored

cleanup:
	LDR x21, [x19]			// x21 = string address
	LDR x20, [x19, #8]		// x20 = next node address

	MOV x0, x21			// move string address
	BL  free			// free allocated memory

	MOV x0, x19			// move node address
	BL  free			// free allocated memory

	MOV x19, x20			// x19 = next node
	CMP x19, #0x00			// CMP for null terminated
	BNE cleanup			// branch back if not found

	LDR x30, [SP], #16		// POP LR
	LDR x21, [SP], #16		// POP
	LDR x20, [SP], #16		// POP
	LDR x19, [SP], #16		// POP

	RET				// Return
	.end
