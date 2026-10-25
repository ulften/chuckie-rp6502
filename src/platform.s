; Chuckie Egg for the Picocomputer 6502: the platform layer.
;
; The game was written for the BBC Micro. It draws sprites straight into
; the MODE 2 screen memory, and uses the MOS for everything else: OSWRCH
; for text and VDU commands, OSBYTE for the keyboard, and OSWORD for the
; sound, the interval timer and line input. This file provides those
; services on the RP6502, with just the parts of the MOS that the game
; uses:
;
; - The screen is an XRAM bitmap; see xram.inc. Each BBC pixel is one
;   byte, so a logical colour c is the byte c * $11.
; - A VDU driver for MODE 2 with text at the graphics cursor (VDU 5).
; - The keyboard, read from the RIA keyboard bits through a table of BBC
;   internal key numbers.
; - SOUND and ENVELOPE on the PSG, run by the VSYNC interrupt.
; - The interval timer, from the run time clock of the RIA.

.include "rp6502.inc"
.include "xram.inc"

.export oswrch, osword, osbyte
.export draw_sprite, calculate_screen_location
.export plat_sleep, plat_countdown, plat_counting
.export plat_layout_game, plat_layout_menu
.import entry_point

; Zero page locations of the game that the sprite routines use.
loop_counter            = $8A
screen_lo               = $70
screen_hi               = $71
sprite_lo               = $76
sprite_hi               = $77
sprite_height           = $78
sprite_width_bytes      = $7A
sprite_colour_mask_left = $7F

; The game uses zero page up to $8F. The platform uses $90-$AF, and the
; interrupt handler uses $B0-$BF, so that it never changes the
; temporaries of the code that it interrupts.
.segment "PLATZP": zeropage
ptr:        .res 2      ; general pointer
tmp:        .res 6      ; scratch
xaddr:      .res 2      ; an XRAM address
colour:     .res 1      ; a pixel byte, colour * $11
bits:       .res 1      ; pixel bits being plotted
owblock:    .res 2      ; OSWORD parameter block
glyph:      .res 2      ; font data of a character
row:        .res 2      ; signed row of the screen, 0 at the top
col:        .res 2      ; signed BBC pixel column
count:      .res 1

.segment "IRQZP": zeropage
iptr:       .res 2
itmp:       .res 4

.segment "PLATBSS"
; VDU state
vdu_need:   .res 1      ; parameter bytes still to come
vdu_n:      .res 1      ; parameter bytes received
vdu_cmd:    .res 1
vdu_buf:    .res 9
gx:         .res 2      ; graphics cursor, BBC units, signed
gy:         .res 2
win_l:      .res 2      ; graphics window, BBC units, inclusive
win_b:      .res 2
win_r:      .res 2
win_t:      .res 2
fg_mode:    .res 1      ; GCOL action for the foreground
fg_byte:    .res 1      ; foreground colour * $11
bg_byte:    .res 1      ; background colour * $11
palette:    .res 16     ; physical colour of each logical colour
; line input
rl_len:     .res 1
rl_max:     .res 1
rl_min_ch:  .res 1
rl_max_ch:  .res 1
; time
itimer_base: .res 4     ; the clock when the interval timer was 0
itmp_clock: .res 4
cs_ticks:   .res 2      ; free running centiseconds
cs_acc:     .res 1      ; VSYNC to centisecond fraction
countdown:  .res 2      ; the end of plat_countdown, in cs_ticks
bell_block: .res 8
; sound: four BBC channels, 0 noise and 1-3 tone, each with a queue of
; four notes.
snd_qn:     .res 4      ; notes queued
snd_qh:     .res 4      ; index of the first queued note
snd_qamp:   .res 16
snd_qpitch: .res 16
snd_qdur:   .res 16
ch_state:   .res 4      ; 0 idle, 1 playing, 2 releasing
ch_env:     .res 4      ; envelope number 1-4, or 0
ch_amp:     .res 4      ; amplitude 0-126
ch_phase:   .res 4      ; envelope phase: 0 attack 1 decay 2 sustain 3 release
ch_step:    .res 4      ; centiseconds to the next envelope step
ch_dur_lo:  .res 4      ; centiseconds left of the note
ch_dur_hi:  .res 4
ch_inf:     .res 4      ; nonzero for a note without end
ch_att:     .res 4      ; attenuation last written to the PSG, $FF none
env_tab:    .res 4 * 13 ; ENVELOPE parameters 1-13 of envelopes 1-4

; ---------------------------------------------------------------------
; Reset and interrupt entry points. rp6502_executable() in CMakeLists.txt
; points the vectors here.

.segment "STARTUP"
reset:
    jmp start           ; $0800 reset vector
    jmp irq             ; $0803 IRQ vector
    rti                 ; $0806 NMI vector

.segment "CODE"

start:
    sei
    cld
    ldx #$FF
    txs
    ; Clear zero page, the game's pages $04-$07 and the platform RAM.
    lda #0
    tax
:   sta $00,x
    sta $0200,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne :-
    jsr video_init
    jsr sound_init
    xreg 0, 0, 0, XRAM_KEYBOARD
    jsr vdu_mode2
    lda #$80            ; VSYNC interrupt
    sta RIA_IRQ
    cli
    jmp entry_point

video_init:
    xreg 1, 0, 0, CANVAS_320X240
    lda #<XRAM_CONFIG
    ldx #>XRAM_CONFIG
    jsr write_config
    lda #<XRAM_CONFIG2
    ldx #>XRAM_CONFIG2
    jsr write_config
    jsr plat_layout_menu
    xreg 1, 0, 1, 3, MODE3_4BPP, XRAM_CONFIG, 0, 0, SPLIT_SCANLINE
    xreg 1, 0, 1, 3, MODE3_4BPP, XRAM_CONFIG2, 0, SPLIT_SCANLINE, 0
    rts

write_config:
    sta RIA_ADDR0
    stx RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    ldx #0
:   lda mode3_config,x
    sta RIA_RW0
    inx
    cpx #MODE3_CONFIG_SIZE
    bne :-
    rts

; The BBC screen has 256 rows and the canvas 240, so 16 rows don't show.
; The canvas is in two parts, each with its own bitmap configuration, so
; that the rows that don't show can be from the middle of the screen as
; well as from its ends. The game screen uses rows 7 to 250, with 4 empty
; rows in its status lines at the top; the title screens use rows 15 to
; 250 and need all rows in between.
SPLIT_SCANLINE = 12

; The game screen: rows 7-18 on scanlines 0-11, rows 23-250 below.
plat_layout_game:
    lda #<(-7)
    ldx #<(-(7 + 4))
    jmp set_layout

; The title screens: rows 13-252.
plat_layout_menu:
    lda #<(-13)
    ldx #<(-13)

; Sets y_pos_px of the two configurations to -A and -X, sign extended.
set_layout:
    pha
    lda #<(XRAM_CONFIG + MODE3_CONFIG_Y_POS_PX)
    sta RIA_ADDR0
    lda #>(XRAM_CONFIG + MODE3_CONFIG_Y_POS_PX)
    sta RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    pla
    sta RIA_RW0
    lda #$FF
    sta RIA_RW0
    lda #<(XRAM_CONFIG2 + MODE3_CONFIG_Y_POS_PX)
    sta RIA_ADDR0
    stx RIA_RW0
    lda #$FF
    sta RIA_RW0
    rts

.segment "RODATA"

mode3_config:
    .byte 0, 0                          ; x_wrap, y_wrap
    .word 0, 0                          ; x_pos_px, y_pos_px (set_layout)
    .word 320, 256                      ; width_px, height_px
    .word XRAM_BITMAP, XRAM_PALETTE

; The eight colours of the BBC Micro, physical colours 0-7.
bbc_colours:
    COLOR_FROM_RGBA   0,   0,   0, 255  ; black
    COLOR_FROM_RGBA 255,   0,   0, 255  ; red
    COLOR_FROM_RGBA   0, 255,   0, 255  ; green
    COLOR_FROM_RGBA 255, 255,   0, 255  ; yellow
    COLOR_FROM_RGBA   0,   0, 255, 255  ; blue
    COLOR_FROM_RGBA 255,   0, 255, 255  ; magenta
    COLOR_FROM_RGBA   0, 255, 255, 255  ; cyan
    COLOR_FROM_RGBA 255, 255, 255, 255  ; white

bit_mask:
    .byte $01, $02, $04, $08, $10, $20, $40, $80

; ---------------------------------------------------------------------
; Screen addresses

.segment "CODE"

; xaddr = A * 160 + X, for row A of the screen and BBC pixel column X.
row_address:
    sta xaddr
    lda #0
    sta xaddr+1
    asl xaddr           ; row * 32
    rol xaddr+1
    asl xaddr
    rol xaddr+1
    asl xaddr
    rol xaddr+1
    asl xaddr
    rol xaddr+1
    asl xaddr
    rol xaddr+1
    lda xaddr           ; + row * 128 = row * 32 * 4
    sta tmp
    lda xaddr+1
    sta tmp+1
    asl tmp
    rol tmp+1
    asl tmp
    rol tmp+1
    clc
    lda xaddr
    adc tmp
    sta xaddr
    lda xaddr+1
    adc tmp+1
    sta xaddr+1
    txa
    clc
    adc xaddr
    sta xaddr
    bcc :+
    inc xaddr+1
:   rts

; Point both XRAM portals at xaddr, stepping forward. Portal 0 reads
; and portal 1 writes, so a pixel can be read, changed and written back.
portals_at_xaddr:
    lda xaddr
    sta RIA_ADDR0
    sta RIA_ADDR1
    lda xaddr+1
    sta RIA_ADDR0+1
    sta RIA_ADDR1+1
    lda #1
    sta RIA_STEP0
    sta RIA_STEP1
    rts

; ---------------------------------------------------------------------
; The game's sprite routines.

; In: X = BBC pixel column (0-159), Y = row from the bottom (0-255).
; Out: screen_lo/hi = the XRAM address of that pixel.
calculate_screen_location:
    tya
    eor #$FF
    tay                 ; as the original, which leaves Y = Y EOR &FF
    jsr row_address
    lda xaddr
    sta screen_lo
    lda xaddr+1
    sta screen_hi
    rts

; Draws a one-bit sprite with EOR, so a second draw removes it.
; In: screen_lo/hi from calculate_screen_location, sprite_lo/hi the data,
; sprite_width_bytes and sprite_height its size, and
; sprite_colour_mask_left the colour as the bits of a left MODE 2 pixel.
; Like the original, it leaves sprite_lo/hi after the data and
; sprite_height at 0.
draw_sprite:
    ; The bits of a left MODE 2 pixel are 7, 5, 3 and 1 of the colour.
    lda sprite_colour_mask_left
    ldx #0
    stx colour
    asl a
    rol colour
    asl a
    asl a
    rol colour
    asl a
    asl a
    rol colour
    asl a
    asl a
    rol colour
    lda colour
    asl a
    asl a
    asl a
    asl a
    ora colour
    sta colour
    lda #1
    sta RIA_STEP0
    sta RIA_STEP1
@row:
    lda screen_hi
    cmp #>XRAM_BITMAP_END
    bcc :+
    jmp @skip_rest          ; below the screen
:   cmp #>(XRAM_BITMAP_END - 1)
    bne @in_range
    ; The last page of the bitmap: skip a row that would run past it.
    lda sprite_width_bytes
    asl a
    asl a
    asl a
    clc
    adc screen_lo
    bcs @next_row
@in_range:
    lda screen_lo
    sta RIA_ADDR0
    sta RIA_ADDR1
    lda screen_hi
    sta RIA_ADDR0+1
    sta RIA_ADDR1+1
    ldy #0
@byte:
    lda (sprite_lo),y
    sta bits
    .repeat 8
    asl bits
    lda RIA_RW0
    bcc :+
    eor colour
:   sta RIA_RW1
    .endrepeat
    iny
    cpy sprite_width_bytes
    beq @next_row
    jmp @byte
@next_row:
    clc
    lda sprite_lo
    adc sprite_width_bytes
    sta sprite_lo
    bcc :+
    inc sprite_hi
:   clc
    lda screen_lo
    adc #SCREEN_STRIDE
    sta screen_lo
    bcc :+
    inc screen_hi
:   dec sprite_height
    beq :+
    jmp @row
:   ldx #0              ; as the original
    rts
@skip_rest:
    ; Move past the rest of the data, as a full draw would.
    clc
    lda sprite_lo
    adc sprite_width_bytes
    sta sprite_lo
    bcc :+
    inc sprite_hi
:   dec sprite_height
    bne @skip_rest
    ldx #0
    rts

; ---------------------------------------------------------------------
; Delays. The game timed these with loops of 65536 DEX/BNE at 2 MHz.

; A = number of 16 centisecond delays. Like the original, it returns
; with X = Y = 0 and loop_counter = 0.
plat_sleep:
    sta loop_counter
:   lda #16
    jsr wait_cs
    dec loop_counter
    bne :-
    ldx #0
    ldy #0
    rts

; Starts a countdown of X * 256 + A centiseconds.
plat_countdown:
    clc
    sei
    adc cs_ticks
    sta countdown
    txa
    adc cs_ticks+1
    cli
    sta countdown+1
    rts

; C = 1 while the countdown runs. Keeps X and Y.
plat_counting:
    sei
    lda cs_ticks
    cmp countdown
    lda cs_ticks+1
    cli
    sbc countdown+1
    asl a               ; C = the sign: 1 before the end
    rts

; Waits A centiseconds.
wait_cs:
    clc
    adc cs_ticks
    sta tmp
    lda #0
    adc cs_ticks+1
    sta tmp+1
@wait:
    sei
    lda cs_ticks
    cmp tmp
    lda cs_ticks+1
    cli
    sbc tmp+1
    bmi @wait
    rts

; ---------------------------------------------------------------------
; OSWRCH: the VDU driver. Preserves A, X and Y.

oswrch:
    pha
    txa
    pha
    tya
    pha
    tsx
    lda $0103,x
    jsr vdu
    pla
    tay
    pla
    tax
    pla
    rts

vdu:
    ldx vdu_need
    beq @new
    ldx vdu_n
    sta vdu_buf,x
    inc vdu_n
    dec vdu_need
    beq vdu_exec
    rts
@new:
    cmp #32
    bcc @control
    cmp #127
    beq @delete
    jmp vdu_char
@delete:
    jmp vdu_del
@control:
    sta vdu_cmd
    tax
    lda vdu_param_count,x
    beq vdu_exec
    sta vdu_need
    lda #0
    sta vdu_n
    rts

vdu_exec:
    lda vdu_cmd
    asl a
    tax
    lda vdu_jump+1,x
    pha
    lda vdu_jump,x
    pha
vdu_nop:
    rts                 ; to the command, or nothing for vdu_nop

.segment "RODATA"
vdu_param_count:
    .byte 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    .byte 0, 1, 2, 5, 0, 0, 1, 9, 8, 5, 0, 0, 4, 4, 0, 2
vdu_jump:
    .word vdu_nop-1     ; 0
    .word vdu_nop-1     ; 1 next byte to the printer
    .word vdu_nop-1     ; 2 printer on
    .word vdu_nop-1     ; 3 printer off
    .word vdu_nop-1     ; 4 text at the text cursor
    .word vdu_nop-1     ; 5 text at the graphics cursor, always on here
    .word vdu_nop-1     ; 6
    .word vdu_bell-1    ; 7
    .word vdu_left-1    ; 8
    .word vdu_right-1   ; 9
    .word vdu_down-1    ; 10
    .word vdu_up-1      ; 11
    .word vdu_cls-1     ; 12
    .word vdu_cr-1      ; 13
    .word vdu_nop-1     ; 14
    .word vdu_nop-1     ; 15
    .word vdu_clg-1     ; 16
    .word vdu_nop-1     ; 17 COLOUR
    .word vdu_gcol-1    ; 18
    .word vdu_palette-1 ; 19
    .word vdu_nop-1     ; 20
    .word vdu_nop-1     ; 21
    .word vdu_mode-1    ; 22
    .word vdu_nop-1     ; 23
    .word vdu_window-1  ; 24
    .word vdu_plot-1    ; 25
    .word vdu_reset_windows-1 ; 26
    .word vdu_nop-1     ; 27
    .word vdu_nop-1     ; 28 text window
    .word vdu_nop-1     ; 29 graphics origin
    .word vdu_home-1    ; 30
    .word vdu_tab-1     ; 31

.segment "CODE"

vdu_bell:
    lda #<bell_block
    sta ptr
    lda #>bell_block
    sta ptr+1
    jmp sound

vdu_left:
    sec
    lda gx
    sbc #64
    sta gx
    bcs :+
    dec gx+1
:   rts

vdu_right:
    clc
    lda gx
    adc #64
    sta gx
    bcc :+
    inc gx+1
:   rts

vdu_down:
    sec
    lda gy
    sbc #32
    sta gy
    bcs :+
    dec gy+1
:   rts

vdu_up:
    clc
    lda gy
    adc #32
    sta gy
    bcc :+
    inc gy+1
:   rts

vdu_cr:
    lda win_l
    sta gx
    lda win_l+1
    sta gx+1
    rts

vdu_home:
    lda win_l
    sta gx
    lda win_l+1
    sta gx+1
    lda win_t
    sta gy
    lda win_t+1
    sta gy+1
    rts

; VDU 31,x,y moves to text column x and row y, in units of characters.
vdu_tab:
    lda vdu_buf
    ldx #6              ; * 64
    jsr times_2_to_x
    sta gx
    stx gx+1
    lda vdu_buf+1
    ldx #5              ; * 32
    jsr times_2_to_x
    sta tmp
    stx tmp+1
    sec
    lda #<1023
    sbc tmp
    sta gy
    lda #>1023
    sbc tmp+1
    sta gy+1
    rts

; A * 2^X, returned in A (low) and X (high).
times_2_to_x:
    sta tmp+2
    lda #0
    sta tmp+3
:   asl tmp+2
    rol tmp+3
    dex
    bne :-
    lda tmp+2
    ldx tmp+3
    rts

; VDU 18,mode,colour. Colours 128-143 are the background.
vdu_gcol:
    lda vdu_buf+1
    and #$0F
    sta tmp
    asl a
    asl a
    asl a
    asl a
    ora tmp
    bit vdu_buf+1
    bmi @bg
    sta fg_byte
    lda vdu_buf
    sta fg_mode
    rts
@bg:
    sta bg_byte
    rts

; VDU 19,logical,physical,0,0,0
vdu_palette:
    lda vdu_buf
    and #$0F
    tax
    lda vdu_buf+1
    and #$0F
    sta palette,x
    ; fall through to write_palette

; Writes the 16 colours to XRAM.
write_palette:
    lda #<XRAM_PALETTE
    sta RIA_ADDR0
    lda #>XRAM_PALETTE
    sta RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    ldx #0
:   lda palette,x
    and #$07            ; flashing colours 8-15 stay on their first colour
    asl a
    tay
    lda bbc_colours,y
    sta RIA_RW0
    lda bbc_colours+1,y
    sta RIA_RW0
    inx
    cpx #16
    bne :-
    rts

; VDU 22,mode. Every mode is MODE 2 here.
vdu_mode:
vdu_mode2:
    ldx #15
:   txa
    and #$07
    sta palette,x
    dex
    bpl :-
    jsr write_palette
    lda #0
    sta fg_mode
    sta bg_byte
    sta vdu_need
    lda #$77            ; white
    sta fg_byte
    jsr vdu_reset_windows
    jsr vdu_home
    lda #0
    jmp clear_screen

; VDU 24,left;bottom;right;top;
vdu_window:
    ldx #7
:   lda vdu_buf,x
    sta win_l,x
    dex
    bpl :-
    rts

vdu_reset_windows:
    lda #0
    sta win_l
    sta win_l+1
    sta win_b
    sta win_b+1
    lda #<1279
    sta win_r
    lda #>1279
    sta win_r+1
    lda #<1023
    sta win_t
    lda #>1023
    sta win_t+1
    rts

; VDU 25,k,x;y; moves the graphics cursor. The game only moves (PLOT 4);
; the other PLOT commands move without drawing.
vdu_plot:
    lda vdu_buf
    and #$04
    beq @relative
    lda vdu_buf+1
    sta gx
    lda vdu_buf+2
    sta gx+1
    lda vdu_buf+3
    sta gy
    lda vdu_buf+4
    sta gy+1
    rts
@relative:
    clc
    lda gx
    adc vdu_buf+1
    sta gx
    lda gx+1
    adc vdu_buf+2
    sta gx+1
    clc
    lda gy
    adc vdu_buf+3
    sta gy
    lda gy+1
    adc vdu_buf+4
    sta gy+1
    rts

; VDU 12 clears the screen. In VDU 5 mode it clears the graphics window.
vdu_cls:
    jsr vdu_clg
    jmp vdu_home

; VDU 16 clears the graphics window to the background colour.
vdu_clg:
    ; columns win_l / 8 to win_r / 8, rows 255 - win_t / 4 to 255 - win_b / 4
    lda win_l
    ldx win_l+1
    jsr units_to_col
    sta tmp+4           ; first column
    lda win_r
    ldx win_r+1
    jsr units_to_col
    sec
    sbc tmp+4
    sta count           ; columns - 1
    inc count
    lda win_t
    ldx win_t+1
    jsr units_to_row
    sta tmp+5           ; top row
    lda win_b
    ldx win_b+1
    jsr units_to_row
    sec
    sbc tmp+5
    tay
    iny                 ; rows, 1-256 (0 = 256)
    lda bg_byte
    sta colour
    lda tmp+5
    ldx tmp+4
    ; fall through to fill_rect

; Fills Y rows (0 = 256) of count bytes, from row A and column X, with
; colour.
fill_rect:
    sta row
    stx col
@row:
    lda row
    ldx col
    jsr row_address
    lda xaddr
    sta RIA_ADDR0
    lda xaddr+1
    sta RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    lda colour
    ldx count
:   sta RIA_RW0
    dex
    bne :-
    inc row
    dey
    bne @row
    rts

; Clears the whole bitmap to the colour byte in A.
clear_screen:
    sta colour
    lda #0
    sta RIA_ADDR0
    sta RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    lda colour
    ldy #>(XRAM_BITMAP_END - XRAM_BITMAP) / 4
    ldx #0
:   sta RIA_RW0
    sta RIA_RW0
    sta RIA_RW0
    sta RIA_RW0
    inx
    bne :-
    dey
    bne :-
    rts

; BBC units in A (low) X (high), clamped to the screen, to a column 0-159.
units_to_col:
    cpx #$80
    bcs @zero           ; negative
    cpx #>1280
    bcc :+
    bne @max
    cmp #<1280
    bcs @max
:   stx tmp+1
    lsr tmp+1
    ror a
    lsr tmp+1
    ror a
    lsr tmp+1
    ror a
    rts
@zero:
    lda #0
    rts
@max:
    lda #159
    rts

; BBC units in A (low) X (high), clamped to the screen, to a row 0-255
; from the top.
units_to_row:
    cpx #$80
    bcs @bottom
    cpx #>1024
    bcs @top
    stx tmp+1
    lsr tmp+1
    ror a
    lsr tmp+1
    ror a
    eor #$FF
    rts
@bottom:
    lda #255
    rts
@top:
    lda #0
    rts

; VDU 127 in VDU 5 mode: back one character, and clear its cell.
vdu_del:
    jsr vdu_left
    jsr cursor_cell
    bcs :+
    lda bg_byte
    sta colour
    lda #8
    sta count
    ldy #8
    lda row
    ldx col
    jmp fill_rect
:   rts

; row and col of the top left of the character at the graphics cursor.
; C = 1 when the cell is not wholly on the screen.
cursor_cell:
    ; col = gx >> 3, signed
    lda gx+1
    sta col+1
    lda gx
    ldx #3
:   cmp #0              ; keep A, shift col+1:A right, signed
    pha
    lda col+1
    cmp #$80
    ror col+1
    pla
    ror a
    dex
    bne :-
    sta col
    ; row = 255 - (gy >> 2), signed
    lda gy+1
    sta row+1
    lda gy
    ldx #2
:   pha
    lda row+1
    cmp #$80
    ror row+1
    pla
    ror a
    dex
    bne :-
    eor #$FF
    sta row
    lda row+1
    eor #$FF
    sta row+1           ; row = -1 - (gy >> 2) + 256 = 255 - (gy >> 2)
    inc row+1
    ; on screen when col 0-152 and row 0-248
    lda col+1
    bne @off
    lda col
    cmp #153
    bcs @off
    lda row+1
    bne @off
    lda row
    cmp #249
    bcs @off
    clc
    rts
@off:
    sec
    rts

; A printable character in VDU 5 mode: plot the set pixels of its glyph
; at the graphics cursor with the GCOL action, then move right.
vdu_char:
    sec
    sbc #32
    sta glyph
    lda #0
    sta glyph+1
    asl glyph
    rol glyph+1
    asl glyph
    rol glyph+1
    asl glyph
    rol glyph+1
    clc
    lda glyph
    adc #<font_data
    sta glyph
    lda glyph+1
    adc #>font_data
    sta glyph+1
    jsr cursor_cell
    bcs @done
    lda #8
    sta count
@row:
    lda row
    ldx col
    jsr row_address
    jsr portals_at_xaddr
    ldy #0
    lda (glyph),y
    sta bits
    ldx #8
@pixel:
    lda RIA_RW0
    asl bits
    bcc :+
    jsr gcol_apply
:   sta RIA_RW1
    dex
    bne @pixel
    inc glyph
    bne :+
    inc glyph+1
:   inc row
    dec count
    bne @row
@done:
    jmp vdu_right

; The GCOL action of the foreground on the pixel byte in A.
gcol_apply:
    ldy fg_mode
    beq @set
    dey
    beq @or
    dey
    beq @and
    dey
    beq @eor
    eor #$FF            ; 4: invert
    rts
@set:
    lda fg_byte
    rts
@or:
    ora fg_byte
    rts
@and:
    and fg_byte
    rts
@eor:
    eor fg_byte
    rts

; ---------------------------------------------------------------------
; OSBYTE

osbyte:
    cmp #$81
    beq inkey
    cmp #$79
    beq keyboard_scan
    cmp #$7A
    beq keyboard_scan_16
    cmp #$AC
    beq key_table
    cmp #$0F
    beq flush_input
    rts

; OSBYTE &AC: X/Y = the key translation table.
key_table:
    ldx #<key_ascii
    ldy #>key_ascii
    rts

; OSBYTE &0F: empty the keyboard buffer.
flush_input:
    bit RIA_READY
    bvc :+
    lda RIA_RX
    jmp flush_input
:   rts

; OSBYTE &79. X >= &80: test key X - &80, and return with bit 7 of X set
; when it is down. X < &80: return the lowest key from X up that is down,
; or &FF.
keyboard_scan:
    txa
    bpl keyboard_scan_from
    and #$7F
    tax
    jsr key_down
    bcc :+
    txa
    ora #$80
    tax
:   rts

; OSBYTE &7A: the lowest key from 16 up that is down, or &FF.
keyboard_scan_16:
    ldx #16
keyboard_scan_from:
:   jsr key_down
    bcs :+
    inx
    bpl :-
    ldx #$FF
:   rts

; OSBYTE &81, INKEY. Y = &FF and X = key EOR &FF: X = Y = &FF when the
; key is down, else 0. Otherwise wait up to X + 256 * Y centiseconds for
; a character: X = the character, Y = 0 and C = 0, or Y = &FF and C = 1.
inkey:
    cpy #$FF
    bne @wait_char
    txa
    eor #$FF
    tax
    jsr key_down
    ldx #0
    bcc :+
    dex
:   txa
    tay
    rts
@wait_char:
    stx tmp+2
    sty tmp+3
@loop:
    bit RIA_READY
    bvs @char
    lda tmp+2
    ora tmp+3
    beq @timeout
    lda #1
    jsr wait_cs
    lda tmp+2
    bne :+
    dec tmp+3
:   dec tmp+2
    jmp @loop
@char:
    ldx RIA_RX
    ldy #0
    clc
    rts
@timeout:
    ldy #$FF
    sec
    rts

; C = 1 when BBC internal key X (0-127) is down. Keeps X.
key_down:
    lda key_hid1,x
    beq :+
    jsr hid_down
    bcs @yes
:   lda key_hid2,x
    beq @no
    jsr hid_down
    bcs @yes
@no:
    clc
@yes:
    rts

; C = 1 when USB HID keycode A is down. Keeps X.
hid_down:
    pha
    lsr a
    lsr a
    lsr a
    clc
    adc #<XRAM_KEYBOARD
    sta RIA_ADDR0
    lda #>XRAM_KEYBOARD
    adc #0
    sta RIA_ADDR0+1
    pla
    and #$07
    tay
    lda RIA_RW0
    and bit_mask,y
    cmp #1              ; C = 1 when the bit is set
    rts

; ---------------------------------------------------------------------
; OSWORD

osword:
    stx owblock
    sty owblock+1
    cmp #7
    bne :+
    stx ptr
    sty ptr+1
    jmp sound
:   cmp #3
    beq read_timer
    cmp #4
    beq write_timer
    cmp #8
    bne :+
    jmp envelope
:   cmp #0
    bne :+
    jmp read_line
:   rts

; OSWORD 3 and 4: read and write the five bytes of the interval timer,
; in centiseconds. The timer is the run time clock of the RIA less
; itimer_base, so it has the resolution of the BBC timer. The game paces
; its main loop with it, at 3 centiseconds a frame.
read_timer:
    jsr read_clock
    sec
    ldy #0
:   lda itmp_clock,y
    sbc itimer_base,y
    sta (owblock),y
    iny
    cpy #4
    bne :-
    lda #0
    sta (owblock),y
    rts

write_timer:
    jsr read_clock
    sec
    ldy #0
:   lda itmp_clock,y
    sbc (owblock),y
    sta itimer_base,y
    iny
    cpy #4
    bne :-
    rts

; itmp_clock = the run time of the 6502 in centiseconds.
read_clock:
    lda #RIA_ATTR_CLK_RUN_CS
    sta RIA_A
    lda #RIA_OP_ATTR_GET
    sta RIA_OP
    jsr RIA_SPIN
    sta itmp_clock
    stx itmp_clock+1
    lda RIA_SREG
    sta itmp_clock+2
    lda RIA_SREG+1
    sta itmp_clock+3
    rts

; OSWORD 0: read a line. The block holds the buffer address, the maximum
; length, and the lowest and highest characters to accept. Returns
; Y = length, C = 1 for Escape.
read_line:
    ldy #2
    lda (owblock),y
    sta rl_max
    iny
    lda (owblock),y
    sta rl_min_ch
    iny
    lda (owblock),y
    sta rl_max_ch
    ldy #0
    lda (owblock),y
    tax
    iny
    lda (owblock),y
    stx owblock
    sta owblock+1       ; owblock = the buffer
    lda #0
    sta rl_len
@next:
    bit RIA_READY
    bvc @next
    lda RIA_RX
    cmp #13
    beq @return
    cmp #10
    beq @return
    cmp #27
    beq @escape
    cmp #127
    beq @delete
    cmp #8
    beq @delete
    cmp rl_min_ch
    bcc @next
    cmp rl_max_ch
    beq :+
    bcs @next
:   ldy rl_len
    cpy rl_max
    bcs @full
    sta (owblock),y
    inc rl_len
    jsr oswrch
    jmp @next
@full:
    lda #7
    jsr oswrch
    jmp @next
@delete:
    lda rl_len
    beq @next
    dec rl_len
    lda #127
    jsr oswrch
    jmp @next
@return:
    lda #13
    ldy rl_len
    sta (owblock),y
    clc
    rts
@escape:
    ldy rl_len
    sec
    rts

; ---------------------------------------------------------------------
; Sound

sound_init:
    xreg 0, 1, 0, XRAM_PSG
    lda #<XRAM_PSG
    sta RIA_ADDR0
    lda #>XRAM_PSG
    sta RIA_ADDR0+1
    lda #1
    sta RIA_STEP0
    ldx #0
:   lda psg_init_data,x
    sta RIA_RW0
    inx
    cpx #4 * PSG_CHANNEL_SIZE
    bne :-
    ldx #3
:   lda #$FF
    sta ch_att,x
    dex
    bpl :-
    ; The bell: SOUND &13,-15,208,1
    ldx #7
:   lda bell_data,x
    sta bell_block,x
    dex
    bpl :-
    rts

.segment "RODATA"
psg_init_data:
    ; freq, duty, attack, decay, release_wave, pan_gate, reserved
    .word 0
    .byte 128, $F0, $F0, PSG_WAVE_NOISE, 0, 0
    .repeat 3
    .word 0
    .byte 128, $F0, $F0, PSG_WAVE_SQUARE, 0, 0
    .endrepeat
bell_data:
    .word $13, .loword(-15), 208, 1
; PSG frequency * 3 of the noise of BBC noise pitches 0-2: shift rates of
; 7.8 kHz, 3.9 kHz and 1.95 kHz.
noise_lo:
    .byte <(7812 * 3), <(3906 * 3), <(1953 * 3)
noise_hi:
    .byte >(7812 * 3), >(3906 * 3), >(1953 * 3)

.segment "CODE"

; OSWORD 7: SOUND, with the block at ptr. The block holds the channel, the amplitude (negative for
; a level, 1-4 for an envelope), the pitch and the duration in 1/20 s, as
; 16-bit values. Bit 4 of the channel flushes the queue of the channel.
; Like the MOS, it waits while the queue is full.
sound:
    ldy #0
    lda (ptr),y
    and #$03
    tax
    lda (ptr),y
    and #$10
    beq @wait
    sei
    lda #0
    sta snd_qn,x
    sta ch_state,x      ; the next tick starts this note
    beq @add
@wait:
    lda snd_qn,x
    cmp #4
    bcs @wait           ; the interrupt makes room
    sei
@add:
    txa
    asl a
    asl a
    sta tmp
    lda snd_qh,x
    clc
    adc snd_qn,x
    and #$03
    ora tmp
    tax
    ldy #2
    lda (ptr),y
    sta snd_qamp,x
    ldy #4
    lda (ptr),y
    sta snd_qpitch,x
    ldy #6
    lda (ptr),y
    sta snd_qdur,x
    ldy #0
    lda (ptr),y
    and #$03
    tax
    inc snd_qn,x
    cli
    rts

; OSWORD 8: ENVELOPE. Envelopes 1-4.
envelope:
    ldy #0
    lda (owblock),y
    sec
    sbc #1
    and #$03
    tax
    lda env_offset,x
    tax
    ldy #1
:   lda (owblock),y
    sta env_tab,x
    inx
    iny
    cpy #14
    bne :-
    rts

.segment "RODATA"
env_offset:
    .byte 0, 13, 26, 39

; ---------------------------------------------------------------------
; The VSYNC interrupt: 60 times a second. It counts centiseconds, 5 for
; every 3 VSYNCs, and runs the sound once per centisecond.

.segment "CODE"

irq:
    pha
    txa
    pha
    tya
    pha
    lda RIA_IRQ         ; acknowledge
    lda RIA_ADDR1       ; the sound writes through portal 1
    pha
    lda RIA_ADDR1+1
    pha
    lda RIA_STEP1
    pha
    lda #1
    sta RIA_STEP1
    clc
    lda cs_acc
    adc #5
    sta cs_acc
@tick:
    lda cs_acc
    cmp #3
    bcc @done
    sbc #3
    sta cs_acc
    jsr centisecond
    jmp @tick
@done:
    pla
    sta RIA_STEP1
    pla
    sta RIA_ADDR1+1
    pla
    sta RIA_ADDR1
    pla
    tay
    pla
    tax
    pla
    rti

centisecond:
    inc cs_ticks
    bne :+
    inc cs_ticks+1
:   ldx #3
:   jsr sound_channel
    dex
    bpl :-
    rts

; One centisecond of BBC sound channel X.
sound_channel:
    lda ch_state,x
    beq @idle
    cmp #2
    beq @releasing
    lda ch_inf,x
    bne @envelope
    lda ch_dur_lo,x
    bne :+
    dec ch_dur_hi,x
:   dec ch_dur_lo,x
    lda ch_dur_lo,x
    ora ch_dur_hi,x
    bne @envelope
    ; the note is over
    lda snd_qn,x
    bne @start
    lda ch_env,x
    beq @silence
    lda #2
    sta ch_state,x
    lda #3
    sta ch_phase,x
    bne @envelope
@releasing:
    lda snd_qn,x
    bne @start
    beq @envelope
@idle:
    lda snd_qn,x
    beq @output
@start:
    jsr start_note
@envelope:
    lda ch_env,x
    beq @output
    dec ch_step,x
    bne @output
    jsr envelope_step
    jmp @output
@silence:
    lda #0
    sta ch_state,x
    sta ch_amp,x
@output:
    jmp channel_output

; Takes the next note from the queue of channel X.
start_note:
    txa
    asl a
    asl a
    ora snd_qh,x
    tay
    inc snd_qh,x
    lda snd_qh,x
    and #$03
    sta snd_qh,x
    dec snd_qn,x
    lda snd_qdur,y
    cmp #$FF
    bne :+
    sta ch_inf,x
    bne @dur_done
:   lda #0
    sta ch_inf,x
    sta ch_dur_hi,x
    lda snd_qdur,y      ; * 5 centiseconds
    sta itmp
    asl a
    rol ch_dur_hi,x
    asl a
    rol ch_dur_hi,x
    clc
    adc itmp
    sta ch_dur_lo,x
    bcc :+
    inc ch_dur_hi,x
:   lda ch_dur_lo,x
    ora ch_dur_hi,x
    bne @dur_done
    lda #1              ; a duration of 0 still sounds briefly
    sta ch_dur_lo,x
@dur_done:
    lda snd_qamp,y
    beq @level          ; amplitude 0: silence
    bmi @level
    ; an envelope
    sec
    sbc #1
    and #$03
    clc
    adc #1
    sta ch_env,x
    lda #0
    sta ch_amp,x
    sta ch_phase,x
    lda #1
    sta ch_step,x
    bne @pitch
@level:
    ; -15..0 to 120..0
    eor #$FF
    clc
    adc #1
    asl a
    asl a
    asl a
    sta ch_amp,x
    lda #0
    sta ch_env,x
@pitch:
    lda #1
    sta ch_state,x
    ; write the frequency, and start the note again
    jsr psg_channel_address
    lda snd_qpitch,y
    cpx #0
    bne @tone
    and #$03
    cmp #$03
    beq @tone_of_1
    tay
    lda noise_lo,y
    sta RIA_RW1
    lda noise_hi,y
    sta RIA_RW1
    jmp @gate
@tone_of_1:
    ldy #1 * 4
    lda snd_qpitch,y    ; an approximation: the last pitch queued on 1
@tone:
    tay
    lda pitch_lo,y
    sta RIA_RW1
    lda pitch_hi,y
    sta RIA_RW1
@gate:
    jsr psg_channel_address
    clc
    lda RIA_ADDR1
    adc #PSG_CHANNEL_PAN_GATE
    sta RIA_ADDR1
    lda #0
    sta RIA_RW1         ; gate off, so the next write starts the note
    lda #$FF
    sta ch_att,x
    rts

; Portal 1 at PSG channel X (BBC channel X is PSG channel X).
psg_channel_address:
    txa
    asl a
    asl a
    asl a
    clc
    adc #<XRAM_PSG
    sta RIA_ADDR1
    lda #>XRAM_PSG
    adc #0
    sta RIA_ADDR1+1
    rts

; One step of the amplitude envelope of channel X. The pitch parts of the
; envelopes are not used by the game, so they are not run.
envelope_step:
    lda ch_env,x
    tay
    lda env_offset-1,y
    tay                 ; Y = the envelope in env_tab
    lda env_tab,y       ; T, the step length
    and #$7F
    bne :+
    lda #1
:   sta ch_step,x
    lda ch_phase,x
    beq @attack
    cmp #1
    beq @decay
    cmp #2
    beq @sustain
    ; release
    lda env_tab+10,y    ; AR
    jsr add_amp
    lda ch_amp,x
    bne :+
    lda #0
    sta ch_state,x
:   rts
@sustain:
    lda env_tab+9,y     ; AS
    jmp add_amp
@attack:
    lda env_tab+11,y    ; ALA
    sta itmp+1
    lda env_tab+7,y     ; AA
    jmp toward_target
@decay:
    lda env_tab+12,y    ; ALD
    sta itmp+1
    lda env_tab+8,y     ; AD
    ; fall through

; Adds the signed step A to the amplitude, and stops at the target level
; in itmp+1, where it goes on to the next phase. A step of 0 goes on at
; once.
toward_target:
    sta itmp
    cmp #0
    beq @next
    bmi @down
    clc
    adc ch_amp,x
    bcs @reached        ; past 255
    cmp itmp+1
    bcs @reached
    sta ch_amp,x
    rts
@down:
    clc
    adc ch_amp,x
    bcc @reached        ; below 0
    cmp itmp+1
    bcc @reached
    beq @reached
    sta ch_amp,x
    rts
@reached:
    lda itmp+1
    sta ch_amp,x
@next:
    inc ch_phase,x
    rts

; Adds the signed step A to the amplitude, kept in 0-126. Z = 1 when it
; is 0.
add_amp:
    cmp #0
    bmi @down
    clc
    adc ch_amp,x
    cmp #127
    bcc @store
    lda #126
    bne @store
@down:
    clc
    adc ch_amp,x
    bcs @store
    lda #0
@store:
    sta ch_amp,x
    rts

; Writes the level of channel X to the PSG when it has changed.
channel_output:
    lda ch_state,x
    beq @off
    lda ch_amp,x
    lsr a
    lsr a
    lsr a
    beq @off
    eor #$0F            ; attenuation 0 (loud) to 14
    jmp @write
@off:
    lda #$10            ; off
@write:
    cmp ch_att,x
    beq @same
    sta ch_att,x
    sta itmp
    jsr psg_channel_address
    lda itmp
    cmp #$10
    beq @gate_off
    asl a
    asl a
    asl a
    asl a
    sta itmp            ; level in bits 7-4, rate 0
    clc
    lda RIA_ADDR1
    adc #PSG_CHANNEL_ATTACK
    sta RIA_ADDR1
    lda itmp
    sta RIA_RW1         ; attack
    sta RIA_RW1         ; decay
    inc RIA_ADDR1       ; skip release_wave
    lda #PSG_GATE
    sta RIA_RW1
@same:
    rts
@gate_off:
    clc
    lda RIA_ADDR1
    adc #PSG_CHANNEL_PAN_GATE
    sta RIA_ADDR1
    lda #0
    sta RIA_RW1
    rts

; ---------------------------------------------------------------------

.segment "RODATA"
.include "tables.inc"
