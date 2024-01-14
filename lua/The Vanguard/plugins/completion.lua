return{
  "hrsh7th/nvim-cmp",
  --    " For snippy users.
  'dcampos/nvim-snippy',
  'dcampos/cmp-snippy',
  --     For vsnip users.
  --    'hrsh7th/cmp-vsnip'
  --    'hrsh7th/vim-vsnip'
  -- luasnip users.
  'L3MON4D3/LuaSnip',
 'saadparwaiz1/cmp_luasnip',
 "rafamadriz/friendly-snippets",

  --     ultisnips users.
  --    'SirVer/ultisnips'
  --    'quangnguyen30192/cmp-nvim-ultisnips'
  dependencies = {
    "hrsh7th/cmp-buffer",
    'neovim/nvim-lspconfig',
    "hrsh7th/cmp-path",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
  },
  event = "InsertEnter",
  config = function()
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
        end,
  }

