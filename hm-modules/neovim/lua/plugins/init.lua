local cmd = vim.cmd
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

require "paq" {
  "savq/paq-nvim";  -- Let Paq manage itself

  'andymass/vim-matchup';
  'echasnovski/mini.nvim';
  'folke/trouble.nvim';
  'folke/which-key.nvim';
  'ggandor/leap.nvim';
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-nvim-lsp-signature-help';
  'jose-elias-alvarez/null-ls.nvim';
  'kyazdani42/nvim-web-devicons';
  'L3MON4D3/LuaSnip';
  'lervag/vimtex';
  'lewis6991/gitsigns.nvim';
  'lukas-reineke/indent-blankline.nvim';
  'mbbill/undotree';
  'mickael-menu/zk-nvim';
  'neovim/nvim-lspconfig';
  'neovimhaskell/haskell-vim';
  'ntpeters/vim-better-whitespace';
  'numToStr/Comment.nvim';
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  'nvim-lualine/lualine.nvim';
  'nvim-telescope/telescope.nvim';
  {'nvim-treesitter/nvim-treesitter', build = 'TSUpdate'};
  'marko-cerovac/material.nvim';
  'p00f/nvim-ts-rainbow';
  'purescript-contrib/purescript-vim';
  'ray-x/go.nvim';
  'rcarriga/nvim-notify';
  'romgrk/barbar.nvim';
  'saadparwaiz1/cmp_luasnip';
  'stevearc/dressing.nvim';
  'tpope/vim-eunuch';
  'vmchale/dhall-vim';
}
