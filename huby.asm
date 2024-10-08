
;


	org	$8995
;	org	$89A5
	

   ; add a basic header so that the program can be "RUN"
   ; 2021 A=&H89A5:CALL A:END
;   	db 	$FF,$FF,$E5,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00
   	db 	$FF,$FF,$E2,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00



begin:	
START:       


	di


  	 LD    HL,MUSICDATA
;                CALL  HUBY_PLAY
;                RET

OP_INCL:        EQU   $2C

HUBY_PLAY:      LD    C,(HL)              ; Read the tempo word
                INC   HL
                LD    B,(HL)
                INC   HL
                LD    E,(HL)              ; Offset to pattern data is 
                INC   HL                  ; kept in DE always. 
                LD    D,(HL)              ; And HL = current position in song layout.

READPOS:        INC   HL
                LD    A,(HL)              ; Read the pattern number for channel 1
                INC   HL
                OR    A
                RET   Z                   ; Zero signifies the end of the song

; This code is for handling Tempo changes in the middle of a song.
; As the song data specified in Beepola (see MUSICDATA below) doesn't
; have any tempo changes, this code has been commented out to save 9
; bytes. Uncomment it if you want to use this routine to play tunes
; that contain mid-song tempo changes...
                CP    $FF                 ; $FF signifies SET TEMPO
                JR    NZ,NOT_TEMPO
                LD    C,(HL)
                INC   HL
                LD    B,(HL)
                JR    READPOS

NOT_TEMPO:      PUSH  HL                  ; Store the layout pointer
                PUSH  DE                  ; Store the pattern offset pointer
                PUSH  BC                  ; Store current tempo
                LD    L,(HL)              ; Read the pattern number for channel 2
                LD    B,2                 ; DJNZ through following code twice (1x for each channel)
CALC_ADR:       LD    H,0                 ; Multiply pattern number by 8...
                ADD   HL,HL               ; x2
                ADD   HL,HL               ; x4
                ADD   HL,HL               ; x8
                ADD   HL,DE               ; Add the offset to the pattern data
                PUSH  HL                  ; Store the address of pattern data
                LD    L,A
                DJNZ  CALC_ADR            ; Do the same thing for channel 2
                EXX
                POP   HL
                POP   DE

                LD    B,8                 ; Fixed pattern length = 8 rows
READ_ROW:       LD    A,(DE)              ; Read note for channel 1
                INC   DE                  ; inc channel 1 row pointer
                EXX
                LD    H,A
                LD    D,A
                EXX
                LD    A,(HL)              ; Read note for channel 2
                INC   HL                  ; inc channel 2 row pointer
                EXX
                LD    L,A
                LD    E,A
                CP    OP_INCL             ; If channel 1 note == $2C then play drum
                JR    Z,SET_DRUMSLIDE
                XOR   A
SET_DRUMSLIDE:  LD    (SND_SLIDE),A
                POP   BC                  ; Retrieve tempo
                PUSH  BC
                DI

SOUND_LOOP:     XOR   A
                DEC   E
                JR    NZ,SND_LOOP1
                LD    E,L
                SUB   L
SND_SLIDE:      NOP                       ; This is set to INC L for the drum sound
SND_LOOP1:      DEC   D
                JR    NZ,SND_LOOP2
                LD    D,H
                SUB   H
SND_LOOP2:      SBC   A,A
;                AND   2


	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	

	xor	1
	ld	($6800),a


                DEC   BC
                LD    A,B
                OR    C
                JR    NZ,SOUND_LOOP       ; 113/123 Ts

SND_LOOP3:      LD    HL,$2758            ; Set HL' for returning to BASIC
                EXX   
                EI
                JR    NZ,PATTERN_END
                DJNZ  READ_ROW
PATTERN_END:    POP   BC
                POP   DE
                POP   HL
                JR    Z,READPOS           ; No key pressed, goto next pattern
                RET                       ; Otherwise return


; ************************************************************************
; * Song data...
; ************************************************************************
BORDER_CLR:          EQU $0




; *** DATA ***
MUSICDATA:
                DEFW  $06A0               ; Initial tempo
                DEFW  PATTDATA - 8        ; Ptr to start of pattern data - 8
                DEFB  $01
                DEFB  $02
                DEFB  $01
                DEFB  $03
                DEFB  $01
                DEFB  $04
                DEFB  $01
                DEFB  $05
                DEFB  $06
                DEFB  $07
                DEFB  $08
                DEFB  $09
                DEFB  $0A
                DEFB  $01
                DEFB  $0B
                DEFB  $01
                DEFB  $0C
                DEFB  $0D
                DEFB  $0E
                DEFB  $0F
                DEFB  $10
                DEFB  $11
                DEFB  $12
                DEFB  $13
                DEFB  $06
                DEFB  $07
                DEFB  $08
                DEFB  $09
                DEFB  $0A
                DEFB  $01
                DEFB  $0B
                DEFB  $01
                DEFB  $0C
                DEFB  $0D
                DEFB  $0E
                DEFB  $0F
                DEFB  $10
                DEFB  $11
                DEFB  $12
                DEFB  $13
                DEFB  $06
                DEFB  $14
                DEFB  $15
                DEFB  $01
                DEFB  $06
                DEFB  $01
                DEFB  $15
                DEFB  $01
                DEFB  $16
                DEFB  $17
                DEFB  $16
                DEFB  $18
                DEFB  $19
                DEFB  $1A
                DEFB  $19
                DEFB  $01
                DEFB  $1B
                DEFB  $1C
                DEFB  $1B
                DEFB  $1D
                DEFB  $16
                DEFB  $14
                DEFB  $16
                DEFB  $01
                DEFB  $1E
                DEFB  $1F
                DEFB  $1E
                DEFB  $20
                DEFB  $19
                DEFB  $1F
                DEFB  $19
                DEFB  $01
                DEFB  $21
                DEFB  $22
                DEFB  $21
                DEFB  $23
                DEFB  $24
                DEFB  $25
                DEFB  $26
                DEFB  $01
                DEFB  $16
                DEFB  $17
                DEFB  $16
                DEFB  $18
                DEFB  $19
                DEFB  $1A
                DEFB  $19
                DEFB  $01
                DEFB  $1B
                DEFB  $1C
                DEFB  $1B
                DEFB  $1D
                DEFB  $16
                DEFB  $14
                DEFB  $16
                DEFB  $01
                DEFB  $1E
                DEFB  $1F
                DEFB  $1E
                DEFB  $20
                DEFB  $19
                DEFB  $1F
                DEFB  $19
                DEFB  $01
                DEFB  $21
                DEFB  $22
                DEFB  $21
                DEFB  $27
                DEFB  $16
                DEFB  $25
                DEFB  $28
                DEFB  $01
                DEFB  $29
                DEFB  $01
                DEFB  $06
                DEFB  $01
                DEFB  $06
                DEFB  $07
                DEFB  $08
                DEFB  $09
                DEFB  $0A
                DEFB  $01
                DEFB  $0B
                DEFB  $01
                DEFB  $0C
                DEFB  $0D
                DEFB  $0E
                DEFB  $0F
                DEFB  $10
                DEFB  $11
                DEFB  $12
                DEFB  $13
                DEFB  $06
                DEFB  $07
                DEFB  $08
                DEFB  $2A
                DEFB  $0A
                DEFB  $01
                DEFB  $0B
                DEFB  $01
                DEFB  $0C
                DEFB  $07
                DEFB  $0C
                DEFB  $2B
                DEFB  $10
                DEFB  $2C
                DEFB  $2D
                DEFB  $2E
                DEFB  $06
                DEFB  $14
                DEFB  $15
                DEFB  $01
                DEFB  $06
                DEFB  $01
                DEFB  $15
                DEFB  $01
                DEFB  $16
                DEFB  $17
                DEFB  $16
                DEFB  $18
                DEFB  $19
                DEFB  $1A
                DEFB  $19
                DEFB  $01
                DEFB  $1B
                DEFB  $1C
                DEFB  $1B
                DEFB  $1D
                DEFB  $16
                DEFB  $14
                DEFB  $16
                DEFB  $01
                DEFB  $1E
                DEFB  $1F
                DEFB  $1E
                DEFB  $20
                DEFB  $19
                DEFB  $1F
                DEFB  $19
                DEFB  $01
                DEFB  $21
                DEFB  $22
                DEFB  $21
                DEFB  $23
                DEFB  $24
                DEFB  $25
                DEFB  $26
                DEFB  $01
                DEFB  $16
                DEFB  $17
                DEFB  $16
                DEFB  $18
                DEFB  $19
                DEFB  $1A
                DEFB  $19
                DEFB  $01
                DEFB  $1B
                DEFB  $1C
                DEFB  $1B
                DEFB  $1D
                DEFB  $16
                DEFB  $14
                DEFB  $16
                DEFB  $01
                DEFB  $1E
                DEFB  $1F
                DEFB  $1E
                DEFB  $20
                DEFB  $19
                DEFB  $1F
                DEFB  $19
                DEFB  $01
                DEFB  $21
                DEFB  $22
                DEFB  $21
                DEFB  $27
                DEFB  $16
                DEFB  $25
                DEFB  $28
                DEFB  $01
                DEFB  $29
                DEFB  $01
                DEFB  $06
                DEFB  $01
                DEFB  $00                 ; End of song

PATTDATA:
                DEFB  $00, $00, $00, $00, $00, $00, $00, $00
                DEFB  $66, $00, $00, $00, $60, $00, $00, $00
                DEFB  $5B, $00, $00, $00, $56, $00, $00, $00
                DEFB  $51, $00, $00, $00, $4C, $00, $00, $00
                DEFB  $48, $00, $00, $00, $44, $00, $00, $00
                DEFB  $80, $00, $80, $00, $80, $00, $80, $00
                DEFB  $20, $00, $00, $00, $20, $00, $00, $00
                DEFB  $2C, $00, $80, $00, $2C, $00, $80, $00
                DEFB  $00, $00, $24, $00, $20, $00, $24, $00
                DEFB  $90, $00, $90, $00, $90, $00, $90, $00
                DEFB  $2C, $00, $90, $00, $2C, $00, $90, $00
                DEFB  $A1, $00, $A1, $00, $A1, $00, $A1, $00
                DEFB  $28, $00, $00, $00, $28, $00, $00, $00
                DEFB  $2C, $00, $A1, $00, $2C, $00, $A1, $00
                DEFB  $00, $00, $28, $00, $30, $00, $36, $00
                DEFB  $97, $00, $97, $00, $97, $00, $97, $00
                DEFB  $39, $00, $00, $40, $00, $00, $39, $00
                DEFB  $2C, $00, $88, $00, $88, $00, $88, $00
                DEFB  $39, $00, $00, $44, $00, $00, $39, $00
                DEFB  $19, $00, $00, $00, $00, $00, $00, $00
                DEFB  $80, $00, $80, $00, $80, $00, $90, $88
                DEFB  $40, $00, $80, $00, $80, $00, $40, $80
                DEFB  $33, $00, $00, $00, $00, $00, $00, $00
                DEFB  $00, $00, $00, $00, $30, $00, $2D, $00
                DEFB  $44, $00, $88, $00, $88, $00, $44, $88
                DEFB  $2B, $00, $00, $00, $00, $00, $00, $00
                DEFB  $4C, $00, $97, $00, $97, $00, $4C, $97
                DEFB  $26, $00, $00, $00, $00, $00, $00, $00
                DEFB  $00, $00, $22, $00, $20, $00, $1C, $00
                DEFB  $39, $00, $72, $00, $72, $00, $39, $72
                DEFB  $18, $00, $00, $00, $00, $00, $00, $00
                DEFB  $00, $00, $13, $00, $00, $00, $15, $00
                DEFB  $56, $00, $AB, $00, $AB, $00, $56, $AB
                DEFB  $1C, $00, $00, $00, $00, $00, $00, $00
                DEFB  $00, $00, $18, $00, $00, $00, $19, $00
                DEFB  $80, $00, $80, $40, $88, $00, $80, $40
                DEFB  $20, $00, $00, $00, $00, $00, $00, $00
                DEFB  $97, $00, $80, $40, $AB, $00, $80, $40
                DEFB  $2B, $00, $00, $00, $1C, $00, $00, $00
                DEFB  $40, $00, $80, $00, $40, $00, $40, $80
                DEFB  $80, $FF, $80, $FF, $80, $FF, $80, $FF
                DEFB  $1B, $00, $1C, $00, $20, $00, $24, $00
                DEFB  $1B, $00, $1C, $00, $20, $00, $1B, $00
                DEFB  $18, $00, $00, $20, $00, $00, $18, $00
                DEFB  $88, $00, $88, $00, $88, $00, $88, $00
                DEFB  $15, $00, $00, $1C, $00, $00, $15, $00

end
