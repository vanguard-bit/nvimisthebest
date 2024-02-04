return {
  'EdenEast/nightfox.nvim',
  init = function() vim.cmd.colorscheme('nightfox')
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

  end,
  opts = {
    options = {
      transparent = true,
      inverse = {             -- Inverse highlight for different types
      match_paren = true,
      visual = true,
      search = false,
    },
  }
}
  -- 	styles = {
    -- 		-- foot.ini:
    -- 		-- font=IosevkaTerm Nerd Font Mono:weight=regular:size=12
    -- 		-- font-bold=IosevkaTerm Nerd Font Mono:weight=medium:size=12
    -- 		-- font-italic=IosevkaTerm Nerd Font Mono:weight=bold:size=12
    -- 		-- font-bold-italic=IosevkaTerm Nerd Font Mono:weight=black:size=12
    -- 		comments = 'NONE',
    -- 		conditionals = 'NONE',
    -- 		constants = 'NONE',
    -- 		-- functions = 'italic',
    -- 		keywords = 'NONE',
    -- 		numbers = 'NONE',
    -- 		types = 'NONE',
    -- 		variables = 'NONE',
    -- 	},
    -- },
    -- 	palettes = {
      -- 		nightfox = {
        -- 			bg0 = '#000000',
        -- 			bg1 = '#121821',
        -- 		},
        -- 	},
        -- 	groups = {
          -- 		nightfox = {
            -- 			StatusLine = { bg = 'none' },
            -- 			StatusLineNC = { bg = 'none' },
            -- 		},
            -- 	},
            -- },
            -- priority = 100,
          }

