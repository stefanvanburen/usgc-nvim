-- Contrast check for the diff and match highlight groups, run headless:
--
--     nvim -l tests/contrast.lua
--
-- Exits non-zero if any pairing falls below its threshold. The pairings are
-- the ones a diff actually puts on screen, including the ones the theme does
-- not spell out itself: plugins such as diffs.nvim and mini.diff derive their
-- own backgrounds from DiffAdd's and DiffDelete's -- mixed toward Normal's --
-- and then leave a foreground of their own choosing on top, so each diff
-- background is checked against every foreground that can land on it.

local root = vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2)))
vim.opt.runtimepath:prepend(root)
vim.o.termguicolors = true

local BLEND = 0.6 -- diffs.nvim's share of the theme's background, its default

-- { foreground group, background group, minimum contrast }
local checks = {
  { 'Added', 'Normal', 4.5 },
  { 'Changed', 'Normal', 4.5 },
  { 'Removed', 'Normal', 4.5 },
  { 'Normal', 'DiffAdd', 4 },
  { 'Normal', 'DiffChange', 4 },
  { 'Normal', 'DiffDelete', 4 },
  { 'Normal', 'DiffText', 3 },
  { 'Added', 'DiffAdd', 3 },
  { 'Changed', 'DiffChange', 3 },
  { 'Changed', 'DiffText', 3 },
  { 'Removed', 'DiffDelete', 3 },
}

-- Groups a plugin paints on top of another group's background, here
-- mini.pick's match ranges over the current match. A foreground alone is at
-- the mercy of whatever is underneath -- these were drawn in the accent color
-- over an accent-colored row -- so each has to carry a background of its own.
local layered = { 'MiniPickMatchRanges' }

local function channel(color, shift)
  return math.floor(color / shift) % 0x100
end

local function luminance(color)
  local function part(c)
    c = c / 255
    return c <= 0.03928 and c / 12.92 or ((c + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * part(channel(color, 0x10000))
    + 0.7152 * part(channel(color, 0x100))
    + 0.0722 * part(channel(color, 1))
end

local function contrast(a, b)
  local hi, lo = luminance(a), luminance(b)
  if hi < lo then
    hi, lo = lo, hi
  end
  return (hi + 0.05) / (lo + 0.05)
end

local function mix(color, onto, alpha)
  local out = 0
  for _, shift in ipairs({ 0x10000, 0x100, 1 }) do
    local value = channel(color, shift) * alpha + channel(onto, shift) * (1 - alpha)
    out = out + math.floor(value + 0.5) * shift
  end
  return out
end

local function hl(group)
  return vim.api.nvim_get_hl(0, { name = group, link = false })
end

local failures = {}
local pairings = 0

-- Only the variants: the `usgc` colorscheme is a light/dark switch between
-- them, and has no colors of its own to check.
for _, path in ipairs(vim.fn.glob(root .. '/colors/usgc-*.vim', false, true)) do
  local scheme = vim.fn.fnamemodify(path, ':t:r')
  vim.cmd.colorscheme(scheme)
  local normal = hl('Normal')

  for _, name in ipairs(layered) do
    local spec = hl(name)
    pairings = pairings + 1
    if not spec.bg then
      failures[#failures + 1] = string.format('%s: %s has no background of its own', scheme, name)
    else
      local ratio = contrast(spec.fg or normal.fg, spec.bg)
      if ratio < 3 then
        failures[#failures + 1] = string.format(
          '%s: %s #%06X on its own #%06X is %.2f:1, below 3.0:1',
          scheme,
          name,
          spec.fg or normal.fg,
          spec.bg,
          ratio
        )
      end
    end
  end

  for _, check in ipairs(checks) do
    local fg_group, bg_group, min = check[1], check[2], check[3]
    local fg = hl(fg_group).fg or normal.fg
    local backgrounds = { { bg_group, hl(bg_group).bg or normal.bg } }
    if bg_group ~= 'Normal' then
      local blended = mix(backgrounds[1][2], normal.bg, BLEND)
      backgrounds[#backgrounds + 1] = { bg_group .. ' blended', blended }
    end

    for _, background in ipairs(backgrounds) do
      pairings = pairings + 1
      local ratio = contrast(fg, background[2])
      if ratio < min then
        failures[#failures + 1] = string.format(
          '%s: %s #%06X on %s #%06X is %.2f:1, below %.1f:1',
          scheme,
          fg_group,
          fg,
          background[1],
          background[2],
          ratio,
          min
        )
      end
    end
  end
end

if #failures > 0 then
  io.stderr:write(table.concat(failures, '\n'), '\n')
  os.exit(1)
end

print(string.format('contrast: %d pairings pass', pairings))
