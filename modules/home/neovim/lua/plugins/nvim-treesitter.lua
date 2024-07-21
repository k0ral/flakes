return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nushell/tree-sitter-nu",
    },
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = false,
        },
        ensure_installed = {
          "dockerfile",
          "go",
          "gomod",
          "gosum",
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
      })
    end,
  },
}
