DATAS SEGMENT
    ;�˴��������ݶδ���
    inputting DB 'Please input a string:$'
    buf db 40,0,40 dup(0)  ; ���建����
    ;buf+1ָ�ľ������0������������ʵ�ʵ�Ԫ�ظ�����
    outputting DB 0DH,0AH,'The result is:$'
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
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
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    ;LEA BX,buf
    ;MOV CL,[BX+1]
    ;MOV CH,0 ;��ֹCH��ֵ
    ;MOV DI,2 ;ÿ���ƶ���λ
    ;
    ;MOV DL,[BX][DI]
    ;MOV AH,2
    ;INT 21H
    
    LEA DI,buf
    MOV CL,[DI+1] ;ȡ��ʵ�������ַ��ĸ���
    mov CH,0 
    add DI,2    ;[buf+2] ���ǻ������ַ����ĵ�һ���ַ�
    
L1: MOV DL,[DI]
	CMP DL,'0'
	JL L2
	CMP DL,'9'
	JG L2
	MOV DL,'#'
	mov [DI],DL
	JMP L5
	
L2: CMP DL,'A'
	JL L3
	CMP DL,'Z'
	JG L3
	ADD DL,20H
	mov [DI],DL
	JMP L5
	
L3: CMP DL,'a'
	JL L4
	CMP DL,'z'
	JG L4
	SUB DL,20H
	mov [DI],DL
	JMP L5
	
L4: MOV DL,'$'
	mov [DI],DL
	
L5: INC DI
	LOOP L1
      
    
    LEA DX,outputting
    MOV AH,9
    INT 21H
   
    
    ;ѭ������ַ���
    lea di,buf
    mov cl,[di+1] ;ȡ��ʵ�������ַ��ĸ���
    mov ch,0
    add di,2
next:mov dl,[di]
    MOV AH,2
    INT 21H
    
 	inc di
 	loop next
 	;JMP��������ת��ָ��
 	;LOOP��ѭ��ָ�ѭ�������ɼ����Ĵ���CXָ��
    
    
    ;LEA BX,buf
    ;ADD BX,2
    ;MOV DX,BX
    ;MOV AH,9
    ;INT 21H
    
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    ;MOV DL,0DH
    ;MOV AH,2
    ;INT 21H
   	;MOV DL,0AH
    ;MOV AH,2
    ;INT 21H
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
