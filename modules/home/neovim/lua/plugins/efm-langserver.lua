return {
  {
    "creativenull/efmls-configs-nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lspconfig").efm.setup({
        filetypes = { "go", "json", "lua", "nix", "proto" },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
        settings = {
          rootMarkers = { ".git/" },
          languages = {
            go = { require("efmls-configs.linters.golangci_lint") },
            json = { require("efmls-configs.formatters.jq") },
            lua = { require("efmls-configs.formatters.stylua"), require("efmls-configs.linters.selene") },
            nix = { require("efmls-configs.linters.statix") },
            proto = { require("efmls-configs.formatters.buf"), require("efmls-configs.linters.buf") },
          },
        },
      })
    end,
  },
}
