#!/usr/bin/env python3
"""Applies the RP6502 changes to the converted game source.

The game itself is unchanged except for these places, found by their
beebasm line numbers (the "; chuckie.basm:N" comments that basm2ca65.py
writes). Everything that was BBC Micro hardware or MOS now lives in
src/platform.s.

Usage: port.py converted.s src/chuckie.s
"""
import re
import sys

# (first line, last line, replacement) in chuckie.basm line numbers.
PATCHES = [
    (97, 101, """\
; RP6502: the MOS entry points are in platform.s.
.import oswrch, osword, osbyte"""),
    (603, 736, """\
; RP6502: draw_sprite and calculate_screen_location drew into the BBC
; screen memory at &3000. They are in platform.s, and draw into the XRAM
; bitmap.
.import draw_sprite, calculate_screen_location"""),
    (3257, 3276, """\
    ; RP6502: the BBC loader put this code at &3000 and this loop moved it
    ; down to &0900. The ROM loads it in place, so there is nothing to move."""),
    (971, 971, """\
    jsr plat_layout_game    ; RP6502: show the rows of the game screen
    jsr draw_game_stats"""),
    (3527, 3527, """\
    jsr plat_layout_menu    ; RP6502: show the rows of the title screens
    lda #$02"""),
    (3349, 3352, """\
    ; RP6502: the original gave up after 25600 rounds of four INKEYs, about
    ; 14 s at 2 MHz but only 2 s at 8 MHz. It is timed now.
    lda #<1400
    ldx #>1400
    jsr plat_countdown"""),
    (3390, 3393, """\
    jsr plat_counting
    bcs wait_for_player_count_loop"""),
    (3456, 3467, """\
    ; RP6502: a delay loop of about 0.16 s per count at 2 MHz, now timed.
    jmp plat_sleep"""),
    (3614, 3622, """\
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
    rts"""),
]

HEADER = """\
; Chuckie Egg for the Picocomputer 6502 (RP6502).
;
; The game code of Chuckie Egg for the BBC Micro, from the mungre/chuckie
; disassembly. tools/basm2ca65.py converted it to ca65 and tools/port.py
; applied the changes marked RP6502. The rest is the original code.

.segment "GAME"
.export entry_point
.import plat_sleep, plat_countdown, plat_counting, plat_layout_game, plat_layout_menu
"""


def main():
    src, dst = sys.argv[1], sys.argv[2]
    lines = open(src).read().split("\n")
    tag = re.compile(r";\s*chuckie\.basm:(\d+)\s*$")
    out = []
    done = set()
    for line in lines:
        if re.match(r"\s*\.org\b", line):
            continue
        m = tag.search(line)
        n = int(m.group(1)) if m else None
        hit = None
        for i, (a, b, text) in enumerate(PATCHES):
            if n is not None and a <= n <= b:
                hit = i
                break
        if hit is None:
            out.append(line)
        elif hit not in done:
            done.add(hit)
            out.append(PATCHES[hit][2])
    missing = set(range(len(PATCHES))) - done
    if missing:
        raise SystemExit("patches not applied: %s" % sorted(missing))
    body = "\n".join(out)
    body = re.sub(r"\A(;[^\n]*\n)+\n?", "", body)  # drop the converter header
    open(dst, "w").write(HEADER + "\n" + body)


if __name__ == "__main__":
    main()
