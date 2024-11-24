return {
  "neovim/nvim-lspconfig",
  event = {"VeryLazy", "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
  { "folke/neodev.nvim", opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
  --   Change the Diagnostic symbols in the sign column (gutter)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
 require("neodev").setup({
--   -- add any options here, or leave empty to use the default settings
 library = { plugins = { "nvim-dap-ui" }, types = true } 
 })
     local keymap = vim.keymap -- for conciseness

     local opts = { noremap = true, silent = true }
     local on_attach = function(client,bufnr)
       opts.buffer = bufnr
       -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

       opts.desc = "Go to declaration"
       keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

       opts.desc = "Show LSP definitions"
       keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

       opts.desc = "Show LSP implementations"
       keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

       opts.desc = "Show LSP type definitions"
       keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

       opts.desc = "See available code actions"
       keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

       opts.desc = "Smart rename"
       keymap.set("n", "<leader>re", vim.lsp.buf.rename, opts) -- smart rename
       opts.desc = "Show buffer diagnostics"
       keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

       opts.desc = "Show line diagnostics"
       keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

       opts.desc = "Go to previous diagnostic"
       keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

       opts.desc = "Go to next diagnostic"
       keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

       opts.desc = "Show documentation for what is under cursor"
       keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

       opts.desc = "Restart LSP"
       keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
     end


 local capabilities = require('cmp_nvim_lsp').default_capabilities()
 -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
 require('lspconfig')['clangd'].setup {
   capabilities = capabilities,
       on_attach=on_attach,
 }
 require('lspconfig')['rust_analyzer'].setup({
   capabilities = capabilities,
       on_attach=on_attach,
       single_file_support = true,
     settings = {
       inlayHints=true,
         ["rust-analyzer"] = {
             imports = {
                 granularity = {
                     group = "module",
                 },
                 prefix = "self",
             },

  cargo = {
             allFeatures = true,
             loadOutDirsFromCheck = true,
             runBuildScripts = true,
           },
           -- Add clippy lints for Rust.
           checkOnSave = {
             allFeatures = true,
             command = "clippy",
             extraArgs = { "--no-deps" },
           },
             procMacro = {
                 enable = true
             },
         }
     },
     taplo = {
       keys = {
         {
           "K",
          function()
            if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
               require("crates").show_popup()
             else
               vim.lsp.buf.hover()
             end
           end,
           desc = "Show Crate Documentation",
         },
       },
     },
 })
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.env.VIMRUNTIME
        --   -- Depending on the usage, you might want to add additional paths here.
        --   "${3rd}/luv/library"
        --   -- "${3rd}/busted/library",
        -- },
        -- -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  settings = {
    Lua = {}
  }
} -- require'lspconfig'['typos_lsp'].setup{
 --   capabilities = capabilities,
 --     root_dir = function(fname)
 --     return require('lspconfig.util').root_pattern('typos.toml', '_typos.toml', '.typos.toml')(fname)
 --       or vim.fn.getcwd()
 --   end,
 --       on_attach=on_attach,
 -- }
 -- require'lspconfig'['pylyzer'].setup({
 --   capabilities = capabilities,
 --       on_attach=on_attach,
 --  settings={
 --   python = {
 --     checkOnType = false,
 --     diagnostics = true,
 --     inlayHints = true,
 --     smartCompletion = true
 --   }
 -- }
 -- })
 require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}
  -- init.lua
  -- require'lspconfig'.jdtls.setup{cmd = {"jdtls"}}
-- require'lspconfig'.java_language_server.setup{cmd = {"lang_server_windows.cmd"}}
end,
}

-- require'lspconfig'.rust_analyzer.setup({
--     on_attach=on_attach,
--     capabilities = capabilities,
-- })
-- require'lspconfig'.clangd.setup({
--     capabilities = capabilities,
--     on_attach = on_attach
--    })
--     require'lspconfig'.lua_ls.setup({
--     capabilities = capabilities,
--     on_attach = on_attach,
--
-- })
-- require'lspconfig'.typos_lsp.setup{
--    capabilities = capabilities,
--    on_attach = on_attach,
-- }
--  require'lspconfig'.pylyzer.setup({
--      capabilities = capabilities,
--  on_attach = on_attach,
--
-- }
