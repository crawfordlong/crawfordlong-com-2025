#!/usr/bin/env fish
# Generate brief text-only posts (notes) for testing infinite scroll.
# Usage: fish scripts/gennotes.fish [COUNT]   # default COUNT=24

# ----- COUNT (no math) -----
set COUNT 24
if test -n "$argv[1]"
    set COUNT "$argv[1]"
end
if not string match -qr '^[0-9]+$' -- "$COUNT"
    echo "COUNT must be an integer"
    exit 1
end

# ----- Date/time pieces -----
set Y (date +%Y)
set M (date +%m)
set D (date +%d)
set TZOFF (string replace -r '([+-]\d{2})(\d{2})' '$1:$2' -- (date +%z))

# Prebuild zero-padded minutes 00..59 (avoid math)
set MINUTES
for m in (seq 0 59)
    set MINUTES $MINUTES (printf "%02d" $m)
end

# Snippets to cycle through (no math needed for cycling)
set SNIPS \
    "Lorem ipsum—quick draft note." \
    "Small thought, nothing fancy." \
    "Another test line for the grid." \
    "Short note to pad the feed." \
    "Text-only post for scrolling." \
    "Minimal content; just words." \
    "Checking masonry with text." \
    "A brief sentence. That’s all." \
    "Filler text for pagination." \
    "Grid test: tiny blurb here." \
    "Scrolling demo; ignore content." \
    "Yet another very short note." \
    "Micro post to exercise layout." \
    "Testing: does this interleave?" \
    "Hello from a text-only tile." \
    "One more snippet for variety."

set sn_i 1
set sn_n (count $SNIPS)

# Generate bundles
for idx in (seq 1 $COUNT)
    # time: all at hour 00, minutes 00.. (wrap every 60)
    set HH 00
    set mi (printf "%02d" (math "($idx - 1) % 60")) # safe: no leading zeros in operand
    # If you want *zero* math, replace the line above with:
    # set mi $MINUTES[(math "(( $idx - 1 ) % 60) + 1")]

    set SLUG "00$mi-note-$idx"
    set DIR content/notes/$Y/$M/$D/$SLUG
    mkdir -p "$DIR"

    set SNIP $SNIPS[$sn_i]
    set sn_i (math "$sn_i + 1")
    if test $sn_i -gt $sn_n
        set sn_i 1
    end

    printf '%s\n' \
        --- \
        "date: $Y-$M-$D"T"$HH:$mi:00$TZOFF" \
        'title: ""' \
        --- \
        '' \
        "$SNIP" >"$DIR/index.md"
end

echo "Generated $COUNT text posts under content/notes/$Y/$M/$D/"
