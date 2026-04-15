-- USGC EPITAXY - Magenta scheme
-- Crystal layer growth
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.fl_magenta,
  caret = p.white,
  accent = p.fl_blue,
  selection_bg = p.blue,
  selection_fg = p.fl_yellow,
  line_highlight = p.fl_yellow,
  gutter_fg = p.fl_blue,
  gutter_highlight = p.black,
}

local M = {}

function M.apply()
  usgc.apply('usgc-epitaxy', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
