local cmd = vim.cmd
local fn = vim.fn
local global = vim.g
local map = vim.api.nvim_set_keymap
local opt = vim.opt

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
global.mapleader = "<Space>"
global.maplocalleader = ","

require("config.lazy")
require("plugins")

-- General options
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.cursorline = true
opt.expandtab = true
opt.foldmethod = "marker"
opt.guifont = "VictorMono Nerd Font:h14"
opt.hidden = true
opt.inccommand = "split"
opt.list = true
opt.listchars = "tab:▸ ,trail:·"
opt.number = true
opt.showmatch = true
opt.shiftwidth = 2
opt.showmode = false
opt.shortmess = opt.shortmess + { c = true }
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.undodir = fn.stdpath("config") .. "/undodir"
opt.undofile = true

-- Colorscheme
opt.background = "dark"
global.material_style = "deep ocean"
require("material").setup({
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
cmd("colorscheme material")

--
-- Plugin specific
--

-- Aerial
require("aerial").setup({
  open_automatic = true,
})

-- Comment
require("Comment").setup()

-- Leap
require("leap").opts.highlight_unlabeled_phase_one_targets = true

-- Auto-completion
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
  },
})

-- Mini
require("mini.cursorword").setup()

-- Undotree
global.undotree_SetFocusWhenToggle = true
map("n", "<A-z>", ":UndotreeToggle<CR>", { noremap = true })

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

-- Lua
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.lua" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Nix
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.nix" },
  command = "set filetype=nix",
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

--
-- Key bindings
--
map('n', '<C-d>', 'dw', {})
map('i', '<C-d>', '<C-o>dw', {})
map("n", "<C-b>", "<cmd>Telescope buffers<CR>", {})
map("i", "<C-b>", "<C-o><cmd>Telescope buffers<CR>", {})
map("n", "<C-c>", "<Esc>", { noremap = true })
map("i", "<C-c>", "<Esc>", { noremap = true })
map("n", "<C-e>", "<End>", { noremap = true })
map("i", "<C-e>", "<End>", { noremap = true })
map("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<CR>", {})
map("i", "<C-f>", "<C-o><cmd>Telescope current_buffer_fuzzy_find<CR>", {})
vim.keymap.set({ "n" }, "<C-g>", function()
  local current_window = vim.fn.win_getid()
  require("leap").leap({ target_windows = { current_window } })
end)
map("n", "<C-h>", ":%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>", {})
map("i", "<C-h>", "<C-o>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>", {})
map("n", "<C-m>", "%", { noremap = true })
-- Breaks Enter key
-- map('i', '<C-m>', '<C-o>%', { noremap = true })
map("n", "<C-n>", ":AerialNext<CR>", {})
map("i", "<C-n>", "<C-o>:AerialNext<CR>", {})
map("n", "<C-p>", ":AerialPrev<CR>", {})
map("i", "<C-p>", "<C-o>:AerialPrev<CR>", {})
map("n", "<C-q>", ":confirm qall<CR>", {})
map("i", "<C-q>", "<C-o>:confirm qall<CR>", {})
map("n", "<C-s>", ":w<CR>", {})
map("i", "<C-s>", "<C-o>:w<CR>", {})
map("v", "<C-s>", "<Esc>:w<CR>gv", {})
map("n", "<C-t>", ":Telescope find_files<CR>", {})
map("i", "<C-t>", "<C-o>:Telescope find_files<CR>", {})
map("n", "<C-v>", "P", { noremap = true })
map("i", "<C-v>", "<C-o>P", { noremap = true })
map("n", "<C-w>", ":bdelete<CR>", {})
map("i", "<C-w>", "<C-o>:bdelete<CR>", {})
map("n", "<C-y>", ":redo<CR>", {})
map("i", "<C-y>", "<C-o>:redo<CR>", {})
map("n", "<C-z>", ":undo<CR>", {})
map("i", "<C-z>", "<C-o>:undo<CR>", {})
map("n", "<C-Del>", "dw", {})
map("i", "<C-Del>", "<C-o>dw", {})
map("n", "<C-PageDown>", ":BufferNext<CR>", {})
map("i", "<C-PageDown>", "<C-o>:BufferNext<CR>", {})
map("v", "<C-PageDown>", ":BufferNext<CR>", {})
map("n", "<C-S-PageDown>", ":BufferMoveNext<CR>", {})
map("i", "<C-S-PageDown>", "<C-o>:BufferMoveNext<CR>", {})
map("v", "<C-S-PageDown>", ":BufferMoveNext<CR>", {})
map("n", "<C-PageUp>", ":BufferPrevious<CR>", {})
map("i", "<C-PageUp>", "<C-o>:BufferPrevious<CR>", {})
map("v", "<C-PageUp>", ":BufferPrevious<CR>", {})
map("n", "<C-S-PageUp>", ":BufferMovePrevious<CR>", {})
map("i", "<C-S-PageUp>", "<C-o>:BufferMovePrevious<CR>", {})
map("v", "<C-S-PageUp>", ":BufferMovePrevious<CR>", {})
map("i", "<C-Down>", "<C-o>}", { noremap = true })
map("n", "<C-Down>", "}", { noremap = true })
map("v", "<C-Down>", "}", { noremap = true })
map("i", "<C-Up>", "<C-o>{", { noremap = true })
map("n", "<C-Up>", "{", { noremap = true })
map("v", "<C-Up>", "{", { noremap = true })
map("i", "<C-Left>", "<C-o>b", { noremap = true })
map("n", "<C-Left>", "b", { noremap = true })
map("i", "<C-Right>", "<C-o>e", { noremap = true })
map("n", "<C-Right>", "e", { noremap = true })
map("i", "<A-CR>", "<C-o>:LspDefinition<CR>", {})
map("v", "<A-CR>", ":LspDefinition<CR>", {})

map("n", "<A-Del>", ":delete<CR>", {})
map("i", "<A-Del>", "<C-o>:delete<CR>", {})
map("", "<A-Left>", "<Home>", { noremap = true })
map("i", "<A-Left>", "<Home>", { noremap = true })
map("", "<A-Right>", "<End>", { noremap = true })
map("i", "<A-Right>", "<End>", { noremap = true })
map("n", "<A-c>", "<Plug>(comment_toggle_linewise_current)", {})
map("i", "<A-c>", "<C-o><Plug>(comment_toggle_linewise_current)", {})
map("v", "<A-c>", "<Plug>(comment_toggle_linewise_visual)", {})
map("n", "<A-h>", ":LspHover<CR>", { noremap = true })
map("i", "<A-h>", "<C-o>:LspHover<CR>", { noremap = true })
map("n", "<A-n>", "*", { noremap = true })
map("i", "<A-n>", "<C-o>*", { noremap = true })
map("n", "<A-p>", "#", { noremap = true })
map("i", "<A-p>", "<C-o>#", { noremap = true })
map("n", "<A-x>", "<cmd>Telescope commands<CR>", {})
map("i", "<A-x>", "<C-o><cmd>Telescope commands<CR>", {})

map("n", "<Esc>", ":nohl<CR>:echo<CR>", {})
map("i", "<Tab>", 'pumvisible() ? "<C-n>" : "<C-o>>>"', { noremap = true, expr = true })
map("i", "<S-Tab>", 'pumvisible() ? "<C-p>" : "<C-o><<"', { noremap = true, expr = true })
map("n", "<Tab>", ">>", { noremap = true })
map("n", "<S-Tab>", "<<", { noremap = true })

map("n", "<F5>", "<Plug>(lcn-menu)", {})

-- map('n', '<Space>', '@=(foldlevel('.')?'za':"\<Space>")<CR>', { noremap = true, silent = true })
-- map('v', '<Space>', 'zf', { noremap = true })

map("v", "<", "<gv", { noremap = true })
map("v", ">", ">gv", { noremap = true })
map("v", "y", "ygv", { noremap = true })
map("v", "y", "ygv", { noremap = true })

-- Commands
vim.api.nvim_create_user_command("LspCapabilities", function(opts)
  print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities))
end, {})
vim.api.nvim_create_user_command("LspCodeActions", function(opts)
  vim.lsp.buf.code_action()
end, {})
vim.api.nvim_create_user_command("LspDefinitions", "Telescope lsp_definitions", {})
vim.api.nvim_create_user_command("LspDocumentSymbols", "Telescope lsp_document_symbols", {})
vim.api.nvim_create_user_command("LspFormat", function(opts)
  vim.lsp.buf.format({ async = false })
end, {})
vim.api.nvim_create_user_command("LspHover", function(opts)
  vim.lsp.buf.hover()
end, {})
vim.api.nvim_create_user_command("LspImplementations", "Telescope lsp_implementations", {})
vim.api.nvim_create_user_command("LspRename", function(opts)
  vim.lsp.buf.rename()
end, {})
vim.api.nvim_create_user_command("LspReferences", "Telescope lsp_references", {})
vim.api.nvim_create_user_command("LspSignatureHelp", function(opts)
  vim.lsp.buf.signature_help()
end, {})
vim.api.nvim_create_user_command("LspTypeDefinition", function(opts)
  vim.lsp.buf.type_definition()
end, {})
vim.api.nvim_create_user_command("LspWorkspaceSymbols", "Telescope lsp_workspace_symbols", {})
vim.api.nvim_create_user_command("FileTypes", "Telescope filetypes", {})
