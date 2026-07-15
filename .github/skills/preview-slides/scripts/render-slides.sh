#!/usr/bin/env bash
# Render Beamer slides (beamer.pdf) to PNG images so an agent can view them.
#
# Usage:
#   scripts/render-slides.sh                # render all pages at 150 dpi
#   scripts/render-slides.sh 5              # render only page 5
#   scripts/render-slides.sh 3 7            # render pages 3..7 (inclusive)
#   DPI=200 scripts/render-slides.sh        # override resolution
#
# Output: .slidepreview/slide-001.png, slide-002.png, ...
# Requires: ghostscript (gs), latexmk (only if beamer.pdf is missing/stale).
set -euo pipefail

# Resolve repo root as the parent of the skill's scripts/ dir, or fall back to cwd.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." >/dev/null 2>&1 && pwd)"
[[ -f "$ROOT/beamer.tex" ]] || ROOT="$PWD"
cd "$ROOT"

DPI="${DPI:-150}"
OUTDIR=".slidepreview"
FIRST="${1:-}"
LAST="${2:-${FIRST:-}}"

if ! command -v gs >/dev/null 2>&1; then
  echo "error: ghostscript (gs) is not installed." >&2
  exit 1
fi

# Build the PDF if it is missing or older than the source.
if [[ ! -f beamer.pdf || beamer.tex -nt beamer.pdf ]]; then
  echo "Building beamer.pdf ..." >&2
  latexmk -pdf -interaction=nonstopmode beamer.tex >/dev/null
fi

mkdir -p "$OUTDIR"
rm -f "$OUTDIR"/slide-*.png

PAGEARGS=()
if [[ -n "$FIRST" ]]; then
  PAGEARGS+=("-dFirstPage=$FIRST" "-dLastPage=$LAST")
fi

gs -sDEVICE=png16m -r"$DPI" -dBATCH -dNOPAUSE -dGraphicsAlphaBits=4 -dTextAlphaBits=4 \
   "${PAGEARGS[@]}" \
   -sOutputFile="$OUTDIR/slide-%03d.png" beamer.pdf >/dev/null

echo "Rendered $(ls -1 "$OUTDIR"/slide-*.png | wc -l) page(s) to $OUTDIR/ at ${DPI} dpi:" >&2
ls -1 "$OUTDIR"/slide-*.png
