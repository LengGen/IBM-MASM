;Ĭ�ϲ���ML6.11������
DATAS SEGMENT
    ;�˴��������ݶδ���  
    INPUTTING DB 'Please input a low char!!!:$'
    STRING DB 0DH,0AH,'The result is:$'
    A DB 0 ; �������A����Ϊ�˷�ֹ����Ǳ�ڵ�bug(��ͬ�������н����ͬ)
    BUF DB 81,0,81 DUP(0) 
    ;���建����  
    ;����һ(��һ���ֽ�)���ַ���������ַ�����  81=���81���ַ�
    ;������(�ڶ����ֽ�)���ַ����ĵ�ǰ�ַ�����  0=��ǰ�ַ�����Ϊ0
    ;������(�������ֽ�)��81 DUP(0) ���ַ�����81���ַ���0�����
    
    GOLINE DB 0DH,0AH,'$'
    
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
    DB 100 DUP(0)
    ;����һ���ɴ��100���ַ��Ŀռ䣬����ȫ����0����ʼ��
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    
L1: LEA DX,INPUTTING
	MOV AH,9
	INT 21H
	
	MOV AH,1
	INT 21H
	
	LEA DX,GOLINE
	MOV AH,9
	INT 21H
	
	CMP AL,'a' ; ��AL����������� 'a���'
	JL L1      ; JL��ʾ С��a������ת��L1�����
	CMP AL,'z'
	JG L1	   ; JG��ʾ ����z������ת��L1�����
	;��ʵ������������Ϊ�˷�ֹ�û������Сд��ĸ���ַ��ġ��������Сд��ĸ���򲻶���ʾ�û���������
	
	SUB AL,20H  ; ��ȥ32(������16������)������Сдת��д
	MOV A,AL
	
	LEA DX,STRING
	MOV AH,9
	INT 21H
	
	MOV DL,A
	MOV AH,02H
	INT 21H

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START