	    AREA   appcode,CODE,READONLY
TRHAM    FUNCTION								
        ENTRY
        EXPORT TRHAM
		IMPORT HAMMINGDECODE		
		B IMAGE	
EVEN_PARITY		 MOV R7 ,LR		
LOOP             AND R10 ,R9 ,R8
                 CMP R10 ,#0
				 IT HI
                 ADDHI R4 ,R4 ,#1       ;R11 AND R10 TEMP REGISTERS
				 ADD R11 ,R11 ,#1
				 LSL R9 ,R9 ,#1
                 CMP R11 ,#8	
	             IT HS
				 BHS CHECK_PARITY
                 B LOOP   	
CHECK_PARITY	AND R4 ,R4 ,#1
				MOV R11 ,#0
				CMP R4 ,#0                   ;R4 TEMP REGISTER
                IT HI
                MOVHI R11 ,#1	
				MOV PC , R7


IMAGE           LDR  R12 ,=0X20005C01   ;SOURCE 
                LDR  R5 ,=0X20000050    ;DESTINATION 
				
IMAGELOOP      LDR R9 ,=0X20005C6D
               CMP  R12 ,R9
               IT HI 
               BHI stop		   
               B START


LOADIMAGE       LSL R1 ,R1 ,#1
                ORR R0 ,R1 ,R0
                LSL R2 ,R2 ,#2  
                ORR R0 ,R2 ,R0
				LSL R3 ,R3 ,#3
				ORR R0 ,R3 ,R0
				AND R6 ,R6 ,#0X000000FF
				STR R6 ,[R5]   
                ADD R5 ,R5 ,#1
				AND R0 ,R0 ,#0X000000FF
				STR R0 ,[R5]
				ADD R5 ,R5 ,#1
				LDR R9 ,=0X200000B4
				CMP R5 , R9
				ADD R12 ,R12,#1 
				IT HI 
				BHI HAMMINGDECODE
                B IMAGELOOP
START	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	   MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	  ; MOV R5 ,#0x20000000                  ;R5 will have starting address
	LDR R6 ,[R12]	;R6 will have data
    AND R6 ,R6 ,#0X000000FF	
	MOV R0 ,#0X0000005B                  ;FIRST PARITY  P1  MASK
	MOV R1 ,#0X0000006D
	MOV R2 ,#0X0000008E
	MOV R3 ,#0X000000F0
	MOV R8 ,#0X00000000
	MOV R11 ,#0X00000000 
	AND R8 ,R6 ,R0                        ;MASKING TO R8 TEMPORARY REGISTER FOR CAL PARITY
    BL  EVEN_PARITY	
R_1	MOV R8 ,#0X00000000
    AND R8 ,R6,R1
	MOV R0 , R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S   
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
R_2	MOV R8 ,#0X00000000
    AND R8 ,R6,R2
	MOV R1 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
	MOV R8 ,#0X00000000    
R_3	AND R8 , R6 , R3
	MOV R2 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
 	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
R_4 MOV R3 ,R11
    B LOADIMAGE
    
stop    B stop
        ENDFUNC
        END
		

 