// Programmer: Melina Pouya
// CS3B - Spring 2024
// RASM 4 - delete_string

// delete_string subrotuine takes the pointer to the label that contains the first node of a linked listt.
//   the routine will then prompt user for index to delete, check for existence, and delete the indicated
//   index.
//
//  x0 must contain the address to the label that contains the first node
//  LR must contain the return address
//  Routine preserves all mandated AAPCS registers
//  free impacts various registers.

	.global delete_string

	.data

szPromptDel:	.asciz	"Choose a index to remove: "
szDelError:	.asciz	"Invalid index to delete, please select again:.\n"
szInputDel:	.skip	21

	.text
delete_string:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x22, [SP, #-16]!	// PUSH
	STR x23, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR

	MOV x19, x0		// copy head
	LDR x21, [x19]		// load node to x21
	BL  data_count		// check for number of nodes

	MOV x20, x1		// store nodes
	SUB x20, x20, #1	// index available is one less than number of nodes (0 index)

Input_delete:
	LDR x0,=szPromptDel	// point to szPromptDel
	BL  putstring		// displays to terminal

	LDR x0,=szInputDel	// points to szInputDel
	MOV x1, #21		// max number of characters for input is 21
	BL  getstring		// cin >> index to delete

	LDR x0,=szInputDel	// point szInputDel
	BL  ascint64		// converts value in string to an int in x0

	CMP x0, #0		// compare x0 and 0
	BLT error		// branch if less than to error

	CMP x0, #0		// compare x0 and 0
	BEQ delete_first_node	// branch to delete_first_node if equals

	CMP x0, x20		// compare x0 and x20 (selected and max index)
	BLE search_delete	// branch to search_delete if less than

error:
	LDR x0,=szDelError	// point to szDelError
	BL  putstring		// Display to terminal
	B   Input_delete	// brnach back to Input_delete

// x21 equals current node, x22 equals next node, x23 equals previous node
search_delete:
	CMP x0, #0		// compare x0 against 0 (index counter)
	BEQ delete_index	// Branch if equal to delete_index

	MOV x23, x21		// copy current to previous
	LDR x22, [x21, #8]	// x22 = next node
	MOV x21, x22		// current = next
	LDR x22, [x21, #8]	// x22 = next->next node
	SUB x0, x0, #1		// index counter --

	B  search_delete	// branch back to search_delete

delete_index:
	STR x22, [x23, #8]	// store next node address in previous node tail

	LDR x0, [x21]		// point to string within current node
	BL  free		// free allocated memory

	MOV x0, x21		// points to node to be deleted
	BL  free		// free allocated memory

	B  delete_end		// branch to delete_end

delete_first_node:
	LDR x22, [x21, #8]	// x22 = next node
	STR x22, [x19]		// store next node into head (will be new first node)

	LDR x0, [x21]		// point to string inside of current node
	BL  free		// free allocated memory

	MOV x0, x21		// point to node
	BL  free		// free allocated memory

	B   delete_end		// brnach to delete end

// free data and assign head = 0
only_node:
	LDR x0, [x21]		// point to string inside node
	BL  free		// free allocated memory

	MOV x0, x21		// point to node
	BL  free		// free node

	MOV x0, #0		// x0 = 0
	STR x0, [x19]		// store 0 inside head (empty)

delete_end:
	LDR x30, [SP], #16	// POP LR
	LDR x23, [SP], #16	// POP
	LDR x22, [SP], #16	// POP
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP
	RET
