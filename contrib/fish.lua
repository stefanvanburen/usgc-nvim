-- Generate fish themes from these colorschemes.
--
--   nvim -l contrib/fish.lua [outdir]
--
-- outdir defaults to $XDG_CONFIG_HOME/fish/themes. fish lists themes by
-- filename, so a generated usgc-reticle.theme is selected with
-- `fish_config theme choose usgc-reticle`, and made permanent with
-- `fish_config theme save`.
--
-- As with contrib/ghostty.lua, every color is read back out of Neovim rather
-- than duplicated here, so the two cannot drift.

local root = vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2)))
vim.opt.runtimepath:prepend(root)
vim.o.termguicolors = true

local config = os.getenv('XDG_CONFIG_HOME') or (os.getenv('HOME') .. '/.config')
local outdir = arg[1] or (config .. '/fish/themes')
vim.fn.mkdir(outdir, 'p')

-- fish takes bare hex, so these carry no leading '#'.
-- @param value number
-- @return string
local function hex(value)
  return string.format('%06X', value)
end

-- Render a highlight group as a fish color value: a foreground, then any
-- background and attributes fish understands.
-- @param group string
-- @param mode? 'fg'|'bg' to take only one half, for variables that want one
-- @return string
local function spec(group, mode)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  local parts = {}
  if mode ~= 'bg' then
    if hl.fg then
      parts[#parts + 1] = hex(hl.fg)
    end
    if hl.bold then
      parts[#parts + 1] = '--bold'
    end
    if hl.underline then
      parts[#parts + 1] = '--underline'
    end
    if hl.italic then
      parts[#parts + 1] = '--italics'
    end
    if hl.reverse then
      parts[#parts + 1] = '--reverse'
    end
  end
  if mode ~= 'fg' and hl.bg then
    parts[#parts + 1] = '--background=' .. hex(hl.bg)
  end
  assert(#parts > 0, group .. ' produced an empty fish color')
  return table.concat(parts, ' ')
end

-- fish's color variables, paired with the highlight group each reads from.
-- Ordered rather than a plain table so the generated files stay readable.
local variables = {
  { 'fish_color_normal', 'Normal', 'fg' },
  { 'fish_color_command', 'Statement' },
  { 'fish_color_keyword', 'Keyword' },
  { 'fish_color_param', 'Identifier' },
  { 'fish_color_option', 'Special' },
  { 'fish_color_quote', 'String' },
  { 'fish_color_escape', 'SpecialChar' },
  { 'fish_color_operator', 'Operator' },
  { 'fish_color_redirection', 'Operator' },
  { 'fish_color_end', 'Delimiter' },
  { 'fish_color_comment', 'Comment' },
  { 'fish_color_autosuggestion', 'NonText' },
  { 'fish_color_error', 'ErrorMsg' },
  { 'fish_color_status', 'ErrorMsg' },
  { 'fish_color_cancel', 'ErrorMsg' },
  { 'fish_color_valid_path', 'Underlined' },
  { 'fish_color_cwd', 'Directory' },
  { 'fish_color_cwd_root', 'ErrorMsg' },
  { 'fish_color_user', 'Special' },
  { 'fish_color_host', 'Normal', 'fg' },
  { 'fish_color_host_remote', 'Special' },
  { 'fish_color_selection', 'Visual' },
  { 'fish_color_search_match', 'Search' },
  { 'fish_color_history_current', 'Statement' },
  { 'fish_pager_color_background', 'Pmenu', 'bg' },
  { 'fish_pager_color_completion', 'Pmenu' },
  { 'fish_pager_color_description', 'Comment' },
  { 'fish_pager_color_prefix', 'Special' },
  { 'fish_pager_color_progress', 'Title' },
  { 'fish_pager_color_selected_background', 'PmenuSel', 'bg' },
  { 'fish_pager_color_selected_completion', 'PmenuSel' },
  { 'fish_pager_color_selected_description', 'PmenuSel' },
  { 'fish_pager_color_selected_prefix', 'PmenuSel' },
}

-- Only the variants: the `usgc` colorscheme is a light/dark switch between
-- them, and has no colors of its own to generate from.
for _, path in ipairs(vim.fn.glob(root .. '/colors/usgc-*.vim', false, true)) do
  local name = vim.fn.fnamemodify(path, ':t:r')
  vim.cmd.colorscheme(name)

  local background = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg
  local lines = {
    "# name: '" .. name .. "'",
    '# preferred_background: ' .. hex(assert(background, 'Normal has no background')),
    '#',
    '# Generated from stefanvanburen/usgc-nvim. Do not edit by hand: change the',
    '# colorscheme there and regenerate.',
    '',
  }
  for _, entry in ipairs(variables) do
    local variable, group, mode = entry[1], entry[2], entry[3]
    lines[#lines + 1] = variable .. ' ' .. spec(group, mode)
  end

  local out = outdir .. '/' .. name .. '.theme'
  local file = assert(io.open(out, 'w'))
  file:write(table.concat(lines, '\n'), '\n')
  file:close()
  print('wrote ' .. out)
end
