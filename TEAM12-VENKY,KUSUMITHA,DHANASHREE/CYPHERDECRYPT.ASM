	PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
     EXPORT CYPHERDECRYPT
	 ENTRY 
CYPHERDECRYPT  FUNCTION	
    LDR r8 , =0x20005C01   ;location of cipher texT
	LDR r9,[r8]  ;ciphertext msg from encryption
	MOV r10,r9	;storing previos ciphertext
	EOR r9,r9,#10 ; r9 = exor of ciphertext & initialization vector(cdtn for 1st msg)	
	STR r9,[r8]	
	ADD r8,r8,#4
	MOV r11,#1 ; for decrypting all words
LOOP	
		LDR r9, [r8] ;loading result from ciphertext location (of encryped text) to r11
		mov r7 ,r9
		EOR r9,r9,r10
		MOV r10,r7
		STR R9 ,[R8]
		ADD r8,r8,#4
		ADD r11,r11,#1
		CMP r11,#25
		BNE LOOP
		
		
	BEQ STARTMSGD
	EOR r9,r7,r11  ; exor current cipher text with prev cipher text msg
STARTMSGD 
	
     
stop B stop ; stop program
	 ENDFUNC
	 END