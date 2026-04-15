-- USGC POLYIMIDE - Amber scheme
-- Heat-resistant polymer
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.yellow,
  caret = p.green,
  accent = p.fl_orange,
  selection_bg = p.blue,
  selection_fg = p.fl_cyan,
  line_highlight = p.fl_blue,
  gutter_fg = p.fl_orange,
  gutter_highlight = p.white,
}

local M = {}

function M.apply()
  usgc.apply('usgc-polyimide', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
