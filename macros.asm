%macro CLEARSCREEN 0
	;Video BIOS
	mov AH, 0x0		;Set video mode
	mov AL, 0x12	;640x480 16 color graphics (VGA)
	int 0x10
%endmacro



%macro MACRO_INPUT_CHAR_NO_ECO 0
	mov AH, 0x8		;User input without echo
	int 0x21		;DOS Function Dispatcher
%endmacro


%macro MACRO_PRINT_CHAR 1
	xor DX, Dx
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
	cmp [coef_%1_sign], byte 0			;Compare Sign
	je m_print_func_coef_%1_pos
	MACRO_PRINT_CHAR 0x2d				;If neg, print -
	jmp m_print_func_coef_%1_number

	m_print_func_coef_%1_pos:
	MACRO_PRINT_CHAR 0x2b				;If pos, print +

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
	cmp [coef_%1_i_den], word 1
	je m_print_int_coef_%1_den_is_1

	MACRO_PRINT_CHAR 0x2f
	MACRO_PARSE_NUMBER_WITHOUT_SIGN_TO_STRING [coef_%1_i_den]
	MACRO_PRINT_STRING gen_output_buff

	m_print_int_coef_%1_den_is_1:
	MACRO_PRINT_STRING str_x_%2
%endmacro




%macro MACRO_UPDATE_DERIVATIVE_COEF 1
	xor DX, DX
	mov AX, [coef_%1]
	mov BX, %1
	mul BX
	mov [coef_%1_d], AX
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