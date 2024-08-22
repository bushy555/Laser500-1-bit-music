
	output "falling.bin"


	org	$8995
;	org	$89A5
	



   ; add a basic header so that the program can be "RUN"
   ; 2021 A equ &H89A5:CALL A:END
   	db $FF,$FF,$E5,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00



wave1	equ 0
wave2	equ $800
wave3	equ $1000
wave4	equ $1800
wave5	equ $2000
wave6	equ $2800
wave7	equ $3000
wave8	equ $3800
wave9	equ $4000
wave10	equ $4800
wave11	equ $5000
wave12	equ $5800
wave13	equ $6000
wave14	equ $6800
wave15	equ $7000
wave16	equ $7800
wave17	equ $8000
wave18	equ $8800
wave19	equ $9000
wave20	equ $9800
wave21	equ $a000
wave22	equ $a800
wave23	equ $b000
wave24	equ $b800
wave25	equ $c000
wave26	equ $c800
wave27	equ $d000
wave28	equ $d800
wave29	equ $e000
wave30	equ $e800
wave31	equ $f000
wave32	equ $f800

kick equ $1
hhat equ $40

rest	equ 0
noise	equ $75

a0	 equ $17
ais0	 equ $19
b0	 equ $1a
c1	 equ $1c
cis1	 equ $1d
d1	 equ $1f
dis1	 equ $21
e1	 equ $23
f1	 equ $25
fis1	 equ $27
g1	 equ $2a
gis1	 equ $2c
a1	 equ $2f
ais1	 equ $32
b1	 equ $34
c2	 equ $38
cis2	 equ $3b
d2	 equ $3e
dis2	 equ $42
e2	 equ $46
f2	 equ $4a
fis2	 equ $4f
g2	 equ $53
gis2	 equ $58
a2	 equ $5d
ais2	 equ $63
b2	 equ $69
c3	 equ $6f
cis3	 equ $76
d3	 equ $7d
dis3	 equ $84
e3	 equ $8c
f3	 equ $94
fis3	 equ $9d
g3	 equ $a7
gis3	 equ $b0
a3	 equ $bb
ais3	 equ $c6
b3	 equ $d2
c4	 equ $de
cis4	 equ $ec
d4	 equ $fa
dis4	 equ $108
e4	 equ $118
f4	 equ $129
fis4	 equ $13a
g4	 equ $14d
gis4	 equ $161
a4	 equ $176
ais4	 equ $18c
b4	 equ $1a4
c5	 equ $1bd
cis5	 equ $1d7
d5	 equ $1f3
dis5	 equ $211
e5	 equ $230
f5	 equ $252
fis5	 equ $275
g5	 equ $29a
gis5	 equ $2c2
a5	 equ $2ec
ais5	 equ $318
b5	 equ $348
c6	 equ $379
cis6	 equ $3ae
d6	 equ $3e6
dis6	 equ $422
e6	 equ $461
f6	 equ $4a3
fis6	 equ $4ea
g6	 equ $535
gis6	 equ $584
a6	 equ $5d8
ais6	 equ $631
b6	 equ $68f
c7	 equ $6f3
cis7	 equ $75d
d7	 equ $7cd

	;test code

begin

	ld hl,music_data
	call play
	ret
	


;wtbeep 0.1
;experimental beeper engine for ZX Spectrum
;by utz 11'2016 * www.irrlichtproject.de



play
	ld	a, 2	
	out	($41), a

	di
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld (mLoopVar),de
	ld (seqpntr),hl
	exx
	ld c,0			;timer lo
	push hl			;preserve HL' for return to BASIC
	ld (oldSP),sp
	ld ix,0
	ld iy,0

;*******************************************************************************
rdseq
seqpntr equ $+1
	ld sp,0
	xor a
	pop de			;pattern pointer to DE
	or d
	ld (seqpntr),sp
	jr nz,rdptn0
	
mLoopVar equ $+1
	ld sp,0		;get loop point		;comment out to disable looping
	jr rdseq+3					;comment out to disable looping

;*******************************************************************************
exit
oldSP equ $+1
	ld sp,0
	pop hl
	exx
	ei
	ret

;*******************************************************************************
rdptn0
	ld (ptnpntr),de

readPtn
;	in a,($fe)		;read kbd
;	cpl
;	and $1f
;	jr nz,exit


ptnpntr equ $+1
	ld sp,0	
	;jr $
	pop af			;timer + ctrl
	jr z,rdseq
	
	ld b,a			;timer ($ ticks)
	
	jr c,_noUpd1
	
	ex af,af'
	
	ld h,mixAlgo/256
	pop de
	ld a,d
	
	and $f8
	ld l,a
	
	ld a,(hl)
	ld (algo1),a
	inc l
	ld a,(hl)
	ld (algo1+1),a
	inc l
	ld a,(hl)
	ld (algo1+2),a
	inc l
	ld a,(hl)
	ld (algo1+3),a
	inc l
	ld a,(hl)
	ld (algo1+4),a
	
	ld hl,0
	
	ld a,d
	and $7
	ld d,a
	
	ex af,af'

_noUpd1
	jp pe,_noUpd2
	
	exx
	ex af,af'
	
	ld h,mixAlgo/256
	pop bc
	ld a,b
	
	and $f8
	ld l,a
	
	ld a,(hl)
	ld (algo2),a
	inc l
	ld a,(hl)
	ld (algo2+1),a
	inc l
	ld a,(hl)
	ld (algo2+2),a
	inc l
	ld a,(hl)
	ld (algo2+3),a
	inc l
	ld a,(hl)
	ld (algo2+4),a
	
	ld hl,0
	
	ld a,b
	and $7
	ld b,a	
	
	ex af,af'
	exx
	
_noUpd2
	jp m,_noUpd3
	
	exx
	
	pop de
	ld a,d
	ex af,af'
	ld a,d
	and $7
	ld d,a
	ld (fdiv3),de
	
	ex af,af'
	and $f8
	ld e,a
	ld d,mixAlgo/256
	
	ld a,(de)
	ld (algo3),a
	inc e
	ld a,(de)
	ld (algo3+1),a
	inc e
	ld a,(de)
	ld (algo3+2),a
	inc e
	ld a,(de)
	ld (algo3+3),a
	inc e
	ld a,(de)
	ld (algo3+4),a
	
	ld de,0
	exx

_noUpd3
	
	pop af
	jp po,_noSweepReset
	
	ld iy,0					;reset sweep registers
	ld ixh,0
_noSweepReset
	jp c,drum1
	jr z,drum2
	dec sp
drumRet	
	
	ld (ptnpntr),sp
	
fdiv3 equ $+1
	ld sp,0

;*******************************************************************************
playNote
	add hl,de	;11	
	ld a,h		;4

algo1	
	ds 5		;20


	sra	a
	sra	a
	sra	a

	XOR   	1
	ld	($6800),a	
	exx		;4
	
	add hl,bc	;11
	ld a,h		;4

algo2	
	ds 5		;20
	
;			inc bc		;6		;timing

	sra	a
	sra	a
	sra	a

	XOR   	1
	ld	($6800),a	
	ex de,hl	;4
	
	add hl,sp	;11
	ld a,h		;4

algo3	
	ds 5		;20
	
;	nop		;4		;timing
;	nop		;4
	
	ex de,hl	;4
	

	sra	a
	sra	a
	sra	a

	XOR   	1
	ld	($6800),a	
	
	exx		;4
	
	dec c		;4
	jp nz,playNote	;10
			;184
	
	inc iyl				;update sweep counters
	ld a,iyl
	rrca
	rrca
	ld iyh,a
	rrca
	ld ixh,a
	
	dec b
	jp nz,playNote

	jp readPtn
	
;*******************************************************************************
drum2						;noise
	ld (hlRest),hl
	ld (bcRest),bc
	
	ld b,a
	ex af,af'
	
	ld a,b
	ld hl,1					;$1 (snare) <- 1011 -> $1237 (hat)
	rrca
	jr c,setVol
	ld hl,$1237

setVol	
	and $7f
	ld (dvol),a	
				
	ld bc,$a803				;length
sloop
	add hl,hl		;11
	sbc a,a			;4
	xor l			;4
	ld l,a			;4

dvol equ $+1	
	cp $80			;7		;volume
	sbc a,a			;4
				
;	or $7			;7		;border

	sra	a
	sra	a
	sra	a

	XOR   	1
	ld	($6800),a
	djnz sloop		;13/8

	dec c			;4
	jr nz,sloop		;12

	jr drumEnd
	
drum1						;kick
	ld (deRest),de
	ld (bcRest),bc
	ld (hlRest),hl

	ld d,a					;A = start_pitch<<1
	ld e,0					;B = 0
	ld h,e
	ld l,e
	
	ex af,af'
	
	srl d					;set start pitch
	rl e
	
	ld c,$3				;length
	
xlllp
	add hl,de
	jr c,_noUpd
	ld a,e
_slideSpeed equ $+1
	sub $8;10					;speed
	ld e,a
	sbc a,a
	add a,d
	ld d,a
_noUpd
	ld a,h					
	or $7					;border

	sra	a
	sra	a
	sra	a

	XOR   	1
	ld	($6800),a
	djnz xlllp
	dec c
	jr nz,xlllp

						;45680 (/224 = 248.3)
deRest equ $+1
	ld de,0


drumEnd
hlRest equ $+1
	ld hl,0
bcRest equ $+1
	ld bc,0
	
	ld c,6					;adjust timer
	jp drumRet

;*******************************************************************************

	align 256

mixAlgo

	ds 8			;00	50% square
	
	daa			;02	32% square
	and h
	ds 6
	
	rlca			;01	25% square
	and h
	ds 6
	
	daa			;03	19% square
	cpl
	and h
	ds 5
	
	inc a			;04	12.5% square
	inc a
	xor h
	rrca
	ds 4
	
	inc a			;05	6.25% square
	xor h
	rrca
	ds 5

	add a,iyl		;06	duty sweep (fast) (cpl, dec a is not needed, but makes for a nicer attack env)
	cpl
	dec a
	or h
	ds 3
	
	add a,iyh		;07	duty sweep (slow)
	cpl
	dec a
	or h
	ds 3
	
	add a,ixh		;08	duty sweep (very slow, start lo)
	cpl
	dec a
	and h
	ds 3

	add a,ixh		;09	duty sweep (very slow, start hi)
	and h
	ds 5
	

	add a,iyh		;0a	duty sweep (slow) + oct
	rlca
	xor h
	ds 4

	add a,iyh		;0b	duty sweep (slow) - oct
	rrca
	xor h
	ds 4
	
	add a,iyl		;0c	duty sweep (fast) - oct
	rrca
	xor h
	ds 4

	daa			;0d	vowel 1
	rlca
	cpl
	xor h
	ds 4
	
	daa			;0e	vowel 2
	rlca
	rlca
	cpl
	xor h
	ds 3
	
	daa			;0f	vowel 3
	cpl
	xor h
	ds 5

	rrca			;10	vowel 4
	rrca
	sbc a,a
	and h
	rlca
	ds 3
	
	rlca			;11	vowel 5
	rlca
	xor h
	rlca
	ds 4
	
	rrca			;12	vowel 6
	sbc a,a
	and h
	rlca
	ds 4
	
	cpl			;13	rasp 1
	daa
	sbc a,a
	rlca
	and h
	ds 3
	
	rlca			;14	rasp 2
	rlca
	sbc a,a
	and h
	ds 4

	daa			;15	phat rasp
	rrca
	rrca
	cpl
	or h
	ds 3

	daa			;16	phat 2
	rrca
	rrca
	cpl
	and h
	ds 3
	
	daa			;17	phat 3
	rlca
	rlca
	cpl
	and h
	ds 3

	daa			;18	phat 4
	rlca
	cpl
	and h
	ds 4
	
	daa			;19	phat 5
	rrca
	rrca
	cpl
	xor h
	ds 3
	
	cpl			;1a	phat 6
	daa
	sbc a,a
	rlca
	xor h
	ds 3
	
	rlca			;1b	phat 7
	rlca
	sbc a,a
	and h
	rlca
	ds 3
	
	rlc h			;1c	noise 1
	and h
	ds 5
	
	rlc h			;1e	noise 2
	sbc a,a
	or h
	ds 4
	
	rlc h			;1d	noise 3
	ds 6
	
	rlc h			;1f	noise 4
	or h
	xor l
	ds 5



	align 256





;compiled music data

music_data
	dw .loop
	dw .pattern1
.loop:
	dw .pattern2
	dw 0
.pattern1
	dw #400,#382f,#0,#0,#701
	dw #485
	db 0
	dw #484,#388d
	db 0
	dw #485
	db 0
	dw #484,#382f
	db 0
	dw #485
	db 0
	dw #405,#288d
	db 0
	dw #485
	db 0
	dw #404,#3870,#2800,#701
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #404,#382f,#2870
	db 0
	dw #485
	db 0
	dw #404,#3870,#2800
	db 0
	dw #485
	db 0
	dw #485,#701
	dw #485
	db 0
	dw #404,#382f,#2870
	db 0
	dw #485
	db 0
	dw #404,#3870,#2800
	db 0
	dw #485
	db 0
	dw #484,#382f
	db 0
	dw #485
	db 0
	dw #404,#386a,#2870,#701
	dw #485
	db 0
	dw #404,#382f,#2800
	db 0
	dw #485
	db 0
	dw #404,#3870,#286a
	db 0
	dw #485
	db 0
	dw #405,#2800
	db 0
	dw #485
	db 0
	dw #404,#3025,#2870,#701
	dw #485
	db 0
	dw #404,#308d,#2800
	db 0
	dw #485
	db 0
	dw #484,#3025
	db 0
	dw #485
	db 0
	dw #405,#288d
	db 0
	dw #485
	db 0
	dw #404,#3070,#2800,#701
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #404,#3025,#2870
	db 0
	dw #485
	db 0
	dw #404,#3070,#2800
	db 0
	dw #485
	db 0
	dw #485,#701
	dw #485
	db 0
	dw #404,#3025,#2870
	db 0
	dw #485
	db 0
	dw #404,#306a,#2800
	db 0
	dw #485
	db 0
	dw #484,#3070
	db 0
	dw #485
	db 0
	dw #405,#286a,#701
	dw #485
	db 0
	dw #404,#3025,#2870
	db 0
	dw #485
	db 0
	dw #405,#2800
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #484,#301f,#701
	dw #485
	db 0
	dw #484,#308d
	db 0
	dw #485
	db 0
	dw #484,#301f
	db 0
	dw #485
	db 0
	dw #405,#288d
	db 0
	dw #485
	db 0
	dw #404,#3070,#2800,#701
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #404,#301f,#2870
	db 0
	dw #485
	db 0
	dw #404,#3070,#2800
	db 0
	dw #485
	db 0
	dw #485,#701
	dw #485
	db 0
	dw #404,#301f,#2870
	db 0
	dw #485
	db 0
	dw #404,#3070,#2800
	db 0
	dw #485
	db 0
	dw #484,#301f
	db 0
	dw #485
	db 0
	dw #404,#306a,#2870,#701
	dw #485
	db 0
	dw #404,#301f,#2800
	db 0
	dw #485
	db 0
	dw #404,#3070,#286a
	db 0
	dw #485
	db 0
	dw #405,#2800
	db 0
	dw #485
	db 0
	dw #404,#3025,#2870,#701
	dw #485
	db 0
	dw #404,#3070,#2800
	db 0
	dw #485
	db 0
	dw #484,#3025
	db 0
	dw #485
	db 0
	dw #405,#2870
	db 0
	dw #485
	db 0
	dw #404,#306a,#2800,#701
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #404,#3070,#286a
	db 0
	dw #485
	db 0
	dw #405,#2800
	db 0
	dw #485
	db 0
	dw #404,#302a,#2870,#701
	dw #485
	db 0
	dw #404,#3070,#2800
	db 0
	dw #485
	db 0
	dw #484,#302a
	db 0
	dw #485
	db 0
	dw #405,#2870
	db 0
	dw #485
	db 0
	dw #400,#306a,#3854,#2800,#8140
	dw #481,#383f
	db 0
	dw #481,#3835,#8140
	dw #481,#382f
	db 0
	dw #400,#3070,#382a,#286a,#8140
	dw #481,#381f
	db 0
	dw #401,#381a,#2800,#8140
	dw #481,#3817
	db 0
	dw #480,#382f,#382f,#401
	dw #481,#3800
	db 0
	dw #480,#388d,#382f
	db 0
	dw #481,#3800
	db 0
	dw #480,#382f,#382f,#c40
	dw #481,#3800
	db 0
	dw #401,#382f,#288d,#c40
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#382f
	db 0
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870,#c40
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#c40
	dw #481,#3800
	db 0
	dw #481,#382f,#c40
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#382f,#382f,#c40
	dw #481,#3800
	db 0
	dw #400,#386a,#382f,#2870,#205
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#286a,#c40
	dw #481,#3800
	db 0
	dw #401,#382f,#2800,#c40
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#401
	dw #481,#3800
	db 0
	dw #400,#308d,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#3825,#401
	dw #481,#3800
	db 0
	dw #401,#3825,#288d,#c40
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#c40
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800,#c40
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#306a,#3825,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#3070,#3825,#c40
	dw #481,#3800
	db 0
	dw #401,#384b,#286a,#205
	dw #481,#3838
	db 0
	dw #400,#3025,#382f,#2870
	db 0
	dw #481,#382a
	db 0
	dw #401,#3825,#2800,#6740
	dw #481,#381c
	db 0
	dw #481,#3817,#6740
	dw #481,#3815
	db 0
	dw #480,#301f,#381f,#401
	dw #481,#3800
	db 0
	dw #480,#308d,#381f
	db 0
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#1840
	dw #481,#3800
	db 0
	dw #401,#381f,#288d,#1840
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#381f
	db 0
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870,#1840
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#1840
	dw #481,#3800
	db 0
	dw #481,#381f,#1840
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#1840
	dw #481,#3800
	db 0
	dw #400,#306a,#381f,#2870,#205
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#286a,#1840
	dw #481,#3800
	db 0
	dw #401,#381f,#2800,#1840
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#401
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#3825,#401
	dw #481,#3800
	db 0
	dw #401,#3825,#2870,#1840
	dw #481,#3800
	db 0
	dw #400,#306a,#3825,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#286a,#401
	dw #481,#3800
	db 0
	dw #401,#3825,#2800,#1840
	dw #481,#3800
	db 0
	dw #400,#302a,#382a,#2870,#401
	dw #481,#3800
	db 0
	dw #401,#382a,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#306a,#382a,#401
	dw #481,#3800
	db 0
	dw #480,#3070,#382a,#1840
	dw #481,#3800
	db 0
	dw #401,#382a,#286a,#205
	dw #481,#3800
	db 0
	dw #400,#306a,#382a,#2870
	db 0
	dw #480,#305e,#3800
	db 0
	dw #480,#3054,#382a,#205
	dw #480,#3046,#3800
	db 0
	dw #400,#3000,#382a,#286a,#205
	dw #401,#3800,#285e
	db 0
	dw #400,#70,#382f,#2854,#401
	dw #400,#0,#3800,#2846
	db 0
	dw #400,#70,#382f,#2800
	db 0
	dw #480,#0,#3800
	db 0
	dw #401,#385e,#38e1
	db 0
	dw #481,#3800
	db 0
	dw #400,#870,#382f,#38d4
	db 0
	dw #480,#800,#3800
	db 0
	dw #400,#870,#382f,#38bd,#1401
	dw #480,#800,#3800
	db 0
	dw #401,#385e,#38a8
	db 0
	dw #481,#3800
	db 0
	dw #400,#1070,#382f,#387e
	db 0
	dw #480,#1000,#3800
	db 0
	dw #400,#1070,#385e,#388d
	db 0
	dw #480,#1000,#3800
	db 0
	dw #401,#382f,#3800,#401
	dw #481,#3800
	db 0
	dw #480,#188d,#382f
	db 0
	dw #480,#1800,#3800
	db 0
	dw #400,#188d,#385e,#407e
	db 0
	dw #480,#1800,#3800
	db 0
	dw #401,#382f,#4070
	db 0
	dw #481,#3800
	db 0
	dw #400,#208d,#382f,#406a,#1401
	dw #480,#2000,#3800
	db 0
	dw #400,#208d,#385e,#4070
	db 0
	dw #480,#2000,#3800
	db 0
	dw #400,#207e,#382f,#407e
	db 0
	dw #480,#2000,#3800
	db 0
	dw #401,#385e,#405e
	db 0
	dw #481,#3800
	db 0
	dw #400,#2870,#382f,#4000,#401
	dw #480,#2800,#3800
	db 0
	dw #480,#2870,#382f
	db 0
	dw #480,#2800,#3800
	db 0
	dw #401,#385e,#485e
	db 0
	dw #481,#3800
	db 0
	dw #400,#2070,#382f,#4854
	db 0
	dw #480,#2000,#3800
	db 0
	dw #400,#2070,#382f,#4846,#1401
	dw #480,#2000,#3800
	db 0
	dw #401,#385e,#483f
	db 0
	dw #481,#3800
	db 0
	dw #400,#1870,#382f,#4838
	db 0
	dw #480,#1800,#3800
	db 0
	dw #400,#1870,#385e,#483f
	db 0
	dw #480,#1800,#3800
	db 0
	dw #401,#382f,#4800,#401
	dw #481,#3800
	db 0
	dw #480,#108d,#382f
	db 0
	dw #480,#1000,#3800
	db 0
	dw #400,#108d,#385e,#3038
	db 0
	dw #400,#1000,#3800,#3046
	db 0
	dw #401,#382f,#305e
	db 0
	dw #401,#3800,#3070
	db 0
	dw #400,#88d,#382f,#308d,#1401
	dw #400,#800,#3800,#305e
	db 0
	dw #400,#88d,#385e,#3070
	db 0
	dw #400,#800,#3800,#308d
	db 0
	dw #400,#87e,#382f,#30bd
	db 0
	dw #400,#800,#3800,#308d
	db 0
	dw #401,#385e,#30bd
	db 0
	dw #401,#3800,#30e1
	db 0
	dw #400,#70,#3825,#38a8,#401
	dw #404,#0,#38bd
	db 0
	dw #400,#70,#3825,#38d4
	db 0
	dw #404,#0,#38e1
	db 0
	dw #481,#384b
	db 0
	dw #485
	db 0
	dw #480,#870,#3825
	db 0
	dw #484,#800
	db 0
	dw #480,#870,#3825,#1401
	dw #484,#800
	db 0
	dw #481,#384b
	db 0
	dw #485
	db 0
	dw #480,#1070,#3825
	db 0
	dw #484,#1000
	db 0
	dw #480,#1070,#384b
	db 0
	dw #484,#1000
	db 0
	dw #401,#3825,#390b,#401
	dw #405,#391b
	db 0
	dw #480,#188d,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#188d,#384b
	db 0
	dw #484,#1800
	db 0
	dw #401,#3825,#38fc
	db 0
	dw #485
	db 0
	dw #480,#208d,#3825,#1401
	dw #484,#2000
	db 0
	dw #480,#208d,#384b
	db 0
	dw #484,#2000
	db 0
	dw #400,#207e,#3825,#38d4
	db 0
	dw #484,#2000
	db 0
	dw #481,#384b
	db 0
	dw #485
	db 0
	dw #480,#2870,#3825,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#3825
	db 0
	dw #484,#2800
	db 0
	dw #481,#384b
	db 0
	dw #485
	db 0
	dw #480,#2070,#3825
	db 0
	dw #484,#2000
	db 0
	dw #400,#2070,#3825,#38c8,#1401
	dw #404,#2000,#38bd
	db 0
	dw #401,#384b,#38a8
	db 0
	dw #485
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#1870,#384b
	db 0
	dw #484,#1800
	db 0
	dw #481,#3825,#401
	dw #485
	db 0
	dw #480,#108d,#3825
	db 0
	dw #484,#1000
	db 0
	dw #400,#108d,#384b,#38a8
	db 0
	dw #404,#1000,#3896
	db 0
	dw #401,#3825,#387e
	db 0
	dw #405,#3870
	db 0
	dw #400,#88d,#3825,#38a8,#1401
	dw #404,#800,#3896
	db 0
	dw #400,#88d,#384b,#387e
	db 0
	dw #404,#800,#3870
	db 0
	dw #400,#87e,#3825,#38a8
	db 0
	dw #404,#800,#3896
	db 0
	dw #401,#384b,#387e
	db 0
	dw #405,#3870
	db 0
	dw #400,#70,#381f,#3800,#401
	dw #484,#0
	db 0
	dw #480,#70,#381f
	db 0
	dw #484,#0
	db 0
	dw #401,#383f,#38e1,#c40
	dw #485
	db 0
	dw #400,#870,#381f,#38d4,#c40
	dw #484,#800
	db 0
	dw #400,#870,#381f,#38bd,#1401
	dw #484,#800
	db 0
	dw #401,#383f,#38a8,#c40
	dw #485
	db 0
	dw #400,#1070,#381f,#387e,#c40
	dw #484,#1000
	db 0
	dw #400,#1070,#383f,#388d,#c40
	dw #484,#1000
	db 0
	dw #401,#381f,#3800,#401
	dw #485
	db 0
	dw #480,#188d,#381f
	db 0
	dw #484,#1800
	db 0
	dw #400,#188d,#383f,#407e,#c40
	dw #484,#1800
	db 0
	dw #401,#381f,#4070,#c40
	dw #485
	db 0
	dw #400,#208d,#381f,#406a,#1401
	dw #484,#2000
	db 0
	dw #400,#208d,#383f,#4070,#c40
	dw #484,#2000
	db 0
	dw #400,#207e,#381f,#407e,#c40
	dw #484,#2000
	db 0
	dw #401,#383f,#405e,#c40
	dw #485
	db 0
	dw #480,#2870,#381f,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#381f
	db 0
	dw #484,#2800
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #480,#2070,#381f,#c40
	dw #484,#2000
	db 0
	dw #480,#2070,#381f,#1401
	dw #484,#2000
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #480,#1870,#381f,#c40
	dw #484,#1800
	db 0
	dw #480,#1870,#383f,#c40
	dw #484,#1800
	db 0
	dw #401,#381f,#409f,#401
	dw #405,#40a8
	db 0
	dw #480,#108d,#381f
	db 0
	dw #484,#1000
	db 0
	dw #480,#108d,#383f,#c40
	dw #484,#1000
	db 0
	dw #481,#381f,#c40
	dw #485
	db 0
	dw #400,#88d,#381f,#40b2,#1401
	dw #404,#800,#40bd
	db 0
	dw #480,#88d,#383f,#c40
	dw #484,#800
	db 0
	dw #480,#87e,#381f,#c40
	dw #484,#800
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #400,#70,#3825,#38e1,#401
	dw #484,#0
	db 0
	dw #480,#70,#3825
	db 0
	dw #484,#0
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#870,#3825,#c40
	dw #484,#800
	db 0
	dw #480,#870,#3825,#1401
	dw #484,#800
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#1070,#3825,#c40
	dw #484,#1000
	db 0
	dw #480,#1070,#384b,#c40
	dw #484,#1000
	db 0
	dw #481,#3825,#401
	dw #485
	db 0
	dw #480,#188d,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#188d,#384b,#c40
	dw #484,#1800
	db 0
	dw #481,#3825,#c40
	dw #485
	db 0
	dw #480,#208d,#3825,#1401
	dw #484,#2000
	db 0
	dw #480,#208d,#384b,#c40
	dw #484,#2000
	db 0
	dw #400,#207e,#3825,#38e1,#c40
	dw #404,#2000,#38bd
	db 0
	dw #401,#384b,#38a8,#c40
	dw #405,#38bd
	db 0
	dw #400,#2870,#382a,#38e1,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#382a
	db 0
	dw #484,#2800
	db 0
	dw #481,#3854,#c40
	dw #485
	db 0
	dw #480,#2070,#382a,#c40
	dw #484,#2000
	db 0
	dw #480,#2070,#382a,#1401
	dw #484,#2000
	db 0
	dw #481,#3854,#c40
	dw #485
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#1800
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#1800
	db 0
	dw #401,#382a,#38d4,#401
	dw #485
	db 0
	dw #480,#108d,#382a
	db 0
	dw #484,#1000
	db 0
	dw #480,#108d,#3854,#c40
	dw #484,#1000
	db 0
	dw #481,#382a,#c40
	dw #485
	db 0
	dw #480,#88d,#382a,#1401
	dw #484,#800
	db 0
	dw #480,#88d,#3854,#c40
	dw #484,#800
	db 0
	dw #400,#87e,#382a,#38c8,#c40
	dw #404,#800,#38bd
	db 0
	dw #401,#3854,#38b2,#c40
	dw #405,#38a8
	db 0
	dw #400,#405e,#382f,#282f,#401
	dw #404,#4000,#2800
	db 0
	dw #400,#405e,#382f,#282f
	db 0
	dw #404,#4000,#2800
	db 0
	dw #401,#3800,#202f
	db 0
	dw #405,#2000
	db 0
	dw #400,#405e,#382f,#202f
	db 0
	dw #404,#4000,#2000
	db 0
	dw #400,#405e,#382f,#182f,#401
	dw #404,#4000,#1800
	db 0
	dw #401,#3800,#182f
	db 0
	dw #405,#1800
	db 0
	dw #400,#405e,#382f,#102f
	db 0
	dw #404,#4000,#1000
	db 0
	dw #400,#405e,#382f,#102f
	db 0
	dw #404,#4000,#1000
	db 0
	dw #401,#38e1,#82f,#401
	dw #401,#3800,#800
	db 0
	dw #401,#38d4,#82f
	db 0
	dw #401,#3800,#800
	db 0
	dw #400,#30e1,#38bd,#102f
	db 0
	dw #400,#3000,#3800,#1000
	db 0
	dw #400,#30d4,#388d,#102f
	db 0
	dw #400,#3000,#3800,#1000
	db 0
	dw #400,#30bd,#38e1,#182f,#401
	dw #400,#3000,#3800,#1800
	db 0
	dw #400,#308d,#38d4,#182f
	db 0
	dw #400,#3000,#3800,#1800
	db 0
	dw #400,#30e1,#38bd,#202f
	db 0
	dw #400,#3000,#3800,#2000
	db 0
	dw #400,#30d4,#388d,#202f
	db 0
	dw #400,#3000,#3800,#2000
	db 0
	dw #400,#485e,#382f,#282f,#401
	dw #404,#4800,#2800
	db 0
	dw #400,#485e,#382f,#282f
	db 0
	dw #404,#4800,#2800
	db 0
	dw #401,#3800,#202f
	db 0
	dw #405,#2000
	db 0
	dw #400,#485e,#382f,#202f
	db 0
	dw #404,#4800,#2000
	db 0
	dw #400,#485e,#382f,#182f,#401
	dw #404,#4800,#1800
	db 0
	dw #401,#3800,#182f
	db 0
	dw #405,#1800
	db 0
	dw #400,#485e,#382f,#202f
	db 0
	dw #404,#4800,#2000
	db 0
	dw #400,#485e,#382f,#202f
	db 0
	dw #404,#4800,#2000
	db 0
	dw #401,#3800,#282f,#401
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #405,#282f
	db 0
	dw #405,#2800
	db 0
	dw #480,#382f,#382f,#201
	dw #481,#3800
	db 0
	dw #480,#388d,#382f
	db 0
	dw #481,#3800
	db 0
	dw #480,#382f,#382f,#540
	dw #481,#3800
	db 0
	dw #401,#382f,#288d
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#201
	dw #481,#3800
	db 0
	dw #481,#382f
	db 0
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870,#540
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #481,#382f,#201
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#540
	dw #481,#3800
	db 0
	dw #480,#382f,#382f
	db 0
	dw #481,#3800
	db 0
	dw #400,#386a,#382f,#2870,#201
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#286a,#540
	dw #481,#3800
	db 0
	dw #401,#382f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#201
	dw #481,#3800
	db 0
	dw #400,#308d,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#3825,#540
	dw #481,#3800
	db 0
	dw #401,#3825,#288d
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800,#201
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#540
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #481,#3825,#201
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#306a,#3825,#2800,#540
	dw #481,#3800
	db 0
	dw #480,#3070,#3825
	db 0
	dw #481,#3800
	db 0
	dw #401,#3825,#286a,#201
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870
	db 0
	dw #481,#3800
	db 0
	dw #401,#3825,#2800,#540
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#201
	dw #481,#3800
	db 0
	dw #480,#308d,#381f
	db 0
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#540
	dw #481,#3800
	db 0
	dw #401,#381f,#288d,#540
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#201
	dw #481,#3800
	db 0
	dw #481,#381f
	db 0
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870,#540
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#540
	dw #481,#3800
	db 0
	dw #481,#381f,#201
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#540
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#540
	dw #481,#3800
	db 0
	dw #400,#306a,#381f,#2870,#201
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#286a,#540
	dw #481,#3800
	db 0
	dw #401,#381f,#2800,#540
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#201
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#3825,#540
	dw #481,#3800
	db 0
	dw #401,#3825,#2870,#540
	dw #481,#3800
	db 0
	dw #400,#306a,#3825,#2800,#201
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#286a,#540
	dw #481,#3800
	db 0
	dw #401,#3825,#2800,#540
	dw #481,#3800
	db 0
	dw #400,#302a,#382a,#2870,#201
	dw #481,#3800
	db 0
	dw #400,#3070,#382a,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#302a,#382a
	db 0
	dw #481,#3800
	db 0
	dw #401,#382a,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#306a,#3854,#2800,#8140
	dw #481,#383f
	db 0
	dw #481,#3835,#8140
	dw #481,#382f
	db 0
	dw #400,#3070,#382a,#286a,#8140
	dw #481,#381f
	db 0
	dw #401,#381a,#2800,#8140
	dw #481,#3817
	db 0
	dw #480,#382f,#382f,#401
	dw #481,#3800
	db 0
	dw #480,#388d,#382f
	db 0
	dw #481,#3800
	db 0
	dw #480,#382f,#385e,#c40
	dw #481,#3800
	db 0
	dw #401,#382f,#288d,#c40
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#385e
	db 0
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870,#c40
	dw #481,#3800
	db 0
	dw #400,#3870,#385e,#2800,#c40
	dw #481,#3800
	db 0
	dw #481,#382f,#c40
	dw #481,#3800
	db 0
	dw #400,#382f,#382f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#385e,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#382f,#382f,#c40
	dw #481,#3800
	db 0
	dw #400,#386a,#382f,#2870,#205
	dw #481,#3800
	db 0
	dw #400,#382f,#385e,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3870,#382f,#286a,#c40
	dw #481,#3800
	db 0
	dw #401,#385e,#2800,#c40
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#401
	dw #481,#3800
	db 0
	dw #400,#308d,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#384b,#401
	dw #481,#3800
	db 0
	dw #401,#3825,#288d,#c40
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#384b
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#c40
	dw #481,#3800
	db 0
	dw #400,#3070,#384b,#2800,#c40
	dw #481,#3800
	db 0
	dw #481,#3825
	db 0
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#306a,#384b,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#3070,#3825,#c40
	dw #481,#3800
	db 0
	dw #401,#384b,#286a,#205
	dw #481,#3838
	db 0
	dw #400,#3025,#382f,#2870
	db 0
	dw #481,#382a
	db 0
	dw #401,#3825,#2800,#6740
	dw #481,#381c
	db 0
	dw #481,#3817,#6740
	dw #481,#3815
	db 0
	dw #480,#301f,#381f,#401
	dw #481,#3800
	db 0
	dw #480,#308d,#381f
	db 0
	dw #481,#3800
	db 0
	dw #480,#301f,#383f,#1840
	dw #481,#3800
	db 0
	dw #401,#381f,#288d,#1840
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#383f
	db 0
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870,#1840
	dw #481,#3800
	db 0
	dw #400,#3070,#383f,#2800,#1840
	dw #481,#3800
	db 0
	dw #481,#381f,#1840
	dw #481,#3800
	db 0
	dw #400,#301f,#381f,#2870
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#383f,#2800,#401
	dw #481,#3800
	db 0
	dw #480,#301f,#381f,#1840
	dw #481,#3800
	db 0
	dw #400,#306a,#381f,#2870,#205
	dw #481,#3800
	db 0
	dw #400,#301f,#383f,#2800
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#381f,#286a,#1840
	dw #481,#3800
	db 0
	dw #401,#383f,#2800,#1840
	dw #481,#3800
	db 0
	dw #400,#3025,#3825,#2870,#401
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#2800
	db 0
	dw #481,#3800
	db 0
	dw #480,#3025,#384b,#401
	dw #481,#3800
	db 0
	dw #401,#3825,#2870,#1840
	dw #481,#3800
	db 0
	dw #400,#306a,#3825,#2800,#205
	dw #481,#3800
	db 0
	dw #481,#384b
	db 0
	dw #481,#3800
	db 0
	dw #400,#3070,#3825,#286a,#401
	dw #481,#3800
	db 0
	dw #401,#384b,#2800,#1840
	dw #481,#3800
	db 0
	dw #400,#302a,#382a,#2870,#401
	dw #481,#3800
	db 0
	dw #400,#3070,#382a,#308c
	db 0
	dw #481,#3800
	db 0
	dw #400,#3000,#382a,#3000
	db 0
	dw #481,#3800
	db 0
	dw #481,#382a
	db 0
	dw #481,#3800
	db 0
	dw #400,#306a,#3854,#307e
	db 0
	dw #481,#3846
	db 0
	dw #481,#383f
	db 0
	dw #481,#3835
	db 0
	dw #400,#3070,#382a,#308d,#1401
	dw #481,#3823
	db 0
	dw #481,#381f,#1401
	dw #481,#381a
	db 0
	dw #400,#70,#382f,#3000,#401
	dw #480,#0,#3800
	db 0
	dw #480,#70,#382f
	db 0
	dw #480,#0,#3800
	db 0
	dw #401,#385e,#38e1,#c40
	dw #481,#3800
	db 0
	dw #400,#870,#382f,#38d4,#c40
	dw #480,#800,#3800
	db 0
	dw #400,#870,#382f,#38bd,#1401
	dw #480,#800,#3800
	db 0
	dw #401,#385e,#38a8,#c40
	dw #481,#3800
	db 0
	dw #400,#1070,#382f,#387e,#c40
	dw #480,#1000,#3800
	db 0
	dw #400,#1070,#385e,#388d,#c40
	dw #480,#1000,#3800
	db 0
	dw #401,#382f,#3800,#401
	dw #481,#3800
	db 0
	dw #480,#188d,#382f
	db 0
	dw #480,#1800,#3800
	db 0
	dw #400,#188d,#385e,#407e,#c40
	dw #480,#1800,#3800
	db 0
	dw #401,#382f,#4070,#c40
	dw #481,#3800
	db 0
	dw #400,#208d,#382f,#406a,#1401
	dw #480,#2000,#3800
	db 0
	dw #400,#208d,#385e,#4070,#c40
	dw #480,#2000,#3800
	db 0
	dw #400,#207e,#382f,#407e,#c40
	dw #480,#2000,#3800
	db 0
	dw #401,#385e,#405e,#c40
	dw #481,#3800
	db 0
	dw #400,#2870,#382f,#4000,#401
	dw #480,#2800,#3800
	db 0
	dw #480,#2870,#382f
	db 0
	dw #480,#2800,#3800
	db 0
	dw #401,#385e,#485e,#c40
	dw #481,#3800
	db 0
	dw #400,#2070,#382f,#4854,#c40
	dw #480,#2000,#3800
	db 0
	dw #400,#2070,#382f,#4846,#1401
	dw #480,#2000,#3800
	db 0
	dw #401,#385e,#483f,#c40
	dw #481,#3800
	db 0
	dw #400,#1870,#382f,#4838,#c40
	dw #480,#1800,#3800
	db 0
	dw #400,#1870,#385e,#483f,#c40
	dw #480,#1800,#3800
	db 0
	dw #401,#382f,#4800,#401
	dw #481,#3800
	db 0
	dw #480,#108d,#382f
	db 0
	dw #480,#1000,#3800
	db 0
	dw #400,#108d,#385e,#3038,#c40
	dw #400,#1000,#3800,#3046
	db 0
	dw #401,#382f,#305e,#c40
	dw #401,#3800,#3070
	db 0
	dw #400,#88d,#382f,#308d,#1401
	dw #400,#800,#3800,#305e
	db 0
	dw #400,#88d,#385e,#3070,#c40
	dw #400,#800,#3800,#308d
	db 0
	dw #400,#87e,#382f,#30bd,#c40
	dw #400,#800,#3800,#308d
	db 0
	dw #401,#385e,#30bd,#c40
	dw #401,#3800,#30e1
	db 0
	dw #400,#70,#3825,#38a8,#401
	dw #404,#0,#38bd
	db 0
	dw #400,#70,#3825,#38d4
	db 0
	dw #404,#0,#38e1
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#870,#3825,#c40
	dw #484,#800
	db 0
	dw #480,#870,#3825,#1401
	dw #484,#800
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#1070,#3825,#c40
	dw #484,#1000
	db 0
	dw #480,#1070,#384b,#c40
	dw #484,#1000
	db 0
	dw #401,#3825,#390b,#401
	dw #405,#391b
	db 0
	dw #480,#188d,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#188d,#384b,#c40
	dw #484,#1800
	db 0
	dw #401,#3825,#38fc,#c40
	dw #485
	db 0
	dw #480,#208d,#3825,#1401
	dw #484,#2000
	db 0
	dw #480,#208d,#384b,#c40
	dw #484,#2000
	db 0
	dw #400,#207e,#3825,#38d4,#c40
	dw #484,#2000
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#2870,#3825,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#3825
	db 0
	dw #484,#2800
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#2070,#3825,#c40
	dw #484,#2000
	db 0
	dw #400,#2070,#3825,#38c8,#1401
	dw #404,#2000,#38bd
	db 0
	dw #401,#384b,#38a8,#c40
	dw #485
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#1800
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#1800
	db 0
	dw #481,#3825,#401
	dw #485
	db 0
	dw #480,#108d,#3825
	db 0
	dw #484,#1000
	db 0
	dw #400,#108d,#384b,#38a8,#c40
	dw #404,#1000,#3896
	db 0
	dw #401,#3825,#387e,#c40
	dw #405,#3870
	db 0
	dw #400,#88d,#3825,#38a8,#1401
	dw #404,#800,#3896
	db 0
	dw #400,#88d,#384b,#387e,#c40
	dw #404,#800,#3870
	db 0
	dw #400,#87e,#3825,#38a8,#c40
	dw #404,#800,#3896
	db 0
	dw #401,#384b,#387e,#c40
	dw #405,#3870
	db 0
	dw #400,#70,#381f,#3800,#401
	dw #484,#0
	db 0
	dw #480,#70,#381f
	db 0
	dw #484,#0
	db 0
	dw #401,#383f,#38e1,#c40
	dw #485
	db 0
	dw #400,#870,#381f,#38d4,#c40
	dw #484,#800
	db 0
	dw #400,#870,#381f,#38bd,#1401
	dw #484,#800
	db 0
	dw #401,#383f,#38a8,#c40
	dw #485
	db 0
	dw #400,#1070,#381f,#387e,#c40
	dw #484,#1000
	db 0
	dw #400,#1070,#383f,#388d,#c40
	dw #484,#1000
	db 0
	dw #401,#381f,#3800,#401
	dw #485
	db 0
	dw #480,#188d,#381f
	db 0
	dw #484,#1800
	db 0
	dw #400,#188d,#383f,#407e,#c40
	dw #484,#1800
	db 0
	dw #401,#381f,#4070,#c40
	dw #485
	db 0
	dw #400,#208d,#381f,#406a,#1401
	dw #484,#2000
	db 0
	dw #400,#208d,#383f,#4070,#c40
	dw #484,#2000
	db 0
	dw #400,#207e,#381f,#407e,#c40
	dw #484,#2000
	db 0
	dw #401,#383f,#405e,#c40
	dw #485
	db 0
	dw #480,#2870,#381f,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#381f
	db 0
	dw #484,#2800
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #480,#2070,#381f,#c40
	dw #484,#2000
	db 0
	dw #480,#2070,#381f,#1401
	dw #484,#2000
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #480,#1870,#381f,#c40
	dw #484,#1800
	db 0
	dw #480,#1870,#383f,#c40
	dw #484,#1800
	db 0
	dw #401,#381f,#409f,#401
	dw #405,#40a8
	db 0
	dw #480,#108d,#381f
	db 0
	dw #484,#1000
	db 0
	dw #480,#108d,#383f,#c40
	dw #484,#1000
	db 0
	dw #481,#381f,#c40
	dw #485
	db 0
	dw #400,#88d,#381f,#40b2,#1401
	dw #404,#800,#40bd
	db 0
	dw #480,#88d,#383f,#c40
	dw #484,#800
	db 0
	dw #480,#87e,#381f,#c40
	dw #484,#800
	db 0
	dw #481,#383f,#c40
	dw #485
	db 0
	dw #400,#70,#3825,#38e1,#401
	dw #484,#0
	db 0
	dw #480,#70,#3825
	db 0
	dw #484,#0
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#870,#3825,#c40
	dw #484,#800
	db 0
	dw #480,#870,#3825,#1401
	dw #484,#800
	db 0
	dw #481,#384b,#c40
	dw #485
	db 0
	dw #480,#1070,#3825,#c40
	dw #484,#1000
	db 0
	dw #480,#1070,#384b,#c40
	dw #484,#1000
	db 0
	dw #481,#3825,#401
	dw #485
	db 0
	dw #480,#188d,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#188d,#384b,#c40
	dw #484,#1800
	db 0
	dw #481,#3825,#c40
	dw #485
	db 0
	dw #480,#208d,#3825,#1401
	dw #484,#2000
	db 0
	dw #480,#208d,#384b,#c40
	dw #484,#2000
	db 0
	dw #400,#207e,#3825,#38e1,#c40
	dw #404,#2000,#38bd
	db 0
	dw #401,#384b,#38a8,#c40
	dw #405,#38bd
	db 0
	dw #400,#2870,#382a,#38e1,#401
	dw #484,#2800
	db 0
	dw #480,#2870,#382a
	db 0
	dw #484,#2800
	db 0
	dw #481,#3854,#c40
	dw #485
	db 0
	dw #480,#2070,#382a,#c40
	dw #484,#2000
	db 0
	dw #480,#2070,#382a,#1401
	dw #484,#2000
	db 0
	dw #481,#3854,#c40
	dw #485
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#1800
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#1800
	db 0
	dw #401,#382a,#38d4,#401
	dw #485
	db 0
	dw #480,#108d,#382a
	db 0
	dw #484,#1000
	db 0
	dw #480,#108d,#3854,#c40
	dw #484,#1000
	db 0
	dw #481,#382a,#c40
	dw #485
	db 0
	dw #480,#88d,#382a,#1401
	dw #484,#800
	db 0
	dw #480,#88d,#3854,#c40
	dw #484,#800
	db 0
	dw #400,#87e,#382a,#38c8,#c40
	dw #404,#800,#38bd
	db 0
	dw #401,#3854,#38b2,#c40
	dw #405,#38a8
	db 0
	dw #400,#1896,#3825,#40e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#18bd,#384b,#c40
	dw #484,#2896
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#1896,#3825,#1401
	dw #484,#28bd
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#18bd,#3825,#c40
	dw #484,#2896
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#1896,#3825,#401
	dw #484,#28bd
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#2870
	db 0
	dw #480,#18bd,#384b,#c40
	dw #484,#2896
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#1896,#3825,#1401
	dw #484,#28bd
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #400,#18bd,#3825,#40e1,#c40
	dw #404,#2896,#40bd
	db 0
	dw #400,#1870,#384b,#40a8,#c40
	dw #404,#2870,#40bd
	db 0
	dw #400,#188d,#382a,#40e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#382a
	db 0
	dw #484,#1800
	db 0
	dw #480,#18a8,#3854,#c40
	dw #484,#288d
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#2870
	db 0
	dw #480,#188d,#382a,#1401
	dw #484,#28a8
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #480,#18a8,#382a,#c40
	dw #484,#288d
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #400,#188d,#382a,#40d4,#401
	dw #484,#28a8
	db 0
	dw #480,#1870,#382a
	db 0
	dw #484,#2870
	db 0
	dw #480,#18a8,#3854,#c40
	dw #484,#288d
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#2870
	db 0
	dw #480,#188d,#382a,#1401
	dw #484,#28a8
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #400,#18a8,#382a,#40c8,#c40
	dw #404,#288d,#40bd
	db 0
	dw #400,#1870,#3854,#40b2,#c40
	dw #404,#2870,#40a8
	db 0
	dw #400,#192c,#3825,#40e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#18bd,#384b,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#1401
	dw #484,#28bd
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#18bd,#3825,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#401
	dw #484,#28bd
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#2870
	db 0
	dw #480,#18bd,#384b,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#1401
	dw #484,#28bd
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #400,#18bd,#3825,#40e1,#c40
	dw #404,#292c,#40bd
	db 0
	dw #400,#1870,#384b,#40a8,#c40
	dw #404,#2870,#40bd
	db 0
	dw #400,#191b,#381f,#40e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#381f
	db 0
	dw #484,#1800
	db 0
	dw #480,#18a8,#383f,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#381f,#c40
	dw #484,#2870
	db 0
	dw #480,#191b,#381f,#1401
	dw #484,#28a8
	db 0
	dw #480,#1870,#383f,#c40
	dw #484,#2870
	db 0
	dw #480,#18a8,#381f,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#383f,#c40
	dw #484,#2870
	db 0
	dw #400,#191b,#3823,#40d4,#401
	dw #484,#28a8
	db 0
	dw #480,#1870,#3823
	db 0
	dw #484,#2870
	db 0
	dw #480,#18a8,#3846,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#3823,#c40
	dw #484,#2870
	db 0
	dw #480,#191b,#3823,#1401
	dw #484,#28a8
	db 0
	dw #480,#1870,#3846,#c40
	dw #484,#2870
	db 0
	dw #400,#18a8,#3823,#40c8,#c40
	dw #404,#291b,#40bd
	db 0
	dw #400,#1870,#3846,#40b2,#c40
	dw #404,#2870,#40a8
	db 0
	dw #400,#192c,#3825,#30e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#1800
	db 0
	dw #480,#197a,#384b,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#1401
	dw #484,#297a
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#197a,#3825,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#401
	dw #484,#297a
	db 0
	dw #480,#1870,#3825
	db 0
	dw #484,#2870
	db 0
	dw #480,#197a,#384b,#c40
	dw #484,#292c
	db 0
	dw #480,#1870,#3825,#c40
	dw #484,#2870
	db 0
	dw #480,#192c,#3825,#1401
	dw #484,#297a
	db 0
	dw #480,#1870,#384b,#c40
	dw #484,#2870
	db 0
	dw #400,#197a,#3825,#30e1,#c40
	dw #404,#292c,#30bd
	db 0
	dw #400,#1870,#384b,#30a8,#c40
	dw #404,#2870,#30bd
	db 0
	dw #400,#191b,#382a,#30e1,#401
	dw #484,#1800
	db 0
	dw #480,#1870,#382a
	db 0
	dw #484,#1800
	db 0
	dw #480,#1951,#3854,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#2870
	db 0
	dw #480,#191b,#382a,#1401
	dw #484,#2951
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #480,#1951,#382a,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #400,#191b,#382a,#30d4,#401
	dw #484,#2951
	db 0
	dw #480,#1870,#382a
	db 0
	dw #484,#2870
	db 0
	dw #480,#1951,#3854,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#382a,#c40
	dw #484,#2870
	db 0
	dw #480,#191b,#382a,#1401
	dw #484,#2951
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #480,#1951,#382a,#c40
	dw #484,#291b
	db 0
	dw #480,#1870,#3854,#c40
	dw #484,#2870
	db 0
	dw #400,#417a,#382f,#282f,#401
	dw #404,#4000,#2800
	db 0
	dw #400,#417a,#382f,#282f
	db 0
	dw #404,#4000,#2800
	db 0
	dw #401,#3800,#202f
	db 0
	dw #405,#2000
	db 0
	dw #400,#417a,#382f,#202f
	db 0
	dw #404,#4000,#2000
	db 0
	dw #400,#417a,#382f,#182f,#401
	dw #404,#4000,#1800
	db 0
	dw #401,#3800,#182f
	db 0
	dw #405,#1800
	db 0
	dw #400,#417a,#382f,#102f
	db 0
	dw #404,#4000,#1000
	db 0
	dw #400,#417a,#382f,#102f
	db 0
	dw #404,#4000,#1000
	db 0
	dw #401,#3800,#82f,#401
	dw #405,#800
	db 0
	dw #404,#297a,#82f
	db 0
	dw #404,#2800,#800
	db 0
	dw #404,#297a,#102f
	db 0
	dw #404,#2800,#1000
	db 0
	dw #405,#102f
	db 0
	dw #405,#1000
	db 0
	dw #404,#297a,#182f,#401
	dw #404,#2800,#1800
	db 0
	dw #405,#182f
	db 0
	dw #405,#1800
	db 0
	dw #404,#297a,#202f
	db 0
	dw #404,#2800,#2000
	db 0
	dw #404,#297a,#202f
	db 0
	dw #404,#2800,#2000
	db 0
	dw #400,#405e,#382f,#2070,#401
	dw #404,#4000,#2000
	db 0
	dw #400,#405e,#382f,#2070
	db 0
	dw #404,#4000,#2000
	db 0
	dw #481,#3800
	db 0
	dw #485
	db 0
	dw #400,#405e,#382f,#2070
	db 0
	dw #404,#4000,#2000
	db 0
	dw #400,#405e,#382f,#2070,#401
	dw #404,#4000,#2000
	db 0
	dw #481,#3800
	db 0
	dw #485
	db 0
	dw #400,#405e,#382f,#2070
	db 0
	dw #404,#4000,#2000
	db 0
	dw #400,#405e,#382f,#2070
	db 0
	dw #404,#4000,#2000
	db 0
	dw #481,#3800,#401
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #485
	db 0
	dw #400,#305e,#482f,#e0bd,#401
	dw #404,#285e,#e0bd,#401
	dw #404,#205e,#e0bd,#401
	dw #404,#185e,#e000
	db 0
	dw #404,#105e,#e0bd,#401
	dw #404,#85e,#e000
	db 0
	dw #404,#5e,#e0bd,#401
	dw #405,#e000
	db 0
	dw #400,#0,#4800,#e000
	db 0
	db #40
.pattern2
	dw #0100,0,0,0
	db #40
