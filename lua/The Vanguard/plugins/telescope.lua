return{
  'nvim-telescope/telescope.nvim', tag = '0.1.5',
  -- or                              , branch = '0.1.x',
  dependencies = {{ 'nvim-lua/plenary.nvim'},
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    config = function()
        require("telescope").load_extension("fzf")
  local builtin = require('telescope.builtin')
   vim.keymap.set('n', '<leader>sww', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>sW', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>sw', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

      end,
  },{
    'nvim-telescope/telescope-symbols.nvim',
},
},
keys= {
      {
        "<leader>rb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
      { "<leader>rf", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      -- git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
      -- search
      { '<leader>"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>km", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      {"<S-T>","<cmd>Telescope symbols<cr>",desc="Symbols"},
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({
          })
        end,
        desc = "Goto Symbol (Workspace)",
      },
      v={{'<leader>"',"<cmd>Telescope registers<CR>"},},
    i={  {"<S-T>","<cmd>Telescope symbols<cr>",desc="Symbols"},
  },
},
config = function()
  local actions = require("telescope.actions")
  local trouble = require("trouble.sources.telescope")

  local telescope = require("telescope")
  local previewers = require("telescope.previewers")

  telescope.setup {
    extensions = {
      fzf = {
        fuzzy = true,                    -- false will only do exact matching
        override_generic_sorter = true,  -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
        case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        -- the default case_mode is "smart_case"
      }
    },

    defaults = {
      mappings = {
        i = { ["<c-t>"] = trouble.open },
        n = { ["<c-t>"] = trouble.open },
      },
      preview = {
        filesize_limit = 10, -- MB
      },
    },
    pickers =  {
      buffers = {
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          }
        }
      },
      find_files = {
        mappings = {
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end
          }
        }
      },
    },
  }
end,
    }
