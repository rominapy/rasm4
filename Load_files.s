// Programmer: Melina Pouya & rOmina POuya
// CS3B - Spring 2024
// RASM4 - load_file
//
// load_file subroutine takes the headPtr and tailPtr, and loads a predetermined file,
//  loading each line of text into the linked-list.
//
// x0 must contain the address of headPtr
// x1 must contain the address of tailPtr
// LR must contain the return address
// Must have designated file in local directory. Returns error message if not found.
//
// All AAPCS registers are preserved.

	.global	load_file			// sets starting point of subrotuine

	.data
szPromptIF:	.asciz	"\nEnter file to load data from: "
szInError:	.asciz	"File Not Found\n"
szReading:	.asciz	"Reading from file...\n"
szInFile:	.skip	512			// input buffer for file

	.text
load_file:
	STR x19, [SP, #-16]!			// Push
	STR x20, [SP, #-16]!			// Push
	STR x21, [SP, #-16]!			// Push
	STR x30, [SP, #-16]!			// PUSH LR

	MOV x19, x0				// copy headPtr
	MOV x20, x1				// copy tailPtr

	LDR x0,=szPromptIF			// point to szPromptIF
	BL  putstring				// display to terminal

	LDR x0,=szInFile			// point to szInFile
	MOV x1, #512				// max character input is 512
	BL  getstring				// cin >> InFile

	MOV x0, #-100				// local file directory
	LDR x1, =szInFile			// points to szInFile
	MOV x2, #00				// x2 = read
	MOV x3, #0600				// permissions
	MOV x8, #56				// Service Code 56 for OpenAt
	SVC 0					// Call Linux to open file

	CMP x0, #0				// compare against 0
	BLT inFail				// branch to inFail if less than zero

	MOV x21, x0				// iFD stored
	LDR x0,=szReading			// point to szreading
	BL  putstring				// display to terminal
read:
	MOV x0, x21				// x0 = iFD

	LDR x1,=szInFile			// points to szInFile
	BL  getline				// Branch to getline()

	CMP x0, #0				// compare x0 for 0
	BEQ close_inFile			// branch to close_inFile if equal

	LDR x0,=szInFile			// point to szInFile
	MOV x1, x19				// x1 = headPtr
	MOV x2, x20				// x2 = tailPtr
	BL   linked_list			// Branch to linked_list

	B   read				// Branch back to read

close_inFile:
	MOV x0, x21				// x0 = iFD
	MOV x8, #57				// Service Code 57 for close
	SVC 0					// call Linux to close file

	B   end_inFile				// Branch to end_inFile

inFail:
	LDR x0,=szInError			// point to szInError
	BL  putstring				// display to terminal

end_inFile:
	LDR x30, [SP], #16			// POP LR
	LDR x21, [SP], #16			// POP
	LDR x20, [SP], #16			// POP
	LDR x19, [SP], #16			// POP

	RET					// Return


// getline subroutine for load_file
getline:
	STR x19, [SP, #-16]!			// Push
	STR x30, [SP, #-16]!			// Push LR

line:
	BL  getchar				// branch to getchar()

	CMP x0, #0				// compare x0 for 0
	BEQ eof					// Branch to eof if equal

	LDRB w2, [x1]				// w2 = char
	CMP  w2, #0xa				// compare for \n
	BEQ  endline				// Branch to endline if equal

	ADD x1, x1, #1				// x1 = szInLine address + 1
	MOV x0, x21				// x0 = iFD
	B   line				// Branch back to line

endline:
	ADD  x1, x1, #1				// x1 = szInLine address + 1
	MOV  w2, #0				// w2 = 0x00
	STRB w2, [x1]				// store to end of szInLine

eof:
	LDR x30, [SP], #16			// POP LR
	LDR x19, [SP], #16			// POP
	RET					// Return to load_file

// getchar subroutine for getline
getchar:
	MOV x2, #1				// x2 = 1 byte
	MOV x8, #63				// Service Code 63 for read
	SVC 0					// Call Linux to read file
	RET					// Return to getline

	.end

