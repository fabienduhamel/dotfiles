#!/bin/bash
# Focus the nearest window to the left/right of the focused one. When there is
# nothing in that direction on the current screen, hop to the other monitor.
# Usage: focus_window.sh left | focus_window.sh right
osascript -l JavaScript - "$1" <<'EOF'
ObjC.import('CoreGraphics');
ObjC.import('AppKit');

// Normal, on-screen windows as {pid, x, y} in top-left, y-down global coords.
function onScreenWindows() {
  const ref = $.CGWindowListCopyWindowInfo(1 | 16, 0); // on-screen | exclude desktop
  // The result is an opaque CFArrayRef; cast it before unwrapping to JS.
  const list = ObjC.deepUnwrap(ObjC.castRefToObject(ref));
  const wins = [];
  for (const w of list) {
    if (w.kCGWindowLayer !== 0) continue; // skip menus, shadows, the Dock, etc.
    const b = w.kCGWindowBounds;
    if (!b || b.Width < 50 || b.Height < 50) continue;
    wins.push({ pid: w.kCGWindowOwnerPID, x: b.X, y: b.Y });
  }
  return wins;
}

// Screen rectangles in the same top-left coords as the windows. NSScreen uses
// bottom-left origin, so flip y using the primary screen's height.
function screenRects() {
  const screens = $.NSScreen.screens;
  const n = screens.count;
  const frames = [];
  let hPrimary = 0;
  for (let i = 0; i < n; i++) {
    const f = screens.objectAtIndex(i).frame;
    frames.push(f);
    if (f.origin.x === 0 && f.origin.y === 0) hPrimary = f.size.height;
  }
  return frames.map(f => ({
    l: f.origin.x,
    r: f.origin.x + f.size.width,
    t: hPrimary - (f.origin.y + f.size.height),
    b: hPrimary - f.origin.y,
  }));
}

const inRect = (s, w) => w.x >= s.l && w.x < s.r && w.y >= s.t && w.y < s.b;

// Bring the target's app to the front. Only when that app has several on-screen
// windows do we pay for System Events to raise the specific one we picked.
function focus(target, wins) {
  $.NSRunningApplication
    .runningApplicationWithProcessIdentifier(target.pid)
    .activateWithOptions(2); // NSApplicationActivateIgnoringOtherApps

  if (wins.filter(w => w.pid === target.pid).length <= 1) return;
  try {
    const proc = Application('System Events').processes.whose({ unixId: target.pid })[0];
    const pw = proc.windows;
    for (let i = 0; i < pw.length; i++) {
      const p = pw[i].position();
      if (Math.abs(p[0] - target.x) < 5 && Math.abs(p[1] - target.y) < 5) {
        pw[i].actions['AXRaise'].perform();
        return;
      }
    }
  } catch (e) {}
}

function run(argv) {
  const goingLeft = argv[0] !== 'right'; // anything but 'right' means left

  const wins = onScreenWindows();

  // The focused window is the front-most one owned by the active app.
  const frontPID = $.NSWorkspace.sharedWorkspace.frontmostApplication.processIdentifier;
  const focused = wins.find(w => w.pid === frontPID);
  if (!focused) return;

  const screen = screenRects().find(s => inRect(s, focused))
    || { l: -1e9, r: 1e9, t: -1e9, b: 1e9 };

  // Nearest in the travel direction: 'left' wants the largest x still left of
  // us, 'right' the smallest x still right of us — the same comparison also
  // yields the rightmost / leftmost window when we hop to the other screen.
  const nearest = (cands) => cands.reduce((best, w) =>
    best === null ? w : (goingLeft ? (w.x > best.x ? w : best) : (w.x < best.x ? w : best)),
    null);

  // 1) a neighbor on the same screen, in the requested direction
  let target = nearest(wins.filter(w =>
    w !== focused && inRect(screen, w) &&
    (goingLeft ? w.x < focused.x : w.x > focused.x)));

  // 2) otherwise hop to the other screen, entering from the opposite edge
  if (!target) target = nearest(wins.filter(w => w !== focused && !inRect(screen, w)));

  if (target) focus(target, wins);
}
EOF
