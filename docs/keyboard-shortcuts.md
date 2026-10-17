# Keyboard Shortcuts

A unified, cross-app keyboard layout. Every modifier carries **one consistent
meaning** so the same intention always maps to the same gesture, whatever the
app.

## The mental model

| Modifier       | Meaning                                                                   |
| -------------- | ------------------------------------------------------------------------- |
| `hyper`        | **App/window focus** — launch an app or move to a neighboring window       |
| `cmd`          | **Navigate content** — cursor in VSCode, page in Chrome, panes in WezTerm |
| `alt`          | **Navigate / move focus** — by word in text, between UI zones in VSCode   |
| `+ shift`      | Turns navigation into **selection** (native macOS convention)             |
| `ctrl + shift` | **Structural** action — multi-cursor, pane resize                         |
| `ctrl + alt`   | **Window placement** (Rectangle)                                          |

> `hyper` = right `cmd`, remapped via [Vorssaint](https://github.com/vorssaint/vorssaint-utils).

`hyper` + arrows moves between **windows**, `cmd` + arrows moves between
**panes** inside an app.

## System (Hammerspoon + Rectangle)

| Gesture                      | Action                                                              |
| ---------------------------- | ------------------------------------------------------------------- |
| `hyper` + letter (c/o/t/v)   | Jump to a specific app                                              |
| `hyper` + arrows (or `q`/`d`/`z`/`s`) | Focus the neighboring window in that direction             |
| `ctrl + alt` + arrows        | Place the window (Rectangle)                                        |

App launcher mnemonics: **c** Chrome, **o** Obsidian, **t** WezTerm,
**v** VSCode. `hyper` + physical number-row keys **1–5** launch Chrome,
WezTerm, VSCode, Obsidian, and Slack respectively.

## VSCode

| Gesture                | Action                                                           |
| ---------------------- | ---------------------------------------------------------------- |
| `cmd` + arrows         | Text navigation (line/file start & end)                          |
| `alt` + arrows         | Text navigation (word by word)                                   |
| `cmd + shift` + arrows | Selection                                                        |
| `alt + shift` + arrows | Selection (by word)                                              |
| `alt` + A/Z/E/S        | Move focus between UI zones (editor, explorer, terminal, panel…) |
| `ctrl + shift` + ↑/↓   | Multi-cursor                                                     |
| `ctrl + shift` + ←/→   | (free)                                                           |

## WezTerm

| Gesture                 | Action                 |
| ----------------------- | ---------------------- |
| `cmd` + arrows          | Navigate between panes |
| `ctrl + shift` + arrows | Resize panes           |
| `alt` + arrows          | (free)                 |
