SECTION .data

message:	db 'Hello world',0xA,0dh,"$"
screenX:	dw 0x0
screenY:	dw 0x0

draw_fill_rect_w:	dw 0x0
draw_fill_rect_w_c:	dw 0x0
draw_fill_rect_h:	dw 0x0


SECTION .bss
function_coefficients: resw 6

inStrBuf resb 15

SECTION .text


global main
	 bits 16		;It's 16bit (for DOS)
	 org 0x100	  	;It's a .COM program (Start program at offset 100h)
	 jmp main


main:
	;Video BIOS
	mov AH, 0x0		;Set video mode
	mov AL, 0x12	;640x480 16 color graphics (VGA)
	int 10h

	mov word [screenX], 0x140
	mov word [screenY], 0x0F0
	mov word [draw_fill_rect_w], 0xA
	mov word [draw_fill_rect_h], 0x1E
	call DrawFilledRectangle

;	inc word [screenX]
;	inc word [screenY]
;	call DrawPixel

	mov DX, message		; Start address of message
	mov AH, 09			; Prepare for screen display
	int 21h				; DOS interrupt 21h
	int 20h				; Terminate program

DrawFilledRectangle:	;draw_fill_rect_w, draw_fill_rect_h, screenX, screenY
	mov word [draw_fill_rect_w_c], 0

	DrawVerticalLine_ver_loop:
		cmp word [draw_fill_rect_h], 0
		jle DrawVerticalLine_end

		DrawVerticalLine_hor_loop:

			mov SI, [draw_fill_rect_w_c]
			mov DI, [draw_fill_rect_w]
			cmp SI, DI
			je DrawVerticalLine_hor_end

			call DrawPixel
			inc word [draw_fill_rect_w_c]
			inc word [screenX]
			jmp DrawVerticalLine_hor_loop

		DrawVerticalLine_hor_end:
		mov word [draw_fill_rect_w_c], 0
		mov SI, [screenX]
		mov DI, [draw_fill_rect_w]
		sub SI, DI
		mov word [screenX], SI
		dec word [draw_fill_rect_h]
		inc word [screenY]
		jmp DrawVerticalLine_ver_loop
	DrawVerticalLine_end:
	ret


DrawPixel:	;screenX, screenY	;Mods AH,AL,BH,CX,DX
	mov AH, 0x0C		;Write graphics pixel
	mov AL, 0x2			;Color Green
	mov BH, 0	   		;Page 0
	mov CX, [screenX]	;X coord
	mov DX, [screenY]	;Y coord
	int 10h				;Video BIOS
	ret