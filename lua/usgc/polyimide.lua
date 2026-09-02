-- USGC POLYIMIDE - Amber scheme
-- Heat-resistant polymer
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.yellow,
  caret = p.green,
  accent = p.fl_orange,
  -- Visual selection and search (original uses blue)
  selection_bg = p.blue,
  selection_fg = p.fl_cyan,
  -- Cursor line (original uses fl_blue)
  cursorline_bg = p.fl_blue,
  -- Popup menu (distinct from cursorline)
  -- Not olive: at #666600 it is the brightest of the palette's dark tones, and
  -- the fl_orange accent that draws every float's border reached only 2.06:1
  -- on it. Maroon keeps the warm cast and takes that border to 4.57:1.
  popup_bg = p.maroon,
  popup_sel_bg = p.yellow,
  popup_sel_fg = p.black,
  -- Gutter
  gutter_fg = p.fl_orange,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-polyimide', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
