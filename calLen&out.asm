;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ���
    inputting db 'Please input a string:$'
    STR1 DB 0DH,0AH,'The char numbers of your input:$'
    buf db 81,0,81 dup(0)
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    DB 100 DUP(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
    LEA DX,inputting
    MOV AH,9
    INT 21H
    
    LEA DX,buf
    MOV AH,10
    INT 21H
    
    LEA DX,STR1
    MOV AH,9
    INT 21H
    
    LEA SI,buf
    MOV DL,[SI+1]  ;��ȡ�ַ�����ʵ�ʳ���
    ADD DL,30H
    
    MOV AH,02H
    INT 21H
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    ;ѭ������ַ���
    LEA SI,BUF
    INC SI
    MOV CL,[SI]
    
NEXT:
	INC SI
	MOV DL,[SI]
	MOV AH,2
	INT 21H
	
	LOOP NEXT
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    MOV AH,4CH
    INT 21H
    
CODES ENDS
    END START