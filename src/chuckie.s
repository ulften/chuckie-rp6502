; Chuckie Egg for the Picocomputer 6502 (RP6502).
;
; The game code of Chuckie Egg for the BBC Micro, from the mungre/chuckie
; disassembly. tools/basm2ca65.py converted it to ca65 and tools/port.py
; applied the changes marked RP6502. The rest is the original code.

.segment "GAME"
.export entry_point
.import plat_sleep, plat_countdown, plat_counting, plat_layout_game, plat_layout_menu

scan_f0 = $20  ; main.basm:14
scan_f1 = $71  ; main.basm:15
scan_f2 = $72  ; main.basm:16
scan_f3 = $73  ; main.basm:17
scan_f4 = $14  ; main.basm:18
scan_f5 = $74  ; main.basm:19
scan_f6 = $75  ; main.basm:20
scan_f7 = $16  ; main.basm:21
scan_f8 = $76  ; main.basm:22
scan_f9 = $77  ; main.basm:23
scan_PAD_PLUS = $3A  ; main.basm:24
scan_PAD_MINUS = $3B  ; main.basm:25
scan_PAD_DIVIDE = $4A  ; main.basm:26
scan_PAD_TIMES = $5B  ; main.basm:27
scan_ESCAPE = $70  ; main.basm:28
scan_1 = $30  ; main.basm:29
scan_2 = $31  ; main.basm:30
scan_3 = $11  ; main.basm:31
scan_4 = $12  ; main.basm:32
scan_5 = $13  ; main.basm:33
scan_6 = $34  ; main.basm:34
scan_7 = $24  ; main.basm:35
scan_8 = $15  ; main.basm:36
scan_9 = $26  ; main.basm:37
scan_0 = $27  ; main.basm:38
scan_EQUALS = $17  ; main.basm:39
scan_TILDE = $18  ; main.basm:40
scan_PIPE = $78  ; main.basm:41
scan_LEFT = $19  ; main.basm:42
scan_RIGHT = $79  ; main.basm:43
scan_PAD_7 = $1B  ; main.basm:44
scan_PAD_8 = $2A  ; main.basm:45
scan_PAD_9 = $2B  ; main.basm:46
scan_PAD_HASH = $5A  ; main.basm:47
scan_TAB = $60  ; main.basm:48
scan_Q = $10  ; main.basm:49
scan_W = $21  ; main.basm:50
scan_E = $22  ; main.basm:51
scan_R = $33  ; main.basm:52
scan_T = $23  ; main.basm:53
scan_Y = $44  ; main.basm:54
scan_U = $35  ; main.basm:55
scan_I = $25  ; main.basm:56
scan_O = $36  ; main.basm:57
scan_P = $37  ; main.basm:58
scan_AT = $47  ; main.basm:59
scan_LBRACE = $38  ; main.basm:60
scan_STERLING = $28  ; main.basm:61
scan_UP = $39  ; main.basm:62
scan_DOWN = $29  ; main.basm:63
scan_PAD_4 = $7A  ; main.basm:64
scan_PAD_5 = $7B  ; main.basm:65
scan_PAD_6 = $1A  ; main.basm:66
scan_PAD_DELETE = $4B  ; main.basm:67
scan_CAPSLOCK = $40  ; main.basm:68
scan_CTRL = $01  ; main.basm:69
scan_A = $41  ; main.basm:70
scan_S = $51  ; main.basm:71
scan_D = $32  ; main.basm:72
scan_F = $43  ; main.basm:73
scan_G = $53  ; main.basm:74
scan_H = $54  ; main.basm:75
scan_J = $45  ; main.basm:76
scan_K = $46  ; main.basm:77
scan_L = $56  ; main.basm:78
scan_PLUS = $57  ; main.basm:79
scan_TIMES = $48  ; main.basm:80
scan_RBRACE = $58  ; main.basm:81
scan_RETURN = $49  ; main.basm:82
scan_PAD_1 = $6B  ; main.basm:83
scan_PAD_2 = $7C  ; main.basm:84
scan_PAD_3 = $6C  ; main.basm:85
scan_PAD_COMMA = $5C  ; main.basm:86
scan_SHIFTLOCK = $50  ; main.basm:87
scan_SHIFT = $00  ; main.basm:88
scan_Z = $61  ; main.basm:89
scan_X = $42  ; main.basm:90
scan_C = $52  ; main.basm:91
scan_V = $63  ; main.basm:92
scan_B = $64  ; main.basm:93
scan_N = $55  ; main.basm:94
scan_M = $65  ; main.basm:95
scan_COMMA = $66  ; main.basm:96
scan_FULLSTOP = $67  ; main.basm:97
scan_SLASH = $68  ; main.basm:98
scan_DELETE = $59  ; main.basm:99
scan_COPY = $69  ; main.basm:100
scan_PAD_0 = $6A  ; main.basm:101
scan_PAD_FULLSTOP = $4C  ; main.basm:102
scan_PAD_RETURN = $3C  ; main.basm:103
scan_SPACE = $62  ; main.basm:104
osword_0_read_line = 0  ; main.basm:107
osword_3_read_interval_timer = 3  ; main.basm:108
osword_4_write_interval_timer = 4  ; main.basm:109
osword_7_play_sound = 7  ; main.basm:110
osword_8_define_envelope = 8  ; main.basm:111
osbyte_04_cursor_key_effect = $04  ; main.basm:114
osbyte_0F_flush_buffer_class = $0F  ; main.basm:115
osbyte_79_keyboard_scan = $79  ; main.basm:116
osbyte_7A_keyboard_scan_from_16 = $7A  ; main.basm:117
osbyte_7C_clear_escape = $7C  ; main.basm:118
osbyte_81_inkey = $81  ; main.basm:119
osbyte_8C_select_tape = $8C  ; main.basm:120
osbyte_AC_key_code_to_ascii_table = $AC  ; main.basm:121
osbyte_D6_bell_duration = $D6  ; main.basm:122
osbyte_E5_escape_key_effect = $E5  ; main.basm:123
interval_time = $00  ; chuckie.basm:2
carousel_stack_top = $1B  ; chuckie.basm:3
clock_stop_timer = $1C  ; chuckie.basm:4
timer_2 = $1D  ; chuckie.basm:5
timer_1 = $1E  ; chuckie.basm:6
timer_0 = $1F  ; chuckie.basm:7
player_lives = $20  ; chuckie.basm:8
player_levels = $24  ; chuckie.basm:9
current_score = $28  ; chuckie.basm:10
duck_x = $30  ; chuckie.basm:11
duck_y = $31  ; chuckie.basm:12
duck_vx = $32  ; chuckie.basm:13
duck_vy = $33  ; chuckie.basm:14
duck_direction_flap = $34  ; chuckie.basm:15
duck_loose_flag = $35  ; chuckie.basm:16
current_chicken = $36  ; chuckie.basm:17
chicken_speed = $37  ; chuckie.basm:18
birds_timer_cycle = $38  ; chuckie.basm:19
egg_remaining_count = $39  ; chuckie.basm:20
bonus_3 = $3A  ; chuckie.basm:21
bonus_2 = $3B  ; chuckie.basm:22
bonus_1 = $3C  ; chuckie.basm:23
bonus_gone_flag = $3D  ; chuckie.basm:24
extra_life_flag = $3E  ; chuckie.basm:25
score_x_position = $3F  ; chuckie.basm:26
harry_x = $40  ; chuckie.basm:27
harry_y = $41  ; chuckie.basm:28
harry_board_x = $42  ; chuckie.basm:29
harry_board_y = $43  ; chuckie.basm:30
harry_cell_x = $44  ; chuckie.basm:31
harry_cell_y = $45  ; chuckie.basm:32
harry_dx = $46  ; chuckie.basm:33
harry_dy = $47  ; chuckie.basm:34
harry_sprite_index = $48  ; chuckie.basm:35
harry_state = $49  ; chuckie.basm:36
harry_fall_scaled_vy = $4A  ; chuckie.basm:37
harry_fall_facing = $4B  ; chuckie.basm:38
harry_facing = $4C  ; chuckie.basm:39
round_number = $4D  ; chuckie.basm:40
player_data_index = $4E  ; chuckie.basm:41
dead_flag = $4F  ; chuckie.basm:42
level_number = $50  ; chuckie.basm:43
scenario_lo = $51  ; chuckie.basm:44
scenario_hi = $52  ; chuckie.basm:45
wall_count = $53  ; chuckie.basm:46
ladder_count = $54  ; chuckie.basm:47
lift_flag = $55  ; chuckie.basm:48
grain_count = $56  ; chuckie.basm:49
chicken_count = $57  ; chuckie.basm:50
lift_x = $58  ; chuckie.basm:51
lift_y1 = $59  ; chuckie.basm:52
lift_y2 = $5A  ; chuckie.basm:53
lift_alternator = $5B  ; chuckie.basm:54
scenario_number = $5C  ; chuckie.basm:55
player = $5D  ; chuckie.basm:56
player_total_count = $5E  ; chuckie.basm:57
player_remaining_count = $5F  ; chuckie.basm:58
key_press_bits = $60  ; chuckie.basm:59
key_right = $61  ; chuckie.basm:60
key_left = $62  ; chuckie.basm:61
key_down = $63  ; chuckie.basm:62
key_up = $64  ; chuckie.basm:63
key_jump = $65  ; chuckie.basm:64
rand1 = $66  ; chuckie.basm:65
rand2 = $67  ; chuckie.basm:66
rand3 = $68  ; chuckie.basm:67
rand4 = $69  ; chuckie.basm:68
screen_lo = $70  ; chuckie.basm:69
screen_hi = $71  ; chuckie.basm:70
screen_row_offset = $72  ; chuckie.basm:71
screen_col_offset = $73  ; chuckie.basm:72
string_length = $75  ; chuckie.basm:73
sprite_lo = $76  ; chuckie.basm:74
sprite_hi = $77  ; chuckie.basm:75
sprite_height = $78  ; chuckie.basm:76
sprite_width_pixels = $79  ; chuckie.basm:77
sprite_width_bytes = $7A  ; chuckie.basm:78
sprite_colour_mask_left = $7F  ; chuckie.basm:79
param = $88  ; chuckie.basm:80
loop_counter = $8A  ; chuckie.basm:81
chicken_xs = $0400  ; chuckie.basm:82
chicken_ys = $0405  ; chuckie.basm:83
chicken_board_xs = $040A  ; chuckie.basm:84
chicken_board_ys = $040F  ; chuckie.basm:85
chicken_states = $0414  ; chuckie.basm:86
chicken_sprite_indices = $0419  ; chuckie.basm:87
chicken_directions = $041E  ; chuckie.basm:88
highscore_table = $0430  ; chuckie.basm:89
player_score = $0500  ; chuckie.basm:90
player_level_bonus = $0508  ; chuckie.basm:91
player_egg_flags = $0510  ; chuckie.basm:92
player_grain_flags = $0520  ; chuckie.basm:93
board_page1 = $0600  ; chuckie.basm:94
board_page2 = $0700  ; chuckie.basm:95
; RP6502: the MOS entry points are in platform.s.
.import oswrch, osword, osbyte
draw_key_selection_indirect:  ; chuckie.basm:106
    jmp draw_key_selection  ; chuckie.basm:108
select_keys:  ; chuckie.basm:111
    ldx #<((msg_key_selection))  ; chuckie.basm:113
    ldy #>((msg_key_selection))  ; chuckie.basm:113
    jsr write_counted_string  ; chuckie.basm:114
    lda #osbyte_AC_key_code_to_ascii_table  ; chuckie.basm:115
    ldx #$00  ; chuckie.basm:116
    ldy #$FF  ; chuckie.basm:117
    jsr osbyte  ; chuckie.basm:118
    stx sprite_lo  ; chuckie.basm:119
    sty sprite_hi  ; chuckie.basm:120
    lda #$00  ; chuckie.basm:121
    sta key_press_bits  ; chuckie.basm:122
    lda #$54  ; chuckie.basm:123
    sta current_score  ; chuckie.basm:124
    ldx #<((msg_key_up))  ; chuckie.basm:125
    ldy #>((msg_key_up))  ; chuckie.basm:125
    jsr write_counted_string  ; chuckie.basm:126
    jsr select_key  ; chuckie.basm:127
    sta key_up  ; chuckie.basm:128
    ldx #<((msg_key_down))  ; chuckie.basm:129
    ldy #>((msg_key_down))  ; chuckie.basm:129
    jsr write_counted_string  ; chuckie.basm:130
    jsr select_key  ; chuckie.basm:131
    sta key_down  ; chuckie.basm:132
    ldx #<((msg_key_left))  ; chuckie.basm:133
    ldy #>((msg_key_left))  ; chuckie.basm:133
    jsr write_counted_string  ; chuckie.basm:134
    jsr select_key  ; chuckie.basm:135
    sta key_left  ; chuckie.basm:136
    ldx #<((msg_key_right))  ; chuckie.basm:137
    ldy #>((msg_key_right))  ; chuckie.basm:137
    jsr write_counted_string  ; chuckie.basm:138
    jsr select_key  ; chuckie.basm:139
    sta key_right  ; chuckie.basm:140
    ldx #<((msg_key_jump))  ; chuckie.basm:141
    ldy #>((msg_key_jump))  ; chuckie.basm:141
    jsr write_counted_string  ; chuckie.basm:142
    jsr select_key  ; chuckie.basm:143
    sta key_jump  ; chuckie.basm:144
    rts   ; chuckie.basm:145
select_key:  ; chuckie.basm:146
    lda #osbyte_79_keyboard_scan  ; chuckie.basm:147
    ldx #scan_SHIFT ^ $80  ; chuckie.basm:148
    jsr osbyte  ; chuckie.basm:149
    txa   ; chuckie.basm:150
    bpl not_shift_1  ; chuckie.basm:151
    ldx #$00  ; chuckie.basm:152
    jmp key_pressed  ; chuckie.basm:153
not_shift_1:  ; chuckie.basm:154
    lda #osbyte_79_keyboard_scan  ; chuckie.basm:155
    ldx #scan_CTRL ^ $80  ; chuckie.basm:156
    jsr osbyte  ; chuckie.basm:157
    txa   ; chuckie.basm:158
    bpl not_ctrl  ; chuckie.basm:159
    ldx #$01  ; chuckie.basm:160
    jmp key_pressed  ; chuckie.basm:161
not_ctrl:  ; chuckie.basm:162
    lda #osbyte_7A_keyboard_scan_from_16  ; chuckie.basm:163
    jsr osbyte  ; chuckie.basm:164
    cpx #$FF  ; chuckie.basm:165
    beq select_key  ; chuckie.basm:166
key_pressed:  ; chuckie.basm:167
    stx param  ; chuckie.basm:168
    txa   ; chuckie.basm:169
    eor #$FF  ; chuckie.basm:170
    sta $89  ; chuckie.basm:171
    ldy key_press_bits  ; chuckie.basm:172
    txa   ; chuckie.basm:173
    and #$0F  ; chuckie.basm:174
    sta $8B  ; chuckie.basm:175
    txa   ; chuckie.basm:176
    and #$F0  ; chuckie.basm:177
    sta $8C  ; chuckie.basm:178
    lda #$00  ; chuckie.basm:179
    sta $8D  ; chuckie.basm:180
    sta $8E  ; chuckie.basm:181
key_clash_loop:  ; chuckie.basm:182
    txa   ; chuckie.basm:183
    cmp current_score,Y  ; chuckie.basm:184
    beq select_key  ; chuckie.basm:185
    lda current_score,Y  ; chuckie.basm:186
    and #$0F  ; chuckie.basm:187
    cmp $8B  ; chuckie.basm:188
    bne lo_nibble_mismatch  ; chuckie.basm:189
    inc $8D  ; chuckie.basm:190
lo_nibble_mismatch:  ; chuckie.basm:191
    lda current_score,Y  ; chuckie.basm:192
    and #$F0  ; chuckie.basm:193
    cmp $8C  ; chuckie.basm:194
    bne hi_nibble_mismatch  ; chuckie.basm:195
    inc $8E  ; chuckie.basm:196
hi_nibble_mismatch:  ; chuckie.basm:197
    dey   ; chuckie.basm:198
    bpl key_clash_loop  ; chuckie.basm:199
    lda $8D  ; chuckie.basm:200
    beq no_clash  ; chuckie.basm:201
    lda $8E  ; chuckie.basm:202
    beq no_clash  ; chuckie.basm:203
    lda #osbyte_D6_bell_duration  ; chuckie.basm:204
    ldx #$01  ; chuckie.basm:205
    ldy #$00  ; chuckie.basm:206
    jsr osbyte  ; chuckie.basm:207
    lda #$07  ; chuckie.basm:208
    jsr oswrch  ; chuckie.basm:209
    jmp select_key  ; chuckie.basm:210
no_clash:  ; chuckie.basm:211
    inc key_press_bits  ; chuckie.basm:212
    ldy key_press_bits  ; chuckie.basm:213
    txa   ; chuckie.basm:214
    sta current_score,Y  ; chuckie.basm:215
draw_key_name_impl:  ; chuckie.basm:218
    cpx #$02  ; chuckie.basm:220
    bcs not_shift_ctrl  ; chuckie.basm:221
    cpx #$00  ; chuckie.basm:222
    bne not_shift_2  ; chuckie.basm:223
    ldx #<((key_name_shift))  ; chuckie.basm:224
    ldy #>((key_name_shift))  ; chuckie.basm:224
    jmp write_name_load_result  ; chuckie.basm:225
not_shift_2:  ; chuckie.basm:226
    ldx #<((key_name_control))  ; chuckie.basm:227
    ldy #>((key_name_control))  ; chuckie.basm:227
    jmp write_name_load_result  ; chuckie.basm:228
not_shift_ctrl:  ; chuckie.basm:229
    ldy param  ; chuckie.basm:230
    lda (sprite_lo),Y  ; chuckie.basm:231
    cmp #$21  ; chuckie.basm:232
    bcc not_ascii  ; chuckie.basm:233
    cmp #$7F  ; chuckie.basm:234
    bcs not_ascii  ; chuckie.basm:235
    pha   ; chuckie.basm:236
    lda #$27  ; chuckie.basm:237
    jsr oswrch  ; chuckie.basm:238
    pla   ; chuckie.basm:239
    jsr oswrch  ; chuckie.basm:240
    lda #$27  ; chuckie.basm:241
    jsr oswrch  ; chuckie.basm:242
    jmp load_result  ; chuckie.basm:243
not_ascii:  ; chuckie.basm:244
    cmp #$00  ; chuckie.basm:245
    bne not_tab  ; chuckie.basm:246
    ldx #<((key_name_tab))  ; chuckie.basm:247
    ldy #>((key_name_tab))  ; chuckie.basm:247
    jmp write_name_load_result  ; chuckie.basm:248
not_tab:  ; chuckie.basm:249
    cmp #$01  ; chuckie.basm:250
    bne not_capslock  ; chuckie.basm:251
    ldx #<((key_name_capslock))  ; chuckie.basm:252
    ldy #>((key_name_capslock))  ; chuckie.basm:252
    jmp write_name_load_result  ; chuckie.basm:253
not_capslock:  ; chuckie.basm:254
    cmp #$02  ; chuckie.basm:255
    bne not_shiftlock  ; chuckie.basm:256
    ldx #<((key_name_shiftlock))  ; chuckie.basm:257
    ldy #>((key_name_shiftlock))  ; chuckie.basm:257
    jmp write_name_load_result  ; chuckie.basm:258
not_shiftlock:  ; chuckie.basm:259
    cmp #$1B  ; chuckie.basm:260
    bne not_escape  ; chuckie.basm:261
    ldx #<((key_name_escape))  ; chuckie.basm:262
    ldy #>((key_name_escape))  ; chuckie.basm:262
    jmp write_name_load_result  ; chuckie.basm:263
not_escape:  ; chuckie.basm:264
    cmp #$20  ; chuckie.basm:265
    bne not_space  ; chuckie.basm:266
    ldx #<((key_name_space))  ; chuckie.basm:267
    ldy #>((key_name_space))  ; chuckie.basm:267
    jmp write_name_load_result  ; chuckie.basm:268
not_space:  ; chuckie.basm:269
    cmp #$7F  ; chuckie.basm:270
    bne not_delete  ; chuckie.basm:271
    ldx #<((key_name_delete))  ; chuckie.basm:272
    ldy #>((key_name_delete))  ; chuckie.basm:272
    jmp write_name_load_result  ; chuckie.basm:273
not_delete:  ; chuckie.basm:274
    cmp #$0D  ; chuckie.basm:275
    bne not_enter  ; chuckie.basm:276
    ldx #<((key_name_return))  ; chuckie.basm:277
    ldy #>((key_name_return))  ; chuckie.basm:277
    jmp write_name_load_result  ; chuckie.basm:278
not_enter:  ; chuckie.basm:279
    cmp #$8B  ; chuckie.basm:280
    bne not_copy  ; chuckie.basm:281
    ldx #<((key_name_copy))  ; chuckie.basm:282
    ldy #>((key_name_copy))  ; chuckie.basm:282
    jmp write_name_load_result  ; chuckie.basm:283
not_copy:  ; chuckie.basm:284
    cmp #$8C  ; chuckie.basm:285
    bne not_left  ; chuckie.basm:286
    ldx #<((key_name_left))  ; chuckie.basm:287
    ldy #>((key_name_left))  ; chuckie.basm:287
    jmp write_name_load_result  ; chuckie.basm:288
not_left:  ; chuckie.basm:289
    cmp #$8D  ; chuckie.basm:290
    bne not_right  ; chuckie.basm:291
    ldx #<((key_name_right))  ; chuckie.basm:292
    ldy #>((key_name_right))  ; chuckie.basm:292
    jmp write_name_load_result  ; chuckie.basm:293
not_right:  ; chuckie.basm:294
    cmp #$8E  ; chuckie.basm:295
    bne not_down  ; chuckie.basm:296
    ldx #<((key_name_down))  ; chuckie.basm:297
    ldy #>((key_name_down))  ; chuckie.basm:297
    jmp write_name_load_result  ; chuckie.basm:298
not_down:  ; chuckie.basm:299
    cmp #$8F  ; chuckie.basm:300
    bne not_up  ; chuckie.basm:301
    ldx #<((key_name_up))  ; chuckie.basm:302
    ldy #>((key_name_up))  ; chuckie.basm:302
    jmp write_name_load_result  ; chuckie.basm:303
not_up:  ; chuckie.basm:304
    cmp #$80  ; chuckie.basm:305
    bcc load_result  ; chuckie.basm:306
    cmp #$8A  ; chuckie.basm:307
    bcs load_result  ; chuckie.basm:308
    pha   ; chuckie.basm:309
    lda #$66  ; chuckie.basm:310
    jsr oswrch  ; chuckie.basm:311
    pla   ; chuckie.basm:312
    sec   ; chuckie.basm:313
    sbc #$50  ; chuckie.basm:314
    jsr oswrch  ; chuckie.basm:315
    jmp load_result  ; chuckie.basm:316
write_name_load_result:  ; chuckie.basm:317
    jsr write_counted_string  ; chuckie.basm:318
load_result:  ; chuckie.basm:319
    lda $89  ; chuckie.basm:320
    rts   ; chuckie.basm:321
msg_key_selection:  ; chuckie.basm:323
    .byte MSG_END_1-MSG_START_1  ; chuckie.basm:324
MSG_START_1:  ; chuckie.basm:324
    .byte $10  ; chuckie.basm:325
    .byte $12, (0), (4)  ; chuckie.basm:326
    .byte $19, (4), <((480)), >((480)), <((950)), >((950))  ; chuckie.basm:327
    .byte "K E Y"  ; chuckie.basm:328
    .byte $19, (4), <((96)), >((96)), <((850)), >((850))  ; chuckie.basm:329
    .byte "S E L E C T I O N"  ; chuckie.basm:330
    .byte $12, (0), (2)  ; chuckie.basm:331
MSG_END_1:  ; chuckie.basm:332
msg_key_up:  ; chuckie.basm:334
    .byte MSG_END_2-MSG_START_2  ; chuckie.basm:335
MSG_START_2:  ; chuckie.basm:335
    .byte $19, (4), <((196)), >((196)), <((700)), >((700))  ; chuckie.basm:336
    .byte "Up .. "  ; chuckie.basm:337
MSG_END_2:  ; chuckie.basm:338
msg_key_down:  ; chuckie.basm:340
    .byte MSG_END_3-MSG_START_3  ; chuckie.basm:341
MSG_START_3:  ; chuckie.basm:341
    .byte $19, (4), <((64)), >((64)), <((620)), >((620))  ; chuckie.basm:342
    .byte "Down .. "  ; chuckie.basm:343
MSG_END_3:  ; chuckie.basm:344
msg_key_left:  ; chuckie.basm:346
    .byte MSG_END_4-MSG_START_4  ; chuckie.basm:347
MSG_START_4:  ; chuckie.basm:347
    .byte $19, (4), <((64)), >((64)), <((540)), >((540))  ; chuckie.basm:348
    .byte "Left .. "  ; chuckie.basm:349
MSG_END_4:  ; chuckie.basm:350
msg_key_right:  ; chuckie.basm:352
    .byte MSG_END_5-MSG_START_5  ; chuckie.basm:353
MSG_START_5:  ; chuckie.basm:353
    .byte $19, (4), <((0)), >((0)), <((460)), >((460))  ; chuckie.basm:354
    .byte "Right .. "  ; chuckie.basm:355
MSG_END_5:  ; chuckie.basm:356
msg_key_jump:  ; chuckie.basm:358
    .byte MSG_END_6-MSG_START_6  ; chuckie.basm:359
MSG_START_6:  ; chuckie.basm:359
    .byte $19, (4), <((64)), >((64)), <((380)), >((380))  ; chuckie.basm:360
    .byte "Jump .. "  ; chuckie.basm:361
MSG_END_6:  ; chuckie.basm:362
key_name_tab:  ; chuckie.basm:364
    .byte MSG_END_7-MSG_START_7  ; chuckie.basm:365
MSG_START_7:  ; chuckie.basm:365
    .byte "Tab"  ; chuckie.basm:366
MSG_END_7:  ; chuckie.basm:367
key_name_capslock:  ; chuckie.basm:369
    .byte MSG_END_8-MSG_START_8  ; chuckie.basm:370
MSG_START_8:  ; chuckie.basm:370
    .byte "Caps Lock"  ; chuckie.basm:371
MSG_END_8:  ; chuckie.basm:372
key_name_shiftlock:  ; chuckie.basm:374
    .byte MSG_END_9-MSG_START_9  ; chuckie.basm:375
MSG_START_9:  ; chuckie.basm:375
    .byte "Shift Lock"  ; chuckie.basm:376
MSG_END_9:  ; chuckie.basm:377
key_name_escape:  ; chuckie.basm:379
    .byte MSG_END_10-MSG_START_10  ; chuckie.basm:380
MSG_START_10:  ; chuckie.basm:380
    .byte "Escape"  ; chuckie.basm:381
MSG_END_10:  ; chuckie.basm:382
key_name_space:  ; chuckie.basm:384
    .byte MSG_END_11-MSG_START_11  ; chuckie.basm:385
MSG_START_11:  ; chuckie.basm:385
    .byte "Space"  ; chuckie.basm:386
MSG_END_11:  ; chuckie.basm:387
key_name_delete:  ; chuckie.basm:389
    .byte MSG_END_12-MSG_START_12  ; chuckie.basm:390
MSG_START_12:  ; chuckie.basm:390
    .byte "Delete"  ; chuckie.basm:391
MSG_END_12:  ; chuckie.basm:392
key_name_return:  ; chuckie.basm:394
    .byte MSG_END_13-MSG_START_13  ; chuckie.basm:395
MSG_START_13:  ; chuckie.basm:395
    .byte "Return"  ; chuckie.basm:396
MSG_END_13:  ; chuckie.basm:397
key_name_copy:  ; chuckie.basm:399
    .byte MSG_END_14-MSG_START_14  ; chuckie.basm:400
MSG_START_14:  ; chuckie.basm:400
    .byte "Copy"  ; chuckie.basm:401
MSG_END_14:  ; chuckie.basm:402
key_name_left:  ; chuckie.basm:404
    .byte MSG_END_15-MSG_START_15  ; chuckie.basm:405
MSG_START_15:  ; chuckie.basm:405
    .byte "Left Arrow"  ; chuckie.basm:406
MSG_END_15:  ; chuckie.basm:407
key_name_right:  ; chuckie.basm:409
    .byte MSG_END_16-MSG_START_16  ; chuckie.basm:410
MSG_START_16:  ; chuckie.basm:410
    .byte "Right Arrow"  ; chuckie.basm:411
MSG_END_16:  ; chuckie.basm:412
key_name_down:  ; chuckie.basm:414
    .byte MSG_END_17-MSG_START_17  ; chuckie.basm:415
MSG_START_17:  ; chuckie.basm:415
    .byte "Down Arrow"  ; chuckie.basm:416
MSG_END_17:  ; chuckie.basm:417
key_name_up:  ; chuckie.basm:419
    .byte MSG_END_18-MSG_START_18  ; chuckie.basm:420
MSG_START_18:  ; chuckie.basm:420
    .byte "Up Arrow"  ; chuckie.basm:421
MSG_END_18:  ; chuckie.basm:422
key_name_shift:  ; chuckie.basm:424
    .byte MSG_END_19-MSG_START_19  ; chuckie.basm:425
MSG_START_19:  ; chuckie.basm:425
    .byte "Shift"  ; chuckie.basm:426
MSG_END_19:  ; chuckie.basm:427
key_name_control:  ; chuckie.basm:429
    .byte MSG_END_20-MSG_START_20  ; chuckie.basm:430
MSG_START_20:  ; chuckie.basm:430
    .byte "Control"  ; chuckie.basm:431
MSG_END_20:  ; chuckie.basm:432
draw_key_selection:  ; chuckie.basm:435
    ldx #<((msg_key_display))  ; chuckie.basm:437
    ldy #>((msg_key_display))  ; chuckie.basm:437
    jsr write_counted_string  ; chuckie.basm:438
    lda #osbyte_AC_key_code_to_ascii_table  ; chuckie.basm:439
    ldx #$00  ; chuckie.basm:440
    ldy #$FF  ; chuckie.basm:441
    jsr osbyte  ; chuckie.basm:442
    stx sprite_lo  ; chuckie.basm:443
    sty sprite_hi  ; chuckie.basm:444
    ldx #<((msg_key_up))  ; chuckie.basm:445
    ldy #>((msg_key_up))  ; chuckie.basm:445
    jsr write_counted_string  ; chuckie.basm:446
    lda key_up  ; chuckie.basm:447
    jsr draw_key_name  ; chuckie.basm:448
    ldx #<((msg_key_down))  ; chuckie.basm:449
    ldy #>((msg_key_down))  ; chuckie.basm:449
    jsr write_counted_string  ; chuckie.basm:450
    lda key_down  ; chuckie.basm:451
    jsr draw_key_name  ; chuckie.basm:452
    ldx #<((msg_key_left))  ; chuckie.basm:453
    ldy #>((msg_key_left))  ; chuckie.basm:453
    jsr write_counted_string  ; chuckie.basm:454
    lda key_left  ; chuckie.basm:455
    jsr draw_key_name  ; chuckie.basm:456
    ldx #<((msg_key_right))  ; chuckie.basm:457
    ldy #>((msg_key_right))  ; chuckie.basm:457
    jsr write_counted_string  ; chuckie.basm:458
    lda key_right  ; chuckie.basm:459
    jsr draw_key_name  ; chuckie.basm:460
    ldx #<((msg_key_jump))  ; chuckie.basm:461
    ldy #>((msg_key_jump))  ; chuckie.basm:461
    jsr write_counted_string  ; chuckie.basm:462
    lda key_jump  ; chuckie.basm:463
    jsr draw_key_name  ; chuckie.basm:464
    ldx #<((msg_standard_keys))  ; chuckie.basm:465
    ldy #>((msg_standard_keys))  ; chuckie.basm:465
    jsr write_counted_string  ; chuckie.basm:466
    rts   ; chuckie.basm:467
draw_key_name:  ; chuckie.basm:468
    eor #$FF  ; chuckie.basm:469
    tax   ; chuckie.basm:470
    sta param  ; chuckie.basm:471
    jmp draw_key_name_impl  ; chuckie.basm:472
msg_key_display:  ; chuckie.basm:473
    .byte MSG_END_21-MSG_START_21  ; chuckie.basm:474
MSG_START_21:  ; chuckie.basm:474
    .byte $19, (4), <((512)), >((512)), <((800)), >((800))  ; chuckie.basm:475
    .byte $12, (0), (4)  ; chuckie.basm:476
    .byte "KEYS"  ; chuckie.basm:477
    .byte $12, (0), (8)  ; chuckie.basm:478
MSG_END_21:  ; chuckie.basm:479
msg_standard_keys:  ; chuckie.basm:481
    .byte MSG_END_22-MSG_START_22  ; chuckie.basm:482
MSG_START_22:  ; chuckie.basm:482
    .byte $12, (0), (2)  ; chuckie.basm:483
    .byte $19, (4), <((64)), >((64)), <((280)), >((280))  ; chuckie.basm:484
    .byte "Hold .. 'H'"  ; chuckie.basm:485
    .byte $19, (4), <((0)), >((0)), <((200)), >((200))  ; chuckie.basm:486
    .byte "Abort .. Escape +'H'"  ; chuckie.basm:487
MSG_END_22:  ; chuckie.basm:488
harry_motion_noises:  ; chuckie.basm:492
    lda harry_dx  ; chuckie.basm:494
    ora harry_dy  ; chuckie.basm:495
    bne harry_moving  ; chuckie.basm:496
    rts   ; chuckie.basm:497
harry_moving:  ; chuckie.basm:498
    lda birds_timer_cycle  ; chuckie.basm:499
    and #$01  ; chuckie.basm:500
    beq even_tick  ; chuckie.basm:501
    rts   ; chuckie.basm:502
even_tick:  ; chuckie.basm:503
    lda harry_state  ; chuckie.basm:504
    bne harry_not_on_ground  ; chuckie.basm:505
    lda #$64  ; chuckie.basm:506
    jmp play_sound1  ; chuckie.basm:507
harry_not_on_ground:  ; chuckie.basm:508
    cmp #$01  ; chuckie.basm:509
    bne harry_not_on_ladder_1  ; chuckie.basm:510
    lda #$96  ; chuckie.basm:511
    jmp play_sound1  ; chuckie.basm:512
harry_not_on_ladder_1:  ; chuckie.basm:513
    cmp #$02  ; chuckie.basm:514
    bne harry_not_jumping  ; chuckie.basm:515
    lda harry_fall_scaled_vy  ; chuckie.basm:516
    cmp #$0B  ; chuckie.basm:517
    bcc harry_jumping_upwards  ; chuckie.basm:518
    lda #$BE  ; chuckie.basm:519
    sec   ; chuckie.basm:520
    sbc harry_fall_scaled_vy  ; chuckie.basm:521
    sbc harry_fall_scaled_vy  ; chuckie.basm:522
    jmp play_sound1  ; chuckie.basm:523
harry_jumping_upwards:  ; chuckie.basm:524
    lda #$96  ; chuckie.basm:525
    clc   ; chuckie.basm:526
    adc harry_fall_scaled_vy  ; chuckie.basm:527
    adc harry_fall_scaled_vy  ; chuckie.basm:528
    jmp play_sound1  ; chuckie.basm:529
harry_not_jumping:  ; chuckie.basm:530
    cmp #$03  ; chuckie.basm:531
    bne harry_not_falling  ; chuckie.basm:532
    lda #$6E  ; chuckie.basm:533
    sec   ; chuckie.basm:534
    sbc harry_fall_scaled_vy  ; chuckie.basm:535
    sbc harry_fall_scaled_vy  ; chuckie.basm:536
    jmp play_sound1  ; chuckie.basm:537
harry_not_falling:  ; chuckie.basm:538
    lda harry_dx  ; chuckie.basm:539
    bne harry_moving_on_lift  ; chuckie.basm:540
    rts   ; chuckie.basm:541
harry_moving_on_lift:  ; chuckie.basm:542
    lda #$64  ; chuckie.basm:543
play_sound1:  ; chuckie.basm:544
    sta sound1_pitch  ; chuckie.basm:545
    ldx #<((sound1))  ; chuckie.basm:546
    ldy #>((sound1))  ; chuckie.basm:546
    lda #osword_7_play_sound  ; chuckie.basm:547
    jsr osword  ; chuckie.basm:548
    rts   ; chuckie.basm:549
sound1:  ; chuckie.basm:550
    .byte $13  ; chuckie.basm:551
    .byte $00  ; chuckie.basm:552
    .byte $01  ; chuckie.basm:553
    .byte $00  ; chuckie.basm:554
sound1_pitch:  ; chuckie.basm:555
    .byte $00  ; chuckie.basm:556
    .byte $00  ; chuckie.basm:557
    .byte $01  ; chuckie.basm:558
    .byte $00  ; chuckie.basm:559
sound2:  ; chuckie.basm:561
    .byte $03  ; chuckie.basm:562
    .byte $00  ; chuckie.basm:563
    .byte $02  ; chuckie.basm:564
    .byte $00  ; chuckie.basm:565
sound2_pitch:  ; chuckie.basm:566
    .byte "x"  ; chuckie.basm:567
    .byte $00  ; chuckie.basm:568
sound2_duration:  ; chuckie.basm:569
    .byte $1E  ; chuckie.basm:570
    .byte $00  ; chuckie.basm:571
sound3:  ; chuckie.basm:572
    .byte $10  ; chuckie.basm:573
    .byte $00  ; chuckie.basm:574
    .byte $03  ; chuckie.basm:575
    .byte $00  ; chuckie.basm:576
sound3_pitch:  ; chuckie.basm:577
    .byte $00  ; chuckie.basm:578
    .byte $00  ; chuckie.basm:579
    .byte $04  ; chuckie.basm:580
    .byte $00  ; chuckie.basm:581
sound4:  ; chuckie.basm:582
    .byte $10  ; chuckie.basm:583
    .byte $00  ; chuckie.basm:584
    .byte $01  ; chuckie.basm:585
    .byte $00  ; chuckie.basm:586
    .byte $04  ; chuckie.basm:587
    .byte $00  ; chuckie.basm:588
    .byte $01  ; chuckie.basm:589
    .byte $00  ; chuckie.basm:590
    .byte $00  ; chuckie.basm:591
    .byte $00  ; chuckie.basm:592
    .byte $00  ; chuckie.basm:593
    .byte $00  ; chuckie.basm:594
    .byte $00  ; chuckie.basm:595
    .byte $00  ; chuckie.basm:596
    .byte $00  ; chuckie.basm:597
    .byte $00  ; chuckie.basm:598
scenario_lookup_table:  ; scenes.basm:1
    .word scenario_0  ; scenes.basm:2
    .word scenario_1  ; scenes.basm:3
    .word scenario_2  ; scenes.basm:4
    .word scenario_3  ; scenes.basm:5
    .word scenario_4  ; scenes.basm:6
    .word scenario_5  ; scenes.basm:7
    .word scenario_6  ; scenes.basm:8
    .word scenario_7  ; scenes.basm:9
scenario_0:  ; scenes.basm:10
    .byte (ladders_1-walls_1)/3,(lift_1-ladders_1)/3,eggs_1-lift_1,(chickens_1-grain_1)/2,2  ; scenes.basm:12
walls_1:  ; scenes.basm:13
    .byte 1, 0, 19  ; scenes.basm:14
    .byte 6, 1, 18  ; scenes.basm:15
    .byte 11, 2, 8  ; scenes.basm:16
    .byte 11, 14, 18  ; scenes.basm:17
    .byte 12, 9, 10  ; scenes.basm:18
    .byte 13, 11, 12  ; scenes.basm:19
    .byte 14, 13, 14  ; scenes.basm:20
    .byte 15, 15, 16  ; scenes.basm:21
    .byte 16, 3, 7  ; scenes.basm:22
    .byte 17, 9, 11  ; scenes.basm:23
    .byte 21, 5, 9  ; scenes.basm:24
    .byte 21, 11, 16  ; scenes.basm:25
    .byte 21, 18, 19  ; scenes.basm:26
ladders_1:  ; scenes.basm:27
    .byte 3, 7, 13  ; scenes.basm:28
    .byte 7, 2, 23  ; scenes.basm:29
    .byte 11, 2, 8  ; scenes.basm:30
    .byte 16, 2, 8  ; scenes.basm:31
lift_1:  ; scenes.basm:32
eggs_1:  ; scenes.basm:33
    .byte 4, 2  ; scenes.basm:34
    .byte 1, 7  ; scenes.basm:35
    .byte 13, 7  ; scenes.basm:36
    .byte 18, 7  ; scenes.basm:37
    .byte 2, 12  ; scenes.basm:38
    .byte 10, 13  ; scenes.basm:39
    .byte 17, 12  ; scenes.basm:40
    .byte 4, 17  ; scenes.basm:41
    .byte 10, 18  ; scenes.basm:42
    .byte 6, 22  ; scenes.basm:43
    .byte 13, 22  ; scenes.basm:44
    .byte 19, 22  ; scenes.basm:45
grain_1:  ; scenes.basm:46
    .byte 2, 2  ; scenes.basm:47
    .byte 13, 2  ; scenes.basm:48
    .byte 5, 7  ; scenes.basm:49
    .byte 14, 7  ; scenes.basm:50
    .byte 5, 12  ; scenes.basm:51
    .byte 15, 12  ; scenes.basm:52
    .byte 16, 16  ; scenes.basm:53
    .byte 11, 18  ; scenes.basm:54
    .byte 9, 22  ; scenes.basm:55
    .byte 14, 22  ; scenes.basm:56
chickens_1:  ; scenes.basm:57
    .byte 5, 17  ; scenes.basm:58
    .byte 8, 22  ; scenes.basm:59
    .byte 4, 12  ; scenes.basm:60
    .byte 6, 7  ; scenes.basm:61
    .byte 12, 2  ; scenes.basm:62
scenario_1:  ; scenes.basm:64
    .byte (ladders_2-walls_2)/3,(lift_2-ladders_2)/3,eggs_2-lift_2,(chickens_2-grain_2)/2,3  ; scenes.basm:66
walls_2:  ; scenes.basm:67
    .byte 1, 0, 3  ; scenes.basm:68
    .byte 1, 5, 19  ; scenes.basm:69
    .byte 6, 0, 6  ; scenes.basm:70
    .byte 6, 8, 10  ; scenes.basm:71
    .byte 6, 12, 14  ; scenes.basm:72
    .byte 6, 16, 19  ; scenes.basm:73
    .byte 11, 0, 3  ; scenes.basm:74
    .byte 11, 5, 14  ; scenes.basm:75
    .byte 11, 16, 19  ; scenes.basm:76
    .byte 16, 0, 10  ; scenes.basm:77
    .byte 16, 12, 19  ; scenes.basm:78
    .byte 21, 4, 10  ; scenes.basm:79
    .byte 21, 12, 19  ; scenes.basm:80
ladders_2:  ; scenes.basm:81
    .byte 2, 2, 18  ; scenes.basm:82
    .byte 4, 17, 23  ; scenes.basm:83
    .byte 6, 7, 18  ; scenes.basm:84
    .byte 9, 2, 8  ; scenes.basm:85
    .byte 9, 12, 23  ; scenes.basm:86
    .byte 13, 12, 18  ; scenes.basm:87
    .byte 17, 2, 13  ; scenes.basm:88
    .byte 17, 17, 23  ; scenes.basm:89
lift_2:  ; scenes.basm:90
eggs_2:  ; scenes.basm:91
    .byte 5, 2  ; scenes.basm:92
    .byte 12, 2  ; scenes.basm:93
    .byte 0, 7  ; scenes.basm:94
    .byte 4, 7  ; scenes.basm:95
    .byte 13, 7  ; scenes.basm:96
    .byte 0, 12  ; scenes.basm:97
    .byte 7, 12  ; scenes.basm:98
    .byte 19, 12  ; scenes.basm:99
    .byte 7, 17  ; scenes.basm:100
    .byte 7, 22  ; scenes.basm:101
    .byte 15, 22  ; scenes.basm:102
    .byte 19, 22  ; scenes.basm:103
grain_2:  ; scenes.basm:104
    .byte 0, 2  ; scenes.basm:105
    .byte 3, 2  ; scenes.basm:106
    .byte 15, 2  ; scenes.basm:107
    .byte 16, 7  ; scenes.basm:108
    .byte 0, 17  ; scenes.basm:109
    .byte 10, 17  ; scenes.basm:110
    .byte 12, 22  ; scenes.basm:111
chickens_2:  ; scenes.basm:112
    .byte 6, 22  ; scenes.basm:113
    .byte 1, 2  ; scenes.basm:114
    .byte 18, 12  ; scenes.basm:115
    .byte 11, 12  ; scenes.basm:116
    .byte 13, 22  ; scenes.basm:117
scenario_2:  ; scenes.basm:119
    .byte (ladders_3-walls_3)/3,(lift_3-ladders_3)/3,eggs_3-lift_3,(chickens_3-grain_3)/2,3  ; scenes.basm:121
walls_3:  ; scenes.basm:122
    .byte 1, 0, 2  ; scenes.basm:123
    .byte 2, 3, 4  ; scenes.basm:124
    .byte 1, 7, 9  ; scenes.basm:125
    .byte 1, 11, 19  ; scenes.basm:126
    .byte 5, 15, 18  ; scenes.basm:127
    .byte 10, 0, 4  ; scenes.basm:128
    .byte 15, 0, 3  ; scenes.basm:129
    .byte 19, 3, 4  ; scenes.basm:130
    .byte 6, 7, 10  ; scenes.basm:131
    .byte 6, 12, 12  ; scenes.basm:132
    .byte 7, 14, 14  ; scenes.basm:133
    .byte 8, 15, 15  ; scenes.basm:134
    .byte 9, 17, 17  ; scenes.basm:135
    .byte 10, 18, 19  ; scenes.basm:136
    .byte 12, 12, 13  ; scenes.basm:137
    .byte 12, 15, 15  ; scenes.basm:138
    .byte 15, 18, 19  ; scenes.basm:139
    .byte 16, 17, 17  ; scenes.basm:140
    .byte 17, 15, 15  ; scenes.basm:141
    .byte 18, 12, 13  ; scenes.basm:142
    .byte 19, 7, 11  ; scenes.basm:143
    .byte 21, 13, 15  ; scenes.basm:144
    .byte 20, 16, 16  ; scenes.basm:145
    .byte 20, 18, 19  ; scenes.basm:146
ladders_3:  ; scenes.basm:147
    .byte 1, 2, 12  ; scenes.basm:148
    .byte 3, 11, 21  ; scenes.basm:149
    .byte 8, 7, 21  ; scenes.basm:150
    .byte 10, 7, 21  ; scenes.basm:151
    .byte 13, 19, 23  ; scenes.basm:152
    .byte 18, 2, 7  ; scenes.basm:153
    .byte 19, 11, 17  ; scenes.basm:154
lift_3:  ; scenes.basm:155
    .byte 5  ; scenes.basm:156
eggs_3:  ; scenes.basm:157
    .byte 4, 3  ; scenes.basm:158
    .byte 15, 2  ; scenes.basm:159
    .byte 16, 6  ; scenes.basm:160
    .byte 4, 11  ; scenes.basm:161
    .byte 4, 20  ; scenes.basm:162
    .byte 9, 7  ; scenes.basm:163
    .byte 15, 9  ; scenes.basm:164
    .byte 15, 13  ; scenes.basm:165
    .byte 1, 16  ; scenes.basm:166
    .byte 17, 17  ; scenes.basm:167
    .byte 19, 18  ; scenes.basm:168
    .byte 19, 21  ; scenes.basm:169
grain_3:  ; scenes.basm:170
    .byte 2, 2  ; scenes.basm:171
    .byte 2, 11  ; scenes.basm:172
    .byte 7, 7  ; scenes.basm:173
    .byte 7, 20  ; scenes.basm:174
    .byte 0, 16  ; scenes.basm:175
    .byte 13, 2  ; scenes.basm:176
    .byte 12, 19  ; scenes.basm:177
    .byte 15, 18  ; scenes.basm:178
    .byte 13, 13  ; scenes.basm:179
    .byte 18, 21  ; scenes.basm:180
chickens_3:  ; scenes.basm:181
    .byte 2, 16  ; scenes.basm:182
    .byte 9, 20  ; scenes.basm:183
    .byte 17, 6  ; scenes.basm:184
    .byte 0, 2  ; scenes.basm:185
    .byte 8, 7  ; scenes.basm:186
scenario_3:  ; scenes.basm:188
    .byte (ladders_4-walls_4)/3,(lift_4-ladders_4)/3,eggs_4-lift_4,(chickens_4-grain_4)/2,4  ; scenes.basm:190
walls_4:  ; scenes.basm:191
    .byte 1, 0, 4  ; scenes.basm:192
    .byte 1, 6, 10  ; scenes.basm:193
    .byte 1, 13, 19  ; scenes.basm:194
    .byte 6, 0, 4  ; scenes.basm:195
    .byte 6, 7, 10  ; scenes.basm:196
    .byte 6, 13, 17  ; scenes.basm:197
    .byte 5, 19, 19  ; scenes.basm:198
    .byte 12, 0, 1  ; scenes.basm:199
    .byte 13, 3, 3  ; scenes.basm:200
    .byte 14, 5, 5  ; scenes.basm:201
    .byte 15, 7, 8  ; scenes.basm:202
    .byte 11, 7, 8  ; scenes.basm:203
    .byte 11, 13, 16  ; scenes.basm:204
    .byte 10, 18, 19  ; scenes.basm:205
    .byte 16, 8, 10  ; scenes.basm:206
    .byte 17, 0, 0  ; scenes.basm:207
    .byte 18, 2, 2  ; scenes.basm:208
    .byte 19, 3, 3  ; scenes.basm:209
    .byte 20, 4, 4  ; scenes.basm:210
    .byte 21, 5, 5  ; scenes.basm:211
    .byte 21, 7, 10  ; scenes.basm:212
    .byte 16, 13, 14  ; scenes.basm:213
    .byte 16, 16, 16  ; scenes.basm:214
    .byte 16, 18, 19  ; scenes.basm:215
    .byte 21, 13, 15  ; scenes.basm:216
    .byte 21, 17, 19  ; scenes.basm:217
ladders_4:  ; scenes.basm:218
    .byte 3, 2, 8  ; scenes.basm:219
    .byte 8, 2, 23  ; scenes.basm:220
    .byte 14, 12, 23  ; scenes.basm:221
    .byte 15, 2, 8  ; scenes.basm:222
    .byte 19, 16, 23  ; scenes.basm:223
lift_4:  ; scenes.basm:224
    .byte 11  ; scenes.basm:225
eggs_4:  ; scenes.basm:226
    .byte 0, 2  ; scenes.basm:227
    .byte 0, 13  ; scenes.basm:228
    .byte 0, 18  ; scenes.basm:229
    .byte 7, 7  ; scenes.basm:230
    .byte 9, 17  ; scenes.basm:231
    .byte 13, 2  ; scenes.basm:232
    .byte 16, 7  ; scenes.basm:233
    .byte 13, 12  ; scenes.basm:234
    .byte 19, 11  ; scenes.basm:235
    .byte 17, 16  ; scenes.basm:236
    .byte 16, 21  ; scenes.basm:237
    .byte 16, 24  ; scenes.basm:238
grain_4:  ; scenes.basm:239
    .byte 0, 7  ; scenes.basm:240
    .byte 10, 2  ; scenes.basm:241
    .byte 18, 2  ; scenes.basm:242
    .byte 5, 15  ; scenes.basm:243
    .byte 9, 22  ; scenes.basm:244
    .byte 13, 22  ; scenes.basm:245
chickens_4:  ; scenes.basm:246
    .byte 10, 22  ; scenes.basm:247
    .byte 17, 22  ; scenes.basm:248
    .byte 17, 2  ; scenes.basm:249
    .byte 4, 2  ; scenes.basm:250
    .byte 10, 7  ; scenes.basm:251
scenario_4:  ; scenes.basm:253
    .byte (ladders_5-walls_5)/3,(lift_5-ladders_5)/3,eggs_5-lift_5,(chickens_5-grain_5)/2,4  ; scenes.basm:255
walls_5:  ; scenes.basm:256
    .byte 1, 0, 1  ; scenes.basm:257
    .byte 1, 3, 11  ; scenes.basm:258
    .byte 1, 13, 15  ; scenes.basm:259
    .byte 1, 18, 19  ; scenes.basm:260
    .byte 6, 0, 5  ; scenes.basm:261
    .byte 6, 9, 12  ; scenes.basm:262
    .byte 6, 14, 15  ; scenes.basm:263
    .byte 11, 0, 5  ; scenes.basm:264
    .byte 11, 10, 15  ; scenes.basm:265
    .byte 11, 19, 19  ; scenes.basm:266
    .byte 16, 0, 5  ; scenes.basm:267
    .byte 21, 3, 7  ; scenes.basm:268
    .byte 20, 9, 9  ; scenes.basm:269
    .byte 19, 11, 13  ; scenes.basm:270
    .byte 18, 14, 14  ; scenes.basm:271
    .byte 22, 12, 15  ; scenes.basm:272
    .byte 21, 18, 19  ; scenes.basm:273
ladders_5:  ; scenes.basm:274
    .byte 3, 2, 8  ; scenes.basm:275
    .byte 2, 12, 18  ; scenes.basm:276
    .byte 4, 12, 23  ; scenes.basm:277
    .byte 7, 2, 7  ; scenes.basm:278
    .byte 7, 10, 17  ; scenes.basm:279
    .byte 10, 2, 8  ; scenes.basm:280
    .byte 12, 7, 13  ; scenes.basm:281
    .byte 12, 20, 24  ; scenes.basm:282
    .byte 14, 2, 8  ; scenes.basm:283
lift_5:  ; scenes.basm:284
    .byte 16  ; scenes.basm:285
eggs_5:  ; scenes.basm:286
    .byte 0, 2  ; scenes.basm:287
    .byte 0, 7  ; scenes.basm:288
    .byte 0, 12  ; scenes.basm:289
    .byte 0, 17  ; scenes.basm:290
    .byte 5, 7  ; scenes.basm:291
    .byte 5, 22  ; scenes.basm:292
    .byte 9, 11  ; scenes.basm:293
    .byte 13, 6  ; scenes.basm:294
    .byte 11, 20  ; scenes.basm:295
    .byte 13, 23  ; scenes.basm:296
    .byte 19, 12  ; scenes.basm:297
    .byte 19, 22  ; scenes.basm:298
grain_5:  ; scenes.basm:299
    .byte 4, 2  ; scenes.basm:300
    .byte 5, 2  ; scenes.basm:301
    .byte 6, 2  ; scenes.basm:302
    .byte 13, 2  ; scenes.basm:303
    .byte 15, 2  ; scenes.basm:304
    .byte 18, 2  ; scenes.basm:305
    .byte 10, 12  ; scenes.basm:306
    .byte 15, 12  ; scenes.basm:307
    .byte 3, 22  ; scenes.basm:308
    .byte 6, 22  ; scenes.basm:309
    .byte 7, 22  ; scenes.basm:310
    .byte 15, 23  ; scenes.basm:311
    .byte 18, 22  ; scenes.basm:312
chickens_5:  ; scenes.basm:313
    .byte 1, 7  ; scenes.basm:314
    .byte 3, 12  ; scenes.basm:315
    .byte 1, 17  ; scenes.basm:316
    .byte 14, 12  ; scenes.basm:317
    .byte 15, 7  ; scenes.basm:318
scenario_5:  ; scenes.basm:320
    .byte (ladders_6-walls_6)/3,(lift_6-ladders_6)/3,eggs_6-lift_6,(chickens_6-grain_6)/2,4  ; scenes.basm:322
walls_6:  ; scenes.basm:323
    .byte 1, 0, 2  ; scenes.basm:324
    .byte 1, 6, 8  ; scenes.basm:325
    .byte 1, 11, 14  ; scenes.basm:326
    .byte 6, 0, 1  ; scenes.basm:327
    .byte 6, 3, 5  ; scenes.basm:328
    .byte 6, 12, 14  ; scenes.basm:329
    .byte 11, 2, 7  ; scenes.basm:330
    .byte 11, 12, 17  ; scenes.basm:331
    .byte 10, 17, 19  ; scenes.basm:332
    .byte 16, 0, 5  ; scenes.basm:333
    .byte 16, 16, 19  ; scenes.basm:334
    .byte 21, 6, 6  ; scenes.basm:335
    .byte 21, 8, 8  ; scenes.basm:336
    .byte 20, 12, 17  ; scenes.basm:337
    .byte 22, 17, 19  ; scenes.basm:338
    .byte 2, 17, 17  ; scenes.basm:339
ladders_6:  ; scenes.basm:340
    .byte 0, 2, 8  ; scenes.basm:341
    .byte 4, 4, 18  ; scenes.basm:342
    .byte 14, 7, 13  ; scenes.basm:343
    .byte 14, 19, 23  ; scenes.basm:344
    .byte 17, 2, 13  ; scenes.basm:345
    .byte 17, 16, 24  ; scenes.basm:346
lift_6:  ; scenes.basm:347
    .byte 9  ; scenes.basm:348
eggs_6:  ; scenes.basm:349
    .byte 2, 2  ; scenes.basm:350
    .byte 16, 2  ; scenes.basm:351
    .byte 5, 7  ; scenes.basm:352
    .byte 12, 7  ; scenes.basm:353
    .byte 12, 12  ; scenes.basm:354
    .byte 16, 12  ; scenes.basm:355
    .byte 7, 17  ; scenes.basm:356
    .byte 3, 21  ; scenes.basm:357
    .byte 6, 22  ; scenes.basm:358
    .byte 12, 21  ; scenes.basm:359
    .byte 19, 17  ; scenes.basm:360
    .byte 19, 23  ; scenes.basm:361
grain_6:  ; scenes.basm:362
    .byte 11, 2  ; scenes.basm:363
    .byte 12, 2  ; scenes.basm:364
    .byte 13, 2  ; scenes.basm:365
    .byte 14, 2  ; scenes.basm:366
    .byte 0, 17  ; scenes.basm:367
    .byte 2, 17  ; scenes.basm:368
    .byte 3, 17  ; scenes.basm:369
    .byte 7, 12  ; scenes.basm:370
    .byte 19, 11  ; scenes.basm:371
chickens_6:  ; scenes.basm:372
    .byte 1, 17  ; scenes.basm:373
    .byte 1, 2  ; scenes.basm:374
    .byte 18, 17  ; scenes.basm:375
    .byte 13, 7  ; scenes.basm:376
    .byte 18, 11  ; scenes.basm:377
scenario_6:  ; scenes.basm:379
    .byte (ladders_7-walls_7)/3,(lift_7-ladders_7)/3,eggs_7-lift_7,(chickens_7-grain_7)/2,3  ; scenes.basm:381
walls_7:  ; scenes.basm:382
    .byte 21, 11, 16  ; scenes.basm:383
    .byte 16, 0, 4  ; scenes.basm:384
    .byte 16, 6, 7  ; scenes.basm:385
    .byte 11, 0, 2  ; scenes.basm:386
    .byte 6, 1, 3  ; scenes.basm:387
    .byte 4, 0, 1  ; scenes.basm:388
    .byte 1, 3, 4  ; scenes.basm:389
    .byte 2, 5, 6  ; scenes.basm:390
    .byte 1, 7, 8  ; scenes.basm:391
    .byte 2, 9, 9  ; scenes.basm:392
    .byte 3, 9, 9  ; scenes.basm:393
    .byte 3, 12, 12  ; scenes.basm:394
    .byte 8, 5, 8  ; scenes.basm:395
    .byte 9, 5, 5  ; scenes.basm:396
    .byte 10, 5, 5  ; scenes.basm:397
    .byte 11, 5, 5  ; scenes.basm:398
    .byte 12, 5, 5  ; scenes.basm:399
    .byte 11, 8, 8  ; scenes.basm:400
    .byte 12, 8, 8  ; scenes.basm:401
    .byte 15, 12, 15  ; scenes.basm:402
    .byte 11, 10, 11  ; scenes.basm:403
    .byte 9, 14, 16  ; scenes.basm:404
    .byte 2, 15, 16  ; scenes.basm:405
ladders_7:  ; scenes.basm:406
    .byte 1, 2, 18  ; scenes.basm:407
    .byte 3, 2, 8  ; scenes.basm:408
    .byte 5, 20, 24  ; scenes.basm:409
    .byte 7, 20, 24  ; scenes.basm:410
    .byte 9, 20, 24  ; scenes.basm:411
    .byte 13, 16, 23  ; scenes.basm:412
    .byte 15, 10, 17  ; scenes.basm:413
lift_7:  ; scenes.basm:414
    .byte 18  ; scenes.basm:415
eggs_7:  ; scenes.basm:416
    .byte 6, 23  ; scenes.basm:417
    .byte 8, 23  ; scenes.basm:418
    .byte 10, 23  ; scenes.basm:419
    .byte 15, 22  ; scenes.basm:420
    .byte 7, 17  ; scenes.basm:421
    .byte 2, 3  ; scenes.basm:422
    .byte 7, 9  ; scenes.basm:423
    .byte 11, 12  ; scenes.basm:424
    .byte 16, 15  ; scenes.basm:425
    .byte 16, 10  ; scenes.basm:426
    .byte 12, 4  ; scenes.basm:427
    .byte 17, 2  ; scenes.basm:428
grain_7:  ; scenes.basm:429
    .byte 2, 7  ; scenes.basm:430
    .byte 3, 17  ; scenes.basm:431
    .byte 8, 9  ; scenes.basm:432
    .byte 12, 22  ; scenes.basm:433
chickens_7:  ; scenes.basm:434
    .byte 13, 22  ; scenes.basm:435
    .byte 1, 17  ; scenes.basm:436
    .byte 14, 10  ; scenes.basm:437
    .byte 0, 5  ; scenes.basm:438
    .byte 2, 12  ; scenes.basm:439
scenario_7:  ; scenes.basm:441
    .byte (ladders_8-walls_8)/3,(lift_8-ladders_8)/3,eggs_8-lift_8,(chickens_8-grain_8)/2,3  ; scenes.basm:443
walls_8:  ; scenes.basm:444
    .byte 1, 0, 19  ; scenes.basm:445
    .byte 6, 2, 4  ; scenes.basm:446
    .byte 6, 7, 13  ; scenes.basm:447
    .byte 6, 16, 18  ; scenes.basm:448
    .byte 11, 2, 5  ; scenes.basm:449
    .byte 11, 8, 12  ; scenes.basm:450
    .byte 11, 15, 18  ; scenes.basm:451
    .byte 16, 3, 6  ; scenes.basm:452
    .byte 16, 9, 11  ; scenes.basm:453
    .byte 16, 14, 17  ; scenes.basm:454
    .byte 21, 3, 3  ; scenes.basm:455
    .byte 21, 6, 6  ; scenes.basm:456
    .byte 21, 8, 12  ; scenes.basm:457
    .byte 21, 14, 14  ; scenes.basm:458
    .byte 21, 17, 17  ; scenes.basm:459
ladders_8:  ; scenes.basm:460
    .byte 3, 2, 8  ; scenes.basm:461
    .byte 17, 2, 8  ; scenes.basm:462
    .byte 10, 7, 13  ; scenes.basm:463
    .byte 4, 12, 18  ; scenes.basm:464
    .byte 16, 12, 18  ; scenes.basm:465
    .byte 10, 17, 23  ; scenes.basm:466
lift_8:  ; scenes.basm:467
eggs_8:  ; scenes.basm:468
    .byte 5, 6  ; scenes.basm:469
    .byte 15, 6  ; scenes.basm:470
    .byte 6, 11  ; scenes.basm:471
    .byte 14, 11  ; scenes.basm:472
    .byte 8, 16  ; scenes.basm:473
    .byte 12, 16  ; scenes.basm:474
    .byte 5, 21  ; scenes.basm:475
    .byte 15, 21  ; scenes.basm:476
    .byte 7, 21  ; scenes.basm:477
    .byte 13, 21  ; scenes.basm:478
    .byte 3, 24  ; scenes.basm:479
    .byte 17, 24  ; scenes.basm:480
grain_8:  ; scenes.basm:481
    .byte 1, 2  ; scenes.basm:482
    .byte 2, 2  ; scenes.basm:483
    .byte 4, 2  ; scenes.basm:484
    .byte 5, 2  ; scenes.basm:485
    .byte 6, 2  ; scenes.basm:486
    .byte 8, 2  ; scenes.basm:487
    .byte 9, 2  ; scenes.basm:488
    .byte 10, 2  ; scenes.basm:489
    .byte 11, 2  ; scenes.basm:490
    .byte 12, 2  ; scenes.basm:491
    .byte 13, 2  ; scenes.basm:492
    .byte 14, 2  ; scenes.basm:493
    .byte 15, 2  ; scenes.basm:494
    .byte 16, 2  ; scenes.basm:495
    .byte 18, 2  ; scenes.basm:496
    .byte 19, 2  ; scenes.basm:497
chickens_8:  ; scenes.basm:498
    .byte 17, 2  ; scenes.basm:499
    .byte 10, 12  ; scenes.basm:500
    .byte 10, 22  ; scenes.basm:501
    .byte 3, 17  ; scenes.basm:502
    .byte 17, 17  ; scenes.basm:503
    .byte $55, $42, $28, $34, $29, $3A, $20, $45  ; scenes.basm:506
sprite_lookup_table:  ; sprites.basm:1
    .byte (150), (24)  ; sprites.basm:2
    .word ($3600)  ; sprites.basm:2
    .byte (8), (8)  ; sprites.basm:3
    .word (bmp_1)  ; sprites.basm:3
    .byte (8), (8)  ; sprites.basm:4
    .word (bmp_2)  ; sprites.basm:4
    .byte (8), (8)  ; sprites.basm:5
    .word (bmp_3)  ; sprites.basm:5
    .byte (8), (8)  ; sprites.basm:6
    .word (bmp_4)  ; sprites.basm:6
    .byte (16), (4)  ; sprites.basm:7
    .word (bmp_5)  ; sprites.basm:7
    .byte (8), (16)  ; sprites.basm:8
    .word (bmp_6)  ; sprites.basm:8
    .byte (8), (16)  ; sprites.basm:9
    .word (bmp_7)  ; sprites.basm:9
    .byte (8), (16)  ; sprites.basm:10
    .word (bmp_8)  ; sprites.basm:10
    .byte (8), (16)  ; sprites.basm:11
    .word (bmp_9)  ; sprites.basm:11
    .byte (8), (16)  ; sprites.basm:12
    .word (bmp_10)  ; sprites.basm:12
    .byte (8), (16)  ; sprites.basm:13
    .word (bmp_11)  ; sprites.basm:13
    .byte (8), (16)  ; sprites.basm:14
    .word (bmp_12)  ; sprites.basm:14
    .byte (8), (18)  ; sprites.basm:15
    .word (bmp_13)  ; sprites.basm:15
    .byte (8), (18)  ; sprites.basm:16
    .word (bmp_14)  ; sprites.basm:16
    .byte (16), (24)  ; sprites.basm:17
    .word (bmp_15)  ; sprites.basm:17
    .byte (16), (24)  ; sprites.basm:18
    .word (bmp_16)  ; sprites.basm:18
    .byte (16), (24)  ; sprites.basm:19
    .word (bmp_17)  ; sprites.basm:19
    .byte (16), (24)  ; sprites.basm:20
    .word (bmp_18)  ; sprites.basm:20
    .byte (24), (48)  ; sprites.basm:21
    .word (bmp_19)  ; sprites.basm:21
    .byte (24), (48)  ; sprites.basm:22
    .word (bmp_20)  ; sprites.basm:22
    .byte (8), (20)  ; sprites.basm:23
    .word (bmp_21)  ; sprites.basm:23
    .byte (8), (20)  ; sprites.basm:24
    .word (bmp_22)  ; sprites.basm:24
    .byte (8), (20)  ; sprites.basm:25
    .word (bmp_23)  ; sprites.basm:25
    .byte (8), (20)  ; sprites.basm:26
    .word (bmp_24)  ; sprites.basm:26
    .byte (8), (20)  ; sprites.basm:27
    .word (bmp_25)  ; sprites.basm:27
    .byte (8), (22)  ; sprites.basm:28
    .word (bmp_26)  ; sprites.basm:28
    .byte (16), (20)  ; sprites.basm:29
    .word (bmp_27)  ; sprites.basm:29
    .byte (16), (20)  ; sprites.basm:30
    .word (bmp_28)  ; sprites.basm:30
    .byte (16), (20)  ; sprites.basm:31
    .word (bmp_29)  ; sprites.basm:31
    .byte (16), (20)  ; sprites.basm:32
    .word (bmp_30)  ; sprites.basm:32
    .byte (8), (7)  ; sprites.basm:33
    .word (bmp_31)  ; sprites.basm:33
    .byte (8), (7)  ; sprites.basm:34
    .word (bmp_32)  ; sprites.basm:34
    .byte (8), (7)  ; sprites.basm:35
    .word (bmp_33)  ; sprites.basm:35
    .byte (8), (7)  ; sprites.basm:36
    .word (bmp_34)  ; sprites.basm:36
    .byte (8), (7)  ; sprites.basm:37
    .word (bmp_35)  ; sprites.basm:37
    .byte (8), (7)  ; sprites.basm:38
    .word (bmp_36)  ; sprites.basm:38
    .byte (8), (7)  ; sprites.basm:39
    .word (bmp_37)  ; sprites.basm:39
    .byte (8), (7)  ; sprites.basm:40
    .word (bmp_38)  ; sprites.basm:40
    .byte (8), (7)  ; sprites.basm:41
    .word (bmp_39)  ; sprites.basm:41
    .byte (8), (7)  ; sprites.basm:42
    .word (bmp_40)  ; sprites.basm:42
    .byte (24), (9)  ; sprites.basm:43
    .word (bmp_41)  ; sprites.basm:43
    .byte (32), (9)  ; sprites.basm:44
    .word (bmp_42)  ; sprites.basm:44
    .byte (32), (9)  ; sprites.basm:45
    .word (bmp_43)  ; sprites.basm:45
    .byte (40), (9)  ; sprites.basm:46
    .word (bmp_44)  ; sprites.basm:46
    .byte (48), (9)  ; sprites.basm:47
    .word (bmp_45)  ; sprites.basm:47
    .byte (40), (9)  ; sprites.basm:48
    .word (bmp_46)  ; sprites.basm:48
    .byte (8), (3)  ; sprites.basm:49
    .word (bmp_47)  ; sprites.basm:49
    .byte (16), (30)  ; sprites.basm:50
    .word (bmp_48)  ; sprites.basm:50
    .byte (16), (30)  ; sprites.basm:51
    .word (bmp_49)  ; sprites.basm:51
    .byte (16), (30)  ; sprites.basm:52
    .word (bmp_50)  ; sprites.basm:52
    .byte (16), (30)  ; sprites.basm:53
    .word (bmp_51)  ; sprites.basm:53
    .byte (16), (30)  ; sprites.basm:54
    .word (bmp_52)  ; sprites.basm:54
    .byte (16), (30)  ; sprites.basm:55
    .word (bmp_53)  ; sprites.basm:55
    .byte (16), (30)  ; sprites.basm:56
    .word (bmp_54)  ; sprites.basm:56
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:58
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:59
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:60
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:61
    .byte $00, $00, $00, $00  ; sprites.basm:62
bmp_1:  ; sprites.basm:63
    .byte %11111011  ; sprites.basm:64
    .byte %00000000  ; sprites.basm:65
    .byte %10111111  ; sprites.basm:66
    .byte %00000000  ; sprites.basm:67
    .byte %11101111  ; sprites.basm:68
    .byte %00000000  ; sprites.basm:69
    .byte %00000000  ; sprites.basm:70
    .byte %00000000  ; sprites.basm:71
bmp_2:  ; sprites.basm:72
    .byte %01000010  ; sprites.basm:73
    .byte %01000010  ; sprites.basm:74
    .byte %01000010  ; sprites.basm:75
    .byte %01000010  ; sprites.basm:76
    .byte %01111110  ; sprites.basm:77
    .byte %01000010  ; sprites.basm:78
    .byte %01000010  ; sprites.basm:79
    .byte %01000010  ; sprites.basm:80
bmp_3:  ; sprites.basm:81
    .byte %00000000  ; sprites.basm:82
    .byte %00111000  ; sprites.basm:83
    .byte %01101100  ; sprites.basm:84
    .byte %01011110  ; sprites.basm:85
    .byte %01111110  ; sprites.basm:86
    .byte %01111100  ; sprites.basm:87
    .byte %00111000  ; sprites.basm:88
    .byte %00000000  ; sprites.basm:89
bmp_4:  ; sprites.basm:90
    .byte %00000000  ; sprites.basm:91
    .byte %00000000  ; sprites.basm:92
    .byte %00000000  ; sprites.basm:93
    .byte %00001000  ; sprites.basm:94
    .byte %00010100  ; sprites.basm:95
    .byte %00101010  ; sprites.basm:96
    .byte %01010101  ; sprites.basm:97
    .byte %00000000  ; sprites.basm:98
bmp_5:  ; sprites.basm:99
    .byte %00011111, %11111000  ; sprites.basm:100
    .byte %00011111, %11111000  ; sprites.basm:101
    .byte %00011011, %11011000  ; sprites.basm:102
    .byte %00010001, %10001000  ; sprites.basm:103
bmp_6:  ; sprites.basm:104
    .byte %00011000  ; sprites.basm:105
    .byte %00111100  ; sprites.basm:106
    .byte %11111111  ; sprites.basm:107
    .byte %00110100  ; sprites.basm:108
    .byte %00111100  ; sprites.basm:109
    .byte %00010000  ; sprites.basm:110
    .byte %00011000  ; sprites.basm:111
    .byte %00111100  ; sprites.basm:112
    .byte %01101110  ; sprites.basm:113
    .byte %01101110  ; sprites.basm:114
    .byte %01101110  ; sprites.basm:115
    .byte %01101110  ; sprites.basm:116
    .byte %00111100  ; sprites.basm:117
    .byte %00011000  ; sprites.basm:118
    .byte %00010000  ; sprites.basm:119
    .byte %00011000  ; sprites.basm:120
bmp_7:  ; sprites.basm:121
    .byte %00011000  ; sprites.basm:122
    .byte %00111100  ; sprites.basm:123
    .byte %11111111  ; sprites.basm:124
    .byte %00110100  ; sprites.basm:125
    .byte %00111100  ; sprites.basm:126
    .byte %00010000  ; sprites.basm:127
    .byte %00011000  ; sprites.basm:128
    .byte %00111100  ; sprites.basm:129
    .byte %01101110  ; sprites.basm:130
    .byte %01101110  ; sprites.basm:131
    .byte %01110110  ; sprites.basm:132
    .byte %01110110  ; sprites.basm:133
    .byte %00111100  ; sprites.basm:134
    .byte %00111000  ; sprites.basm:135
    .byte %01001010  ; sprites.basm:136
    .byte %00100100  ; sprites.basm:137
bmp_8:  ; sprites.basm:138
    .byte %00011000  ; sprites.basm:139
    .byte %00111100  ; sprites.basm:140
    .byte %11111111  ; sprites.basm:141
    .byte %00110100  ; sprites.basm:142
    .byte %00111100  ; sprites.basm:143
    .byte %00010000  ; sprites.basm:144
    .byte %00011000  ; sprites.basm:145
    .byte %00111100  ; sprites.basm:146
    .byte %01101110  ; sprites.basm:147
    .byte %01101110  ; sprites.basm:148
    .byte %01011110  ; sprites.basm:149
    .byte %01011110  ; sprites.basm:150
    .byte %00111100  ; sprites.basm:151
    .byte %00111000  ; sprites.basm:152
    .byte %01001010  ; sprites.basm:153
    .byte %00100100  ; sprites.basm:154
bmp_9:  ; sprites.basm:155
    .byte %00011000  ; sprites.basm:156
    .byte %00111100  ; sprites.basm:157
    .byte %11111111  ; sprites.basm:158
    .byte %00101100  ; sprites.basm:159
    .byte %00111100  ; sprites.basm:160
    .byte %00001000  ; sprites.basm:161
    .byte %00011000  ; sprites.basm:162
    .byte %00111100  ; sprites.basm:163
    .byte %01110110  ; sprites.basm:164
    .byte %01110110  ; sprites.basm:165
    .byte %01110110  ; sprites.basm:166
    .byte %01110110  ; sprites.basm:167
    .byte %00111100  ; sprites.basm:168
    .byte %00011000  ; sprites.basm:169
    .byte %00001000  ; sprites.basm:170
    .byte %00011000  ; sprites.basm:171
bmp_10:  ; sprites.basm:172
    .byte %00011000  ; sprites.basm:173
    .byte %00111100  ; sprites.basm:174
    .byte %11111111  ; sprites.basm:175
    .byte %00101100  ; sprites.basm:176
    .byte %00111100  ; sprites.basm:177
    .byte %00001000  ; sprites.basm:178
    .byte %00011000  ; sprites.basm:179
    .byte %00111100  ; sprites.basm:180
    .byte %01110110  ; sprites.basm:181
    .byte %01110110  ; sprites.basm:182
    .byte %01101110  ; sprites.basm:183
    .byte %01101110  ; sprites.basm:184
    .byte %00111100  ; sprites.basm:185
    .byte %00011100  ; sprites.basm:186
    .byte %01010010  ; sprites.basm:187
    .byte %00100100  ; sprites.basm:188
bmp_11:  ; sprites.basm:189
    .byte %00011000  ; sprites.basm:190
    .byte %00111100  ; sprites.basm:191
    .byte %11111111  ; sprites.basm:192
    .byte %00101100  ; sprites.basm:193
    .byte %00111100  ; sprites.basm:194
    .byte %00001000  ; sprites.basm:195
    .byte %00011000  ; sprites.basm:196
    .byte %00111100  ; sprites.basm:197
    .byte %01110110  ; sprites.basm:198
    .byte %01110110  ; sprites.basm:199
    .byte %01111010  ; sprites.basm:200
    .byte %01111010  ; sprites.basm:201
    .byte %00111100  ; sprites.basm:202
    .byte %00011100  ; sprites.basm:203
    .byte %01010010  ; sprites.basm:204
    .byte %00100100  ; sprites.basm:205
bmp_12:  ; sprites.basm:206
    .byte %00011000  ; sprites.basm:207
    .byte %00111100  ; sprites.basm:208
    .byte %11111111  ; sprites.basm:209
    .byte %00111100  ; sprites.basm:210
    .byte %00111100  ; sprites.basm:211
    .byte %00011000  ; sprites.basm:212
    .byte %00011000  ; sprites.basm:213
    .byte %10111101  ; sprites.basm:214
    .byte %11111111  ; sprites.basm:215
    .byte %01111110  ; sprites.basm:216
    .byte %01111110  ; sprites.basm:217
    .byte %01111110  ; sprites.basm:218
    .byte %00111100  ; sprites.basm:219
    .byte %00100100  ; sprites.basm:220
    .byte %00100100  ; sprites.basm:221
    .byte %01100110  ; sprites.basm:222
bmp_13:  ; sprites.basm:223
    .byte %00011000  ; sprites.basm:224
    .byte %00111100  ; sprites.basm:225
    .byte %11111111  ; sprites.basm:226
    .byte %00111100  ; sprites.basm:227
    .byte %00111101  ; sprites.basm:228
    .byte %00011001  ; sprites.basm:229
    .byte %00011001  ; sprites.basm:230
    .byte %00111101  ; sprites.basm:231
    .byte %11111111  ; sprites.basm:232
    .byte %11111110  ; sprites.basm:233
    .byte %11111110  ; sprites.basm:234
    .byte %11111110  ; sprites.basm:235
    .byte %10111100  ; sprites.basm:236
    .byte %00111110  ; sprites.basm:237
    .byte %00100000  ; sprites.basm:238
    .byte %00100000  ; sprites.basm:239
    .byte %00100000  ; sprites.basm:240
    .byte %01100000  ; sprites.basm:241
bmp_14:  ; sprites.basm:242
    .byte %00011000  ; sprites.basm:243
    .byte %00111100  ; sprites.basm:244
    .byte %11111111  ; sprites.basm:245
    .byte %00111100  ; sprites.basm:246
    .byte %10111100  ; sprites.basm:247
    .byte %10011000  ; sprites.basm:248
    .byte %10011000  ; sprites.basm:249
    .byte %10111100  ; sprites.basm:250
    .byte %11111111  ; sprites.basm:251
    .byte %01111111  ; sprites.basm:252
    .byte %01111111  ; sprites.basm:253
    .byte %01111111  ; sprites.basm:254
    .byte %00111101  ; sprites.basm:255
    .byte %01111100  ; sprites.basm:256
    .byte %00000100  ; sprites.basm:257
    .byte %00000100  ; sprites.basm:258
    .byte %00000100  ; sprites.basm:259
    .byte %00000110  ; sprites.basm:260
bmp_15:  ; sprites.basm:261
    .byte %00000000, %01110000  ; sprites.basm:262
    .byte %00000000, %11111000  ; sprites.basm:263
    .byte %00000001, %11101000  ; sprites.basm:264
    .byte %00000001, %11101111  ; sprites.basm:265
    .byte %00000001, %11111111  ; sprites.basm:266
    .byte %00000001, %11111000  ; sprites.basm:267
    .byte %00000000, %11110000  ; sprites.basm:268
    .byte %00000000, %11100000  ; sprites.basm:269
    .byte %00000000, %01100000  ; sprites.basm:270
    .byte %00001110, %01110000  ; sprites.basm:271
    .byte %00011111, %01110000  ; sprites.basm:272
    .byte %00111111, %11111000  ; sprites.basm:273
    .byte %01111111, %11111000  ; sprites.basm:274
    .byte %11111111, %01111000  ; sprites.basm:275
    .byte %11111111, %10111000  ; sprites.basm:276
    .byte %10111111, %10111100  ; sprites.basm:277
    .byte %10111111, %10111100  ; sprites.basm:278
    .byte %11011111, %10111100  ; sprites.basm:279
    .byte %01101111, %01111100  ; sprites.basm:280
    .byte %01110110, %11111100  ; sprites.basm:281
    .byte %00111001, %11111000  ; sprites.basm:282
    .byte %00011111, %11111000  ; sprites.basm:283
    .byte %00001111, %11110000  ; sprites.basm:284
    .byte %00000011, %11100000  ; sprites.basm:285
bmp_16:  ; sprites.basm:286
    .byte %00000000, %01110000  ; sprites.basm:287
    .byte %00000000, %11111001  ; sprites.basm:288
    .byte %00000001, %11101010  ; sprites.basm:289
    .byte %00000001, %11101100  ; sprites.basm:290
    .byte %00000001, %11111100  ; sprites.basm:291
    .byte %00000001, %11111010  ; sprites.basm:292
    .byte %00000000, %11110001  ; sprites.basm:293
    .byte %00000000, %11100000  ; sprites.basm:294
    .byte %00000000, %01100000  ; sprites.basm:295
    .byte %00001110, %01110000  ; sprites.basm:296
    .byte %00011111, %01110000  ; sprites.basm:297
    .byte %00111111, %11111000  ; sprites.basm:298
    .byte %01110001, %11111000  ; sprites.basm:299
    .byte %11101110, %01111000  ; sprites.basm:300
    .byte %11011111, %10111000  ; sprites.basm:301
    .byte %10111111, %11111100  ; sprites.basm:302
    .byte %11111111, %11111100  ; sprites.basm:303
    .byte %11111111, %11111100  ; sprites.basm:304
    .byte %01111111, %11111100  ; sprites.basm:305
    .byte %01111111, %11111100  ; sprites.basm:306
    .byte %00111111, %11111000  ; sprites.basm:307
    .byte %00011111, %11111000  ; sprites.basm:308
    .byte %00001111, %11110000  ; sprites.basm:309
    .byte %00000011, %11100000  ; sprites.basm:310
bmp_17:  ; sprites.basm:311
    .byte %00001110, %00000000  ; sprites.basm:312
    .byte %00011111, %00000000  ; sprites.basm:313
    .byte %00010111, %10000000  ; sprites.basm:314
    .byte %11110111, %10000000  ; sprites.basm:315
    .byte %11111111, %10000000  ; sprites.basm:316
    .byte %00011111, %10000000  ; sprites.basm:317
    .byte %00001111, %00000000  ; sprites.basm:318
    .byte %00000111, %00000000  ; sprites.basm:319
    .byte %00000110, %00000000  ; sprites.basm:320
    .byte %00001110, %01110000  ; sprites.basm:321
    .byte %00001110, %11111000  ; sprites.basm:322
    .byte %00011111, %11111100  ; sprites.basm:323
    .byte %00011111, %11111110  ; sprites.basm:324
    .byte %00011110, %11111111  ; sprites.basm:325
    .byte %00011101, %11111111  ; sprites.basm:326
    .byte %00111101, %11111101  ; sprites.basm:327
    .byte %00111101, %11111101  ; sprites.basm:328
    .byte %00111101, %11111011  ; sprites.basm:329
    .byte %00111110, %11110110  ; sprites.basm:330
    .byte %00111111, %01101110  ; sprites.basm:331
    .byte %00011111, %10011100  ; sprites.basm:332
    .byte %00011111, %11111000  ; sprites.basm:333
    .byte %00001111, %11110000  ; sprites.basm:334
    .byte %00000111, %11000000  ; sprites.basm:335
bmp_18:  ; sprites.basm:336
    .byte %00001110, %00000000  ; sprites.basm:337
    .byte %10011111, %00000000  ; sprites.basm:338
    .byte %01010111, %10000000  ; sprites.basm:339
    .byte %00110111, %10000000  ; sprites.basm:340
    .byte %00111111, %10000000  ; sprites.basm:341
    .byte %01011111, %10000000  ; sprites.basm:342
    .byte %10001111, %00000000  ; sprites.basm:343
    .byte %00000111, %00000000  ; sprites.basm:344
    .byte %00000110, %00000000  ; sprites.basm:345
    .byte %00001110, %01110000  ; sprites.basm:346
    .byte %00001110, %11111000  ; sprites.basm:347
    .byte %00011111, %11111100  ; sprites.basm:348
    .byte %00011111, %10001110  ; sprites.basm:349
    .byte %00011110, %01110111  ; sprites.basm:350
    .byte %00011101, %11111011  ; sprites.basm:351
    .byte %00111111, %11111101  ; sprites.basm:352
    .byte %00111111, %11111111  ; sprites.basm:353
    .byte %00111111, %11111111  ; sprites.basm:354
    .byte %00111111, %11111110  ; sprites.basm:355
    .byte %00111111, %11111110  ; sprites.basm:356
    .byte %00011111, %11111100  ; sprites.basm:357
    .byte %00011111, %11111000  ; sprites.basm:358
    .byte %00001111, %11110000  ; sprites.basm:359
    .byte %00000111, %11000000  ; sprites.basm:360
bmp_19:  ; sprites.basm:361
    .byte %00000000, %00111000, %00000000  ; sprites.basm:362
    .byte %00000000, %01000100, %00000000  ; sprites.basm:363
    .byte %00000000, %01000100, %00000000  ; sprites.basm:364
    .byte %00000000, %01000100, %00000000  ; sprites.basm:365
    .byte %00000000, %00111000, %00000000  ; sprites.basm:366
    .byte %00000000, %00010000, %00000000  ; sprites.basm:367
    .byte %00000000, %11111110, %00000000  ; sprites.basm:368
    .byte %00000011, %01111101, %10000000  ; sprites.basm:369
    .byte %00001100, %11010110, %01100000  ; sprites.basm:370
    .byte %00010001, %01010101, %00010000  ; sprites.basm:371
    .byte %00100010, %01010100, %10001000  ; sprites.basm:372
    .byte %00100100, %10010010, %01001000  ; sprites.basm:373
    .byte %01000100, %10010010, %01000100  ; sprites.basm:374
    .byte %01001000, %10010010, %00100100  ; sprites.basm:375
    .byte %10001000, %10010010, %00100010  ; sprites.basm:376
    .byte %10001001, %00010001, %00100010  ; sprites.basm:377
    .byte %11010001, %00010000, %00010110  ; sprites.basm:378
    .byte %10110001, %00010000, %00001010  ; sprites.basm:379
    .byte %10011001, %00000000, %00000010  ; sprites.basm:380
    .byte %10010111, %00000000, %00000010  ; sprites.basm:381
    .byte %10010001, %11100000, %00000010  ; sprites.basm:382
    .byte %10010001, %00000000, %00000010  ; sprites.basm:383
    .byte %10010001, %00010000, %00000010  ; sprites.basm:384
    .byte %10010001, %00010000, %00010010  ; sprites.basm:385
    .byte %10010001, %00010000, %00010010  ; sprites.basm:386
    .byte %10010001, %00010000, %00010010  ; sprites.basm:387
    .byte %10010000, %00000000, %00010010  ; sprites.basm:388
    .byte %10010000, %00000000, %00010010  ; sprites.basm:389
    .byte %10010000, %00000000, %00010010  ; sprites.basm:390
    .byte %11010000, %00000000, %00010110  ; sprites.basm:391
    .byte %10110000, %00000000, %00011010  ; sprites.basm:392
    .byte %10010000, %00000000, %00110010  ; sprites.basm:393
    .byte %10010000, %00000000, %00010010  ; sprites.basm:394
    .byte %10010000, %00000000, %00010010  ; sprites.basm:395
    .byte %10010000, %00000000, %00010010  ; sprites.basm:396
    .byte %10010000, %00000000, %00010010  ; sprites.basm:397
    .byte %10010000, %00000000, %00010010  ; sprites.basm:398
    .byte %10010000, %00000000, %00010010  ; sprites.basm:399
    .byte %10010001, %00000000, %00010010  ; sprites.basm:400
    .byte %10010001, %00000001, %00010010  ; sprites.basm:401
    .byte %10010001, %00010001, %00010010  ; sprites.basm:402
    .byte %10010001, %00010001, %00010010  ; sprites.basm:403
    .byte %11010001, %00010001, %00010010  ; sprites.basm:404
    .byte %01010001, %00010001, %00010100  ; sprites.basm:405
    .byte %00110001, %00010001, %00011000  ; sprites.basm:406
    .byte %00011001, %00010001, %00110000  ; sprites.basm:407
    .byte %00000111, %00010001, %11000000  ; sprites.basm:408
    .byte %00000000, %11111110, %00000000  ; sprites.basm:409
bmp_20:  ; sprites.basm:410
    .byte %00000000, %00111000, %00000000  ; sprites.basm:411
    .byte %00000000, %01000100, %00000000  ; sprites.basm:412
    .byte %00000000, %01000100, %00000000  ; sprites.basm:413
    .byte %00000000, %01000100, %00000000  ; sprites.basm:414
    .byte %00000000, %00111000, %00000000  ; sprites.basm:415
    .byte %00000000, %00010000, %00000000  ; sprites.basm:416
    .byte %00000000, %11111110, %00000000  ; sprites.basm:417
    .byte %00000011, %01111101, %10000000  ; sprites.basm:418
    .byte %00001100, %11010110, %01100000  ; sprites.basm:419
    .byte %00010001, %01010101, %00010000  ; sprites.basm:420
    .byte %00100010, %01010100, %10001000  ; sprites.basm:421
    .byte %00100100, %10010010, %01001000  ; sprites.basm:422
    .byte %01000100, %10010010, %01000100  ; sprites.basm:423
    .byte %01001000, %10010010, %00100100  ; sprites.basm:424
    .byte %10001000, %10010010, %00100010  ; sprites.basm:425
    .byte %10001001, %00010001, %00100010  ; sprites.basm:426
    .byte %11010001, %00010001, %00010110  ; sprites.basm:427
    .byte %10110001, %00010001, %00011010  ; sprites.basm:428
    .byte %10011001, %00010001, %00110010  ; sprites.basm:429
    .byte %10010111, %00010001, %11010010  ; sprites.basm:430
    .byte %10010001, %11111111, %00010010  ; sprites.basm:431
    .byte %10010001, %00010001, %00010010  ; sprites.basm:432
    .byte %10010001, %00010001, %00010010  ; sprites.basm:433
    .byte %10010001, %00010001, %00010010  ; sprites.basm:434
    .byte %10010001, %00010001, %00010010  ; sprites.basm:435
    .byte %10010001, %00010001, %00010010  ; sprites.basm:436
    .byte %10010001, %00010001, %00010010  ; sprites.basm:437
    .byte %10010001, %00010001, %00010010  ; sprites.basm:438
    .byte %10010001, %00010001, %00010010  ; sprites.basm:439
    .byte %11010001, %00010001, %00010110  ; sprites.basm:440
    .byte %10110001, %00010001, %00011010  ; sprites.basm:441
    .byte %10011001, %00010001, %00110010  ; sprites.basm:442
    .byte %10010111, %00010001, %11010010  ; sprites.basm:443
    .byte %10010001, %11111111, %00010010  ; sprites.basm:444
    .byte %10010001, %00010001, %00010010  ; sprites.basm:445
    .byte %10010001, %00010001, %00010010  ; sprites.basm:446
    .byte %10010001, %00010001, %00010010  ; sprites.basm:447
    .byte %10010001, %00010001, %00010010  ; sprites.basm:448
    .byte %10010001, %00010001, %00010010  ; sprites.basm:449
    .byte %10010001, %00010001, %00010010  ; sprites.basm:450
    .byte %10010001, %00010001, %00010010  ; sprites.basm:451
    .byte %10010001, %00010001, %00010010  ; sprites.basm:452
    .byte %11010001, %00010001, %00010010  ; sprites.basm:453
    .byte %01010001, %00010001, %00010100  ; sprites.basm:454
    .byte %00110001, %00010001, %00011000  ; sprites.basm:455
    .byte %00011001, %00010001, %00110000  ; sprites.basm:456
    .byte %00000111, %00010001, %11000000  ; sprites.basm:457
    .byte %00000000, %11111110, %00000000  ; sprites.basm:458
bmp_21:  ; sprites.basm:459
    .byte %00001100  ; sprites.basm:460
    .byte %00011011  ; sprites.basm:461
    .byte %00011100  ; sprites.basm:462
    .byte %00001000  ; sprites.basm:463
    .byte %00001000  ; sprites.basm:464
    .byte %00000100  ; sprites.basm:465
    .byte %00000100  ; sprites.basm:466
    .byte %00000010  ; sprites.basm:467
    .byte %00110010  ; sprites.basm:468
    .byte %01111011  ; sprites.basm:469
    .byte %01111111  ; sprites.basm:470
    .byte %01111111  ; sprites.basm:471
    .byte %01111111  ; sprites.basm:472
    .byte %00111110  ; sprites.basm:473
    .byte %00011000  ; sprites.basm:474
    .byte %00010000  ; sprites.basm:475
    .byte %00010000  ; sprites.basm:476
    .byte %00010000  ; sprites.basm:477
    .byte %00010000  ; sprites.basm:478
    .byte %00011000  ; sprites.basm:479
bmp_22:  ; sprites.basm:480
    .byte %00001101  ; sprites.basm:481
    .byte %00011010  ; sprites.basm:482
    .byte %00011101  ; sprites.basm:483
    .byte %00001000  ; sprites.basm:484
    .byte %00001000  ; sprites.basm:485
    .byte %00000100  ; sprites.basm:486
    .byte %00000100  ; sprites.basm:487
    .byte %00000010  ; sprites.basm:488
    .byte %00110010  ; sprites.basm:489
    .byte %01111011  ; sprites.basm:490
    .byte %01111111  ; sprites.basm:491
    .byte %01111111  ; sprites.basm:492
    .byte %01111111  ; sprites.basm:493
    .byte %00111110  ; sprites.basm:494
    .byte %00011000  ; sprites.basm:495
    .byte %00101000  ; sprites.basm:496
    .byte %00101000  ; sprites.basm:497
    .byte %01000100  ; sprites.basm:498
    .byte %01000101  ; sprites.basm:499
    .byte %00100010  ; sprites.basm:500
bmp_23:  ; sprites.basm:501
    .byte %00110000  ; sprites.basm:502
    .byte %11011000  ; sprites.basm:503
    .byte %00111000  ; sprites.basm:504
    .byte %00010000  ; sprites.basm:505
    .byte %00010000  ; sprites.basm:506
    .byte %00100000  ; sprites.basm:507
    .byte %00100000  ; sprites.basm:508
    .byte %01000000  ; sprites.basm:509
    .byte %01001100  ; sprites.basm:510
    .byte %11011110  ; sprites.basm:511
    .byte %11111110  ; sprites.basm:512
    .byte %11111110  ; sprites.basm:513
    .byte %11111110  ; sprites.basm:514
    .byte %01111100  ; sprites.basm:515
    .byte %00011000  ; sprites.basm:516
    .byte %00001000  ; sprites.basm:517
    .byte %00001000  ; sprites.basm:518
    .byte %00001000  ; sprites.basm:519
    .byte %00001000  ; sprites.basm:520
    .byte %00011000  ; sprites.basm:521
bmp_24:  ; sprites.basm:522
    .byte %10110000  ; sprites.basm:523
    .byte %01011000  ; sprites.basm:524
    .byte %10111000  ; sprites.basm:525
    .byte %00010000  ; sprites.basm:526
    .byte %00010000  ; sprites.basm:527
    .byte %00100000  ; sprites.basm:528
    .byte %00100000  ; sprites.basm:529
    .byte %01000000  ; sprites.basm:530
    .byte %01001100  ; sprites.basm:531
    .byte %11011110  ; sprites.basm:532
    .byte %11111110  ; sprites.basm:533
    .byte %11111110  ; sprites.basm:534
    .byte %11111110  ; sprites.basm:535
    .byte %01111100  ; sprites.basm:536
    .byte %00011000  ; sprites.basm:537
    .byte %00010100  ; sprites.basm:538
    .byte %00010100  ; sprites.basm:539
    .byte %00100010  ; sprites.basm:540
    .byte %10100010  ; sprites.basm:541
    .byte %01000100  ; sprites.basm:542
bmp_25:  ; sprites.basm:543
    .byte %00011000  ; sprites.basm:544
    .byte %00111100  ; sprites.basm:545
    .byte %00111100  ; sprites.basm:546
    .byte %00111100  ; sprites.basm:547
    .byte %00011000  ; sprites.basm:548
    .byte %00011000  ; sprites.basm:549
    .byte %00011000  ; sprites.basm:550
    .byte %00111100  ; sprites.basm:551
    .byte %01111110  ; sprites.basm:552
    .byte %01111110  ; sprites.basm:553
    .byte %01111110  ; sprites.basm:554
    .byte %01111110  ; sprites.basm:555
    .byte %01111110  ; sprites.basm:556
    .byte %00111100  ; sprites.basm:557
    .byte %00111100  ; sprites.basm:558
    .byte %00100100  ; sprites.basm:559
    .byte %00100100  ; sprites.basm:560
    .byte %00100110  ; sprites.basm:561
    .byte %00100000  ; sprites.basm:562
    .byte %01100000  ; sprites.basm:563
bmp_26:  ; sprites.basm:564
    .byte %00011000  ; sprites.basm:565
    .byte %00111100  ; sprites.basm:566
    .byte %00111100  ; sprites.basm:567
    .byte %00111100  ; sprites.basm:568
    .byte %00011000  ; sprites.basm:569
    .byte %00011000  ; sprites.basm:570
    .byte %00011000  ; sprites.basm:571
    .byte %00111100  ; sprites.basm:572
    .byte %01111110  ; sprites.basm:573
    .byte %01111110  ; sprites.basm:574
    .byte %01111110  ; sprites.basm:575
    .byte %01111110  ; sprites.basm:576
    .byte %01111110  ; sprites.basm:577
    .byte %00111100  ; sprites.basm:578
    .byte %00111100  ; sprites.basm:579
    .byte %00100100  ; sprites.basm:580
    .byte %00100100  ; sprites.basm:581
    .byte %01100100  ; sprites.basm:582
    .byte %00000100  ; sprites.basm:583
    .byte %00000100  ; sprites.basm:584
    .byte %00000100  ; sprites.basm:585
    .byte %00000110  ; sprites.basm:586
bmp_27:  ; sprites.basm:587
    .byte %00000000, %00000000  ; sprites.basm:588
    .byte %00000000, %00000000  ; sprites.basm:589
    .byte %00000000, %00000000  ; sprites.basm:590
    .byte %00000000, %00000000  ; sprites.basm:591
    .byte %00000000, %00000000  ; sprites.basm:592
    .byte %00000000, %00000000  ; sprites.basm:593
    .byte %00000000, %00111000  ; sprites.basm:594
    .byte %00110000, %00101000  ; sprites.basm:595
    .byte %01111000, %01111000  ; sprites.basm:596
    .byte %01111100, %11000100  ; sprites.basm:597
    .byte %01111111, %11000010  ; sprites.basm:598
    .byte %01111111, %10000000  ; sprites.basm:599
    .byte %00111111, %00000000  ; sprites.basm:600
    .byte %00111111, %00000000  ; sprites.basm:601
    .byte %00011111, %00000000  ; sprites.basm:602
    .byte %00010110, %00000000  ; sprites.basm:603
    .byte %00010000, %00000000  ; sprites.basm:604
    .byte %00010000, %00000000  ; sprites.basm:605
    .byte %00010000, %00000000  ; sprites.basm:606
    .byte %00011000, %00000000  ; sprites.basm:607
bmp_28:  ; sprites.basm:608
    .byte %00000000, %00000000  ; sprites.basm:609
    .byte %00000000, %00000000  ; sprites.basm:610
    .byte %00000000, %00000000  ; sprites.basm:611
    .byte %00000000, %00000000  ; sprites.basm:612
    .byte %00000000, %00000000  ; sprites.basm:613
    .byte %00000000, %00000000  ; sprites.basm:614
    .byte %00000000, %00000000  ; sprites.basm:615
    .byte %00110000, %00000000  ; sprites.basm:616
    .byte %01111000, %00000000  ; sprites.basm:617
    .byte %01111100, %00000000  ; sprites.basm:618
    .byte %01111110, %00000000  ; sprites.basm:619
    .byte %01111111, %11111000  ; sprites.basm:620
    .byte %00111111, %11110100  ; sprites.basm:621
    .byte %00111111, %00010100  ; sprites.basm:622
    .byte %00011111, %00001000  ; sprites.basm:623
    .byte %00010110, %00001000  ; sprites.basm:624
    .byte %00010000, %00001000  ; sprites.basm:625
    .byte %00010000, %00000000  ; sprites.basm:626
    .byte %00010000, %00000000  ; sprites.basm:627
    .byte %00011000, %00000000  ; sprites.basm:628
bmp_29:  ; sprites.basm:629
    .byte %00000000, %00000000  ; sprites.basm:630
    .byte %00000000, %00000000  ; sprites.basm:631
    .byte %00000000, %00000000  ; sprites.basm:632
    .byte %00000000, %00000000  ; sprites.basm:633
    .byte %00000000, %00000000  ; sprites.basm:634
    .byte %00000000, %00000000  ; sprites.basm:635
    .byte %00011100, %00000000  ; sprites.basm:636
    .byte %00010100, %00001100  ; sprites.basm:637
    .byte %00011110, %00011110  ; sprites.basm:638
    .byte %00100011, %00111110  ; sprites.basm:639
    .byte %01000011, %11111110  ; sprites.basm:640
    .byte %00000001, %11111110  ; sprites.basm:641
    .byte %00000000, %11111100  ; sprites.basm:642
    .byte %00000000, %11111100  ; sprites.basm:643
    .byte %00000000, %11111000  ; sprites.basm:644
    .byte %00000000, %01101000  ; sprites.basm:645
    .byte %00000000, %00001000  ; sprites.basm:646
    .byte %00000000, %00001000  ; sprites.basm:647
    .byte %00000000, %00001000  ; sprites.basm:648
    .byte %00000000, %00011000  ; sprites.basm:649
bmp_30:  ; sprites.basm:650
    .byte %00000000, %00000000  ; sprites.basm:651
    .byte %00000000, %00000000  ; sprites.basm:652
    .byte %00000000, %00000000  ; sprites.basm:653
    .byte %00000000, %00000000  ; sprites.basm:654
    .byte %00000000, %00000000  ; sprites.basm:655
    .byte %00000000, %00000000  ; sprites.basm:656
    .byte %00000000, %00000000  ; sprites.basm:657
    .byte %00000000, %00001100  ; sprites.basm:658
    .byte %00000000, %00011110  ; sprites.basm:659
    .byte %00000000, %00111110  ; sprites.basm:660
    .byte %00000000, %01111110  ; sprites.basm:661
    .byte %00011111, %11111110  ; sprites.basm:662
    .byte %00101111, %11111100  ; sprites.basm:663
    .byte %00101000, %11111100  ; sprites.basm:664
    .byte %00010000, %11111000  ; sprites.basm:665
    .byte %00010000, %01101000  ; sprites.basm:666
    .byte %00010000, %00001000  ; sprites.basm:667
    .byte %00000000, %00001000  ; sprites.basm:668
    .byte %00000000, %00001000  ; sprites.basm:669
    .byte %00000000, %00011000  ; sprites.basm:670
bmp_31:  ; sprites.basm:671
    .byte %01100000  ; sprites.basm:672
    .byte %10010000  ; sprites.basm:673
    .byte %10010000  ; sprites.basm:674
    .byte %10010000  ; sprites.basm:675
    .byte %10010000  ; sprites.basm:676
    .byte %10010000  ; sprites.basm:677
    .byte %01100000  ; sprites.basm:678
bmp_32:  ; sprites.basm:679
    .byte %00100000  ; sprites.basm:680
    .byte %01100000  ; sprites.basm:681
    .byte %00100000  ; sprites.basm:682
    .byte %00100000  ; sprites.basm:683
    .byte %00100000  ; sprites.basm:684
    .byte %00100000  ; sprites.basm:685
    .byte %01110000  ; sprites.basm:686
bmp_33:  ; sprites.basm:687
    .byte %01100000  ; sprites.basm:688
    .byte %10010000  ; sprites.basm:689
    .byte %00010000  ; sprites.basm:690
    .byte %00100000  ; sprites.basm:691
    .byte %01000000  ; sprites.basm:692
    .byte %10000000  ; sprites.basm:693
    .byte %11110000  ; sprites.basm:694
bmp_34:  ; sprites.basm:695
    .byte %01100000  ; sprites.basm:696
    .byte %10010000  ; sprites.basm:697
    .byte %00010000  ; sprites.basm:698
    .byte %00100000  ; sprites.basm:699
    .byte %00010000  ; sprites.basm:700
    .byte %10010000  ; sprites.basm:701
    .byte %01100000  ; sprites.basm:702
bmp_35:  ; sprites.basm:703
    .byte %10000000  ; sprites.basm:704
    .byte %10000000  ; sprites.basm:705
    .byte %10100000  ; sprites.basm:706
    .byte %10100000  ; sprites.basm:707
    .byte %11110000  ; sprites.basm:708
    .byte %00100000  ; sprites.basm:709
    .byte %00100000  ; sprites.basm:710
bmp_36:  ; sprites.basm:711
    .byte %11110000  ; sprites.basm:712
    .byte %10000000  ; sprites.basm:713
    .byte %11100000  ; sprites.basm:714
    .byte %00010000  ; sprites.basm:715
    .byte %00010000  ; sprites.basm:716
    .byte %10010000  ; sprites.basm:717
    .byte %01100000  ; sprites.basm:718
bmp_37:  ; sprites.basm:719
    .byte %01100000  ; sprites.basm:720
    .byte %10010000  ; sprites.basm:721
    .byte %10000000  ; sprites.basm:722
    .byte %11100000  ; sprites.basm:723
    .byte %10010000  ; sprites.basm:724
    .byte %10010000  ; sprites.basm:725
    .byte %01100000  ; sprites.basm:726
bmp_38:  ; sprites.basm:727
    .byte %11110000  ; sprites.basm:728
    .byte %00010000  ; sprites.basm:729
    .byte %00010000  ; sprites.basm:730
    .byte %00100000  ; sprites.basm:731
    .byte %00100000  ; sprites.basm:732
    .byte %01000000  ; sprites.basm:733
    .byte %01000000  ; sprites.basm:734
bmp_39:  ; sprites.basm:735
    .byte %01100000  ; sprites.basm:736
    .byte %10010000  ; sprites.basm:737
    .byte %10010000  ; sprites.basm:738
    .byte %01100000  ; sprites.basm:739
    .byte %10010000  ; sprites.basm:740
    .byte %10010000  ; sprites.basm:741
    .byte %01100000  ; sprites.basm:742
bmp_40:  ; sprites.basm:743
    .byte %01100000  ; sprites.basm:744
    .byte %10010000  ; sprites.basm:745
    .byte %10010000  ; sprites.basm:746
    .byte %01110000  ; sprites.basm:747
    .byte %00010000  ; sprites.basm:748
    .byte %10010000  ; sprites.basm:749
    .byte %01100000  ; sprites.basm:750
bmp_41:  ; sprites.basm:751
    .byte %11111111, %11111111, %11111000  ; sprites.basm:752
    .byte %10001000, %10001001, %10001000  ; sprites.basm:753
    .byte %10111011, %10101010, %10111000  ; sprites.basm:754
    .byte %10111011, %10101010, %10111000  ; sprites.basm:755
    .byte %10001011, %10101001, %10011000  ; sprites.basm:756
    .byte %11101011, %10101010, %10111000  ; sprites.basm:757
    .byte %11101011, %10101010, %10111000  ; sprites.basm:758
    .byte %10001000, %10001010, %10001000  ; sprites.basm:759
    .byte %11111111, %11111111, %11111000  ; sprites.basm:760
bmp_42:  ; sprites.basm:761
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:762
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:763
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:764
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:765
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:766
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:767
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:768
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:769
    .byte %11111111, %11111111, %11111111, %11111110  ; sprites.basm:770
bmp_43:  ; sprites.basm:771
    .byte %11111111, %11111111, %11111111, %11111111  ; sprites.basm:772
    .byte %10011011, %11011010, %10001001, %11111111  ; sprites.basm:773
    .byte %10101011, %10101010, %10111010, %11111111  ; sprites.basm:774
    .byte %10101011, %10101010, %10111010, %11111111  ; sprites.basm:775
    .byte %10011011, %10001101, %10011001, %11111111  ; sprites.basm:776
    .byte %10111011, %10101101, %10111010, %11111111  ; sprites.basm:777
    .byte %10111011, %10101101, %10111010, %11111111  ; sprites.basm:778
    .byte %10111000, %10101101, %10001010, %11111111  ; sprites.basm:779
    .byte %11111111, %11111111, %11111111, %11111111  ; sprites.basm:780
bmp_44:  ; sprites.basm:781
    .byte %11111111, %11111111, %11111111, %11111111, %11111100  ; sprites.basm:782
    .byte %10111000, %10101000, %10111111, %11111111, %11111100  ; sprites.basm:783
    .byte %10111011, %10101011, %10111111, %11111111, %11111100  ; sprites.basm:784
    .byte %10111011, %10101011, %10111111, %11111111, %11111100  ; sprites.basm:785
    .byte %10111001, %10101001, %10111111, %11111111, %11111100  ; sprites.basm:786
    .byte %10111011, %10101011, %10111111, %11111111, %11111100  ; sprites.basm:787
    .byte %10111011, %11011011, %10111111, %11111111, %11111100  ; sprites.basm:788
    .byte %10001000, %11011000, %10001111, %11111111, %11111100  ; sprites.basm:789
    .byte %11111111, %11111111, %11111111, %11111111, %11111100  ; sprites.basm:790
bmp_45:  ; sprites.basm:791
    .byte %11111111, %11111111, %11111111, %11111111, %11111111, %11110000  ; sprites.basm:792
    .byte %10011000, %10110101, %01000111, %11111111, %11111111, %11110000  ; sprites.basm:793
    .byte %10101010, %10010101, %01011111, %11111111, %11111111, %11110000  ; sprites.basm:794
    .byte %10101010, %10010101, %01011111, %11111111, %11111111, %11110000  ; sprites.basm:795
    .byte %10011010, %10100101, %01000111, %11111111, %11111111, %11110000  ; sprites.basm:796
    .byte %10101010, %10100101, %01110111, %11111111, %11111111, %11110000  ; sprites.basm:797
    .byte %10101010, %10110101, %01110111, %11111111, %11111111, %11110000  ; sprites.basm:798
    .byte %10011000, %10110100, %01000111, %11111111, %11111111, %11110000  ; sprites.basm:799
    .byte %11111111, %11111111, %11111111, %11111111, %11111111, %11110000  ; sprites.basm:800
bmp_46:  ; sprites.basm:801
    .byte %11111111, %11111111, %11111111, %11111111, %11000000  ; sprites.basm:802
    .byte %10001010, %01001000, %11111111, %11111111, %11000000  ; sprites.basm:803
    .byte %11011010, %01001011, %11111111, %11111111, %11000000  ; sprites.basm:804
    .byte %11011010, %10101011, %11111111, %11111111, %11000000  ; sprites.basm:805
    .byte %11011010, %10101001, %11111111, %11111111, %11000000  ; sprites.basm:806
    .byte %11011010, %10101011, %11111111, %11111111, %11000000  ; sprites.basm:807
    .byte %11011010, %11101011, %11111111, %11111111, %11000000  ; sprites.basm:808
    .byte %11011010, %11101000, %11111111, %11111111, %11000000  ; sprites.basm:809
    .byte %11111111, %11111111, %11111111, %11111111, %11000000  ; sprites.basm:810
bmp_47:  ; sprites.basm:811
    .byte %01000000  ; sprites.basm:812
    .byte %11100000  ; sprites.basm:813
    .byte %00000000  ; sprites.basm:814
bmp_48:  ; sprites.basm:815
    .byte %00000011, %10000000  ; sprites.basm:816
    .byte %00001111, %11100000  ; sprites.basm:817
    .byte %00011111, %11110000  ; sprites.basm:818
    .byte %00011111, %11111000  ; sprites.basm:819
    .byte %00111111, %11111000  ; sprites.basm:820
    .byte %00111111, %11111100  ; sprites.basm:821
    .byte %01111111, %11111100  ; sprites.basm:822
    .byte %01111111, %11111100  ; sprites.basm:823
    .byte %01111110, %01111100  ; sprites.basm:824
    .byte %01111100, %00111000  ; sprites.basm:825
    .byte %11111000, %00011000  ; sprites.basm:826
    .byte %11111000, %00000000  ; sprites.basm:827
    .byte %11110000, %00000000  ; sprites.basm:828
    .byte %11110000, %00000000  ; sprites.basm:829
    .byte %11110000, %00000000  ; sprites.basm:830
    .byte %11110000, %00000000  ; sprites.basm:831
    .byte %11110000, %00000000  ; sprites.basm:832
    .byte %11110000, %00000000  ; sprites.basm:833
    .byte %11111000, %00000000  ; sprites.basm:834
    .byte %11111000, %00011000  ; sprites.basm:835
    .byte %01111100, %00111000  ; sprites.basm:836
    .byte %01111110, %01111100  ; sprites.basm:837
    .byte %01111111, %11111100  ; sprites.basm:838
    .byte %01111111, %11111100  ; sprites.basm:839
    .byte %00111111, %11111100  ; sprites.basm:840
    .byte %00111111, %11111000  ; sprites.basm:841
    .byte %00011111, %11111000  ; sprites.basm:842
    .byte %00011111, %11110000  ; sprites.basm:843
    .byte %00001111, %11100000  ; sprites.basm:844
    .byte %00000011, %10000000  ; sprites.basm:845
bmp_49:  ; sprites.basm:846
    .byte %01100000, %00011000  ; sprites.basm:847
    .byte %11110000, %00111100  ; sprites.basm:848
    .byte %11110000, %00111100  ; sprites.basm:849
    .byte %11110000, %00111100  ; sprites.basm:850
    .byte %11110000, %00111100  ; sprites.basm:851
    .byte %11110000, %00111100  ; sprites.basm:852
    .byte %11110000, %00111100  ; sprites.basm:853
    .byte %11110000, %00111100  ; sprites.basm:854
    .byte %11110000, %00111100  ; sprites.basm:855
    .byte %11110000, %00111100  ; sprites.basm:856
    .byte %11110000, %00111100  ; sprites.basm:857
    .byte %11110000, %00111100  ; sprites.basm:858
    .byte %11111111, %11111100  ; sprites.basm:859
    .byte %11111111, %11111100  ; sprites.basm:860
    .byte %11111111, %11111100  ; sprites.basm:861
    .byte %11111111, %11111100  ; sprites.basm:862
    .byte %11111111, %11111100  ; sprites.basm:863
    .byte %11111111, %11111100  ; sprites.basm:864
    .byte %11110000, %00111100  ; sprites.basm:865
    .byte %11110000, %00111100  ; sprites.basm:866
    .byte %11110000, %00111100  ; sprites.basm:867
    .byte %11110000, %00111100  ; sprites.basm:868
    .byte %11110000, %00111100  ; sprites.basm:869
    .byte %11110000, %00111100  ; sprites.basm:870
    .byte %11110000, %00111100  ; sprites.basm:871
    .byte %11110000, %00111100  ; sprites.basm:872
    .byte %11110000, %00111100  ; sprites.basm:873
    .byte %11110000, %00111100  ; sprites.basm:874
    .byte %11110000, %00111100  ; sprites.basm:875
    .byte %01100000, %00011000  ; sprites.basm:876
bmp_50:  ; sprites.basm:877
    .byte %01100000, %00011000  ; sprites.basm:878
    .byte %11110000, %00111100  ; sprites.basm:879
    .byte %11110000, %00111100  ; sprites.basm:880
    .byte %11110000, %00111100  ; sprites.basm:881
    .byte %11110000, %00111100  ; sprites.basm:882
    .byte %11110000, %00111100  ; sprites.basm:883
    .byte %11110000, %00111100  ; sprites.basm:884
    .byte %11110000, %00111100  ; sprites.basm:885
    .byte %11110000, %00111100  ; sprites.basm:886
    .byte %11110000, %00111100  ; sprites.basm:887
    .byte %11110000, %00111100  ; sprites.basm:888
    .byte %11110000, %00111100  ; sprites.basm:889
    .byte %11110000, %00111100  ; sprites.basm:890
    .byte %11110000, %00111100  ; sprites.basm:891
    .byte %11110000, %00111100  ; sprites.basm:892
    .byte %11110000, %00111100  ; sprites.basm:893
    .byte %11110000, %00111100  ; sprites.basm:894
    .byte %11110000, %00111100  ; sprites.basm:895
    .byte %11110000, %00111100  ; sprites.basm:896
    .byte %11110000, %00111100  ; sprites.basm:897
    .byte %11110000, %00111100  ; sprites.basm:898
    .byte %11110000, %00111100  ; sprites.basm:899
    .byte %11111000, %01111100  ; sprites.basm:900
    .byte %11111100, %11111100  ; sprites.basm:901
    .byte %11111111, %11111100  ; sprites.basm:902
    .byte %11111111, %11111100  ; sprites.basm:903
    .byte %11111111, %11111100  ; sprites.basm:904
    .byte %01111111, %11111000  ; sprites.basm:905
    .byte %01111111, %11111000  ; sprites.basm:906
    .byte %00111111, %11110000  ; sprites.basm:907
bmp_51:  ; sprites.basm:908
    .byte %01100000, %00010000  ; sprites.basm:909
    .byte %11110000, %00111000  ; sprites.basm:910
    .byte %11110000, %00111000  ; sprites.basm:911
    .byte %11110000, %01111100  ; sprites.basm:912
    .byte %11110000, %01111100  ; sprites.basm:913
    .byte %11110000, %11111100  ; sprites.basm:914
    .byte %11110000, %11111100  ; sprites.basm:915
    .byte %11110001, %11111000  ; sprites.basm:916
    .byte %11110001, %11111000  ; sprites.basm:917
    .byte %11110011, %11110000  ; sprites.basm:918
    .byte %11110011, %11110000  ; sprites.basm:919
    .byte %11110111, %11100000  ; sprites.basm:920
    .byte %11111111, %11100000  ; sprites.basm:921
    .byte %11111111, %11000000  ; sprites.basm:922
    .byte %11111111, %10000000  ; sprites.basm:923
    .byte %11111111, %11000000  ; sprites.basm:924
    .byte %11111111, %11000000  ; sprites.basm:925
    .byte %11111111, %11100000  ; sprites.basm:926
    .byte %11111111, %11100000  ; sprites.basm:927
    .byte %11110011, %11110000  ; sprites.basm:928
    .byte %11110011, %11110000  ; sprites.basm:929
    .byte %11110001, %11111000  ; sprites.basm:930
    .byte %11110001, %11111000  ; sprites.basm:931
    .byte %11110000, %11111100  ; sprites.basm:932
    .byte %11110000, %11111100  ; sprites.basm:933
    .byte %11110000, %01111100  ; sprites.basm:934
    .byte %11110000, %01111100  ; sprites.basm:935
    .byte %11110000, %00111000  ; sprites.basm:936
    .byte %11110000, %00111000  ; sprites.basm:937
    .byte %01100000, %00010000  ; sprites.basm:938
bmp_52:  ; sprites.basm:939
    .byte %01111111, %11111000  ; sprites.basm:940
    .byte %11111111, %11111100  ; sprites.basm:941
    .byte %11111111, %11111100  ; sprites.basm:942
    .byte %11111111, %11111100  ; sprites.basm:943
    .byte %11111111, %11111100  ; sprites.basm:944
    .byte %01111111, %11111000  ; sprites.basm:945
    .byte %00000111, %10000000  ; sprites.basm:946
    .byte %00000111, %10000000  ; sprites.basm:947
    .byte %00000111, %10000000  ; sprites.basm:948
    .byte %00000111, %10000000  ; sprites.basm:949
    .byte %00000111, %10000000  ; sprites.basm:950
    .byte %00000111, %10000000  ; sprites.basm:951
    .byte %00000111, %10000000  ; sprites.basm:952
    .byte %00000111, %10000000  ; sprites.basm:953
    .byte %00000111, %10000000  ; sprites.basm:954
    .byte %00000111, %10000000  ; sprites.basm:955
    .byte %00000111, %10000000  ; sprites.basm:956
    .byte %00000111, %10000000  ; sprites.basm:957
    .byte %00000111, %10000000  ; sprites.basm:958
    .byte %00000111, %10000000  ; sprites.basm:959
    .byte %00000111, %10000000  ; sprites.basm:960
    .byte %00000111, %10000000  ; sprites.basm:961
    .byte %00000111, %10000000  ; sprites.basm:962
    .byte %00000111, %10000000  ; sprites.basm:963
    .byte %01111111, %11111000  ; sprites.basm:964
    .byte %11111111, %11111100  ; sprites.basm:965
    .byte %11111111, %11111100  ; sprites.basm:966
    .byte %11111111, %11111100  ; sprites.basm:967
    .byte %11111111, %11111100  ; sprites.basm:968
    .byte %01111111, %11111000  ; sprites.basm:969
bmp_53:  ; sprites.basm:970
    .byte %00111111, %11111000  ; sprites.basm:971
    .byte %01111111, %11111100  ; sprites.basm:972
    .byte %01111111, %11111100  ; sprites.basm:973
    .byte %11111111, %11111100  ; sprites.basm:974
    .byte %11111111, %11111100  ; sprites.basm:975
    .byte %11111111, %11111000  ; sprites.basm:976
    .byte %11111000, %00000000  ; sprites.basm:977
    .byte %11110000, %00000000  ; sprites.basm:978
    .byte %11110000, %00000000  ; sprites.basm:979
    .byte %11110000, %00000000  ; sprites.basm:980
    .byte %11110000, %00000000  ; sprites.basm:981
    .byte %11110000, %00000000  ; sprites.basm:982
    .byte %11111111, %11100000  ; sprites.basm:983
    .byte %11111111, %11110000  ; sprites.basm:984
    .byte %11111111, %11110000  ; sprites.basm:985
    .byte %11111111, %11110000  ; sprites.basm:986
    .byte %11111111, %11110000  ; sprites.basm:987
    .byte %11111111, %11100000  ; sprites.basm:988
    .byte %11110000, %00000000  ; sprites.basm:989
    .byte %11110000, %00000000  ; sprites.basm:990
    .byte %11110000, %00000000  ; sprites.basm:991
    .byte %11110000, %00000000  ; sprites.basm:992
    .byte %11110000, %00000000  ; sprites.basm:993
    .byte %11111000, %00000000  ; sprites.basm:994
    .byte %11111111, %11111000  ; sprites.basm:995
    .byte %11111111, %11111100  ; sprites.basm:996
    .byte %11111111, %11111100  ; sprites.basm:997
    .byte %01111111, %11111100  ; sprites.basm:998
    .byte %01111111, %11111100  ; sprites.basm:999
    .byte %00111111, %11111000  ; sprites.basm:1000
bmp_54:  ; sprites.basm:1001
    .byte %00000011, %10000000  ; sprites.basm:1002
    .byte %00001111, %11100000  ; sprites.basm:1003
    .byte %00011111, %11110000  ; sprites.basm:1004
    .byte %00011111, %11111000  ; sprites.basm:1005
    .byte %00111111, %11111000  ; sprites.basm:1006
    .byte %00111111, %11111100  ; sprites.basm:1007
    .byte %01111111, %11111100  ; sprites.basm:1008
    .byte %01111111, %11111100  ; sprites.basm:1009
    .byte %01111110, %01111100  ; sprites.basm:1010
    .byte %01111100, %00111000  ; sprites.basm:1011
    .byte %11111000, %00011000  ; sprites.basm:1012
    .byte %11111000, %00000000  ; sprites.basm:1013
    .byte %11110000, %00000000  ; sprites.basm:1014
    .byte %11110000, %00000000  ; sprites.basm:1015
    .byte %11110000, %00000000  ; sprites.basm:1016
    .byte %11110000, %00000000  ; sprites.basm:1017
    .byte %11110000, %11111000  ; sprites.basm:1018
    .byte %11110000, %11111000  ; sprites.basm:1019
    .byte %11111000, %11111100  ; sprites.basm:1020
    .byte %11111000, %01111100  ; sprites.basm:1021
    .byte %01111100, %00111100  ; sprites.basm:1022
    .byte %01111110, %00111100  ; sprites.basm:1023
    .byte %01111111, %01111100  ; sprites.basm:1024
    .byte %01111111, %11111100  ; sprites.basm:1025
    .byte %00111111, %11111100  ; sprites.basm:1026
    .byte %00111111, %11111100  ; sprites.basm:1027
    .byte %00011111, %11111100  ; sprites.basm:1028
    .byte %00011111, %11111000  ; sprites.basm:1029
    .byte %00001111, %11111000  ; sprites.basm:1030
    .byte %00000011, %11110000  ; sprites.basm:1031
    .byte $20, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1033
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1034
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1035
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1036
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1037
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1038
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1039
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1040
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1041
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1042
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1043
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1044
    .byte $00, $00, $00, $00, $00, $00, $00, $00  ; sprites.basm:1045
    .byte $00, $00, $0D, $FF  ; sprites.basm:1046
; RP6502: draw_sprite and calculate_screen_location drew into the BBC
; screen memory at &3000. They are in platform.s, and draw into the XRAM
; bitmap.
.import draw_sprite, calculate_screen_location
lookup_sprite:  ; chuckie.basm:739
    ldy #$00  ; chuckie.basm:741
    sty sprite_hi  ; chuckie.basm:742
    asl a  ; chuckie.basm:743
    rol sprite_hi  ; chuckie.basm:744
    asl a  ; chuckie.basm:745
    rol sprite_hi  ; chuckie.basm:746
    adc #<sprite_lookup_table  ; chuckie.basm:747
    sta sprite_lo  ; chuckie.basm:748
    lda sprite_hi  ; chuckie.basm:749
    adc #>sprite_lookup_table  ; chuckie.basm:750
    sta sprite_hi  ; chuckie.basm:751
    lda (sprite_lo),Y  ; chuckie.basm:752
    sta sprite_width_pixels  ; chuckie.basm:753
    clc   ; chuckie.basm:754
    adc #$07  ; chuckie.basm:755
    lsr a  ; chuckie.basm:756
    lsr a  ; chuckie.basm:757
    lsr a  ; chuckie.basm:758
    sta sprite_width_bytes  ; chuckie.basm:759
    iny   ; chuckie.basm:760
    lda (sprite_lo),Y  ; chuckie.basm:761
    sta sprite_height  ; chuckie.basm:762
    iny   ; chuckie.basm:763
    lda (sprite_lo),Y  ; chuckie.basm:764
    tax   ; chuckie.basm:765
    iny   ; chuckie.basm:766
    lda (sprite_lo),Y  ; chuckie.basm:767
    stx sprite_lo  ; chuckie.basm:768
    sta sprite_hi  ; chuckie.basm:769
    rts   ; chuckie.basm:770
draw_sprite_at_text_coords:  ; chuckie.basm:773
    pha   ; chuckie.basm:775
    txa   ; chuckie.basm:776
    clc   ; chuckie.basm:777
    rol a  ; chuckie.basm:778
    rol a  ; chuckie.basm:779
    rol a  ; chuckie.basm:780
    tax   ; chuckie.basm:781
    tya   ; chuckie.basm:782
    sec   ; chuckie.basm:783
    rol a  ; chuckie.basm:784
    sec   ; chuckie.basm:785
    rol a  ; chuckie.basm:786
    sec   ; chuckie.basm:787
    rol a  ; chuckie.basm:788
    tay   ; chuckie.basm:789
    jsr calculate_screen_location  ; chuckie.basm:790
    pla   ; chuckie.basm:791
    jsr lookup_sprite  ; chuckie.basm:792
    jsr draw_sprite  ; chuckie.basm:793
    rts   ; chuckie.basm:794
write_counted_string:  ; chuckie.basm:797
    stx screen_lo  ; chuckie.basm:799
    sty screen_hi  ; chuckie.basm:800
    ldy #$00  ; chuckie.basm:801
    lda (screen_lo),Y  ; chuckie.basm:802
    sta string_length  ; chuckie.basm:803
string_loop:  ; chuckie.basm:804
    iny   ; chuckie.basm:805
    lda (screen_lo),Y  ; chuckie.basm:806
    jsr oswrch  ; chuckie.basm:807
    cpy string_length  ; chuckie.basm:808
    bne string_loop  ; chuckie.basm:809
    rts   ; chuckie.basm:810
test_keys:  ; chuckie.basm:813
    ldx #scan_H ^ $FF  ; chuckie.basm:815
    ldy #$FF  ; chuckie.basm:816
    lda #osbyte_81_inkey  ; chuckie.basm:817
    jsr osbyte  ; chuckie.basm:818
    cpy #$00  ; chuckie.basm:819
    beq test_player_keys  ; chuckie.basm:820
pause_loop:  ; chuckie.basm:821
    ldx #scan_H ^ $FF  ; chuckie.basm:822
    ldy #$FF  ; chuckie.basm:823
    lda #osbyte_81_inkey  ; chuckie.basm:824
    jsr osbyte  ; chuckie.basm:825
    cpy #$00  ; chuckie.basm:826
    beq test_pause_over  ; chuckie.basm:827
    ldx #scan_ESCAPE ^ $FF  ; chuckie.basm:828
    ldy #$FF  ; chuckie.basm:829
    lda #osbyte_81_inkey  ; chuckie.basm:830
    jsr osbyte  ; chuckie.basm:831
    cpy #$00  ; chuckie.basm:832
    beq test_pause_over  ; chuckie.basm:833
    lda #$80  ; chuckie.basm:834
    sta key_press_bits  ; chuckie.basm:835
    rts   ; chuckie.basm:836
test_pause_over:  ; chuckie.basm:837
    jsr test_player_keys  ; chuckie.basm:838
    lda key_press_bits  ; chuckie.basm:839
    beq pause_loop  ; chuckie.basm:840
test_player_keys:  ; chuckie.basm:841
    lda #$00  ; chuckie.basm:842
    sta key_press_bits  ; chuckie.basm:843
    lda #$01  ; chuckie.basm:844
    sta $80  ; chuckie.basm:845
    ldx key_right  ; chuckie.basm:846
    jsr test_next_key  ; chuckie.basm:847
    ldx key_left  ; chuckie.basm:848
    jsr test_next_key  ; chuckie.basm:849
    ldx key_down  ; chuckie.basm:850
    jsr test_next_key  ; chuckie.basm:851
    ldx key_up  ; chuckie.basm:852
    jsr test_next_key  ; chuckie.basm:853
    ldx key_jump  ; chuckie.basm:854
    jsr test_next_key  ; chuckie.basm:855
    rts   ; chuckie.basm:856
test_next_key:  ; chuckie.basm:857
    ldy #$FF  ; chuckie.basm:858
    lda #osbyte_81_inkey  ; chuckie.basm:859
    jsr osbyte  ; chuckie.basm:860
    cpy #$00  ; chuckie.basm:861
    beq not_pressed  ; chuckie.basm:862
    lda key_press_bits  ; chuckie.basm:863
    ora $80  ; chuckie.basm:864
    sta key_press_bits  ; chuckie.basm:865
not_pressed:  ; chuckie.basm:866
    asl $80  ; chuckie.basm:867
    rts   ; chuckie.basm:868
randomise:  ; chuckie.basm:871
    lda rand1  ; chuckie.basm:873
    and #$48  ; chuckie.basm:874
    adc #$38  ; chuckie.basm:875
    asl a  ; chuckie.basm:876
    asl a  ; chuckie.basm:877
    rol rand4  ; chuckie.basm:878
    rol rand3  ; chuckie.basm:879
    rol rand2  ; chuckie.basm:880
    rol rand1  ; chuckie.basm:881
    rts   ; chuckie.basm:882
add_to_score:  ; chuckie.basm:885
    ldy #$08  ; chuckie.basm:887
    sty sprite_colour_mask_left  ; chuckie.basm:888
    ldy current_score,X  ; chuckie.basm:889
    clc   ; chuckie.basm:890
    adc current_score,X  ; chuckie.basm:891
    cpx #$03  ; chuckie.basm:892
    bne not_ten_thousands_digit  ; chuckie.basm:893
    inc extra_life_flag  ; chuckie.basm:894
not_ten_thousands_digit:  ; chuckie.basm:895
    cmp #$0A  ; chuckie.basm:896
    bcc no_carry  ; chuckie.basm:897
    sec   ; chuckie.basm:898
    sbc #$0A  ; chuckie.basm:899
    sta current_score,X  ; chuckie.basm:900
    jsr draw_current_digit  ; chuckie.basm:901
    lda #$01  ; chuckie.basm:902
    dex   ; chuckie.basm:903
    bpl add_to_score  ; chuckie.basm:904
    rts   ; chuckie.basm:905
no_carry:  ; chuckie.basm:906
    sta current_score,X  ; chuckie.basm:907
draw_current_digit:  ; chuckie.basm:908
    cpx #$02  ; chuckie.basm:909
    bcs visible_digit  ; chuckie.basm:910
    rts   ; chuckie.basm:911
visible_digit:  ; chuckie.basm:912
    sta $8C  ; chuckie.basm:913
    stx $8D  ; chuckie.basm:914
    sty $8E  ; chuckie.basm:915
    lda score_x_position  ; chuckie.basm:916
    clc   ; chuckie.basm:917
x_times_5_loop:  ; chuckie.basm:918
    adc #$05  ; chuckie.basm:919
    dex   ; chuckie.basm:920
    bpl x_times_5_loop  ; chuckie.basm:921
    sta $8B  ; chuckie.basm:922
    tax   ; chuckie.basm:923
    lda $8E  ; chuckie.basm:924
    ldy #$F7  ; chuckie.basm:925
    jsr draw_digit  ; chuckie.basm:926
    lda $8C  ; chuckie.basm:927
    ldx $8B  ; chuckie.basm:928
    ldy #$F7  ; chuckie.basm:929
    jsr draw_digit  ; chuckie.basm:930
    ldx $8D  ; chuckie.basm:931
    rts   ; chuckie.basm:932
draw_digit:  ; chuckie.basm:935
    pha   ; chuckie.basm:937
    jsr calculate_screen_location  ; chuckie.basm:938
    pla   ; chuckie.basm:939
    clc   ; chuckie.basm:940
    adc #$1F  ; chuckie.basm:941
    jsr lookup_sprite  ; chuckie.basm:942
    jsr draw_sprite  ; chuckie.basm:943
    rts   ; chuckie.basm:944
wait_for_interval_timer:  ; chuckie.basm:947
    lda #osword_3_read_interval_timer  ; chuckie.basm:949
    ldx #<((interval_time))  ; chuckie.basm:950
    ldy #>((interval_time))  ; chuckie.basm:950
    jsr osword  ; chuckie.basm:951
    lda $01  ; chuckie.basm:952
    bne reset_timer  ; chuckie.basm:953
    lda $00  ; chuckie.basm:954
    cmp #$03  ; chuckie.basm:955
    bcc wait_for_interval_timer  ; chuckie.basm:956
reset_timer:  ; chuckie.basm:957
    lda #$00  ; chuckie.basm:958
    sta $00  ; chuckie.basm:959
    sta $01  ; chuckie.basm:960
    lda #osword_4_write_interval_timer  ; chuckie.basm:961
    ldx #<((interval_time))  ; chuckie.basm:962
    ldy #>((interval_time))  ; chuckie.basm:962
    jsr osword  ; chuckie.basm:963
    rts   ; chuckie.basm:964
init_and_draw_level:  ; chuckie.basm:967
    lda #$10  ; chuckie.basm:969
    jsr oswrch  ; chuckie.basm:970
    jsr plat_layout_game    ; RP6502: show the rows of the game screen
    jsr draw_game_stats
    lda scenario_number  ; chuckie.basm:972
    asl a  ; chuckie.basm:973
    tay   ; chuckie.basm:974
    lda scenario_lookup_table,Y  ; chuckie.basm:975
    sta scenario_lo  ; chuckie.basm:976
    iny   ; chuckie.basm:977
    lda scenario_lookup_table,Y  ; chuckie.basm:978
    sta scenario_hi  ; chuckie.basm:979
    ldy #$00  ; chuckie.basm:980
    lda (scenario_lo),Y  ; chuckie.basm:981
    sta wall_count  ; chuckie.basm:982
    iny   ; chuckie.basm:983
    lda (scenario_lo),Y  ; chuckie.basm:984
    sta ladder_count  ; chuckie.basm:985
    iny   ; chuckie.basm:986
    lda (scenario_lo),Y  ; chuckie.basm:987
    sta lift_flag  ; chuckie.basm:988
    iny   ; chuckie.basm:989
    lda (scenario_lo),Y  ; chuckie.basm:990
    sta grain_count  ; chuckie.basm:991
    iny   ; chuckie.basm:992
    lda (scenario_lo),Y  ; chuckie.basm:993
    sta chicken_count  ; chuckie.basm:994
    lda #$00  ; chuckie.basm:995
    tax   ; chuckie.basm:996
clear_board_loop:  ; chuckie.basm:997
    sta board_page1,X  ; chuckie.basm:998
    sta board_page2,X  ; chuckie.basm:999
    dex   ; chuckie.basm:1000
    bne clear_board_loop  ; chuckie.basm:1001
    lda #$0A  ; chuckie.basm:1002
    sta sprite_colour_mask_left  ; chuckie.basm:1003
    lda wall_count  ; chuckie.basm:1004
    sta loop_counter  ; chuckie.basm:1005
    sty $89  ; chuckie.basm:1006
wall_loop:  ; chuckie.basm:1007
    ldy $89  ; chuckie.basm:1008
    iny   ; chuckie.basm:1009
    lda (scenario_lo),Y  ; chuckie.basm:1010
    sta $8B  ; chuckie.basm:1011
    iny   ; chuckie.basm:1012
    lda (scenario_lo),Y  ; chuckie.basm:1013
    sta $8C  ; chuckie.basm:1014
    iny   ; chuckie.basm:1015
    lda (scenario_lo),Y  ; chuckie.basm:1016
    sec   ; chuckie.basm:1017
    sbc $8C  ; chuckie.basm:1018
    sta $8D  ; chuckie.basm:1019
    sty $89  ; chuckie.basm:1020
wall_segments_loop:  ; chuckie.basm:1021
    lda #$01  ; chuckie.basm:1022
    ldy $8B  ; chuckie.basm:1023
    ldx $8C  ; chuckie.basm:1024
    jsr board_write  ; chuckie.basm:1025
    ldx $8C  ; chuckie.basm:1026
    jsr draw_sprite_at_text_coords  ; chuckie.basm:1027
    inc $8C  ; chuckie.basm:1028
    dec $8D  ; chuckie.basm:1029
    bpl wall_segments_loop  ; chuckie.basm:1030
    dec loop_counter  ; chuckie.basm:1031
    bne wall_loop  ; chuckie.basm:1032
    lda #$08  ; chuckie.basm:1033
    sta sprite_colour_mask_left  ; chuckie.basm:1034
    lda ladder_count  ; chuckie.basm:1035
    sta loop_counter  ; chuckie.basm:1036
ladder_loop:  ; chuckie.basm:1037
    ldy $89  ; chuckie.basm:1038
    iny   ; chuckie.basm:1039
    lda (scenario_lo),Y  ; chuckie.basm:1040
    sta $8B  ; chuckie.basm:1041
    iny   ; chuckie.basm:1042
    lda (scenario_lo),Y  ; chuckie.basm:1043
    sta $8C  ; chuckie.basm:1044
    iny   ; chuckie.basm:1045
    lda (scenario_lo),Y  ; chuckie.basm:1046
    sec   ; chuckie.basm:1047
    sbc $8C  ; chuckie.basm:1048
    sta $8D  ; chuckie.basm:1049
    sty $89  ; chuckie.basm:1050
ladder_segments_loop:  ; chuckie.basm:1051
    ldx $8B  ; chuckie.basm:1052
    ldy $8C  ; chuckie.basm:1053
    jsr board_read_with_range_check  ; chuckie.basm:1054
    beq no_wall_segment  ; chuckie.basm:1055
    ldx #$0A  ; chuckie.basm:1056
    stx sprite_colour_mask_left  ; chuckie.basm:1057
    ldx $8B  ; chuckie.basm:1058
    jsr draw_sprite_at_text_coords  ; chuckie.basm:1059
    lda #$01  ; chuckie.basm:1060
    ldx #$08  ; chuckie.basm:1061
    stx sprite_colour_mask_left  ; chuckie.basm:1062
no_wall_segment:  ; chuckie.basm:1063
    ora #$02  ; chuckie.basm:1064
    ldx $8B  ; chuckie.basm:1065
    ldy $8C  ; chuckie.basm:1066
    jsr board_write  ; chuckie.basm:1067
    lda #$02  ; chuckie.basm:1068
    ldx $8B  ; chuckie.basm:1069
    ldy $8C  ; chuckie.basm:1070
    jsr draw_sprite_at_text_coords  ; chuckie.basm:1071
    inc $8C  ; chuckie.basm:1072
    dec $8D  ; chuckie.basm:1073
    bpl ladder_segments_loop  ; chuckie.basm:1074
    dec loop_counter  ; chuckie.basm:1075
    bne ladder_loop  ; chuckie.basm:1076
    lda lift_flag  ; chuckie.basm:1077
    beq no_lift_1  ; chuckie.basm:1078
    ldy $89  ; chuckie.basm:1079
    iny   ; chuckie.basm:1080
    lda (scenario_lo),Y  ; chuckie.basm:1081
    sty $89  ; chuckie.basm:1082
    asl a  ; chuckie.basm:1083
    asl a  ; chuckie.basm:1084
    asl a  ; chuckie.basm:1085
    sta lift_x  ; chuckie.basm:1086
no_lift_1:  ; chuckie.basm:1087
    lda #$02  ; chuckie.basm:1088
    sta sprite_colour_mask_left  ; chuckie.basm:1089
    lda #$00  ; chuckie.basm:1090
    sta loop_counter  ; chuckie.basm:1091
    sta egg_remaining_count  ; chuckie.basm:1092
    lda player_data_index  ; chuckie.basm:1093
    sta param  ; chuckie.basm:1094
egg_loop:  ; chuckie.basm:1095
    ldy $89  ; chuckie.basm:1096
    iny   ; chuckie.basm:1097
    lda (scenario_lo),Y  ; chuckie.basm:1098
    sta $8B  ; chuckie.basm:1099
    iny   ; chuckie.basm:1100
    lda (scenario_lo),Y  ; chuckie.basm:1101
    sta $8C  ; chuckie.basm:1102
    sty $89  ; chuckie.basm:1103
    ldx param  ; chuckie.basm:1104
    lda player_egg_flags,X  ; chuckie.basm:1105
    bne egg_collected  ; chuckie.basm:1106
    lda loop_counter  ; chuckie.basm:1107
    asl a  ; chuckie.basm:1108
    asl a  ; chuckie.basm:1109
    asl a  ; chuckie.basm:1110
    asl a  ; chuckie.basm:1111
    adc #$04  ; chuckie.basm:1112
    ldx $8B  ; chuckie.basm:1113
    ldy $8C  ; chuckie.basm:1114
    jsr board_write  ; chuckie.basm:1115
    lda #$03  ; chuckie.basm:1116
    ldx $8B  ; chuckie.basm:1117
    ldy $8C  ; chuckie.basm:1118
    jsr draw_sprite_at_text_coords  ; chuckie.basm:1119
    inc egg_remaining_count  ; chuckie.basm:1120
egg_collected:  ; chuckie.basm:1121
    inc param  ; chuckie.basm:1122
    inc loop_counter  ; chuckie.basm:1123
    lda loop_counter  ; chuckie.basm:1124
    cmp #$0C  ; chuckie.basm:1125
    bcc egg_loop  ; chuckie.basm:1126
    lda #$08  ; chuckie.basm:1127
    sta sprite_colour_mask_left  ; chuckie.basm:1128
    lda #$00  ; chuckie.basm:1129
    sta loop_counter  ; chuckie.basm:1130
    lda player_data_index  ; chuckie.basm:1131
    sta param  ; chuckie.basm:1132
grain_loop:  ; chuckie.basm:1133
    ldy $89  ; chuckie.basm:1134
    iny   ; chuckie.basm:1135
    lda (scenario_lo),Y  ; chuckie.basm:1136
    sta $8B  ; chuckie.basm:1137
    iny   ; chuckie.basm:1138
    lda (scenario_lo),Y  ; chuckie.basm:1139
    sta $8C  ; chuckie.basm:1140
    sty $89  ; chuckie.basm:1141
    ldx param  ; chuckie.basm:1142
    lda player_grain_flags,X  ; chuckie.basm:1143
    bne grain_collected  ; chuckie.basm:1144
    lda loop_counter  ; chuckie.basm:1145
    asl a  ; chuckie.basm:1146
    asl a  ; chuckie.basm:1147
    asl a  ; chuckie.basm:1148
    asl a  ; chuckie.basm:1149
    adc #$08  ; chuckie.basm:1150
    ldx $8B  ; chuckie.basm:1151
    ldy $8C  ; chuckie.basm:1152
    jsr board_write  ; chuckie.basm:1153
    lda #$04  ; chuckie.basm:1154
    ldx $8B  ; chuckie.basm:1155
    ldy $8C  ; chuckie.basm:1156
    jsr draw_sprite_at_text_coords  ; chuckie.basm:1157
grain_collected:  ; chuckie.basm:1158
    inc param  ; chuckie.basm:1159
    inc loop_counter  ; chuckie.basm:1160
    lda loop_counter  ; chuckie.basm:1161
    cmp grain_count  ; chuckie.basm:1162
    bcc grain_loop  ; chuckie.basm:1163
    lda #$20  ; chuckie.basm:1164
    sta sprite_colour_mask_left  ; chuckie.basm:1165
    ldx #$00  ; chuckie.basm:1166
    ldy #$DC  ; chuckie.basm:1167
    jsr calculate_screen_location  ; chuckie.basm:1168
    ldx #$13  ; chuckie.basm:1169
    lda duck_loose_flag  ; chuckie.basm:1170
    beq duck_in_cage_1  ; chuckie.basm:1171
    inx   ; chuckie.basm:1172
duck_in_cage_1:  ; chuckie.basm:1173
    txa   ; chuckie.basm:1174
    jsr lookup_sprite  ; chuckie.basm:1175
    jsr draw_sprite  ; chuckie.basm:1176
    ldy $89  ; chuckie.basm:1177
    ldx #$00  ; chuckie.basm:1178
chicken_loop:  ; chuckie.basm:1179
    iny   ; chuckie.basm:1180
    lda (scenario_lo),Y  ; chuckie.basm:1181
    sta chicken_board_xs,X  ; chuckie.basm:1182
    iny   ; chuckie.basm:1183
    lda (scenario_lo),Y  ; chuckie.basm:1184
    sta chicken_board_ys,X  ; chuckie.basm:1185
    inx   ; chuckie.basm:1186
    cpx #$05  ; chuckie.basm:1187
    bcc chicken_loop  ; chuckie.basm:1188
    rts   ; chuckie.basm:1189
draw_game_stats:  ; chuckie.basm:1190
    lda #$08  ; chuckie.basm:1191
    sta sprite_colour_mask_left  ; chuckie.basm:1192
    ldx #$00  ; chuckie.basm:1193
    ldy #$F8  ; chuckie.basm:1194
    jsr calculate_screen_location  ; chuckie.basm:1195
    lda #$29  ; chuckie.basm:1196
    jsr lookup_sprite  ; chuckie.basm:1197
    jsr draw_sprite  ; chuckie.basm:1198
    ldx player  ; chuckie.basm:1199
    lda #$00  ; chuckie.basm:1200
    clc   ; chuckie.basm:1201
x_times_34_loop_1:  ; chuckie.basm:1202
    adc #$22  ; chuckie.basm:1203
    dex   ; chuckie.basm:1204
    bpl x_times_34_loop_1  ; chuckie.basm:1205
    sec   ; chuckie.basm:1206
    sbc #$07  ; chuckie.basm:1207
    tax   ; chuckie.basm:1208
    ldy #$F8  ; chuckie.basm:1209
    jsr calculate_screen_location  ; chuckie.basm:1210
    lda #$2A  ; chuckie.basm:1211
    jsr lookup_sprite  ; chuckie.basm:1212
    jsr draw_sprite  ; chuckie.basm:1213
    ldx #$00  ; chuckie.basm:1214
    stx param  ; chuckie.basm:1215
draw_player_stats_loop:  ; chuckie.basm:1216
    jsr draw_score_and_lives  ; chuckie.basm:1217
    inc param  ; chuckie.basm:1218
    ldx param  ; chuckie.basm:1219
    cpx player_total_count  ; chuckie.basm:1220
    bcc draw_player_stats_loop  ; chuckie.basm:1221
    lda #$08  ; chuckie.basm:1222
    sta sprite_colour_mask_left  ; chuckie.basm:1223
    ldx #$00  ; chuckie.basm:1224
    ldy #$E8  ; chuckie.basm:1225
    jsr calculate_screen_location  ; chuckie.basm:1226
    lda #$2B  ; chuckie.basm:1227
    jsr lookup_sprite  ; chuckie.basm:1228
    jsr draw_sprite  ; chuckie.basm:1229
    ldx #$1B  ; chuckie.basm:1230
    ldy #$E7  ; chuckie.basm:1231
    jsr calculate_screen_location  ; chuckie.basm:1232
    lda player  ; chuckie.basm:1233
    clc   ; chuckie.basm:1234
    adc #$20  ; chuckie.basm:1235
    jsr lookup_sprite  ; chuckie.basm:1236
    jsr draw_sprite  ; chuckie.basm:1237
    ldx #$24  ; chuckie.basm:1238
    ldy #$E8  ; chuckie.basm:1239
    jsr calculate_screen_location  ; chuckie.basm:1240
    lda #$2C  ; chuckie.basm:1241
    jsr lookup_sprite  ; chuckie.basm:1242
    jsr draw_sprite  ; chuckie.basm:1243
    lda #$00  ; chuckie.basm:1244
    sta $8B  ; chuckie.basm:1245
    sta $8C  ; chuckie.basm:1246
    ldx level_number  ; chuckie.basm:1247
    inx   ; chuckie.basm:1248
    stx $8D  ; chuckie.basm:1249
    lda $8D  ; chuckie.basm:1250
    ldx #$00  ; chuckie.basm:1251
div_mod_10_loop_a:  ; chuckie.basm:1252
    cmp #$0A  ; chuckie.basm:1253
    bcc less_than_10_a  ; chuckie.basm:1254
    sec   ; chuckie.basm:1255
    sbc #$0A  ; chuckie.basm:1256
    inx   ; chuckie.basm:1257
    jmp div_mod_10_loop_a  ; chuckie.basm:1258
less_than_10_a:  ; chuckie.basm:1259
    sta $8D  ; chuckie.basm:1260
    txa   ; chuckie.basm:1261
    ldx #$00  ; chuckie.basm:1262
div_mod_10_loop_b:  ; chuckie.basm:1263
    cmp #$0A  ; chuckie.basm:1264
    bcc less_than_10_b  ; chuckie.basm:1265
    sec   ; chuckie.basm:1266
    sbc #$0A  ; chuckie.basm:1267
    inx   ; chuckie.basm:1268
    jmp div_mod_10_loop_b  ; chuckie.basm:1269
less_than_10_b:  ; chuckie.basm:1270
    sta $8C  ; chuckie.basm:1271
    stx $8B  ; chuckie.basm:1272
    lda $8B  ; chuckie.basm:1273
    beq skip_zero_hundreds  ; chuckie.basm:1274
    ldx #$3B  ; chuckie.basm:1275
    ldy #$E7  ; chuckie.basm:1276
    jsr draw_digit  ; chuckie.basm:1277
skip_zero_hundreds:  ; chuckie.basm:1278
    lda $8C  ; chuckie.basm:1279
    ldx #$40  ; chuckie.basm:1280
    ldy #$E7  ; chuckie.basm:1281
    jsr draw_digit  ; chuckie.basm:1282
    lda $8D  ; chuckie.basm:1283
    ldx #$45  ; chuckie.basm:1284
    ldy #$E7  ; chuckie.basm:1285
    jsr draw_digit  ; chuckie.basm:1286
    ldx #$4E  ; chuckie.basm:1287
    ldy #$E8  ; chuckie.basm:1288
    jsr calculate_screen_location  ; chuckie.basm:1289
    lda #$2D  ; chuckie.basm:1290
    jsr lookup_sprite  ; chuckie.basm:1291
    jsr draw_sprite  ; chuckie.basm:1292
    lda bonus_3  ; chuckie.basm:1293
    ldx #$66  ; chuckie.basm:1294
    ldy #$E7  ; chuckie.basm:1295
    jsr draw_digit  ; chuckie.basm:1296
    lda bonus_2  ; chuckie.basm:1297
    ldx #$6B  ; chuckie.basm:1298
    ldy #$E7  ; chuckie.basm:1299
    jsr draw_digit  ; chuckie.basm:1300
    lda bonus_1  ; chuckie.basm:1301
    ldx #$70  ; chuckie.basm:1302
    ldy #$E7  ; chuckie.basm:1303
    jsr draw_digit  ; chuckie.basm:1304
    lda #$00  ; chuckie.basm:1305
    ldx #$75  ; chuckie.basm:1306
    ldy #$E7  ; chuckie.basm:1307
    jsr draw_digit  ; chuckie.basm:1308
    ldx #$7E  ; chuckie.basm:1309
    ldy #$E8  ; chuckie.basm:1310
    jsr calculate_screen_location  ; chuckie.basm:1311
    lda #$2E  ; chuckie.basm:1312
    jsr lookup_sprite  ; chuckie.basm:1313
    jsr draw_sprite  ; chuckie.basm:1314
    lda round_number  ; chuckie.basm:1315
    lsr a  ; chuckie.basm:1316
    cmp #$08  ; chuckie.basm:1317
    bcc round_less_than_8  ; chuckie.basm:1318
    lda #$08  ; chuckie.basm:1319
round_less_than_8:  ; chuckie.basm:1320
    eor #$FF  ; chuckie.basm:1321
    sec   ; chuckie.basm:1322
    adc #$09  ; chuckie.basm:1323
    sta timer_2  ; chuckie.basm:1324
    ldx #$91  ; chuckie.basm:1325
    ldy #$E7  ; chuckie.basm:1326
    jsr draw_digit  ; chuckie.basm:1327
    lda #$00  ; chuckie.basm:1328
    sta timer_1  ; chuckie.basm:1329
    ldx #$96  ; chuckie.basm:1330
    ldy #$E7  ; chuckie.basm:1331
    jsr draw_digit  ; chuckie.basm:1332
    lda #$00  ; chuckie.basm:1333
    sta timer_0  ; chuckie.basm:1334
    ldx #$9B  ; chuckie.basm:1335
    ldy #$E7  ; chuckie.basm:1336
    jsr draw_digit  ; chuckie.basm:1337
    rts   ; chuckie.basm:1338
draw_score_and_lives:  ; chuckie.basm:1339
    lda #$00  ; chuckie.basm:1340
    clc   ; chuckie.basm:1341
x_times_34_loop_b:  ; chuckie.basm:1342
    adc #$22  ; chuckie.basm:1343
    dex   ; chuckie.basm:1344
    bpl x_times_34_loop_b  ; chuckie.basm:1345
    sec   ; chuckie.basm:1346
    sbc #$07  ; chuckie.basm:1347
    sta $8B  ; chuckie.basm:1348
    lda #$08  ; chuckie.basm:1349
    sta sprite_colour_mask_left  ; chuckie.basm:1350
    lda param  ; chuckie.basm:1351
    asl a  ; chuckie.basm:1352
    asl a  ; chuckie.basm:1353
    asl a  ; chuckie.basm:1354
    asl a  ; chuckie.basm:1355
    asl a  ; chuckie.basm:1356
    asl a  ; chuckie.basm:1357
    tax   ; chuckie.basm:1358
    inx   ; chuckie.basm:1359
    inx   ; chuckie.basm:1360
    stx $8D  ; chuckie.basm:1361
    ldx $8B  ; chuckie.basm:1362
    inx   ; chuckie.basm:1363
    stx $8C  ; chuckie.basm:1364
    lda #$06  ; chuckie.basm:1365
    sta $8E  ; chuckie.basm:1366
draw_digits_loop:  ; chuckie.basm:1367
    ldx $8D  ; chuckie.basm:1368
    lda player_score,X  ; chuckie.basm:1369
    ldx $8C  ; chuckie.basm:1370
    ldy #$F7  ; chuckie.basm:1371
    jsr draw_digit  ; chuckie.basm:1372
    lda $8C  ; chuckie.basm:1373
    clc   ; chuckie.basm:1374
    adc #$05  ; chuckie.basm:1375
    sta $8C  ; chuckie.basm:1376
    inc $8D  ; chuckie.basm:1377
    dec $8E  ; chuckie.basm:1378
    bne draw_digits_loop  ; chuckie.basm:1379
    lda #$20  ; chuckie.basm:1380
    sta sprite_colour_mask_left  ; chuckie.basm:1381
    ldx param  ; chuckie.basm:1382
    lda player_lives,X  ; chuckie.basm:1383
    beq no_lives_left  ; chuckie.basm:1384
    cmp #$08  ; chuckie.basm:1385
    bcc lives_less_than_8  ; chuckie.basm:1386
    lda #$08  ; chuckie.basm:1387
lives_less_than_8:  ; chuckie.basm:1388
    sta $8E  ; chuckie.basm:1389
    lda $8B  ; chuckie.basm:1390
    sta $8C  ; chuckie.basm:1391
draw_pips_loop:  ; chuckie.basm:1392
    ldx $8C  ; chuckie.basm:1393
    ldy #$EE  ; chuckie.basm:1394
    jsr calculate_screen_location  ; chuckie.basm:1395
    lda #$2F  ; chuckie.basm:1396
    jsr lookup_sprite  ; chuckie.basm:1397
    jsr draw_sprite  ; chuckie.basm:1398
    dec $8E  ; chuckie.basm:1399
    beq no_lives_left  ; chuckie.basm:1400
    lda $8C  ; chuckie.basm:1401
    clc   ; chuckie.basm:1402
    adc #$04  ; chuckie.basm:1403
    sta $8C  ; chuckie.basm:1404
    jmp draw_pips_loop  ; chuckie.basm:1405
no_lives_left:  ; chuckie.basm:1406
    rts   ; chuckie.basm:1407
update_harry:  ; chuckie.basm:1410
    lda #$00  ; chuckie.basm:1412
    sta harry_dx  ; chuckie.basm:1413
    sta harry_dy  ; chuckie.basm:1414
    lda key_press_bits  ; chuckie.basm:1415
    lsr a  ; chuckie.basm:1416
    bcc not_right_key  ; chuckie.basm:1417
    inc harry_dx  ; chuckie.basm:1418
not_right_key:  ; chuckie.basm:1419
    lsr a  ; chuckie.basm:1420
    bcc not_left_key  ; chuckie.basm:1421
    dec harry_dx  ; chuckie.basm:1422
not_left_key:  ; chuckie.basm:1423
    lsr a  ; chuckie.basm:1424
    bcc not_down_key  ; chuckie.basm:1425
    dec harry_dy  ; chuckie.basm:1426
not_down_key:  ; chuckie.basm:1427
    lsr a  ; chuckie.basm:1428
    bcc not_up_key  ; chuckie.basm:1429
    inc harry_dy  ; chuckie.basm:1430
not_up_key:  ; chuckie.basm:1431
    asl harry_dy  ; chuckie.basm:1432
    lda harry_state  ; chuckie.basm:1433
    beq state_zero  ; chuckie.basm:1434
    cmp #$02  ; chuckie.basm:1435
    bne state_not_two  ; chuckie.basm:1436
    jmp state_two_within_jump  ; chuckie.basm:1437
state_not_two:  ; chuckie.basm:1438
    bcs state_greater_than_two  ; chuckie.basm:1439
    jmp state_one_on_ladder  ; chuckie.basm:1440
state_greater_than_two:  ; chuckie.basm:1441
    cmp #$03  ; chuckie.basm:1442
    bne state_greater_than_three  ; chuckie.basm:1443
    jmp state_three_falling  ; chuckie.basm:1444
state_greater_than_three:  ; chuckie.basm:1445
    jmp state_four_on_lift  ; chuckie.basm:1446
state_zero:  ; chuckie.basm:1447
    lda key_press_bits  ; chuckie.basm:1448
    and #$10  ; chuckie.basm:1449
    beq not_jump_key  ; chuckie.basm:1450
    jmp start_jump  ; chuckie.basm:1451
not_jump_key:  ; chuckie.basm:1452
    lda harry_dy  ; chuckie.basm:1453
    beq not_ladder  ; chuckie.basm:1454
    ldx harry_cell_x  ; chuckie.basm:1455
    cpx #$03  ; chuckie.basm:1456
    bne not_ladder  ; chuckie.basm:1457
    lda harry_dy  ; chuckie.basm:1458
    bmi try_going_down  ; chuckie.basm:1459
    ldx harry_board_x  ; chuckie.basm:1460
    ldy harry_board_y  ; chuckie.basm:1461
    iny   ; chuckie.basm:1462
    iny   ; chuckie.basm:1463
    jsr board_read_with_range_check  ; chuckie.basm:1464
    and #$02  ; chuckie.basm:1465
    beq not_ladder  ; chuckie.basm:1466
    bne do_ladder_start  ; chuckie.basm:1467
try_going_down:  ; chuckie.basm:1468
    ldx harry_board_x  ; chuckie.basm:1469
    ldy harry_board_y  ; chuckie.basm:1470
    dey   ; chuckie.basm:1471
    jsr board_read_with_range_check  ; chuckie.basm:1472
    and #$02  ; chuckie.basm:1473
    beq not_ladder  ; chuckie.basm:1474
do_ladder_start:  ; chuckie.basm:1475
    lda #$00  ; chuckie.basm:1476
    sta harry_dx  ; chuckie.basm:1477
    lda #$01  ; chuckie.basm:1478
    sta harry_state  ; chuckie.basm:1479
    jmp update_facing  ; chuckie.basm:1480
not_ladder:  ; chuckie.basm:1481
    lda #$00  ; chuckie.basm:1482
    sta harry_dy  ; chuckie.basm:1483
    lda harry_cell_x  ; chuckie.basm:1484
    clc   ; chuckie.basm:1485
    adc harry_dx  ; chuckie.basm:1486
    ldx harry_board_x  ; chuckie.basm:1487
    cmp #$00  ; chuckie.basm:1488
    bpl not_entering_left_cell  ; chuckie.basm:1489
    dex   ; chuckie.basm:1490
not_entering_left_cell:  ; chuckie.basm:1491
    cmp #$08  ; chuckie.basm:1492
    bmi not_entering_right_cell  ; chuckie.basm:1493
    inx   ; chuckie.basm:1494
not_entering_right_cell:  ; chuckie.basm:1495
    ldy harry_board_y  ; chuckie.basm:1496
    dey   ; chuckie.basm:1497
    jsr board_read_with_range_check  ; chuckie.basm:1498
    and #$01  ; chuckie.basm:1499
    bne cell_has_wall  ; chuckie.basm:1500
    tay   ; chuckie.basm:1501
    ldx #$FF  ; chuckie.basm:1502
    lda harry_dx  ; chuckie.basm:1503
    clc   ; chuckie.basm:1504
    adc harry_cell_x  ; chuckie.basm:1505
    and #$07  ; chuckie.basm:1506
    cmp #$04  ; chuckie.basm:1507
    bcs falling_left  ; chuckie.basm:1508
    ldx #$01  ; chuckie.basm:1509
    iny   ; chuckie.basm:1510
falling_left:  ; chuckie.basm:1511
    stx harry_fall_facing  ; chuckie.basm:1512
    sty harry_fall_scaled_vy  ; chuckie.basm:1513
    lda #$03  ; chuckie.basm:1514
    sta harry_state  ; chuckie.basm:1515
cell_has_wall:  ; chuckie.basm:1516
    jsr test_horizontal_obstructions  ; chuckie.basm:1517
    bcc update_facing  ; chuckie.basm:1518
    lda #$00  ; chuckie.basm:1519
    sta harry_dx  ; chuckie.basm:1520
update_facing:  ; chuckie.basm:1521
    lda harry_dx  ; chuckie.basm:1522
    beq skip_update_facing  ; chuckie.basm:1523
    sta harry_facing  ; chuckie.basm:1524
skip_update_facing:  ; chuckie.basm:1525
    jmp harry_apply_dx_dy  ; chuckie.basm:1526
state_one_on_ladder:  ; chuckie.basm:1527
    lda key_press_bits  ; chuckie.basm:1528
    and #$10  ; chuckie.basm:1529
    beq not_jump_from_ladder  ; chuckie.basm:1530
    jmp start_jump  ; chuckie.basm:1531
not_jump_from_ladder:  ; chuckie.basm:1532
    lda harry_dx  ; chuckie.basm:1533
    beq not_sideways_from_ladder  ; chuckie.basm:1534
    ldx harry_cell_y  ; chuckie.basm:1535
    bne not_sideways_from_ladder  ; chuckie.basm:1536
    ldx harry_board_x  ; chuckie.basm:1537
    ldy harry_board_y  ; chuckie.basm:1538
    dey   ; chuckie.basm:1539
    jsr board_read_with_range_check  ; chuckie.basm:1540
    and #$01  ; chuckie.basm:1541
    beq not_sideways_from_ladder  ; chuckie.basm:1542
    lda #$00  ; chuckie.basm:1543
    sta harry_dy  ; chuckie.basm:1544
    lda #$00  ; chuckie.basm:1545
    sta harry_state  ; chuckie.basm:1546
    jmp set_harry_facing_ladder  ; chuckie.basm:1547
not_sideways_from_ladder:  ; chuckie.basm:1548
    lda #$00  ; chuckie.basm:1549
    sta harry_dx  ; chuckie.basm:1550
    lda harry_dy  ; chuckie.basm:1551
    beq set_harry_facing_ladder  ; chuckie.basm:1552
    lda harry_cell_y  ; chuckie.basm:1553
    bne set_harry_facing_ladder  ; chuckie.basm:1554
    lda harry_dy  ; chuckie.basm:1555
    bmi ladder_going_down  ; chuckie.basm:1556
    ldx harry_board_x  ; chuckie.basm:1557
    ldy harry_board_y  ; chuckie.basm:1558
    iny   ; chuckie.basm:1559
    iny   ; chuckie.basm:1560
    jsr board_read_with_range_check  ; chuckie.basm:1561
    and #$02  ; chuckie.basm:1562
    bne set_harry_facing_ladder  ; chuckie.basm:1563
    sta harry_dy  ; chuckie.basm:1564
    jmp set_harry_facing_ladder  ; chuckie.basm:1565
ladder_going_down:  ; chuckie.basm:1566
    ldx harry_board_x  ; chuckie.basm:1567
    ldy harry_board_y  ; chuckie.basm:1568
    dey   ; chuckie.basm:1569
    jsr board_read_with_range_check  ; chuckie.basm:1570
    and #$02  ; chuckie.basm:1571
    bne set_harry_facing_ladder  ; chuckie.basm:1572
    sta harry_dy  ; chuckie.basm:1573
set_harry_facing_ladder:  ; chuckie.basm:1574
    lda #$00  ; chuckie.basm:1575
    sta harry_facing  ; chuckie.basm:1576
    jmp harry_apply_dx_dy  ; chuckie.basm:1577
state_two_within_jump:  ; chuckie.basm:1578
    lda harry_fall_facing  ; chuckie.basm:1579
    sta harry_dx  ; chuckie.basm:1580
    lda harry_dy  ; chuckie.basm:1581
    sta $89  ; chuckie.basm:1582
    lda harry_fall_scaled_vy  ; chuckie.basm:1583
    lsr a  ; chuckie.basm:1584
    lsr a  ; chuckie.basm:1585
    cmp #$06  ; chuckie.basm:1586
    bcc vy_in_range  ; chuckie.basm:1587
    lda #$06  ; chuckie.basm:1588
vy_in_range:  ; chuckie.basm:1589
    eor #$FF  ; chuckie.basm:1590
    sec   ; chuckie.basm:1591
    adc #$02  ; chuckie.basm:1592
    sta harry_dy  ; chuckie.basm:1593
    inc harry_fall_scaled_vy  ; chuckie.basm:1594
    lda harry_y  ; chuckie.basm:1595
    cmp #$DC  ; chuckie.basm:1596
    bcc not_bounce_off_top  ; chuckie.basm:1597
    lda #$FF  ; chuckie.basm:1598
    sta harry_dy  ; chuckie.basm:1599
    lda #$0C  ; chuckie.basm:1600
    sta harry_fall_scaled_vy  ; chuckie.basm:1601
    jmp test_lift_collision  ; chuckie.basm:1602
not_bounce_off_top:  ; chuckie.basm:1603
    lda harry_cell_x  ; chuckie.basm:1604
    clc   ; chuckie.basm:1605
    adc harry_dx  ; chuckie.basm:1606
    cmp #$03  ; chuckie.basm:1607
    bne not_grabbing_ladder  ; chuckie.basm:1608
    lda $89  ; chuckie.basm:1609
    beq not_grabbing_ladder  ; chuckie.basm:1610
    bmi test_grab_ladder_with_down_key  ; chuckie.basm:1611
comment_jumping_up_in_middle_of_cell:  ; chuckie.basm:1612
    ldx harry_board_x  ; chuckie.basm:1613
    ldy harry_board_y  ; chuckie.basm:1614
    iny   ; chuckie.basm:1615
    jsr board_read_with_range_check  ; chuckie.basm:1616
    and #$02  ; chuckie.basm:1617
    bne grab_ladder_with_up_key  ; chuckie.basm:1618
    ldx harry_board_x  ; chuckie.basm:1619
    ldy harry_board_y  ; chuckie.basm:1620
    iny   ; chuckie.basm:1621
    lda harry_cell_y  ; chuckie.basm:1622
    cmp #$04  ; chuckie.basm:1623
    bcc harry_in_bottom_half_of_cell_2  ; chuckie.basm:1624
    iny   ; chuckie.basm:1625
harry_in_bottom_half_of_cell_2:  ; chuckie.basm:1626
    jsr board_read_with_range_check  ; chuckie.basm:1627
    and #$02  ; chuckie.basm:1628
    beq not_grabbing_ladder  ; chuckie.basm:1629
grab_ladder_with_up_key:  ; chuckie.basm:1630
    lda #$01  ; chuckie.basm:1631
    sta harry_state  ; chuckie.basm:1632
    lda harry_cell_y  ; chuckie.basm:1633
    clc   ; chuckie.basm:1634
    adc harry_dy  ; chuckie.basm:1635
    and #$01  ; chuckie.basm:1636
    beq up_grab_position_already_even  ; chuckie.basm:1637
    inc harry_dy  ; chuckie.basm:1638
up_grab_position_already_even:  ; chuckie.basm:1639
    jmp no_horizontal_bounce  ; chuckie.basm:1640
test_grab_ladder_with_down_key:  ; chuckie.basm:1641
    ldx harry_board_x  ; chuckie.basm:1642
    ldy harry_board_y  ; chuckie.basm:1643
    jsr board_read_with_range_check  ; chuckie.basm:1644
    and #$02  ; chuckie.basm:1645
    beq not_grabbing_ladder  ; chuckie.basm:1646
    ldx harry_board_x  ; chuckie.basm:1647
    ldy harry_board_y  ; chuckie.basm:1648
    iny   ; chuckie.basm:1649
    jsr board_read_with_range_check  ; chuckie.basm:1650
    and #$02  ; chuckie.basm:1651
    beq not_grabbing_ladder  ; chuckie.basm:1652
    lda #$01  ; chuckie.basm:1653
    sta harry_state  ; chuckie.basm:1654
    lda harry_cell_y  ; chuckie.basm:1655
    clc   ; chuckie.basm:1656
    adc harry_dy  ; chuckie.basm:1657
    and #$01  ; chuckie.basm:1658
    beq down_grab_position_already_even  ; chuckie.basm:1659
    dec harry_dy  ; chuckie.basm:1660
down_grab_position_already_even:  ; chuckie.basm:1661
    jmp no_horizontal_bounce  ; chuckie.basm:1662
not_grabbing_ladder:  ; chuckie.basm:1663
    lda harry_dy  ; chuckie.basm:1664
    clc   ; chuckie.basm:1665
    adc harry_cell_y  ; chuckie.basm:1666
    beq test_jump_landing_on_wall  ; chuckie.basm:1667
    bpl test_hop_up  ; chuckie.basm:1668
    ldx harry_board_x  ; chuckie.basm:1669
    ldy harry_board_y  ; chuckie.basm:1670
    dey   ; chuckie.basm:1671
    jsr board_read_with_range_check  ; chuckie.basm:1672
    and #$01  ; chuckie.basm:1673
    beq test_lift_collision  ; chuckie.basm:1674
    lda #$00  ; chuckie.basm:1675
    sta harry_state  ; chuckie.basm:1676
    lda #$00  ; chuckie.basm:1677
    sec   ; chuckie.basm:1678
    sbc harry_cell_y  ; chuckie.basm:1679
    sta harry_dy  ; chuckie.basm:1680
    jmp test_lift_collision  ; chuckie.basm:1681
test_jump_landing_on_wall:  ; chuckie.basm:1682
    ldx harry_board_x  ; chuckie.basm:1683
    ldy harry_board_y  ; chuckie.basm:1684
    dey   ; chuckie.basm:1685
    jsr board_read_with_range_check  ; chuckie.basm:1686
    and #$01  ; chuckie.basm:1687
    beq test_lift_collision  ; chuckie.basm:1688
    lda #$00  ; chuckie.basm:1689
    sta harry_state  ; chuckie.basm:1690
    jmp test_lift_collision  ; chuckie.basm:1691
test_hop_up:  ; chuckie.basm:1692
    cmp #$08  ; chuckie.basm:1693
    bne test_lift_collision  ; chuckie.basm:1694
    ldx harry_board_x  ; chuckie.basm:1695
    ldy harry_board_y  ; chuckie.basm:1696
    jsr board_read_with_range_check  ; chuckie.basm:1697
    and #$01  ; chuckie.basm:1698
    beq test_lift_collision  ; chuckie.basm:1699
    lda #$00  ; chuckie.basm:1700
    sta harry_state  ; chuckie.basm:1701
    jmp test_lift_collision  ; chuckie.basm:1702
test_lift_collision:  ; chuckie.basm:1703
    lda lift_flag  ; chuckie.basm:1704
    beq no_lift_2  ; chuckie.basm:1705
    lda lift_x  ; chuckie.basm:1706
    sec   ; chuckie.basm:1707
    sbc #$01  ; chuckie.basm:1708
    cmp harry_x  ; chuckie.basm:1709
    bcs no_lift_2  ; chuckie.basm:1710
    adc #$0A  ; chuckie.basm:1711
    cmp harry_x  ; chuckie.basm:1712
    bcc no_lift_2  ; chuckie.basm:1713
    lda harry_y  ; chuckie.basm:1714
    sec   ; chuckie.basm:1715
    sbc #$11  ; chuckie.basm:1716
    sta $8B  ; chuckie.basm:1717
    sbc #$02  ; chuckie.basm:1718
    clc   ; chuckie.basm:1719
    adc harry_dy  ; chuckie.basm:1720
    sta $8C  ; chuckie.basm:1721
    lda lift_y1  ; chuckie.basm:1722
    cmp $8B  ; chuckie.basm:1723
    beq join_lift_one  ; chuckie.basm:1724
    bcs try_lift_two  ; chuckie.basm:1725
    cmp $8C  ; chuckie.basm:1726
    bcc try_lift_two  ; chuckie.basm:1727
join_lift_one:  ; chuckie.basm:1728
    ldx lift_alternator  ; chuckie.basm:1729
    bne other_lift_moving  ; chuckie.basm:1730
    clc   ; chuckie.basm:1731
    adc #$01  ; chuckie.basm:1732
other_lift_moving:  ; chuckie.basm:1733
    jmp join_a_lift  ; chuckie.basm:1734
try_lift_two:  ; chuckie.basm:1735
    lda lift_y2  ; chuckie.basm:1736
    cmp $8B  ; chuckie.basm:1737
    beq join_lift_two  ; chuckie.basm:1738
    bcs no_lift_2  ; chuckie.basm:1739
    cmp $8C  ; chuckie.basm:1740
    bcc no_lift_2  ; chuckie.basm:1741
join_lift_two:  ; chuckie.basm:1742
    ldx lift_alternator  ; chuckie.basm:1743
    beq join_a_lift  ; chuckie.basm:1744
    clc   ; chuckie.basm:1745
    adc #$01  ; chuckie.basm:1746
join_a_lift:  ; chuckie.basm:1747
    sec   ; chuckie.basm:1748
    sbc $8B  ; chuckie.basm:1749
    clc   ; chuckie.basm:1750
    adc #$01  ; chuckie.basm:1751
    sta harry_dy  ; chuckie.basm:1752
    lda #$00  ; chuckie.basm:1753
    sta harry_fall_scaled_vy  ; chuckie.basm:1754
    lda #$04  ; chuckie.basm:1755
    sta harry_state  ; chuckie.basm:1756
    jmp no_horizontal_bounce  ; chuckie.basm:1757
no_lift_2:  ; chuckie.basm:1758
    jsr test_horizontal_obstructions  ; chuckie.basm:1759
    bcc no_horizontal_bounce  ; chuckie.basm:1760
    lda #$00  ; chuckie.basm:1761
    sec   ; chuckie.basm:1762
    sbc harry_dx  ; chuckie.basm:1763
    sta harry_dx  ; chuckie.basm:1764
    sta harry_fall_facing  ; chuckie.basm:1765
no_horizontal_bounce:  ; chuckie.basm:1766
    jmp harry_apply_dx_dy  ; chuckie.basm:1767
start_jump:  ; chuckie.basm:1768
    lda #$00  ; chuckie.basm:1769
    sta harry_fall_scaled_vy  ; chuckie.basm:1770
    lda #$02  ; chuckie.basm:1771
    sta harry_state  ; chuckie.basm:1772
    lda harry_dx  ; chuckie.basm:1773
    sta harry_fall_facing  ; chuckie.basm:1774
    beq falling_straight_retain_facing  ; chuckie.basm:1775
    sta harry_facing  ; chuckie.basm:1776
falling_straight_retain_facing:  ; chuckie.basm:1777
    jmp state_two_within_jump  ; chuckie.basm:1778
state_three_falling:  ; chuckie.basm:1779
    inc harry_fall_scaled_vy  ; chuckie.basm:1780
    lda harry_fall_scaled_vy  ; chuckie.basm:1781
    cmp #$04  ; chuckie.basm:1782
    bcs falling_faster  ; chuckie.basm:1783
    lda harry_fall_facing  ; chuckie.basm:1784
    sta harry_dx  ; chuckie.basm:1785
    lda #$FF  ; chuckie.basm:1786
    sta harry_dy  ; chuckie.basm:1787
    jmp test_fall_landing  ; chuckie.basm:1788
falling_faster:  ; chuckie.basm:1789
    lda #$00  ; chuckie.basm:1790
    sta harry_dx  ; chuckie.basm:1791
    lda harry_fall_scaled_vy  ; chuckie.basm:1792
    lsr a  ; chuckie.basm:1793
    lsr a  ; chuckie.basm:1794
    cmp #$04  ; chuckie.basm:1795
    bcc scaled_vy_in_range  ; chuckie.basm:1796
    lda #$03  ; chuckie.basm:1797
scaled_vy_in_range:  ; chuckie.basm:1798
    eor #$FF  ; chuckie.basm:1799
    sta harry_dy  ; chuckie.basm:1800
test_fall_landing:  ; chuckie.basm:1801
    lda harry_dy  ; chuckie.basm:1802
    clc   ; chuckie.basm:1803
    adc harry_cell_y  ; chuckie.basm:1804
    beq test_fall_landing_on_wall  ; chuckie.basm:1805
    bpl fall_processing_complete  ; chuckie.basm:1806
    ldx harry_board_x  ; chuckie.basm:1807
    ldy harry_board_y  ; chuckie.basm:1808
    dey   ; chuckie.basm:1809
    jsr board_read_with_range_check  ; chuckie.basm:1810
    and #$01  ; chuckie.basm:1811
    beq fall_processing_complete  ; chuckie.basm:1812
    lda #$00  ; chuckie.basm:1813
    sta harry_state  ; chuckie.basm:1814
    lda #$00  ; chuckie.basm:1815
    sec   ; chuckie.basm:1816
    sbc harry_cell_y  ; chuckie.basm:1817
    sta harry_dy  ; chuckie.basm:1818
    jmp fall_processing_complete  ; chuckie.basm:1819
test_fall_landing_on_wall:  ; chuckie.basm:1820
    ldx harry_board_x  ; chuckie.basm:1821
    ldy harry_board_y  ; chuckie.basm:1822
    dey   ; chuckie.basm:1823
    jsr board_read_with_range_check  ; chuckie.basm:1824
    and #$01  ; chuckie.basm:1825
    beq fall_processing_complete  ; chuckie.basm:1826
    lda #$00  ; chuckie.basm:1827
    sta harry_state  ; chuckie.basm:1828
fall_processing_complete:  ; chuckie.basm:1829
    jmp harry_apply_dx_dy  ; chuckie.basm:1830
state_four_on_lift:  ; chuckie.basm:1831
    lda key_press_bits  ; chuckie.basm:1832
    and #$10  ; chuckie.basm:1833
    beq not_jump_from_lift  ; chuckie.basm:1834
    jmp start_jump  ; chuckie.basm:1835
not_jump_from_lift:  ; chuckie.basm:1836
    lda lift_x  ; chuckie.basm:1837
    sec   ; chuckie.basm:1838
    sbc #$01  ; chuckie.basm:1839
    cmp harry_x  ; chuckie.basm:1840
    bcs fall_from_lift  ; chuckie.basm:1841
    adc #$0A  ; chuckie.basm:1842
    cmp harry_x  ; chuckie.basm:1843
    bcs not_fall_from_lift  ; chuckie.basm:1844
fall_from_lift:  ; chuckie.basm:1845
    lda #$00  ; chuckie.basm:1846
    sta harry_fall_scaled_vy  ; chuckie.basm:1847
    sta harry_fall_facing  ; chuckie.basm:1848
    lda #$03  ; chuckie.basm:1849
    sta harry_state  ; chuckie.basm:1850
not_fall_from_lift:  ; chuckie.basm:1851
    lda #$01  ; chuckie.basm:1852
    sta harry_dy  ; chuckie.basm:1853
    lda harry_dx  ; chuckie.basm:1854
    beq not_moving_retain_facing  ; chuckie.basm:1855
    sta harry_facing  ; chuckie.basm:1856
not_moving_retain_facing:  ; chuckie.basm:1857
    jsr test_horizontal_obstructions  ; chuckie.basm:1858
    bcc horizontal_movement_clear  ; chuckie.basm:1859
    lda #$00  ; chuckie.basm:1860
    sta harry_dx  ; chuckie.basm:1861
horizontal_movement_clear:  ; chuckie.basm:1862
    lda harry_y  ; chuckie.basm:1863
    cmp #$DC  ; chuckie.basm:1864
    bcc harry_apply_dx_dy  ; chuckie.basm:1865
    inc dead_flag  ; chuckie.basm:1866
harry_apply_dx_dy:  ; chuckie.basm:1867
    lda harry_sprite_index  ; chuckie.basm:1868
    jsr draw_harry  ; chuckie.basm:1869
    lda harry_x  ; chuckie.basm:1870
    clc   ; chuckie.basm:1871
    adc harry_dx  ; chuckie.basm:1872
    sta harry_x  ; chuckie.basm:1873
    lda harry_cell_x  ; chuckie.basm:1874
    clc   ; chuckie.basm:1875
    adc harry_dx  ; chuckie.basm:1876
    bpl not_move_to_left_cell  ; chuckie.basm:1877
    dec harry_board_x  ; chuckie.basm:1878
not_move_to_left_cell:  ; chuckie.basm:1879
    cmp #$08  ; chuckie.basm:1880
    bmi not_move_to_right_cell  ; chuckie.basm:1881
    inc harry_board_x  ; chuckie.basm:1882
not_move_to_right_cell:  ; chuckie.basm:1883
    and #$07  ; chuckie.basm:1884
    sta harry_cell_x  ; chuckie.basm:1885
    lda harry_y  ; chuckie.basm:1886
    clc   ; chuckie.basm:1887
    adc harry_dy  ; chuckie.basm:1888
    sta harry_y  ; chuckie.basm:1889
    lda harry_cell_y  ; chuckie.basm:1890
    clc   ; chuckie.basm:1891
    adc harry_dy  ; chuckie.basm:1892
    bpl not_move_to_down_cell  ; chuckie.basm:1893
    dec harry_board_y  ; chuckie.basm:1894
not_move_to_down_cell:  ; chuckie.basm:1895
    cmp #$08  ; chuckie.basm:1896
    bmi not_move_to_up_cell  ; chuckie.basm:1897
    inc harry_board_y  ; chuckie.basm:1898
not_move_to_up_cell:  ; chuckie.basm:1899
    and #$07  ; chuckie.basm:1900
    sta harry_cell_y  ; chuckie.basm:1901
    ldx #$06  ; chuckie.basm:1902
    lda harry_facing  ; chuckie.basm:1903
    beq harry_facing_ladder  ; chuckie.basm:1904
    bpl harry_not_facing_left  ; chuckie.basm:1905
    ldx #$09  ; chuckie.basm:1906
harry_not_facing_left:  ; chuckie.basm:1907
    stx param  ; chuckie.basm:1908
    lda harry_cell_x  ; chuckie.basm:1909
    lsr a  ; chuckie.basm:1910
    jmp harry_calculate_frame  ; chuckie.basm:1911
harry_facing_ladder:  ; chuckie.basm:1912
    lda #$0C  ; chuckie.basm:1913
    sta param  ; chuckie.basm:1914
    lda harry_cell_y  ; chuckie.basm:1915
    lsr a  ; chuckie.basm:1916
harry_calculate_frame:  ; chuckie.basm:1917
    ldx #$02  ; chuckie.basm:1918
    stx $89  ; chuckie.basm:1919
    bit $89  ; chuckie.basm:1920
    beq zero_one_else_zero_two  ; chuckie.basm:1921
    and #$01  ; chuckie.basm:1922
    asl a  ; chuckie.basm:1923
zero_one_else_zero_two:  ; chuckie.basm:1924
    ldx harry_state  ; chuckie.basm:1925
    cpx #$01  ; chuckie.basm:1926
    bne harry_not_on_ladder_2  ; chuckie.basm:1927
    ldx harry_dy  ; chuckie.basm:1928
    bne harry_apply_frame_offset  ; chuckie.basm:1929
    lda #$00  ; chuckie.basm:1930
    jmp harry_apply_frame_offset  ; chuckie.basm:1931
harry_not_on_ladder_2:  ; chuckie.basm:1932
    ldx harry_dx  ; chuckie.basm:1933
    bne harry_apply_frame_offset  ; chuckie.basm:1934
    lda #$00  ; chuckie.basm:1935
harry_apply_frame_offset:  ; chuckie.basm:1936
    clc   ; chuckie.basm:1937
    adc param  ; chuckie.basm:1938
    sta harry_sprite_index  ; chuckie.basm:1939
    jsr draw_harry  ; chuckie.basm:1940
    ldx harry_board_x  ; chuckie.basm:1941
    ldy harry_board_y  ; chuckie.basm:1942
    lda harry_cell_y  ; chuckie.basm:1943
    cmp #$04  ; chuckie.basm:1944
    bcc harry_in_bottom_half_of_cell  ; chuckie.basm:1945
    iny   ; chuckie.basm:1946
harry_in_bottom_half_of_cell:  ; chuckie.basm:1947
    sty $89  ; chuckie.basm:1948
    jsr board_read_with_range_check  ; chuckie.basm:1949
    sta param  ; chuckie.basm:1950
    and #$0C  ; chuckie.basm:1951
    beq rts_1  ; chuckie.basm:1952
    and #$08  ; chuckie.basm:1953
    bne consume_grain  ; chuckie.basm:1954
    dec egg_remaining_count  ; chuckie.basm:1955
    lda #$06  ; chuckie.basm:1956
    sta sound3_pitch  ; chuckie.basm:1957
    ldx #<((sound3))  ; chuckie.basm:1958
    ldy #>((sound3))  ; chuckie.basm:1958
    lda #osword_7_play_sound  ; chuckie.basm:1959
    jsr osword  ; chuckie.basm:1960
    lda param  ; chuckie.basm:1961
    lsr a  ; chuckie.basm:1962
    lsr a  ; chuckie.basm:1963
    lsr a  ; chuckie.basm:1964
    lsr a  ; chuckie.basm:1965
    clc   ; chuckie.basm:1966
    adc player_data_index  ; chuckie.basm:1967
    tax   ; chuckie.basm:1968
    dec player_egg_flags,X  ; chuckie.basm:1969
    ldx harry_board_x  ; chuckie.basm:1970
    ldy $89  ; chuckie.basm:1971
    jsr delete_egg  ; chuckie.basm:1972
    lda level_number  ; chuckie.basm:1973
    lsr a  ; chuckie.basm:1974
    lsr a  ; chuckie.basm:1975
    clc   ; chuckie.basm:1976
    adc #$01  ; chuckie.basm:1977
    cmp #$0A  ; chuckie.basm:1978
    bcc egg_bonus_in_range  ; chuckie.basm:1979
    lda #$0A  ; chuckie.basm:1980
egg_bonus_in_range:  ; chuckie.basm:1981
    ldx #$05  ; chuckie.basm:1982
    jsr add_to_score  ; chuckie.basm:1983
    jmp rts_1  ; chuckie.basm:1984
consume_grain:  ; chuckie.basm:1985
    lda #$05  ; chuckie.basm:1986
    sta sound3_pitch  ; chuckie.basm:1987
    ldx #<((sound3))  ; chuckie.basm:1988
    ldy #>((sound3))  ; chuckie.basm:1988
    lda #osword_7_play_sound  ; chuckie.basm:1989
    jsr osword  ; chuckie.basm:1990
    lda param  ; chuckie.basm:1991
    lsr a  ; chuckie.basm:1992
    lsr a  ; chuckie.basm:1993
    lsr a  ; chuckie.basm:1994
    lsr a  ; chuckie.basm:1995
    clc   ; chuckie.basm:1996
    adc player_data_index  ; chuckie.basm:1997
    tax   ; chuckie.basm:1998
    dec player_grain_flags,X  ; chuckie.basm:1999
    ldx harry_board_x  ; chuckie.basm:2000
    ldy $89  ; chuckie.basm:2001
    jsr delete_grain  ; chuckie.basm:2002
    lda #$05  ; chuckie.basm:2003
    ldx #$06  ; chuckie.basm:2004
    jsr add_to_score  ; chuckie.basm:2005
    lda #$14  ; chuckie.basm:2006
    sta clock_stop_timer  ; chuckie.basm:2007
rts_1:  ; chuckie.basm:2008
    rts   ; chuckie.basm:2009
test_horizontal_obstructions:  ; chuckie.basm:2010
    lda harry_dx  ; chuckie.basm:2011
    bmi test_left  ; chuckie.basm:2012
    bne test_right  ; chuckie.basm:2013
    clc   ; chuckie.basm:2014
    rts   ; chuckie.basm:2015
test_left:  ; chuckie.basm:2016
    lda harry_x  ; chuckie.basm:2017
    cmp #$01  ; chuckie.basm:2018
    bcc horizontal_obstruction  ; chuckie.basm:2019
    lda harry_cell_x  ; chuckie.basm:2020
    cmp #$02  ; chuckie.basm:2021
    bcs no_obstruction  ; chuckie.basm:2022
    lda harry_dy  ; chuckie.basm:2023
    cmp #$02  ; chuckie.basm:2024
    beq no_obstruction  ; chuckie.basm:2025
    ldx harry_board_x  ; chuckie.basm:2026
    dex   ; chuckie.basm:2027
    ldy harry_board_y  ; chuckie.basm:2028
    lda harry_cell_y  ; chuckie.basm:2029
    clc   ; chuckie.basm:2030
    adc harry_dy  ; chuckie.basm:2031
    cmp #$08  ; chuckie.basm:2032
    bcc test_this_row_left  ; chuckie.basm:2033
    bpl test_row_above_left  ; chuckie.basm:2034
    dey   ; chuckie.basm:2035
    jmp test_this_row_left  ; chuckie.basm:2036
test_row_above_left:  ; chuckie.basm:2037
    iny   ; chuckie.basm:2038
test_this_row_left:  ; chuckie.basm:2039
    jsr board_read_with_range_check  ; chuckie.basm:2040
    cmp #$01  ; chuckie.basm:2041
    beq horizontal_obstruction  ; chuckie.basm:2042
    lda harry_dy  ; chuckie.basm:2043
    bpl no_obstruction  ; chuckie.basm:2044
    ldx harry_board_x  ; chuckie.basm:2045
    dex   ; chuckie.basm:2046
    iny   ; chuckie.basm:2047
    jsr board_read_with_range_check  ; chuckie.basm:2048
    cmp #$01  ; chuckie.basm:2049
    beq horizontal_obstruction  ; chuckie.basm:2050
    bne no_obstruction  ; chuckie.basm:2051
test_right:  ; chuckie.basm:2052
    lda harry_x  ; chuckie.basm:2053
    cmp #$98  ; chuckie.basm:2054
    bcs horizontal_obstruction  ; chuckie.basm:2055
    lda harry_cell_x  ; chuckie.basm:2056
    cmp #$05  ; chuckie.basm:2057
    bcc no_obstruction  ; chuckie.basm:2058
    lda harry_dy  ; chuckie.basm:2059
    cmp #$02  ; chuckie.basm:2060
    beq no_obstruction  ; chuckie.basm:2061
    ldx harry_board_x  ; chuckie.basm:2062
    inx   ; chuckie.basm:2063
    ldy harry_board_y  ; chuckie.basm:2064
    lda harry_cell_y  ; chuckie.basm:2065
    clc   ; chuckie.basm:2066
    adc harry_dy  ; chuckie.basm:2067
    cmp #$08  ; chuckie.basm:2068
    bcc test_this_row_right  ; chuckie.basm:2069
    bpl test_row_above_right  ; chuckie.basm:2070
    dey   ; chuckie.basm:2071
    jmp test_this_row_right  ; chuckie.basm:2072
test_row_above_right:  ; chuckie.basm:2073
    iny   ; chuckie.basm:2074
test_this_row_right:  ; chuckie.basm:2075
    jsr board_read_with_range_check  ; chuckie.basm:2076
    cmp #$01  ; chuckie.basm:2077
    beq horizontal_obstruction  ; chuckie.basm:2078
    lda harry_dy  ; chuckie.basm:2079
    bpl no_obstruction  ; chuckie.basm:2080
    ldx harry_board_x  ; chuckie.basm:2081
    inx   ; chuckie.basm:2082
    iny   ; chuckie.basm:2083
    jsr board_read_with_range_check  ; chuckie.basm:2084
    cmp #$01  ; chuckie.basm:2085
    beq horizontal_obstruction  ; chuckie.basm:2086
no_obstruction:  ; chuckie.basm:2087
    clc   ; chuckie.basm:2088
    rts   ; chuckie.basm:2089
horizontal_obstruction:  ; chuckie.basm:2090
    sec   ; chuckie.basm:2091
    rts   ; chuckie.basm:2092
delete_egg:  ; chuckie.basm:2093
    txa   ; chuckie.basm:2094
    pha   ; chuckie.basm:2095
    lda #$00  ; chuckie.basm:2096
    jsr board_write  ; chuckie.basm:2097
    lda #$02  ; chuckie.basm:2098
    sta sprite_colour_mask_left  ; chuckie.basm:2099
    pla   ; chuckie.basm:2100
    tax   ; chuckie.basm:2101
    lda #$03  ; chuckie.basm:2102
    jsr draw_sprite_at_text_coords  ; chuckie.basm:2103
    rts   ; chuckie.basm:2104
delete_grain:  ; chuckie.basm:2107
    txa   ; chuckie.basm:2109
    pha   ; chuckie.basm:2110
    lda #$00  ; chuckie.basm:2111
    jsr board_write  ; chuckie.basm:2112
    lda #$08  ; chuckie.basm:2113
    sta sprite_colour_mask_left  ; chuckie.basm:2114
    pla   ; chuckie.basm:2115
    tax   ; chuckie.basm:2116
    lda #$04  ; chuckie.basm:2117
    jsr draw_sprite_at_text_coords  ; chuckie.basm:2118
    rts   ; chuckie.basm:2119
draw_harry:  ; chuckie.basm:2122
    ldx #$20  ; chuckie.basm:2124
    stx sprite_colour_mask_left  ; chuckie.basm:2125
    jsr lookup_sprite  ; chuckie.basm:2126
    ldx harry_x  ; chuckie.basm:2127
    ldy harry_y  ; chuckie.basm:2128
    jsr calculate_screen_location  ; chuckie.basm:2129
    jsr draw_sprite  ; chuckie.basm:2130
    rts   ; chuckie.basm:2131
draw_duck:  ; chuckie.basm:2134
    ldx #$20  ; chuckie.basm:2136
    stx sprite_colour_mask_left  ; chuckie.basm:2137
    clc   ; chuckie.basm:2138
    adc #$0F  ; chuckie.basm:2139
    jsr lookup_sprite  ; chuckie.basm:2140
    ldx duck_x  ; chuckie.basm:2141
    ldy duck_y  ; chuckie.basm:2142
    jsr calculate_screen_location  ; chuckie.basm:2143
    jsr draw_sprite  ; chuckie.basm:2144
    rts   ; chuckie.basm:2145
draw_chicken:  ; chuckie.basm:2148
    ldx #$80  ; chuckie.basm:2150
    stx sprite_colour_mask_left  ; chuckie.basm:2151
    ldx param  ; chuckie.basm:2152
    lda chicken_sprite_indices,X  ; chuckie.basm:2153
    clc   ; chuckie.basm:2154
    adc #$15  ; chuckie.basm:2155
    pha   ; chuckie.basm:2156
    jsr lookup_sprite  ; chuckie.basm:2157
    ldx param  ; chuckie.basm:2158
    lda chicken_xs,X  ; chuckie.basm:2159
    ldy chicken_ys,X  ; chuckie.basm:2160
    tax   ; chuckie.basm:2161
    pla   ; chuckie.basm:2162
    cmp #$1D  ; chuckie.basm:2163
    bcc not_feeding_left  ; chuckie.basm:2164
    txa   ; chuckie.basm:2165
    sbc #$08  ; chuckie.basm:2166
    tax   ; chuckie.basm:2167
not_feeding_left:  ; chuckie.basm:2168
    jsr calculate_screen_location  ; chuckie.basm:2169
    jsr draw_sprite  ; chuckie.basm:2170
    rts   ; chuckie.basm:2171
update_lift:  ; chuckie.basm:2174
    lda lift_flag  ; chuckie.basm:2176
    beq no_lift_3  ; chuckie.basm:2177
    ldy lift_y1  ; chuckie.basm:2178
    lda lift_alternator  ; chuckie.basm:2179
    beq update_lift_1  ; chuckie.basm:2180
    ldy lift_y2  ; chuckie.basm:2181
update_lift_1:  ; chuckie.basm:2182
    sty $89  ; chuckie.basm:2183
    lda #$02  ; chuckie.basm:2184
    sta sprite_colour_mask_left  ; chuckie.basm:2185
    lda #$05  ; chuckie.basm:2186
    jsr lookup_sprite  ; chuckie.basm:2187
    ldx lift_x  ; chuckie.basm:2188
    ldy $89  ; chuckie.basm:2189
    jsr calculate_screen_location  ; chuckie.basm:2190
    jsr draw_sprite  ; chuckie.basm:2191
    inc $89  ; chuckie.basm:2192
    inc $89  ; chuckie.basm:2193
    lda $89  ; chuckie.basm:2194
    cmp #$E0  ; chuckie.basm:2195
    bne lift_not_at_top  ; chuckie.basm:2196
    lda #$06  ; chuckie.basm:2197
    sta $89  ; chuckie.basm:2198
lift_not_at_top:  ; chuckie.basm:2199
    lda #$05  ; chuckie.basm:2200
    jsr lookup_sprite  ; chuckie.basm:2201
    ldx lift_x  ; chuckie.basm:2202
    ldy $89  ; chuckie.basm:2203
    jsr calculate_screen_location  ; chuckie.basm:2204
    jsr draw_sprite  ; chuckie.basm:2205
    lda lift_alternator  ; chuckie.basm:2206
    beq write_lift_y1  ; chuckie.basm:2207
    lda $89  ; chuckie.basm:2208
    sta lift_y2  ; chuckie.basm:2209
    jmp written_lift_y  ; chuckie.basm:2210
write_lift_y1:  ; chuckie.basm:2211
    lda $89  ; chuckie.basm:2212
    sta lift_y1  ; chuckie.basm:2213
written_lift_y:  ; chuckie.basm:2214
    lda lift_alternator  ; chuckie.basm:2215
    eor #$FF  ; chuckie.basm:2216
    sta lift_alternator  ; chuckie.basm:2217
no_lift_3:  ; chuckie.basm:2218
    rts   ; chuckie.basm:2219
board_read_with_range_check:  ; chuckie.basm:2222
    cpy #$19  ; chuckie.basm:2224
    bcs out_of_bounds  ; chuckie.basm:2225
    cpx #$14  ; chuckie.basm:2226
    bcs out_of_bounds  ; chuckie.basm:2227
    jsr board_calculate_index  ; chuckie.basm:2228
    bcs page_2_1  ; chuckie.basm:2229
    lda board_page1,X  ; chuckie.basm:2230
    rts   ; chuckie.basm:2231
page_2_1:  ; chuckie.basm:2232
    lda board_page2,X  ; chuckie.basm:2233
    rts   ; chuckie.basm:2234
out_of_bounds:  ; chuckie.basm:2235
    lda #$00  ; chuckie.basm:2236
    rts   ; chuckie.basm:2237
board_write:  ; chuckie.basm:2240
    jsr board_calculate_index  ; chuckie.basm:2242
    bcs page_2_2  ; chuckie.basm:2243
    sta board_page1,X  ; chuckie.basm:2244
    rts   ; chuckie.basm:2245
page_2_2:  ; chuckie.basm:2246
    sta board_page2,X  ; chuckie.basm:2247
    rts   ; chuckie.basm:2248
board_calculate_index:  ; chuckie.basm:2251
    pha   ; chuckie.basm:2253
    sty $8E  ; chuckie.basm:2254
    tya   ; chuckie.basm:2255
    asl a  ; chuckie.basm:2256
    asl a  ; chuckie.basm:2257
    adc $8E  ; chuckie.basm:2258
    asl a  ; chuckie.basm:2259
    asl a  ; chuckie.basm:2260
    php   ; chuckie.basm:2261
    clc   ; chuckie.basm:2262
    sta $8E  ; chuckie.basm:2263
    txa   ; chuckie.basm:2264
    adc $8E  ; chuckie.basm:2265
    tax   ; chuckie.basm:2266
    bcs addition_carried  ; chuckie.basm:2267
    plp   ; chuckie.basm:2268
    pla   ; chuckie.basm:2269
    rts   ; chuckie.basm:2270
addition_carried:  ; chuckie.basm:2271
    pla   ; chuckie.basm:2272
    pla   ; chuckie.basm:2273
    rts   ; chuckie.basm:2274
update_birds_timers:  ; chuckie.basm:2277
    inc birds_timer_cycle  ; chuckie.basm:2279
    lda birds_timer_cycle  ; chuckie.basm:2280
    cmp #$08  ; chuckie.basm:2281
    bne cycle_not_overflowed  ; chuckie.basm:2282
    lda #$00  ; chuckie.basm:2283
    sta birds_timer_cycle  ; chuckie.basm:2284
    jmp update_duck  ; chuckie.basm:2285
cycle_not_overflowed:  ; chuckie.basm:2286
    cmp #$04  ; chuckie.basm:2287
    bne cycle_not_midway  ; chuckie.basm:2288
    jmp update_timers  ; chuckie.basm:2289
cycle_not_midway:  ; chuckie.basm:2290
    jmp update_chickens  ; chuckie.basm:2291
update_duck:  ; chuckie.basm:2292
    lda duck_direction_flap  ; chuckie.basm:2293
    and #$02  ; chuckie.basm:2294
    sta $8B  ; chuckie.basm:2295
    lda duck_loose_flag  ; chuckie.basm:2296
    beq duck_in_cage_2  ; chuckie.basm:2297
    lda duck_x  ; chuckie.basm:2298
    clc   ; chuckie.basm:2299
    adc #$04  ; chuckie.basm:2300
    cmp harry_x  ; chuckie.basm:2301
    bcs duck_right_of_harry  ; chuckie.basm:2302
    inc duck_vx  ; chuckie.basm:2303
    lda duck_vx  ; chuckie.basm:2304
    cmp #$06  ; chuckie.basm:2305
    bmi vx_less_than_6  ; chuckie.basm:2306
    dec duck_vx  ; chuckie.basm:2307
vx_less_than_6:  ; chuckie.basm:2308
    lda #$00  ; chuckie.basm:2309
    sta $8B  ; chuckie.basm:2310
    jmp vx_adjusted  ; chuckie.basm:2311
duck_right_of_harry:  ; chuckie.basm:2312
    dec duck_vx  ; chuckie.basm:2313
    lda duck_vx  ; chuckie.basm:2314
    cmp #$FB  ; chuckie.basm:2315
    bpl vx_greater_or_equal_minus_5  ; chuckie.basm:2316
    inc duck_vx  ; chuckie.basm:2317
vx_greater_or_equal_minus_5:  ; chuckie.basm:2318
    lda #$02  ; chuckie.basm:2319
    sta $8B  ; chuckie.basm:2320
vx_adjusted:  ; chuckie.basm:2321
    lda harry_y  ; chuckie.basm:2322
    clc   ; chuckie.basm:2323
    adc #$04  ; chuckie.basm:2324
    cmp duck_y  ; chuckie.basm:2325
    bcc duck_above_harry  ; chuckie.basm:2326
    inc duck_vy  ; chuckie.basm:2327
    lda duck_vy  ; chuckie.basm:2328
    cmp #$06  ; chuckie.basm:2329
    bmi vy_less_than_6  ; chuckie.basm:2330
    dec duck_vy  ; chuckie.basm:2331
vy_less_than_6:  ; chuckie.basm:2332
    jmp vy_adjusted  ; chuckie.basm:2333
duck_above_harry:  ; chuckie.basm:2334
    dec duck_vy  ; chuckie.basm:2335
    lda duck_vy  ; chuckie.basm:2336
    cmp #$FB  ; chuckie.basm:2337
    bpl vy_adjusted  ; chuckie.basm:2338
    inc duck_vy  ; chuckie.basm:2339
vy_adjusted:  ; chuckie.basm:2340
    lda duck_y  ; chuckie.basm:2341
    clc   ; chuckie.basm:2342
    adc duck_vy  ; chuckie.basm:2343
    cmp #$28  ; chuckie.basm:2344
    bcs duck_not_at_bottom  ; chuckie.basm:2345
    lda duck_vy  ; chuckie.basm:2346
    eor #$FF  ; chuckie.basm:2347
    sta duck_vy  ; chuckie.basm:2348
    inc duck_vy  ; chuckie.basm:2349
duck_not_at_bottom:  ; chuckie.basm:2350
    lda duck_x  ; chuckie.basm:2351
    clc   ; chuckie.basm:2352
    adc duck_vx  ; chuckie.basm:2353
    cmp #$90  ; chuckie.basm:2354
    bcc duck_in_cage_2  ; chuckie.basm:2355
    lda duck_vx  ; chuckie.basm:2356
    eor #$FF  ; chuckie.basm:2357
    sta duck_vx  ; chuckie.basm:2358
    inc duck_vx  ; chuckie.basm:2359
duck_in_cage_2:  ; chuckie.basm:2360
    lda duck_direction_flap  ; chuckie.basm:2361
    jsr draw_duck  ; chuckie.basm:2362
    lda duck_x  ; chuckie.basm:2363
    clc   ; chuckie.basm:2364
    adc duck_vx  ; chuckie.basm:2365
    sta duck_x  ; chuckie.basm:2366
    lda duck_y  ; chuckie.basm:2367
    clc   ; chuckie.basm:2368
    adc duck_vy  ; chuckie.basm:2369
    sta duck_y  ; chuckie.basm:2370
    lda duck_direction_flap  ; chuckie.basm:2371
    and #$01  ; chuckie.basm:2372
    eor #$01  ; chuckie.basm:2373
    ora $8B  ; chuckie.basm:2374
    sta duck_direction_flap  ; chuckie.basm:2375
    jsr draw_duck  ; chuckie.basm:2376
    rts   ; chuckie.basm:2377
update_chickens:  ; chuckie.basm:2378
    dec current_chicken  ; chuckie.basm:2379
    ldx current_chicken  ; chuckie.basm:2380
    bpl current_chicken_not_wrapped  ; chuckie.basm:2381
    ldx chicken_speed  ; chuckie.basm:2382
    stx current_chicken  ; chuckie.basm:2383
current_chicken_not_wrapped:  ; chuckie.basm:2384
    cpx chicken_count  ; chuckie.basm:2385
    bcc current_chicken_live  ; chuckie.basm:2386
    rts   ; chuckie.basm:2387
current_chicken_live:  ; chuckie.basm:2388
    stx param  ; chuckie.basm:2389
    lda chicken_states,X  ; chuckie.basm:2390
    cmp #$01  ; chuckie.basm:2391
    bne state_not_one  ; chuckie.basm:2392
    jmp chicken_state_one  ; chuckie.basm:2393
state_not_one:  ; chuckie.basm:2394
    bcc chicken_state_zero  ; chuckie.basm:2395
    jmp chicken_state_two_or_more  ; chuckie.basm:2396
chicken_state_zero:  ; chuckie.basm:2397
    lda chicken_board_xs,X  ; chuckie.basm:2398
    sta $8B  ; chuckie.basm:2399
    lda chicken_board_ys,X  ; chuckie.basm:2400
    sta $8C  ; chuckie.basm:2401
    lda #$00  ; chuckie.basm:2402
    sta $8D  ; chuckie.basm:2403
    ldx $8B  ; chuckie.basm:2404
    ldy $8C  ; chuckie.basm:2405
    dex   ; chuckie.basm:2406
    dey   ; chuckie.basm:2407
    jsr board_read_with_range_check  ; chuckie.basm:2408
    and #$01  ; chuckie.basm:2409
    beq no_wall_left  ; chuckie.basm:2410
    sta $8D  ; chuckie.basm:2411
no_wall_left:  ; chuckie.basm:2412
    ldx $8B  ; chuckie.basm:2413
    ldy $8C  ; chuckie.basm:2414
    inx   ; chuckie.basm:2415
    dey   ; chuckie.basm:2416
    jsr board_read_with_range_check  ; chuckie.basm:2417
    and #$01  ; chuckie.basm:2418
    beq no_wall_right  ; chuckie.basm:2419
    lda #$02  ; chuckie.basm:2420
    ora $8D  ; chuckie.basm:2421
    sta $8D  ; chuckie.basm:2422
no_wall_right:  ; chuckie.basm:2423
    ldx $8B  ; chuckie.basm:2424
    ldy $8C  ; chuckie.basm:2425
    dey   ; chuckie.basm:2426
    jsr board_read_with_range_check  ; chuckie.basm:2427
    and #$02  ; chuckie.basm:2428
    beq no_ladder_down  ; chuckie.basm:2429
    lda #$08  ; chuckie.basm:2430
    ora $8D  ; chuckie.basm:2431
    sta $8D  ; chuckie.basm:2432
no_ladder_down:  ; chuckie.basm:2433
    ldx $8B  ; chuckie.basm:2434
    ldy $8C  ; chuckie.basm:2435
    iny   ; chuckie.basm:2436
    iny   ; chuckie.basm:2437
    jsr board_read_with_range_check  ; chuckie.basm:2438
    and #$02  ; chuckie.basm:2439
    beq no_ladder_up  ; chuckie.basm:2440
    lda #$04  ; chuckie.basm:2441
    ora $8D  ; chuckie.basm:2442
    sta $8D  ; chuckie.basm:2443
no_ladder_up:  ; chuckie.basm:2444
    jsr count_chicken_options  ; chuckie.basm:2445
    cpx #$01  ; chuckie.basm:2446
    bne multiple_options  ; chuckie.basm:2447
    lda $8D  ; chuckie.basm:2448
    ldx param  ; chuckie.basm:2449
    sta chicken_directions,X  ; chuckie.basm:2450
    jmp one_option_selected  ; chuckie.basm:2451
multiple_options:  ; chuckie.basm:2452
    ldx param  ; chuckie.basm:2453
    lda chicken_directions,X  ; chuckie.basm:2454
    cmp #$04  ; chuckie.basm:2455
    bcs using_ladder  ; chuckie.basm:2456
    eor #$FC  ; chuckie.basm:2457
    jmp clear_opposite_direction_retain_orthogonal  ; chuckie.basm:2458
using_ladder:  ; chuckie.basm:2459
    eor #$F3  ; chuckie.basm:2460
clear_opposite_direction_retain_orthogonal:  ; chuckie.basm:2461
    and $8D  ; chuckie.basm:2462
    sta $8D  ; chuckie.basm:2463
    jsr count_chicken_options  ; chuckie.basm:2464
    cpx #$01  ; chuckie.basm:2465
    bne multiple_options_still  ; chuckie.basm:2466
    ldx param  ; chuckie.basm:2467
    lda $8D  ; chuckie.basm:2468
    sta chicken_directions,X  ; chuckie.basm:2469
    jmp one_option_selected  ; chuckie.basm:2470
multiple_options_still:  ; chuckie.basm:2471
    lda $8D  ; chuckie.basm:2472
    sta $8E  ; chuckie.basm:2473
choose_random_direction_loop:  ; chuckie.basm:2474
    jsr randomise  ; chuckie.basm:2475
    lda rand1  ; chuckie.basm:2476
    and $8E  ; chuckie.basm:2477
    sta $8D  ; chuckie.basm:2478
    jsr count_chicken_options  ; chuckie.basm:2479
    cpx #$01  ; chuckie.basm:2480
    bne choose_random_direction_loop  ; chuckie.basm:2481
    ldx param  ; chuckie.basm:2482
    lda $8D  ; chuckie.basm:2483
    sta chicken_directions,X  ; chuckie.basm:2484
one_option_selected:  ; chuckie.basm:2485
    ldx param  ; chuckie.basm:2486
    lda chicken_directions,X  ; chuckie.basm:2487
    and #$03  ; chuckie.basm:2488
    beq chicken_state_one  ; chuckie.basm:2489
    and #$01  ; chuckie.basm:2490
    beq going_right  ; chuckie.basm:2491
    ldx $8B  ; chuckie.basm:2492
    ldy $8C  ; chuckie.basm:2493
    dex   ; chuckie.basm:2494
    jsr board_read_with_range_check  ; chuckie.basm:2495
    jmp test_grain  ; chuckie.basm:2496
going_right:  ; chuckie.basm:2497
    ldx $8B  ; chuckie.basm:2498
    ldy $8C  ; chuckie.basm:2499
    inx   ; chuckie.basm:2500
    jsr board_read_with_range_check  ; chuckie.basm:2501
test_grain:  ; chuckie.basm:2502
    and #$08  ; chuckie.basm:2503
    beq chicken_state_one  ; chuckie.basm:2504
    ldx param  ; chuckie.basm:2505
    lda #$02  ; chuckie.basm:2506
    sta chicken_states,X  ; chuckie.basm:2507
    jmp chicken_state_one  ; chuckie.basm:2508
count_chicken_options:  ; chuckie.basm:2509
    ldx #$00  ; chuckie.basm:2510
    lda $8D  ; chuckie.basm:2511
count_bits_loop:  ; chuckie.basm:2512
    lsr a  ; chuckie.basm:2513
    bcc bit_not_set  ; chuckie.basm:2514
    inx   ; chuckie.basm:2515
bit_not_set:  ; chuckie.basm:2516
    cmp #$00  ; chuckie.basm:2517
    bne count_bits_loop  ; chuckie.basm:2518
    rts   ; chuckie.basm:2519
chicken_state_two_or_more:  ; chuckie.basm:2520
    cmp #$04  ; chuckie.basm:2521
    bne chicken_state_one  ; chuckie.basm:2522
    lda chicken_directions,X  ; chuckie.basm:2523
    ldy chicken_board_xs,X  ; chuckie.basm:2524
    sty $8B  ; chuckie.basm:2525
    ldy chicken_board_ys,X  ; chuckie.basm:2526
    sty $8C  ; chuckie.basm:2527
    ldx $8B  ; chuckie.basm:2528
    dex   ; chuckie.basm:2529
    and #$01  ; chuckie.basm:2530
    bne moving_left  ; chuckie.basm:2531
    inx   ; chuckie.basm:2532
    inx   ; chuckie.basm:2533
moving_left:  ; chuckie.basm:2534
    stx $8D  ; chuckie.basm:2535
    jsr board_read_with_range_check  ; chuckie.basm:2536
    sta $89  ; chuckie.basm:2537
    and #$08  ; chuckie.basm:2538
    beq chicken_state_one  ; chuckie.basm:2539
    lda $89  ; chuckie.basm:2540
    lsr a  ; chuckie.basm:2541
    lsr a  ; chuckie.basm:2542
    lsr a  ; chuckie.basm:2543
    lsr a  ; chuckie.basm:2544
    clc   ; chuckie.basm:2545
    adc player_data_index  ; chuckie.basm:2546
    tax   ; chuckie.basm:2547
    dec player_grain_flags,X  ; chuckie.basm:2548
    ldx $8D  ; chuckie.basm:2549
    ldy $8C  ; chuckie.basm:2550
    jsr delete_grain  ; chuckie.basm:2551
chicken_state_one:  ; chuckie.basm:2552
    jsr draw_chicken  ; chuckie.basm:2553
    ldx param  ; chuckie.basm:2554
    lda chicken_states,X  ; chuckie.basm:2555
    cmp #$02  ; chuckie.basm:2556
    bcs chicken_eating  ; chuckie.basm:2557
    lda chicken_directions,X  ; chuckie.basm:2558
    lsr a  ; chuckie.basm:2559
    bcs move_chicken_left  ; chuckie.basm:2560
    lsr a  ; chuckie.basm:2561
    bcs move_chicken_right  ; chuckie.basm:2562
    lsr a  ; chuckie.basm:2563
    bcs move_chicken_up  ; chuckie.basm:2564
    lda chicken_ys,X  ; chuckie.basm:2565
    sec   ; chuckie.basm:2566
    sbc #$04  ; chuckie.basm:2567
    sta chicken_ys,X  ; chuckie.basm:2568
    lda chicken_states,X  ; chuckie.basm:2569
    beq skip_dec_y  ; chuckie.basm:2570
    dec chicken_board_ys,X  ; chuckie.basm:2571
skip_dec_y:  ; chuckie.basm:2572
    lda #$04  ; chuckie.basm:2573
    jmp move_chicken_finish  ; chuckie.basm:2574
move_chicken_up:  ; chuckie.basm:2575
    lda chicken_ys,X  ; chuckie.basm:2576
    clc   ; chuckie.basm:2577
    adc #$04  ; chuckie.basm:2578
    sta chicken_ys,X  ; chuckie.basm:2579
    lda chicken_states,X  ; chuckie.basm:2580
    beq skip_inc_y  ; chuckie.basm:2581
    inc chicken_board_ys,X  ; chuckie.basm:2582
skip_inc_y:  ; chuckie.basm:2583
    lda #$04  ; chuckie.basm:2584
    jmp move_chicken_finish  ; chuckie.basm:2585
move_chicken_left:  ; chuckie.basm:2586
    lda chicken_xs,X  ; chuckie.basm:2587
    sec   ; chuckie.basm:2588
    sbc #$04  ; chuckie.basm:2589
    sta chicken_xs,X  ; chuckie.basm:2590
    lda chicken_states,X  ; chuckie.basm:2591
    beq skip_dec_x  ; chuckie.basm:2592
    dec chicken_board_xs,X  ; chuckie.basm:2593
skip_dec_x:  ; chuckie.basm:2594
    lda #$02  ; chuckie.basm:2595
    jmp move_chicken_finish  ; chuckie.basm:2596
move_chicken_right:  ; chuckie.basm:2597
    lda chicken_xs,X  ; chuckie.basm:2598
    clc   ; chuckie.basm:2599
    adc #$04  ; chuckie.basm:2600
    sta chicken_xs,X  ; chuckie.basm:2601
    lda chicken_states,X  ; chuckie.basm:2602
    beq skip_inc_x  ; chuckie.basm:2603
    inc chicken_board_xs,X  ; chuckie.basm:2604
skip_inc_x:  ; chuckie.basm:2605
    lda #$00  ; chuckie.basm:2606
    jmp move_chicken_finish  ; chuckie.basm:2607
move_chicken_finish:  ; chuckie.basm:2608
    sta chicken_sprite_indices,X  ; chuckie.basm:2609
    lda chicken_states,X  ; chuckie.basm:2610
    eor #$01  ; chuckie.basm:2611
    sta chicken_states,X  ; chuckie.basm:2612
    clc   ; chuckie.basm:2613
    adc chicken_sprite_indices,X  ; chuckie.basm:2614
    sta chicken_sprite_indices,X  ; chuckie.basm:2615
    jsr draw_chicken  ; chuckie.basm:2616
    rts   ; chuckie.basm:2617
chicken_eating:  ; chuckie.basm:2618
    lda chicken_states,X  ; chuckie.basm:2619
    asl a  ; chuckie.basm:2620
    and #$1F  ; chuckie.basm:2621
    sta chicken_states,X  ; chuckie.basm:2622
    beq feeding_complete  ; chuckie.basm:2623
    lda #$06  ; chuckie.basm:2624
feeding_complete:  ; chuckie.basm:2625
    ldy chicken_directions,X  ; chuckie.basm:2626
    cpy #$01  ; chuckie.basm:2627
    bne moving_right  ; chuckie.basm:2628
    clc   ; chuckie.basm:2629
    adc #$02  ; chuckie.basm:2630
moving_right:  ; chuckie.basm:2631
    ldy chicken_states,X  ; chuckie.basm:2632
    cpy #$08  ; chuckie.basm:2633
    bne head_not_on_ground  ; chuckie.basm:2634
    clc   ; chuckie.basm:2635
    adc #$01  ; chuckie.basm:2636
head_not_on_ground:  ; chuckie.basm:2637
    sta chicken_sprite_indices,X  ; chuckie.basm:2638
    jsr draw_chicken  ; chuckie.basm:2639
    rts   ; chuckie.basm:2640
update_timers:  ; chuckie.basm:2641
    lda #$08  ; chuckie.basm:2642
    sta sprite_colour_mask_left  ; chuckie.basm:2643
    lda clock_stop_timer  ; chuckie.basm:2644
    beq clock_not_stopped  ; chuckie.basm:2645
    dec clock_stop_timer  ; chuckie.basm:2646
    rts   ; chuckie.basm:2647
clock_not_stopped:  ; chuckie.basm:2648
    ldx #$02  ; chuckie.basm:2649
    stx param  ; chuckie.basm:2650
decrement_timer_loop:  ; chuckie.basm:2651
    jsr draw_timer_digit  ; chuckie.basm:2652
    ldx param  ; chuckie.basm:2653
    dec timer_2,X  ; chuckie.basm:2654
    php   ; chuckie.basm:2655
    bpl no_borrow_1  ; chuckie.basm:2656
    lda #$09  ; chuckie.basm:2657
    sta timer_2,X  ; chuckie.basm:2658
no_borrow_1:  ; chuckie.basm:2659
    jsr draw_timer_digit  ; chuckie.basm:2660
    dec param  ; chuckie.basm:2661
    plp   ; chuckie.basm:2662
    bmi decrement_timer_loop  ; chuckie.basm:2663
    clc   ; chuckie.basm:2664
    lda timer_2  ; chuckie.basm:2665
    adc timer_1  ; chuckie.basm:2666
    adc timer_0  ; chuckie.basm:2667
    bne time_remains  ; chuckie.basm:2668
    inc dead_flag  ; chuckie.basm:2669
    rts   ; chuckie.basm:2670
time_remains:  ; chuckie.basm:2671
    lda timer_0  ; chuckie.basm:2672
    beq five_divides_time  ; chuckie.basm:2673
    cmp #$05  ; chuckie.basm:2674
    beq five_divides_time  ; chuckie.basm:2675
    rts   ; chuckie.basm:2676
five_divides_time:  ; chuckie.basm:2677
    lda bonus_gone_flag  ; chuckie.basm:2678
    beq decrement_bonus  ; chuckie.basm:2679
    rts   ; chuckie.basm:2680
decrement_bonus:  ; chuckie.basm:2683
    ldx #$02  ; chuckie.basm:2685
    stx param  ; chuckie.basm:2686
decrement_bonus_loop:  ; chuckie.basm:2687
    jsr draw_bonus_digit  ; chuckie.basm:2688
    ldx param  ; chuckie.basm:2689
    dec bonus_3,X  ; chuckie.basm:2690
    php   ; chuckie.basm:2691
    bpl no_borrow_2  ; chuckie.basm:2692
    lda #$09  ; chuckie.basm:2693
    sta bonus_3,X  ; chuckie.basm:2694
no_borrow_2:  ; chuckie.basm:2695
    jsr draw_bonus_digit  ; chuckie.basm:2696
    dec param  ; chuckie.basm:2697
    plp   ; chuckie.basm:2698
    bmi decrement_bonus_loop  ; chuckie.basm:2699
    clc   ; chuckie.basm:2700
    lda bonus_3  ; chuckie.basm:2701
    adc bonus_2  ; chuckie.basm:2702
    adc bonus_1  ; chuckie.basm:2703
    bne bonus_remains  ; chuckie.basm:2704
    inc bonus_gone_flag  ; chuckie.basm:2705
bonus_remains:  ; chuckie.basm:2706
    rts   ; chuckie.basm:2707
draw_timer_digit:  ; chuckie.basm:2710
    lda param  ; chuckie.basm:2712
    tay   ; chuckie.basm:2713
    asl a  ; chuckie.basm:2714
    asl a  ; chuckie.basm:2715
    adc param  ; chuckie.basm:2716
    adc #$91  ; chuckie.basm:2717
    tax   ; chuckie.basm:2718
    lda timer_2,Y  ; chuckie.basm:2719
    ldy #$E7  ; chuckie.basm:2720
    jsr draw_digit  ; chuckie.basm:2721
    rts   ; chuckie.basm:2722
draw_bonus_digit:  ; chuckie.basm:2725
    lda param  ; chuckie.basm:2727
    tay   ; chuckie.basm:2728
    asl a  ; chuckie.basm:2729
    asl a  ; chuckie.basm:2730
    adc param  ; chuckie.basm:2731
    adc #$66  ; chuckie.basm:2732
    tax   ; chuckie.basm:2733
    lda bonus_3,Y  ; chuckie.basm:2734
    ldy #$E7  ; chuckie.basm:2735
    jsr draw_digit  ; chuckie.basm:2736
    rts   ; chuckie.basm:2737
hit_test_birds:  ; chuckie.basm:2740
    lda chicken_count  ; chuckie.basm:2742
    beq hit_test_duck  ; chuckie.basm:2743
    lda #$00  ; chuckie.basm:2744
    sta loop_counter  ; chuckie.basm:2745
hit_test_chicken_loop:  ; chuckie.basm:2746
    ldx loop_counter  ; chuckie.basm:2747
    lda chicken_xs,X  ; chuckie.basm:2748
    sec   ; chuckie.basm:2749
    sbc harry_x  ; chuckie.basm:2750
    clc   ; chuckie.basm:2751
    adc #$05  ; chuckie.basm:2752
    cmp #$0B  ; chuckie.basm:2753
    bcs chicken_miss  ; chuckie.basm:2754
    lda chicken_ys,X  ; chuckie.basm:2755
    sec   ; chuckie.basm:2756
    sbc #$01  ; chuckie.basm:2757
    sbc harry_y  ; chuckie.basm:2758
    clc   ; chuckie.basm:2759
    adc #$0E  ; chuckie.basm:2760
    cmp #$1D  ; chuckie.basm:2761
    bcs chicken_miss  ; chuckie.basm:2762
    inc dead_flag  ; chuckie.basm:2763
chicken_miss:  ; chuckie.basm:2764
    inc loop_counter  ; chuckie.basm:2765
    lda loop_counter  ; chuckie.basm:2766
    cmp chicken_count  ; chuckie.basm:2767
    bcc hit_test_chicken_loop  ; chuckie.basm:2768
hit_test_duck:  ; chuckie.basm:2769
    lda duck_loose_flag  ; chuckie.basm:2770
    beq duck_in_cage_3  ; chuckie.basm:2771
    lda duck_x  ; chuckie.basm:2772
    clc   ; chuckie.basm:2773
    adc #$04  ; chuckie.basm:2774
    sec   ; chuckie.basm:2775
    sbc harry_x  ; chuckie.basm:2776
    clc   ; chuckie.basm:2777
    adc #$05  ; chuckie.basm:2778
    cmp #$0B  ; chuckie.basm:2779
    bcs duck_in_cage_3  ; chuckie.basm:2780
    lda duck_y  ; chuckie.basm:2781
    sec   ; chuckie.basm:2782
    sbc #$05  ; chuckie.basm:2783
    sbc harry_y  ; chuckie.basm:2784
    clc   ; chuckie.basm:2785
    adc #$0E  ; chuckie.basm:2786
    cmp #$1D  ; chuckie.basm:2787
    bcs duck_in_cage_3  ; chuckie.basm:2788
    inc dead_flag  ; chuckie.basm:2789
duck_in_cage_3:  ; chuckie.basm:2790
    rts   ; chuckie.basm:2791
location_of_highscore_x:  ; chuckie.basm:2794
    lda #$00  ; chuckie.basm:2796
    sta sprite_hi  ; chuckie.basm:2797
    dex   ; chuckie.basm:2798
    txa   ; chuckie.basm:2799
    asl a  ; chuckie.basm:2800
    asl a  ; chuckie.basm:2801
    asl a  ; chuckie.basm:2802
    rol sprite_hi  ; chuckie.basm:2803
    asl a  ; chuckie.basm:2804
    rol sprite_hi  ; chuckie.basm:2805
    clc   ; chuckie.basm:2806
    adc #<highscore_table  ; chuckie.basm:2807
    sta sprite_lo  ; chuckie.basm:2808
    lda sprite_hi  ; chuckie.basm:2809
    adc #>highscore_table  ; chuckie.basm:2810
    sta sprite_hi  ; chuckie.basm:2811
    rts   ; chuckie.basm:2812
init_highscores:  ; chuckie.basm:2815
    lda #$0A  ; chuckie.basm:2817
    sta loop_counter  ; chuckie.basm:2818
init_highscores_loop:  ; chuckie.basm:2819
    ldx loop_counter  ; chuckie.basm:2820
    jsr location_of_highscore_x  ; chuckie.basm:2821
    ldy #$0F  ; chuckie.basm:2822
    lda #$20  ; chuckie.basm:2823
name_trailing_spaces_loop:  ; chuckie.basm:2824
    sta (sprite_lo),Y  ; chuckie.basm:2825
    dey   ; chuckie.basm:2826
    cpy #$0A  ; chuckie.basm:2827
    bne name_trailing_spaces_loop  ; chuckie.basm:2828
    lda #$46  ; chuckie.basm:2829
    sta (sprite_lo),Y  ; chuckie.basm:2830
    dey   ; chuckie.basm:2831
    lda #$26  ; chuckie.basm:2832
    sta (sprite_lo),Y  ; chuckie.basm:2833
    dey   ; chuckie.basm:2834
    lda #$41  ; chuckie.basm:2835
    sta (sprite_lo),Y  ; chuckie.basm:2836
    dey   ; chuckie.basm:2837
    lda #$00  ; chuckie.basm:2838
score_loop:  ; chuckie.basm:2839
    sta (sprite_lo),Y  ; chuckie.basm:2840
    dey   ; chuckie.basm:2841
    bpl score_loop  ; chuckie.basm:2842
    lda #$01  ; chuckie.basm:2843
    ldy #$04  ; chuckie.basm:2844
    sta (sprite_lo),Y  ; chuckie.basm:2845
    dec loop_counter  ; chuckie.basm:2846
    bne init_highscores_loop  ; chuckie.basm:2847
    rts   ; chuckie.basm:2848
compare_highscores:  ; chuckie.basm:2851
    lda #$01  ; chuckie.basm:2853
    sta loop_counter  ; chuckie.basm:2854
highscores_loop:  ; chuckie.basm:2855
    ldx loop_counter  ; chuckie.basm:2856
    jsr location_of_highscore_x  ; chuckie.basm:2857
    ldy #$00  ; chuckie.basm:2858
highscore_digits_loop_1:  ; chuckie.basm:2859
    lda (sprite_lo),Y  ; chuckie.basm:2860
    cmp current_score,Y  ; chuckie.basm:2861
    bmi highscore_less_than_current  ; chuckie.basm:2862
    bne highscore_greater_than_current  ; chuckie.basm:2863
    iny   ; chuckie.basm:2864
    cpy #$08  ; chuckie.basm:2865
    bne highscore_digits_loop_1  ; chuckie.basm:2866
highscore_greater_than_current:  ; chuckie.basm:2867
    inc loop_counter  ; chuckie.basm:2868
    lda loop_counter  ; chuckie.basm:2869
    cmp #$0B  ; chuckie.basm:2870
    bcc highscores_loop  ; chuckie.basm:2871
    rts   ; chuckie.basm:2872
highscore_less_than_current:  ; chuckie.basm:2873
    jsr shift_highscores  ; chuckie.basm:2874
    ldy #$07  ; chuckie.basm:2875
copy_score_loop:  ; chuckie.basm:2876
    lda current_score,Y  ; chuckie.basm:2877
    sta (sprite_lo),Y  ; chuckie.basm:2878
    dey   ; chuckie.basm:2879
    bpl copy_score_loop  ; chuckie.basm:2880
    ldy #$0F  ; chuckie.basm:2881
    lda #$20  ; chuckie.basm:2882
clear_name_loop:  ; chuckie.basm:2883
    sta (sprite_lo),Y  ; chuckie.basm:2884
    dey   ; chuckie.basm:2885
    cpy #$07  ; chuckie.basm:2886
    bne clear_name_loop  ; chuckie.basm:2887
    rts   ; chuckie.basm:2888
shift_highscores:  ; chuckie.basm:2889
    lda #$09  ; chuckie.basm:2890
    sta $8B  ; chuckie.basm:2891
shift_highscores_loop:  ; chuckie.basm:2892
    ldx $8B  ; chuckie.basm:2893
    cpx loop_counter  ; chuckie.basm:2894
    bcc all_shifted  ; chuckie.basm:2895
    jsr location_of_highscore_x  ; chuckie.basm:2896
    ldy #$0F  ; chuckie.basm:2897
copy_entry_from_table_to_buffer_loop:  ; chuckie.basm:2898
    lda (sprite_lo),Y  ; chuckie.basm:2899
    sta duck_x,Y  ; chuckie.basm:2900
    dey   ; chuckie.basm:2901
    bpl copy_entry_from_table_to_buffer_loop  ; chuckie.basm:2902
    ldx $8B  ; chuckie.basm:2903
    inx   ; chuckie.basm:2904
    jsr location_of_highscore_x  ; chuckie.basm:2905
    ldy #$0F  ; chuckie.basm:2906
copy_entry_from_buffer_to_table_loop:  ; chuckie.basm:2907
    lda duck_x,Y  ; chuckie.basm:2908
    sta (sprite_lo),Y  ; chuckie.basm:2909
    dey   ; chuckie.basm:2910
    bpl copy_entry_from_buffer_to_table_loop  ; chuckie.basm:2911
    dec $8B  ; chuckie.basm:2912
    jmp shift_highscores_loop  ; chuckie.basm:2913
all_shifted:  ; chuckie.basm:2914
    ldx loop_counter  ; chuckie.basm:2915
    jsr location_of_highscore_x  ; chuckie.basm:2916
    rts   ; chuckie.basm:2917
draw_highscores:  ; chuckie.basm:2920
    lda #$01  ; chuckie.basm:2922
    sta loop_counter  ; chuckie.basm:2923
    ldx #<((msg_highscores))  ; chuckie.basm:2924
    ldy #>((msg_highscores))  ; chuckie.basm:2924
    jsr write_counted_string  ; chuckie.basm:2925
    lda #$C0  ; chuckie.basm:2926
    sta msg_highscore_y_lo  ; chuckie.basm:2927
    lda #$02  ; chuckie.basm:2928
    sta msg_highscore_y_hi  ; chuckie.basm:2929
draw_highscores_loop:  ; chuckie.basm:2930
    ldx #<((msg_highscore_move))  ; chuckie.basm:2931
    ldy #>((msg_highscore_move))  ; chuckie.basm:2931
    jsr write_counted_string  ; chuckie.basm:2932
    lda #$20  ; chuckie.basm:2933
    ldx loop_counter  ; chuckie.basm:2934
    stx $8B  ; chuckie.basm:2935
    cpx #$0A  ; chuckie.basm:2936
    bne no_tens_digit  ; chuckie.basm:2937
    lda #$31  ; chuckie.basm:2938
    ldx #$00  ; chuckie.basm:2939
    stx $8B  ; chuckie.basm:2940
no_tens_digit:  ; chuckie.basm:2941
    jsr oswrch  ; chuckie.basm:2942
    lda $8B  ; chuckie.basm:2943
    clc   ; chuckie.basm:2944
    adc #$30  ; chuckie.basm:2945
    jsr oswrch  ; chuckie.basm:2946
    ldx loop_counter  ; chuckie.basm:2947
    jsr location_of_highscore_x  ; chuckie.basm:2948
    ldy #$00  ; chuckie.basm:2949
    sty $8B  ; chuckie.basm:2950
highscore_digits_loop_2:  ; chuckie.basm:2951
    lda (sprite_lo),Y  ; chuckie.basm:2952
    bne write_digit  ; chuckie.basm:2953
    ldx $8B  ; chuckie.basm:2954
    bne write_digit  ; chuckie.basm:2955
    lda #$20  ; chuckie.basm:2956
    jmp skip_digit  ; chuckie.basm:2957
write_digit:  ; chuckie.basm:2958
    clc   ; chuckie.basm:2959
    adc #$30  ; chuckie.basm:2960
    inc $8B  ; chuckie.basm:2961
skip_digit:  ; chuckie.basm:2962
    jsr oswrch  ; chuckie.basm:2963
    iny   ; chuckie.basm:2964
    cpy #$08  ; chuckie.basm:2965
    bcc highscore_digits_loop_2  ; chuckie.basm:2966
    lda #$20  ; chuckie.basm:2967
    jsr oswrch  ; chuckie.basm:2968
highscore_name_loop:  ; chuckie.basm:2969
    lda (sprite_lo),Y  ; chuckie.basm:2970
    jsr oswrch  ; chuckie.basm:2971
    iny   ; chuckie.basm:2972
    cpy #$10  ; chuckie.basm:2973
    bcc highscore_name_loop  ; chuckie.basm:2974
    inc loop_counter  ; chuckie.basm:2975
    lda loop_counter  ; chuckie.basm:2976
    cmp #$0B  ; chuckie.basm:2977
    beq rts_2  ; chuckie.basm:2978
    lda msg_highscore_y_lo  ; chuckie.basm:2979
    sec   ; chuckie.basm:2980
    sbc #$30  ; chuckie.basm:2981
    sta msg_highscore_y_lo  ; chuckie.basm:2982
    lda msg_highscore_y_hi  ; chuckie.basm:2983
    sbc #$00  ; chuckie.basm:2984
    sta msg_highscore_y_hi  ; chuckie.basm:2985
    jmp draw_highscores_loop  ; chuckie.basm:2986
rts_2:  ; chuckie.basm:2987
    rts   ; chuckie.basm:2988
check_highscore:  ; chuckie.basm:2991
    jsr compare_highscores  ; chuckie.basm:2993
    lda loop_counter  ; chuckie.basm:2994
    cmp #$0B  ; chuckie.basm:2995
    bne new_highscore  ; chuckie.basm:2996
    rts   ; chuckie.basm:2997
new_highscore:  ; chuckie.basm:2998
    sta param  ; chuckie.basm:2999
    lda #$C0  ; chuckie.basm:3000
    sta msg_name_y_lo  ; chuckie.basm:3001
    lda #$02  ; chuckie.basm:3002
    sta msg_name_y_hi  ; chuckie.basm:3003
    lda param  ; chuckie.basm:3004
    sec   ; chuckie.basm:3005
    sbc #$01  ; chuckie.basm:3006
    beq no_subtraction  ; chuckie.basm:3007
    tax   ; chuckie.basm:3008
subtract_x_times_48_loop:  ; chuckie.basm:3009
    lda msg_name_y_lo  ; chuckie.basm:3010
    sec   ; chuckie.basm:3011
    sbc #$30  ; chuckie.basm:3012
    sta msg_name_y_lo  ; chuckie.basm:3013
    lda msg_name_y_hi  ; chuckie.basm:3014
    sbc #$00  ; chuckie.basm:3015
    sta msg_name_y_hi  ; chuckie.basm:3016
    dex   ; chuckie.basm:3017
    bne subtract_x_times_48_loop  ; chuckie.basm:3018
no_subtraction:  ; chuckie.basm:3019
    ldx #<((msg_enter_your_name))  ; chuckie.basm:3020
    ldy #>((msg_enter_your_name))  ; chuckie.basm:3020
    jsr write_counted_string  ; chuckie.basm:3021
    lda player  ; chuckie.basm:3022
    clc   ; chuckie.basm:3023
    adc #$31  ; chuckie.basm:3024
    jsr oswrch  ; chuckie.basm:3025
    jsr draw_highscores  ; chuckie.basm:3026
    ldx #<((msg_name_move))  ; chuckie.basm:3027
    ldy #>((msg_name_move))  ; chuckie.basm:3027
    jsr write_counted_string  ; chuckie.basm:3028
    lda #osbyte_04_cursor_key_effect  ; chuckie.basm:3029
    ldx #$01  ; chuckie.basm:3030
    jsr osbyte  ; chuckie.basm:3031
    lda #osbyte_0F_flush_buffer_class  ; chuckie.basm:3032
    ldx #$01  ; chuckie.basm:3033
    jsr osbyte  ; chuckie.basm:3034
    lda #osbyte_E5_escape_key_effect  ; chuckie.basm:3035
    ldx #$01  ; chuckie.basm:3036
    ldy #$00  ; chuckie.basm:3037
    jsr osbyte  ; chuckie.basm:3038
    ldx #<((osword_line_block))  ; chuckie.basm:3039
    ldy #>((osword_line_block))  ; chuckie.basm:3039
    lda #osword_0_read_line  ; chuckie.basm:3040
    jsr osword  ; chuckie.basm:3041
    ldx param  ; chuckie.basm:3042
    jsr location_of_highscore_x  ; chuckie.basm:3043
    ldy #$08  ; chuckie.basm:3044
copy_name_loop:  ; chuckie.basm:3045
    lda line_buffer-8,Y  ; chuckie.basm:3046
    cmp #$0D  ; chuckie.basm:3047
    beq rts_3  ; chuckie.basm:3048
    sta (sprite_lo),Y  ; chuckie.basm:3049
    iny   ; chuckie.basm:3050
    cpy #$10  ; chuckie.basm:3051
    bcc copy_name_loop  ; chuckie.basm:3052
rts_3:  ; chuckie.basm:3053
    rts   ; chuckie.basm:3054
msg_highscores:  ; chuckie.basm:3056
    .byte MSG_END_23-MSG_START_23  ; chuckie.basm:3057
MSG_START_23:  ; chuckie.basm:3057
    .byte $12, (0), (1)  ; chuckie.basm:3058
    .byte $19, (4), <((288)), >((288)), <((800)), >((800))  ; chuckie.basm:3059
    .byte "HIGH SCORES"  ; chuckie.basm:3060
    .byte $12, (0), (3)  ; chuckie.basm:3061
MSG_END_23:  ; chuckie.basm:3062
msg_highscore_move:  ; chuckie.basm:3064
    .byte MSG_END_24-MSG_START_24  ; chuckie.basm:3065
MSG_START_24:  ; chuckie.basm:3065
    .byte $19  ; chuckie.basm:3066
    .byte $04  ; chuckie.basm:3067
    .byte " "  ; chuckie.basm:3068
    .byte $00  ; chuckie.basm:3069
msg_highscore_y_lo:  ; chuckie.basm:3070
    .byte $00  ; chuckie.basm:3071
msg_highscore_y_hi:  ; chuckie.basm:3072
    .byte $00  ; chuckie.basm:3073
MSG_END_24:  ; chuckie.basm:3074
msg_name_move:  ; chuckie.basm:3076
    .byte MSG_END_25-MSG_START_25  ; chuckie.basm:3077
MSG_START_25:  ; chuckie.basm:3077
    .byte $12, (0), (1)  ; chuckie.basm:3078
    .byte $19  ; chuckie.basm:3079
    .byte $04  ; chuckie.basm:3080
    .byte $A0  ; chuckie.basm:3081
    .byte $02  ; chuckie.basm:3082
msg_name_y_lo:  ; chuckie.basm:3083
    .byte $00  ; chuckie.basm:3084
msg_name_y_hi:  ; chuckie.basm:3085
    .byte $00  ; chuckie.basm:3086
    .byte ">"  ; chuckie.basm:3087
MSG_END_25:  ; chuckie.basm:3088
msg_enter_your_name:  ; chuckie.basm:3090
    .byte MSG_END_26-MSG_START_26  ; chuckie.basm:3091
MSG_START_26:  ; chuckie.basm:3091
    .byte $18, <(0), >(0), <(0), >(0), <(1279), >(1279), <(892), >(892)  ; chuckie.basm:3092
    .byte $10  ; chuckie.basm:3093
    .byte $1A  ; chuckie.basm:3094
    .byte $12, (0), (1)  ; chuckie.basm:3095
    .byte $19, (4), <((160)), >((160)), <((160)), >((160))  ; chuckie.basm:3096
    .byte "ENTER YOUR NAME"  ; chuckie.basm:3097
    .byte $19, (4), <((384)), >((384)), <((100)), >((100))  ; chuckie.basm:3098
    .byte $12, (0), (2)  ; chuckie.basm:3099
    .byte "Player "  ; chuckie.basm:3100
MSG_END_26:  ; chuckie.basm:3101
osword_line_block:  ; chuckie.basm:3103
    .word line_buffer  ; chuckie.basm:3104
    .byte line_buffer_end - line_buffer - 1  ; chuckie.basm:3105
    .byte " "  ; chuckie.basm:3106
    .byte $7F  ; chuckie.basm:3107
line_buffer:  ; chuckie.basm:3108
    .byte $00  ; chuckie.basm:3109
    .byte $00  ; chuckie.basm:3110
    .byte $00  ; chuckie.basm:3111
    .byte $00  ; chuckie.basm:3112
    .byte $00  ; chuckie.basm:3113
    .byte $00  ; chuckie.basm:3114
    .byte $00  ; chuckie.basm:3115
    .byte $00  ; chuckie.basm:3116
    .byte $00  ; chuckie.basm:3117
line_buffer_end:  ; chuckie.basm:3118
entry_point:  ; chuckie.basm:3120
    jsr one_time_init  ; chuckie.basm:3122
outer_loop:  ; chuckie.basm:3123
    jsr carousel  ; chuckie.basm:3124
    jsr select_player_count  ; chuckie.basm:3125
one_life_loop:  ; chuckie.basm:3126
    ldx #<((msg_get_ready))  ; chuckie.basm:3127
    ldy #>((msg_get_ready))  ; chuckie.basm:3127
    jsr write_counted_string  ; chuckie.basm:3128
    ldx #<((msg_player))  ; chuckie.basm:3129
    ldy #>((msg_player))  ; chuckie.basm:3129
    jsr write_counted_string  ; chuckie.basm:3130
    lda player  ; chuckie.basm:3131
    clc   ; chuckie.basm:3132
    adc #$31  ; chuckie.basm:3133
    jsr oswrch  ; chuckie.basm:3134
    lda #$14  ; chuckie.basm:3135
    jsr sleep  ; chuckie.basm:3136
level_loop:  ; chuckie.basm:3137
    jsr init_level_state  ; chuckie.basm:3138
    jsr init_and_draw_level  ; chuckie.basm:3139
    jsr init_mobile_things  ; chuckie.basm:3140
    lda #osbyte_7C_clear_escape  ; chuckie.basm:3141
    jsr osbyte  ; chuckie.basm:3142
game_loop:  ; chuckie.basm:3143
    jsr test_keys  ; chuckie.basm:3144
    jsr update_harry  ; chuckie.basm:3145
    jsr harry_motion_noises  ; chuckie.basm:3146
    jsr update_lift  ; chuckie.basm:3147
    jsr update_birds_timers  ; chuckie.basm:3148
    jsr check_extra_lives  ; chuckie.basm:3149
    jsr hit_test_birds  ; chuckie.basm:3150
    jsr wait_for_interval_timer  ; chuckie.basm:3151
    lda dead_flag  ; chuckie.basm:3152
    bne harry_died  ; chuckie.basm:3153
    lda harry_y  ; chuckie.basm:3154
    cmp #$11  ; chuckie.basm:3155
    bcc harry_died  ; chuckie.basm:3156
    lda egg_remaining_count  ; chuckie.basm:3157
    beq eggs_all_collected  ; chuckie.basm:3158
    lda key_press_bits  ; chuckie.basm:3159
    bmi outer_loop  ; chuckie.basm:3160
    jmp game_loop  ; chuckie.basm:3161
eggs_all_collected:  ; chuckie.basm:3162
    lda bonus_gone_flag  ; chuckie.basm:3163
    bne bonus_already_gone  ; chuckie.basm:3164
accumulate_bonus_loop:  ; chuckie.basm:3165
    lda #$01  ; chuckie.basm:3166
    ldx #$06  ; chuckie.basm:3167
    jsr add_to_score  ; chuckie.basm:3168
    jsr decrement_bonus  ; chuckie.basm:3169
    jsr check_extra_lives  ; chuckie.basm:3170
    lda bonus_1  ; chuckie.basm:3171
    beq fifty_divides_bonus  ; chuckie.basm:3172
    cmp #$05  ; chuckie.basm:3173
    bne skip_bonus_sound  ; chuckie.basm:3174
fifty_divides_bonus:  ; chuckie.basm:3175
    ldx #<((sound4))  ; chuckie.basm:3176
    ldy #>((sound4))  ; chuckie.basm:3176
    lda #osword_7_play_sound  ; chuckie.basm:3177
    jsr osword  ; chuckie.basm:3178
skip_bonus_sound:  ; chuckie.basm:3179
    lda bonus_gone_flag  ; chuckie.basm:3180
    beq accumulate_bonus_loop  ; chuckie.basm:3181
bonus_already_gone:  ; chuckie.basm:3182
    inc level_number  ; chuckie.basm:3183
    jsr save_player_state  ; chuckie.basm:3184
    jsr init_player_level_state  ; chuckie.basm:3185
    jsr restore_player_state  ; chuckie.basm:3186
    jmp level_loop  ; chuckie.basm:3187
harry_died:  ; chuckie.basm:3188
    jsr save_player_state  ; chuckie.basm:3189
    ldx #<((dead_tune))  ; chuckie.basm:3190
    ldy #>((dead_tune))  ; chuckie.basm:3190
    jsr play_tune  ; chuckie.basm:3191
    ldx player  ; chuckie.basm:3192
    dec player_lives,X  ; chuckie.basm:3193
    bne lives_remaining  ; chuckie.basm:3194
    ldx #<((msg_game_over))  ; chuckie.basm:3195
    ldy #>((msg_game_over))  ; chuckie.basm:3195
    jsr write_counted_string  ; chuckie.basm:3196
    ldx #<((msg_player))  ; chuckie.basm:3197
    ldy #>((msg_player))  ; chuckie.basm:3197
    jsr write_counted_string  ; chuckie.basm:3198
    lda player  ; chuckie.basm:3199
    clc   ; chuckie.basm:3200
    adc #$31  ; chuckie.basm:3201
    jsr oswrch  ; chuckie.basm:3202
    lda #$0A  ; chuckie.basm:3203
    jsr sleep  ; chuckie.basm:3204
    lda #osbyte_7C_clear_escape  ; chuckie.basm:3205
    jsr osbyte  ; chuckie.basm:3206
    jsr check_highscore  ; chuckie.basm:3207
    lda #$05  ; chuckie.basm:3208
    jsr sleep  ; chuckie.basm:3209
    dec player_remaining_count  ; chuckie.basm:3210
    beq all_players_dead  ; chuckie.basm:3211
lives_remaining:  ; chuckie.basm:3212
    ldx player  ; chuckie.basm:3213
    inx   ; chuckie.basm:3214
    txa   ; chuckie.basm:3215
    and #$03  ; chuckie.basm:3216
    sta player  ; chuckie.basm:3217
    cmp player_total_count  ; chuckie.basm:3218
    bcs lives_remaining  ; chuckie.basm:3219
    tax   ; chuckie.basm:3220
    lda player_lives,X  ; chuckie.basm:3221
    beq lives_remaining  ; chuckie.basm:3222
    jsr restore_player_state  ; chuckie.basm:3223
    jmp one_life_loop  ; chuckie.basm:3224
all_players_dead:  ; chuckie.basm:3225
    jmp outer_loop  ; chuckie.basm:3226
msg_game_over:  ; chuckie.basm:3227
    .byte MSG_END_27-MSG_START_27  ; chuckie.basm:3228
MSG_START_27:  ; chuckie.basm:3228
    .byte $18, <(256), >(256), <(336), >(336), <(1024), >(1024), <(532), >(532)  ; chuckie.basm:3229
    .byte $10  ; chuckie.basm:3230
    .byte $1A  ; chuckie.basm:3231
    .byte $19, (4), <((352)), >((352)), <((500)), >((500))  ; chuckie.basm:3232
    .byte $12, (0), (8)  ; chuckie.basm:3233
    .byte "GAME OVER"  ; chuckie.basm:3234
MSG_END_27:  ; chuckie.basm:3235
msg_get_ready:  ; chuckie.basm:3237
    .byte MSG_END_28-MSG_START_28  ; chuckie.basm:3238
MSG_START_28:  ; chuckie.basm:3238
    .byte $10  ; chuckie.basm:3239
    .byte $19, (4), <((352)), >((352)), <((500)), >((500))  ; chuckie.basm:3240
    .byte $12, (0), (4)  ; chuckie.basm:3241
    .byte "Get Ready"  ; chuckie.basm:3242
    .byte $12, (0), (8)  ; chuckie.basm:3243
MSG_END_28:  ; chuckie.basm:3244
msg_player:  ; chuckie.basm:3246
    .byte MSG_END_29-MSG_START_29  ; chuckie.basm:3247
MSG_START_29:  ; chuckie.basm:3247
    .byte $19, (4), <((384)), >((384)), <((400)), >((400))  ; chuckie.basm:3248
    .byte "Player "  ; chuckie.basm:3249
MSG_END_29:  ; chuckie.basm:3250
one_time_init:  ; chuckie.basm:3252
    lda #osbyte_8C_select_tape  ; chuckie.basm:3253
    ldx #$0C  ; chuckie.basm:3254
    ldy #$00  ; chuckie.basm:3255
    jsr osbyte  ; chuckie.basm:3256
    ; RP6502: the BBC loader put this code at &3000 and this loop moved it
    ; down to &0900. The ROM loads it in place, so there is nothing to move.
    lda #$16  ; chuckie.basm:3277
    jsr oswrch  ; chuckie.basm:3278
    lda #$02  ; chuckie.basm:3279
    jsr oswrch  ; chuckie.basm:3280
    lda #$05  ; chuckie.basm:3281
    jsr oswrch  ; chuckie.basm:3282
    lda #$05  ; chuckie.basm:3283
    jsr oswrch  ; chuckie.basm:3284
    lda #$9D  ; chuckie.basm:3285
    sta key_jump  ; chuckie.basm:3286
    lda #$BE  ; chuckie.basm:3287
    sta key_up  ; chuckie.basm:3288
    lda #$9E  ; chuckie.basm:3289
    sta key_down  ; chuckie.basm:3290
    lda #$99  ; chuckie.basm:3291
    sta key_left  ; chuckie.basm:3292
    lda #$98  ; chuckie.basm:3293
    sta key_right  ; chuckie.basm:3294
    jsr init_highscores  ; chuckie.basm:3295
    ldx #<((envelope1))  ; chuckie.basm:3296
    ldy #>((envelope1))  ; chuckie.basm:3296
    lda #osword_8_define_envelope  ; chuckie.basm:3297
    jsr osword  ; chuckie.basm:3298
    ldx #<((envelope2))  ; chuckie.basm:3299
    ldy #>((envelope2))  ; chuckie.basm:3299
    lda #osword_8_define_envelope  ; chuckie.basm:3300
    jsr osword  ; chuckie.basm:3301
    ldx #<((envelope3))  ; chuckie.basm:3302
    ldy #>((envelope3))  ; chuckie.basm:3302
    lda #osword_8_define_envelope  ; chuckie.basm:3303
    jsr osword  ; chuckie.basm:3304
    ldx #$0F  ; chuckie.basm:3305
    stx param  ; chuckie.basm:3306
set_palette_loop:  ; chuckie.basm:3307
    ldx param  ; chuckie.basm:3308
    stx msg_palette_logical  ; chuckie.basm:3309
    lda palette_table,X  ; chuckie.basm:3310
    sta msg_palette_physical  ; chuckie.basm:3311
    ldx #<((msg_palette))  ; chuckie.basm:3312
    ldy #>((msg_palette))  ; chuckie.basm:3312
    jsr write_counted_string  ; chuckie.basm:3313
    dec param  ; chuckie.basm:3314
    bpl set_palette_loop  ; chuckie.basm:3315
    rts   ; chuckie.basm:3316
msg_palette:  ; chuckie.basm:3317
    .byte MSG_END_30-MSG_START_30  ; chuckie.basm:3318
MSG_START_30:  ; chuckie.basm:3318
    .byte $13  ; chuckie.basm:3319
msg_palette_logical:  ; chuckie.basm:3320
    .byte $00  ; chuckie.basm:3321
msg_palette_physical:  ; chuckie.basm:3322
    .byte $00  ; chuckie.basm:3323
    .byte $00  ; chuckie.basm:3324
    .byte $00  ; chuckie.basm:3325
    .byte $00  ; chuckie.basm:3326
MSG_END_30:  ; chuckie.basm:3327
palette_table:  ; chuckie.basm:3329
    .byte $00  ; chuckie.basm:3330
    .byte $03  ; chuckie.basm:3331
    .byte $05  ; chuckie.basm:3332
    .byte $02  ; chuckie.basm:3333
    .byte $03  ; chuckie.basm:3334
    .byte $03  ; chuckie.basm:3335
    .byte $03  ; chuckie.basm:3336
    .byte $03  ; chuckie.basm:3337
    .byte $06  ; chuckie.basm:3338
    .byte $06  ; chuckie.basm:3339
    .byte $06  ; chuckie.basm:3340
    .byte $06  ; chuckie.basm:3341
    .byte $03  ; chuckie.basm:3342
    .byte $03  ; chuckie.basm:3343
    .byte $03  ; chuckie.basm:3344
    .byte $03  ; chuckie.basm:3345
select_player_count:  ; chuckie.basm:3346
    ldx #<((msg_how_many_players))  ; chuckie.basm:3347
    ldy #>((msg_how_many_players))  ; chuckie.basm:3347
    jsr write_counted_string  ; chuckie.basm:3348
    ; RP6502: the original gave up after 25600 rounds of four INKEYs, about
    ; 14 s at 2 MHz but only 2 s at 8 MHz. It is timed now.
    lda #<1400
    ldx #>1400
    jsr plat_countdown
wait_for_player_count_loop:  ; chuckie.basm:3353
    ldx #scan_1 ^ $FF  ; chuckie.basm:3354
    ldy #$FF  ; chuckie.basm:3355
    lda #osbyte_81_inkey  ; chuckie.basm:3356
    jsr osbyte  ; chuckie.basm:3357
    cpy #$00  ; chuckie.basm:3358
    beq one_not_pressed  ; chuckie.basm:3359
    lda #$01  ; chuckie.basm:3360
    jmp init_player_count  ; chuckie.basm:3361
one_not_pressed:  ; chuckie.basm:3362
    ldx #scan_2 ^ $FF  ; chuckie.basm:3363
    ldy #$FF  ; chuckie.basm:3364
    lda #osbyte_81_inkey  ; chuckie.basm:3365
    jsr osbyte  ; chuckie.basm:3366
    cpy #$00  ; chuckie.basm:3367
    beq two_not_pressed  ; chuckie.basm:3368
    lda #$02  ; chuckie.basm:3369
    jmp init_player_count  ; chuckie.basm:3370
two_not_pressed:  ; chuckie.basm:3371
    ldx #scan_3 ^ $FF  ; chuckie.basm:3372
    ldy #$FF  ; chuckie.basm:3373
    lda #osbyte_81_inkey  ; chuckie.basm:3374
    jsr osbyte  ; chuckie.basm:3375
    cpy #$00  ; chuckie.basm:3376
    beq three_not_pressed  ; chuckie.basm:3377
    lda #$03  ; chuckie.basm:3378
    jmp init_player_count  ; chuckie.basm:3379
three_not_pressed:  ; chuckie.basm:3380
    ldx #scan_4 ^ $FF  ; chuckie.basm:3381
    ldy #$FF  ; chuckie.basm:3382
    lda #osbyte_81_inkey  ; chuckie.basm:3383
    jsr osbyte  ; chuckie.basm:3384
    cpy #$00  ; chuckie.basm:3385
    beq four_not_pressed  ; chuckie.basm:3386
    lda #$04  ; chuckie.basm:3387
    jmp init_player_count  ; chuckie.basm:3388
four_not_pressed:  ; chuckie.basm:3389
    jsr plat_counting
    bcs wait_for_player_count_loop
    pla   ; chuckie.basm:3394
    pla   ; chuckie.basm:3395
    jmp outer_loop  ; chuckie.basm:3396
init_player_count:  ; chuckie.basm:3397
    sta player_total_count  ; chuckie.basm:3398
    sta player_remaining_count  ; chuckie.basm:3399
    clc   ; chuckie.basm:3400
    adc #$30  ; chuckie.basm:3401
    jsr oswrch  ; chuckie.basm:3402
    lda #$05  ; chuckie.basm:3403
    jsr sleep  ; chuckie.basm:3404
init_players_state:  ; chuckie.basm:3405
    ldx #$03  ; chuckie.basm:3406
init_players_loop:  ; chuckie.basm:3407
    lda #$00  ; chuckie.basm:3408
    sta player_levels,X  ; chuckie.basm:3409
    lda #$05  ; chuckie.basm:3410
    sta player_lives,X  ; chuckie.basm:3411
    dex   ; chuckie.basm:3412
    bpl init_players_loop  ; chuckie.basm:3413
    ldx #$03  ; chuckie.basm:3414
    stx param  ; chuckie.basm:3415
init_players_scores_loop:  ; chuckie.basm:3416
    txa   ; chuckie.basm:3417
    asl a  ; chuckie.basm:3418
    asl a  ; chuckie.basm:3419
    asl a  ; chuckie.basm:3420
    asl a  ; chuckie.basm:3421
    asl a  ; chuckie.basm:3422
    asl a  ; chuckie.basm:3423
    tax   ; chuckie.basm:3424
    ldy #$07  ; chuckie.basm:3425
    lda #$00  ; chuckie.basm:3426
init_score_loop:  ; chuckie.basm:3427
    sta player_score,X  ; chuckie.basm:3428
    inx   ; chuckie.basm:3429
    dey   ; chuckie.basm:3430
    bpl init_score_loop  ; chuckie.basm:3431
    dec param  ; chuckie.basm:3432
    ldx param  ; chuckie.basm:3433
    bpl init_players_scores_loop  ; chuckie.basm:3434
    lda #$00  ; chuckie.basm:3435
    sta level_number  ; chuckie.basm:3436
    lda #$04  ; chuckie.basm:3437
    sta player  ; chuckie.basm:3438
init_players_level_state_loop:  ; chuckie.basm:3439
    dec player  ; chuckie.basm:3440
    jsr init_player_level_state  ; chuckie.basm:3441
    lda player  ; chuckie.basm:3442
    bne init_players_level_state_loop  ; chuckie.basm:3443
    jsr restore_player_state  ; chuckie.basm:3444
    lda #$1A  ; chuckie.basm:3445
    jsr oswrch  ; chuckie.basm:3446
    rts   ; chuckie.basm:3447
msg_how_many_players:  ; chuckie.basm:3448
    .byte MSG_END_31-MSG_START_31  ; chuckie.basm:3449
MSG_START_31:  ; chuckie.basm:3449
    .byte $10  ; chuckie.basm:3450
    .byte $19, (4), <((32)), >((32)), <((500)), >((500))  ; chuckie.basm:3451
    .byte "How many players? "  ; chuckie.basm:3452
MSG_END_31:  ; chuckie.basm:3453
sleep:  ; chuckie.basm:3455
    ; RP6502: a delay loop of about 0.16 s per count at 2 MHz, now timed.
    jmp plat_sleep
carousel:  ; chuckie.basm:3468
    tsx   ; chuckie.basm:3469
    stx carousel_stack_top  ; chuckie.basm:3470
    jsr init_four_players  ; chuckie.basm:3471
carousel_loop:  ; chuckie.basm:3472
    lda #$10  ; chuckie.basm:3473
    jsr oswrch  ; chuckie.basm:3474
    jsr draw_chuckie_banner  ; chuckie.basm:3475
    jsr draw_highscores  ; chuckie.basm:3476
    jsr draw_press_s_to_start  ; chuckie.basm:3477
    lda #$1E  ; chuckie.basm:3478
    sta loop_counter  ; chuckie.basm:3479
highscores_visible_loop:  ; chuckie.basm:3480
    jsr carousel_test_keys_sleep  ; chuckie.basm:3481
    dec loop_counter  ; chuckie.basm:3482
    bne highscores_visible_loop  ; chuckie.basm:3483
    jsr carousel_draw_game_screen  ; chuckie.basm:3484
    lda #$14  ; chuckie.basm:3485
    sta loop_counter  ; chuckie.basm:3486
game_screen_visible_loop:  ; chuckie.basm:3487
    jsr carousel_test_keys_sleep  ; chuckie.basm:3488
    dec loop_counter  ; chuckie.basm:3489
    bne game_screen_visible_loop  ; chuckie.basm:3490
    lda #$10  ; chuckie.basm:3491
    jsr oswrch  ; chuckie.basm:3492
    jsr draw_chuckie_banner  ; chuckie.basm:3493
    jsr draw_key_selection_indirect  ; chuckie.basm:3494
    jsr draw_press_s_to_start  ; chuckie.basm:3495
    lda #$1E  ; chuckie.basm:3496
    sta loop_counter  ; chuckie.basm:3497
key_selection_visible_loop:  ; chuckie.basm:3498
    jsr carousel_test_keys_sleep  ; chuckie.basm:3499
    dec loop_counter  ; chuckie.basm:3500
    bne key_selection_visible_loop  ; chuckie.basm:3501
    jsr carousel_draw_game_screen  ; chuckie.basm:3502
    lda #$14  ; chuckie.basm:3503
    sta loop_counter  ; chuckie.basm:3504
game_screen_visible_again_loop:  ; chuckie.basm:3505
    jsr carousel_test_keys_sleep  ; chuckie.basm:3506
    dec loop_counter  ; chuckie.basm:3507
    bne game_screen_visible_again_loop  ; chuckie.basm:3508
    jmp carousel_loop  ; chuckie.basm:3509
carousel_draw_game_screen:  ; chuckie.basm:3510
    jsr randomise  ; chuckie.basm:3511
    lda rand1  ; chuckie.basm:3512
    and #$07  ; chuckie.basm:3513
    sta level_number  ; chuckie.basm:3514
    sta scenario_number  ; chuckie.basm:3515
    jsr init_and_draw_level  ; chuckie.basm:3516
    jsr init_mobile_things  ; chuckie.basm:3517
    rts   ; chuckie.basm:3518
init_four_players:  ; chuckie.basm:3519
    lda #$04  ; chuckie.basm:3520
    sta player_total_count  ; chuckie.basm:3521
    sta player_remaining_count  ; chuckie.basm:3522
    jsr init_players_state  ; chuckie.basm:3523
    jsr init_level_state  ; chuckie.basm:3524
    rts   ; chuckie.basm:3525
draw_chuckie_banner:  ; chuckie.basm:3526
    jsr plat_layout_menu    ; RP6502: show the rows of the title screens
    lda #$02
    sta sprite_colour_mask_left  ; chuckie.basm:3528
    lda #$30  ; chuckie.basm:3529
    ldx #$02  ; chuckie.basm:3530
    ldy #$F0  ; chuckie.basm:3531
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3532
    lda #$31  ; chuckie.basm:3533
    ldx #$11  ; chuckie.basm:3534
    ldy #$F0  ; chuckie.basm:3535
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3536
    lda #$32  ; chuckie.basm:3537
    ldx #$20  ; chuckie.basm:3538
    ldy #$F0  ; chuckie.basm:3539
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3540
    lda #$30  ; chuckie.basm:3541
    ldx #$2F  ; chuckie.basm:3542
    ldy #$F0  ; chuckie.basm:3543
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3544
    lda #$33  ; chuckie.basm:3545
    ldx #$3E  ; chuckie.basm:3546
    ldy #$F0  ; chuckie.basm:3547
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3548
    lda #$34  ; chuckie.basm:3549
    ldx #$4D  ; chuckie.basm:3550
    ldy #$F0  ; chuckie.basm:3551
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3552
    lda #$35  ; chuckie.basm:3553
    ldx #$5C  ; chuckie.basm:3554
    ldy #$F0  ; chuckie.basm:3555
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3556
    lda #$35  ; chuckie.basm:3557
    ldx #$72  ; chuckie.basm:3558
    ldy #$F0  ; chuckie.basm:3559
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3560
    lda #$36  ; chuckie.basm:3561
    ldx #$81  ; chuckie.basm:3562
    ldy #$F0  ; chuckie.basm:3563
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3564
    lda #$36  ; chuckie.basm:3565
    ldx #$90  ; chuckie.basm:3566
    ldy #$F0  ; chuckie.basm:3567
    jsr draw_chuckie_banner_letter  ; chuckie.basm:3568
    rts   ; chuckie.basm:3569
draw_press_s_to_start:  ; chuckie.basm:3570
    ldx #<((msg_press_s_to_start))  ; chuckie.basm:3571
    ldy #>((msg_press_s_to_start))  ; chuckie.basm:3571
    jsr write_counted_string  ; chuckie.basm:3572
    rts   ; chuckie.basm:3573
msg_press_s_to_start:  ; chuckie.basm:3574
    .byte MSG_END_32-MSG_START_32  ; chuckie.basm:3575
MSG_START_32:  ; chuckie.basm:3575
    .byte $19, (4), <((128)), >((128)), <((100)), >((100))  ; chuckie.basm:3576
    .byte $12, (0), (4)  ; chuckie.basm:3577
    .byte "Press "  ; chuckie.basm:3578
    .byte $12, (0), (8)  ; chuckie.basm:3579
    .byte "S "  ; chuckie.basm:3580
    .byte $12, (0), (4)  ; chuckie.basm:3581
    .byte "to start"  ; chuckie.basm:3582
    .byte $19, (4), <((128)), >((128)), <((50)), >((50))  ; chuckie.basm:3583
    .byte $12, (0), (8)  ; chuckie.basm:3584
    .byte "K "  ; chuckie.basm:3585
    .byte $12, (0), (4)  ; chuckie.basm:3586
    .byte "to change keys"  ; chuckie.basm:3587
MSG_END_32:  ; chuckie.basm:3588
carousel_test_keys:  ; chuckie.basm:3590
    lda #osbyte_81_inkey  ; chuckie.basm:3591
    ldx #scan_S ^ $FF  ; chuckie.basm:3592
    ldy #$FF  ; chuckie.basm:3593
    jsr osbyte  ; chuckie.basm:3594
    cpy #$00  ; chuckie.basm:3595
    beq s_not_pressed  ; chuckie.basm:3596
    ldx carousel_stack_top  ; chuckie.basm:3597
    txs   ; chuckie.basm:3598
    rts   ; chuckie.basm:3599
s_not_pressed:  ; chuckie.basm:3600
    lda #osbyte_81_inkey  ; chuckie.basm:3601
    ldx #scan_K ^ $FF  ; chuckie.basm:3602
    ldy #$FF  ; chuckie.basm:3603
    jsr osbyte  ; chuckie.basm:3604
    cpy #$00  ; chuckie.basm:3605
    bne k_pressed  ; chuckie.basm:3606
    rts   ; chuckie.basm:3607
k_pressed:  ; chuckie.basm:3608
    ldx carousel_stack_top  ; chuckie.basm:3609
    txs   ; chuckie.basm:3610
    jsr select_keys  ; chuckie.basm:3611
    jmp carousel_loop  ; chuckie.basm:3612
carousel_test_keys_sleep:  ; chuckie.basm:3613
    ; RP6502: a delay loop of about 0.16 s at 2 MHz, now timed. S and K
    ; are tested all the time, so that a short press is not missed.
    lda #16
    ldx #0
    jsr plat_countdown
:   jsr carousel_test_keys
    jsr plat_counting
    bcs :-
    ldx #0
    ldy #0
    rts
draw_chuckie_banner_letter:  ; chuckie.basm:3623
    pha   ; chuckie.basm:3624
    jsr calculate_screen_location  ; chuckie.basm:3625
    pla   ; chuckie.basm:3626
    jsr lookup_sprite  ; chuckie.basm:3627
    jsr draw_sprite  ; chuckie.basm:3628
    rts   ; chuckie.basm:3629
init_level_state:  ; chuckie.basm:3630
    lda level_number  ; chuckie.basm:3631
    and #$07  ; chuckie.basm:3632
    sta scenario_number  ; chuckie.basm:3633
    lda level_number  ; chuckie.basm:3634
    lsr a  ; chuckie.basm:3635
    lsr a  ; chuckie.basm:3636
    lsr a  ; chuckie.basm:3637
    sta round_number  ; chuckie.basm:3638
    lda #$00  ; chuckie.basm:3639
    sta duck_loose_flag  ; chuckie.basm:3640
    lda round_number  ; chuckie.basm:3641
    beq not_first_round  ; chuckie.basm:3642
    inc duck_loose_flag  ; chuckie.basm:3643
not_first_round:  ; chuckie.basm:3644
    lda #$00  ; chuckie.basm:3645
    sta birds_timer_cycle  ; chuckie.basm:3646
    lda #$00  ; chuckie.basm:3647
    sta current_chicken  ; chuckie.basm:3648
    lda #$08  ; chuckie.basm:3649
    ldx round_number  ; chuckie.basm:3650
    cpx #$04  ; chuckie.basm:3651
    bcc early_round_slow_chickens  ; chuckie.basm:3652
    lda #$05  ; chuckie.basm:3653
early_round_slow_chickens:  ; chuckie.basm:3654
    sta chicken_speed  ; chuckie.basm:3655
    lda #$00  ; chuckie.basm:3656
    sta extra_life_flag  ; chuckie.basm:3657
    sta dead_flag  ; chuckie.basm:3658
    sta clock_stop_timer  ; chuckie.basm:3659
    lda #$76  ; chuckie.basm:3660
    sta rand1  ; chuckie.basm:3661
    sta rand2  ; chuckie.basm:3662
    sta rand3  ; chuckie.basm:3663
    sta rand4  ; chuckie.basm:3664
    rts   ; chuckie.basm:3665
init_player_level_state:  ; chuckie.basm:3666
    lda player  ; chuckie.basm:3667
    asl a  ; chuckie.basm:3668
    asl a  ; chuckie.basm:3669
    asl a  ; chuckie.basm:3670
    asl a  ; chuckie.basm:3671
    asl a  ; chuckie.basm:3672
    asl a  ; chuckie.basm:3673
    tax   ; chuckie.basm:3674
    lda level_number  ; chuckie.basm:3675
    clc   ; chuckie.basm:3676
    adc #$01  ; chuckie.basm:3677
    cmp #$0A  ; chuckie.basm:3678
    bcc bonus_in_range  ; chuckie.basm:3679
    lda #$09  ; chuckie.basm:3680
bonus_in_range:  ; chuckie.basm:3681
    sta player_level_bonus,X  ; chuckie.basm:3682
    lda #$00  ; chuckie.basm:3683
    sta $0509,X  ; chuckie.basm:3684
    sta $050A,X  ; chuckie.basm:3685
    sta $050B,X  ; chuckie.basm:3686
    ldy #$10  ; chuckie.basm:3687
clear_flags_loop:  ; chuckie.basm:3688
    sta player_egg_flags,X  ; chuckie.basm:3689
    sta player_grain_flags,X  ; chuckie.basm:3690
    inx   ; chuckie.basm:3691
    dey   ; chuckie.basm:3692
    bne clear_flags_loop  ; chuckie.basm:3693
    rts   ; chuckie.basm:3694
restore_player_state:  ; chuckie.basm:3695
    ldx player  ; chuckie.basm:3696
    lda player_levels,X  ; chuckie.basm:3697
    sta level_number  ; chuckie.basm:3698
    txa   ; chuckie.basm:3699
    asl a  ; chuckie.basm:3700
    asl a  ; chuckie.basm:3701
    asl a  ; chuckie.basm:3702
    asl a  ; chuckie.basm:3703
    asl a  ; chuckie.basm:3704
    asl a  ; chuckie.basm:3705
    sta player_data_index  ; chuckie.basm:3706
    tax   ; chuckie.basm:3707
    ldy #$00  ; chuckie.basm:3708
restore_score_loop:  ; chuckie.basm:3709
    lda player_score,X  ; chuckie.basm:3710
    sta current_score,Y  ; chuckie.basm:3711
    inx   ; chuckie.basm:3712
    iny   ; chuckie.basm:3713
    cpy #$08  ; chuckie.basm:3714
    bcc restore_score_loop  ; chuckie.basm:3715
    ldx player_data_index  ; chuckie.basm:3716
    ldy #$00  ; chuckie.basm:3717
restore_bonus_loop:  ; chuckie.basm:3718
    lda player_level_bonus,X  ; chuckie.basm:3719
    sta bonus_3,Y  ; chuckie.basm:3720
    inx   ; chuckie.basm:3721
    iny   ; chuckie.basm:3722
    cpy #$04  ; chuckie.basm:3723
    bcc restore_bonus_loop  ; chuckie.basm:3724
    ldx player  ; chuckie.basm:3725
    lda #$00  ; chuckie.basm:3726
    clc   ; chuckie.basm:3727
x_times_34_loop_2:  ; chuckie.basm:3728
    adc #$22  ; chuckie.basm:3729
    dex   ; chuckie.basm:3730
    bpl x_times_34_loop_2  ; chuckie.basm:3731
    sec   ; chuckie.basm:3732
    sbc #$15  ; chuckie.basm:3733
    sta score_x_position  ; chuckie.basm:3734
    rts   ; chuckie.basm:3735
save_player_state:  ; chuckie.basm:3736
    ldx player  ; chuckie.basm:3737
    lda level_number  ; chuckie.basm:3738
    sta player_levels,X  ; chuckie.basm:3739
    ldx player_data_index  ; chuckie.basm:3740
    ldy #$00  ; chuckie.basm:3741
save_score_loop:  ; chuckie.basm:3742
    lda current_score,Y  ; chuckie.basm:3743
    sta player_score,X  ; chuckie.basm:3744
    inx   ; chuckie.basm:3745
    iny   ; chuckie.basm:3746
    cpy #$08  ; chuckie.basm:3747
    bcc save_score_loop  ; chuckie.basm:3748
    ldx player_data_index  ; chuckie.basm:3749
    ldy #$00  ; chuckie.basm:3750
save_bonus_loop:  ; chuckie.basm:3751
    lda bonus_3,Y  ; chuckie.basm:3752
    sta player_level_bonus,X  ; chuckie.basm:3753
    inx   ; chuckie.basm:3754
    iny   ; chuckie.basm:3755
    cpy #$04  ; chuckie.basm:3756
    bcc save_bonus_loop  ; chuckie.basm:3757
    rts   ; chuckie.basm:3758
init_mobile_things:  ; chuckie.basm:3759
    lda lift_flag  ; chuckie.basm:3760
    beq no_lift_4  ; chuckie.basm:3761
    lda #$08  ; chuckie.basm:3762
    sta lift_y1  ; chuckie.basm:3763
    lda #$5A  ; chuckie.basm:3764
    sta lift_y2  ; chuckie.basm:3765
    lda #$00  ; chuckie.basm:3766
    sta lift_alternator  ; chuckie.basm:3767
    lda #$02  ; chuckie.basm:3768
    sta sprite_colour_mask_left  ; chuckie.basm:3769
    lda #$05  ; chuckie.basm:3770
    jsr lookup_sprite  ; chuckie.basm:3771
    ldx lift_x  ; chuckie.basm:3772
    ldy lift_y1  ; chuckie.basm:3773
    jsr calculate_screen_location  ; chuckie.basm:3774
    jsr draw_sprite  ; chuckie.basm:3775
    lda #$05  ; chuckie.basm:3776
    jsr lookup_sprite  ; chuckie.basm:3777
    ldx lift_x  ; chuckie.basm:3778
    ldy lift_y2  ; chuckie.basm:3779
    jsr calculate_screen_location  ; chuckie.basm:3780
    jsr draw_sprite  ; chuckie.basm:3781
no_lift_4:  ; chuckie.basm:3782
    lda #$04  ; chuckie.basm:3783
    sta duck_x  ; chuckie.basm:3784
    lda #$CC  ; chuckie.basm:3785
    sta duck_y  ; chuckie.basm:3786
    lda #$00  ; chuckie.basm:3787
    sta duck_vx  ; chuckie.basm:3788
    sta duck_vy  ; chuckie.basm:3789
    sta duck_direction_flap  ; chuckie.basm:3790
    jsr draw_duck  ; chuckie.basm:3791
    ldx #$FF  ; chuckie.basm:3792
    stx param  ; chuckie.basm:3793
    lda round_number  ; chuckie.basm:3794
    cmp #$01  ; chuckie.basm:3795
    bne round_has_chickens  ; chuckie.basm:3796
    ldx #$00  ; chuckie.basm:3797
    stx chicken_count  ; chuckie.basm:3798
round_has_chickens:  ; chuckie.basm:3799
    cmp #$03  ; chuckie.basm:3800
    bcc init_chickens_loop  ; chuckie.basm:3801
    ldx #$05  ; chuckie.basm:3802
    stx chicken_count  ; chuckie.basm:3803
init_chickens_loop:  ; chuckie.basm:3804
    inc param  ; chuckie.basm:3805
    ldx param  ; chuckie.basm:3806
    cpx chicken_count  ; chuckie.basm:3807
    bcs done_chickens  ; chuckie.basm:3808
    lda chicken_board_xs,X  ; chuckie.basm:3809
    asl a  ; chuckie.basm:3810
    asl a  ; chuckie.basm:3811
    asl a  ; chuckie.basm:3812
    sta chicken_xs,X  ; chuckie.basm:3813
    lda chicken_board_ys,X  ; chuckie.basm:3814
    asl a  ; chuckie.basm:3815
    asl a  ; chuckie.basm:3816
    asl a  ; chuckie.basm:3817
    clc   ; chuckie.basm:3818
    adc #$14  ; chuckie.basm:3819
    sta chicken_ys,X  ; chuckie.basm:3820
    lda #$00  ; chuckie.basm:3821
    sta chicken_states,X  ; chuckie.basm:3822
    sta chicken_sprite_indices,X  ; chuckie.basm:3823
    lda #$02  ; chuckie.basm:3824
    sta chicken_directions,X  ; chuckie.basm:3825
    jsr draw_chicken  ; chuckie.basm:3826
    jmp init_chickens_loop  ; chuckie.basm:3827
done_chickens:  ; chuckie.basm:3828
    lda #$03  ; chuckie.basm:3829
    jsr sleep  ; chuckie.basm:3830
    lda #$3C  ; chuckie.basm:3831
    sta harry_x  ; chuckie.basm:3832
    lda #$20  ; chuckie.basm:3833
    sta harry_y  ; chuckie.basm:3834
    lda #$06  ; chuckie.basm:3835
    sta harry_sprite_index  ; chuckie.basm:3836
    jsr draw_harry  ; chuckie.basm:3837
    lda #$07  ; chuckie.basm:3838
    sta harry_board_x  ; chuckie.basm:3839
    sta harry_cell_x  ; chuckie.basm:3840
    lda #$02  ; chuckie.basm:3841
    sta harry_board_y  ; chuckie.basm:3842
    lda #$00  ; chuckie.basm:3843
    sta harry_cell_y  ; chuckie.basm:3844
    sta harry_state  ; chuckie.basm:3845
    lda #$01  ; chuckie.basm:3846
    sta harry_facing  ; chuckie.basm:3847
    jsr draw_current_life_marker  ; chuckie.basm:3848
    rts   ; chuckie.basm:3849
check_extra_lives:  ; chuckie.basm:3850
    lda extra_life_flag  ; chuckie.basm:3851
    bne extra_life  ; chuckie.basm:3852
    rts   ; chuckie.basm:3853
extra_life:  ; chuckie.basm:3854
    lda #$00  ; chuckie.basm:3855
    sta extra_life_flag  ; chuckie.basm:3856
    jsr draw_current_life_marker  ; chuckie.basm:3857
    ldx player  ; chuckie.basm:3858
    inc player_lives,X  ; chuckie.basm:3859
    rts   ; chuckie.basm:3860
draw_current_life_marker:  ; chuckie.basm:3861
    lda #$20  ; chuckie.basm:3862
    sta sprite_colour_mask_left  ; chuckie.basm:3863
    ldx player  ; chuckie.basm:3864
    lda player_lives,X  ; chuckie.basm:3865
    cmp #$09  ; chuckie.basm:3866
    bcc marker_visible  ; chuckie.basm:3867
    rts   ; chuckie.basm:3868
marker_visible:  ; chuckie.basm:3869
    asl a  ; chuckie.basm:3870
    asl a  ; chuckie.basm:3871
    adc score_x_position  ; chuckie.basm:3872
    adc #$0A  ; chuckie.basm:3873
    tax   ; chuckie.basm:3874
    ldy #$EE  ; chuckie.basm:3875
    jsr calculate_screen_location  ; chuckie.basm:3876
    lda #$2F  ; chuckie.basm:3877
    jsr lookup_sprite  ; chuckie.basm:3878
    jsr draw_sprite  ; chuckie.basm:3879
    rts   ; chuckie.basm:3880
play_tune:  ; chuckie.basm:3881
    stx sprite_lo  ; chuckie.basm:3882
    sty sprite_hi  ; chuckie.basm:3883
    ldy #$00  ; chuckie.basm:3884
    sty $89  ; chuckie.basm:3885
    lda (sprite_lo),Y  ; chuckie.basm:3886
    sta loop_counter  ; chuckie.basm:3887
play_tune_loop:  ; chuckie.basm:3888
    ldy $89  ; chuckie.basm:3889
    iny   ; chuckie.basm:3890
    lda (sprite_lo),Y  ; chuckie.basm:3891
    sta sound2_pitch  ; chuckie.basm:3892
    iny   ; chuckie.basm:3893
    lda (sprite_lo),Y  ; chuckie.basm:3894
    sta sound2_duration  ; chuckie.basm:3895
    sty $89  ; chuckie.basm:3896
    ldx #<((sound2))  ; chuckie.basm:3897
    ldy #>((sound2))  ; chuckie.basm:3897
    lda #osword_7_play_sound  ; chuckie.basm:3898
    jsr osword  ; chuckie.basm:3899
    dec loop_counter  ; chuckie.basm:3900
    bne play_tune_loop  ; chuckie.basm:3901
    rts   ; chuckie.basm:3902
dead_tune:  ; chuckie.basm:3903
    .byte $10  ; chuckie.basm:3904
    .byte "!"  ; chuckie.basm:3905
    .byte $04  ; chuckie.basm:3906
    .byte ")"  ; chuckie.basm:3907
    .byte $02  ; chuckie.basm:3908
    .byte "!"  ; chuckie.basm:3909
    .byte $04  ; chuckie.basm:3910
    .byte $19  ; chuckie.basm:3911
    .byte $02  ; chuckie.basm:3912
    .byte $15  ; chuckie.basm:3913
    .byte $04  ; chuckie.basm:3914
    .byte $05  ; chuckie.basm:3915
    .byte $02  ; chuckie.basm:3916
    .byte $0D  ; chuckie.basm:3917
    .byte $04  ; chuckie.basm:3918
    .byte $01  ; chuckie.basm:3919
    .byte $02  ; chuckie.basm:3920
    .byte $05  ; chuckie.basm:3921
    .byte $0C  ; chuckie.basm:3922
    .byte $05  ; chuckie.basm:3923
    .byte $01  ; chuckie.basm:3924
    .byte $0D  ; chuckie.basm:3925
    .byte $01  ; chuckie.basm:3926
    .byte $15  ; chuckie.basm:3927
    .byte $01  ; chuckie.basm:3928
    .byte $19  ; chuckie.basm:3929
    .byte $01  ; chuckie.basm:3930
    .byte "!"  ; chuckie.basm:3931
    .byte $01  ; chuckie.basm:3932
    .byte "1"  ; chuckie.basm:3933
    .byte $01  ; chuckie.basm:3934
    .byte "5"  ; chuckie.basm:3935
    .byte $01  ; chuckie.basm:3936
envelope1:  ; chuckie.basm:3937
    .byte $01  ; chuckie.basm:3938
    .byte $01  ; chuckie.basm:3939
    .byte $00  ; chuckie.basm:3940
    .byte $00  ; chuckie.basm:3941
    .byte $00  ; chuckie.basm:3942
    .byte $00  ; chuckie.basm:3943
    .byte $00  ; chuckie.basm:3944
    .byte $00  ; chuckie.basm:3945
    .byte "~"  ; chuckie.basm:3946
    .byte $CE  ; chuckie.basm:3947
    .byte $00  ; chuckie.basm:3948
    .byte $00  ; chuckie.basm:3949
    .byte "d"  ; chuckie.basm:3950
    .byte $00  ; chuckie.basm:3951
envelope2:  ; chuckie.basm:3952
    .byte $02  ; chuckie.basm:3953
    .byte $01  ; chuckie.basm:3954
    .byte $00  ; chuckie.basm:3955
    .byte $00  ; chuckie.basm:3956
    .byte $00  ; chuckie.basm:3957
    .byte $00  ; chuckie.basm:3958
    .byte $00  ; chuckie.basm:3959
    .byte $00  ; chuckie.basm:3960
    .byte "~"  ; chuckie.basm:3961
    .byte $FE  ; chuckie.basm:3962
    .byte $00  ; chuckie.basm:3963
    .byte $FB  ; chuckie.basm:3964
    .byte "~d"  ; chuckie.basm:3965
envelope3:  ; chuckie.basm:3966
    .byte $03  ; chuckie.basm:3967
    .byte $01  ; chuckie.basm:3968
    .byte $00  ; chuckie.basm:3969
    .byte $00  ; chuckie.basm:3970
    .byte $00  ; chuckie.basm:3971
    .byte $00  ; chuckie.basm:3972
    .byte $00  ; chuckie.basm:3973
    .byte $00  ; chuckie.basm:3974
    .byte "2"  ; chuckie.basm:3975
    .byte $00  ; chuckie.basm:3976
    .byte $00  ; chuckie.basm:3977
    .byte $E7  ; chuckie.basm:3978
    .byte "d"  ; chuckie.basm:3979
    .byte $00  ; chuckie.basm:3980
end_padding:  ; chuckie.basm:3981
    .byte $00  ; chuckie.basm:3982
    .byte $00  ; chuckie.basm:3983
    .byte $00  ; chuckie.basm:3984
    .byte $00  ; chuckie.basm:3985
    .byte $00  ; chuckie.basm:3986
    ; COPYBLOCK &0900,&1100,&3000 (dropped)
    ; SAVE &1100,&3800,entry_point (dropped)
