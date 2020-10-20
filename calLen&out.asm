;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码
    inputting db 'Please input a string:$'
    STR1 DB 0DH,0AH,'The char numbers of your input:$'
    buf db 81,0,81 dup(0)
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DB 100 DUP(0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
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
    MOV DL,[SI+1]  ;读取字符串的实际长度
    ADD DL,30H
    
    MOV AH,02H
    INT 21H
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    ;循环输出字符串
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