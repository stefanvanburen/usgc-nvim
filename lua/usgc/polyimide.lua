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
  popup_bg = p.olive,
  popup_sel_bg = p.yellow,
  popup_sel_fg = p.black,
  -- LSP references / folds / context
  reference_bg = p.fl_blue,
  fold_bg = p.fl_blue,
  context_bg = p.fl_blue,
  -- Gutter
  gutter_fg = p.fl_orange,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-polyimide', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
