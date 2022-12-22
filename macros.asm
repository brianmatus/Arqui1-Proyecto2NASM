%macro CLEARSCREEN 0
;Video BIOS
mov AH, 0x0		;Set video mode
mov AL, 0x12	;640x480 16 color graphics (VGA)
int 0x10
%endmacro


%macro MACRO_PRINT_STRING 1
	mov AH, 0x9 			; Print String
	mov DX, %1	; Start address of message
	int 0x21
%endmacro


%macro MACRO_PARSE_STRING_BUFFER 1
	mov SI, %1		;Parameter for Parse String
	call ParseString
	mov AH, 0x9
	mov DX, text_ln_r
	int 0x21
%endmacro



%macro MACRO_ENTER_COEFFICIENT 1
	EnterFunctionCoefficients_coef_%1:
	MACRO_PRINT_STRING enter_coef_%1
	call ReadUntilLN
	MACRO_PARSE_STRING_BUFFER inStrBuf
	cmp CX, 0x1
	jne EnterFunctionCoefficients_coef_%1_ok
	MACRO_PRINT_STRING input_error_2
	jmp EnterFunctionCoefficients_coef_%1
	EnterFunctionCoefficients_coef_%1_ok:
	mov [coef_%1], AX
	mov [coef_%1_sign], BX
%endmacro