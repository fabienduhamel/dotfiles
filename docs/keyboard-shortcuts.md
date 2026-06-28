# Keyboard Shortcuts

A unified, cross-app keyboard layout. Every modifier carries **one consistent
meaning** so the same intention always maps to the same gesture, whatever the
app.

## The mental model

| Modifier       | Meaning                                                                   |
| -------------- | ------------------------------------------------------------------------- |
| `hyper`        | **App focus** — jump to an app, or move to a neighboring app              |
| `cmd`          | **Navigate content** — cursor in VSCode, page in Chrome, panes in WezTerm |
| `alt`          | **Navigate / move focus** — by word in text, between UI zones in VSCode   |
| `+ shift`      | Turns navigation into **selection** (native macOS convention)             |
| `ctrl + shift` | **Structural** action — multi-cursor, pane resize                         |
| `ctrl + alt`   | **Window placement** (Rectangle)                                          |

> `hyper` = Capslock or right `cmd`, remapped via Karabiner.

The "go to the neighbor" idea is fractal across two scales: `hyper` + arrows
moves between **apps**, `cmd` + arrows moves between **panes** inside an app.

## System (skhd + Rectangle)

| Gesture                      | Action                                                              |
| ---------------------------- | ------------------------------------------------------------------- |
| `hyper` + letter (c/o/t/v/s) | Jump to a specific app                                              |
| `hyper` + ←/→ (or `a`/`e`)   | Focus neighboring app (geographic) — `a`/`e` are an identical alias |
| `ctrl + alt` + arrows        | Place the window (Rectangle)                                        |

App launcher mnemonics: **c** Chrome, **o** Obsidian, **t** WezTerm,
**v** VSCode, **s** Slack.

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
