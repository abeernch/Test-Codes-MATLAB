# Short Tutorial

This is a quick path through the repository for someone opening it for the first
time.

## 1. Start with the root README

Read the root `README.md` first. It tells you which folders map to which script
families.

## 2. Pick one experiment family

Choose the area you want to inspect:

- `Test Scripts/` for PDW, PRI, waveform, radar, and networking experiments.
- `Test Scripts TDOA/` for TDoA, multilateration, and geometry scripts.
- `Functions/` for shared helpers.

## 3. Read the top of the script before running it

Many files are experiments. The first lines usually tell you:

- What the script is testing.
- Which parameters you can edit.
- Whether it expects interactive input.
- Whether it depends on a toolbox.

## 4. Run a small script first

Prefer a short validation script before a larger scenario script. That makes it
easier to confirm the environment is set up correctly.

## 5. Trace dependencies

If a script calls a helper in `Functions/`, open that helper next. Most of the
repo is easier to understand once you follow one script chain end to end.

## 6. Keep the docs generic

When writing new documentation, keep it technical and omit deployment-specific
site names, coordinates, and other location identifiers from public-facing text.
