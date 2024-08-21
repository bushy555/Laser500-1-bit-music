1-bit music tunes for the LASER 500 computer. (Also for the Laser350 and Laser700).
All music files assembled to binary files which are drag-n-drop compatible with Nippur72's Laser500 browser emulator.
https://nippur72.github.io/laser500emu/

The Laser 500 has its speaker sitting on bit 1 of memory latch $6800, and requires a write to port $41 for activation.

push  af

ld      a,2

out     ($41),a

pop	af

	XOR   	1
 
	ld	($6800),a

-----------------------------------------------------

Assembly listings require an execution basic 'RUN' header:
	org	$8995		; Loads BASIC header here.
 
;   The below is essentially this:       2021 A equ &H89A5:CALL A:END

   	db 	$FF,$FF,$E2,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00

;   Resulting outtputed assembled .BIN file can be simply copied into an emulator, or, 

;   Use a Laser500:   BIN2WAV to create a WAV file , that can then be CLOAD'd in.
;
;   Antontino's Laser500 emulator :     https://nippur72.github.io/laser500emu/
;

