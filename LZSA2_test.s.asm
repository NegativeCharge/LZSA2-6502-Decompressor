LOAD_ADDR = &5800
BACKWARD_DECOMPRESS = FALSE

\ Allocate vars in ZP
ORG &80
GUARD &9F
.zp_start
    INCLUDE ".\lib\lzsa2.h.asm"
.zp_end

\ Main
CLEAR 0, LOAD_ADDR
GUARD LOAD_ADDR
ORG &1100
.start
    INCLUDE ".\lib\lzsa2.s.asm"

.entry_point

    \\ Turn off cursor by directly poking crtc
    lda #&0b
    sta &fe00
    lda #&20
    sta &fe01
    
    lda #LO(comp_data)
    sta LZSA_SRC_LO

    lda #HI(comp_data)
    sta LZSA_SRC_HI

    lda #LO(LOAD_ADDR)
    sta LZSA_DST_LO

    lda #HI(LOAD_ADDR)
    sta LZSA_DST_HI
    
    jsr DECOMPRESS_LZSA2_FAST

.loop
    jmp loop
    
.comp_data
    INCBIN ".\tests\test_0.bin.lzsa2"

.end

SAVE "LZSA2", start, end, entry_point

\ ******************************************************************
\ *	Memory Info
\ ******************************************************************

PRINT "------------------------"
PRINT "   LZSA2 Decompressor   "
PRINT "------------------------"
PRINT "CODE SIZE         = ", ~end-start
PRINT "DECOMPRESSOR SIZE = ", entry_point-start, "bytes"
PRINT "ZERO PAGE SIZE    = ", zp_end-zp_start, "bytes"
PRINT "------------------------"
PRINT "LOAD ADDR         = ", ~start
PRINT "HIGH WATERMARK    = ", ~P%
PRINT "RAM BYTES FREE    = ", ~LOAD_ADDR-P%
PRINT "------------------------"

PUTBASIC "loader.bas","LOADER"
PUTFILE  "BOOT","!BOOT", &FFFF  