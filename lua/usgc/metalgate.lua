-- USGC METALGATE - Cyan scheme
-- Metal gate transistor
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.fl_cyan,
  caret = p.fl_blue,
  accent = p.fl_yellow,
  -- Visual selection and search
  selection_bg = p.cyan,
  selection_fg = p.fl_cyan,
  -- Cursor line (subtle)
  cursorline_bg = p.blue,
  -- Popup menu (distinct from cursorline)
  popup_bg = p.cyan,
  popup_sel_bg = p.fl_yellow,
  popup_sel_fg = p.black,
  -- Gutter
  gutter_fg = p.fl_yellow,
  gutter_highlight = p.fl_cyan,
}

local M = {}

function M.apply()
  usgc.apply('usgc-metalgate', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
