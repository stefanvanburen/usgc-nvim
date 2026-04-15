-- USGC METALGATE - Cyan scheme
-- Metal gate transistor
local usgc = require('usgc')
local p = usgc.palette

local opts = {
  bg = p.black,
  fg = p.fl_cyan,
  caret = p.fl_blue,
  accent = p.fl_yellow,
  selection_bg = p.olive,
  selection_fg = p.fl_yellow,
  line_highlight = p.fl_blue,
  gutter_fg = p.fl_yellow,
  gutter_highlight = p.fl_cyan,
}

local M = {}

function M.apply()
  usgc.apply('usgc-metalgate', usgc.make_groups(opts), usgc.make_terminal(opts))
end

return M
