-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup(
  "plugins",
  {
    change_detection = {
      enabled = false,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        }
      }
    }
  }
)

-- [[ Setting options ]]

local function safeRequire(module)

	local success, loadedModule = pcall(require, module)

	if success then return loadedModule end

	vim.cmd.echo ("Error loading " .. module)

end

safeRequire("config.options")
safeRequire("config.keymaps")
safeRequire("config.autocmds")


-- TODO Recoalesce compile_commands
-- os.execute('jq -s add out/**/compile_commands.json > compile_commands.json')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
