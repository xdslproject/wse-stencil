#!/bin/sh
set -e
echo " $* " | grep -Eq "( -h )|( --help )" && { echo "Usage: $(basename "$0") CSL_FILE

    Estimates memory usage of a CSL program (usually underestimates).
"; exit 0; }

file=$1

[ -z "$file" ] && { echo "missing CSL_FILE"; exit 1; }
! [ -f "$file" ] && { echo "$file does not exist"; exit 1; }

chunk_size=$(sed -nE 's/param chunk_size.*= ([0-9]+);/\1/p' "$file")
pattern=$(sed -nE 's/.*param pattern.*= ([0-9]+);.*/\1/p' "$file")
lib_size=$((((3 * 1024) + 244) * 8)) # ~3.2KB

sed -nE 's/.*(var|const) [a-zA-Z_][a-zA-Z0-9_]* ?: \[([0-9]+(, ?[0-9]+)*)\].([0-9]+).*/\2,\4/p' "$file" | awk \
    -vchunk_size="$chunk_size" \
    -vpattern="$pattern" \
    -vlib_size="$lib_size" \
    -F, '
BEGIN {
    oned_exch = 4 * pattern * 32 + 2 * 32
    stencil_comms = 4 * pattern * chunk_size * 32
    res=oned_exch + stencil_comms + lib_size
}
{
    local_res = 1
    for(i=1; i<=NF; i++) {
        local_res *= $i
    }
    res += local_res
}
END {
    bytes=res/8
    kbytes=bytes/1024
    if (bytes > 48000) print "\x1b[1;33mWARN: memory usage could be too high"
    print bytes "B (" kbytes "KB)"
    if (bytes > 48000) printf "\x1b[0m"
}
'
