
	PRESERVE8
     THUMB
     AREA     appcode, CODE, READONLY
     EXPORT __main
	 IMPORT TRHAM
	ENTRY 
__main  FUNCTION
    LDR R0 ,=0X2000000A
    LDR R1 ,=0X2000006D
    MOV r4, r0             
	LDR r6,=0x20000C02 ;location of IV
	LDR r8,=0x20005C01 ;location of cipher text
	MOV r9, #10	;value for IV
	STR r9, [r6]  ;store 10 to IV
	LDR r10,[r6]    ;initialization vector
	
	LDR r7, [r4]  ; reading plain text from start add
	CMP r10, #10 ;initialization vector value = 10
	EOR r7,r7,r10 ; exor of plaintext & initialization vector
	STR r10 , [r6]       ;store IV 
	STR r7,[r8] ;storing the result
	ADD r4, r4,#4
ELOOP
	LDR r7, [r4]  ; reading plain text from start add
	LDR r11, [r8]  ; load encrypted result to r11
	EOR r7,r7,r11  ;exor result with plain text
	ADD r8,r8,#4
	STR r7,[r8]
	ADD r4, r4,#4	
	CMP r4,r1
	BLT ELOOP
    B TRHAM   
stop B stop ; stop program
	 ENDFUNC
	 END
