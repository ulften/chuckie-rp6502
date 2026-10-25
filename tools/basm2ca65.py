#!/usr/bin/env python3
"""Convert the mungre/chuckie beebasm sources to one flat ca65 file.

beebasm features handled: INCLUDE, MACRO/ENDMACRO (expanded here),
{ } scopes with .label and .^label (flattened, names made unique),
name=value constants, EQUB/EQUW/EQUS, &hex, %binary, MOD/DIV/EOR/AND/OR.
ORG becomes .org. COPYBLOCK and SAVE are dropped (the caller places the
code).

Usage: basm2ca65.py main.basm out.s
"""
import os
import re
import sys

IDENT = re.compile(r"[A-Za-z_][A-Za-z_0-9]*")
MNEMONICS = set("""ADC AND ASL BCC BCS BEQ BIT BMI BNE BPL BRK BVC BVS CLC CLD CLI
CLV CMP CPX CPY DEC DEX DEY EOR INC INX INY JMP JSR LDA LDX LDY LSR NOP ORA
PHA PHP PLA PLP ROL ROR RTI RTS SBC SEC SED SEI STA STX STY TAX TAY TSX TXA
TXS TYA""".split())
KEYWORDS = {"A", "X", "Y", "MOD", "DIV", "EOR", "AND", "OR", "NOT", "LO", "HI"}


def strip_comment(line):
    out, q = [], False
    for ch in line:
        if ch == '"':
            q = not q
        if ch in ";\\" and not q:
            break
        out.append(ch)
    return "".join(out).rstrip()


def read(path, out):
    base = os.path.dirname(path)
    with open(path) as f:
        for n, raw in enumerate(f, 1):
            line = strip_comment(raw.rstrip("\n"))
            m = re.match(r'\s*INCLUDE\s+"([^"]+)"', line)
            if m:
                read(os.path.join(base, m.group(1)), out)
                continue
            out.append((os.path.basename(path), n, line, raw.rstrip("\n")))


def split_args(s):
    parts, depth, cur, q = [], 0, "", False
    for ch in s:
        if ch == '"':
            q = not q
        if not q and ch == "(":
            depth += 1
        if not q and ch == ")":
            depth -= 1
        if ch == "," and depth == 0 and not q:
            parts.append(cur.strip())
            cur = ""
        else:
            cur += ch
    if cur.strip():
        parts.append(cur.strip())
    return parts


def expand_macros(lines):
    macros, out, i = {}, [], 0
    while i < len(lines):
        f, n, line, raw = lines[i]
        m = re.match(r"\s*MACRO\s+(\w+)\s*(.*)$", line)
        if m:
            name = m.group(1)
            params = [p.strip() for p in m.group(2).split(",") if p.strip()]
            body = []
            i += 1
            while not re.match(r"\s*ENDMACRO", lines[i][2]):
                body.append(lines[i][2])
                i += 1
            macros[name] = (params, body)
            i += 1
            continue
        out.append(lines[i])
        i += 1
    changed = True
    while changed:
        changed = False
        res = []
        for f, n, line, raw in out:
            m = re.match(r"(\s*)(\w+)\s*(.*)$", line)
            if m and m.group(2) in macros:
                params, body = macros[m.group(2)]
                args = split_args(m.group(3))
                for b in body:
                    t = b
                    for p, a in zip(params, args):
                        t = re.sub(r"\b%s\b" % re.escape(p), "(" + a + ")", t)
                    res.append((f, n, t, raw))
                changed = True
            else:
                res.append((f, n, line, raw))
        out = res
    return out


def parse(lines):
    """Statements: (kind, scope, data, src). Scopes are numbered; 0 is
    global. parent[s] is the enclosing scope."""
    stmts, parent, stack, next_id = [], {0: None}, [0], 1
    for f, n, line, raw in lines:
        s = line.strip()
        while s:
            if s.startswith("{"):
                parent[next_id] = stack[-1]
                stack.append(next_id)
                next_id += 1
                s = s[1:].strip()
                continue
            if s.startswith("}"):
                stack.pop()
                s = s[1:].strip()
                continue
            m = re.match(r"\.(\^?)([A-Za-z_]\w*)\s*(.*)$", s)
            if m:
                scope = stack[-1]
                if m.group(1):
                    scope = parent[scope]
                stmts.append(("label", stack[-1], (m.group(2), scope), (f, n)))
                s = m.group(3).strip()
                continue
            m = re.match(r"([A-Za-z_]\w*)\s*=\s*(.+)$", s)
            if m:
                stmts.append(("const", stack[-1], (m.group(1), m.group(2)), (f, n)))
                break
            stmts.append(("stmt", stack[-1], s, (f, n)))
            break
    return stmts, parent


def main():
    src, dst = sys.argv[1], sys.argv[2]
    lines = []
    read(src, lines)
    lines = expand_macros(lines)
    stmts, parent = parse(lines)

    # Definitions: (name, scope) -> unique name.
    defs = {}
    count = {}
    for kind, cur, data, _ in stmts:
        if kind in ("label", "const"):
            name = data[0]
            scope = data[1] if kind == "label" else cur
            count[name] = count.get(name, 0) + 1
            defs[(name, scope)] = None
    seen = {}
    for (name, scope) in defs:
        if count[name] == 1 or scope == 0:
            defs[(name, scope)] = name
        else:
            k = seen.get(name, 0) + 1
            seen[name] = k
            defs[(name, scope)] = "%s_%d" % (name, k)

    def resolve(name, scope, where):
        s = scope
        while s is not None:
            if (name, s) in defs:
                return defs[(name, s)]
            s = parent[s]
        raise SystemExit("%s:%d: undefined %s" % (where[0], where[1], name))

    def expr(e, scope, where):
        # Split off strings, convert the rest.
        parts = re.split(r'("[^"]*")', e)
        out = []
        for p in parts:
            if p.startswith('"'):
                out.append(p)
                continue
            p = re.sub(r"&([0-9A-Fa-f]+)", r"$\1", p)

            def rep(m):
                w = m.group(0)
                if w == "MOD":
                    return ".mod"
                if w == "DIV":
                    return "/"
                if w == "EOR":
                    return "^"
                if w == "AND":
                    return "&"
                if w == "OR":
                    return "|"
                if w in ("X", "Y", "A"):
                    return w
                return resolve(w, scope, where)
            # identifiers not preceded by $ or % digit context
            p = re.sub(r"(?<![$%0-9A-Za-z_])[A-Za-z_]\w*", rep, p)
            out.append(p)
        r = "".join(out)
        m = re.match(r"(#?)\s*(.+?)\s*\.mod 256$", r)
        if m:
            r = "%s<(%s)" % (m.group(1), m.group(2))
        m = re.match(r"(#?)\s*(.+?)\s*/ 256$", r)
        if m:
            r = "%s>(%s)" % (m.group(1), m.group(2))
        return r

    out = ["; Generated by tools/basm2ca65.py from the mungre/chuckie disassembly.",
           "; The comment on each line gives its beebasm source line.", ""]
    for kind, cur, data, where in stmts:
        tag = "  ; %s:%d" % where
        if kind == "label":
            out.append("%s:%s" % (defs[(data[0], data[1])], tag))
        elif kind == "const":
            out.append("%s = %s%s" % (defs[(data[0], cur)], expr(data[1], cur, where), tag))
        else:
            m = re.match(r"(\w+)\s*(.*)$", data)
            op, rest = m.group(1), m.group(2)
            U = op.upper()
            if U == "EQUB":
                out.append("    .byte %s%s" % (expr(rest, cur, where), tag))
            elif U == "EQUW":
                out.append("    .word %s%s" % (expr(rest, cur, where), tag))
            elif U == "EQUS":
                out.append("    .byte %s%s" % (expr(rest, cur, where), tag))
            elif U == "ORG":
                out.append("    .org %s" % expr(rest, cur, where))
            elif U in ("COPYBLOCK", "SAVE", "PRINT", "GUARD", "CLEAR"):
                out.append("    ; %s %s (dropped)" % (op, rest))
            elif U in MNEMONICS:
                r = rest.strip()
                if r.upper() == "A":
                    r = "a"
                else:
                    r = expr(r, cur, where)
                out.append("    %s %s%s" % (op.lower(), r, tag))
            else:
                raise SystemExit("%s:%d: unknown statement %r" % (where[0], where[1], data))
    with open(dst, "w") as f:
        f.write("\n".join(out) + "\n")


if __name__ == "__main__":
    main()
