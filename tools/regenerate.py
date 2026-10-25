#!/usr/bin/env python3
"""Rebuilds src/chuckie.s and src/tables.inc from their sources, and checks
that the converter still reproduces the original BBC Micro executable.

Usage: tools/regenerate.py <path to a clone of mungre/chuckie>

Needs ca65 and ld65 (cc65) on the PATH. src/chuckie.s is overwritten, so
make changes to the game in tools/port.py, or stop using this script and
edit src/chuckie.s directly.
"""
import os
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)


def run(*cmd):
    subprocess.run(cmd, check=True)


def main():
    if len(sys.argv) != 2:
        raise SystemExit(__doc__)
    chuckie = sys.argv[1]
    main_basm = os.path.join(chuckie, "asm", "main.basm")
    original = os.path.join(chuckie, "src", "CH_EGG.bin")
    with tempfile.TemporaryDirectory() as tmp:
        converted = os.path.join(tmp, "converted.s")
        run(sys.executable, os.path.join(HERE, "basm2ca65.py"), main_basm, converted)

        # The converted code at $0900, as the BBC loader leaves it.
        cfg = os.path.join(tmp, "verify.cfg")
        with open(cfg, "w") as f:
            f.write("MEMORY { M: start = $0900, size = $F000, file = %O; }\n"
                    "SEGMENTS { CODE: load = M, type = rw; }\n")
        src = os.path.join(tmp, "verify.s")
        with open(converted) as f, open(src, "w") as g:
            for line in f:
                g.write(";" + line if line.lstrip().startswith(".org") else line)
        obj, binary = os.path.join(tmp, "verify.o"), os.path.join(tmp, "verify.bin")
        run("ca65", "-o", obj, src)
        run("ld65", "-C", cfg, "-o", binary, obj)
        built = open(binary, "rb").read()
        # CH_EGG loads at &1100; its last 2 KB, at &3000, is the code that the
        # loader moves down to &0900.
        built = built[0x800:] + built[:0x800]
        if built != open(original, "rb").read():
            raise SystemExit("The converted code differs from CH_EGG.bin.")
        print("The converted code is byte for byte the original CH_EGG.")

        run(sys.executable, os.path.join(HERE, "port.py"), converted,
            os.path.join(ROOT, "src", "chuckie.s"))
    run(sys.executable, os.path.join(HERE, "gen_tables.py"),
        os.path.join(HERE, "font8x8_basic.h"), os.path.join(ROOT, "src", "tables.inc"))
    print("Wrote src/chuckie.s and src/tables.inc.")


if __name__ == "__main__":
    main()
