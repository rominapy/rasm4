/// Programmer: Romina Pouya & Melina Pouya
// CS3B - Spring 2024
//------------------------------------------------------------------------
//
// Menu subrotuine displays the reoccuring menu for RASM4. Menu takes in address of headPtr
//    to call data_count and display the current bytes and nodes being used.
//
//  x0 must cointain the address of headPtr for data_count
//  LR must contain return address
//  ALL AAPCS registers are preserved.

	.global menu				// set starting point for menu subroutine


	.data
szData:		.asciz	"\n        Data Structure Heap Memory Comsumption: "
szByte:		.asciz	" bytes\n"
szNode:		.asciz	"        Number of Nodes: "

szOpt1:		.asciz	"<1> View all strings\n"
szOpt2:		.asciz	"<2> Add String:\n"
szOptA:		.asciz	"    <a> Keyboard\n"
szOptB:		.asciz	"    <b> from File\n"
szOpt3:		.asciz	"<3> Delete String\n"
szOpt4:		.asciz  "<4> Edit String\n"
szOpt5:		.asciz	"<5> String Search\n"
szOpt6:		.asciz	"<6> Save file\n"
szOpt7:		.asciz	"<7> Quit\n"
szPrompt:	.asciz	"Enter choice: "

dbNode:		.quad	0			// node value
szCount:	.skip	21			// string for bytes and node value
szInput:	.skip	21			// user input for option choice
chCr:		.byte	10			// New line character

	.text
menu:
	STR x19, [SP, #-16]!			// Push
	STR x20, [SP, #-16]!			// Push
	STR LR, [SP, #-16]!			// Push LR

	BL  data_count				// branch to data_count(headPtr)
	LDR x2,=dbNode				// points to dbNode
	STR x1,[x2]				// store node value into dbNode

	LDR x1,=szCount				// point to szCount
	BL  int64asc				// convert bytes into string

	LDR x0,=szData				// point to szData
	BL  putstring				// display to terminal

	LDR x0,=szCount				// point to szCount
	BL  putstring				// display to terminal

	LDR x0,=szByte				// point to szByte
	BL  putstring				// display to terminal

	LDR x0, =dbNode				// point to dbNode
	LDR x0, [x0]				// load value stored in dbNode
	LDR x1, =szCount			// point to szCount
	BL  int64asc				// convert node count to string

	LDR x0,=szNode				// point to szNode
	BL  putstring				// display to terminal

	LDR x0,=szCount				// point to szCount
	BL  putstring				// display to terminal

	LDR x0,=chCr				// point to chCr
	BL  putch				// display to terminal

	LDR x0,=szOpt1				// point to szOpt1
	BL  putstring				// display to terminal

	LDR x0,=szOpt2				// point to szOpt2
	BL  putstring				// display to terminal

	LDR x0,=szOptA				// point to szOptA
	BL  putstring				// display to terminal

	LDR x0,=szOptB				// point to szOptB
	BL  putstring				// display to terminal

	LDR x0,=szOpt3				// point to szOpt3
	BL  putstring				// display to terminal

	LDR x0,=szOpt4				// point to szOpt4
	BL  putstring				// display to terminal

	LDR x0,=szOpt5				// point to szOpt5
	BL  putstring				// display to terminal

	LDR x0,=szOpt6				// point to szOpt6
	BL  putstring				// display to terminal

	LDR x0,=szOpt7				// point to szOpt7
	BL  putstring				// display to terminal

	LDR x0,=szPrompt			// point to szPrompt
	BL  putstring				// display to terminal

	LDR x0,=szInput				// point to szInput
	MOV x1, #21				// max input is 21 characters
	BL  getstring				// cin >> choice

	LDR x0,=szInput				// point to szInput
	LDRB w1, [x0,#1]			// w1 = load second character
	LDRB w0, [x0]				// w0 = load first character


	LDR LR, [SP], #16			// POP LR
	LDR x20, [SP], #16			// POP
	LDR x21, [SP], #16			// POP

	RET					// Return
	.end
t 
