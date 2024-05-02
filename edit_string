/// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
//------------------------------------------------------------------------
// RASM4 - edit_string
//------------------------------------------------------------------------
// edit_string subroutine takes the address of the label that contains the first node of a linked-list
//  and prompts the user for the index of a string that they want to change, and the new string. It then
//  locates the string, and replaces it with the new one dynamically. Uses free to clear up the memory
//  used for the old string. (No memory is lost)
//
//  x0 must contain the address that points to the first node of a linked-list
//  LR must contain return address
//  ALL AAPCS registers are preserved itself*
//  *Free is not AAPCS compliant

	.global edit_string

	.data
szPromptEdit:	.asciz	"Select an index of a string you would like to change: "
szEditError:	.asciz	"Invalid index to edit. Please select again.\n"
szNewString:	.asciz	"Input the new string you would like to save: "
szInputEdit:	.skip	21	// index to edit
szEditBuff:	.skip	512	// keyboard input buffer


	.text
edit_string:
	STR x19, [SP, #-16]!	// PUSH
	STR x20, [SP, #-16]!	// PUSH
	STR x21, [SP, #-16]!	// PUSH
	STR x30, [SP, #-16]!	// PUSH LR


	MOV x19, x0		// copy head address
	LDR x19, [x19]		// node address

	BL  data_count		// count the number of current nodes
	MOV x20, x1		// x20 = results of counting nodes
	SUB x20, x20, #1	// subtract 1 for max usuable index (0 -> n-1)

input_edit:
	LDR x0,=szPromptEdit	// point to szPromptEdit
	BL  putstring		// display to terminal

	LDR x0,=szInputEdit	// point to szInputEdit
	MOV x1, #21		// max number of charcters is 21
	BL  getstring		// cin >> index to edit

	LDR x0,=szInputEdit	// point to szInputEdit
	BL  ascint64		// converts string to an integer value

	CMP x0, #0		// compare x0 against 0
	BLT error_edit		// Branch if less than to error_edit

	CMP x0, x20		// compare x0 and x20 (input index and max index)
	BLE search_edit		// Branch if less than to search_edit

error_edit:
	LDR x0, =szEditError	// point to szEditError
	BL  putstring		// display to terminal
	B   input_edit		// Branch back to input_edit

search_edit:
	CMP x0, #0		// compare x0 against 0
	BEQ edit_index		// Branch if equal to edit_index

	LDR x21, [x19, #8]	// x21 is next node
	MOV x19, x21		// x19 equals next node
	SUB x0, x0, #1		// index counter --
	B search_edit		// branch back to search_edit

edit_index:
	LDR x0,=szNewString	// point to szNewString
	BL  putstring		// display to terminal

	LDR x0,=szEditBuff	// point szEditBuff
	MOV x1, #512		// max input from keyboard is 512 characters
	BL  getstring		// cin >> new_string

	LDR x0,=szEditBuff	// point to szEditBuff
	BL  String_copy		// string_copy(new_string)

	LDR x1, [x19]		// load old string address to x1
	STR x0, [x19]		// store new string address from x0

	MOV x0, x1		// Mov old address to x0 for free
	BL  free		// free allocaed memory

	LDR x30, [SP], #16	// POP LR
	LDR x21, [SP], #16	// POP
	LDR x20, [SP], #16	// POP
	LDR x19, [SP], #16	// POP
	RET			// Return
	.end
