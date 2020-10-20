DATAS SEGMENT
    ;此处输入数据段代码
    inputting DB 'Please input a string:$'
    buf db 40,0,40 dup(0)  ; 定义缓冲区
    ;buf+1指的就是这个0，即缓冲区中实际的元素个数。
    outputting DB 0DH,0AH,'The result is:$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
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
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
   	MOV DL,0AH
    MOV AH,2
    INT 21H
    
    ;LEA BX,buf
    ;MOV CL,[BX+1]
    ;MOV CH,0 ;防止CH有值
    ;MOV DI,2 ;每次移动单位
    ;
    ;MOV DL,[BX][DI]
    ;MOV AH,2
    ;INT 21H
    
    LEA DI,buf
    MOV CL,[DI+1] ;取出实际输入字符的个数
    mov CH,0 
    add DI,2    ;[buf+2] 就是缓冲区字符串的第一个字符
    
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
   
    
    ;循环输出字符串
    lea di,buf
    mov cl,[di+1] ;取出实际输入字符的个数
    mov ch,0
    add di,2
next:mov dl,[di]
    MOV AH,2
    INT 21H
    
 	inc di
 	loop next
 	;JMP是无条件转移指令
 	;LOOP是循环指令，循环次数由计数寄存器CX指定
    
    
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
