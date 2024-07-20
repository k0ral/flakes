return {
  "andymass/vim-matchup",
  "echasnovski/mini.nvim",
  "folke/trouble.nvim",
  "folke/which-key.nvim",
  "ggandor/leap.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        override_vim_notify = true
      }
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
  },
  "L3MON4D3/LuaSnip",
  "lervag/vimtex",
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  "mbbill/undotree",
  {
    "mcauley-penney/tidy.nvim",
    opts = {
        filetype_exclude = { "markdown", "diff" }
    },
  },
  "mickael-menu/zk-nvim",
  { 'mrcjkb/rustaceanvim', version = '^4', ft = { 'rust' } },
  "neovim/nvim-lspconfig",
  "neovimhaskell/haskell-vim",
  "nvimtools/none-ls.nvim",
  "numToStr/Comment.nvim",
  "nvim-lua/popup.nvim",
  { "nvim-telescope/telescope.nvim", dependencies = { 'nvim-lua/plenary.nvim' }, opts = {} },
  "marko-cerovac/material.nvim",
  "purescript-contrib/purescript-vim",
  "romgrk/barbar.nvim",
  "saadparwaiz1/cmp_luasnip",
  { "stevearc/aerial.nvim", dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" } },
  "stevearc/dressing.nvim",
  "tpope/vim-eunuch",
  "vmchale/dhall-vim",
}
