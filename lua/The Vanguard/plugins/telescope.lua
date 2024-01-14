return{
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    --keys= {
        {vim.keymap.set('n', '<leader>ff',":Telescope find_files<CR>")},
        {vim.keymap.set('n', '<leader>fh', ":Telescope help_tags<CR>")},
        {vim.keymap.set('n', '<leader>sw', ":Telescope live_grep<CR>")},
        {vim.keymap.set('n', '<leader>rf', ":Telescope oldfiles<CR>")},
        -- }
        config = function()
            local actions = require("telescope.actions")
            local trouble = require("trouble.providers.telescope")

            local telescope = require("telescope")
            local previewers = require("telescope.previewers")

            telescope.setup {
                defaults = {
                    mappings = {
                        i = { ["<c-t>"] = trouble.open_with_trouble },
                        n = { ["<c-t>"] = trouble.open_with_trouble },
                    },
                    preview = {
                        filesize_limit = 10, -- MB
                    },
                },
                pickers =  {
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
