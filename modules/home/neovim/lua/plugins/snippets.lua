return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope.nvim",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("telescope").load_extension("luasnip")

      vim.api.nvim_create_user_command("Snippets", "Telescope luasnip", {})
    end,
  },
}
