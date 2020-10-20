;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码  
    INPUTTING DB 'Please input a low char!!!:$'
    STRING DB 0DH,0AH,'The result is:$'
    A DB 0 ; 定义变量A就是为了防止出现潜在的bug(不同机器运行结果不同)
    BUF DB 81,0,81 DUP(0) 
    ;定义缓冲区  
    ;参数一(第一个字节)：字符串的最大字符个数  81=最多81个字符
    ;参数二(第二个字节)：字符串的当前字符个数  0=当前字符个数为0
    ;参数三(第三个字节)：81 DUP(0) 将字符串的81个字符用0来填充
    
    GOLINE DB 0DH,0AH,'$'
    
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DB 100 DUP(0)
    ;申请一个可存放100个字符的空间，并且全部用0来初始化
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
L1: LEA DX,INPUTTING
	MOV AH,9
	INT 21H
	
	MOV AH,1
	INT 21H
	
	LEA DX,GOLINE
	MOV AH,9
	INT 21H
	
	CMP AL,'a' ; 将AL里面的内容与 'a相比'
	JL L1      ; JL表示 小于a，则跳转到L1代码段
	CMP AL,'z'
	JG L1	   ; JG表示 大于z，就跳转到L1代码段
	;其实这四行语句就是为了防止用户输入非小写字母的字符的。如果不是小写字母，则不断提示用户重新输入
	
	SUB AL,20H  ; 减去32(这里是16进制数)，就是小写转大写
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