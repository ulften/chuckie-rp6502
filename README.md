# Chuckie Egg för Picocomputer 6502

En port av Chuckie Egg (A&F Software, 1983) från BBC Micro till
[Picocomputer 6502](https://picocomputer.github.io/) (RP6502), byggd med
[rp6502-sdk](https://github.com/picocomputer/rp6502-sdk) och cc65.

Spelkoden är originalets 6502-maskinkod, från disassemblyn i
[mungre/chuckie](https://github.com/mungre/chuckie). Den är översatt till
ca65-syntax och i övrigt nästan orörd. Det som på BBC:n var hårdvara eller
operativsystemet MOS (skärmminnet, OSWRCH/VDU, OSBYTE, OSWORD, SOUND och
ENVELOPE) är skrivet på nytt för RP6502 i `src/platform.s`.

## Bygga och köra

Samma verktyg som andra rp6502-sdk-projekt: CMake 3.28+, Python 3, Make
eller Ninja och cc65 (`picocomputer/cc65`).

```bash
cmake --preset cc65/Release
cmake --build build/cc65/release
```

ROM-filen hamnar i `build/cc65/release/chuckie/chuckie.rp6502`. Kör den i
emulatorn med

```bash
build/cc65/release/chuckie/rp6502-emu build/cc65/release/chuckie/chuckie.rp6502
```

eller med F5 (RP6502-EMU) i VS Code. Bygget gör också en webbspelare,
`build/cc65/release/web/`, som du kan starta med RP6502-WEB i VS Code.

## Tangenter

| Tangent | Funktion |
| --- | --- |
| S | starta, sedan 1–4 för antal spelare |
| K | välj egna tangenter (piltangenter och Shift går bra) |
| A / Z | upp / ner |
| , / . | vänster / höger |
| Mellanslag | hoppa |
| H | paus, valfri spelknapp fortsätter |
| Esc + H | avsluta spelet |

Tangenterna är BBC-tangenterna på samma plats på ett PC-tangentbord,
tabellen finns i `tools/gen_tables.py`.

## Så fungerar porten

**Skärmen.** MODE 2 på BBC:n är 160×256 pixlar i 16 logiska färger. Här är
den en mode 3-bitmap i XRAM med 4 bitar per pixel, 320 pixlar bred, där
varje BBC-pixel är en byte med två lika nibblar, alltså två pixlar på
duken. Rad *r* och kolumn *x* ligger på XRAM-adress `r * 160 + x`. Spelets
`draw_sprite` och `calculate_screen_location` ritade direkt i skärmminnet
på &3000. De är omskrivna och ritar med EOR genom de två XRAM-portalerna:
portal 0 läser och portal 1 skriver.

**16 rader för många.** BBC-skärmen har 256 rader men duken bara 240.
Duken är därför delad i två delar med var sin konfiguration av samma
bitmap. På spelskärmen syns rad 7–250, och fyra tomma rader i
statusraden överst hoppas över. Titelskärmarna visar rad 13–252. Spelet
byter mellan de två lägena när det ritar spelplanen respektive
CHUCKIE EGG-loggan (`plat_layout_game` och `plat_layout_menu`).

**VDU.** OSWRCH är en liten VDU-drivrutin med det spelet använder: MODE,
text vid grafikmarkören (VDU 5) med ett 8×8-typsnitt, GCOL, palett (VDU 19),
grafikfönster, CLG, MOVE och radredigering.

**Tangentbordet.** INKEY och tangentskanningarna i OSBYTE läser RIA:ns
tangentbitar i XRAM genom en tabell från BBC:ns interna tangentnummer till
USB HID-koder. Namninmatning till topplistan (OSWORD 0) läser tecknen från
konsolen.

**Ljud.** SOUND och ENVELOPE körs på RIA:ns PSG, med fyra köer som i MOS.
Avbrottet från VSYNC kör ljudet 100 gånger per sekund i snitt och sköter
amplitudkurvorna. Kanal 0 är brus, 1–3 fyrkantsvåg. Tonhöjden följer BBC:ns
skala, där 53 är mitt-C och varje steg en kvarts halvton.

**Tid.** Spelet väntar 3 centisekunder per varv med intervalltimern
(OSWORD 3/4), som här kommer från RIA:ns klocka. De två fördröjningsloopar
som var räknade i cykler vid 2 MHz är ersatta med tidsstyrda väntor.
6502:an kör i standardtakten (8 MHz), så spelet går aldrig långsammare än
originalets 3 centisekunder per varv.

## Minneskarta

| 6502-RAM | |
| --- | --- |
| $0000–$008F | spelets nollsida, samma adresser som på BBC:n |
| $0090–$00BF | plattformens nollsida (avbrottet använder $B0–$BF) |
| $0200–$03FF | plattformens variabler |
| $0400–$07FF | spelets data, samma adresser som på BBC:n |
| $0800– | koden: hopp för reset/IRQ/NMI, spelet, plattformen |

| XRAM | |
| --- | --- |
| $0000–$9FFF | skärmen, 160 × 256 byte |
| $A000, $A010 | mode 3-konfigurationerna |
| $A020 | paletten, 16 färger |
| $A040 | tangentbordet |
| $A100 | PSG |

## Filer

| Fil | |
| --- | --- |
| `src/chuckie.s` | spelet, genererat från disassemblyn; ändringarna är märkta `RP6502` |
| `src/platform.s` | plattformslagret: start, grafik, VDU, tangentbord, ljud, tid |
| `src/xram.inc` | XRAM-kartan och SDK-definitioner |
| `src/tables.inc` | typsnitt, tonhöjder och tangenttabeller, genererat |
| `src/chuckie.cfg` | länkarens minneskarta |
| `tools/basm2ca65.py` | översätter beebasm-källan till ca65 |
| `tools/port.py` | gör ändringarna i spelkoden |
| `tools/gen_tables.py` | skriver `src/tables.inc` |
| `tools/regenerate.py` | kör allt ovan och kontrollerar att översättningen ger exakt originalets CH_EGG |

`tools/regenerate.py` behövs bara om du vill göra om översättningen:

```bash
git clone https://github.com/mungre/chuckie ../chuckie
python3 tools/regenerate.py ../chuckie
```

Den skriver över `src/chuckie.s`. Om du hellre ändrar i spelkoden direkt
kan du göra det och strunta i skriptet.

## Skillnader mot originalet

- 16 av 256 rader syns inte, se ovan. Spelet ritar inget där.
- Typsnittet är font8x8 (public domain) och inte BBC:ns.
- Ljudet är en efterbildning av SN76489 och MOS ljudsystem. Spelet använder
  bara amplitudkurvor, så tonhöjdskurvorna i ENVELOPE är inte gjorda.
- Blinkande färger (8–15) visas som sin första färg. Spelet använder dem
  inte.

## Upphovsrätt

Chuckie Egg är skrivet av Nigel Alderton och utgivet av A&F Software.
Spelkoden här kommer från mungre/chuckie. Typsnittet är font8x8 av Daniel
Hepper, public domain. Plattformslagret och verktygen är nya.
