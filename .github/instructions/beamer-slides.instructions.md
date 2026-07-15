---
name: "Beamer Slide Conventions"
description: "Use when editing, adding, or restyling slides in this EARL conference Beamer talk (beamer.tex). Covers the blue theme, frame structure, footline/cover templates, placeholder conventions, and how to build the PDF."
applyTo: "**/*.tex"
---

# Beamer Slide Conventions (EARL Talk)

This repository is a single-file LaTeX Beamer presentation for the **EARL conference**.
The deck is authored in [beamer.tex](../../beamer.tex) and built to `beamer.pdf`.

Talk topic: *Co-Migrate — An Agentic AI System for Enterprise Cloud Migration* (LSEG).

## Theme & Colours

- Primary brand colour is `earlblue` = `\definecolor{earlblue}{RGB}{0,63,114}`. Reuse this
  named colour; do **not** hard-code raw RGB values in individual slides.
- Frame titles render white-on-`earlblue`; body text is black; structural accents are `earlblue`.
- Navigation symbols are disabled globally (`\setbeamertemplate{navigation symbols}{}`). Keep them off.
- The EARL logo lives at `assets/earlconf.png`. Reference it by that relative path only.

## Slide Structure

- The **cover slide** is a special `[plain]` frame with a full `earlblue` background and the logo
  centred at the bottom. It uses local overrides for `footline` and `usebackgroundtemplate` inside a
  `{ ... }` group. Do not add a footline or frame title to the cover.
- **Content slides** use `\frametitle{...}` and automatically get the blue footline bar with the
  logo bottom-right (defined by the global `\setbeamertemplate{footline}{...}`). Do not re-add the
  logo manually on content slides.
- Group slides under the existing `\section{...}` markers. Each major agenda item has its own section.
- Keep the big banner comment style already in the file to separate sections:
  ```tex
  % =====================================================================
  % N. Section Name
  % =====================================================================
  ```

## Content Conventions

- Placeholder content is marked with `\emph{placeholder}` and often a trailing `--- description`.
  When filling a slide, **replace the `\emph{placeholder}`** with real content and remove the
  `--- ...` hint once the point is written.
- Bullets use `\begin{itemize}` with a leading `\textbf{Label:}` for each point. Match this pattern
  when adding bullets so slides stay visually consistent.
- Use `\texttt{...}` for code identifiers, file names, function names (e.g. `\texttt{retry.py}`).
- Keep bullets terse and presentation-friendly (a phrase, not a paragraph). Prefer 3–5 bullets per slide.
- Escape LaTeX special characters in prose: `_ # % & { } $`. In particular use `\_` inside `\texttt{}`
  for snake_case names (e.g. `\texttt{get\_X\_agent()}`).

## Editing Rules

- Edit only [beamer.tex](../../beamer.tex) for slide content. Do **not** hand-edit generated files
  (`beamer.aux`, `.nav`, `.snm`, `.toc`, `.fls`, `.fdb_latexmk`, `.log`, `.out`, `.synctex.gz`, `.pdf`).
- Preserve the preamble (theme, colours, templates) unless the user explicitly asks for a restyle.
- When adding a whole new topic, add a `\section{...}`, add its item to the **Agenda** frame, and
  follow the banner-comment + `\frametitle` pattern.

## Building

- Build with `latexmk -pdf beamer.tex` (latexmk and pdflatex are installed in the dev container).
- The LaTeX Workshop extension auto-builds on save (`latex-workshop.latex.autoBuild.run: onFileChange`),
  so a manual build is usually only needed to verify from the terminal.
- After non-trivial edits, run a build and check for errors before reporting done:
  `latexmk -pdf -interaction=nonstopmode beamer.tex`.
- Clean auxiliary files with `latexmk -c` if the build state looks stale.

## Visual Verification (required)

- Any change to slide content or styling **must** be visually verified by rendering the affected
  slide(s) with the `preview-slides` skill
  ([SKILL.md](../skills/preview-slides/SKILL.md)) and viewing the resulting image(s) — a
  successful `latexmk` build alone is **not** sufficient.
- Render the specific page(s) you changed, view the PNG(s) in `.slidepreview/`, and confirm the
  content, layout, spacing, colours, and any diagrams/images look correct with no overflow.
- This is especially important for TikZ diagrams, `\includegraphics` images, and dense slides where
  content can silently overflow the frame or footline.
- Only report the change as done after this visual check passes. If it doesn't look right, fix
  `beamer.tex` and re-render to confirm.
