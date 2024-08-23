1-bit music tunes for the LASER 500 computer. (Also for the Laser350 and Laser700).
All music files assembled to binary files which are drag-n-drop compatible with Nippur72's Laser500 browser emulator.
https://nippur72.github.io/laser500emu/

The Laser 500 has its speaker sitting on bit 1 of memory latch $6800, and requires an initial write to port $41 for bank activation.

	di
	ld      a,2
	out     ($41),a


Then oscillate bit 1 in register A of the latch to output on/off timed signal to the speaker as a repalcement to the standard ZX code:  'OUT ($FE), A'

	XOR   	1
 	ld	($6800),a

-----------------------------------------------------

Assembly listings require an execution basic 'RUN' header:
	org	$8995		; Loads BASIC header here.
 
;   The below is essentially this:       2021 A equ &H89A5:CALL A:END

   	db 	$FF,$FF,$E2,$07,$41,$F0,$0C,$A5,$89,$3A,$B6,$20,$41,$3A,$81,$00

;   The resulting assembled .BIN file can be simply drag/dropped into an emulator, or, use a Laser500 'BIN2WAV' or 'BIN2CAS' to create a WAV file , that can then be CLOAD'd in. This can be found within the Z88dk dev kit APPMAKE. 

;   Antontino's Laser500 emulator :     https://nippur72.github.io/laser500emu/


To play the tunes, simply go to the above emulator URL, and drag'n'drop the .BIN files into the emulator.
Speed may vary - testing was initially performed on Firefox v115 and the emulator was absolutely *DEAD SET SLOOOOW* !!  and totally un-useable.
I ditched it for a current version of Mozilla based MYPAL68 browser (Aug 24) and the speed of the emulator was back to what I'd call normal operating speed.




