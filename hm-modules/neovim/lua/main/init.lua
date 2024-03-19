local cmd = vim.cmd
local fn = vim.fn
local global = vim.g
local map = vim.api.nvim_set_keymap
local opt = vim.opt

-- General options
opt.clipboard = 'unnamedplus'
opt.completeopt = {'menu', 'menuone', 'noselect'}
opt.cursorline = true
opt.expandtab = true
opt.foldmethod = 'marker'
opt.guifont = 'VictorMono Nerd Font:h14'
opt.hidden = true
opt.inccommand = 'split'
opt.list = true
opt.listchars = 'tab:▸ ,trail:·'
opt.number = true
opt.pastetoggle = '<F12>'
opt.showmatch = true
opt.shiftwidth = 2
opt.showmode = false
opt.shortmess = opt.shortmess + { c = true }
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.undodir = fn.stdpath('config') .. '/undodir'
opt.undofile = true

global.mapleader = '<Space>'
global.maplocalleader = ','

-- Colorscheme
opt.background = 'dark'
global.material_style = 'deep ocean'
require('material').setup({
  styles = {
    comments = { italic = true },
  },
  plugins = {
    "gitsigns",
    "mini",
    "nvim-web-devicons",
    "telescope",
    "trouble",
    "which-key",
  },
  lualine_style = "stealth",
})
cmd 'colorscheme material'


--
-- Plugin specific
--

-- Aerial
require("aerial").setup({
  open_automatic = true,
})

-- Comment
require('Comment').setup()

-- Fidget
require("fidget").setup{
  notification = {
    override_vim_notify = true
  }
}

-- Git signs
require('gitsigns').setup()

-- Indent blankline
require("ibl").setup()

-- Leap
require('leap').opts.highlight_unlabeled_phase_one_targets = true

-- LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp = require('lspconfig')

local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


lsp.java_language_server.setup {
  capabilities = capabilities,
  cmd = { "java-language-server" },
}
lsp.gopls.setup {
  capabilities = capabilities,
}
lsp.hls.setup {
  capabilities = capabilities,
}
lsp.marksman.setup {
  capabilities = capabilities,
}
lsp.pyright.setup {
  capabilities = capabilities,
}
lsp.rnix.setup {
  capabilities = capabilities,
}

-- Auto-completion
local cmp = require("cmp")
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  },
}

-- Lualine
require('lualine').setup {
  options = { theme = 'material' },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', { 'diagnostics', sources = { 'nvim_lsp' } } },
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = {'quickfix'}
}

-- Mini
require('mini.cursorword').setup()

-- Null-ls
local null_ls = require("null-ls")
local sources = {
  null_ls.builtins.code_actions.statix,
  null_ls.builtins.diagnostics.golangci_lint,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.jq,
  null_ls.builtins.formatting.nixfmt,
}

null_ls.setup({ sources = sources })

-- Rainbow
global.rainbow_active = true

-- Telescope
require("telescope")

-- Text-case
require('textcase').setup()

-- Tidy
require("tidy").setup()

-- Tree-sitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  ensure_installed = {
    "dockerfile",
    "fish",
    "go",
    "html",
    "java",
    "json",
    "lua",
    "nix",
    "python",
    "rust",
    "terraform",
    "toml",
    "yaml",
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
  },
}

-- Trouble
require('trouble').setup {
  auto_close = true, -- automatically close the list when you have no diagnostics
}

-- Undotree
global.undotree_SetFocusWhenToggle = true
map('n', '<A-z>', ':UndotreeToggle<CR>', { noremap = true })

-- Which-key
require("which-key").setup()

--
-- Language-specific
--

--  Haskell
global.haskell_indent_disable = true

-- Java
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.java",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Go
require('go').setup()

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})

-- Python
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Rust
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- TeX
global.tex_flavor = 'latex'

--
-- Key bindings
--
map('n', '<C-b>', '<cmd>Telescope buffers<CR>', {})
map('i', '<C-b>', '<C-o><cmd>Telescope buffers<CR>', {})
map('n', '<C-c>', '<Esc>', { noremap = true })
map('i', '<C-c>', '<Esc>', { noremap = true })
map('n', '<C-d>', 'dw', {})
map('i', '<C-d>', '<C-o>dw', {})
map('n', '<C-e>', '<End>', { noremap = true })
map('i', '<C-e>', '<End>', { noremap = true })
map('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<CR>', {})
map('i', '<C-f>', '<C-o><cmd>Telescope current_buffer_fuzzy_find<CR>', {})
vim.keymap.set({'n'}, '<C-g>', function ()
  local current_window = vim.fn.win_getid()
  require('leap').leap { target_windows = { current_window } }
end)
map('n', '<C-h>', ':%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>', {})
map('i', '<C-h>', '<C-o>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>', {})
map('n', '<C-m>', '%', { noremap = true })
-- Breaks Enter key
-- map('i', '<C-m>', '<C-o>%', { noremap = true })
map('n', '<C-n>', ':AerialNext<CR>', {})
map('i', '<C-n>', '<C-o>:AerialNext<CR>', {})
map('n', '<C-p>', ':AerialPrev<CR>', {})
map('i', '<C-p>', '<C-o>:AerialPrev<CR>', {})
map('n', '<C-q>', ':confirm qall<CR>', {})
map('i', '<C-q>', '<C-o>:confirm qall<CR>', {})
map('n', '<C-s>', ':w<CR>', {})
map('i', '<C-s>', '<C-o>:w<CR>', {})
map('v', '<C-s>', '<Esc>:w<CR>gv', {})
map('n', '<C-t>', ':Telescope find_files<CR>', {})
map('i', '<C-t>', '<C-o>:Telescope find_files<CR>', {})
map('n', '<C-v>', 'P', { noremap = true })
map('i', '<C-v>', '<C-o>P', { noremap = true })
map('n', '<C-w>', ':bdelete<CR>', {})
map('i', '<C-w>', '<C-o>:bdelete<CR>', {})
map('n', '<C-y>', ':redo<CR>', {})
map('i', '<C-y>', '<C-o>:redo<CR>', {})
map('n', '<C-z>', ':undo<CR>', {})
map('i', '<C-z>', '<C-o>:undo<CR>', {})
map('n', '<C-Del>', 'dw', {})
map('i', '<C-Del>', '<C-o>dw', {})
map('n', '<C-PageDown>', ':BufferNext<CR>', {})
map('i', '<C-PageDown>', '<C-o>:BufferNext<CR>', {})
map('v', '<C-PageDown>', ':BufferNext<CR>', {})
map('n', '<C-S-PageDown>', ':BufferMoveNext<CR>', {})
map('i', '<C-S-PageDown>', '<C-o>:BufferMoveNext<CR>', {})
map('v', '<C-S-PageDown>', ':BufferMoveNext<CR>', {})
map('n', '<C-PageUp>', ':BufferPrevious<CR>', {})
map('i', '<C-PageUp>', '<C-o>:BufferPrevious<CR>', {})
map('v', '<C-PageUp>', ':BufferPrevious<CR>', {})
map('n', '<C-S-PageUp>', ':BufferMovePrevious<CR>', {})
map('i', '<C-S-PageUp>', '<C-o>:BufferMovePrevious<CR>', {})
map('v', '<C-S-PageUp>', ':BufferMovePrevious<CR>', {})
map('i', '<C-Down>', '<C-o>}', { noremap = true })
map('n', '<C-Down>', '}', { noremap = true })
map('v', '<C-Down>', '}', { noremap = true })
map('i', '<C-Up>', '<C-o>{', { noremap = true })
map('n', '<C-Up>', '{', { noremap = true })
map('v', '<C-Up>', '{', { noremap = true })
map('i', '<C-Left>', '<C-o>b', { noremap = true })
map('n', '<C-Left>', 'b', { noremap = true })
map('i', '<C-Right>', '<C-o>e', { noremap = true })
map('n', '<C-Right>', 'e', { noremap = true })
map('i', '<A-CR>', '<C-o>:LspDefinition<CR>', {})
map('v', '<A-CR>', ':LspDefinition<CR>', {})

map('n', '<A-Del>', ':delete<CR>', {})
map('i', '<A-Del>', '<C-o>:delete<CR>', {})
map('', '<A-Left>', '<Home>', { noremap = true })
map('i', '<A-Left>', '<Home>', { noremap = true })
map('', '<A-Right>', '<End>', { noremap = true })
map('i', '<A-Right>', '<End>', { noremap = true })
map('n', '<A-c>', '<Plug>(comment_toggle_linewise_current)', {})
map('i', '<A-c>', '<C-o><Plug>(comment_toggle_linewise_current)', {})
map('v', '<A-c>', '<Plug>(comment_toggle_linewise_visual)', {})
map('n', '<A-h>', ':LspHover<CR>', { noremap = true })
map('i', '<A-h>', '<C-o>:LspHover<CR>', { noremap = true })
map('n', '<A-n>', '*', { noremap = true })
map('i', '<A-n>', '<C-o>*', { noremap = true })
map('n', '<A-p>', '#', { noremap = true })
map('i', '<A-p>', '<C-o>#', { noremap = true })
map('n', '<A-x>', '<cmd>Telescope commands<CR>', {})
map('i', '<A-x>', '<C-o><cmd>Telescope commands<CR>', {})

map('n', '<Esc>', ':nohl<CR>:echo<CR>', {})
map('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<C-o>>>"', { noremap = true, expr = true })
map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<C-o><<"', { noremap = true, expr = true })
map('n', '<Tab>', '>>', { noremap = true })
map('n', '<S-Tab>', '<<', { noremap = true })

map('n', '<F5>', '<Plug>(lcn-menu)', {})

-- map('n', '<Space>', '@=(foldlevel('.')?'za':"\<Space>")<CR>', { noremap = true, silent = true })
-- map('v', '<Space>', 'zf', { noremap = true })

map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })
map('v', 'y', 'ygv', { noremap = true })
map('v', 'y', 'ygv', { noremap = true })
