#! /bin/sh

pandoc() {
    nix run nixpkgs#pandoc -- "$@"
}

HERE="$(dirname $(realpath $0))"

for F; do
    INPUT="$(realpath "$F")"
    OUTPUT="$(basename "$INPUT")"
    OUTPUT="/tmp/"${OUTPUT%.*}.html

    echo "$OUTPUT"
    pandoc "$INPUT" -c "$HERE/pr2html.css" -s -o "$OUTPUT"
done
