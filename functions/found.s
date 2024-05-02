/// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
//------------------------------------------------------------------------
// RASM4 - hits_found subroutine
// Last Modified: 4.19.2023
//------------------------------------------------------------------------
//
// hits_found takes the address to a pointer of a linked list in x0 and the substring being searched for in 
//  x1 and calculates the number of times that the substring is found.
//
// x0 must contain the address to the pointer towards the first node
// x1 must contain the null terminated substirng to search for
// LR must contain the return address
// ALL AAPCS mandated registers are preserved

	.global hits_found

	.data
szSearch:		.asciz	"\nSearch \""
szSearch2:		.asciz	"\" ("
szSearch3:		.asciz	" hits in 1 file of "
szSearch4:		.asciz	" searched)\n"

szHits:		.skip	21	// string output for hits
szTotal:	.skip	21	// string output for total searched


	.text
hits_found:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x22, [SP, #-16]!	// PUSH
	STR x23, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x19, x0		// copy head
	MOV x20, x1		// copy substring
	MOV x21, #0		// hit counter
	MOV x22, #0		// total counter

	LDR x19, [x19]		// address of first node

hits_search:
 	ADD x22, x22, #1	// total counter ++

	LDR x0, [x19]		// x0 = string within node
	MOV x1, x20		// x1 = substring
	BL  string_found	// string_found(string, substring)

	CMP w0, #-1		// compare x0 with -1 (not found)
	BNE hit_count		// branch to hit_count if not equal

	B   next		// branch to next

hit_count:
	ADD x21, x21, #1	// hit counter ++

next:
	LDR x23, [x19, #8]	// x23 = next node
	MOV x19, x23		// copy next node to x19
	CMP x19, #0x00		// compare x19 for null terminated
	BNE hits_search		// branch back to hits_search if not equal

// display results
	LDR x0,=szSearch	// point to szSearch
	BL  putstring		// display to terminal

	MOV x0, x20		// move substring address to x0
	BL  putstring		// display to terminal

	LDR x0,=szSearch2	// point to szSearch2
	BL  putstring		// display to terminal

	MOV x0, x21		// Move hit counts to x0
	LDR x1,=szHits		// point to szHits
	BL  int64asc		// convert int value to string and store

	LDR x0,=szHits		// points to szHits
	BL  putstring		// display to terminal

	LDR x0,=szSearch3	// point to szSearch3
	BL  putstring		// display to terminal

	MOV x0, x22		// Move x22 to x0 (total counts)
	LDR x1,=szTotal		// point to szTotal
	BL  int64asc		// convert int value to string and store

	LDR x0, =szTotal	// point to szTotal
	BL  putstring		// display to terminal

	LDR x0,=szSearch4	// point to szSearch4
	BL  putstring		// display to terminal

	LDR x30, [SP], #16	// POP LR
	LDR x23, [SP], #16	// POP
	LDR x22, [SP], #16	// POP
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP

	RET			// Return
	.end

