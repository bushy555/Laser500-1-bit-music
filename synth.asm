


;Add an execution basic 'RUN' header:
;	output "synth.bin"	; USE this if assembling with SJASM.  Else, comment out for PASMO/TASM.
	org	$8995		; Loads BASIC header here.
;	org	$89A5		; $8995 + 16byte header = $A9A5: start of ASM is here.
;	
;
;   Add a basic header so that the program can be "RUN"
;   2021 A equ &H89A5:CALL A:END
;   	db 	$FF,$FF,$E5,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00
   	db 	$FF,$FF,$E2,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00
;
;
;   Assemble:
;		PASMO	: \vz\tasm\_utils\pasmo --alocal %1.asm %1.bin
; 		SJ	: \vz\tasm\_utils\sjasmplus %1.asm
;
;   Resulting outtputed assembled .BIN file can be simply copied into an emulator, or, 
;   Use:   BIN2WAV to create a WAV file , that can then be CLOAD'd in.
;
;   Antontino's Laser500 emulator :     https://nippur72.github.io/laser500emu/
;



	
start:	di
	exx
	push hl
	ld hl,  music_data
	call play
	pop hl
	exx
	ei
	ret
	

;Music Synth 48K engine by Simon C. Tillson,   1989
;reversed and adapted for 1tracker by Shiru 01'2018
;the code mostly remained intact,  just a header added

play:

       di
	
	ld a, (hl)
	ld (song_speed), a
	inc hl
	inc hl
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch1_song_ptr), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch2_song_ptr), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch3_song_ptr), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch1_loop_ptr), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch2_loop_ptr), de
	ld e, (hl)
	inc hl
	ld d, (hl)
	inc hl
	ld   (ch3_loop_ptr), de
	
	ld (envelope_data_ptr), hl

	call ch1_read_note
	call ch2_read_note
	call ch3_read_note
	
	ld e, 0
	
	call play_loop
        ei
	ret

play_loop:
	ld   a, (song_speed)
	ld   (sound_loop_cnt), a
sound_loop:
sound_loop_ch1:
	ld   a, h			;process first tone channel
	and  a
	jr   z, sound_loop_ch2		;check if channel is muted (zero period)
	dec  h
	jr   nz, sound_loop_ch2
	ld   a, (ch1_volume)
	ld   c, a
	and  a
	jr   z, sound_loop_ch2
	ld   b, a
	xor  a
;       OUT   (254), A
;	in	a, ($fe) 		; Cassette Output becomes Low
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a
	djnz $
	ld   a, $1
;        out  ($FE), a
;	out	($ff), a 		; Cassette Output becomes High
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a
	sub  c
	ld   b, a
	djnz $
	ld   a, (ch1_period)
	ld   h, a
sound_loop_ch2:
	ld   a, l			;process second tone channel
	and  a
	jr   z, sound_loop_ch3
	dec  l
	jr   nz, sound_loop_ch3
	ld   a, (ch2_volume)
	and  a
	jr   z, sound_loop_ch3
	ld   c, a
	ld   b, a
	xor  a
;       OUT   (254), A
;	in	a, ($fe) 		; Cassette Output becomes Low
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a

	djnz $
	
	ld   a, $21
;        out  ($FE), a
;	out	($ff), a 		; Cassette Output becomes High
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a

	sub  c
	ld   b, a

	djnz $
	
	ld   a, (ch2_period)
	ld   l, a

sound_loop_ch3:

	ld   a, d			;process noise channel
	
	and  a
	jr   z, sound_loop_next
	dec  d
	jr   nz, sound_loop_next
	ld   a, (ix)			;read noise from ROM

;	and  $21
;        out  ($FE), a
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a


	jr   nz, hidc1
	in   a, ($fe)			; Cassette Output becomes Low
	jr   nxdc
hidc1: ;out	($ff), a 		; Cassette Output becomes High

	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a
nxdc:	xor  $1
;        out  ($FE), a
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a


	jr   nz,  hidc2
;	in   a, ($fe)			; Cassette Output becomes Low
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a
	jr   loop
hidc2: 	
	and 1
	push	af
 	ld      a,2
        out     ($41),a
	pop	af
	XOR   	1
	ld	($6800),a
loop:	ld   a, (ch3_period)
	ld   d, a
sound_loop_next:
	inc  ix 			;advance noise pointer,  gets modified to mute noise
	ld   a, ixh			;keep it in $0fff range
	cp   $0F
	jr   nz, no_noise_overflow
	ld   ix, 0
no_noise_overflow:
	ld   a, (sound_loop_cnt)
	dec  a
	ld   (sound_loop_cnt), a
	jp   nz, sound_loop
	call ch1_advance_envelope
	call ch2_advance_envelope
	call ch3_advance_envelope
	
	bit  6, e
	call nz, loop_playing
	res  6, e

;        xor  a
;        in   a, ($FE)
;        cpl
;        and  $1F
;        jp   z, play_loop

	ld   a, h
	or   l
	or   d
	jp   nz, play_loop
	ret
ch1_advance_envelope:
	exx
	dec  e
	exx
	ret  nz
	ld   a, (ch1_counter)
	exx
	ld   e, a
	exx
	ld   bc, (ch1_env_play_ptr)
	inc  bc
	ld   (ch1_env_play_ptr), bc	
	ld   a, (bc)
	ld   (ch1_volume), a
	bit  7, a
	call nz, ch1_read_note
	ret
ch2_advance_envelope:
	exx
	dec  b
	exx
	ret  nz
	ld   a, (ch2_counter)
	exx
	ld   b, a
	exx
	ld   bc, (ch2_env_play_ptr)
	inc  bc
	ld   (ch2_env_play_ptr), bc
	ld   a, (bc)
	ld   (ch2_volume), a
	bit  7, a
	call nz, ch2_read_note
	ret

ch3_advance_envelope:
	exx
	dec  c
	exx
	ret  nz
	ld   a, (ch3_counter)
	exx
	ld   c, a
	exx
	ld   bc, (ch3_env_play_ptr)
	inc  bc
	ld   (ch3_env_play_ptr), bc
	ld   a, (bc)
	ld   d, a
	ld   (ch3_period), a
	bit  7, a
	call nz, ch3_read_note
	ret

loop_playing:

	ld hl, (ch1_loop_ptr)
	ld   (ch1_song_ptr), hl
	ld hl, (ch2_loop_ptr)
	ld   (ch2_song_ptr), hl
	ld hl, (ch3_loop_ptr)
	ld   (ch3_song_ptr), hl
	call ch1_read_note
	call ch2_read_note
	call ch3_read_note
	ret

ch1_read_note:

	push hl
	push de
	ld   hl, (ch1_song_ptr)
	ld   a, (hl)
	inc  a
	jp   nz, ch1_no_envelope
	inc  hl
	ld   a, (hl)
	inc  hl
	ld   (ch1_song_ptr), hl
	ld   l, a
	ld   h, 0
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	ld   de, (envelope_data_ptr)
	add  hl, de
	ld   (ch1_env_sel_ptr), hl
ch1_no_envelope:
	ld   hl, (ch1_song_ptr)
	ld   a, (hl)
	ld   (ch1_period), a
	inc  hl
	ld   a, (hl)
	and  a
	jp   nz, L9D80
	pop  de
	set  6, e
	push de
L9D80:	exx
	ld   e, a
	exx
	ld   (ch1_counter), a
	inc  hl
	ld   (ch1_song_ptr), hl
	ld   hl, (ch1_env_sel_ptr)
	ld   (ch1_env_play_ptr), hl
	ld   a, (hl)
	ld   (ch1_volume), a
	pop  de
	pop  hl
	ld   a, (ch1_period)
	ld   h, a
	ret
ch2_read_note:
	push hl
	push de
	ld   hl, (ch2_song_ptr)
	ld   a, (hl)
	inc  a
	jp   nz, ch2_no_envelope
	inc  hl
	ld   a, (hl)
	inc  hl
	ld   (ch2_song_ptr), hl
	ld   l, a
	ld   h, 0
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	ld   de, (envelope_data_ptr)
	add  hl, de
	ld   (ch2_env_sel_ptr), hl

ch2_no_envelope:
	ld   hl, (ch2_song_ptr)
	ld   a, (hl)
	ld   (ch2_period), a
	inc  hl
	ld   a, (hl)
	exx
	ld   b, a
	exx
	ld   (ch2_counter), a
	inc  hl
	ld   (ch2_song_ptr), hl
	ld   hl, (ch2_env_sel_ptr)
	ld   (ch2_env_play_ptr), hl
	ld   a, (hl)
	ld   (ch2_volume), a
	pop  de
	pop  hl
	ld   a, (ch2_period)
	ld   l, a
	ret
ch3_read_note:
	push hl
	push de
	ld   ix, 0
	ld   hl, (ch3_song_ptr)
	ld   a, (hl)
	ld   l, a
	ld   h, 0
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	add  hl, hl
	ld   de, (envelope_data_ptr)
	add  hl, de
	ld   (ch3_env_play_ptr), hl
	ld   a, (hl)
	ld   (ch3_period), a
	ld   hl, (ch3_song_ptr)
	inc  hl
	ld   a, (hl)
	ld   (ch3_counter), a
	inc  hl
	ld   (ch3_song_ptr), hl
	exx
	ld   c, a
	exx
	pop  de
	pop  hl
	ld   a, (ch3_period)
	ld   d, a
	ret
	
	
	
song_speed:		db 0

envelope_data_ptr:	dw 0

ch1_counter:		db 0
ch2_counter:		db 0
ch3_counter:		db 0

sound_loop_cnt: 	db 0

ch1_song_ptr:		dw 0
ch2_song_ptr:		dw 0
ch3_song_ptr:		dw 0

ch1_loop_ptr:		dw 0
ch2_loop_ptr:		dw 0
ch3_loop_ptr:		dw 0

ch1_env_sel_ptr:	dw 0
ch2_env_sel_ptr:	dw 0

ch1_env_play_ptr:	dw 0
ch2_env_play_ptr:	dw 0
ch3_env_play_ptr:	dw 0

ch1_volume:		db 0
ch2_volume:		db 0

ch1_period:		db 0
ch2_period:		db 0
ch3_period:		db 0

;compiled music data

music_data:
	db $2a
	db $00
	dw .ch1
	dw .ch2
	dw .ch3
	dw .ch1loop
	dw .ch2loop
	dw .ch3loop
.envelopes:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $0d, $00, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $01, $02, $04, $0b, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b, $0a, $09, $08, $05, $04, $03, $03, $03, $04, $05, $08, $09, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0e, $ff, $ff
	db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0d, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $ff, $ff
	db $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e, $0d, $0d, $0d, $0c, $0c, $0c, $0b, $0b, $0a, $0a, $09, $08, $07, $05, $03, $01, $01, $01, $01, $01, $01, $01, $ff, $ff
	db $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $03, $03, $03, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $0f, $0f, $0e, $0d, $0b, $09, $07, $05, $03, $03, $02, $01, $01, $01, $ff, $ff
	db $1d, $1c, $1b, $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01, $00, $ff, $ff
	db $1d, $1c, $1b, $1a, $19, $18, $17, $16, $15, $14, $13, $12, $11, $10, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01, $00, $ff, $ff
	db $0d, $00, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $01, $02, $04, $0b, $05, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b, $0a, $09, $08, $05, $04, $03, $03, $03, $04, $05, $08, $09, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0e, $ff, $ff
	db $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0e, $0d, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $ff, $ff
	db $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e, $0d, $0d, $0d, $0c, $0c, $0c, $0b, $0b, $0a, $0a, $09, $08, $07, $05, $03, $01, $01, $01, $01, $01, $01, $01, $ff, $ff
	db $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $03, $03, $03, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $0f, $0f, $0e, $0d, $0b, $09, $07, $05, $03, $03, $02, $01, $01, $01, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff
.ch1:
	db $ff, $05
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $54, $01
	db $54, $02
	db $54, $01
	db $54, $02
	db $54, $02
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $54, $01
	db $54, $02
	db $54, $01
	db $54, $02
	db $54, $02
	db $ff, $07
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $ff, $05
	db $4a, $01
	db $4a, $01
	db $3f, $02
	db $38, $02
	db $32, $02
	db $38, $02
	db $3f, $02
	db $38, $01
	db $32, $03
	db $38, $02
	db $3f, $04
	db $42, $04
	db $54, $06
	db $4a, $01
	db $4a, $01
	db $3f, $02
	db $38, $02
	db $32, $02
	db $38, $02
	db $3f, $02
	db $38, $01
	db $32, $03
	db $2a, $02
	db $32, $04
	db $38, $04
	db $32, $06
	db $2f, $02
	db $32, $04
	db $3f, $04
	db $4a, $06
	db $54, $04
	db $38, $04
	db $42, $02
	db $3f, $06
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $4a, $01
	db $4a, $02
	db $54, $01
	db $54, $02
	db $54, $01
	db $54, $02
	db $54, $02
	db $ff, $07
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $4a, $01
	db $ff, $05
	db $2a, $01
	db $2a, $01
	db $32, $01
	db $2a, $02
	db $32, $03
	db $38, $02
	db $3f, $01
	db $38, $02
	db $32, $03
	db $38, $04
	db $38, $03
	db $3f, $01
	db $38, $02
	db $38, $01
	db $32, $01
	db $38, $01
	db $3f, $01
	db $4a, $01
	db $54, $01
	db $2a, $01
	db $2a, $01
	db $32, $01
	db $2a, $02
	db $32, $03
	db $38, $02
	db $3f, $01
	db $38, $02
	db $32, $03
	db $38, $02
	db $3f, $04
	db $42, $04
	db $3f, $06
	db $ff, $07
	db $2f, $04
	db $32, $04
	db $3f, $04
	db $4a, $04
	db $ff, $05
	db $32, $01
	db $32, $01
	db $32, $01
	db $38, $01
	db $38, $01
	db $38, $01
	db $32, $01
	db $32, $01
	db $32, $01
	db $38, $01
	db $38, $01
	db $38, $01
	db $32, $01
	db $32, $01
	db $2a, $01
	db $2a, $01
	db $ff, $07
	db $4a, $10
	db $ff, $04
	db $4a, $08
	db $42, $08
	db $54, $02
	db $54, $02
	db $32, $04
	db $38, $02
	db $3f, $04
	db $38, $02
	db $38, $02
	db $54, $02
	db $32, $04
	db $38, $02
	db $3f, $04
	db $4a, $02
	db $38, $02
	db $4a, $02
	db $32, $04
	db $38, $02
	db $3f, $04
	db $4a, $02
	db $ff, $07
	db $4a, $10
	db $ff, $04
	db $54, $02
	db $54, $02
	db $32, $04
	db $38, $02
	db $3f, $04
	db $38, $02
	db $38, $02
	db $54, $02
	db $32, $04
	db $38, $02
	db $3f, $04
	db $38, $02
	db $38, $02
	db $4a, $02
	db $32, $02
	db $2f, $02
	db $32, $02
	db $38, $02
	db $3f, $04
	db $ff, $03
	db $3f, $10
	db $ff, $05
	db $4a, $02
	db $4a, $02
	db $3f, $02
	db $4a, $01
	db $38, $02
	db $4a, $01
	db $35, $02
	db $32, $02
	db $2a, $02
	db $4a, $02
	db $4a, $02
	db $3f, $02
	db $4a, $01
	db $32, $02
	db $4a, $01
	db $35, $02
	db $38, $02
	db $3f, $02
	db $4a, $02
	db $4a, $02
	db $3f, $02
	db $4a, $01
	db $38, $02
	db $4a, $01
	db $35, $02
	db $32, $02
	db $2a, $02
	db $4a, $02
	db $4a, $02
	db $3f, $02
	db $4a, $01
	db $32, $02
	db $4a, $01
	db $2c, $02
	db $2a, $02
	db $27, $02
	db $54, $01
	db $4a, $01
	db $3f, $01
	db $4a, $01
	db $3f, $01
	db $38, $01
	db $32, $01
	db $2a, $02
	db $32, $01
	db $38, $01
	db $3f, $01
	db $38, $01
	db $3f, $01
	db $4a, $01
	db $54, $01
	db $4a, $02
	db $4a, $01
	db $54, $01
	db $4a, $01
	db $3f, $01
	db $38, $01
	db $3f, $01
	db $32, $01
	db $32, $01
	db $35, $01
	db $35, $01
	db $38, $01
	db $38, $01
	db $3f, $01
	db $3f, $01
	db $2a, $01
	db $32, $01
	db $2a, $01
	db $32, $01
	db $2a, $01
	db $32, $01
	db $2a, $01
	db $32, $01
	db $2a, $01
	db $32, $02
	db $38, $02
	db $3f, $03
	db $2a, $02
	db $2a, $02
	db $2a, $02
	db $2a, $01
	db $2a, $02
	db $2a, $01
	db $2a, $02
	db $2a, $02
	db $2a, $02
	db $2a, $02
	db $2a, $02
	db $2a, $02
	db $2a, $01
	db $2a, $02
	db $2c, $02
	db $2f, $02
	db $32, $14
.ch1loop:
	db $00, $ff
	db $00, $00
.ch2:
	db $ff, $05
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $64, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $95, $01
	db $95, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $02
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $95, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $85, $01
	db $7e, $02
	db $7e, $02
	db $7e, $02
	db $7e, $01
	db $7e, $02
	db $7e, $01
	db $7e, $02
	db $7e, $01
	db $7e, $01
	db $7e, $01
	db $7e, $01
	db $a8, $02
	db $a8, $02
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $70, $02
	db $70, $02
	db $70, $02
	db $70, $01
	db $70, $02
	db $70, $01
	db $70, $02
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $64, $01
	db $64, $01
	db $7e, $01
	db $7e, $01
	db $95, $01
	db $95, $01
	db $7e, $02
	db $7e, $02
	db $7e, $02
	db $7e, $01
	db $7e, $02
	db $7e, $01
	db $7e, $02
	db $7e, $01
	db $7e, $01
	db $7e, $01
	db $7e, $01
	db $a8, $02
	db $a8, $02
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $02
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $a8, $01
	db $70, $02
	db $70, $02
	db $70, $02
	db $70, $01
	db $70, $02
	db $70, $01
	db $70, $02
	db $70, $01
	db $70, $01
	db $70, $01
	db $70, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $5e, $01
	db $54, $01
	db $54, $01
	db $54, $01
	db $54, $01
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $70, $02
	db $95, $01
	db $6a, $02
	db $64, $02
	db $64, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $64, $02
	db $95, $01
	db $6a, $02
	db $70, $02
	db $7e, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $70, $02
	db $95, $01
	db $6a, $02
	db $64, $02
	db $64, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $64, $02
	db $95, $01
	db $6a, $02
	db $70, $02
	db $7e, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $70, $02
	db $95, $01
	db $6a, $02
	db $64, $02
	db $54, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $64, $02
	db $95, $01
	db $6a, $02
	db $70, $02
	db $7e, $02
	db $95, $02
	db $95, $02
	db $7e, $02
	db $95, $01
	db $70, $02
	db $95, $01
	db $6a, $02
	db $64, $02
	db $54, $02
	db $64, $02
	db $64, $02
	db $64, $02
	db $64, $01
	db $64, $02
	db $64, $01
	db $64, $02
	db $64, $02
	db $64, $02
	db $64, $02
	db $64, $02
	db $64, $02
	db $64, $01
	db $64, $02
	db $6a, $02
	db $70, $02
	db $7e, $14
.ch2loop:
	db $00, $ff
	db $00, $00
.ch3:
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0b, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $00, $02
	db $0a, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $03
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $03
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0a, $01
	db $0a, $01
	db $0b, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $02
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0a, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $00, $01
	db $0b, $01
	db $0b, $01
	db $0b, $01
	db $00, $11
.ch3loop:
	db $00, $ff
	db $00, $00


	END 

VARS_ADDR:
	db 80h



