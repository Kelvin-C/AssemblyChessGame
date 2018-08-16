;**  ATmega128(L) Assembly Language File - IAR Assembler Syntax **

.DEVICE ATmega128

;*************************************************************************
.include "m128def.inc"
		
		jmp Init		    ; jmp is 2 word instruction to set correct vector
		nop reti			; External 0 interrupt  Vector 
		nop reti			; External 1 interrupt  Vector 
		nop reti			; External 2 interrupt  Vector 
		nop reti			; External 3 interrupt  Vector 
		nop reti			; External 4 interrupt  Vector 
		nop reti			; External 5 interrupt  Vector 
		nop reti			; External 6 interrupt  Vector 
		nop reti			; External 7 interrupt  Vector 
		nop reti			; Timer 2 Compare Vector 
		nop reti			; Timer 2 Overflow Vector 
		nop reti			; Timer 1 Capture  Vector 
		nop reti			; Timer1 CompareA  Vector 
		nop reti			; Timer 1 CompareB  Vector 
		nop reti			; Timer 1 Overflow  Vector 
		jmp TIM0_COMP		; Timer 0 Compare  Vector 
		nop reti			; Timer 0 Overflow interrupt  Vector 
		nop reti			; SPI  Vector 
		nop reti			; UART Receive  Vector 
		nop reti			; UDR Empty  Vector 
		nop reti			; UART Transmit  Vector 
		nop reti			; ADC Conversion Complete Vector 
		nop reti			; EEPROM Ready Vector 
		nop reti			; Analog Comparator  Vector 

.org		$0080			; start address well above interrupt table
;**************************************************************************
;r16 to r23 are TempRegs
.def x_shift	= r24 
.def y_shift	= r25 

RJMP Init
;*************************************************************************											 
;port B = x axis, channel 1
;port D = y axis, channel 2

X_table: ;X table [y_n, x_n ..., y1, x1]. {ld rd, -X}: load from (x1, y1), voltages length = [12-119] = 108
;1) K [1-32]
;2) Q [33-56]
;3) B [57-78]
;4) N [79-102]
;5) R [103-134]
;6) P [135-160]
;7) Player 1 message [161-169]
;8) voltages for circle (combined sine and cosine) [170-193]
;9) voltages for triangle [194-229]
;10) voltages for square [230-253]
.db 134, 130, 128, 130, 128, 130, 125, 128, 122, 125, 122, 125, 125, 128, 128, 130, 128, 130, 131, 128, 134, 125, 134, 125, 131, 128, 128, 130, 128, 130, 122, 130,\
133, 122, 132, 124, 130, 126, 129, 128, 131, 125, 131, 130, 131, 130, 122, 130, 122, 130, 122, 125, 122, 125, 131, 125,\
134, 130, 130, 125, 130, 125, 128, 130, 128, 130, 125, 125, 125, 125, 122, 130, 122, 130, 128, 130, 134, 130,\
122, 125, 126, 125, 130, 125, 134, 125, 134, 125, 130, 127, 126, 128, 122, 130, 122, 130, 126, 130, 130, 130, 134, 130,\
134, 125, 131, 128, 128, 130, 128, 130, 128, 128, 128, 125, 128, 125, 125, 125, 122, 125, 122, 125, 122, 128, 122, 130, 134, 130, 130, 130, 126, 130, 122, 130,\
128, 130, 128, 128, 128, 125, 128, 125, 125, 125, 122, 125, 122, 125, 122, 128, 122, 130, 134, 130, 130, 130, 126, 130, 122, 130,\
' ','1',' ','r','e','y','a','l','P',\
136, 122, 133, 119, 128, 117, 122, 119, 119, 122, 117, 128, 119, 133, 122, 136, 128, 138, 133, 136, 136, 133, 138, 128,\
138, 139, 138, 134, 138, 130, 138, 126, 138, 122, 138, 117, 139, 117, 134, 120, 130, 122, 126, 124, 122, 126, 117, 129, 117, 128, 122, 130, 126, 132, 130, 134, 134, 136, 139, 139,\
139, 117, 128, 117, 117, 117, 138, 117, 138, 128, 138, 139, 139, 138, 128, 138, 117, 138, 117, 139, 117, 128, 117, 117

;*************************************************************************
Y_table: ;Y table
;1) flag to indicate whether piece is first move or captured; 0 = after 1st move, 1 = captured, 2 = first move [1-32] 
;2) voltage shifts for circles (flipped) -> [y_n, x_n ..., y1, x1]. ->-> (1 King, 1 Queen, 2 Bishops, 2 Knights, 2 Rooks, 8 Pawns) ->-> ;[33-64]
;3) voltage shifts for triangles (flipped) -> [y_n, x_n ..., y1, x1]  ;[65-96]
;4) voltage shifts for square (cursor) ;[97-98]
;5) index for x-coordinate of selected chess piece ;[99]
;6) value for flag, 0 = select piece; 1 = move piece ;[100]
;7) value for flag, 1 = player 1; 2 = player 2 ;[101]
;8) emoticon flag, 0 = no face, 1 = sad face [102]
.db 2,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,2,0,0,0,0,0,2,2,2,2,2,2,2,2,2,2,\
-66, 0, -66, 22, -66, -22, -66, 44, -66, -44, -66, 66, -66, -66, -66, 88, -44, -66, -44, -44, -44, -22, -44, 0, -44, 22, -44, 44, -44, 66, -44, 88,\
88, 0, 88, 22, 88, -22, 88, 44, 88, -44, 88, 66, 88, -66, 88, 88, 66, -66, 66, -44, 66, -22, 66, 0, 66, 22, 66, 44, 66, 66, 66, 88,\
0,0, \
0,\
0,\
1,\
0		

;*************************************************************************
Init:                
		; **** Stack Pointer Setup Code ****
		; Stack Pointer Setup 
		ldi r16,$0F
		out SPH,r16		; Stack Pointer High Byte 
		ldi r16, $FF	; Stack Pointer Setup 
		out SPL,r16		; Stack Pointer Low Byte 
                                  
   		; **** RAMPZ Setup Code ****  
		ldi  r16, $00		; 1 = EPLM acts on upper 64K
		out RAMPZ, r16		; 0 = EPLM acts on lower 64K

		; ******* Sleep Mode And SRAM  *******
		ldi r16, $C0		; Idle Mode - SE bit in MCUCR not set
		out MCUCR, r16		; External SRAM Enable Wait State Enabled
   
		; ******* Comparator Setup Code ****  
		ldi r16,$80			; Comparator Disabled, Input Capture Disabled 
		out ACSR, r16		; Comparator Settings

		; **** Timer0 Setup Code ****  
		ldi r16,$0C			; Timer 0 Setup
		out TCCR0, r16		; Timer - PRESCALE TCK0 BY 256
							; (devide the 8 Mhz clock by 256)
							; clear timer on OCR0 match
		ldi r16,$FF			; load OCR0 with n=255
		out OCR0,r16		; The counter will go every n*64*125 nsec
                               
		; **** Interrupts Setup Code ****  
		ldi r16, $02		; OCIE0
		out TIMSK, r16		; T0: Output compare match 
		
        ; ******* Port A Setup Code ****  (LCD)
		ldi r16, $FF		; 
		out DDRA, r16		; Port A Direction Register
		ldi r16, $00		; Init value 
		out PORTA, r16		; Port A value
   
		; ******* Port B Setup Code ****  (Channel 1)
		ldi r16, $FF		; 
		out DDRB , r16		; Port B Direction Register
		ldi r16, $00		; Init value 
		out PORTB, r16		; Port B value
   
		; ******* Port C Setup Code ****  (LCD)
		ldi r16, $FF		; Address AD15 to AD8
		out PORTC, r16		; Port C value
   
		; ******* Port D Setup Code ****  (Channel 2)
		ldi r16, $FF		; 
		out DDRD, r16		; Port D Direction Register
		ldi r16, $00		; Init value 
		out PORTD, r16		; Port D value
   
		;******* Port E setup Code ****  (Keypad)
		ldi r16, $F0		; 0-3 output, 4-7 input
		out DDRE, r16		; Port E Direction Register
		ldi r16, $0F		; Init value 
		out PORTE, r16		; Port E value
                                   
		sei					; Enable All Interrupts 
 
		rcall init_X_table
		rcall init_Y_table
		rcall Idisp
		rcall LCDMessage_out
		rjmp main

main:
		rcall loadtableY
		rjmp main

;*******************************************************************************
; Display Initialization routine
; Follow the White-Red Book of Hitachi.
; Hitachi Liquid Crystal Disply LCD Initialization Sequence.
;
Idisp:		
		RCALL DEL10ms            ;wait 10ms for things to relax after power up           
		ldi r16, $30	         
		sts   $8000,r16
		RCALL DEL4P1ms           ;wait 4.1 msec according to Hitachi
		sts   $8000,r16	        
		rcall DEL100mus          ;wait 100 mus
		sts   $8000,r16	         
		rcall busylcd		
		ldi r16, $3F	         ;Function Set : 2 lines + 5x7 Font
		sts  $8000,r16
		rcall busylcd
		ldi r16,  $08	         ;display off
		sts  $8000, r16
		rcall busylcd		
		ldi r16,  $01	         ;display on
		sts  $8000,  r16
		rcall busylcd
		ldi r16, $38			 ;function set
		sts  $8000, r16
		rcall busylcd
		ldi r16, $0E			 ;display on
		sts  $8000, r16
		rcall busylcd
		ldi r16, $06			 ;entry mode set increment no shift
		sts  $8000,  r16
		rcall busylcd
        clr r16
        ret
;
;**********************************************************************************
; This clears the display so we can start all over again
;
CLRDIS:
	    ldi r16,$01		;Clear Display and send cursor 
		sts $8000,r16   ;to the most left position
		rcall busylcd
        ret
;**********************************************************************************
;   
busylcd:        
        lds r16, $8000   ;load LCD status
        sbrc r16, 7      ;check busy bit  7
        rjmp busylcd
        rcall DEL100mus
        ret              ;return if clear
;*************************************************************************

TIM0_COMP:
		in R4,SREG		; save Sreg
		inc r23			; increment cycle
		cpi r23,$30		; compare cycle with 200 -> total time = n(FF)*64(0C)*125 *$30(r23) ns = 99ms
		brne TIM0_COMP_ret	; if r23 = 48 jump to TIM0_COMP_ret
		clr r23 		; clear cycle and start counting 

		/***sequence of pushes to save register before using keypad functions. Sequence of pops to restore the registers after keypad functions.***/
		push r16
		push r17
		push r18
		push r19
		push r20
		push r21
		push r22
		push r24
		push r25
		push r26
		push r27
		push r28
		push r29
		push r30
		push r31
		push r0
		ldi r26,$FD	;reset
		ldi r27,$05 ;X
		ldi r28,$66 ;reset
		ldi r29,$01 ;Y
		ldi r30,0	;reset
		ldi r31,0	;Z
		call in_IO1		;Call keypad functions. 
		pop r0
		pop r31
		pop r30
		pop r29
		pop r28
		pop r27
		pop r26
		pop r25
		pop r24
		pop r22
		pop r21
		pop r20
		pop r19
		pop r18
		pop r17
		pop r16
		
TIM0_COMP_ret:
		out SREG,r4		; restore sreg	
		reti			; Timer 0 Overflow interrupt code here 

;*************************************************************************											 

LCDMessage_Out:
        LDI r18, 9	;length of messages in X table
		subi XL, 84	;length of square/circle/triangle part of X table

LCDMessage_More:
		ld r17, -X
		sts $C000, r17 ;display letter on LCD
		rcall busylcd
		dec r18
		breq LCDMessage_End
		rjmp LCDMessage_More

LCDMessage_End:  	  
		subi XL, -93	;reset X (+93)
		ret          

;*************************************************************************											 
init_X_table:	;Store 'X_table' into SRAM and make X register point to the table.
		ldi r16, 253	; length of X_table
		ldi ZL, low(X_table*2)
		ldi ZH, high(X_table*2)
		.equ init_X_address = $0500
		ldi XL, low(init_X_address)
		ldi XH, high(init_X_address)

init_X_table_loop:	;load 8-bit number at address to R0, store number into Y+
		lpm			;move one byte from PM to r0; Check Assembly 3 - page 28
		st X+,r0	;store in SRAM (and increment)
		inc ZL
		dec r16		;count down bytes copied
		brne init_X_table_loop
		ret

;*************************************************************************											 
init_Y_table:	;Store 'Y_table' into SRAM and make Y register point to the table.
		ldi r16, 102; length of Y_table
		ldi ZL, low(Y_table*2)
		ldi ZH, high(Y_table*2)
		.equ init_Y_address = $0100
		ldi YL, low(init_Y_address)
		ldi YH, high(init_Y_address)

init_Y_table_loop:	;load 8-bit number at address to R0, store number into Y+
		lpm			; move one byte from PM to r0; Check Assembly 3 - page 28
		st Y+,r0	; store in SRAM (and increment)
		inc ZL
		dec r16		; count down bytes copied
		brne init_Y_table_loop
		ret
	
;************************ PLOT OSCILLOSCOPE *************************************	

;********* LOAD TABLE Y **************							 
loadtableY:
		subi YL, 4		;Shift Y to x-coordinate of square
		ld x_shift, -Y
		ld y_shift, -Y
		ldi r18, 50		;no of times to redraw square
		rcall drawsquare
		ldi r16, 32		;no of chess pieces
		rjmp loadtableY_loop

drawsquare:
		rcall loadsquare
		dec r18
		brne drawsquare
		ret

loadtableY_loop:
		ldi r20, 64		;total no. of coordinates of all pieces

loadtableY_loop_cont:
		ldi r18, 7		;no of times to redraw each triangle/circle
		sub YL, r20		;shift Y to the flag of the piece (to see if it's captured)
		ld r21, -Y		
		add YL, r20		;reset
		subi YL, $FF	;Y
		dec r20			
		cpi r21, 1		;if piece is captured (i.e. flag = 1)
		breq skipdraw	;do not draw piece
		ld x_shift, -Y
		ld y_shift, -Y	
		
redraw_loop:
		ldi r22, 3			;number of times to redraw letter per redraw shape loop (total number of times redrawing each letter = r22*r18)
		rcall loadtableX	;draw piece
		dec r18
		brne redraw_loop	;stops drawing after r18 number of times

redraw_loop_cont:			;ran when after a piece/letter has finished drawing
		dec r16				
		brne loadtableY_loop_cont	;loops this function until all pieces are drawn
		subi YL, $BA		;shift pointer X by +70 (reset)
		ret					;jump back to main

skipdraw:
		subi YL, 2			;skip the x,y-coordinates of current piece if it's captured
		rjmp redraw_loop_cont


;********* LOAD TABLE X **************	
loadtableX:
		cpi r16, 17					;check if it is currently drawing player 1 or 2 pieces. (r16 > 16 is player 1)
		brge before_loadtriangle	;draw triangle for player 1
		rjmp before_loadcircle		;draw circle for player 2

before_loadtriangle:	;for player 1, this function will check what type of piece it needs to draw, and then it jumps to its corrsponding drawing function.
		cpi r16, 25
		brge draw_letter_pawn
		cpi r16, 23
		brge draw_letter_rook
		cpi r16, 21
		brge draw_letter_knight
		cpi r16, 19
		brge jump_draw_letter_bishop
		cpi r16, 18
		breq jump_draw_letter_queen
		cpi r16, 17
		breq jump_draw_letter_king

before_loadcircle:		;for player 2, this function will check what type of piece it needs to draw, and then it jumps to its corrsponding drawing function.
		cpi r16, 9
		brge draw_letter_pawn
		cpi r16, 7
		brge draw_letter_rook
		cpi r16, 5
		brge draw_letter_knight
		cpi r16, 3
		brge jump_draw_letter_bishop
		cpi r16, 2
		breq jump_draw_letter_queen
		cpi r16, 1
		breq jump_draw_letter_king

draw_letter_pawn:
		subi XL, 93	;shift X to the voltages for the letter P
		ldi r17, 13 ;half the no of voltages in table X for pawn

draw_letter_pawn_loop:
		ld r19, -X		 ;x-coordinate voltage of P
		add r19, x_shift ;shifts the x voltage to the piece's x-coordinate
		out portb, r19   ;output new voltage to DAC/oscilloscope

		ld r19, -X		 ;y-coordinate voltage of P
		add r19, y_shift ;shifts the y voltage to the piece's y-coordinate
		out portd, r19   ;output new voltage to DAC/oscilloscope

		dec r17	
		brne draw_letter_pawn_loop	;keeps drawing until P is fully drawn
		subi XL, -119				;shift pointer X by +119 (reset).

		dec r22					
		brne draw_letter_pawn	;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge jump_loadtriangle
		cpi r16, 17
		brlt jump_loadcircle

draw_letter_rook:
		subi XL, 119 ;shift X to the voltages for the letter R
		ldi r17, 16  ;half the no of voltages in table X for rook

draw_letter_rook_loop:
		ld r19, -X			;x-coordinate voltage of R
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of R
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17
		brne draw_letter_rook_loop	;keeps drawing until R is fully drawn
		subi XL, -151				;shift pointer X by +151 (reset).

		dec r22					
		brne draw_letter_rook	;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge jump_loadtriangle
		cpi r16, 17
		brlt jump_loadcircle

jump_loadcircle:
		rjmp loadcircle

jump_loadtriangle:
		rjmp loadtriangle

jump_draw_letter_bishop:
		rjmp draw_letter_bishop

jump_draw_letter_queen:
		rjmp draw_letter_queen

jump_draw_letter_king:
		rjmp draw_letter_king

draw_letter_knight:
		subi XL, 151;shift X to the voltages for the letter N
		ldi r17, 12 ;half the no of voltages in table X for king

draw_letter_knight_loop:
		ld r19, -X			;x-coordinate voltage of N
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of N
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17	
		brne draw_letter_knight_loop ;keeps drawing until N is fully drawn
		subi XL, -175				 ;shift pointer X by +175 (reset).

		dec r22					
		brne draw_letter_knight ;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge jump_loadtriangle
		cpi r16, 17
		brlt jump_loadcircle

draw_letter_bishop:
		subi XL, 175		;shift X to the voltages for the letter B
		ldi r17, 11			;half the no of voltages in table X for B

draw_letter_bishop_loop:
		ld r19, -X			;x-coordinate voltage of B
		add r19, x_shift	;shifts the y voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of B
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17	
		brne draw_letter_bishop_loop ;keeps drawing until P is fully drawn
		subi XL, -197				 ;shift pointer X by +197 (reset).

		dec r22		
		brne draw_letter_bishop ;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge loadtriangle
		cpi r16, 17
		brlt jump_loadcircle

draw_letter_queen:
		subi XL, 197	 ;shift X to the voltages for the letter Q
		ldi r17, 12		 ;half the no of voltages in table X for Q

draw_letter_queen_loop:
		ld r19, -X		 ;x-coordinate voltage of Q
		add r19, x_shift ;shifts the x voltage to the piece's x-coordinate
		out portb, r19	 ;output new voltage to DAC/oscilloscope

		ld r19, -X		 ;y-coordinate voltage of Q
		add r19, y_shift ;shifts the y voltage to the piece's y-coordinate
		out portd, r19	 ;output new voltage to DAC/oscilloscope

		dec r17
		brne draw_letter_queen_loop ;keeps drawing until Q is fully drawn
		subi XL, -221				;shift pointer X by +221 (reset).

		dec r22		
		brne draw_letter_queen ;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge loadtriangle
		cpi r16, 17
		brlt loadcircle

draw_letter_king:
		subi XL, 221 ;shift X to the voltages for the letter K
		ldi r17, 16	 ;half the no of voltages in table X for K

draw_letter_king_loop:
		ld r19, -X			;x-coordinate voltage of K
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of K
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17	
		brne draw_letter_king_loop ;keeps drawing until K is fully drawn
		subi XL, -253				;shift pointer X by +253 (reset).

		dec r22		
		brne draw_letter_king ;repeat until the letter P has been drawn r22*r18 times

		cpi r16, 17
		brge loadtriangle
		cpi r16, 17
		brlt loadcircle

;********** DRAW SHAPES ***************
loadsquare:
		ldi r17, 12			;half the no of voltages in table X for square

squareloop:
		ld r19, -X			;x-coordinate voltage of square
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of square
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17
		brne squareloop		;keeps drawing until square is fully drawn
		subi XL, -24		;shift pointer X by +24 (reset).
		ret

loadtriangle:
		subi XL, 24			;shift X to the voltages for the triangle
		ldi r17, 18			;half the no of voltages in table X for triangle

triangleloop:
		ld r19, -X			;x-coordinate voltage of triangle
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of triangle
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17
		brne triangleloop	;keeps drawing until triangle is fully drawn
		subi XL, -60		;shift pointer X by +60 (reset).
		ret

loadcircle:
		subi XL, 60			;shift X to the voltages for the circle
		ldi r17, 12			;half the no of voltages in table X for circle

circleloop:
		ld r19, -X			;x-coordinate voltage of circle
		add r19, x_shift	;shifts the x voltage to the piece's x-coordinate
		out portb, r19		;output new voltage to DAC/oscilloscope

		ld r19, -X			;y-coordinate voltage of circle
		add r19, y_shift	;shifts the y voltage to the piece's y-coordinate
		out portd, r19		;output new voltage to DAC/oscilloscope

		dec r17
		brne circleloop		;keeps drawing until circle is fully drawn
		subi XL, -84		;shift pointer X by +84 (reset).
		ret

/********************************* KEYPAD ******************************************/
return:	ret

;********* CHECK KEYPAD *************
in_IO1:	
		rcall IO1			;Change Port E such that 0-3 output, 4-7 input
		rcall del5mus		;Delay is necessary to change direction of Port E
		in r17, pine		;store input of Port E
		cpi r17, $0F		;If a button is pressed, go to in_IO2
		breq return			;if not pressed, return back to interrupt function

in_IO2:	
		rcall IO2			;Change Port E such that 0-3 input, 4-7 output
		rcall del5mus		;Delay is necessary to change direction of Port E
		in r18, pine		;store input of Port E
		cpi r18, $F0		;If a button is pressed, compare
		breq return			;if not pressed, return back to interrupt function

compare:					;compare/subcompare functions detect which key is pressed based on the input values
		cpi r17, $0E
		breq subcompare0
		cpi r17, $0D
		breq subcompare1
		cpi r17, $0B
		breq subcompare2
		cpi r17, $07
		breq subcompare3
		ret

subcompare0:				;compare/subcompare functions detect which key is pressed based on the input values
		cpi r18, $E0
		breq c
		ret

	c: 	subi YL, 3			;shift Y to select piece flag
		ldi r18, 0			
		st Y, r18			;set select flag to 0 (i.e. a piece is not selected)
		subi YL, $FD		;reset Y
		ret

subcompare1:				;compare/subcompare functions detect which key is pressed based on the input values
		cpi r18, $B0
		breq eight
		ret

eight: 	
		subi YL, 6			;shift Y to y-coordinate of square
		ld r18, Y			;store y-coordinate of square
		ldi r16, 88			
		CPSE r18, r16		;if y-coordinate is 88, it is not changed because it is at the edge of the board
		subi r18, $EA		;shifts the square down one grid by adding 22 (inverted Cartesian coordinates)
		st Y, r18			;stores the new square y-coordinate
		subi YL, $FA		;reset Y
		ret

subcompare2:				;compare/subcompare functions detect which key is pressed based on the input values
		cpi r18, $70
		breq four
		cpi r18, $D0
		breq six
		cpi r18, $E0
		breq e
		ret

four: 
		subi YL, 5			;shift Y to x-coordinate of square
		ld r18, Y			;store x-coordinate of square
		ldi r16, 88			
		cpse r18, r16		;if x-coordinate is 88, it is not changed because it is at the edge of the board
		subi r18, $EA		;shifts the square left one grid by adding 22 (inverted Cartesian coordinates)
		st Y, r18			;stores the new square x-coordinate
		subi YL, $FB		;reset Y
		ret

six:	subi YL, 5			;shift Y to x-coordinate of square
		ld r18, Y			;store x-coordinate of square
		ldi r16, $BE		
		cpse r18, r16		;if x-coordinate is -66, it is not changed because it is at the edge of the board
		subi r18, 22		;shifts the square right one grid by subtracting 22 (inverted Cartesian coordinates)
		st Y, r18			;stores the new square x-coordinate
		subi YL, $FB		;reset Y
		ret

e: 	
		subi YL, 1			;shfit Y to player flag
		ld r24, -Y			;store player flag
		ld r16, -Y			;shift Y and store select piece flag
		cpi r16, 0			;to select a piece
		breq select_piece
		cpi r16, 1			;to move a piece
		breq jump_move_piece
		ret

subcompare3:				;compare/subcompare functions detect which key is pressed based on the input values
		cpi r18, $B0
		breq two
		ret

two: 
		subi YL, 6			;shift Y to y-coordinate of square
		ld r18, Y			;store y-coordinate of square
		ldi r16, $BE
		cpse r18, r16		;if y-coordinate is -66, it is not changed because it is at the edge of the board
		subi r18, 22		;shifts the square up one grid by subtracting 22 (inverted Cartesian coordinates)
		st Y, r18			;stores the new square y-coordinate
		subi YL, $FA		;reset Y
		ret

/*********************** EXTENSION FROM E BUTTON *************************/

jump_move_piece:
		rjmp move_piece

;********** SELECT PIECE **********
select_piece:
		subi YL, 1		;shfit Y to player flag
		ld r16, -Y		;load x voltage shift for square
		ld r17, -Y		;load y voltage shift for square
		ldi r19, 64		;no of chess pieces *2 = total no. of their coordinates. r19 is a counter to show which piece is being compared
		rjmp e_compare_x

e_return:
		subi YL, $BA	; shift pointer Y by +70 (reset)
		ret

e_compare_x:
		ld r18, -Y		;load x-coordinate of a piece
		dec r19

		cp r16, r18		;compare x voltage
		breq e_compare_y	;if the square's x-coordinate is equal to a piece's x-coordinate, go to e_compare_y which compares their y-coordinates
	
		subi YL, 1		;shift Y by 1 to skip the y-coordinate because their x-coordinates are not equal
		dec r19
		breq e_return	;if no pieces are found to be at the square's location, Y is reset and it jumps back to the interrupt function.

		rjmp e_compare_x ;loops this function until all pieces are compared
	
e_compare_y:
		dec r19
		ld r18, -Y			;load y-coordinate of a piece

		cp r17, r18			;compare y voltage
		breq store_piece	;if a piece is found to be at the square's location, the selected piece will be checked to see if it is legal to be selected.
		cpi r19, 0
		breq e_return		;if no pieces are found to be at the square's location, Y is reset and it jumps back to the interrupt function.
		rjmp e_compare_x	;loops e_compare_x until all pieces are compared

store_piece:
		cpi r19, 32			;checks to see if the selected piece is of player 1 or 2 (player 1's piece has r19 > 32)
		brge store_piece_check_player1
		rjmp store_piece_check_player2

store_piece_check_player1:
;r24 = player 1 or 2 flag. If the current player is player 1, then the index of the selected piece's x-coordinate will be stored. Otherwise, no piece is selected.
		cpi r24, 1			
		breq store_piece_coordinates
		rjmp store_piece_reject

store_piece_check_player2:
;r24 = player 1 or 2 flag. If the current player is player 2, then the index of the selected piece's x-coordinate will be stored. Otherwise, no piece is selected.
		cpi r24, 2			
		breq store_piece_coordinates
		rjmp store_piece_reject

store_piece_coordinates:
		subi r19, 69		;r19 is now the negative of the index of the selected piece's x-coordinate
		neg r19				;r19 is now the index of the selected piece's x-coordinate
		subi YL, $FF		;reset 
		add YL, r19			;Y
		subi YL, 3			;shift to select/move flag
		ldi r18, 1			
		st Y, r18			;set select/move flag = 1
		dec YL
		st Y, r19			;store index of the x-coordinate of the selected piece
		subi YL, $FC		;reset Y
		ret

store_piece_reject:
		subi r19, 70		;reset
		sub YL, r19			;Y
		ret

;********** MOVE PIECE ***************
move_piece:
		ld r16, -Y			;index of selected piece's x-coordinate from store_piece_coordinates function
		ld r17, -Y			;x-coordinate of the square to be moved to
		ld r18, -Y			;y-coordinate of the square to be moved to
		subi YL, $FA		;reset Y 
		sub YL, r16			;shift to x-coordinate of selected chess piece
		ld r19, Y			;x-coordinate of chess piece before move
		ld r20, -Y			;y-coordinate of chess piece before move
		mov r22, r19		;copying the "x-coordinate of chess piece before move" to a new register
		mov r23, r20		;copying the "y-coordinate of chess piece before move" to a new register
		sub r19, r17		;difference between x-coordinates
		sub r20, r18		;difference between y-coordinates

compare_chess_piece:
		cpi r16, 22			;upper index for player 1 pawn
		brlt pawn
		cpi r16, 26			;upper index for player 1 rook
		brlt jump_rook
		cpi r16, 30			;upper index for player 1 knight	
		brlt jump_knight
		cpi r16, 34			;upper index for player 1 bishop
		brlt jump_bishop
		cpi r16, 36			;upper index for player 1 queen
		brlt jump_queen
		cpi r16, 38			;upper index for player 1 king
		brlt jump_king
		cpi r16, 54			;upper index for player 2 pawn
		brlt pawn
		cpi r16, 58			;upper index for player 2 rook
		brlt jump_rook
		cpi r16, 62			;upper index for player 2 knight
		brlt jump_knight
		cpi r16, 66			;upper index for player 2 bishop
		brlt jump_bishop
		cpi r16, 68			;upper index for player 2 queen
		brlt jump_queen
		cpi r16, 70			;upper index for player 2 king
		brlt jump_king

;********* PAWN ***********
pawn:
		subi YL, $FF	;reset
		add YL, r16		;Y
		mov r21, r16	;copy the selected piece's x-coordinate index to r21
		subi r21, 7		
		lsr r21			;divide by 2 by shifting bits
		subi r21, $B9	;plus 71
		sub YL, r21		;r21 is index of firstmove flag
		ld r24, Y		;chess piece first move flag
		add YL, r21		;reset Y
		subi YL, 2		;shift Y to player flag
		ld r25, Y		;load player flag to r25
		subi YL, $FE	;reset Y

		cpi r19, 0			;check for forward movement
		breq pawn_firstmove_check
		cpi r19, 22			;diagonal movement
		breq pawn_player_check
		cpi r19, -22		;diagonal movement
		breq pawn_player_check
		rjmp reject_move	;reject move if illegal move

pawn_firstmove_check:
		cpi r24, 2			;check first move
		breq pawn_firstmove_player_check
		cpi r24, 0			;if not first move and not captured...
		breq pawn_player_check

pawn_firstmove_player_check:
		cpi r25, 1			;check if player is player 1
		breq p1_pawn_firstmove
		rjmp p2_pawn_firstmove

jump_rook:
		rjmp rook

jump_knight:
		rjmp knight

jump_bishop:
		rjmp bishop

jump_queen:
		rjmp queen

jump_king:
		rjmp king

p1_pawn_firstmove:
		cpi r20, 22		;check if it is a forward move of one grid
		breq jump_checkoccupy
		cpi r20, 44		;check if it is a forward move of two grids
		breq checkblock_vertical
		rjmp reject_move

p2_pawn_firstmove:
		cpi r20, -22	;check if it is a forward move of one grid
		breq jump_checkoccupy
		cpi r20, -44	;check if it is a forward move of two grids
		breq checkblock_vertical	
		rjmp reject_move

pawn_player_check:
		cpi r25, 1		;check if player is player 1
		breq p1_move_pawn
		cpi r25, 2		;check if player is player 2
		breq p2_move_pawn
		rjmp reject_move

p1_move_pawn:
		cpi r20, 22		;check if it is a forward move of one grid
		breq jump_checkoccupy
		rjmp reject_move

p2_move_pawn:
		cpi r20, -22	;check if it is a forward move of one grid
		breq jump_checkoccupy
		rjmp reject_move

jump_checkoccupy:
		rjmp checkoccupy

;********** ROOK *************
rook:
		subi YL, $FF		; reset
		add YL, r16			; Y
		ldi r21, 0			;flag to show the piece to be moved is not king or pawn
		cpi r19, 0					;check x-shift = 0
		breq checkblock_vertical	;check if vertically move upwards or downwards
		cpi r20, 0					;check y-shift = 0
		breq checkblock_horizontal	;check if horizontally move to the left or right
		ret

;***************** CHECK BLOCK NON-DIAGONAL ***********
checkblock_vertical:
;Checks if any pieces are blocking the movement.
		cp r23, r18		;compare y-coordinate of the chess piece and square square.
		brge checkblock_vertical_pos ;check upward blocks
		rjmp checkblock_vertical_neg ;check downward blocks

checkblock_horizontal:
;Checks if any pieces are blocking the movement.
		cp r22, r17
		brge checkblock_horizontal_pos ;check right blocks
		rjmp checkblock_horizontal_neg ;check left blocks
	
checkblock_vertical_pos:
		subi r20, 22			;keep shifting until all locations are checked
		cpi r20, 0				;if no blocking
		breq jump_checkoccupy	
		subi r23, 22			;shift up one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_vertical_pos  ;loops checkblock_vertical_pos until there is no blocking or a blocking is found

checkblock_vertical_neg:		
		subi r20, -22			;keep shifting until all locations are checked
		cpi r20, 0				;if no blocking
		breq jump_checkoccupy
		subi r23, -22			;shift down one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_vertical_neg  ;loops checkblock_vertical_neg until there is no blocking or a blocking is found

checkblock_horizontal_pos:
		subi r19, 22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq checkblock_check_if_castling_right ;check if the movement is right castling
		subi r22, 22			;shift right one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_horizontal_pos ;loops checkblock_horizontal_pos until there is no blocking or a blocking is found

checkblock_horizontal_neg:
		subi r19, -22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq checkblock_check_if_castling_left ;check if the movement is left castling
		subi r22, -22			;shift left one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_horizontal_neg ;loops checkblock_horizontal_neg until there is no blocking or a blocking is found

checkblock_check_if_castling_right:
		cpi r21, 86				;check if the piece to be moved is player 1's king
		breq king_castling_right_rook_confirm_move
		cpi r21, 102			;check if the piece to be moved is player 2's king
		breq king_castling_right_rook_confirm_move
		rjmp jump_checkoccupy

checkblock_check_if_castling_left:	
		cpi r21, 86				;check if the piece to be moved is player 1's king
		breq king_castling_left_rook_confirm_move
		cpi r21, 102			;check if the piece to be moved is player 2's king
		breq king_castling_left_rook_confirm_move
		rjmp jump_checkoccupy

king_castling_right_rook_confirm_move:
		sub YL, r16		;shift Y to the x-coordinate \
		subi YL, -12	;of right rook
		ldi r25, -22 
		st Y, r25		;set x-coordinate of right rook to be -22 (y-coordinate unchanged)
		subi YL, 12		;reset
		add YL, r16		;Y

		sub YL, r21		;r21 is index of flag for king.
		subi YL, -6		;shift to right rook's flag
		ldi r25, 0		
		st Y, r25		;set right rook's flag to 0 (i.e after first-move)
		subi YL, 6		;reset
		add YL, r21		;Y
		rjmp confirm_move
	
king_castling_left_rook_confirm_move:
		sub YL, r16		;shift Y to the x-coordinate \
		subi YL, -14	;of left rook
		ldi r25, 22 
		st Y, r25		;set x-coordinate of left rook to be 22 (y-coordinate unchanged)
		subi YL, 14		;reset
		add YL, r16		;Y

		sub YL, r21		;r21 is index of flag for king.
		subi YL, -7		;shift to left rook's flag
		ldi r25, 0		;
		st Y, r25		;set left rook's flag to 0 (i.e after first-move)
		subi YL, 7		;reset
		add YL, r21		;Y
		rjmp confirm_move


;*********** CHECK FOR BLOCK (called by Rook, Bishop, Queen, Pawn) ***********
checkblock_compare_loop: 
		ldi r24, 64 ;total no of coordinates of all pieces
		subi YL, 6	;shift Y to x-coordiante of first chess piece 
		rcall checkblock_compare_x	;compare x-coordinate of the selected chess piece with x coordiantes of chess pieces in the table
		ret

checkblock_compare_x:
;compare x-coordinate of the selected chess piece with x coordiantes of chess pieces in the table
		ld r25, -Y	;load x-coordiante of chess piece
		dec r24	
		cp r22, r25 ;compare x-coordinates
		breq checkblock_compare_y ;if the selected piece's x-coordinate is equal to the x-coordinate of a piece in the table, go to checkblock_compare_y which compares their y-coordinates
		subi YL,1	;shifts Y to y-coordinate of chess piece
		dec r24
		breq checkblock_reset	;if no blocking is found, reset Y and return
		rjmp checkblock_compare_x ;loops checkblock_compare_x until all pieces are checked

checkblock_compare_y:
;compare x-coordinate of the selected chess piece with x coordiantes of chess pieces in the table
		dec r24
		ld r25, -Y ;load y-coordiante of chess piece
		cp r23, r25 ;compare y-coordinates
		breq checkblock_rejectmove ;if the selected piece's y-coordinate is equal to the y-coordinate a piece in the table, reset Y and reject move
		cpi r24, 0
		breq checkblock_reset ;if no blocking is found, reset Y and return
		rjmp checkblock_compare_x ;loops checkblock_compare_x until all pieces are checked

checkblock_reset:
		subi YL, $BA; shift pointer Y by +70 (reset)
		ret

checkblock_rejectmove:
		subi r24, 69
		subi YL, $FF ;reset
		sub YL, r24  ;Y
		;sequence of pops to offset the two rcalls
		pop r24
		pop r24
		pop r24
		pop r24
		rjmp reject_move

;*********** KNIGHT ***********
knight:
		subi YL, $FF ;reset
		add YL, r16	 ;Y
		ldi r21, 0			;flag to show the piece to be moved is not king or pawn
		cpi r19, 44			;check is there is a horizontal move of two grids to the right
		breq knight_check1
		cpi r19, -44
		breq knight_check1  ;check is there is a horizontal move of two grids to the left
		cpi r19, 22
		breq knight_check2	;check is there is a horizontal move of one grid to the right
		cpi r19, -22
		breq knight_check2	;check is there is a horizontal move of one grid to the left
		rjmp reject_move

knight_check1:
		cpi r20, 22				;check is there is a vertical move of one grid upwards
		breq jump_checkoccupy1
		cpi r20, -22			;check is there is a vertical move of one grid downwards
		breq jump_checkoccupy1
		rjmp reject_move

knight_check2:
		cpi r20, 44				;check is there is a vertical move of two grids upwards
		breq jump_checkoccupy1
		cpi r20, -44			;check is there is a vertical move of two grids downwards
		breq jump_checkoccupy1
		rjmp reject_move

jump_checkoccupy1:
		rjmp checkoccupy

jump_checkblock_vertical:
		rjmp checkblock_vertical

jump_checkblock_horizontal:
		rjmp checkblock_horizontal

;********* BISHOP ***********
bishop:
		subi YL, $FF ;reset
		add YL, r16	 ;Y
		ldi r21, 0	 ;flag to show the piece to be moved is not king or pawn
		cp r19, r20  ;check shift is along the x = y line
		breq checkblock_xy
		neg r19		;take the negative of r19
		cp r19, r20 ;check shift is along the x = -y line
		breq checkblock_xy_opp
		rjmp reject_move

;********* CHECK BLOCK DIAGONAL ***********	
checkblock_xy: ;x=y line
		cp r22, r17				;compare x-coordinate of the selected chess piece with x-coordiante of the square. If r22 > r17, check blocks on RHS. otherwise, check blocks on LHS.
		brge checkblock_xy_right 
		rjmp checkblock_xy_left

checkblock_xy_opp: ;x=-y line
		neg r19
		cp r22, r17				;compare x-coordinate of the selected chess piece with x-coordiante of the square. If r22 > r17, check blocks on RHS. otherwise, check blocks on LHS.
		brge checkblock_xy_opp_right
		rjmp checkblock_xy_opp_left

checkblock_xy_right:
		subi r19, 22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq jump_checkoccupy1	
		subi r22, 22			;shift right one grid
		subi r23, 22			;shift up one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_xy_right	;loops checkblock_xy_right until all pieces are compared

checkblock_xy_left:
		subi r19, -22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq jump_checkoccupy1	
		subi r22, -22			;shift left one grid
		subi r23, -22			;shift down one grid
		rcall checkblock_compare_loop ;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_xy_left	;loops checkblock_xy_left until all pieces are compared

checkblock_xy_opp_right:
		subi r19, 22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq jump_checkoccupy1
		subi r22, 22			;shift right one grid
		subi r23, -22			;shift down one grid
		rcall checkblock_compare_loop	;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_xy_opp_right	;loops checkblock_xy_left until all pieces are compared

checkblock_xy_opp_left:
		subi r19, -22			;keep shifting until all locations are checked
		cpi r19, 0				;if no blocking
		breq jump_checkoccupy1
		subi r22, -22			;shift left one grid
		subi r23, 22			;shift up one grid
		rcall checkblock_compare_loop	;compare the shifted coordinates with the coordinates of the pieces in the table
		rjmp checkblock_xy_opp_left		;loops checkblock_xy_opp_left until all pieces are compared

;********** QUEEN ***************
queen:
		subi YL, $FF	;reset
		add YL, r16		;Y
		ldi r21, 0		;flag to show the piece to be moved is not king or pawn
		cpi r19, 0		;check if move is vertical
		breq jump_checkblock_vertical
		cpi r20, 0		;check if move is horizontal
		breq jump_checkblock_horizontal
		cp r19, r20		;check move is a shift is along the x = y line
		breq checkblock_xy
		neg r19
		cp r19, r20		;check move is a shift is along the x = -y line
		breq checkblock_xy_opp
		rjmp reject_move

;********** KING ****************
king:
		subi YL, $FF	;reset
		add YL, r16		;Y

		mov r21, r16	;copy the index of selected piece's x-coordinate to r21
		subi r21, 7		
		lsr r21			;divide by 2 by shifting bits
		subi r21, $B9	;plus 71
		sub YL, r21		;r21 is index of king's flag
		ld r24, Y		;king's flag
		add YL, r21		;reset Y

		cpi r20, 0		;check if not moving vertically
		breq king_check_castling
		cpi r20, 22		;check if move up by 1 grid
		breq king_check_horizontal
		cpi r20, -22	;check if move down by 1 grid
		breq king_check_horizontal
		rjmp reject_move

king_check_castling:
		cpi r24, 2		;check if it is king's first move
		brne king_check_horizontal
		cpi r19, 44		;check if move right by 2 grid
		breq king_castling_right
		cpi r19, -44	;check if move left by 2 grid
		breq king_castling_left

king_check_horizontal:
		cpi r19, 0	 ;check if not moving horizontally
		breq checkoccupy
		cpi r19, 22  ;check if move right by 1 grid
		breq checkoccupy
		cpi r19, -22 ;check if move left by 1 grid
		breq checkoccupy
		rjmp reject_move

king_castling_left:
		sub YL, r21		;shift Y to the flag\
		subi YL, -7		;of left rook
		ld r25, Y		;load flag of left rook
		subi YL, 7		;reset
		add YL, r21		;Y
		ldi  r24, 2	
		cpse r25, r24	;check if it is first move of left rook
		rjmp reject_move
		subi r19, 44	;increases the range of checkblock. so checkblock for both king and rook at the same time.
		rjmp checkblock_horizontal

king_castling_right:
		sub YL, r21		;shift Y to the flag\
		subi YL, -6		;of right rook
		ld r25, Y		;load flag of right rook
		subi YL, 6		;reset
		add YL, r21		;Y
		ldi  r24, 2
		cpse r25, r24	;check if it is first move of right rook
		rjmp reject_move
		subi r19, -22	;increases the range of checkblock. so checkblock for both king and rook at the same time.
		rjmp checkblock_horizontal

	
;******** CHECK IF GRID IS OCCUPIED *************
checkoccupy:
		subi YL, 2	 ;shift Y to play flag
		ld r24, Y	 ;load player flag to r24
		subi YL, 4	 ;shift Y to x-coordinate of first chess piece in the table
		ldi r20, 64  ;r20 is the total no of coordinates of all pieces
		rjmp checkoccupy_compare_x

checkoccupy_nooccupy:
		subi YL, $BA ;shift pointer Y by +70 (reset)
		cpi r21, 86
		breq jump_confirm_move
		cpi r21, 102
		breq confirm_move
		cpi r21, 0		;check if pawn. r21 = 0 if not pawn
		brne pawn_nooccupy_check_diagonal
		rjmp confirm_move

jump_confirm_move:
		rjmp confirm_move

pawn_nooccupy_check_diagonal:
		cpi r19, 0		;if x-shift is 0 -> not diagonal move
		breq confirm_move
		rjmp reject_move	

checkoccupy_compare_x:
;compare x-coordinate of the selected chess piece with x coordiantes of chess pieces in the table
		ld r22, -Y		;load x-coordiante of chess piece
		dec r20
		cp r17, r22		;compare x-coordinates
		breq checkoccupy_compare_y ;if the selected piece's x-coordinate is equal to the x-coordinate of a piece in the table, go to checkblock_compare_y which compares their y-coordinates
		subi YL, 1		;shifts Y to y-coordinate of chess piece
		dec r20
		breq checkoccupy_nooccupy  ;if no blocking is found, go to checkoccupy_nooccupy
		rjmp checkoccupy_compare_x ;loops checkoccupy_compare_x until all pieces are checked
	
checkoccupy_compare_y:
;compare y-coordinate of the selected chess piece with x coordiantes of chess pieces in the table
		dec r20
		ld r23, -Y		;load y-coordiante of chess piece
		cp r18, r23		;compare y-coordinates
		breq checkoccupy_occupied ;if the selected piece's y-coordinate is equal to the y-coordinate a piece in the table, go to checkoccupy_occupied
		cpi r20, 0
		breq checkoccupy_nooccupy  ;if no blocking is found,  go to checkoccupy_nooccupy
		rjmp checkoccupy_compare_x ;loops checkblock_compare_x until all pieces are checked

checkoccupy_occupied:
		cpi r20, 32 ;if occupied by player 1's pieces
		brge checkoccupy_occupied_check_player1
		rjmp checkoccupy_occupied_check_player2

checkoccupy_occupied_check_player1:
		rcall checkoccupy_reset
		cpi r24, 1			;r24 = player 1 or 2 flag. If player 1...
		breq jump_reject_move
		rjmp check_if_pawn

checkoccupy_occupied_check_player2:
		rcall checkoccupy_reset
		cpi r24, 2			;r24 = player 1 or 2 flag. If player 2...
		breq jump_reject_move
		rjmp check_if_pawn

check_if_pawn:
		cpi r21, 86
		breq setcapturedflag
		cpi r21, 102
		breq setcapturedflag
		cpi r21, 0	;check if pawn. r21 = 0 if not pawn
		brne pawn_yesoccupy_check_vertical
		rjmp setcapturedflag

pawn_yesoccupy_check_vertical:
		cpi r19, 0		;if x-shift is 0 -> vertical move
		breq jump_reject_move
		rjmp setcapturedflag

jump_reject_move:
		rjmp reject_move

checkoccupy_reset:
		subi r20, 69		;r20 is now the index of x-coordinate of captured chess piece (r20 is negative)
		neg r20
		subi YL, $FF		;reset due to pre-decrement
		add YL, r20			;reset YL
		ret

setcapturedflag:
		sub YL, r20		;shift Y to x-coordinate of captured piece 
		ldi r25, 10		;new coordinate for dead pieces
		st Y, r25		;dead piece now has 10 for x-coordinate
		dec YL			;shift Y to y-coordinate of captured piece
		st Y,r25		;dead piece now has 10 for y-coordinate
		inc YL			;reset
		add YL, r20		;Y
						;convert r20 (x-coordinate index of captured piece) into index of capture flag of the dead piece
		subi r20, 7		;1) r20 minus 7 so that the first capture piece's x-coordinate corresponds to r20 = 0
		lsr r20			;2) divide by 2 by shifting 1 bit to the right
		subi r20, $B9	;3) plus 71 so r20 is now index of capture flag of dead piece
		sub YL, r20		;Y is now at the capture flag of the dead piece
		ldi r25, 1
		st Y, r25		;Set capture flag of dead piece to 1 (makes the piece dead)
		add YL, r20		;Reset Y

confirm_move:
		sub YL, r16	;Y is shifted to the x-coordinate of the selected chess piece
		st Y, r17	;overwrite x-coordinate to square x-coordinate
		dec YL
		st Y, r18	;overwrite y-coordinate to square y-coordinate
		subi YL, $FF ; reset
		add YL, r16	; Y
		cpi r21, 0		;if a piece that's not pawn is moved
		breq set_to_selectpiece

firstmove_flagchange:
		sub YL, r21		;r21 is index of flag for pawn/king. r21 = 0 for other pieces.
		ldi r25, 0		
		st Y, r25		;set flag to 0 (i.e after first-move)
		add YL, r21		;reset Y
		rjmp set_to_selectpiece

set_to_selectpiece:		;change the 'select or move' flag to 0
		subi YL, 3	;shift Y to 'select piece' flag
		ldi r25, 0 
		st Y, r25	;set 'select or move' flag to 0 (i.e. change to select piece)
		subi YL, $FD	;reset Y
		ld r24, -Y		;emoticon flag
		inc YL			;reset Y

checkwin:
		subi YL, 86		;move to player 1 king capture flag
		ld r25, Y		;store capture flag value to r25
		subi YL, $AA	;reset Y (+86)
		cpi r25, 1		;if game is won
		breq win_message

		subi YL, 102	;move to player 2 king capture flag
		ld r25, Y		;store capture flag value to r25
		subi YL, $9A	;reset Y (+102)
		cpi r25, 1		;if game is won
		breq win_message
		rjmp set_to_selectpiece_cont

win_message:
;Display WIN message on the LCD screen. Also removes the 'sad face' on the LCD screen.
		ldi r25, 0		;used to compare on next line
		cpse r24, r25	;skip 'clearface' function if no emoticon is displayed on the LCD screen
		rcall jump_clearface

		ldi r25, $57	; W
		sts $C000, r25
		rcall busylcd
		ldi r25, $49	; I
		sts $C000, r25
		rcall busylcd
		ldi r25, $4E	; N
		sts $C000, r25
		rcall busylcd

		ret

set_to_selectpiece_cont:
		subi YL,2				;shift Y to player flag
		ld r25, Y				;load player flag to r25
		cpi r25, 1				;if player 1
		breq jump_set_player2	;change to player 2 by changing flag
		rjmp set_player1		;if player is player 2, change to player 1 by changing flag

jump_clearface:
		rjmp clearface

set_player1:
		ldi r16, 1		
		st Y, r16		;update player flag to 1
		subi YL, $FE	;reset Y
	
		ldi r17, 0
		cpse r24, r17	;if emoticon is not on the LCD screen
		rcall clearface	;clear the sad face if it's on the screen

		ldi r25, $10	 
		sts $8000, r25	;shift left 
		rcall busylcd
		sts $8000, r25	;shift left 
		rcall busylcd
		ldi r25, $31	;write '1'
		sts $C000, r25
		rcall busylcd
		ldi r25, $20	;spacebar
		sts $C000, r25
		ret

jump_set_player2:
		rjmp set_player2

clearface:
		dec YL			;shift Y to emoticon flag
		ldi r25, 0		
		st Y, r25		;set emoticon flag to 0. flag 0 = no face	
		inc YL			;reset Y

		ldi r25, $10	
		sts $8000, r25	;shift left 
		rcall busylcd
		sts $8000, r25	;shift left 
		rcall busylcd
		sts $8000, r25	;shift left 
		rcall busylcd
		ldi r25, $20	
		sts $C000, r25	;write space
		rcall busylcd
		sts $C000, r25	;write space
		rcall busylcd
		sts $C000, r25	;write space
		rcall busylcd	
		ldi r25, $10
		sts $8000, r25 	;shift left 
		rcall busylcd
		sts $8000, r25	;shift left 
		rcall busylcd
		ret

set_player2:
		ldi r16, 2		
		st Y, r16		 ;update flag to 2 for player 2
		subi YL, $FE	 ;reset Y

		ldi r17, 0
		cpse r24, r17	;skip clearface function if emoticon is not on the LCD screen
		rcall clearface	;clear the sad face if it's on the screen

		ldi r25, $10
		sts $8000, r25	;shift left 
		rcall busylcd
		sts $8000, r25	;shift left 
		rcall busylcd
		ldi r25, $32	;write '2'
		sts $C000, r25
		rcall busylcd
		ldi r25, $20	;write space
		sts $C000, r25
		ret

reject_move:
		ld r25, -Y		;shift Y to emoticon flag
		ldi r24, 1		;used to compare if emoticon flag is 1
		cpse r25, r24	;if LCD screen is showing sad face, skip next line
		rcall sadface	;if no face on the LCD screen, display a sad face to indicate an illegal move.
		inc YL			;reset Y
		ret

sadface:
		ldi r25, 1		
		st Y, r25		;set emoticon flag to 1
		ldi r25, $3A	;write ':'
		sts $C000, r25
		rcall busylcd
		ldi r25, $28	;write '('
		sts $C000, r25
		rcall busylcd
		ret

IO1:	; ******* Port E setup Code ****  
		ldi r16, $F0		; 0-3 output, 4-7 input
		out DDRE, r16		; Port E Direction Register
		ldi r16, $0F		; Init value 
		out PORTE, r16		; Port E value
		ret

IO2:	; ******* Port E setup Code ****  
		ldi r16, $0F		; 0-3 input, 4-7 output
		out DDRE, r16		; Port E Direction Register
		ldi r16, $F0		; Init value 
		out PORTE, r16		; Port E value
		ret

;
;********************   DELAY ROUTINES ********************************************
;
DEL10ms:
; This is a 10 msec delay routine. Each cycle costs
; rcall           -> 3 CC
; ret             -> 4 CC
; 2*LDI        -> 2 CC 
; SBIW         -> 2 CC * 19997
; BRNE         -> 2 CC * 19997
            LDI ZH, HIGH(19997)
            LDI ZL, LOW (19997)
COUNT:  
            SBIW ZL, 1
            BRNE COUNT
            RET
;
DEL4P1ms:
            LDI ZH, HIGH(8198)
            LDI ZL, LOW (8198)
COUNT1:
            SBIW ZL, 1
            BRNE COUNT1
            RET 
;
DEL100mus:
            LDI ZH, HIGH(198)
            LDI ZL, LOW (198)
COUNT2:
            SBIW ZL, 1
            BRNE COUNT2
            RET 

DEL5mus:	
            LDI ZH, HIGH(8)
            LDI ZL, LOW (8)
COUNT3:
            SBIW ZL, 1
            BRNE COUNT3
            RET 





