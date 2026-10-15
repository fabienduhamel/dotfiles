local hyper = { "ctrl", "alt", "shift", "cmd" }

local function launch(app)
  hs.application.launchOrFocus(app)
end

local apps = {
  c = "Google Chrome",
  o = "Obsidian",
  t = "WezTerm",
  v = "Visual Studio Code",
}

for key, app in pairs(apps) do
  hs.hotkey.bind(hyper, key, function() launch(app) end)
end

-- Physical keycodes keep these bindings independent of the keyboard layout.
local numberRowApps = {
  [18] = "Google Chrome",
  [19] = "WezTerm",
  [20] = "Visual Studio Code",
  [21] = "Obsidian",
  [23] = "Slack",
}

local requiredFlags = { "ctrl", "alt", "shift", "cmd" }
hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local app = numberRowApps[event:getKeyCode()]
  if not app then return false end

  local flags = event:getFlags()
  for _, flag in ipairs(requiredFlags) do
    if not flags[flag] then return false end
  end
  for flag, enabled in pairs(flags) do
    if enabled and not hs.fnutils.contains(requiredFlags, flag) then return false end
  end

  launch(app)
  return true
end):start()

local function visibleWindows()
  local windows = {}
  for _, window in ipairs(hs.window.visibleWindows()) do
    local frame = window:frame()
    if window:isStandard() and frame.w >= 50 and frame.h >= 50 then
      windows[#windows + 1] = {
        window = window,
        x = frame.x,
        -- AppKit uses a bottom-left origin; negate y so up means a smaller value.
        y = -frame.y,
      }
    end
  end
  return windows
end

local function focusDirection(direction)
  local windows = visibleWindows()
  if #windows == 0 then return end

  local vertical = direction == "up" or direction == "down"
  local decreasing = direction ~= "right" and direction ~= "down"
  local coordinate = function(window)
    return vertical and window.y or window.x
  end

  local function extreme(candidates, pickMinimum)
    local best
    for _, candidate in ipairs(candidates) do
      if not best
        or (pickMinimum and coordinate(candidate) < coordinate(best))
        or (not pickMinimum and coordinate(candidate) > coordinate(best)) then
        best = candidate
      end
    end
    return best
  end

  local focusedWindow = hs.window.frontmostWindow()
  local focused
  if focusedWindow then
    for _, candidate in ipairs(windows) do
      if candidate.window:id() == focusedWindow:id() then
        focused = candidate
        break
      end
    end
  end

  if not focused then
    local target = extreme(windows, decreasing)
    if target then target.window:focus() end
    return
  end

  local focusedScreen = focused.window:screen()
  local sameScreen = {}
  if focusedScreen then
    for _, candidate in ipairs(windows) do
      if candidate ~= focused
        and candidate.window:screen() == focusedScreen
        and (decreasing and coordinate(candidate) < coordinate(focused)
          or not decreasing and coordinate(candidate) > coordinate(focused)) then
        sameScreen[#sameScreen + 1] = candidate
      end
    end
  end

  local target = extreme(sameScreen, not decreasing)
  if not target then
    local ahead = {}
    local otherWindows = {}
    for _, candidate in ipairs(windows) do
      if candidate ~= focused then
        otherWindows[#otherWindows + 1] = candidate
        if decreasing and coordinate(candidate) < coordinate(focused)
          or not decreasing and coordinate(candidate) > coordinate(focused) then
          ahead[#ahead + 1] = candidate
        end
      end
    end
    target = extreme(#ahead > 0 and ahead or otherWindows, not decreasing)
  end

  if target then target.window:focus() end
end

for _, direction in ipairs({ "left", "right", "up", "down" }) do
  hs.hotkey.bind(hyper, direction, function() focusDirection(direction) end)
end

hs.hotkey.bind(hyper, "q", function() focusDirection("left") end)
hs.hotkey.bind(hyper, "d", function() focusDirection("right") end)
hs.hotkey.bind(hyper, "z", function() focusDirection("up") end)
hs.hotkey.bind(hyper, "s", function() focusDirection("down") end)

hs.hotkey.bind({ "cmd" }, "F12", function()
  hs.task.new("/bin/bash", nil, {
    "-lc",
    'exec "$HOME/Dev/boilerplate/bash/mac-dns-switcher.sh" 127.0.0.1',
  }):start()
end)

hs.hotkey.bind(hyper, "l", function()
  local script = [[
    tell application "Google Chrome"
      repeat with w in windows
        repeat with i from 1 to (count of tabs of w)
          if (URL of tab i of w) starts with "https://calendar.google.com/" then
            set active tab index of w to i
            set index of w to 1
            activate
            return "OK"
          end if
        end repeat
      end repeat
      open location "https://calendar.google.com/"
      activate
      return "OK"
    end tell
  ]]
  local result, err = hs.osascript.applescript(script)
  if not result then hs.printf("Calendar shortcut failed: %s", err) end
end)

hs.hotkey.bind(hyper, "m", function()
  local script = [[
    tell application "Google Chrome"
      repeat with w in windows
        repeat with i from 1 to (count of tabs of w)
          if (URL of tab i of w) starts with "https://mail.google.com/" then
            set active tab index of w to i
            set index of w to 1
            activate
            return "OK"
          end if
        end repeat
      end repeat
      open location "https://mail.google.com"
      activate
      return "OK"
    end tell
  ]]
  local result, err = hs.osascript.applescript(script)
  if not result then hs.printf("Gmail shortcut failed: %s", err) end
end)
