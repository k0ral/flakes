lua require("plugins")
lua require("main")

" Nix
au BufNewFile,BufRead *.nix set filetype=nix

" Commands
command! ConfigOpen edit $MYVIMRC
command! ConfigReload source $MYVIMRC
command! LspCapabilities lua print(vim.inspect(vim.lsp.buf_get_clients()[1].server_capabilities))
command! LspCodeActions lua vim.lsp.buf.code_action()
command! LspDefinitions Telescope lsp_definitions
command! LspDocumentSymbols Telescope lsp_document_symbols
command! LspFormat lua vim.lsp.buf.format({ async = false })
command! LspHover lua vim.lsp.buf.hover()
command! LspImplementations Telescope lsp_implementations
command! LspRename lua vim.lsp.buf.rename()
command! LspReferences Telescope lsp_references
command! LspSignatureHelp lua vim.lsp.buf.signature_help()
command! LspTypeDefinition lua vim.lsp.buf.type_definition()
command! LspWorkspaceSymbols Telescope lsp_workspace_symbols
command! FileTypes Telescope filetypes
