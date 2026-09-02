-- USGC EPITAXY - Magenta scheme
-- Crystal layer growth
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.fl_magenta,
  caret = p.white,
  -- Upstream's fl_blue sits at 2.44:1 against this scheme's black background,
  -- which reaches every group linked to Special.
  accent = p.fl_cyan,
  -- Visual selection and search (original uses blue)
  selection_bg = p.blue,
  selection_fg = p.fl_yellow,
  -- Cursor line (original uses fl_yellow)
  cursorline_bg = p.fl_yellow,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.magenta,
  popup_sel_bg = p.fl_blue,
  popup_sel_fg = p.white,
  -- Gutter
  gutter_fg = p.fl_blue,
  gutter_highlight = p.black,
}

local M = {}

function M.apply()
  usgc.apply('usgc-epitaxy', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
