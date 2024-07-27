return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = function()
      require("telescope").setup({})

      vim.api.nvim_create_user_command("FileTypes", "Telescope filetypes", {})
      vim.api.nvim_create_user_command("Diagnostics", "Telescope diagnostics", {})
      vim.api.nvim_create_user_command("Grep", "Telescope grep_string", {})
      vim.api.nvim_create_user_command("LspDefinitions", "Telescope lsp_definitions", {})
      vim.api.nvim_create_user_command("LspDocumentSymbols", "Telescope lsp_document_symbols", {})
      vim.api.nvim_create_user_command("LspImplementations", "Telescope lsp_implementations", {})
      vim.api.nvim_create_user_command("LspReferences", "Telescope lsp_references", {})
      vim.api.nvim_create_user_command("LspWorkspaceSymbols", "Telescope lsp_workspace_symbols", {})
    end,
  },
}
