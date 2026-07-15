---
name: preview-slides
description: 'Render the EARL Beamer talk (beamer.pdf) to images so the agent can visually inspect the rendered slides — especially diagrams, TikZ figures, images, layout, spacing, and colours. Use when the user asks to look at / review / check how a slide looks, verify a diagram or image renders correctly, or debug visual layout/overflow issues.'
argument-hint: 'Which slide/page (or range) to preview, and what to check'
---

# Preview Rendered Slides

Beamer slides are LaTeX source that only reveal their true visual appearance once
compiled to PDF. This skill compiles `beamer.tex`, converts the relevant PDF pages to
PNG images, and lets the agent **view** them to inspect diagrams, images, layout, and colours.

## When to Use

- The user asks to "look at", "review", "check how it looks", or "see" a slide.
- Verifying a TikZ diagram, figure, or `\includegraphics` image renders correctly.
- Debugging visual issues: text overflow, spacing, alignment, colour, off-slide content.
- Sanity-checking a slide after editing content or restyling.

## Prerequisites

- `ghostscript` (`gs`) for PDF→PNG (installed in the dev container).
- `latexmk` to build the PDF (installed). The script auto-builds if `beamer.pdf`
  is missing or older than `beamer.tex`.

## Procedure

1. **Render the pages** with the helper script (paths are relative to the repo root):
   ```bash
   .github/skills/preview-slides/scripts/render-slides.sh          # all pages
   .github/skills/preview-slides/scripts/render-slides.sh 5        # only page 5
   .github/skills/preview-slides/scripts/render-slides.sh 3 7      # pages 3..7
   DPI=200 .github/skills/preview-slides/scripts/render-slides.sh  # higher resolution
   ```
   Output PNGs land in `.slidepreview/slide-001.png`, `slide-002.png`, ...
2. **View the images.** Open each rendered `.slidepreview/slide-NNN.png` with the image
   viewer tool (not the text file reader) to inspect it visually.
3. **Map pages to slides.** PDF page numbers are sequential; page 1 is the cover slide.
   `\pause`/overlays produce multiple pages per frame, so a frame can span several PNGs.
   If unsure which page a frame is on, render all pages and scan them.
   Note: output files are numbered sequentially from `001` (`slide-001.png` = the *first
   rendered* page), **not** by PDF page number. When rendering a range like `3 7`, page 3
   becomes `slide-001.png`. Render all pages if you need the numbering to match PDF pages.
4. **Report findings** referencing what you saw (e.g. "the diagram on page 6 overflows the
   right footline"), and, if asked, edit `beamer.tex` to fix it, then re-render to confirm.

## Notes

- `.slidepreview/` is a scratch output folder; it is git-ignored and can be deleted anytime.
- Default resolution is 150 dpi. Bump `DPI` (e.g. 200–300) to read small diagram labels.
- For higher-fidelity diagram checks, increase DPI rather than trusting a low-res thumbnail.
- Editing conventions for the deck live in
  [beamer-slides.instructions.md](../../instructions/beamer-slides.instructions.md).
