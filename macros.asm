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
	MACRO_PRINT_STRING enter_coef_%1
	call ReadUntilLN
	MACRO_PARSE_STRING_BUFFER inStrBuf

	push AX
	mov AH, 0x9
	mov DX, text_ln_r
	int 0x21
	pop AX

	cmp CX, 0x1
	jne EnterFunctionCoefficients_coef_%1_ok
	MACRO_PRINT_STRING input_error_2
	jmp EnterFunctionCoefficients_coef_%1
	EnterFunctionCoefficients_coef_%1_ok:
	mov [coef_%1], AX
	mov [coef_%1_sign], BX
%endmacro


%macro MACRO_PARSE_COEFFICIENT_WITHOUT_SIGN_TO_STRING 1
	mov SI, word gen_output_buff
	push word 0x0
	push word [coef_%1]
	call NumberToString
	add ESP, 4
%endmacro



%macro MACRO_PRINT_FUNC_COEF 1
	cmp [coef_%1_sign], byte 0			;Compare Sign
	je m_print_func_coef_%1_pos
	MACRO_PRINT_CHAR 0x2d				;If neg, print -
	jmp m_print_func_coef_%1_number

	m_print_func_coef_%1_pos:
	MACRO_PRINT_CHAR 0x2b				;If pos, print +

	m_print_func_coef_%1_number:

	MACRO_PARSE_COEFFICIENT_WITHOUT_SIGN_TO_STRING %1
	MACRO_PRINT_STRING gen_output_buff
	MACRO_PRINT_STRING str_x_%1

%endmacro