IDEAL
MODEL small

BMP_WIDTH = 320
BMP_HEIGHT = 200
FILE_NAME_IN  equ 'plane.bmp'

STACK 100h
DATASEG

; --------------------------
; Your variables here
	RndCurrentPos dw start

	
	
	
	
	
	OneBmpLine 	db BMP_WIDTH dup (0)  ; One Color line read buffer
   
    ScrLine 	db BMP_WIDTH+4 dup (0)  ; One Color line read buffer

	;BMP File data
	FileName1 	db 'plane1.bmp' ,0
	FileName2 	db 'plane2.bmp' ,0
	FileName3 	db 'plane3.bmp' ,0
	shipOffset dw ? ; offset to the wanted ship file name
	OpenFileName db "open.bmp",0
	InstructionsFileName db "man.bmp",0
	GameOverFileName db "GO.bmp",0
	ScoreFileName db "score.txt",0
	
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	
	SmallPicName db 'Pic48X78.bmp',0
	
	
	BmpFileErrorMsg    	db 'Error At Opening Bmp File ',FILE_NAME_IN, 0dh, 0ah,'$'
	ErrorFile           db 0
			  
			  			  
	; see http://cs.nyu.edu/~yap/classes/machineOrg/info/mouse.htm
	
	;BMP VARS
	BmpLeft dw ?
	BmpTop dw ?
	BmpColSize dw ?
	BmpRowSize dw ?
	BmpDeg dw ?
	BmpX dw ?
	BmpY dw ?
	BmpOffX dw ?
	BmpOffY dw ?
	
	highestScore dw 0
	fileNamePointer dw ?;pointer to the needed spaceship bmp file name
	
	Missiles dw 30 dup(-1); every Missile is reperesented in 3 words, the first is the x, second y, and third direction (divided to 2, dir x and dir y)
	Score dw 0
	
	SpaceShipVelocityVector dw 2 dup(0)
	
	EndGame db 0
	
	sineTable dw 0,17,35,52,70,87,105,122,139,156,174
	dw 191,208,225,242,259,276,292,309,326,342
	dw 358,375,391,407,423,438,454,469,485,500
	dw 515,530,545,559,574,588,602,616,629,643
	dw 656,669,682,695,707,719,731,743,755,766
	dw 777,788,799,809,819,829,839,848,857,866
	dw 875,883,891,899,906,914,921,927,934,940
	dw 946,951,956,961,966,970,974,978,982,985
	dw 988,990,993,995,996,998,999,999,1000,1000
	dw 1000,999,999,998,996,995,993,990,988,985
	dw 982,978,974,970,966,961,956,951,946,940
	dw 934,927,921,914,906,899,891,883,875,866
	dw 857,848,839,829,819,809,799,788,777,766
	dw 755,743,731,719,707,695,682,669,656,643
	dw 629,616,602,588,574,559,545,530,515,500
	dw 485,469,454,438,423,407,391,375,358,342
	dw 326,309,292,276,259,242,225,208,191,174
	dw 156,139,122,105,87,70,52,35,17,0
	dw -17,-35,-52,-70,-87,-105,-122,-139,-156,-174
	dw -191,-208,-225,-242,-259,-276,-292,-309,-326,-342
	dw -358,-375,-391,-407,-423,-438,-454,-469,-485,-500
	dw -515,-530,-545,-559,-574,-588,-602,-616,-629,-643
	dw -656,-669,-682,-695,-707,-719,-731,-743,-755,-766
	dw -777,-788,-799,-809,-819,-829,-839,-848,-857,-866
	dw -875,-883,-891,-899,-906,-914,-921,-927,-934,-940
	dw -946,-951,-956,-961,-966,-970,-974,-978,-982,-985
	dw -988,-990,-993,-995,-996,-998,-999,-999,-1000,-1000
	dw -1000,-999,-999,-998,-996,-995,-993,-990,-988,-985
	dw -982,-978,-974,-970,-966,-961,-956,-951,-946,-940
	dw -934,-927,-921,-914,-906,-899,-891,-883,-875,-866
	dw -857,-848,-839,-829,-819,-809,-799,-788,-777,-766
	dw -755,-743,-731,-719,-707,-695,-682,-669,-656,-643
	dw -629,-616,-602,-588,-574,-559,-545,-530,-515,-500
	dw -485,-469,-454,-438,-423,-407,-391,-375,-358,-342
	dw -326,-309,-292,-276,-259,-242,-225,-208,-191,-174
	dw -156,-139,-122,-105,-87,-70,-52,-35,-17
	
	
	cosTable dw  1000,999, 999, 998, 997, 996, 994, 992, 990, 987, 984 
	 dw 981, 978, 974, 970, 965, 961, 956, 951, 945, 939
	 dw 933, 927, 920, 913, 906, 898, 891, 882, 874, 866 
	 dw 857, 848, 838, 829, 819, 809, 798, 788, 777, 766 
	 dw 754, 743, 731, 719, 707, 694, 681, 669, 656, 642 
	 dw 629, 615, 601, 587, 573, 559, 544, 529, 515, 500 
	 dw 484, 469, 453, 438, 422, 406, 390, 374, 358, 342 
	 dw 325, 309, 292, 275, 258, 241, 224, 207, 190, 173 
	 dw 156, 139, 121, 104, 87, 69, 52, 34, 17, 0
	 dw -17, -34, -52, -69, -87, -104, -121, -139, -156, -173
	 dw -190, -207, -224, -241, -258, -275, -292, -309, -325, -342
	 dw -358, -374, -390, -406, -422, -438, -453, -469, -484, -499 
	 dw -515, -529, -544, -559, -573, -587, -601, -615, -629, -642 
	 dw -656, -669, -681, -694, -707, -719, -731, -743, -754, -766 
	 dw -777, -788, -798, -809, -819, -829, -838, -848, -857, -866 
	 dw -874, -882, -891, -898, -906, -913, -920, -927, -933, -939 
	 dw -945, -951, -956, -961, -965, -970, -974, -978, -981, -984 
	 dw -987, -990, -992, -994, -996, -997, -998, -999, -999, -1000 
	 dw -999, -999, -998, -997, -996, -994, -992, -990, -987, -984 
	 dw -981, -978, -974, -970, -965, -961, -956, -951, -945, -939 
	 dw -933, -927, -920, -913, -906, -898, -891, -882, -874, -866 
	 dw -857, -848, -838, -829, -819, -809, -798, -788, -777, -766 
	 dw -754, -743, -731, -719, -707, -694, -681, -669, -656, -642 
	 dw -629, -615, -601, -587, -573, -559, -544, -529, -515, -500 
	 dw -484, -469, -453, -438, -422, -406, -390, -374, -358, -342 
	 dw -325, -309, -292, -275, -258, -241, -224, -207, -190, -173 
	 dw -156, -139, -121, -104, -87, -69, -52, -34, -17, 0
	 dw 17, 34, 52, 69, 87, 104, 121, 139, 156, 173
	 dw 190, 207, 224, 241, 258, 275, 292, 309, 325, 342 
	 dw 358, 374, 390, 406, 422, 438, 453, 469, 484, 500 
	 dw 515, 529, 544, 559, 573, 587, 601, 615, 629, 642 
	 dw 656, 669, 681, 694, 707, 719, 731, 743, 754, 766 
	 dw 777, 788, 798, 809, 819, 829, 838, 848, 857, 866 
	 dw 874, 882, 891, 898, 906, 913, 920, 927, 933, 939 
	 dw 945, 951, 956, 961, 965, 970, 974, 978, 981, 984 
	 dw 987, 990, 992, 994, 996, 997, 998, 999, 999, 1000 
	
; --------------------------

CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
	mov ax, 13h
	int 10h
	
	call loadHighestScore; loading the highest score
	
OpeningScreen:
	call writeHighestScore; writing the highest score, the last game score or the all time score. the highest
	call loadHighestScore; updating the highest score
	
	
	mov [shipOffset], offset FileName1
	cmp [highestScore], 100
	jl NotPlane2

	cmp [highestScore], 250
	jl NotPlane3
	
	mov [shipOffset], offset FileName3
	jmp NotPlane2
NotPlane3:	
	mov [shipOffset], offset FileName2
NotPlane2:

	mov ax,0
	call ClearScreen
	
	mov [BmpLeft], 0; drawing opening screen
	mov [BmpTop], 0
	mov [BmpColSize],320
	mov [BmpRowSize],200
	mov [BmpOffX], 0
	mov [BmpOffY], 0
	mov [BmpDeg], 0
	mov dx, offset OpenFileName
	call OpenShowBmp
	
	
	
	mov ah,2; moving the cursor to the top left corner
	mov bh, 0
	mov dh, 23
	mov dl, 11
	int 10h
	
	mov ax,[highestScore]
	call ShowAxDecimal
	
	
OpenInput:
	
	mov ah, 1
	int 16h
	jz OpenInput
	
	mov ah,0
	int 16h
	
	cmp al, 's'
	jne CheckIkey
	jmp StartGame
CheckIkey:	
	cmp al, 'i'
	je ManScreen
	
	cmp ah, 01; esc key
	jne OpenInput
	jmp exit
	


ManScreen:
	mov [BmpLeft], 0; drawing manual screen
	mov [BmpTop], 0
	mov [BmpColSize],320
	mov [BmpRowSize],200
	mov [BmpOffX], 0
	mov [BmpOffY], 0
	mov [BmpDeg], 0
	mov dx, offset InstructionsFileName
	call OpenShowBmp
	
	
	
ManInput:
	
	mov ah, 1
	int 16h
	jz ManInput
	
	mov ah,0
	int 16h
	
	cmp ah, 01; esc key
	jne ManInput
	jmp OpeningScreen
	
	
	
	
GameOverScreen:
	mov [BmpLeft], 0; drawing game over screen
	mov [BmpTop], 0
	mov [BmpColSize],320
	mov [BmpRowSize],200
	mov [BmpOffX], 0
	mov [BmpOffY], 0
	mov [BmpDeg], 0
	mov dx, offset GameOverFileName
	call OpenShowBmp
	
	
	mov ah,2; moving the cursor to the needed position
	mov bh, 0
	mov dh, 37 ;row
	mov dl, 50 ;column
	int 10h
	
	mov ax, [Score]
	call ShowAxDecimal
	
	
GameOverInput:
	
	mov ah, 1
	int 16h
	jz GameOverInput
	
	mov ah,0
	int 16h
	
	cmp ah, 01; esc key
	jne GameOverInput
	jmp OpeningScreen











	
StartGame:
	mov [BmpDeg], 0
	mov [EndGame],0
	mov [Score],0
	
	xor bx,bx
ResetingMissiles:
	mov [byte Missiles+bx], -1
	inc bx
	cmp bx,60
	jb ResetingMissiles
MainLoop:
	call LoopDelay1Tenth
	
	call inputs

	
	mov ax ,0
	call ClearScreen
	
	
	
	mov [BmpLeft], 145
	mov [BmpTop], 85
	mov [BmpColSize],30
	mov [BmpRowSize],30
	mov [BmpOffX], 15
	mov [BmpOffY], 15
	mov dx, [shipOffset]
	call OpenShowBmpRot
	
	call updateMissiles
	call DrawMissiles
	
	
	mov ah,2; moving the cursor to the top left corner
	mov bh, 0
	mov dh, 0
	mov dl, 0
	int 10h
	
	mov ax, [Score]
	call ShowAxDecimal
	
	
ReadKey:	
	cmp [EndGame], 1
	jne MainLoop
	jmp GameOverScreen



exit:
	
	mov ax,2
	int 10h
	
	
	mov ax, 4c00h
	int 21h



;claring the screen in the color in al
proc ClearScreen
	
	push es
	push ds
	push si
	push cx
	
	mov bx, 0A000h
	mov es, bx
	mov ds, bx
	cld
	
	xor bx,bx
@@DrawingFirstLine:
	mov [byte es:bx],al
	inc bx
	cmp bx, 320
	jb @@DrawingFirstLine
	

	mov si,0
	mov di, 320
	mov cx,199
@@NextRow:	
	push cx
	
	mov cx, 320
	rep movsb ; Copy line to the screen
	

	xor si,si
	
	pop cx
	loop @@NextRow
	
	
@@endProc:	
	
	pop si
	pop ax
	pop ds
	pop es
    ret
endp ClearScreen


   

proc LoopDelay1Tenth
	push cx
	mov cx ,100
@@Self1:
	push cx
	mov cx,3000   
@@Self2:	
	loop @@Self2
	pop cx
	loop @@Self1
	pop cx
	ret
endp LoopDelay1Tenth



;loads the highets score from the score file
; output: highestScore
proc loadHighestScore
	push ax
	push bx
	push cx
	push dx

	mov ah, 3Dh
	mov al, 2
	mov dx, offset ScoreFileName
	int 21h
	
	jc @@ret
	mov [FileHandle],ax
	
	mov ah, 3Fh
	mov bx, [FileHandle]
	mov cx,2
	mov dx, offset highestScore
	int 21h
	
	mov bx, [FileHandle]
	mov ah, 3Eh
	int 21h
	
	
	
@@ret:	
	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp loadHighestScore


;writes the highets score to the score file
; compares the current score to the highest score
proc writeHighestScore
	push ax
	push bx
	push cx
	push dx

	mov ah, 3Dh
	mov al, 2
	mov dx, offset ScoreFileName
	int 21h
	
	jc @@ret
	mov [FileHandle],ax
	
	mov ah, 40h
	mov bx, [FileHandle]
	mov cx,2
	mov dx, [highestScore]
	cmp [score],dx
	jg @@NewRecord
	jmp @@CrntRecord
	
@@NewRecord:
	mov dx, offset score
	jmp @@Exec
@@CrntRecord:
	mov dx, offset highestScore
	
@@Exec:
	int 21h
	
	mov bx, [FileHandle]
	mov ah, 3Eh
	int 21h
	
	
	
@@ret:	
	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp writeHighestScore


	
; draws an horizontal line
; input: STACK. first push X, second push Y. third Push len. fourth push color
; output: screen
proc DrawHorizontalLine
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	
	mov si, [bp+6]
	dec si
@@Loop:
	mov bh,0
	
	mov dx, [bp+8]
	mov cx, [bp+10]
	add cx, si
	mov al, [bp+4]
	mov ah, 0Ch
	int 10h

	dec si
	cmp si, 0
	jge @@Loop
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp DrawHorizontalLine


	
; draws an vertical line
; input: STACK. first push X, second push Y. third Push len. fourth push color
; output: screen
proc DrawVerticalLine
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	
	mov si, [bp+6]
	dec si
@@Loop:
	mov bh,0
	
	mov dx, [bp+8]
	mov cx, [bp+10]
	add dx, si
	mov al, [bp+4]
	mov ah, 0Ch
	int 10h

	dec si
	cmp si, 0
	jge @@Loop
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp DrawVerticalLine





; draws an rectangle 
; input: STACK. first push X, second push Y. third Push Xlen. fourth push Ylen.fifth push Color
; output: screen
proc DrawRec
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	
	push [bp+12]
	push [bp+10]
	push [bp+8]
	push [bp+4]
	call DrawHorizontalLine
	pop ax
	pop ax
	pop ax
	pop ax
	
	
	
	push [bp+12]
	push [bp+10]
	push [bp+6]
	push [bp+4]
	call DrawVerticalLine
	pop ax
	pop ax
	pop ax
	pop ax
	
	
	mov ax, [bp+12]
	add ax, [bp+8]
	dec ax
	push ax
	push [bp+10]
	push [bp+6]
	push [bp+4]
	call DrawVerticalLine
	pop ax
	pop ax
	pop ax
	pop ax
	
	
	mov ax, [bp+10]
	add ax, [bp+6]
	dec ax
	push [bp+12]
	push ax
	push [bp+8]
	push [bp+4]
	call DrawHorizontalLine
	pop ax
	pop ax
	pop ax
	pop ax
	
	
	
	

	
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp DrawRec
	

; draws a filled rectangle 
; input: STACK. first push X, second push Y. third Push Xlen. fourth push Ylen.fifth push Color
; output: screen
proc DrawRecFull
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	
	mov cx, [bp + 6]
	dec cx
@@Loop:
	push [bp+12]
	mov bx, [bp+10]
	add bx, cx
	push bx
	push [bp +8]
	push [bp+4]
	call DrawHorizontalLine
	
	pop bx
	pop bx
	pop bx
	pop bx
	
	
	dec cx
	cmp cx, 0
	jge @@Loop
	
	
	
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp DrawRecFull


proc Palet
	push ax
	push bx
	push cx
	push dx
	
	xor bx,bx
	mov cx, 0
	mov dx, 85
	
@@Loop:
	push cx
	push dx
	push 5
	push 5
	push bx
	
	call DrawRecFull
	
	pop ax
	pop ax
	pop ax
	pop ax
	pop ax
	
	inc bx
	cmp bx, 256
	ja @@Ret
	add cx, 7
	cmp cx, 112
	jb @@Loop
	add dx, 7
	mov cx,0
	jmp @@Loop
@@Ret:
	pop dx
	pop cx
	pop bx
	pop ax
	
	
	ret
endp Palet


; Description  : get RND between any bl and bh includs (max 0 - 65535)
; Input        : 1. BX = min (from 0) , DX, Max (till 64k -1)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        AX - rnd num from bx to dx  (example 50 - 1550)
; More Info:
; 	BX  must be less than DX 
; 	in order to get good random value again and again the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCsWord
    push es
	push si
	push di
 
	
	mov ax, 40h
	mov	es, ax
	
	sub dx,bx  ; we will make rnd number between 0 to the delta between bx and dx
			   ; Now dx holds only the delta
	cmp dx,0
	jz @@ExitP
	
	push bx
	
	mov di, [word RndCurrentPos]
	call MakeMaskWord ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
@@RandLoop: ;  generate random number 
	mov bx, [es:06ch] ; read timer counter
	
	mov ax, [word cs:di] ; read one word from memory (from semi random bytes at cs)
	xor ax, bx ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	inc di
	cmp di,(EndOfCsLbl - start - 2)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	
	cmp ax,dx    ;do again if  above the delta
	ja @@RandLoop
	pop bx
	add ax,bx  ; add the lower limit to the rnd num
		 
@@ExitP:
	
	pop di
	pop si
	pop es
	ret
endp RandomByCsWord


Proc MakeMaskWord    
    push dx
	
	mov si,1
    
@@again:
	shr dx,1
	cmp dx,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop dx
	ret
endp  MakeMaskWord





; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs



; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask



;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage:   
;================================================
proc ShowAxDecimal
	push ax
	push bx
	push cx
	push dx

	 
	; check if negative
	test ax,08000h
	jz PositiveAx
		
	;  put '-' on the screen
	push ax
	mov dl,'-'
	mov ah,2
	int 21h
	pop ax

	neg ax ; make it positive
PositiveAx:
	mov cx,0   ; will count how many time we did push 
	mov bx,10  ; the divider

put_mode_to_stack:
	xor dx,dx
	div bx
	add dl,30h
	; dl is the current LSB digit 
	; we cant push only dl so we push all dx
	push dx    
	inc cx
	cmp ax,9   ; check if it is the last time to div
	jg put_mode_to_stack

	cmp ax,0
	jz pop_next  ; jump if ax was totally 0
	add al,30h  
	mov dl, al    
	mov ah, 2h
	int 21h        ; show first digit MSB
	   
pop_next: 
	pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	mov dl, al
	mov ah, 2h
	int 21h        ; show all rest digits
	loop pop_next
	
	mov dl, 10d
	mov ah, 2
	int 21h
	
	mov dl, 13d
	mov ah, 2
	int 21h
	

	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp ShowAxDecimal




























; bmp rendering
;-------------------------------------------------------------------------------------------------
proc OpenShowBmp near
	
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBMP
	
	 
	call CloseBmpFile   

@@ExitProc:
	ret
endp OpenShowBmp

 
 
 proc OpenShowBmpRot near
	
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBMPRot
	
	 
	call CloseBmpFile   

@@ExitProc:
	ret
endp OpenShowBmpRot

; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile

	
; output file dx filename to open
proc CreateBmpFile	near						 
	 
	
CreateNewFile:
	mov ah, 3Ch 
	mov cx, 0 
	int 21h
	
	jnc Success
@@ErrorAtOpen:
	mov [ErrorFile],1
	jmp @@ExitProc
	
Success:
	mov [ErrorFile],0
	mov [FileHandle], ax
@@ExitProc:
	ret
endp CreateBmpFile





proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader



proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette

 
proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	
@@NextLine:
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine

@@Copying:
	cmp [byte ds:si], 255d
	je @@Transperant
	jmp @@MovsbLabel
	
@@Transperant:
	inc si
	inc di
	jmp @@LoopLabel

@@MovsbLabel:
	movsb
@@LoopLabel:
	dec cx
	cmp cx,0
	je @@After
	jmp @@Copying

@@After:
	pop dx
	pop cx
	 
	dec cx
	cmp cx,0
	je @@ret
	jmp @@NextLine
@@ret:

	pop cx
	ret
endp ShowBMP 



;displays the BMP rotated bmpDeg degrees
;input:  BmpRowSize, BmpColSize, BmpLeft, BmpTop, BmpY, BmpX, BmpOffX, BmpOffY
proc ShowBMPRot
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (BmpRowSize lines in VGA format),
	; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
	mov cx,[BmpRowSize]
	
 
	mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	xor dx,dx
	mov si,4
	div si
	cmp dx,0
	mov bp,0
	jz @@row_ok
	mov bp,4
	sub bp,dx

@@row_ok:	
	mov dx,[BmpLeft]
	mov ax, [BmpColSize]
	mov [BmpY], ax
@@NextLine:
	mov [BmpX],0
	push cx
	push dx
	
	mov di,cx  ; Current Row at the small bmp (each time -1)
	add di,[BmpTop] ; add the Y on entire screen
	
 
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov cx,di
	shl cx,6
	shl di,8
	add di,cx
	add di,dx
	 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpColSize]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory
	cld ; Clear direction flag, for movsb
	mov cx,[BmpColSize]  
	mov si,offset ScrLine
	
	
	
@@Copying:
	cmp [byte ds:si], 255d
	je @@Transperant
	jmp @@MovsbLabel
	
@@Transperant:
	inc si
	jmp @@LoopLabel

@@MovsbLabel:
	xor ax,ax
	mov al, [ds:si]
	push ax; color
	
	mov ax ,[BmpOffX]; subing from the relative position the offset
	sub [BmpX],ax
	mov ax ,[BmpOffY]
	sub [BmpY],ax
	
	push [BmpX]; position relative to the offset
	push [BmpY]
	
	mov ax ,[BmpOffX]; adding to the ralative position the offset
	add [BmpX],ax
	mov ax ,[BmpOffY]
	add [BmpY],ax
	
	




	mov ax ,[BmpLeft]; adding to the ofsset the bmp position
	add [BmpOffX],ax
	mov ax ,[BmpTop]
	add [BmpOffY],ax
	
	
	push [BmpOffX]; offset
	push [BmpOffY]
	
	mov ax ,[BmpLeft]; subing from the offset the bmp position
	sub [BmpOffX],ax
	mov ax ,[BmpTop]
	sub [BmpOffY],ax
	
	push [BmpDeg]; degrees of rotation
	call DrawPix
	pop ax
	pop ax
	pop ax
	pop ax
	pop ax
	pop ax
	
	inc si	
@@LoopLabel:
	inc [BmpX]
	dec cx
	cmp cx,0
	je @@After
	jmp @@Copying

@@After:
	pop dx
	pop cx
	
	dec [BmpY]
	dec cx
	cmp cx,0
	je @@ret
	jmp @@NextLine

@@ret:
	pop cx
	ret
endp ShowBMPRot



;draws the given a pixel after transformation according to the angle and offset 
; push color, than push X, than push y, relative to the offset; than push offset X; than push offsetY than push angle
angle equ bp+4
offsetY equ bp+6
offsetX equ bp+8
Ypos equ bp+10
Xpos equ bp+12
color equ bp+14
proc DrawPix
	push bp
	mov bp,sp
	
	push ax
	push bx
	push cx
	push dx
	push es
	
	
	
	push [angle]
	push [Xpos]
	push [Ypos]
	call calcX
	pop ax
	pop cx
	pop cx
	
	
	push [angle]
	push [Xpos]
	push [Ypos]
	call calcY
	pop bx
	pop cx
	pop cx
	
	add bx, [offsetY]
	add ax, [offsetX]
	
	push ax
	
	mov ax,bx
	mov cx, 320
	
	mul cx
	mov bx,ax
	
	pop ax
	add bx, ax
	
	mov ax, 0A000h
	mov es, ax
	
	mov ax, [Color]
	mov [byte es:bx], al
	
	

	
	
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	
	ret
endp DrawPix

;calculate the x value of the rotated point
;push the angle, than the x value, the Y value relative to the roatation pivot
proc calcX
	push bp
	mov bp, sp
	
	push ax
	push bx
	push cx
	push dx
	
	
	
	mov ax, [bp+8]
	mov bx,2
	imul bx
	
	
	
	mov bx, ax
	mov ax, [cosTable+bx]
	imul [word bp+6]
	mov cx, ax
	
	mov ax,[bp+8]
	mov bx,2
	imul bx
	
	mov bx, ax
	mov ax, [sineTable+bx]
	imul [word bp+4]

	sub cx, ax
	
	mov ax, cx
	xor dx,dx
	test ax, 1000000000000000b
	jz @@NotNeg
	not dx
@@NotNeg:
	mov bx, 1000
	idiv bx

	mov [word bp + 4], ax

	
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 
endp calcX

;calculates the y value of the rotated point
;push the angle, than the x value, the Y value relative to the roatation pivot
proc calcY
	push bp
	mov bp, sp
	
	push ax;pushing the registers
	push bx
	push cx
	push dx
	
	
	mov ax, [bp+8]; caculating the position of the needed cosine value
	mov bx,2
	imul bx
		
	mov bx, ax ; calculating cosin*x 
	mov ax, [cosTable+bx]
	imul [word bp+4]
	
	mov cx, ax
	
	mov ax,[bp+8]; caculating the position of the needed sine value
	mov bx,2
	imul bx


	mov bx, ax; calculating sin*y
	mov ax, [sineTable+bx]
	imul [word bp+6]
	add cx, ax

	
	
	mov ax, cx
	xor dx,dx
	test ax, 1000000000000000b
	jz @@NotNeg
	not dx
@@NotNeg:
	
	mov bx, 1000
	idiv bx
	mov [bp + 4], ax
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	pop bp
	ret 
endp





























;Missiles
;-------------------------------------------------------------------------------------------------
;generates a missile in the pushed index 0-9 inclusive
IDX equ bp+4
proc genMissile
	push bp
	
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	
	mov ax, [IDX]
	mov bx, 6
	
	mul bx ; getting the offset of the requested index and putting it in si
	
	mov si, ax
	
	mov bl, 0; randoming where the misslie will come from
	mov bh, 3
	call RandomByCs
	
	cmp al, 0
	je @@Up
	cmp al, 1
	je @@Right
	cmp al, 2
	je @@Down
	cmp al, 3
	je @@Left
	
	
	
@@Up:
	mov [word Missiles+si+2],0 ;Yposition
	mov [byte Missiles+si+4], 0 ;Xspeed
	mov [byte Missiles+si+5],7; Yspeed
	
	mov bx, 30
	mov dx, 290
	call RandomByCsWord
	
	mov [word Missiles+si], ax

	jmp @@ret
	
	
	
@@Right:
	mov [word Missiles+si],319 ;Xposition
	mov [byte Missiles+si+4], -7 ;Xspeed
	mov [byte Missiles+si+5],0; Yspeed
	
	mov bx, 30
	mov dx, 170
	call RandomByCsWord
	
	mov [word Missiles+si+2], ax
	
	jmp @@ret
	
	
	
@@Down:
	mov [word Missiles+si+2],199 ;Yposition
	mov [byte Missiles+si+4], 0 ;Xspeed
	mov [byte Missiles+si+5],-7; Yspeed
	
	mov bx, 30
	mov dx, 290
	call RandomByCsWord
	
	mov [word Missiles+si], ax

	jmp @@ret
	
	
	
@@Left:
	mov [word Missiles+si],0 ;Xposition
	mov [byte Missiles+si+4], 7 ;Xspeed
	mov [byte Missiles+si+5],0; Yspeed
	
	mov bx, 30
	mov dx, 170
	call RandomByCsWord
	
	mov [word Missiles+si+2], ax
	
	jmp @@ret
	
	
	
	jmp @@ret

	
@@ret:
	
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
endp genMissile

;updates the missiles position and generates new ones if needed
proc updateMissiles
	push ax
	push bx
	push cx
	push dx
	push di
	push es

	
	xor bx,bx
	

	call CalcVelocityVector
	
	
@@LOOP:
	cmp [word Missiles+bx], -1
	jne @@NotKillMissile
	jmp @@KillMissile
	
@@NotKillMissile:
	
	xor cx,cx
	
	; updating X position
	mov cl,  [byte Missiles+bx+4]
	test cl, 80h;checking if the speed is negative or not
	jz XNotNeg
	not ch
	
XNotNeg:
	add cx, [word SpaceShipVelocityVector]
	add [word Missiles+bx],cx
	

	
	xor cx,cx;I SPENT TOO MUCH TIME TO FUCKING UNDERSTAND THAT I NEED TO ADD THIS
	
	
	; updating Y position
	mov cl,  [byte Missiles+bx+5]
	test cl, 80h;checking if the speed is negative or not
	jz YNotNeg
	not ch
YNotNeg:
	add cx, [word SpaceShipVelocityVector+2]
	add [word Missiles+bx+2],cx
	
 	
	
	cmp [word Missiles+bx], 0;checking if the missile is out of bounds, if yes, jumps to generate a new one
	jl @@KillMissileScore


	cmp [word Missiles+bx],319
	ja @@KillMissileScore

	
	cmp [word Missiles+bx+2], 0
	jl @@KillMissileScore

	
	cmp [word Missiles+bx+2],199
	ja @@KillMissileScore

	
	
	
	cmp [word Missiles+bx], 145 ;checking if the missile is touching the space ship , if yes, turns on the end game flag
	jl @@Continue
	cmp [word Missiles+bx],175
	ja @@Continue
	cmp [word Missiles+bx+2], 75
	jl @@Continue
	cmp [word Missiles+bx+2],115
	ja @@Continue
	
	mov [EndGame],1
	
	jmp @@Continue
	
	
@@KillMissileScore:
	inc [word Score]
@@KillMissile:
	mov [word Missiles+bx],-1  
	mov [word Missiles+bx+2],-1
	mov [word Missiles+bx+4],-1
	
	mov ax, bx; generating a new missile
	mov cl,6
	div cl
	xor ah,ah
	push ax
	call genMissile
	pop ax
@@Continue:
	
	mov ax, 30   ; if the score is lower than 50, only five Missiles exist, if above, ten missiles will exist
	cmp [word Score], 50
	jl @@FiveMissiles
	mov ax, 60
	
@@FiveMissiles:
	add bx,6
	cmp bx, ax
	jae @@ret
	jmp @@LOOP
	
@@ret:
	pop es
	pop di
	pop dx
	pop cx
	pop bx
	pop ax

	ret
endp updateMissiles


;draws the missiles
proc DrawMissiles
	push ax
	push bx
	push cx
	push dx
	
	
	xor bx,bx
@@LOOP:
	
	cmp [word Missiles+bx], -1
	je @@Continue
	
	push bx
	mov bh,0
	mov cx, [word Missiles+bx]
	mov dx, [word Missiles+bx+2]
	mov ah, 0Ch
	mov al,251
	int 10h
	pop bx
	
@@Continue:
	add bx,6
	cmp bx, 60
	jb @@LOOP
	

	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
endp DrawMissiles


;calculates the velocity vector(SpaceShipVelocityVector) 
;for the missiles given the spaceship's angle(bmpDeg)
ShipSpeed equ 5
proc CalcVelocityVector
	push ax
	push bx
	push cx
	push dx
	
	mov ax, [bmpDeg]
	mov bx,2
	imul bx
	mov bx,ax
	mov ax, [cosTable+bx]
	mov bx, ShipSpeed
	imul bx
	mov cx, ax
	
	
	
	mov ax, [bmpDeg]
	mov bx,2
	imul bx
	mov bx,ax
	mov ax, [sineTable+bx]
	mov bx, ShipSpeed
	imul bx


	
	xor dx,dx
	test ax, 1000000000000000b
	jz @@NotNegAx
	not dx
@@NotNegAx:
	mov bx, 1000
	idiv bx
	neg ax
	mov [SpaceShipVelocityVector], ax
	
	
	mov ax, cx
	xor dx,dx
	test ax, 1000000000000000b
	jz @@NotNegCx
	not dx
@@NotNegCx:
	mov bx, 1000
	idiv bx
	mov [SpaceShipVelocityVector+2], ax
	
	
	

	
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
endp CalcVelocityVector



;keybord inputs
proc Inputs
	push ax
	push bx
	push cx
	push dx
	
	mov ah, 1
	int 16h
	jz @@ret
	
	mov ah,1
	int 21h
	
	cmp al, 'd'
	je @@RightArrow
	
	cmp al, 'a'
	je @@LeftArrow
	
	cmp al, 27; esc key
	je @@Escape
	
	jmp @@ret
	
@@Escape:
	mov [EndGame],1
	jmp @@ret

@@RightArrow:
	add [bmpDeg], 5
	mov ax, [BmpDeg]
	mov bx,359
	xor dx,dx
	div bx
	mov [BmpDeg],dx
	jmp @@ret
		
@@LeftArrow:
	sub [word bmpDeg], 5
	
	cmp [word bmpDeg], 0
	jg @@Positive
	
	mov ax, [bmpDeg]
	mov [bmpDeg], 360
	add [bmpDeg], ax

@@Positive:
	
	
	mov ax, [BmpDeg]
	mov bx,359
	xor dx,dx
	div bx
	mov [BmpDeg],dx
	
	
@@ret:	
@@EmptyKeyboardBuffer:
	mov ah, 1
	int 16h
	jz @@pops
	
	mov ah,0
	int 16h
	jmp @@EmptyKeyboardBuffer
	
	
@@pops:	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
endp Inputs











EndOfCsLbl:
	
END start


