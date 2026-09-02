-- Generate Ghostty themes from these colorschemes.
--
--   nvim -l contrib/ghostty.lua [outdir]
--
-- outdir defaults to $XDG_CONFIG_HOME/ghostty/themes. Ghostty finds themes by
-- filename, so a generated usgc-reticle is selected with `theme = usgc-reticle`.
--
-- Everything is read back out of Neovim rather than duplicated here, so the two
-- cannot drift: the palette comes from g:terminal_color_0-15, and the remaining
-- keys from the Normal, Cursor and Visual highlight groups.

local root = vim.fs.dirname(vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2)))
vim.opt.runtimepath:prepend(root)
vim.o.termguicolors = true

local config = os.getenv('XDG_CONFIG_HOME') or (os.getenv('HOME') .. '/.config')
local outdir = arg[1] or (config .. '/ghostty/themes')
vim.fn.mkdir(outdir, 'p')

-- @param group string
-- @param key 'fg'|'bg'
-- @return string
local function color(group, key)
  local value = vim.api.nvim_get_hl(0, { name = group, link = false })[key]
  assert(value, group .. ' has no ' .. key)
  return string.format('#%06X', value)
end

for _, path in ipairs(vim.fn.glob(root .. '/colors/*.vim', false, true)) do
  local name = vim.fn.fnamemodify(path, ':t:r')
  vim.cmd.colorscheme(name)

  local lines = {
    '# ' .. name .. ' -- generated from stefanvanburen/usgc-nvim.',
    '# Do not edit by hand: change the colorscheme there and regenerate.',
    '',
  }
  for i = 0, 15 do
    lines[#lines + 1] = string.format('palette = %d=%s', i, vim.g['terminal_color_' .. i])
  end
  vim.list_extend(lines, {
    '',
    'background = ' .. color('Normal', 'bg'),
    'foreground = ' .. color('Normal', 'fg'),
    'cursor-color = ' .. color('Cursor', 'bg'),
    'cursor-text = ' .. color('Cursor', 'fg'),
    'selection-background = ' .. color('Visual', 'bg'),
    'selection-foreground = ' .. color('Visual', 'fg'),
  })

  local out = outdir .. '/' .. name
  local file = assert(io.open(out, 'w'))
  file:write(table.concat(lines, '\n'), '\n')
  file:close()
  print('wrote ' .. out)
end
