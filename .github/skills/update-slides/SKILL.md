---
name: update-slides
description: 'Update, add, restyle, or fill in placeholder content in the EARL conference Beamer talk (beamer.tex). Use when the user asks to edit slides, write slide content, add a section/frame, replace placeholders, or rebuild the presentation PDF.'
argument-hint: 'Which slide/section to update and what content to add'
---

# Update EARL Beamer Slides

Repeatable workflow for editing the LaTeX Beamer deck in this repo
([beamer.tex](../../../beamer.tex)) and rebuilding the PDF.

## When to Use

- Filling in `\emph{placeholder}` content on a slide.
- Adding a new frame or a new `\section{...}` topic.
- Restyling or fixing formatting to match the deck's blue EARL theme.
- Rebuilding `beamer.pdf` and checking for LaTeX errors.

## Prerequisites

- All slide content lives in a single file: `beamer.tex`.
- Conventions (theme colours, footline/cover templates, bullet patterns, escaping) are documented in
  [beamer-slides.instructions.md](../../instructions/beamer-slides.instructions.md). Follow them.

## Procedure

1. **Locate the target frame.** Search `beamer.tex` for the `\frametitle{...}` or `\section{...}`
   the user named. Read the surrounding frame before editing.
2. **Draft the content.** Keep it presentation-friendly: 3–5 terse bullets, each led by a bold
   `\textbf{Label:}`. Use `\texttt{...}` for code/file/function names and escape special characters
   (`\_ \# \% \& \$`).
3. **Replace placeholders.** Swap each `\emph{placeholder}` for real content and delete the trailing
   `--- hint` once the point is written. Do not leave orphaned `---` fragments.
4. **For a new topic**, in this order:
   - Add a banner comment + `\section{...}` in the right place.
   - Add the `\begin{frame}` ... `\end{frame}` block with a `\frametitle`.
   - Add a matching item to the **Agenda** frame near the top of the file.
   Never add the logo or footline manually — content slides get them automatically.
5. **Preserve the preamble.** Don't touch theme/colour/template definitions unless the user asks
   for a restyle. Never hand-edit generated files (`.aux`, `.nav`, `.snm`, `.toc`, `.pdf`, etc.).
6. **Build and verify.** Run the build and confirm there are no errors:
   ```bash
   latexmk -pdf -interaction=nonstopmode beamer.tex
   ```
   If the build state looks stale, clean first with `latexmk -c` and rebuild.
7. **Visually verify (required).** A clean build is not enough — render the changed slide(s) with
   the [preview-slides](../preview-slides/SKILL.md) skill and view the PNG(s) to confirm content,
   layout, spacing, colours, and any diagrams/images look correct with no overflow.
8. **Report.** Summarise which frames changed and confirm the build and visual check passed.

## Notes

- The cover slide is a special `[plain]` frame with a full-blue background — treat it differently
  from content slides.
- Reuse the `earlblue` named colour; never hard-code RGB in a slide.
- The EARL logo is `assets/earlconf.png`.
