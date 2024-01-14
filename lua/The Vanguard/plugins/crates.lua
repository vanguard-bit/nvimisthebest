return{
  {
    "saecki/crates.nvim",
    lazy = true,
    event = { "BufRead Cargo.toml" },
    init = function()
      local fn = vim.fn
      local api = vim.api
      local keymap = vim.keymap
      local lsp = vim.lsp
      local lsp_protocol = lsp.protocol
      local autocmd = api.nvim_create_autocmd
      local augroup = api.nvim_create_augroup
      local create_command = api.nvim_create_user_command
      autocmd("BufRead", {
        group = api.nvim_create_augroup("UserSetCargoCmpSource", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
          local cmp = require("cmp")
          ---@diagnostic disable-next-line: missing-fields
          cmp.setup.buffer({ sources = { { name = "crates" } } })
        end,
      })

      autocmd("BufRead", {
        pattern = "Cargo.toml",
        callback = function()
          local actions = require("crates.actions")

          local command = "crates.run_action"
          vim.lsp.commands[command] = function(cmd, ctx)
            local action = actions.get_actions()[cmd.data]
            if action then
              vim.api.nvim_buf_call(ctx.bufnr, action)
            end
          end
          local api = vim.api
          local server = require("The Vanguard.utils.lsp").server({
            capabilities = {
              codeActionProvider = true,
            },
            handlers = {
              --@param params lsp.CodeActionParams
              ["textDocument/codeAction"] = function(_, params)
                local function format_title(name)
                  return name:sub(1, 1):upper() .. name:gsub("_", " "):sub(2)
                end

                local code_actions = {}
                for key, action in pairs(actions.get_actions()) do
                  table.insert(code_actions, {
                    title = format_title(key),
                    kind = "refactor.rewrite",
                    command = command,
                    data = key,
                  })
                end
                return code_actions
              end,
            },
          })
          vim.lsp.start({ name = "crates_ls", cmd = server })
        end,
      })
    end,
    config = function()
      local cmp = require'cmp'
      require("crates").setup({
        popup = {
          border = cmp.config.window.bordered(),
        },
        src = {
          cmp = { enabled = true },
        },
      })
    end,
  },
}
