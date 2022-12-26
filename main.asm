;Al inicio de este proyecto, dios y yo sabíamos que estaba haciendo.
;Ahora, sólo dios sabe xD
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
input_error_1:		db "La opcion ingresada no es valida",0xA,0dh,"$"
input_error_2:		db "El texto ingresado no es valido",0xA,0dh,"$"
input_error_3:		db "El intervalo ingresado no es valido",0xA,0dh,"$"
str_no_function:	db "No se ha almacenado ninguna funcion",0xA,0dh,"$"
str_function_is:	db "La funcion almacenada es:","$"
str_deriv_is:		db "La derivada de la funcion es:","$"
str_integral_is:	db "La integral de la funcion es:","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
enter_coef_5:		db "Ingrese el coeficiente para x^5:","$"
enter_coef_4:		db "Ingrese el coeficiente para x^4:","$"
enter_coef_3:		db "Ingrese el coeficiente para x^3:","$"
enter_coef_2:		db "Ingrese el coeficiente para x^2:","$"
enter_coef_1:		db "Ingrese el coeficiente para x^1:","$"
enter_coef_0:		db "Ingrese el coeficiente para x^0:","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
str_enter_xo:		db "Ingrese el rango menor de X:","$"
str_enter_xf:		db "Ingrese el rango mayor de X:","$"
str_enter_y_range:	db "Ingrese la amplitud Y (+-valor):","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
str_ask_graph_fun:	db "Graficar funcion original? (Y/n)","$"
str_ask_graph_der:	db "Graficar funcion derivada? (Y/n)","$"
str_ask_graph_int:	db "Graficar funcion integral? (Y/n)","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
str_x_6:			db "x^6 ","$"
str_x_5:			db "x^5 ","$"
str_x_4:			db "x^4 ","$"
str_x_3:			db "x^3 ","$"
str_x_2:			db "x^2 ","$"
str_x_1:			db "x ","$"
str_x_0:			db " ","$"
str_int_const:		db "+C","$"
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
options_array:		dw main_option1,main_option2,main_option3,main_option4,main_option5,main_option6,main_option7,main_option8
text_ln_r:			db 0xA,0dh, "$"

SECTION .data
fpu_control_word:	dw 0
screen_size_x:		dw 640
screen_size_y:		dw 480
screen_center_y:	dw 240
screenX:			dw 0x0
screenY:			dw 0x0
screenY_float:		dd 0x0

function_exists:	db 1  ;TODO change to 0, for debug use already existing function

coef_5: 			dw 5  ; x^5
coef_5_sign: 		db 0
coef_4: 			dw 4  ; x^4
coef_4_sign: 		db 0
coef_3: 			dw 9  ; x^3
coef_3_sign: 		db 1
coef_2: 			dw 2  ; x^2
coef_2_sign: 		db 1
coef_1: 			dw 1  ; x
coef_1_sign: 		db 1
coef_0: 			dw 1 ; constant
coef_0_sign: 		db 0

coef_5_d: 			dw 0  ; d/dx x^5
coef_4_d: 			dw 0  ; d/dx x^4
coef_3_d: 			dw 0  ; d/dx x^3
coef_2_d: 			dw 0  ; d/dx x^2
coef_1_d: 			dw 0  ; d/dx x

coef_5_i_num: 		dw 0  ; x^5
coef_5_i_den: 		dw 0  ; x^5
coef_4_i_num: 		dw 0  ; x^4
coef_4_i_den: 		dw 0  ; x^4
coef_3_i_num: 		dw 0  ; x^3
coef_3_i_den: 		dw 0  ; x^3
coef_2_i_num: 		dw 0  ; x^2
coef_2_i_den: 		dw 0  ; x^2
coef_1_i_num: 		dw 0  ; x
coef_1_i_den: 		dw 0  ; x
coef_0_i_num: 		dw 0 ; constant
coef_0_i_den: 		dw 0 ; constant

coef_c:				dw 1 ; +C
coef_c_sign:		dw 1 ; +C
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
graph_result_y:		dq 7.5
graph_result_y_d:	dq 0.0
graph_result_y_i:	dq 0.0
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
graph_current_x:	dq 0
graph_xo:			dw -1
graph_xf:			dw 9
graph_x_step:		dq 0.0
graph_y_size:		dw 15	; +-range
graph_num_2:		dd 2
graph_random_int: 	dw 0
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
graph_active_fun:	db 1
graph_active_der:	db 1
graph_active_int:	db 1
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
draw_fill_rect_w:	dw 0x0
draw_fill_rect_w_c:	dw 0x0
draw_fill_rect_h:	dw 0x0
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
debug_var_float:	dq 42.0
debug_var_word:		dq 42.0

inStrBuf_p:				dw 0x0
inStrBuf:  				times 30 db 0x0
gen_output_buff: 		times 30 db 0x0

SECTION .bss

SECTION .text

global _start
	 bits 16		;It's 16bit (for DOS)
	 org 0x100	  	;It's a .COM program (Start program at offset 100h)

_start:
	CLEARSCREEN

	;TODO Set rounding mode of floats to Math.Floor??? idk

	;DEBUG

;	call GraphGuideLines
;	MACRO_INPUT_CHAR_NO_ECO
;	mov AX, word [debug_var_word]
;	fld qword [debug_var_float]


	call UpdateDerivativeCoefficients
	call UpdateIntegralCoefficients
	;END DEBUG

	call UserMainOptionInput
	call ExitApplication


GraphFunction:
	CLEARSCREEN
	;Enter Xo
	MACRO_ASK_X0
	;Enter Xf
	MACRO_ASK_XF
	;Enter Y range
	MACRO_ASK_Y_RANGE

	mov [graph_active_fun], byte 0x1		;Graph all of them until told otherwise
	mov [graph_active_der], byte 0x1
	mov [graph_active_int], byte 0x1

	;Graph normal function?
	MACRO_PRINT_STRING str_ask_graph_fun
	mov AH, 0x1								;Keyboard Input with Echo
	int 0x21								;DOS Function Dispatcher
	cmp AL, 110								;user entered "n"?
	jne GraphFunction_normal_ok
	mov [graph_active_fun], byte 0x0

	GraphFunction_normal_ok:
	MACRO_PRINT_STRING text_ln_r

	;Graph derivative function?
	MACRO_PRINT_STRING str_ask_graph_der
	mov AH, 0x1								;Keyboard Input with Echo
	int 0x21								;DOS Function Dispatcher
	cmp AL, 110								;user entered "n"?
	jne GraphFunction_der_ok
	mov [graph_active_der], byte 0x0

	GraphFunction_der_ok:
	MACRO_PRINT_STRING text_ln_r

	;Graph integral function?
	MACRO_PRINT_STRING str_ask_graph_int
	mov AH, 0x1							;Keyboard Input with Echo
	int 0x21							;DOS Function Dispatcher
	cmp AL, 110							;user entered "n"?
	jne GraphFunction_int_ok
	mov [graph_active_int], byte 0x0

	GraphFunction_int_ok:

	CLEARSCREEN
	call GraphGuideLines
	call GraphNormalFunction
	MACRO_INPUT_CHAR_NO_ECO
	ret



GraphGuideLines:
	;Horizontal one is easy
	mov [screenY], word 239				;Prepare line to center (a little off because of width)
	mov [screenX], word 0x0				;Set to origin

	mov word [draw_fill_rect_w], 640	;Screen width
	mov word [draw_fill_rect_h], 2
	push 0x7							;Gray
	call DrawFilledRectangle
	add ESP, 2

	;Vertical one is the real pain :(
	;Is x=0 even on screen?
	fldz							;										F-stack:1
	fild word [graph_xo]			;										F-stack:2
	fcomp							;cmp graph_xo, 0						F-stack:1
	fnstsw ax						;flags to ax
	sahf							;ax to cpu flags
	ja GraphGuideLines_done

	fild word [graph_xf]			;										F-stack:2
	fcompp							;cmp graph_xf, 0						F-stack:0
	fnstsw ax						;flags to ax
	sahf							;ax to cpu flags
	jb GraphGuideLines_done

	;x_pos = -Xo*screen_size_x/(Xf-Xo)
	fild word [graph_xf]			;Xf										F-Stack:1
	fisub word [graph_xo]			;Xf-Xo
	fidivr word [screen_size_x]		;screen_size_x/(Xf-Xo)
	fimul word [graph_xo]			;Xo*screen_size_x/(Xf-Xo)
	fchs							;-Xo*screen_size_x/(Xf-Xo)

	fistp word [screenX]			;Position of x=0						F-Stack:0
	mov [screenY], word 0x0			;Set to origin
	mov word [draw_fill_rect_w], 2
	mov word [draw_fill_rect_h], 480;Screen height
	push 0x7						;Gray
	call DrawFilledRectangle
	add ESP, 2

	GraphGuideLines_done:
	ret


GraphNormalFunction:
	fild word [graph_xf]			;x_step = (xf-xo)/horizontal_pixels		F-Stack:1
	fisub word [graph_xo]
	fidiv word [screen_size_x]
	fstp qword [graph_x_step]		;F-Stack:0

	fild word [graph_xo]			;Grab xo and set is as current x		F-Stack:1
	fst qword [graph_current_x]		;Store but don't pop it, we will use it in main loop
	mov [screenX], word 0
	;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	GraphNormalFunction_main_loop:
		ficom word [graph_xf]			;cmp current_x, xf
		fnstsw ax						;flags to ax
		sahf							;ax to cpu flags
		ja GraphNormalFunction_main_loop_end

;		MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [screenX]
;		MACRO_PRINT_STRING gen_output_buff
;		MACRO_INPUT_CHAR_NO_ECO
		;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cmp [graph_active_fun], byte 0x0
		je GraphFunction_skip_normal
			call CalculateFunctionY
			call DrawFunctionPoint
		GraphFunction_skip_normal:
		cmp [graph_active_der], byte 0x0
		je GraphFunction_skip_derivative
			call CalculateDerivativeY
			call DrawDerivativePoint
		GraphFunction_skip_derivative:
		cmp [graph_active_int], byte 0x0
		je GraphFunction_skip_integral
			call CalculateIntegralY
			call DrawIntegralPoint
		GraphFunction_skip_integral:
		;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

		fadd qword [graph_x_step]		;add x_step to float stack
		fst qword [graph_current_x]		;store float stack top to current_x
		add [screenX], word 1


		jmp GraphNormalFunction_main_loop

	;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	GraphNormalFunction_main_loop_end:
	fistp qword [graph_current_x]		;clean up. F-Stack:0
	ret

DrawIntegralPoint:			;Need already set: graph_result_y, screenX
	fld qword [graph_result_y_i]		;									F-Stack:1
	fabs								;For comparing range
	ficomp word [graph_y_size]			;cmp graph_result_y, graph_y_size	F-Stack:0
	fnstsw ax							;flags to ax
	sahf								;ax to cpu flags
	ja DrawIntegralPoint_outside_range

	fild word[screen_size_y]			;									F-Stack:1
	fidiv word [graph_y_size]			;scale screen size
	fidiv dword [graph_num_2]			;/2 since +- range
	fmul qword [graph_result_y_i]

;	;Calculate Y position in screen
;	;If point is positive, the value will be smaller (closer to top of screen)
;	;If point is negative, the value will be greater (closer to bottom of screen)
	fisubr word [screen_center_y]		; ST(0) = screen_center_y-ST(0)

	fistp word [screenY]					;									F-Stack:0
	;screenX already set by loop
	mov word [draw_fill_rect_w], 1
	mov word [draw_fill_rect_h], 6		;TODO adjust for best results
	push 0x1							;Red. (R0x4:Funct G0x2:Deriv B0x1:Integ)
	call DrawFilledRectangle
	add ESP, 2

	DrawIntegralPoint_outside_range:
	;TODO do something about it? idk
	ret


DrawDerivativePoint:			;Need already set: graph_result_y, screenX
	fld qword [graph_result_y_d]		;									F-Stack:1
	fabs								;For comparing range
	ficomp word [graph_y_size]			;cmp graph_result_y, graph_y_size	F-Stack:0
	fnstsw ax							;flags to ax
	sahf								;ax to cpu flags
	ja DrawDerivativePoint_outside_range

	fild word[screen_size_y]			;									F-Stack:1
	fidiv word [graph_y_size]			;scale screen size
	fidiv dword [graph_num_2]			;/2 since +- range
	fmul qword [graph_result_y_d]

;	;Calculate Y position in screen
;	;If point is positive, the value will be smaller (closer to top of screen)
;	;If point is negative, the value will be greater (closer to bottom of screen)
	fisubr word [screen_center_y]		; ST(0) = screen_center_y-ST(0)

	fistp word [screenY]					;									F-Stack:0
	;screenX already set by loop
	mov word [draw_fill_rect_w], 1
	mov word [draw_fill_rect_h], 6		;TODO adjust for best results
	push 0x2							;Red. (R0x4:Funct G0x2:Deriv B0x1:Integ)
	call DrawFilledRectangle
	add ESP, 2

	DrawDerivativePoint_outside_range:
	;TODO do something about it? idk
	ret


DrawFunctionPoint:			;Need already set: graph_result_y, screenX
	fld qword [graph_result_y]			;									F-Stack:1
	fabs								;For comparing range
	ficomp word [graph_y_size]			;cmp graph_result_y, graph_y_size	F-Stack:0
	fnstsw ax							;flags to ax
	sahf								;ax to cpu flags
	ja DrawFunctionPoint_outside_range

	fild word[screen_size_y]			;									F-Stack:1
	fidiv word [graph_y_size]			;scale screen size
	fidiv dword [graph_num_2]			;/2 since +- range
	fmul qword [graph_result_y]

;	;Calculate Y position in screen
;	;If point is positive, the value will be smaller (closer to top of screen)
;	;If point is negative, the value will be greater (closer to bottom of screen)
	fisubr word [screen_center_y]		; ST(0) = screen_center_y-ST(0)

	fistp word [screenY]					;									F-Stack:0
	;screenX already set by loop
	mov word [draw_fill_rect_w], 1
	mov word [draw_fill_rect_h], 6		;TODO adjust for best results
	push 0x4							;Red. (R0x4:Funct G0x2:Deriv B0x1:Integ)
	call DrawFilledRectangle
	add ESP, 2

	DrawFunctionPoint_outside_range:
	;TODO do something about it? idk
	ret

CalculateFunctionY: ; graph_current_x needs to be set before this call
	;Clean result to 0
    xor eax, eax
	mov [graph_result_y], eax
	mov [graph_result_y+4], eax

	MACRO_FIND_FUNC_X_VALUE_OF_COEF 5
	MACRO_FIND_FUNC_X_VALUE_OF_COEF 4
	MACRO_FIND_FUNC_X_VALUE_OF_COEF 3
	MACRO_FIND_FUNC_X_VALUE_OF_COEF 2
	MACRO_FIND_FUNC_X_VALUE_OF_COEF 1

	;Special case of constant coefficient
	cmp [coef_0], word 0				;if coefficient is 0, skip
	je CalculateFunctionY_skip_0

	fild word [coef_0]					;Convert coef to float				F-Stack:1

	cmp [coef_0_sign], byte 0x0			;Its positive?
	je CalculateFunctionY_x_0_positive
	fchs								;(Change ST(0) sign)
	CalculateFunctionY_x_0_positive:

	fld qword [graph_result_y]			;Load previous stored result		F-Stack:2
	faddp								;Add last coef to result			F-Stack:1
	fstp qword [graph_result_y]			;Store it as float					F-Stack:0
	CalculateFunctionY_skip_0:

	ret

CalculateDerivativeY: ; graph_current_x needs to be set before this call
	;Clean result to 0
    xor eax, eax
	mov [graph_result_y_d], eax
	mov [graph_result_y_d+4], eax

	MACRO_FIND_DERIV_X_VALUE_OF_COEF 5
	MACRO_FIND_DERIV_X_VALUE_OF_COEF 4
	MACRO_FIND_DERIV_X_VALUE_OF_COEF 3
	MACRO_FIND_DERIV_X_VALUE_OF_COEF 2

	;Special case of x^1 coefficient
	cmp [coef_1], word 0					;if coefficient is 0, skip
	je CalculateDerivativeY_skip_1

	fild word [coef_1]						;Convert coef to float				F-Stack:1

	cmp [coef_1_sign], byte 0x0				;Its positive?
	je CalculateDerivativeY_x_1_positive
	fchs									;(Change ST(0) sign)
	CalculateDerivativeY_x_1_positive:

	fld qword [graph_result_y_d]			;Load previous stored result		F-Stack:2
	faddp									;Add last coef to result			F-Stack:1
	fstp qword [graph_result_y_d]			;Store it as float					F-Stack:0
	CalculateDerivativeY_skip_1:

	ret

CalculateIntegralY: ; graph_current_x needs to be set before this call
	;Clean result to 0
    xor eax, eax
	mov [graph_result_y_i], eax
	mov [graph_result_y_i+4], eax

	MACRO_FIND_INTEG_X_VALUE_OF_COEF 5
	MACRO_FIND_INTEG_X_VALUE_OF_COEF 4
	MACRO_FIND_INTEG_X_VALUE_OF_COEF 3
	MACRO_FIND_INTEG_X_VALUE_OF_COEF 2
	MACRO_FIND_INTEG_X_VALUE_OF_COEF 1
	MACRO_FIND_INTEG_X_VALUE_OF_COEF 0

	;Special case of integration constant
	cmp [coef_c], word 0					;if coefficient is 0, skip
	je CalculateIntegralY_skip_c

	fild word [coef_c]						;Convert coef to float				F-Stack:1

	cmp [coef_c_sign], byte 0x0				;Its positive?
	je CalculateIntegralY_x_c_positive
	fchs									;(Change ST(0) sign)
	CalculateIntegralY_x_c_positive:

	fld qword [graph_result_y_i]			;Load previous stored result		F-Stack:2
	faddp									;Add last coef to result			F-Stack:1
	fstp qword [graph_result_y_i]			;Store it as float					F-Stack:0
	CalculateIntegralY_skip_c:

	ret

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
	call UpdateDerivativeCoefficients
	call UpdateIntegralCoefficients
	mov [function_exists], byte 0x1
	ret


UpdateDerivativeCoefficients:
	MACRO_UPDATE_DERIVATIVE_COEF 5
	MACRO_UPDATE_DERIVATIVE_COEF 4
	MACRO_UPDATE_DERIVATIVE_COEF 3
	MACRO_UPDATE_DERIVATIVE_COEF 2
	MACRO_UPDATE_DERIVATIVE_COEF 1
	ret

UpdateIntegralCoefficients:
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 5
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 4
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 3
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 2
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 1
	MACRO_UPDATE_INTEGRAL_COEFFICIENT 0
	ret

ParseString:	;[SI] as pointer,   returns: AX: result BX: sign  CX:return code
    xor ax, ax 	; Clean needed registers
    xor bx, bx 	;
    xor cx, cx 	;

    mov di, 10 ; set the base to 10

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
	mov byte [DI], 0x0		;null-terminate string
	inc DI
	mov byte [DI], 0x24		;add $ for printing
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
	MACRO_PRINT_STRING input_error_1	;"Entered option is not valid"
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	jmp UserMainOptionInput


PrintStoredFunction:
	cmp [function_exists], byte 0x0		;Check if function has been entered before printing something
	jne PrintStoredFunction_function_exists
	MACRO_PRINT_STRING str_no_function
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret

	PrintStoredFunction_function_exists:
	MACRO_PRINT_STRING str_function_is
	cmp [coef_5], word 0				;if coefficient is 0, skip
	je PrintStoredFunction_skip_5
	cmp [coef_5_sign], byte 0			;Sign is positive? no need to print + in first term
	je PrintStoredFunction_5_pos
	MACRO_PRINT_CHAR 0x2d				; -
	PrintStoredFunction_5_pos:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_5]
	MACRO_PRINT_STRING gen_output_buff	;Print the parsed number
	MACRO_PRINT_STRING str_x_5			;x^5

	;Repeat above for every coefficient
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

	MACRO_PRINT_STRING text_ln_r
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret

PrintFunctionDerivative:
	;Same as above haha
	cmp [function_exists], byte 0x0		;Check if function has been entered before printing something
	jne PrintFunctionDerivative_function_exists
	MACRO_PRINT_STRING str_no_function
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret

	PrintFunctionDerivative_function_exists:
	;Explained in detail in macro MACRO_PRINT_DERIV_COEF
	MACRO_PRINT_STRING str_deriv_is
	cmp [coef_5_d], word 0
	je PrintFunctionDerivative_skip_5
	cmp [coef_5_sign], byte 0
	je PrintFunctionDerivative_5_pos
	MACRO_PRINT_CHAR 0x2d		; -
	PrintFunctionDerivative_5_pos:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_5_d]
	MACRO_PRINT_STRING gen_output_buff
	MACRO_PRINT_STRING str_x_4

	PrintFunctionDerivative_skip_5:

	cmp [coef_4_d], word 0
	je PrintFunctionDerivative_skip_4
	MACRO_PRINT_DERIV_COEF 4, 3

	PrintFunctionDerivative_skip_4:
	cmp [coef_3_d], word 0
	je PrintStoredFunction_skip_3
	MACRO_PRINT_DERIV_COEF 3, 2

	PrintFunctionDerivative_skip_3:
	cmp [coef_2_d], word 0
	je PrintFunctionDerivative_skip_2
	MACRO_PRINT_DERIV_COEF 2, 1

	PrintFunctionDerivative_skip_2:
	cmp [coef_1_d], word 0
	je PrintFunctionDerivative_skip_1
	MACRO_PRINT_DERIV_COEF 1, 0

	PrintFunctionDerivative_skip_1:
	MACRO_PRINT_STRING text_ln_r
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret
PrintFunctionIntegral:
	;Same as above haha x2
	cmp [function_exists], byte 0x0		;Check if function has been entered before printing something
	jne PrintFunctionIntegral_function_exists
	MACRO_PRINT_STRING str_no_function
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
	ret

	PrintFunctionIntegral_function_exists:
	;Explained in detail in macro MACRO_PRINT_INT_COEF
	MACRO_PRINT_STRING str_integral_is
	cmp [coef_5], word 0
	je PrintFunctionIntegral_skip_5
	cmp [coef_5_sign], byte 0
	je PrintFunctionIntegral_5_pos
	MACRO_PRINT_CHAR 0x2d		; -
	PrintFunctionIntegral_5_pos:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_5_i_num]
	MACRO_PRINT_STRING gen_output_buff

	cmp [coef_5_i_den], word 1
	je PrintFunctionIntegral_den_is_1

	MACRO_PRINT_CHAR 0x2f
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_5_i_den]
	MACRO_PRINT_STRING gen_output_buff

	PrintFunctionIntegral_den_is_1:
	MACRO_PRINT_STRING str_x_6



	PrintFunctionIntegral_skip_5:

	cmp [coef_4], word 0
	je PrintFunctionIntegral_skip_4
	MACRO_PRINT_INT_COEF 4, 5

	PrintFunctionIntegral_skip_4:
	cmp [coef_3], word 0
	je PrintStoredFunction_skip_3
	MACRO_PRINT_INT_COEF 3, 4

	PrintFunctionIntegral_skip_3:
	cmp [coef_2], word 0
	je PrintFunctionIntegral_skip_2
	MACRO_PRINT_INT_COEF 2, 3

	PrintFunctionIntegral_skip_2:
	cmp [coef_1], word 0
	je PrintFunctionIntegral_skip_1
	MACRO_PRINT_INT_COEF 1, 2

	PrintFunctionIntegral_skip_1:
	cmp [coef_0], word 0
	je PrintFunctionIntegral_skip_0
	MACRO_PRINT_INT_COEF 0, 1

	PrintFunctionIntegral_skip_0:

	MACRO_PRINT_STRING str_int_const
	MACRO_PRINT_STRING text_ln_r
	MACRO_PRINT_STRING str_press_any
	MACRO_INPUT_CHAR_NO_ECO
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

			xor AH, AH
			mov AL, [ESP+2]						;Color Green
			push AX
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
		add CX, byte 0x1			;charsInStack++
		jmp NumberToString_reverse_loop


	NumberToString_exit1:
		NumberToString_normal_loop:
		cmp CX, 0					;Are chars still un stack?
		je NumberToString_normal_exit
		mov AX, [ESP]				;Get it
		mov [SI], AX				;Add it to buffer
		inc SI
		sub CX, 1					;charsInStack--
		add ESP, 2					;Clean stack
		jmp NumberToString_normal_loop

	NumberToString_normal_exit:
;		mov [SI], word 0			;null-terminate buffer
;		inc SI
		mov [SI], byte 0x24 		;$ for printing int21hs compliance
		ret


;MaxCommonDivisor tested in python:
;if (x<y):
;    x,y = y,x

;while (y > 0):
;    n = x % y
;    x = y
;    y = n
;return x

MaxCommonDivisor:					;STACK has both numbers
	xor DX, DX
	mov AX, [ESP+2]					;x  of x/y
	mov BX, [ESP+4]					;y of x/y
	;remainder will be stored in DX by default

	cmp AX, BX						;Swap AX if BX is bigger
	jge MaxCommonDivisor_no_swap
	xchg AX, BX

	MaxCommonDivisor_no_swap:
	MaxCommonDivisor_loop:
		cmp BX, 0					;Until no remainder:
		je MaxCommonDivisor_exit
		xor DX, DX					;clean for division
		div BX
		mov AX, BX					;x=y
		mov BX, DX					;y=remainder
		jmp MaxCommonDivisor_loop	;repeat
	MaxCommonDivisor_exit:
	ret


;	mov [screenX], word 630
;	mov [screenY], word 470
;	mov word [draw_fill_rect_w], 10
;	mov word [draw_fill_rect_h], 10
;	push 0x2		;Green
;	call DrawFilledRectangle
;	add ESP, 2
;	MACRO_INPUT_CHAR_NO_ECO




