; XRAM memory map of the Chuckie Egg port.
;
; The BBC Micro MODE 2 screen is 160x256 pixels in 16 logical colours.
; Here it is a mode 3 bitmap in 4-bit colour, 320 pixels wide, where each
; BBC pixel is one byte: two equal nibbles, so two canvas pixels. A BBC
; pixel at column x (0-159) and row r (0-255, top first) is the XRAM byte
; at r * 160 + x.

XRAM_BITMAP     = $0000         ; 160 * 256 = 40960 bytes
XRAM_BITMAP_END = $A000
XRAM_CONFIG     = $A000         ; mode3_config_t of the top scanlines
XRAM_CONFIG2    = $A010         ; mode3_config_t of the rest
XRAM_PALETTE    = $A020         ; 16 colours, 32 bytes
XRAM_KEYBOARD   = $A040         ; keyboard_t, 32 bytes
XRAM_PSG        = $A100         ; psg_t, 64 bytes, inside one page

SCREEN_STRIDE   = 160

; Mode 3 configuration structure (mode3_config_t)
MODE3_CONFIG_X_WRAP           = 0
MODE3_CONFIG_Y_WRAP           = 1
MODE3_CONFIG_X_POS_PX         = 2
MODE3_CONFIG_Y_POS_PX         = 4
MODE3_CONFIG_WIDTH_PX         = 6
MODE3_CONFIG_HEIGHT_PX        = 8
MODE3_CONFIG_XRAM_DATA_PTR    = 10
MODE3_CONFIG_XRAM_PALETTE_PTR = 12
MODE3_CONFIG_SIZE             = 14

CANVAS_320X240  = 1
MODE3_4BPP      = $02

; PSG
PSG_WAVE_SINE     = $00
PSG_WAVE_SQUARE   = $10
PSG_WAVE_SAWTOOTH = $20
PSG_WAVE_TRIANGLE = $30
PSG_WAVE_NOISE    = $40
PSG_GATE          = $01

PSG_CHANNEL_FREQ         = 0
PSG_CHANNEL_DUTY         = 2
PSG_CHANNEL_ATTACK       = 3
PSG_CHANNEL_DECAY        = 4
PSG_CHANNEL_RELEASE_WAVE = 5
PSG_CHANNEL_PAN_GATE     = 6
PSG_CHANNEL_SIZE         = 8

.macro COLOR_FROM_RGBA r, g, b, alpha
    .word (((b) >> 3) << 11) | (((g) >> 3) << 6) | (((alpha) >> 7) << 5) | ((r) >> 3)
.endmacro
