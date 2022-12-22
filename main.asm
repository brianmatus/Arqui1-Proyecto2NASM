%include "code/macros.asm"

SECTION .rodata

main_title_s:		db "~~~~~~~~~~~~~~~~~~~~~~~~","$"
main_title:			db 'Proyecto Unico Assembler - NASM',"$"
main_inst1:			db "Ingrese el numero de la opcion que desea:","$"
str_press_any:		db "Presione cualquier tecla para continuar","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
main_option1:		db 0x9, "1)Ingresar funcion", 0xA,0dh,"$"
main_option2:		db 0x9, "2)Imprimir la funcion almacenada", 0xA,0dh,"$"
main_option3:		db 0x9, "3)Imprimir la la derivada de la funcion almacenada", 0xA,0x0D,"$"
main_option4:		db 0x9, "4)Imprimir la la integrada de la funcion almacenada", 0xA,0dh,"$"
main_option5:		db 0x9, "5)Graficar funcion original, derivada o integral", 0xA,0dh,"$"
main_option6:		db 0x9, "6)Encontrar ceros mediante metodo de Newton", 0xA,0dh,"$"
main_option7:		db 0x9, "7)Encontrar ceros mediante metodo de Steffensen", 0xA,0dh,"$"
main_option8:		db 0x9, "8)Salir", 0xA,0dh,"$"
input_error_1:		db "La opcion ingresada no es valida", 0xA,0dh,"$"
input_error_2:		db "El texto ingresado no es valido", 0xA,0dh,"$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
enter_coef_5:		db "Ingrese el coeficiente para x^5:","$"
enter_coef_4:		db "Ingrese el coeficiente para x^4:","$"
enter_coef_3:		db "Ingrese el coeficiente para x^3:","$"
enter_coef_2:		db "Ingrese el coeficiente para x^2:","$"
enter_coef_1:		db "Ingrese el coeficiente para x^1:","$"
enter_coef_0:		db "Ingrese el coeficiente para x^0:","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
str_x_5:			db "x^5  ","$"
str_x_4:			db "x^4  ","$"
str_x_3:			db "x^3  ","$"
str_x_2:			db "x^2  ","$"
str_x_1:			db "x^1  ","$"
str_x_0:			db "  ","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
deleteme_test: 		db "1",0, "$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
options_array:		dw main_option1,main_option2,main_option3,main_option4,main_option5,main_option6,main_option7,main_option8
text_ln_r:			db 0xA,0dh, "$"

SECTION .data
screenX:			dw 0x0
screenY:			dw 0x0

coef_5: 			dw 5  ; x^5
coef_5_sign: 		db 0
coef_4: 			dw 0  ; x^4
coef_4_sign: 		db 0
coef_3: 			dw 0 ; x^3
coef_3_sign: 		db 0
coef_2: 			dw 0  ; x^2
coef_2_sign: 		db 0
coef_1: 			dw 0  ; x
coef_1_sign: 		db 0
coef_0: 			dw 0  ; constant
coef_0_sign: 		db 0

draw_fill_rect_w:	dw 0x0
draw_fill_rect_w_c:	dw 0x0
draw_fill_rect_h:	dw 0x0

inStrBuf_p:				dw 0x0
inStrBuf:  				times 30 db 0x0
gen_output_buff: 		times 30 db 0x0

SECTION .bss


SECTION .text

global _start
	 bits 16		;It's 16bit (for DOS)
	 org 0x100	  	;It's a .COM program (Start program at offset 100h)

_start:
	call UserMainOptionInput

;	mov word [screenX], 0x140
;	mov word [screenY], 0x0F0
;	mov word [draw_fill_rect_w], 0x1E
;	mov word [draw_fill_rect_h], 0xA
;	call DrawFilledRectangle
	call ExitApplication



EnterFunctionCoefficients:

	;COEF x^5
	MACRO_ENTER_COEFFICIENT 5
	;COEF x^4
	MACRO_ENTER_COEFFICIENT 4
	;COEF x^3
	MACRO_ENTER_COEFFICIENT 3
	;COEF x^2
	MACRO_ENTER_COEFFICIENT 2
	;COEF x^1
	MACRO_ENTER_COEFFICIENT 1
	;COEF x^0
	MACRO_ENTER_COEFFICIENT 0
	ret



ParseString:	;[SI] as pointer,   returns: AX: result BX: sign  CX:return code
    xor ax, ax ; clear ax
    xor bx, bx ; clear bx
    xor cx, cx ; clear cx

    mov di, 10 ; set the base to 10

	;TODO checar primer caracter por un signo

	mov bl, [SI] ; load the current character into bl

	cmp bx, '+'
	jne ParseString_check_minus
	inc si ; move to the next character
	jmp ParseString_is_positive

	ParseString_check_minus:
	cmp bx, '-'
	jne ParseString_is_positive
	push 0x1	;Flag as negative
	inc si 		; move to the next character

	jmp parse_loop

	ParseString_is_positive:
	push 0x0	;Flag as possitive

	parse_loop:
    mov bl, [SI] ; load the current character into al
    inc si ; move to the next character

    cmp bl, 0x0 		;have we reached the end of the number?
    je  parse_done

	cmp bx, '0'			;Is this not a number char? (lower half)
	jl parse_error
	cmp bx, '9'			;Is this not a number char? (upper half)
	jg parse_error

    sub bx, '0' 		; subtract the ASCII value of '0' to get the actual numeric value
    mul di		 		; multiply the current result by the base (10)
    add ax, bx 			; add the digit to the result

    jmp parse_loop ; continue parsing the next character

	parse_done:
	mov CX, 0			;Exit code 0 for success, 1 for input error
	pop BX
;	cmp BX, 0
;	je ParseString_not_negative_result
;	neg AX
;	ParseString_not_negative_result
    ret

    parse_error:
    mov CX, 1
;    pop BX
	add esp, 2
    ret


ReadUntilLN:

	mov DI, inStrBuf		;Put start of str ptr into inStrBuf_p
	mov [inStrBuf_p], DI

	ReadUntilLN_loop:
	mov AH, 0x8		;User input without echo
	int 0x21		;DOS Function Dispatcher

	cmp AL, 0xD				;Compare to \r
	je ReadUntilLN_done

	mov DI, [inStrBuf_p]		;Put char pointer in DI
	mov [DI], AL				;Set value to the read char
	inc byte [inStrBuf_p]		;Increment pointer

	;Feedback entered char to user
	mov AH, 0x6		;Direct I/O
	mov DL, AL		;
	int 0x21
	jmp ReadUntilLN_loop

	ReadUntilLN_done:
	mov DI, [inStrBuf_p]
	mov byte [DI], 0x0
	inc DI
	mov byte [DI], 0x24		;$
	ret


UserMainOptionInput:
	CLEARSCREEN
	call PrintMainMenu
	mov AH, 0x8		;User input without echo
	int 0x21		;DOS Function Dispatcher

	;Compare all posible entrys
	cmp al, '1'
	jne option_2
	call EnterFunctionCoefficients
	jmp UserMainOptionInput

	option_2:
	cmp al, '2'
	jne option_3
	call PrintStoredFunction
	jmp UserMainOptionInput

	option_3:
	cmp al, '3'
	jne option_4
	call PrintFunctionDerivative
	jmp UserMainOptionInput

	option_4:
	cmp al, '4'
	jne option_5
	call PrintFunctionIntegral
	jmp UserMainOptionInput

	option_5:
	cmp al, '5'
    jne option_6
    call GraphFunction
	jmp UserMainOptionInput

    option_6:
    cmp al, '6'
    jne option_7
    call SolveByNewton
	jmp UserMainOptionInput

    option_7:
    cmp al, '7'
    jne option_8
    call SolveBySteffensen
	jmp UserMainOptionInput

    option_8:
    cmp al, '8'
    jne option_unknown
    call ExitApplication
	jmp UserMainOptionInput

    option_unknown:
    CLEARSCREEN
	call PrintMainMenu
	MACRO_PRINT_STRING input_error_1
	jmp UserMainOptionInput


PrintStoredFunction:

	cmp [coef_5], word 0
	je PrintStoredFunction_skip_5
	cmp [coef_5_sign], byte 0
	je PrintStoredFunction_5_pos
	MACRO_PRINT_CHAR 0x2d		; -
	PrintStoredFunction_5_pos:
	MACRO_PARSE_COEFFICIENT_WITHOUT_SIGN_TO_STRING 5
	MACRO_PRINT_STRING gen_output_buff
	MACRO_PRINT_STRING str_x_5

	PrintStoredFunction_skip_5:

	cmp [coef_4], word 0
	je PrintStoredFunction_skip_4
	MACRO_PRINT_FUNC_COEF 4

	PrintStoredFunction_skip_4:
	cmp [coef_3], word 0
	je PrintStoredFunction_skip_3
	MACRO_PRINT_FUNC_COEF 3

	PrintStoredFunction_skip_3:
	cmp [coef_2], word 0
	je PrintStoredFunction_skip_2
	MACRO_PRINT_FUNC_COEF 2

	PrintStoredFunction_skip_2:
	cmp [coef_1], word 0
	je PrintStoredFunction_skip_1
	MACRO_PRINT_FUNC_COEF 1

	PrintStoredFunction_skip_1:
	cmp [coef_0], word 0
	je PrintStoredFunction_skip_0
	MACRO_PRINT_FUNC_COEF 0

	PrintStoredFunction_skip_0:


	MACRO_PRINT_CHAR 13
	MACRO_PRINT_CHAR 10
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret

PrintFunctionDerivative:
	ret
PrintFunctionIntegral:
	ret
GraphFunction:
	ret
SolveByNewton:
	ret
SolveBySteffensen:
	ret
ExitApplication:
	mov AH, 0x4C
	mov AL, 0x0
	int 0x21





DrawFilledRectangle:	;draw_fill_rect_w, draw_fill_rect_h, screenX, screenY
	mov word [draw_fill_rect_w_c], 0		;Init current col counter to 0

	DrawVerticalLine_ver_loop:
		cmp word [draw_fill_rect_h], 0		;Have we reached desired height?
		jle DrawVerticalLine_end

		DrawVerticalLine_hor_loop:

			mov SI, [draw_fill_rect_w_c]
			mov DI, [draw_fill_rect_w]
			cmp SI, DI						;Have we reached desired column for current line?
			je DrawVerticalLine_hor_end

			push 0x2
;			mov AL, 0x2						;Color Green
			call DrawPixel
			add ESP, 2
			inc word [draw_fill_rect_w_c]	;Move 1 pixel horizontally
			inc word [screenX]
			jmp DrawVerticalLine_hor_loop

		DrawVerticalLine_hor_end:
		mov word [draw_fill_rect_w_c], 0	;Reset current column
		mov SI, [screenX]
		mov DI, [draw_fill_rect_w]
		sub SI, DI							;Where we originally were located
		mov word [screenX], SI				;Put that back
		dec word [draw_fill_rect_h]			;Decreese remaining height to travel
		inc word [screenY]					;Move one pixel down
		jmp DrawVerticalLine_ver_loop
	DrawVerticalLine_end:
	ret


DrawPixel:	;screenX, screenY	;Mods AH,AL,BH,CX,DX
	mov AX, [ESP+2]
	mov AH, 0x0C		;Write graphics pixel
	mov BH, 0	   		;Page 0
	mov CX, [screenX]	;X coord
	mov DX, [screenY]	;Y coord
	int 10h				;Video BIOS
	ret


PrintMainMenu:
	mov AH, 0x09 			; Print String
	mov DX, main_title_s	; Start address of message
	int 0x21				; DOS Function Dispatcher
	mov DX, main_title
	int 0x21
	mov DX, main_title_s
	int 0x21
	mov DX, text_ln_r
	int 0x21
	mov DX, text_ln_r
	int 0x21

	;Imprimir todas las opciones
	mov BX, options_array	;Point to first option message
	mov ECX, 8	 			;Loop 8 times

	print_options_loop:
	mov DX, [BX]			;Prepare message
	int 0x21				;Print it
	add BX, 2				;Move to next message
	loop print_options_loop
	ret


;Prints number passed in stack to buffer set at SI
NumberToString:		;SI: buffer to output. Stack(2) passed in pop order: number, symbol.
	mov AX, [ESP+2]
	mov CX, 0x0						;for counting chars pushed

	cmp AX, 0						;Special case: number is 0
	jne NumberToString_not_zero
	mov [SI], byte 0x30				;Adds 0, goto exit
	inc SI
	jmp NumberToString_normal_exit

	NumberToString_not_zero:

	mov DX, [ESP+4]					;Get number sign from stack
	cmp DX, 0						;Its positive?
	je NumberToString_not_negative
	mov [SI], byte 0x2d				;If not, add - to string buffer
	inc SI

	NumberToString_not_negative:	;Clean DX for divisions
	xor DX, DX

	NumberToString_reverse_loop:
		cmp AX, 0					;Have we reached 0 as base number?
		je NumberToString_exit1
		mov BX, 10					;Prepare divider
		div BX						;DL contains remainder
		add DX, '0'					;Make it ascii
		push DX						;Store it for later
		xor DX, DX					;Clean DX for net division
		add CX, byte 0x1			;++ chars pushed
		jmp NumberToString_reverse_loop


	NumberToString_exit1:
		NumberToString_normal_loop:
		cmp CX, 0					;Are chars still un stack?
		je NumberToString_normal_exit
		mov AX, [ESP]				;Get it
		mov [SI], AX				;Add it to buffer
		inc SI
		sub CX, 1					;--charsInStack
		add ESP, 2					;Clean stack
		jmp NumberToString_normal_loop

	NumberToString_normal_exit:
		mov [SI], word 0			;null-terminate buffer
		inc SI
		mov [SI], byte 0x24 		;$ for printing int21hs compliance
		ret



