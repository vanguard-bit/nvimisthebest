return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  --config = function()

    -- Change the Diagnostic symbols in the sign column (gutter)
    --local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    --for type, icon in pairs(signs) do
      --local hl = "DiagnosticSign" .. type
      --vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    --end
--
--require'lspconfig'.rust_analyzer.setup({
    --on_attach=on_attach,
    --capabilities = capabilities,
--})
--require'lspconfig'.clangd.setup({
    --capabilities = capabilities,
    --on_attach = on_attach
   --})
    --require'lspconfig'.lua_ls.setup({
    --capabilities = capabilities,
    --on_attach = on_attach,
--
--})
--require'lspconfig'.typos_lsp.setup{
   --capabilities = capabilities,
   --on_attach = on_attach,
--}
 --require'lspconfig'.pylyzer.setup({
     --capabilities = capabilities,
 --on_attach = on_attach,
--end
}
