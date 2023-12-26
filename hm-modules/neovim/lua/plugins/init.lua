local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "andymass/vim-matchup",
  "echasnovski/mini.nvim",
  "folke/trouble.nvim",
  "folke/which-key.nvim",
  "ggandor/leap.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "j-hui/fidget.nvim",
  "johmsalas/text-case.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "kyazdani42/nvim-web-devicons",
  "L3MON4D3/LuaSnip",
  "lervag/vimtex",
  "lewis6991/gitsigns.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "mbbill/undotree",
  "mcauley-penney/tidy.nvim",
  "mickael-menu/zk-nvim",
  "neovim/nvim-lspconfig",
  "neovimhaskell/haskell-vim",
  "numToStr/Comment.nvim",
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-telescope/telescope.nvim",
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  "marko-cerovac/material.nvim",
  "p00f/nvim-ts-rainbow",
  "purescript-contrib/purescript-vim",
  "ray-x/go.nvim",
  "romgrk/barbar.nvim",
  "saadparwaiz1/cmp_luasnip",
  "simrat39/rust-tools.nvim",
  "stevearc/dressing.nvim",
  "tpope/vim-eunuch",
  "vmchale/dhall-vim",
})
