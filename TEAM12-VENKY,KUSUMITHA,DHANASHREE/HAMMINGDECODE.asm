			    AREA   appcode,CODE,READONLY
HAMMINGDECODE    FUNCTION								
        ENTRY
        EXPORT HAMMINGDECODE	
		IMPORT  CYPHERDECRYPT	
        B CORRECT_LOAD
CORRECT_LOAD    LDR  R12 ,=0X20005C01        ;destination register r12
                LDR  R5 ,=0X20000050         ;source register r11 
LOADPARITY		LDR  R6 ,[R5]
                AND R6 ,R6 ,#0X000000FF
                ADD  R5 ,R5 ,#1              ;initializing transmitted value     
                B START     
IMAGE        AND R0 ,R0 ,#0X000000FF
             STR R0 ,[R12]
             ADD  R12 ,R12 ,#1	
             LDR R11 ,=0X20005c6d          ;storing the decoded value     
             CMP R12 ,R11
             IT HS
             BHS CYPHERDECRYPT  			 
             B LOADPARITY     


STARTCORET  AND R6 ,R6 ,#0X000000FF
            LDR R6 ,[R5]         ;R6 REAL PARITY BITS
            ADD  R5 ,R5 ,#1
            B START			
EVEN_PARITY		 MOV R7 ,LR		                      ;EVEN PARITY FUNCTION             
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
CHECK_PARITY	AND R4 ,R4 ,#1                 ;SETS THE PARITY BIT IN R11 REGISTER
				MOV R11 ,#0
				CMP R4 ,#0                   ;R4 TEMP REGISTER
                IT HI
                MOVHI R11 ,#1	
				MOV PC , R7 
START	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	   MOV R4 ,#0X00000000                    ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	  ; MOV R5 ,#0x20000000                   ;R5 will have starting address
	;LDR R6 ,[R5]                             ;R6 will have data	
	MOV R0 ,#0X0000005B                       ;FIRST PARITY  P1 ,P2,P3,P4 IN R0 ,R1,R2,R3  MASK
	MOV R1 ,#0X0000006D
	MOV R2 ,#0X0000008E
	MOV R3 ,#0X000000F0
	MOV R8 ,#0X00000000
	MOV R11 ,#0X00000000 
	AND R8 ,R6 ,R0  	;MASKING TO R8 TEMPORARY REGISTER FOR CAL PARITY
    BL  EVEN_PARITY	
R_1	MOV R8 ,#0X00000000
    AND R8 ,R6,R1
	LDR R7 ,[R5]                          ;SETTING PARITY BITS BY CALLING EVEN_PARITY
    AND R7 ,R7 ,#1
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1    
	MOV R0 , R11
	MOV R9 ,#0X00000001                   ;R9TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;R4TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
R_2	MOV R8 ,#0X00000000
    AND R8 ,R6,R2
	LDR R7 ,[R5] 
    AND R7 ,R7 ,#2
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
	MOV R1 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
	MOV R8 ,#0X00000000    
R_3	AND R8 , R6 , R3
    LDR R7 ,[R5] 
    AND R7 ,R7 ,#4
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
	MOV R2 ,R11
	MOV R9 ,#0X00000001                   ;TMPERORARY REGISTER FOR COUNTING BITS
	MOV R4 ,#0X00000000                   ;TEMP REGISTER TO PARITY EVEN 1'S OR 0'S  
 	MOV R11 ,#0X00000000 
	BL EVEN_PARITY
	LDR R7 ,[R5] 
	AND R7 ,R7 ,#0X000000FF
	AND R7 ,R7 ,#8
    CMP R7 ,#0
    IT HI
    EORHI R11 ,R11 ,#1  
R_4 MOV R3 ,R11
             LSL R1 ,R1 ,#1
                ORR R0 ,R1 ,R0               ;GETTING THE SUM OF PARITY BITS TO CHECK FOR ERROR  
                LSL R2 ,R2 ,#2  
                ORR R0 ,R2 ,R0
				LSL R3 ,R3 ,#3
				ORR R0 ,R3 ,R0
				
            MOV R4 ,R0	
			MOV R0 ,R6
            LDR R6 ,[R5]         ;R6 REAL PARITY BITS
		    AND R6 ,R6 ,#0X000000FF
           ADD  R5 ,R5 ,#1		     			
		   CMP R4 ,#0                 ;R4 CALCULATED PARITY BITS
		   IT NE
		   BNE LOOKUP
		   B IMAGE				
LOOKUP     MOV R1 ,#3                      ;IF ERROR CHECK FOR THE CORRESPONDING BIT AND FLIP THE BITS
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT0
           MOV R1 ,#5
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT1
		    MOV R1 ,#6
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT2
		    MOV R1 ,#7
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT3
		   MOV R1 ,#9
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT4 
		   MOV R1 ,#10
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT5
		   MOV R1 ,#11
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT6
		   MOV R1 ,#12
           CMP R4 ,R1
		   IT EQ
		   BEQ BIT7
		   

		   
BIT0       MOV R1 ,#0X1   
           ;LSL R1 ,R1 ,#3 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT1       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#1 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT2       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#2 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT3       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#3 
           EOR R0 ,R0,R1	            ; CODE FOR CHANGING BITS IN CASE OF ERROR TRANSMISSION
           B IMAGE                          
		   
BIT4       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#4 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT5       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#5 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT6       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#6 
           EOR R0 ,R0,R1	           
           B IMAGE
		   
BIT7       MOV R1 ,#0X1   
           LSL R1 ,R1 ,#7 
           EOR R0 ,R0,R1	           
           B IMAGE
		   


stop    B stop
        ENDFUNC
        END		 
 