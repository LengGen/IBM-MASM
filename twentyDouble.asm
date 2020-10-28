;默认采用ML6.11汇编程序
DATAS SEGMENT
    ;此处输入数据段代码 
    ARRAYM DB 20 DUP (?)		;总数组
    ARRAYPLUS DB 20 DUP (?)		;正数数组
    ARRAYMINUS DB 20 DUP (?)	;负数数组
    BUF DB 81, 0, 81 DUP(0)    	;缓冲区
    
    inputting DB 'Please input a double-digit:$'
    outputcount DB 0DH,0AH,'The number of minus numbers is:$'
    outputsum DB 0DH,0AH,'The sum of plus numbers is:$'
    
    GOLINE DB 0DH,0AH,'$'
    PLUSCOUNT DB 0            	;正数个数
    MINUSCOUNT DB 0			  	;负数个数
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    DB 100 DUP (0)
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    
    LEA BX,ARRAYM
    MOV CL,20         	;计数
    MOV CH,0
    
L1: LEA DX,inputting
    MOV AH,9
    INT 21H
    
    LEA DX,BUF       	;输入数据到缓冲区
    MOV AH,10
    INT 21H
    
    LEA DX,GOLINE      ;换行
    MOV AH,9
    INT 21H
    
    LEA SI,BUF
    MOV AL,[SI+2]    	;可能是十位或 " - "
    CMP AL,'-'
    JE FUHAO
    
    SUB AL,30H			;将字符类型转成数字类型
    MOV DH,3
    XCHG DH,CL
    ;下面进行 AL*10 -> AL
    MOV DL,AL
    SHL AL,CL			;左移三位，乘8
    ADD AL,DL
    ADD AL,DL
 
    ADD AL,[SI+3]		;再加上个位
    SUB AL,30H
    MOV [BX],AL    	;将二位数存入ARRAYM中
    
    INC PLUSCOUNT
    XCHG DH,CL
    JMP L2
    
FUHAO: 
	MOV AL,[SI+3]   	;获取十位
	
	SUB AL,30H			;将字符类型转成数字类型
    MOV DH,3
    XCHG DH,CL
    
	MOV DL,AL
	SHL AL,CL
	ADD AL,DL
	ADD AL,DL
	
	MOV DL,[SI+4]
	SUB DL,30H
	
	ADD AL,DL
	
	NEG AL				;求得相反数存入
	
	MOV [BX],AL     	;存入ARRAYM中
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
	;所有数据都在一个段中  所以设置 ES=DS  串处理指令中DI和ES联用
	
	MOV CL,20		;循环的次数
	MOV CH,0
	CLD 			;让DF=0,从前往后读取
	
DIVIDE:
	LODSB			;从ARRAYM中取出一个字节的数据到AL中  并且SI指针+1
	
	TEST AL,80H		;检测符号位，判断是正数还是负数  两个操作数相与，根据结果是否为0来设置ZF
					;如果相与的结果为0，则ZF=1，说明符号位为0，是正数 ；如果结果不为0，则ZF=0，说明符号位是1，是负数
	
	JNZ MINUS		;如果ZF=0，是负数，则转向minus。  判断ZF，如果ZF=1，是正数，则不跳转。 
	STOSB			;ZF=1,是正数，将AL中的数据存到（（DI））中去  并且DI指针+1
	
	JMP AGAIN		;执行完操作后，跳转到agiin，准备下一次循环

MINUS:
	XCHG BX,DI		;交换BX,DI  将目的地址转成负数组的地址，然后开始对负数组内容进行操作
	STOSB			;把AL中的数据存入到((DI))中去，也就是把负数存入ARRAYMINUS数组中去,并且DI指针+1
	
	XCHG BX,DI		;操作完毕后，将BX,DI交换回来，准备进行下一个字节的循环操作。
	
AGAIN:
	DEC CX			;计数-1，也就是循环次数减少一次。 这个指令会影响ZF的值
	JNZ DIVIDE		;完成正负数据分离  只有ZF=0，也就是CX的值不为0的时候 才会跳转。
	
	;打印负数个数
	LEA DX,outputcount
	MOV AH,9
    INT 21H
	
	MOV AL,MINUSCOUNT
	CBW
	MOV BL,10
	DIV BL			;AX/BL 余数存在AH中，商在AL中
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
	
	;开始做累加操作
	LEA SI,ARRAYPLUS
	MOV CL,PLUSCOUNT
	MOV CH,0
	MOV BX,0  		;将累加的和放到BX中
	CLD
ACCUMULATE:
	LODSB			;从ARRAYPLUS中取出一个字节的数据到AL中  并且SI指针+1
	CBW 			;将AL -> AX 转换为字，表示的数的大小不变
	ADD BX,AX		;累加
	MOV AX,0		;将AX置位0，以免影响后续操作
	
	DEC CX
	JNZ ACCUMULATE
	
	;输出累加和
	MOV AX,BX
	MOV BL,10
	DIV BL			;AX/BL  余数在AH 商在AL
	MOV BH,AH		;先把余数保存起来, 对商进行进一步的操作

	CBW				;AL -> AX
	DIV BL			;AX/BL  余数在AH，商在AL
	MOV DX,AX
	ADD DX,3030H
	MOV AH,2		;输出百位
	INT 21H
	
	MOV DL,DH
	MOV AH,2		;输出十位
	INT 21H
	
	MOV DL,BH
	ADD DL,30H
	MOV AH,2		;输出个位
	INT 21H
	
	LEA DX,GOLINE
	MOV AH,9
	INT 21H
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
