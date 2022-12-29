%macro CLEARSCREEN 0
	;Video BIOS
	mov AH, 0x0		;Set video mode
	mov AL, 0x12	;640x480 16 color graphics (VGA)
	int 0x10
%endmacro

%macro MACRO_EXIT_APPLICATION 0
	mov AH, 0x4C
	mov AL, 0x0
	int 0x21
%endmacro

%macro MACRO_INPUT_CHAR_NO_ECO 0
	mov AH, 0x8		;User input without echo
	int 0x21		;DOS Function Dispatcher
%endmacro


%macro MACRO_PRINT_CHAR 1
	xor DX, DX
	mov AH, 0x6 			; Print String
	mov DL, %1	; Start address of message
	int 0x21
%endmacro


%macro MACRO_PRINT_STRING 1
	mov AH, 0x9 			; Print String
	mov DX, %1	; Start address of message
	int 0x21
%endmacro


%macro MACRO_PARSE_STRING_BUFFER 1
	mov SI, %1		;Parameter for Parse String
	call ParseString
%endmacro



%macro MACRO_ENTER_COEFFICIENT 1
	EnterFunctionCoefficients_coef_%1:
	MACRO_PRINT_STRING enter_coef_%1			;Promt to enter respective coefficient
	call ReadUntilLN							;Read input
	MACRO_PARSE_STRING_BUFFER inStrBuf			;Parse the number

	push AX										;save entered number
	mov AH, 0x9
	mov DX, text_ln_r							;print newline
	int 0x21
	pop AX										;Restore entered number

	cmp CX, 0x1									;Was there an error?
	jne EnterFunctionCoefficients_coef_%1_ok
	MACRO_PRINT_STRING input_error_2			;Tell user to try again
	jmp EnterFunctionCoefficients_coef_%1
	EnterFunctionCoefficients_coef_%1_ok:
	mov [coef_%1], AX							;Save entered coefficient
	mov [coef_%1_sign], BX						;save coefficient sign
%endmacro


%macro MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING 1
	mov SI, word gen_output_buff				;Set the buffer where the parsed number will be
	push word 0x0								;+ as sign
	push word %1								;number to be parsed
	call NumberToString
	add ESP, 4									;Restore stack
%endmacro



%macro MACRO_PRINT_FUNC_COEF 1
	cmp [coef_%1_sign], byte 0					;Compare Sign
	je m_print_func_coef_%1_pos
	MACRO_PRINT_CHAR 0x2d						;If neg, print -
	jmp m_print_func_coef_%1_number

	m_print_func_coef_%1_pos:
	MACRO_PRINT_CHAR 0x2b						;If pos, print +

	m_print_func_coef_%1_number:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_%1]
	MACRO_PRINT_STRING gen_output_buff
	MACRO_PRINT_STRING str_x_%1
%endmacro
%macro MACRO_PRINT_DERIV_COEF 2
	cmp [coef_%1_sign], byte 0			;Compare Sign
	je m_print_deriv_coef_%1_pos
	MACRO_PRINT_CHAR 0x2d				;If neg, print -
	jmp m_print_deriv_coef_%1_number

	m_print_deriv_coef_%1_pos:
	MACRO_PRINT_CHAR 0x2b				;If pos, print +

	m_print_deriv_coef_%1_number:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_%1_d]
	MACRO_PRINT_STRING gen_output_buff
	MACRO_PRINT_STRING str_x_%2
%endmacro

%macro MACRO_PRINT_INT_COEF 2
	cmp [coef_%1_sign], byte 0			;Compare Sign
	je m_print_int_coef_%1_pos
	MACRO_PRINT_CHAR 0x2d				;If neg, print -
	jmp m_print_int_coef_%1_number

	m_print_int_coef_%1_pos:
	MACRO_PRINT_CHAR 0x2b				;If pos, print +

	m_print_int_coef_%1_number:
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_%1_i_num]
	MACRO_PRINT_STRING gen_output_buff
	cmp [coef_%1_i_den], word 1			;If denominator is 1, skip '/' + denominator
	je m_print_int_coef_%1_den_is_1

	MACRO_PRINT_CHAR 0x2f				; /
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_%1_i_den]
	MACRO_PRINT_STRING gen_output_buff

	m_print_int_coef_%1_den_is_1:
	MACRO_PRINT_STRING str_x_%2
%endmacro




%macro MACRO_UPDATE_DERIVATIVE_COEF 1
	xor DX, DX				;Clean up
	mov AX, [coef_%1]		;x
	mov BX, %1				;y
	mul BX					;x = xy
	mov [coef_%1_d], AX		;Store it
%endmacro

%macro MACRO_UPDATE_INTEGRAL_COEFFICIENT 1

	push word [coef_%1]		;Numerator
	push %1+1				;Divisor
	call MaxCommonDivisor
	add ESP, 4				;Clean stack

	;Now that MCD is calculated, divide both numbers by it
	mov BX, AX				;Denominator
	xor DX, DX				;Clean upper part of numerator
	mov AX, [coef_%1]		;Numerator
	div BX
	mov [coef_%1_i_num], AX	;Save integral numerator

	;BX already has max common divisor as denominator
	xor DX, DX				;Clean upper part of numerator
	mov AX, %1+1			;Numerator
	div BX
	mov [coef_%1_i_den], AX	;Save integral denominator

%endmacro

%macro MACRO_FIND_FUNC_X_VALUE_OF_COEF 1
	;/////////////////////////////////////////////COEF 5////////////////////////////////////////////////////////////////
	cmp [coef_%1], word 0						;if coefficient is 0
	je CalculateFunctionY_skip_%1				;then skip

	xor CX,CX									;Clear counter (necessary?)
	mov CX, %1									;Counter to multiply x n-times (x^n)

	cmp CX, 0									;Have we reached x^n?
	je CalculateFunctionY_%1_coef_mult			;Then go to coefficient
	fld qword [graph_current_x]					;grab x									F-Stack:1
	sub CX, 1									;one more close to x^n

	CalculateFunctionY_%1_loop:					;Multiply by x until x^n
		cmp CX, 0								;Have we reached x^n?
		je CalculateFunctionY_%1_coef_mult		;Then go to coefficient
		fmul qword [graph_current_x]			;ST(0)*x
		sub CX, 1								;one more close to x^n
		jmp CalculateFunctionY_%1_loop

	CalculateFunctionY_%1_coef_mult:
	fimul word [coef_%1]						;At this point, we have |coef|*x^n

	cmp [coef_%1_sign], byte 0x0				;Its positive?
	je CalculateFunctionY_x_%1_positive			;Skip sign change
	fchs

	CalculateFunctionY_x_%1_positive:
	;Now we have coef*x^n
	fld qword [graph_result_y]					;load result by previous coefficient	F-Stack:2
	faddp										;Add them								F-Stack:1
	fstp qword [graph_result_y]					;Store it								F-Stack:0
	CalculateFunctionY_skip_%1:
%endmacro


%macro MACRO_FIND_DERIV_X_VALUE_OF_COEF 1
	;/////////////////////////////////////////////COEF 5////////////////////////////////////////////////////////////////
	cmp [coef_%1_d], word 0						;if coefficient is 0
	je CalculateDerivativeY_skip_%1				;then skip

	xor CX,CX									;Clear counter (necessary?)
	mov CX, %1									;Counter to multiply x n-times (x^n)
	sub CX, 1									;Because of derivative

	cmp CX, 0									;Have we reached x^n?
	je CalculateDerivativeY_%1_coef_mult		;Then go to coefficient
	fld qword [graph_current_x]					;grab x									F-Stack:1
	sub CX, 1									;one more close to x^n

	CalculateDerivativeY_%1_loop:				;Multiply by x until x^n
		cmp CX, 0								;Have we reached x^n?
		je CalculateDerivativeY_%1_coef_mult	;Then go to coefficient
		fmul qword [graph_current_x]			;ST(0)*x
		sub CX, 1								;one more close to x^n
		jmp CalculateDerivativeY_%1_loop

	CalculateDerivativeY_%1_coef_mult:
	fimul word [coef_%1_d]						;At this point, we have |coef|*x^n

	cmp [coef_%1_sign], byte 0x0				;Its positive?
	je CalculateDerivativeY_x_%1_positive		;Skip sign change
	fchs

	CalculateDerivativeY_x_%1_positive:
	;Now we have coef*x^n
	fld qword [graph_result_y_d]				;load result by previous coefficient	F-Stack:2
	faddp										;Add them								F-Stack:1
	fstp qword [graph_result_y_d]				;Store it								F-Stack:0
	CalculateDerivativeY_skip_%1:
%endmacro



%macro MACRO_FIND_INTEG_X_VALUE_OF_COEF 1
	;/////////////////////////////////////////////COEF 5////////////////////////////////////////////////////////////////
	cmp [coef_%1_i_num], word 0					;if coefficient is 0
	je CalculateIntegralY_skip_%1				;then skip

	xor CX,CX									;Clear counter (necessary?)
	mov CX, %1									;Counter to multiply x n-times (x^n)
	add CX, 1									;Because of integral

	cmp CX, 0									;Have we reached x^n?
	je CalculateIntegralY_%1_coef_mult			;Then go to coefficient
	fld qword [graph_current_x]					;grab x									F-Stack:1
	sub CX, 1									;one more close to x^n

	CalculateIntegralY_%1_loop:					;Multiply by x until x^n
		cmp CX, 0								;Have we reached x^n?
		je CalculateIntegralY_%1_coef_mult		;Then go to coefficient
		fmul qword [graph_current_x]			;ST(0)*x
		sub CX, 1								;one more close to x^n
		jmp CalculateIntegralY_%1_loop

	CalculateIntegralY_%1_coef_mult:
	fimul word [coef_%1_i_num]
	fidiv word [coef_%1_i_den]					;At this point, we have |coef|*x^n

	cmp [coef_%1_sign], byte 0x0				;Its positive?
	je CalculateIntegralY_x_%1_positive			;Skip sign change
	fchs

	CalculateIntegralY_x_%1_positive:
	;Now we have coef*x^n
	fld qword [graph_result_y_i]				;load result by previous coefficient	F-Stack:2
	faddp										;Add them								F-Stack:1
	fstp qword [graph_result_y_i]				;Store it								F-Stack:0
	CalculateIntegralY_skip_%1:
%endmacro


;ONE TIME USE
%macro MACRO_ASK_X0 0
	GraphFunction_enter_xo:
		MACRO_PRINT_STRING str_enter_xo				;Promt to enter xo
		call ReadUntilLN							;Read input
		MACRO_PRINT_STRING text_ln_r
		MACRO_PARSE_STRING_BUFFER inStrBuf			;Parse the number

		cmp CX, word 0x1							;If no error
		jne GraphFunction_xo_correct				;then continue
		MACRO_PRINT_STRING input_error_2			;print user error
		jmp GraphFunction_enter_xo					;retry

	GraphFunction_xo_correct:
	cmp BX, word 0x0								;if negative
	je GraphFunction_xo_positive
	neg AX											;invert sign
	GraphFunction_xo_positive:
	mov [graph_xo], AX								;store it

%endmacro


;ONE TIME USE
%macro MACRO_ASK_XF 0
	GraphFunction_enter_xf:
		MACRO_PRINT_STRING str_enter_xf			;Promt to enter xf
		call ReadUntilLN						;Read input
		MACRO_PRINT_STRING text_ln_r
		MACRO_PARSE_STRING_BUFFER inStrBuf		;Parse the number

		cmp CX, word 0x1						;If no error
		jne GraphFunction_xf_correct			;then continue
		MACRO_PRINT_STRING input_error_2		;print user error
		jmp GraphFunction_enter_xo				;retry to xo in case of mind change

	GraphFunction_xf_correct:
	cmp BX, word 0x0							;if negative
	je GraphFunction_xf_positive
	neg AX										;invert sign
	GraphFunction_xf_positive:
	mov [graph_xf], AX							;store it
	cmp AX, [graph_xo]							;If Xf-Xo
	jg GraphFunction_interval_correct			;continue
	MACRO_PRINT_STRING input_error_3			;else, tell user
	jmp GraphFunction_enter_xo					;and try again

	GraphFunction_interval_correct:

%endmacro


;ONE TIME USE
%macro MACRO_ASK_Y_RANGE 0
	GraphFunction_enter_y_range:
		MACRO_PRINT_STRING str_enter_y_range	;Promt to enter Y range
		call ReadUntilLN						;Read input
		MACRO_PRINT_STRING text_ln_r
		MACRO_PARSE_STRING_BUFFER inStrBuf		;Parse the number

		cmp CX, word 0x1						;If no error
		jne GraphFunction_y_range_correct		;then continue
		MACRO_PRINT_STRING input_error_2		;print user error
		jmp GraphFunction_enter_y_range			;retry

		GraphFunction_y_range_correct:
		cmp BX, word 0x0						;Y interval is not entered with -
		je GraphFunction_y_range_positive
		MACRO_PRINT_STRING input_error_3		;print user error
		jmp GraphFunction_enter_y_range

	GraphFunction_y_range_positive:
	mov [graph_y_size], AX
%endmacro

%macro MACRO_SCROLL_UP_BY 1
	pusha
	mov AH, 0x6    ; set function to scroll page up
	mov AL, %1
	mov BH, 0
	mov CH, 0x0
	mov CL, 0x0
	mov DH, 29
	mov DL, 79
	int 10h        ; call BIOS interrupt to scroll page
	popa
%endmacro


%macro MACRO_SET_CURSOR_AT 2
	pusha
	mov AH, 0x2		;Set Cursor Position
	mov BH, 0x0		;Page 0 (only one in graphics mode)
	mov DH, %1		;Row
	mov DL, %2		;Column
	int 0x10
	popa
%endmacro