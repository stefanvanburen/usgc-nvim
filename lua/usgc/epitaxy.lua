-- USGC EPITAXY - Magenta scheme
-- Crystal layer growth
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.fl_magenta,
  caret = p.white,
  accent = p.fl_blue,
  -- Visual selection and search
  selection_bg = p.magenta,
  selection_fg = p.fl_magenta,
  -- Cursor line (subtle)
  cursorline_bg = p.blue,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.magenta,
  popup_sel_bg = p.fl_blue,
  popup_sel_fg = p.white,
  -- Gutter
  gutter_fg = p.fl_blue,
  gutter_highlight = p.fl_magenta,
}

local M = {}

function M.apply()
  usgc.apply('usgc-epitaxy', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
