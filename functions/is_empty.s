/// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
//------------------------------------------------------------------------

// This function checks if a list is empty

// Pre-conditions:
// X0	- Contains head of list

// Post-conditions:
// X0	- Contains a 1 or 0 for boolean evaluation
// X1	- Contains head of list

// All registers are preserved except X1

	.text
	.global is_empty

is_empty:
// Store registers we will be using
	STR		X19, [SP, #-16]!	// Push X19

// Compare head to NULL
	LDR	X19, [X0]		// Dereference to get the first element
	CMP	X19, 0x00		// Check if head points to NULL
	MOV	X1, X0			// Copy head to X1
	BEQ	empty_list		// Branch to empty_list if head points to NULL
	MOV	X0, #1			// X0 = 1 if list is not empty
	B	done			// Branch to done

empty_list:
	MOV	X0, #0			// X0 = 0 if list is empty

done:
	LDR		X19, [SP], #16		// Pop X19
	RET
