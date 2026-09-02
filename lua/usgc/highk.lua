-- USGC HIGHK - White scheme
-- High dielectric constant
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.white,
  fg = p.black,
  caret = p.fl_blue,
  accent = p.fl_red,
  -- Visual selection and search (original uses fl_green)
  selection_bg = p.fl_green,
  selection_fg = p.black,
  -- Cursor line (original uses fl_green)
  cursorline_bg = p.fl_green,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.white,
  popup_sel_bg = p.fl_red,
  popup_sel_fg = p.white,
  -- Gutter
  gutter_fg = p.fl_red,
  gutter_highlight = p.black,
  -- The default terminal palette assumes a black background; on white it
  -- leaves 8 of 16 slots under 3:1. Normals use the dark half of the standard
  -- palette, brights the fluorescent half only where it stays legible.
  terminal = {
    [0] = p.black,
    [1] = p.maroon,
    [2] = p.green,
    [3] = p.olive,
    [4] = p.blue,
    [5] = p.magenta,
    [6] = p.cyan,
    [7] = p.gray,
    [8] = p.gray,
    [9] = p.fl_red,
    [10] = p.green,
    [11] = p.olive,
    [12] = p.fl_blue,
    [13] = p.fl_magenta,
    [14] = p.cyan,
    [15] = p.black,
  },
}

local M = {}

function M.apply()
  usgc.apply('usgc-highk', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
