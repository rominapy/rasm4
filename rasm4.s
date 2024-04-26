  
.global _start // Provides program starting address
	
	.equ O_RDONLY, 0	// Read only code
	.equ O_WRONLY, 1	// Write only code
	.equ O_CREAT,  0100	// Create, read & write code
	.equ C_W,	   0101 // Create, write code
	.equ A_RW,	  02002 // Append read and write
	.equ S_RDWR,   0660 // chmod permissions
	.equ S_RW,   0600	// chmod permissions
	.equ AT_FDCWD, -100	// local directory (file descriptor)
	.equ NR_openat, 56  // Openat code
	.equ NR_close,	57	// close code
	.equ NR_write,	64	// writing code
	.equ NR_read,	63	// writing code
	.equ NR_exit,	93	// exit code
	.equ MAX_BYTES, 512	// Input maximum bytes
	.data 		// Data section

//Strings for output format
szHeader:		  .asciz "Names:Romina Pouya& Melina Pouya\nProgram: rasm4.asm\nClass: CS 3B\nDate: 05/02/2024\n"
szOutfile:		  .asciz "output.txt"
szInfile:		  .asciz "input.txt"
szTitle:		  .asciz "\nRASM4 TEXT EDITOR\n"
szMem:	      	  .asciz "Data Structure Memory Consumption: "
szBytes:		  .asciz " bytes\n"
szNumnodes:		  .asciz "\nNumber of Nodes: "
szEnterstr:	 	  .asciz "\nEnter string: "
szEnterline:	  .asciz "\nEnter line number: "
szInvalidIn:	  .asciz "Invalid index, not in range\n"
szInvalidIn2:	  .asciz "Invalid input\n"
szEnd:			  .asciz "Thank you for using our program!\n"
szEmpty:		  .asciz "\nList is empty!\n"
szEndl:			  .asciz "\n"
szEndfree:		  .asciz "\nThe Linked-List has been freed\n\n"
szList:			  .asciz "\nAll values in Linked List:\n "
szLeftB:		  .asciz "["
szRightB:		  .asciz "] "
szEOF:			  .asciz "Reached the End of File\n"
szERROR:		  .asciz "FILE READ ERROR\n"
szSaveError: 	  .asciz "File could not be saved.\n"
szSaveSuccess:	  .asciz "File saved successfully.\n"
szGetFileName:	  .asciz "Please enter file name: "
szDeleteSuccess:  .asciz "Index deleted successfully.\n"

szTemp:			.skip 512	// Temporary storage for output
headPtr:		.quad 0		// headPtr
tailPtr:		.quad 0 	// tailPtr
dbLength:		.quad 0		// storage for strlength
dbIndex:		.quad 0		// index count
iBytecount:		.quad 0		// Bytes space for memory usage
iNodecount:		.quad 0     // Number of nodes space
chCr:			.byte 10	// char endline
chNull:			.byte 0		// char null(\n)
iFD:			.byte 0		// byte to store file director

	.text
_start: 
// ========================== Class Header ========================== //
	ldr x0,=szHeader  // Loads x0 with szHeaders address.
	bl putstring 	  // Call putstring to print header.
	ldr x0, =chCr			// loads address of chEndl into x0
	bl  putch				// branch and link function putch
	
// ========================== Main loop ========================== //
mainLoop:
	// Menu title
	ldr x0,=szTitle		// load x0 with szTitles address
	bl putstring		// Output title.
	
	// Output memory consumption
	ldr x0,=szMem		// load x0 with szMems address
	bl putstring		// call putstring
	
	// convert and output iBytecount
	ldr x0,=iBytecount	// Load x0 with Bytecounts address
	ldrh w0,[x0]		// load count into w0
	ldr x1,=szTemp		// Load x1 with szTemps address
	bl int64asc			// call int64asc
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl putstring		// call putstring
	
	// Output number of nodes
	ldr x0,=szNumnodes	// load x0 with szNumnodes address
	bl putstring		// call putstring
	
	ldr x0,=iNodecount	// Load x0 with Nodecounts address
	ldrh w0,[x0]		// load count into w0
	ldr x1,=szTemp		// Load x1 with szTemps address
	bl int64asc			// call int64asc
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl putstring		// call putstring
	
	// Prompt user with menu and receive input
	bl menuinput		// branch to menu
	
	//switch input
	cmp w0,#'1'			// Compare returned value with 1
	beq	printAll		// Branch to print all strings
	
	cmp w0,#'a'			// Compare returned value with a
	beq inKbd			// Branch to input from keyboard	
	cmp w0,#'A'			// Compare returned value with A
	beq inKbd			// Branch to input from keyboard
	
	cmp w0,#'b'			// Compare returned value with b
	beq inFile			// Branch to input from file
	cmp w0,#'B'			// Compare returned value with B
	beq inFile			// Branch to input from file
	
	cmp w0,#'3'			// Compare returned value with 3
	beq delStr			// Branch to delete a string
	
	cmp w0,#'4'			// Compare returned value with 4
	beq editStr		    // Branch to edit a string
	
	cmp w0,#'5'			// Compare returned value with 5
	beq searchStr		// Branch to search for a string
	
	cmp w0,#'6'			// Compare returned value with 6
	beq saveFile		// Branch to save file
	
	cmp w0,#'7'			// Compare returned value with B
	beq endProgram		// Branch to input from file

// ========================== printAll ========================== //
printAll:
	ldr x1,=iNodecount  // load x1 with Node count pointer
	ldr x1,[x1]			// Load value inside Inodecount into x1
	cmp x1,#0			// Compare nodecount with 0
	beq	emptyList		// branch to empty list if nodecount == 0
	
	ldr x0,=headPtr		// Load x0 with HeadPtrs address
	ldr x1,=iNodecount	// load x1 with Node count pointer
	ldr x1,[x1]			// Load value inside Inodecount into x1
	bl printList		// Branch and link to printlist
	
	ldr x0, =chCr			// loads address of chEndl into x0
	bl  putch				// branch and link function putch
	
	b mainLoop			// Branch back to beginning of progrma

emptyList:
	ldr x0,=szEmpty		// Load x0 with szEmptys address
	bl putstring		// call putstring
	
	b mainLoop			// Branch back to mainLoop to continue program

// ========================== inKeyboard ========================== //
inKbd:
	//Input from Keyboard
	ldr x0,=szEnterstr	// Load x0 with szEnterstrs address
	bl putstring		// branch to putstring
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	mov x1,MAX_BYTES	// Move into x1 MAX_BYTES constant
	bl getstring
	
	ldr x0,=iNodecount	// Load x0 with Nodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq first			// Branch to addFirst if its the Firstnode in the list
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl String_length	// Branch to string length
	add x0,x0,#1		// Add an extra byte for null
	bl addTail			// Otherwise branch to addTail
	
	b mainLoop			// Branch back to beginning of program

first:
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl String_length	// Branch to string length
	add x0,x0,#1		// Add an extra byte for null
	
	bl addFirst			// Branch and link to add first
	b mainLoop			// Branch back to beginning of program
	
// ========================== inFile ========================== //
inFile:
	//Open the FILE
	// Open output.txt for writing
	mov x0, #AT_FDCWD // mov into x0 local directory code
	ldr x1, =szInfile	  // Load x1 with file name address
	mov x2, #O_CREAT  // mov into x2 create if doesnt exist code
	mov x3,	#S_RDWR	  // mov into x3 RW permission
	mov x8,#NR_openat // mov into x8 open at code
	svc 0 			  // Open file for read only access
	
	ldr x4,=iFD		 	// Load iFDs address into x1
	strb w0,[x4]		// Load returned file discriptor byte into iFD
	
inFileLoop:
	ldr x1,=szTemp		// Load szTemps address into x1
	bl getline			// branch and link to getline
	
	cmp x0,#0			// Compare returned byte with 0
	beq fileDone		// Jump to file done if nothing has been Read

	ldr x0,=iNodecount	// Load x0 with Nodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq firstRead		// Branch to addFirst if its the Firstnode in the list

	ldr x0,=szTemp		// Load szTemps address into x0
	bl String_length	// Branch to string length
	add x0,x0,#1		// Increment x0
	bl addTail			// branchd and link to addTail
	
	ldr x0,=iFD		 	// Load iFDs address into x1
	ldrb w0,[x0]			// Reload the file discriptor
	
	b inFileLoop		// branch back to keep reading

firstRead:	
	ldr x0,=szTemp		// Load szTemps address into x0
	bl String_length	// Branch to string length
	add x0,x0,#1		// Increment x0
	bl addFirst			// branchd and link to addTail

	ldr x0,=iFD		 	// Load iFDs address into x1
	ldrb w0,[x0]			// Reload the file discriptor
	
	b inFileLoop		// branch back to keep reading

fileDone:
	ldr x0,=szTemp		// Load szTemps address into x0
	bl String_length	// Branch to string length
	add x0,x0,#1		// Increment x0
	bl addTail			// branchd and link to addTail
	
	// Close file	
	ldr x0,=iFD		 	// Load x0 with iFDs address
	ldrb w0,[x0]	  	// Load byte in address of x0 in w0.
	mov x8, #NR_close 	// mov into x8 exit code
	svc 0			  	// Close the file
	b mainLoop			// Branch back to mainloop
	
// ========================== delStr ========================== //
delStr:
	ldr x0,=iNodecount	// Load x0 with iNodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq delEmpty		// Branch to delEmpty if list is empty

	ldr x0,=szEnterline	 // Load string to prompt for index
	bl putstring		// branch and link function putstring

	ldr x0,=szTemp		// Load x0 with szTemps address
	mov x1,MAX_BYTES	// Move into x1 MAX_BYTES constant
	bl getstring		// get input from keyboard
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl ascint64			// converts string to double
	ldr x1,=iNodecount	// Load x1 with iNodecounts address
	ldr x1,[x1]			// Load value in nodecounts address into x1
	cmp x1,x0			// Check if nodecount is 0
	ble delOutOfRange	// if nodecount >= input index, jump to delOutOfRange

	mov x1,x0			// moves value of x0 into x1 (now contains index)
	ldr x0,=headPtr		// loads value 0 into x20

	bl delIndex			// unconditional branch to delIndex
	
	b mainLoop			// unconditional branch to mainLoop

delOutOfRange:
	ldr x0,=szInvalidIn	// Load address of szInvalidIn into x0
	bl  putstring		// print string

	b mainLoop			// unconditional branch to mainLoop

delEmpty:
	ldr x0,=szEmpty		// Load address of szEmpty into x0
	bl  putstring		// print string

	b mainLoop			// unconditional branch to mainLoop

// ========================== editStr ========================== //
editStr:
	ldr x0,=iNodecount	// Load x0 with iNodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq editEmpty		// Branch to delEmpty if list is empty

	ldr x0,=szEnterline	// Load string to prompt for index
	bl putstring		// branch and link function putstring

	ldr x0,=szTemp		// Load x0 with szTemps address
	mov x1,MAX_BYTES	// Move into x1 MAX_BYTES constant
	bl getstring		// get input from keyboard
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	bl ascint64			// converts string to double
	ldr x1,=iNodecount	// Load x1 with iNodecounts address
	ldr x1,[x1]			// Load value in nodecounts address into x1
	cmp x1,x0			// Check if nodecount is 0
	ble editOutOfRange	// if nodecount >= input index, jump to delOutOfRange

	mov x1,x0			// moves value of x0 into x1 (now contains index)
	ldr x0,=headPtr		// loads value 0 into x0

	b editIndex			// unconditional branch to delIndex
	
	b mainLoop			// unconditional branch to mainLoop

editOutOfRange:
	ldr x0,=szInvalidIn	// Load address of szInvalidIn into x0
	bl  putstring		// print string

	b mainLoop			// unconditional branch to mainLoop

editEmpty:
	ldr x0,=szEmpty		// Load address of szEmpty into x0
	bl  putstring		// print string

	b mainLoop			// unconditional branch to mainLoop

// ========================== searchStr ========================== //
searchStr:
	ldr x0,=iNodecount	// Load x0 with iNodecounts address
	ldr x0,[x0]			// Load value in nodecounts address into x0
	cmp x0,#0			// Check if nodecount is 0
	beq editEmpty		// Branch to delEmpty if list is empty
	
	ldr x0,=szEnterstr	// Load string to prompt for index
	bl putstring		// branch and link function putstring
	
	ldr x0,=szTemp		// Load x0 with szTemps address
	mov x1,MAX_BYTES	// Move into x1 MAX_BYTES constant
	bl getstring		// get input from keyboard
	
	ldr x0,=headPtr		// load x0 with headPtrs address
	ldr x1,=iNodecount	// load x1 with iNodecounts address
	bl stringSearch		// branch and link function stringSearch
	
	b  mainLoop			// unconditional branch to mainLoop

// ========================== saveFile ========================== //
saveFile:
	ldr x0, =iNodecount	// Load x0 with iNodecounts address
	ldr x0, [x0]		// Load value in nodecounts address into x0
	cmp x0, #0			// Check if nodecount is 0
	beq saveError		// Branch to saveError if list is empty

	// Get file name
	ldr x0, =szGetFileName	// prompt user for file name
	bl putstring			// prints prompt
	ldr x0, =szTemp			// load address of szString into x0
	mov x1, MAX_BYTES		// setting x1 to 512
	bl getstring			// branch and link function getstring

	// Open file
	mov x0, #AT_FDCWD		// local directory
	mov x8, #56 			// Openat command
	ldr x1, =szTemp			// loads address of filename into x1

	// Create file
	mov x2, #C_W			// Create the new file
	mov x3, #S_RW			// permissions
	svc 0					// service call

	ldr x1,=iFD				// Load x1 with iFds address
	strb w0,[x1]			// Store returned file descriptor i iFD

	ldr x19, =iNodecount	// loads address of iNodeCount into x19
	ldr x19, [x19]			// Number of nodes stored in x19
	ldr x20, =headPtr		// loads address of headPtr into x20
	ldr x20, [x20]			// Address of node in x0

saveLoop:
	ldr x0, [x20, #0]	// Address of string in x0
	bl String_length	// branch and link function String_length

	mov x11, x0 		// String length is in x11 (ready for function)
	ldr x10, [x20, #0] 	// get address of string into x10 for function

	bl saveString		// branch and link function saveString

	// Decrement the number of nodes
	sub x19, x19, #1
	cmp x19, #0
	beq endSave

	// Move to the next node
	ldr x20, [x20, #8]
	b saveLoop

endSave:
	ldr x0, =szSaveSuccess	// loads address of successful save in x0
	bl  putstring			// prints

	// Close file	
	ldr x0,=iFD		 	// Load x0 with iFDs address
	ldrb w0,[x0]	  	// Load byte in address of x0 in w0.
	mov x8, #NR_close 	// mov into x8 exit code
	svc 0			  	// Close the file

    b mainLoop	// unconditional branch to mainLoop

saveError:
	ldr x0, =szSaveError 	// loads address of save error in x0
	bl putstring			// prints

	b mainLoop	// unconditional branch to mainLoop

// ========================== _end ========================== //
endProgram:
	ldr x0,=headPtr		// load x0 with headPtr
	bl freeList			// branch to freeList

	ldr x0,=szEnd	  	// Load x0 with end of program msg
	bl putstring	  	// branch to putstring

// End of program parameters
	mov X0, #0  			// 0 to return
	mov X8, #NR_exit 		// Linux code 93 terminates
	svc 0	    			// Call Linux to execute


// ============================================================== //
// ====================== HELPER FUNCTIONS ====================== //
// ============================================================== //



// ========================== getline ========================== //
//**GETCHAR**//	
getchar:
	mov x2, #1		// mov 1 into x2
	mov x8, #NR_read // read
	svc 0			// does the lr change
	RET				// Return char
	
//**GETLINE**//
getline:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
top:
	bl getchar		// Branch to getchar
	ldrb w2,[x1]	// load byte in x1 into w2
	
	cmp w2, #0x0a	// Is char LF?
	beq EOLINE		// branch to end of line

	cmp w0, #0x0	// nothing read from file
	beq EOF			// branch to end
	
	cmp w0, #0x0	// compare byte with 0x0
	blt ERROR		// branch to error
	
	add x1, x1, #1	// increment x1
	
	ldr x0, =iFD	// Load iFDs address into x0
	ldrb w0, [x0]	// Reload the File descriptor byte into w0
	b top			// branch to top

EOLINE:
	add x1,x1,#1	// Increment x1	
	mov w2, #0		// store null at the end of fileBuf replacing the lineFeed
	strb w2, [x1]	// store w2 into x1
	b skip			// branch to skip

EOF:
	add x1,x1,#1	// Increment x1
	mov w2, #0		// store null at the end of fileBuf replacing the lineFeed
	strb w2, [x1]	// store w2 into x1
	b skip			// branch to skip
	
ERROR:
	mov x19, x0			// copy x0 into x19
	ldr x0, =szERROR	// load x0 with szErrors address
	bl putstring		// Output error string
	mov x0, x19			// copy x19 back into x0
	b skip				// branch to skip
	
skip:
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	RET					// return getline
	

	

// ========================== addFirst ========================== //
// Receives: X0 - stringlength
// Returns: nothing
 
addFirst:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
	ldr x1,=dbLength	// Load dbLengths address into x1
	str x0,[x1]			// Store returned stringlength into dbLength(x1)
	
	ldr x0,=dbLength	// Load dbLengths address into x0
	ldr x0,[x0]			// Load value inside dbLength
	bl malloc			// Malloc space for new Node
	
	mov x20,#0			// Initialize x20 to 0 for index
	mov x21,#0			// Initialize x21 to 0 for new string index
	
addFirstLoop:
	ldr x1,=szTemp		// Load szTemps address into x1
	ldrb w2,[x1,x20]	// Load first byte of string to copy into w2
	strb w2,[x0,x21]	// Store the byte in w2 into new mallocd space
	
	add x20,x20,#1		// Index++
	add x21,x21,#1		// Index++
	
	ldr x19,=dbLength	// Load saved strlengths address into x19
	ldr x19,[x19]		// Load value from address into x19
	cmp x21,x19			// Compare index with strlength
	bne addFirstLoop	// Loop back to beginning to keep adding
	
	mov x22,x0			// Copy address of mallocd space into x22
	mov x0,#16			// mov 16 into x0
	bl malloc			// Malloc 16 bytes
	
	str x22,[x0]		// Point new mallocd node to mallocd string
	
	ldr x1,=headPtr		// Load headPtrs address into x1
	str x0,[x1]			// Point headptr to new mallocd Node
	mov x0,#0			// Move a 0 into x0
	str x0,[x1,#8]		// Point first Nodenext* to 0(Null)
	
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	ldr x0,=headPtr		// Load headPtrs address into x0
	ldr x0,[x0]			// Load address headPtr is pointing to
	str x0,[x1]			// Point tail to the same address
	
	mov x1,#1			// Move a 1 into x1
	ldr x0,=iNodecount	// Load Nodecounts address into x0
	str x1,[x0]			// Store 1 into nodecount
	
	//calculate bytes
	ldr x0,=dbLength	// Load strlengths address into x0
	ldr x0,[x0]			// Load value in address into x0
	mov x1,#16			// move 16 into x1
	add x1,x0,x1		// Add 16 bytes to strlength and store in x1
	ldr x0,=iBytecount	// Load Bytecounts address into x0
	ldr x2,[x0]			// Copy value in Bytecount into x2
	add x1,x1,x2		// add Bytecount with with saved value in x1
	str x1,[x0]			// Store new bytecount from x1 into the address
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return

// ========================== addTail ========================== //
// Receives: X0 - stringlength
// Returns: nothing

addTail:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
	ldr x1,=dbLength	// Load dbLengths address into x1
	str x0,[x1]			// Store strlength into dbLengths address
	
	ldr x0,=dbLength	// Load dbLengths address into x0
	ldr x0,[x0]			// Load value inside dbLength
	bl malloc			// Branch to malloc
	
	
	mov x20,#0			// Initialize x20 to 0 for index
	mov x21,#0			// Initialize x21 to 0 for new string index
	
addTailLoop:
	ldr x1,=szTemp		// Load szTemps address into x1
	ldrb w2,[x1,x20]	// Load first byte of string to copy into w2
	strb w2,[x0,x21]	// Store the byte in w2 into new mallocd space
	
	add x20,x20,#1		// Index++
	add x21,x21,#1		// Index++
	
	ldr x19,=dbLength	// Load saved strlengths address into x19
	ldr x19,[x19]		// Load value from address into x19
	cmp x21,x19			// Compare index with strlength
	bne addTailLoop		// Loop back to beginning to keep adding
	
	mov x22,x0			// Copy address of mallocd space into x22
	mov x0,#16			// mov 16 into x0
	bl malloc			// Malloc 16 bytes
	
	str x22,[x0]		// Point new mallocd node to mallocd string
	
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	ldr x1,[x1]			// load node that tailPtr is pointing to
	str x0,[x1,#8]		// Point tailPtr to new mallocd space
	ldr x1,=tailPtr		// Load tailPtrs address into x1
	str x0,[x1]			// Point tail to the same address
	
	ldr x0,=iNodecount	// Load Nodecounts address into x0
	ldr x1,[x0]			// Copy nodecount into x1
	add x1,x1,#1		// increment nodecount by 1
	str x1,[x0]			// Store new nodecount
	
	//calculate bytes
	ldr x0,=dbLength	// Load strlengths address into x0
	ldr x0,[x0]			// Load value in address into x0
	mov x1,#16			// move 16 into x1
	add x1,x0,x1		// Add 16 bytes to strlength and store in x1
	ldr x0,=iBytecount	// Load Bytecounts address into x0
	ldr x2,[x0]			// Copy value in Bytecount into x2
	add x1,x1,x2		// add Bytecount with with saved value in x1
	str x1,[x0]			// Store new bytecount from x1 into the address
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return
	
// ========================== printList ========================== //
printList:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
	mov x21,x1			// copy number of nodes into x19
	mov x20,x0			// Copy address of headPtr into x20
	ldr x20,[x20]		// Load value stored inside address of x20
	
printLoop:
	ldr x0,=szLeftB		// Load x0 with Left bracket string address
	bl putstring		// branch to putstring
	
	ldr x0,=dbIndex		// Load x0 with dbIndexs address
	ldr x0,[x0]			// Load index from dbIndex into x0
	ldr x1,=szTemp		// Load szTemps address into x1
	bl int64asc			// convert from int64 to asciz
	ldr x0,=szTemp		// Load szTemps address in x0
	bl putstring		// branch to print string
	
	ldr x0,=szRightB	// Load x0 with Left bracket string address
	bl putstring		// branch to putstring

	ldr x0,[x20,#0]		// Address of current string headptr is pointing to
	bl putstring		// call putstring to print at current address
	
	ldr x0,=chCr		// Load x0 with Carriage return byte
	bl putch			// Call putch
	ldr x0,=chCr		// Load x0 with Carriage return byte
	bl putch			// Call putch
	
	ldr x0,=dbIndex		// Load dbIndexs address into x0
	ldr x1,[x0]			// Load the value inside dbIndex into x1
	add x1,x1,#1		// Increment
	str x1,[x0]			// Store incremented value back into dbIndex
	
	sub x21,x21,#1		// decrement nodeCounter Copy
	cmp x21,#0			// Check if nodeCount copy has reached 0
	beq endPrint		// Stop printing when all nodes have been traversed
	
	ldr x20,[x20,#8]	// Increment node address to next one
	b printLoop			// branch back to printing loop
	
endPrint:
	ldr x0,=dbIndex		// Load dbIndexs address into x0
	mov x1,#0			// Move a 0 into x1
	str x1,[x0]			// Reset dbIndex to 0
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return
	

// ========================== freeList ========================== //
// X0 - headPtr address

freeList:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame

	mov x20,x0		// Move headptr address into x20
	ldr x20,[x20]	// Load address of the first node its potinting to

freeLoop:
	ldr x19,[x20,#8]	// Load next address
	cmp x19,#0			// Check if next is null
	beq skiptoLast		// skip to last node
	
	ldr x21,[x19,#0]	// Holds nextNode's string address

skiptoLast:
	// save the addressses onto the stack
	str x19,[SP,#-16]!
	str x21,[SP,#-16]!

	ldr x0,[x20,#0]		// Load address of current string 
	bl free				// Branch to free

	mov x0,x20			// Copy address of the node
	bl free				// Free the address as well

	ldr x21,[SP],#16	// Reload saved nextNodes strings address
	ldr x19,[SP],#16	// Reload saved nextNodes address

	mov x20,x19			// Load nextNode into x20

	cmp x20,#0			// Check if nextNode is null
	beq endFree			// Jump to end if all nodes have been freed

	b freeLoop			// Jump back to continue freeing

endFree:
	ldr x0,=szEndfree	// Load szEndfrees address
	bl putstring

// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return

// ========================== delIndex ========================== //
// X0 - headPtr address
// X1 - index to be deleted

delIndex:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame

	mov x20,x0		// Move headptr address into x20
	ldr x20,[x20]	// Load address of the first node its potinting to
	
	mov x21,x1		// move index # into x21
	
	cmp x21,#0			// compares x21(index) with 0
	beq delFirstIndex	// if equal, branch to delFirstIndex
	
	ldr x23,=iNodecount	// load address of nodecount into x23
	ldr x23,[x23]		// load value of nodecount into x23
	sub x23,x23,#1		// x23 = x23 - 1 (accurate range of indexes of list)
	
	cmp x21,x23			// compares x21(index) with x23(last # of index)
	beq delLastIndex	// if equal, branch to delLastIndex
	
	b delMiddleIndex	// unconditional branch to delMiddleIndex
	
// ************* first index deletion ************* //
delFirstIndex:
	//calculate bytes
	mov x0, x20			// moving string into x0
	bl String_length	// branch and link function String_length
	mov x1,#16			// move 16 into x1
	add x1,x0,x1        // Add 16 bytes to strlength and store in x1
	ldr x0,=iBytecount  // Load Bytecounts address into x0
    ldr x2,[x0]         // Copy value in Bytecount into x2
    sub x2,x2,x1        // bytecount = bytecount - x1
    str x2,[x0]         // Store new bytecount from x2 into the address

	ldr x19,[x20,#8]	// Load next address
	str x19, [SP, #-16]! // Store the next nodes address onto the stack
	str x20, [SP, #-16]! // Store the next nodes address onto the stack
	
	ldr x0,[x20,#0]		// Load current Nodes string 
	bl free				// Free the string space
	
	ldr x20, [SP], #16	// Holds currentNode address
	ldr x19, [SP], #16	// Holds nextNode address
	
	ldr x25,=headPtr	// Load headPtrs address into x25
	str x19,[x25]		// Point headptr to next Node
	
	mov x0,x20			// Copy address of the first node
	bl free				// Free the address
	b delIndexEnd
	
// ************* last index deletion ************* // NOT WORKING
delLastIndex: 
	mov x22,#0		// x22 serves as counter (starts from 0)

	mov x19,#0		// initializing x19 
	mov x24,#0		// Initializing x24

delLastIndexLoop:
	cmp x22,x23				// compares index with last # of index
	beq delLastIndexFound	// jumps to delLastIndexFound

	add x22,x22,#1		// increments counter by 1

	ldr x24,[x20,#8]	// Load next address
	ldr x19,[x24,#8]	// Load next next address
	
	b delLastIndexLoop	// unconditional loop
	
delLastIndexFound:
	//calculate bytes
	mov x0, x19			// moving string into x0
	bl String_length	// branch and link function String_length
	mov x1,#16			// move 16 into x1
	add x1,x0,x1        // Add 16 bytes to strlength and store in x1
	ldr x0,=iBytecount  // Load Bytecounts address into x0
    ldr x2,[x0]         // Copy value in Bytecount into x2
    sub x2,x2,x1        // bytecount = bytecount - x1
    str x2,[x0]         // Store new bytecount from x2 into the address

	str x19, [SP, #-16]! // Store the currentNodes address onto the stack
	str x24, [SP, #-16]! // Store the prevNodes address onto the stack

	ldr x0,[x19,#0]		// Load string in currentNode
	bl free				// Free the space 
	
	ldr x24, [SP], #16	// Holds prevNode address
	ldr x19, [SP], #16	// Holds currentNode address
	
	mov x0,#0			// Move a 0 into x0
	str x0,[x24,#8]		// Point first Nodenext* to 0(Null)
	ldr x25,=tailPtr	// load tailPtrs address into x25
	str x24,[x25]		// Point tailPtr to previous Node
	
	mov x0,x19			// Copy address of the last node
	bl free				// Free the address
	b delIndexEnd

// ************* middle index deletion ************* // NOT WORKING EITHER
delMiddleIndex:
	mov x22,#0		// x22 serves as counter (starts from 0)
	mov x19,#0		// initializing x19
	mov x29,#0		// initializing x29

delMiddleIndexLoop:
	cmp x22,x21				// compares index with wanted index #
	beq delMiddleIndexFound	// jumps to delMiddleIndexFound

	add x22,x22,#1			// increments counter by 1
	mov x24,x19				// moves previous address into x24
	ldr x19,[x20,#8]		// Load next address
	ldr x29,[x19,#8]		// Load next next address
	
	b delMiddleIndexLoop 	// unconditional loop
	
delMiddleIndexFound:
	//calculate bytes
	mov x0, x19			// moving string into x0
	bl String_length	// branch and link function String_length
	mov x1,#16			// move 16 into x1
	add x1,x0,x1        // Add 16 bytes to strlength and store in x1
	ldr x0,=iBytecount  // Load Bytecounts address into x0
    ldr x2,[x0]         // Copy value in Bytecount into x2
    sub x2,x2,x1        // bytecount = bytecount - x1
    str x2,[x0]         // Store new bytecount from x2 into the address
	
	str x29,[x24,#8]	// point prevNext* to Next node.
	
	mov x0,x19			// Copy address of the last node
	bl free				// Free the address
	b delIndexEnd
	
delIndexEnd:
	ldr x23,=iNodecount	// load address of nodecount into x23
	ldr x24,[x23]		// load value of nodecount into x24
	sub x24,x24,#1		// x24 = x24 - 1 (accurate range of indexes of list)
	str x24,[x23]		// store updated number of indeces into =iNodecount

	ldr x0,=szDeleteSuccess	// load success output
	bl putstring			// prints
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return
	
// ========================== editIndex ========================== // TODO
// X0 - headPtr address
// X1 - index to be edited
// X2 - string to be changed to

editIndex:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame

	mov x21,x1			// copy index into x21
	mov x20,x0			// Copy address of headPtr into x20
	ldr x20,[x20]		// Load value stored inside address of x20

//	ldr x22,=iNodecount // load x22 with Node count pointer
//	ldr x22,[x22]		// Load value inside Inodecount into x22
//	sub x22,x22,#1		// x22 now holds valid range of indexes

	mov x23,#0			// counter

editLoop:
	cmp x23,x21			// compares counter to index
	beq editIndexFound	// if equal, jump to editIndexFound

	ldr x20,[x20,#8]	// Increment node address to next one
	add x23,x23,#1		// Increment counter by 1
	b editLoop

editIndexFound:
	// wow how do i do this??


	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	

	RET			// return
	
// ========================== saveString ========================== //
// X10 - holds string
// X11 - length of string
saveString:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame

	// ********************** Print to file ********************** //

	// Open file
	mov x0, #AT_FDCWD		// local directory
	mov x8, #56 			// Openat command
	ldr x1, =szTemp

	// Create file
	mov x2, #A_RW			// Create the new files
	mov x3, #S_RW			// permissions
	svc 0					// service call

	// x0 now contains the file directory
	// Write the string
	mov x8, #64				// Write
	mov x1, x10
	mov x2, x11
	svc 0

	// ********************** End Print to file ******************* //

	// *********************** Print Return *********************** //

	// Open file
	mov x0, #AT_FDCWD		// local directory
	mov x8, #56 			// Openat command
	ldr x1, =szTemp

	// Create file
	mov x2, #A_RW			// Create the new file
	mov x3, #S_RW			// permissions
	svc 0					// service call

	// ********************** End Print Return *******************

	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	

	// return
	RET

// ========================== stringSearch ========================== //
stringSearch:
// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
	mov x21,x1			// copy number of nodes into x19
	mov x20,x0			// Copy address of headPtr into x20
	ldr x20,[x20]		// Load value stored inside address of x20
	
	ldr x21,[x21]		// load value in iNodecount into x21
	
searchLoop:
	ldr x0,[x20,#0]		// Address of current string headptr is pointing to
	ldr x2,=szTemp		// Load x0 with szTemps address
	
	bl stringEquals		// unconditional branch to stringEquals
	
	cmp x0,#0			// compares x0 to 0
	beq searchPrintSkip	// if equal, branch to searchPrintSkip
	
searchPrintLoop:
	ldr x0,=szLeftB		// Load x0 with Left bracket string address
	bl putstring		// branch to putstring
	
	ldr x0,=dbIndex		// Load x0 with dbIndexs address
	ldr x0,[x0]			// Load index from dbIndex into x0
	ldr x1,=szTemp		// Load szTemps address into x1
	bl int64asc			// convert from int64 to asciz
	ldr x0,=szTemp		// Load szTemps address in x0
	bl putstring		// branch to print string
	
	ldr x0,=szRightB	// Load x0 with Left bracket string address
	bl putstring		// branch to putstring

	ldr x0,[x20,#0]		// Address of current string headptr is pointing to
	bl putstring		// call putstring to print at current address
	
	ldr x0,=chCr		// Load x0 with Carriage return byte
	bl putch			// Call putch
	ldr x0,=chCr		// Load x0 with Carriage return byte
	bl putch			// Call putch
	
searchPrintSkip:
	sub x21,x21,#1		// decrement nodeCounter Copy
	cmp x21,#0			// Check if nodeCount copy has reached 0
	beq searchEndPrint	// Stop printing when all nodes have been traversed

	ldr x0,=dbIndex		// Load dbIndexs address into x0
	ldr x1,[x0]			// Load the value inside dbIndex into x1
	add x1,x1,#1		// Increment
	str x1,[x0]			// Store incremented value back into dbIndex

	ldr x20,[x20,#8]	// Increment node address to next one
	b searchLoop		// branch back to printing loop
	
searchEndPrint:
	ldr x0,=dbIndex		// Load dbIndexs address into x0
	mov x1,#0			// Move a 0 into x1
	str x1,[x0]			// Reset dbIndex to 0
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	
	
	RET			// return
	
// ========================== stringEquals ========================== //
stringEquals:
	// preserving registers x19-x30 (AAPCS)
	str x19, [SP, #-16]!
	str x20, [SP, #-16]!
	str x21, [SP, #-16]!
	str x22, [SP, #-16]!
	str x23, [SP, #-16]!
	str x24, [SP, #-16]!
	str x25, [SP, #-16]!
	str x26, [SP, #-16]!
	str x27, [SP, #-16]!
	str x28, [SP, #-16]!
	str x29, [SP, #-16]!
	str	x30, [SP, #-16]!		// Push LR
	mov x29, SP 	// Set the stack frame
	
	mov x20, x0			// copies string address from x0 to x20
	mov x22, x2 		// copies string address from x2 to x22
	
	mov x0, x22 		// moves substring address from x22 to x0 
	bl	String_length	// branch and link to function string_Length
	mov x29, x0			// x29 also holds string length of substring
	
	mov x0, x20			// moves string address from x20 to X0
	bl  String_length	// branch and link to function string_length
	mov x27, x0			// x27 holds string length of string
	
	sub x27, x27, x29	// x27 = string length - substring length
	
	mov x21, #0			// initializing loop counter
	mov x28, #0		// counter for index

// x20: string address
// x22: substring address
// x27: string length - substring length
// x29: substring length
// x28: index counter
compareIndexLoop:
	cmp x28, x27		// comparing index counter to x27
	bgt	compareFalse	// if x28 > x27, branch to compareFalse
	
	mov x19, x29 		// x19 will become the counter (string length of substring)
	mov x25, #0			// x25 is offset for substring
	
compareMainLoop:
	ldrb w23, [x20, x28]	// gets a byte from the pointer + offset
	ldrb w24, [x22, x25]	// gets a byte from the pointer + offset

	cmp w23, #96			// compares w23 to ASCII val "a"
	blt compareCont			// if char is already uppercase, jump to compareCont
	
	sub w23, w23, #32		// else, turns the lowercase character uppercase

compareCont:
	cmp w24, #96			// compares w24 to ASCII val "a"
	blt	compareCont2		// if char is already uppercase, jump to compareCont2

	sub w24, w24, #32		// else, turns the lowercase character uppercase

compareCont2:
	add x28, x28, #1		// x28 = x28 + 1
	cmp	w23, w24			// compares the two bytes
	bne compareIndexLoop	// if w23 and w24 are not equal, branches to compareIndexLoop
	
	add x25, x25, #1		// x25 = x25 + 1
	
	sub x19, x19, #1		// x19 = x19 - 1
	cmp x19, #0				// compares x19 to 0
	beq compareTrue			// if equal, branches to true
	
	b	compareMainLoop		// unconditional branch to compareMainLoop
	
compareTrue:
	mov x0, #1
	b compareExit

compareFalse:
	mov x0, #0
	
compareExit:
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [SP], #16
	ldr x29, [SP], #16
    ldr x28, [SP], #16
    ldr x27, [SP], #16
    ldr x26, [SP], #16
    ldr x25, [SP], #16
    ldr x24, [SP], #16
    ldr x23, [SP], #16
    ldr x22, [SP], #16
    ldr x21, [SP], #16
    ldr x20, [SP], #16
    ldr x19, [SP], #16	

	// return
	RET
	
