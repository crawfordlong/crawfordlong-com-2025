#!/usr/bin/env fish
# Generate 24 photo posts from images in a folder (jpg/jpeg/png/gif/heic/webp).
# Usage:
#   fish scripts/fishgen.fish /path/to/images
#   or: set -x SRC /path/to/images; fish scripts/fishgen.fish

# --- input path ---
if test -n "$argv[1]"
    set SRC "$argv[1]"
end
set -q SRC; or begin
    echo "Usage: fish scripts/fishgen.fish /path/to/images"
    exit 1
end
if not test -d "$SRC"
    echo "Not a directory: $SRC"
    exit 1
end

# --- config ---
set TARGET 24
set Y (date +%Y)
set M (date +%m)
set D (date +%d)
set TZOFF_RAW (date +%z)
set TZOFF (string replace -r '([+-]\d{2})(\d{2})' '$1:$2' -- $TZOFF_RAW)

# --- collect images recursively (follow symlinks) ---
# GNU find on your box supports -regextype and -iregex.
set imgs (find -L "$SRC" -type f -regextype posix-extended \
  -iregex '.*\.(jpe?g|png|gif|heic|webp)$' -print)

set count (count $imgs)
echo "Found $count image(s) under $SRC"
if test $count -eq 0
    exit 1
end

# --- pick exactly TARGET files (cycle if fewer) ---
set pick
for idx in (seq 1 $TARGET)
    set pos (math "(( $idx - 1 ) % $count ) + 1")
    set pick $pick $imgs[$pos]
end

# --- generate bundles: content/photos/YYYY/MM/DD/HHMM-name/ ---
for idx in (seq 1 $TARGET)
    set f $pick[$idx]
    set name (basename "$f")
    set base (string replace -r '\.[^.]*$' '' -- "$name")
    set base (string replace -ra '[^A-Za-z0-9]+' '-' -- "$base")
    set base (string trim -c '-' -- "$base")
    if test -z "$base"
        set base "img-$idx"
    end

    # timestamps 00:00..00:23
    set mins (math "$idx - 1")
    set HH (printf "%02d" (math "floor($mins / 60)"))
    set MM (printf "%02d" (math "$mins % 60"))

    set SLUG "$HH$MM-$base"
    set DIR content/photos/$Y/$M/$D/$SLUG
    mkdir -p "$DIR"

    printf '%s\n' \
        --- \
        "date: $Y-$M-$D"T"$HH:$MM:00$TZOFF" \
        'title: ""' \
        'caption: ""' \
        --- >"$DIR/index.md"

    set ext (string lower (string match -r '\.[^.]+$' -- "$name"))
    if test -z "$ext"
        set ext ".jpg"
    end
    cp "$f" "$DIR/1$ext"
end

echo "Generated $TARGET bundles under content/photos/$Y/$M/$D/"
