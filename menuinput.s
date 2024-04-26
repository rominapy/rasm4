	
	.global menuinput
	.equ MAX_BYTES, 512
	.data
//String with entire menu prompt
szPrompt:   .asciz	"\n<1> View all strings\n\n<2> Add string\n		<a> from Keyboard\n		<b> from File. Static file named input.txt\n\n<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node).\n\n<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed.\n\n<5> String search. Regardless of case, return all strings that match the substring given.\n\n<6> Save File (output.txt)\n\n<7> Quit\n\nMenu Selection: "
szOption2:	.asciz  "\n<a> from Keyboard\n<b> from File. Static file named input.txt\n\nEnter selection: "
szInvalid:	.asciz  "\nERROR: Invalid Input!\n"
szInput:	.skip 512			// input buffer

	.text
menuinput:
	// preserving registers x19-x30 (AAPCS)
	str x19, [sp, #-16]!
	str x20, [sp, #-16]!
	str x21, [sp, #-16]!
	str x22, [sp, #-16]!
	str x23, [sp, #-16]!
	str x24, [sp, #-16]!
	str x25, [sp, #-16]!
	str x26, [sp, #-16]!
	str x27, [sp, #-16]!
	str x28, [sp, #-16]!
	str x29, [sp, #-16]!
	str x30, [sp, #-16]!
	mov x29, sp		// setting stack frame

reInput:	
	ldr x0,=szPrompt	// load x0 with prompt
	bl putstring		// output Menu prompt
	
	ldr x0,=szInput		// load x0 with input buffers address
	mov x1, MAX_BYTES
	bl getstring		// branch to getstring to receive user input
	
	ldr x0,=szInput		// load x0 with input buffers address
	ldrb w0,[x0]		// Load saved byte into w0
	
	cmp w0,#'1'			// Compare byte with 1
	blt	invalidInp		// branch to invalid input if byte is less than 1
	
	cmp w0,#'7'			// Compare byte with 7
	bgt	invalidInp		// branch to invalid input if byte is greater than 7
	
	cmp w0,#'2'			// Compare byte with 2
	bne	exit		    // branch to exit if input is valid and != 2
	
	// Handling option 2 (a or b)
	ldr x0,=szOption2	// Load x0 with option2s address
	bl putstring		// branch to putstring	
	
	ldr x0,=szInput		// load x0 with input buffers address
	mov x1, MAX_BYTES
	bl getstring		// branch to getstring to receive user input
	
	ldr x0,=szInput		// load x0 with input buffers address
	ldrb w0,[x0]		// Load saved byte into w0
	
	cmp w0,#'a'			// Check if user input == 'a'
	beq	exit		    // branch to exit if input is valid
	cmp w0,#'A'			// Check if user input == 'A'
	beq	exit		    // branch to exit if input is valid
	
	cmp w0,#'b'			// Check if user input == 'b'
	beq	exit		    // branch to exit if input is valid
	cmp w0,#'B'			// Check if user input == 'B'
	beq	exit		    // branch to exit if input is valid
	
invalidInp:	
	ldr x0,=szInvalid	// load x0 with szInvalids address
	bl putstring		// branch to putstring
	
	ldr x0,=szInput		// load x0 with input buffers address
	mov x1,#0			// Move a 0 into x1
	str x1,[x0]		    // Store value in x1 into szInput

	b reInput			// branch back to beginning of menu

exit:
	
	// restoring preserved registers x19-x30 (AAPACS)
	ldr x30, [sp], #16
	ldr x29, [sp], #16
	ldr x28, [sp], #16
	ldr x27, [sp], #16
	ldr x26, [sp], #16
	ldr x25, [sp], #16
	ldr x24, [sp], #16
	ldr x23, [sp], #16
	ldr x22, [sp], #16
	ldr x21, [sp], #16
	ldr x20, [sp], #16
	ldr x19, [sp], #16
	
	ret	// returns to calling function
	
