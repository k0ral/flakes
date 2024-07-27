return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "creativenull/efmls-configs-nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lsp = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }
      for type, icon in pairs(signs) do
        local hl = "LspDiagnosticsSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      lsp.efm.setup({
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

      lsp.jdtls.setup({
        capabilities = capabilities,
      })
      lsp.golangci_lint_ls.setup({
        capabilities = capabilities,
      })
      lsp.gopls.setup({
        capabilities = capabilities,
      })
      lsp.hls.setup({
        capabilities = capabilities,
      })
      lsp.marksman.setup({
        capabilities = capabilities,
      })
      lsp.nil_ls.setup({
        capabilities = capabilities,
        settings = {
          ["nil"] = {
            formatting = {
              command = { "nixfmt" },
            },
          },
        },
      })
      lsp.pylsp.setup({
        capabilities = capabilities,
        settings = {
          pylsp = {
            plugins = {
              pylint = { enabled = true },
              ruff = { formatEnabled = false },
            },
          },
        },
      })
      lsp.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
          },
        },
      })
    end,
  },
}
