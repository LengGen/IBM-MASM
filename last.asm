;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ��� 
    ARRAYM DB 20 DUP (?)
    ARRAYPLUS DB 20 DUP (?)	
    ARRAYMINUS DB 20 DUP (?)
    BUF DB 81, 0, 81 DUP(0)
    inputting DB 'Please input a double-digit:$'
    outputcount DB 0DH,0AH,'The number of minus numbers is:$'
    outputsum DB 0DH,0AH,'The sum of plus numbers is:$'
    GOLINE DB 0DH,0AH,'$'
    PLUSCOUNT DB 0
    MINUSCOUNT DB 0	
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    DB 100 DUP (0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    LEA BX,ARRAYM
    MOV CL,20         	;����
    MOV CH,0
L1: LEA DX,inputting
    MOV AH,9
    INT 21H

    LEA DX,BUF       	;�������ݵ�������
    MOV AH,10
    INT 21H
    
    LEA DX,GOLINE      ;����
    MOV AH,9
    INT 21H
    
    LEA SI,BUF
    MOV AL,[SI+2]    	;������ʮλ�� " - "
    CMP AL,'-'
    JE FUHAO
    
    SUB AL,30H
    MOV DH,3
    XCHG DH,CL
    ;������� AL*10 -> AL
    MOV DL,AL
    SHL AL,CL			
    ADD AL,DL
    ADD AL,DL
 
    ADD AL,[SI+3]		
    SUB AL,30H
    MOV [BX],AL    	
    
    INC PLUSCOUNT
    XCHG DH,CL
    JMP L2
    
FUHAO: 
	MOV AL,[SI+3]   	
	
	SUB AL,30H			
    MOV DH,3
    XCHG DH,CL
    
	MOV DL,AL
	SHL AL,CL
	ADD AL,DL
	ADD AL,DL
	
	MOV DL,[SI+4]
	SUB DL,30H
	
	ADD AL,DL
	
	NEG AL				;����෴������
	
	MOV [BX],AL     	;����ARRAYM��
	INC MINUSCOUNT
	
	XCHG DH,CL
L2:  
	ADD BX,1
	LOOP L1 	     
	
	LEA SI,ARRAYM
	LEA DI,ARRAYPLUS
	LEA BX,ARRAYMINUS
	
	MOV AX,DS
	MOV ES,AX
	
	MOV CL,20
	MOV CH,0
	CLD
	
DIVIDE:
	LODSB			
	
	TEST AL,80H		
	
	JNZ MINUS
	STOSB	
	
	JMP AGAIN

MINUS:
	XCHG BX,DI
	STOSB
	
	XCHG BX,DI
	
AGAIN:
	DEC CX
	JNZ DIVIDE
	
	;��ӡ��������
	LEA DX,outputcount
	MOV AH,9
    INT 21H
	
	MOV AX,MINUSCOUNT
	MOV BL,10
	DIV BL			;AX/BL ��������AH�У�����AL��
	MOV DX,AX
	ADD DX,3030H
	MOV AH,2
	INT 21H
	
	MOV DL,DH
	MOV AH,2
	INT 21H
	
	LEA DX,outputsum
	MOV AH,9
    INT 21H
	
	;��ʼ���ۼӲ���
	LEA SI,ARRAYPLUS
	MOV CL,PLUSCOUNT
	MOV CH,0
	MOV BX,0  		
	CLD
ACCUMULATE:
	LODSB			
	CBW 			
	ADD BX,AX		
	MOV AX,0		
	
	DEC CX
	JNZ ACCUMULATE
	
	;����ۼӺ�
	MOV AX,BX
	MOV BL,10
	DIV BL
	MOV BH,AH

	CBW	
	DIV BL
	MOV DX,AX
	ADD DX,3030H
	MOV AH,2
	INT 21H
	
	MOV DL,DH
	MOV AH,2
	INT 21H
	
	MOV DL,BH
	ADD DL,30H
	MOV AH,2
	INT 21H
	
	LEA DX,GOLINE
	MOV AH,9
	INT 21H
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START