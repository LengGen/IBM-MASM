;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ��� 
    ARRAYM DB 20 DUP (?)		;������
    ARRAYPLUS DB 20 DUP (?)		;��������
    ARRAYMINUS DB 20 DUP (?)	;��������
    BUF DB 81, 0, 81 DUP(0)    	;������
    
    inputting DB 'Please input a double-digit:$'
    outputcount DB 0DH,0AH,'The number of minus numbers is:$'
    outputsum DB 0DH,0AH,'The sum of plus numbers is:$'
    
    GOLINE DB 0DH,0AH,'$'
    PLUSCOUNT DB 0            	;��������
    MINUSCOUNT DB 0			  	;��������
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
    
    SUB AL,30H			;���ַ�����ת����������
    MOV DH,3
    XCHG DH,CL
    ;������� AL*10 -> AL
    MOV DL,AL
    SHL AL,CL			;������λ����8
    ADD AL,DL
    ADD AL,DL
 
    ADD AL,[SI+3]		;�ټ��ϸ�λ
    SUB AL,30H
    MOV [BX],AL    	;����λ������ARRAYM��
    
    INC PLUSCOUNT
    XCHG DH,CL
    JMP L2
    
FUHAO: 
	MOV AL,[SI+3]   	;��ȡʮλ
	
	SUB AL,30H			;���ַ�����ת����������
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
	;�������ݶ���һ������  �������� ES=DS  ������ָ����DI��ES����
	
	MOV CL,20		;ѭ���Ĵ���
	MOV CH,0
	CLD 			;��DF=0,��ǰ�����ȡ
	
DIVIDE:
	LODSB			;��ARRAYM��ȡ��һ���ֽڵ����ݵ�AL��  ����SIָ��+1
	
	TEST AL,80H		;������λ���ж����������Ǹ���  �������������룬���ݽ���Ƿ�Ϊ0������ZF
					;�������Ľ��Ϊ0����ZF=1��˵������λΪ0�������� ����������Ϊ0����ZF=0��˵������λ��1���Ǹ���
	
	JNZ MINUS		;���ZF=0���Ǹ�������ת��minus��  �ж�ZF�����ZF=1��������������ת�� 
	STOSB			;ZF=1,����������AL�е����ݴ浽����DI������ȥ  ����DIָ��+1
	
	JMP AGAIN		;ִ�����������ת��agiin��׼����һ��ѭ��

MINUS:
	XCHG BX,DI		;����BX,DI  ��Ŀ�ĵ�ַת�ɸ�����ĵ�ַ��Ȼ��ʼ�Ը��������ݽ��в���
	STOSB			;��AL�е����ݴ��뵽((DI))��ȥ��Ҳ���ǰѸ�������ARRAYMINUS������ȥ,����DIָ��+1
	
	XCHG BX,DI		;������Ϻ󣬽�BX,DI����������׼��������һ���ֽڵ�ѭ��������
	
AGAIN:
	DEC CX			;����-1��Ҳ����ѭ����������һ�Ρ� ���ָ���Ӱ��ZF��ֵ
	JNZ DIVIDE		;����������ݷ���  ֻ��ZF=0��Ҳ����CX��ֵ��Ϊ0��ʱ�� �Ż���ת��
	
	;��ӡ��������
	LEA DX,outputcount
	MOV AH,9
    INT 21H
	
	MOV AL,MINUSCOUNT
	CBW
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
	MOV BX,0  		;���ۼӵĺͷŵ�BX��
	CLD
ACCUMULATE:
	LODSB			;��ARRAYPLUS��ȡ��һ���ֽڵ����ݵ�AL��  ����SIָ��+1
	CBW 			;��AL -> AX ת��Ϊ�֣���ʾ�����Ĵ�С����
	ADD BX,AX		;�ۼ�
	MOV AX,0		;��AX��λ0������Ӱ���������
	
	DEC CX
	JNZ ACCUMULATE
	
	;����ۼӺ�
	MOV AX,BX
	MOV BL,10
	DIV BL			;AX/BL  ������AH ����AL
	MOV BH,AH		;�Ȱ�������������, ���̽��н�һ���Ĳ���

	CBW				;AL -> AX
	DIV BL			;AX/BL  ������AH������AL
	MOV DX,AX
	ADD DX,3030H
	MOV AH,2		;�����λ
	INT 21H
	
	MOV DL,DH
	MOV AH,2		;���ʮλ
	INT 21H
	
	MOV DL,BH
	ADD DL,30H
	MOV AH,2		;�����λ
	INT 21H
	
	LEA DX,GOLINE
	MOV AH,9
	INT 21H
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
