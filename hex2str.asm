DoubleFloatInMemoryToHexString_Aux:
	;###################################################################################################################
	cmp AH, 0xF0
	jb DoubleFloatInMemoryToHexString_p1_1_E
	mov [SI], byte 70				;Add F to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_E:
	cmp AH, 0xE0
	jb DoubleFloatInMemoryToHexString_p1_1_D
	mov [SI], byte 69				;Add E to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_D:
	cmp AH, 0xD0
	jb DoubleFloatInMemoryToHexString_p1_1_C
	mov [SI], byte 68				;Add D to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_C:
	cmp AH, 0xC0
	jb DoubleFloatInMemoryToHexString_p1_1_B
	mov [SI], byte 67				;Add C to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_B:
	cmp AH, 0xB0
	jb DoubleFloatInMemoryToHexString_p1_1_A
	mov [SI], byte 66				;Add B to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_A:
	cmp AH, 0xA0
	jb DoubleFloatInMemoryToHexString_p1_1_9
	mov [SI], byte 65				;Add A to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_9:
	cmp AH, 0x90
	jb DoubleFloatInMemoryToHexString_p1_1_8
	mov [SI], byte 57				;Add 9 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_8:
	cmp AH, 0x80
	jb DoubleFloatInMemoryToHexString_p1_1_7
	mov [SI], byte 56				;Add 8 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_7:
	cmp AH, 0x70
	jb DoubleFloatInMemoryToHexString_p1_1_6
	mov [SI], byte 55				;Add 7 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_6:
	cmp AH, 0x60
	jb DoubleFloatInMemoryToHexString_p1_1_5
	mov [SI], byte 54				;Add 6 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_5:
	cmp AH, 0x50
	jb DoubleFloatInMemoryToHexString_p1_1_4
	mov [SI], byte 53				;Add 5 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_4:
	cmp AH, 0x40
	jb DoubleFloatInMemoryToHexString_p1_1_3
	mov [SI], byte 52				;Add 4 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_3:
	cmp AH, 0x30
	jb DoubleFloatInMemoryToHexString_p1_1_2
	mov [SI], byte 51				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_2:
	cmp AH, 0x20
	jb DoubleFloatInMemoryToHexString_p1_1_1
	mov [SI], byte 50				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_1:
	cmp AH, 0x10
	jb DoubleFloatInMemoryToHexString_p1_1_0
	mov [SI], byte 49				;Add 2 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_1_exit

	DoubleFloatInMemoryToHexString_p1_1_0:
	mov [SI], byte 48				;Add 0 to buffer
	inc SI
	;###################################################################################################################
	DoubleFloatInMemoryToHexString_p1_1_exit:
	and AH, 0x0F

	cmp AH, 0xF
	jb DoubleFloatInMemoryToHexString_p1_2_E
	mov [SI], byte 70				;Add F to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_E:
	cmp AH, 0xE
	jb DoubleFloatInMemoryToHexString_p1_2_D
	mov [SI], byte 69				;Add E to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_D:
	cmp AH, 0xD
	jb DoubleFloatInMemoryToHexString_p1_2_C
	mov [SI], byte 68				;Add D to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_C:
	cmp AH, 0xC
	jb DoubleFloatInMemoryToHexString_p1_2_B
	mov [SI], byte 67				;Add C to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_B:
	cmp AH, 0xB
	jb DoubleFloatInMemoryToHexString_p1_2_A
	mov [SI], byte 66				;Add B to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_A:
	cmp AH, 0xA
	jb DoubleFloatInMemoryToHexString_p1_2_9
	mov [SI], byte 65				;Add A to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_9:
	cmp AH, 0x9
	jb DoubleFloatInMemoryToHexString_p1_2_8
	mov [SI], byte 57				;Add 9 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_8:
	cmp AH, 0x8
	jb DoubleFloatInMemoryToHexString_p1_2_7
	mov [SI], byte 56				;Add 8 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_7:
	cmp AH, 0x7
	jb DoubleFloatInMemoryToHexString_p1_2_6
	mov [SI], byte 55				;Add 7 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_6:
	cmp AH, 0x6
	jb DoubleFloatInMemoryToHexString_p1_2_5
	mov [SI], byte 54				;Add 6 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_5:
	cmp AH, 0x5
	jb DoubleFloatInMemoryToHexString_p1_2_4
	mov [SI], byte 53				;Add 5 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_4:
	cmp AH, 0x4
	jb DoubleFloatInMemoryToHexString_p1_2_3
	mov [SI], byte 52				;Add 4 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_3:
	cmp AH, 0x3
	jb DoubleFloatInMemoryToHexString_p1_2_2
	mov [SI], byte 51				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_2:
	cmp AH, 0x2
	jb DoubleFloatInMemoryToHexString_p1_2_1
	mov [SI], byte 50				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_1:
	cmp AH, 0x1
	jb DoubleFloatInMemoryToHexString_p1_2_0
	mov [SI], byte 49				;Add 2 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_2_exit

	DoubleFloatInMemoryToHexString_p1_2_0:
	mov [SI], byte 48				;Add 0 to buffer
	inc SI
	;###################################################################################################################
	DoubleFloatInMemoryToHexString_p1_2_exit:

	cmp AL, 0xF0
	jb DoubleFloatInMemoryToHexString_p1_3_E
	mov [SI], byte 70				;Add F to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_E:
	cmp AL, 0xE0
	jb DoubleFloatInMemoryToHexString_p1_3_D
	mov [SI], byte 69				;Add E to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_D:
	cmp AL, 0xD0
	jb DoubleFloatInMemoryToHexString_p1_3_C
	mov [SI], byte 68				;Add D to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_C:
	cmp AL, 0xC0
	jb DoubleFloatInMemoryToHexString_p1_3_B
	mov [SI], byte 67				;Add C to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_B:
	cmp AL, 0xB0
	jb DoubleFloatInMemoryToHexString_p1_3_A
	mov [SI], byte 66				;Add B to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_A:
	cmp AL, 0xA0
	jb DoubleFloatInMemoryToHexString_p1_3_9
	mov [SI], byte 65				;Add A to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_9:
	cmp AL, 0x90
	jb DoubleFloatInMemoryToHexString_p1_3_8
	mov [SI], byte 57				;Add 9 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_8:
	cmp AL, 0x80
	jb DoubleFloatInMemoryToHexString_p1_3_7
	mov [SI], byte 56				;Add 8 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_7:
	cmp AL, 0x70
	jb DoubleFloatInMemoryToHexString_p1_3_6
	mov [SI], byte 55				;Add 7 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_6:
	cmp AL, 0x60
	jb DoubleFloatInMemoryToHexString_p1_3_5
	mov [SI], byte 54				;Add 6 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_5:
	cmp AL, 0x50
	jb DoubleFloatInMemoryToHexString_p1_3_4
	mov [SI], byte 53				;Add 5 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_4:
	cmp AL, 0x40
	jb DoubleFloatInMemoryToHexString_p1_3_3
	mov [SI], byte 52				;Add 4 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_3:
	cmp AL, 0x30
	jb DoubleFloatInMemoryToHexString_p1_3_2
	mov [SI], byte 51				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_2:
	cmp AL, 0x20
	jb DoubleFloatInMemoryToHexString_p1_3_1
	mov [SI], byte 50				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_1:
	cmp AL, 0x10
	jb DoubleFloatInMemoryToHexString_p1_3_0
	mov [SI], byte 49				;Add 2 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_3_exit

	DoubleFloatInMemoryToHexString_p1_3_0:
	mov [SI], byte 48				;Add 0 to buffer
	inc SI
	;###################################################################################################################
	DoubleFloatInMemoryToHexString_p1_3_exit:
	and AL, 0x0F

	cmp AL, 0xF
	jb DoubleFloatInMemoryToHexString_p1_4_E
	mov [SI], byte 70				;Add F to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_E:
	cmp AL, 0xE
	jb DoubleFloatInMemoryToHexString_p1_4_D
	mov [SI], byte 69				;Add E to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_D:
	cmp AL, 0xD
	jb DoubleFloatInMemoryToHexString_p1_4_C
	mov [SI], byte 68				;Add D to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_C:
	cmp AL, 0xC
	jb DoubleFloatInMemoryToHexString_p1_4_B
	mov [SI], byte 67				;Add C to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_B:
	cmp AL, 0xB
	jb DoubleFloatInMemoryToHexString_p1_4_A
	mov [SI], byte 66				;Add B to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_A:
	cmp AL, 0xA
	jb DoubleFloatInMemoryToHexString_p1_4_9
	mov [SI], byte 65				;Add A to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_9:
	cmp AL, 0x9
	jb DoubleFloatInMemoryToHexString_p1_4_8
	mov [SI], byte 57				;Add 9 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_8:
	cmp AL, 0x8
	jb DoubleFloatInMemoryToHexString_p1_4_7
	mov [SI], byte 56				;Add 8 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_7:
	cmp AL, 0x7
	jb DoubleFloatInMemoryToHexString_p1_4_6
	mov [SI], byte 55				;Add 7 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_6:
	cmp AL, 0x6
	jb DoubleFloatInMemoryToHexString_p1_4_5
	mov [SI], byte 54				;Add 6 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_5:
	cmp AL, 0x5
	jb DoubleFloatInMemoryToHexString_p1_4_4
	mov [SI], byte 53				;Add 5 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_4:
	cmp AL, 0x4
	jb DoubleFloatInMemoryToHexString_p1_4_3
	mov [SI], byte 52				;Add 4 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_3:
	cmp AL, 0x3
	jb DoubleFloatInMemoryToHexString_p1_4_2
	mov [SI], byte 51				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_2:
	cmp AL, 0x2
	jb DoubleFloatInMemoryToHexString_p1_4_1
	mov [SI], byte 50				;Add 3 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_1:
	cmp AL, 0x1
	jb DoubleFloatInMemoryToHexString_p1_4_0
	mov [SI], byte 49				;Add 2 to buffer
	inc SI
	jmp DoubleFloatInMemoryToHexString_p1_4_exit

	DoubleFloatInMemoryToHexString_p1_4_0:
	mov [SI], byte 48				;Add 0 to buffer
	inc SI
	;###################################################################################################################
	DoubleFloatInMemoryToHexString_p1_4_exit:
	ret
