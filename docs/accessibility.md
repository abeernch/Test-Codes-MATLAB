# Accessibility

This repository is primarily a code archive, so accessibility here means making
the docs, file structure, and script naming easier to scan and use.

## Current support

- The root README explains the major script families in plain language.
- The docs avoid deployment-specific names and coordinates.
- Folder names and example script names are listed so the repo is easier to
  navigate without opening every file.

## Useful improvements for contributors

- Add short comments to non-obvious scripts.
- Prefer descriptive script names for new files.
- Keep figures readable with labeled axes and consistent units.
- Avoid burying setup details in long comment blocks when a short doc note would
  help more.
- Where possible, include a short usage example at the top of reusable helpers.

## If you change the UI-like scripts

- Keep keyboard and mouse interactions predictable.
- Make sure text remains legible at the figure size the script expects.
- Include legend labels, axis labels, and units.

The repo is not a web app, so there is no browser accessibility baseline here.
The practical goal is documentation clarity and readable MATLAB output.
