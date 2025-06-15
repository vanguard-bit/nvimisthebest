return{
  event = "InsertEnter",
  "hrsh7th/nvim-cmp",
  dependencies = {
    'chrisgrieser/cmp_yanky',
    --    " For snippy users.
    -- 'dcampos/nvim-snippy',
    -- 'dcampos/cmp-snippy',
    --     For vsnip users.
    --    'hrsh7th/cmp-vsnip'
    --    'hrsh7th/vim-vsnip'
    -- luasnip users.
    'honza/vim-snippets',
    'saadparwaiz1/cmp_luasnip',
    -- "rafamadriz/friendly-snippets",

    --     ultisnips users.
    --    'SirVer/ultisnips'
    --    'quangnguyen30192/cmp-nvim-ultisnips'
    "hrsh7th/cmp-buffer",
    'neovim/nvim-lspconfig',
    "hrsh7th/cmp-path",
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-cmdline',
  },
--local winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"
-- Set up nvim-cmp.
  config = function()
  require("luasnip.loaders.from_snipmate").lazy_load()
    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    -- require("luasnip.loaders.from_vscode").lazy_load()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local cmp = require'cmp'

cmp.setup({

  formatting = {
   format = function(entry, vim_item)
    -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
      -- Source
      return vim_item
    end
  },

  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      --  vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
       require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },

  window = {
--  completion = {
    completion = cmp.config.window.bordered(),
			--	winhighlight = winhighlight,
		--	},
			---@diagnostic disable-next-line: missing-fields
		--	documentation = {
                documentation = cmp.config.window.bordered(),
			--	winhighlight = winhighlight,
		--	},
          },
  mapping = cmp.mapping.preset.insert({
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-x>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),

  sources = cmp.config.sources({
    { name = 'luasnip', option = { show_autosnippets = true } }, -- For luasnip users.
    { name = 'nvim_lsp' },
    {name = "cmp_yanky"},
    --  { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    {name = "codeium"},
    { name = 'buffer', keyword_length = 3},
    -- {name="cmdline"},
    {name="path"},
    {name = "crates"}
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})
local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})
end
}
