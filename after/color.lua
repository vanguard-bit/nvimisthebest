local function get_lsp_client_name()
  --alacrity diffrent hl group
	local active_clients = vim.lsp.get_active_clients({ bufnr = 0 })
	local client_name

	if #active_clients > 0 then client_name = active_clients[2].name end
	return client_name
end
local fmt = string.format

----------------------------------------------------------------------------------------------------
---@param n number
---@return string
local hex = function(n)
  if n then
    return fmt("#%06x", n)
  end
end

---@param style string
---@return table
local function parse_style(style)
  if not style or style == "NONE" then
    return {}
  end

  local result = {}
  for token in string.gmatch(style, "([^,]+)") do
    result[token] = true
  end

  return result
end

---Get highlight opts for a given highlight group name
---@param name string
---@return table
local function get_highlight(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  if hl.link then
    return get_highlight(hl.link)
  end

  local result = parse_style(hl.style)
  result.fg = hl.foreground and hex(hl.foreground)
  result.bg = hl.background and hex(hl.background)
  result.sp = hl.special and hex(hl.special)

  return result
end

---Set highlight group from provided table
---@param groups table
local function set_highlights(groups)
  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

---Generate a color palette from the current applied colorscheme
---@return table
local function generate_pallet_from_colorscheme()
  -- stylua: ignore
  local color_map = {
    black   = { index = 0, default = "#393b44" },
    red     = { index = 1, default = "#c94f6d" },
    green   = { index = 2, default = "#81b29a" },
    yellow  = { index = 3, default = "#dbc074" },
    blue    = { index = 4, default = "#719cd6" },
    magenta = { index = 5, default = "#9d79d6" },
    cyan    = { index = 6, default = "#63cdcf" },
    white   = { index = 7, default = "#dfdfe0" },
  }

  local diagnostic_map = {
    hint = { hl = "DiagnosticHint", default = color_map.green.default },
    info = { hl = "DiagnosticInfo", default = color_map.blue.default },
    warn = { hl = "DiagnosticWarn", default = color_map.yellow.default },
    error = { hl = "DiagnosticError", default = color_map.red.default },
    ok = { hl = "DiagnosticOk", default = color_map.green.default },
  }

  local pallet = {}
  for name, value in pairs(color_map) do
    local global_name = "terminal_color_" .. value.index
    pallet[name] = vim.g[global_name] and vim.g[global_name] or value.default
  end

  for name, value in pairs(diagnostic_map) do
    pallet[name] = get_highlight(value.hl).fg or value.default
  end

  pallet.sl = get_highlight("StatusLine")
  pallet.sel = get_highlight("TabLineSel")

  return pallet
end

---Generate user highlight groups based on the curent applied colorscheme
---
---NOTE: This is a global because I dont known where this file will be in your config
---and it is needed for the autocmd below
_G._generate_user_statusline_highlights = function()
  local pal = generate_pallet_from_colorscheme()

  -- stylua: ignore
  local sl_colors = {
    Black   = { fg = pal.black,   bg = pal.white },
    Red     = { fg = pal.red,     bg = pal.sl.bg },
    Green   = { fg = pal.green,   bg = pal.sl.bg },
    Yellow  = { fg = pal.yellow,  bg = pal.sl.bg },
    Blue    = { fg = pal.blue,    bg = pal.sl.bg },
    Magenta = { fg = pal.magenta, bg = pal.sl.bg },
    Cyan    = { fg = pal.cyan,    bg = pal.sl.bg },
    White   = { fg = pal.white,   bg = pal.black },
  }

  local colors = {}
  for name, value in pairs(sl_colors) do
    colors["User" .. name] = { fg = value.fg, bg = value.bg, bold = true }
    colors["UserRv" .. name] = { fg = value.bg, bg = value.fg, bold = true }
  end

  local status = vim.o.background == "dark" and { fg = "none", bg = "none" } or { fg = "none", bg = "none", }

  local groups = {
    -- statusline
    UserSLHint = { fg = pal.sl.bg, bg = pal.hint, bold = true },
    UserSLInfo = { fg = pal.sl.bg, bg = pal.info, bold = true },
    UserSLWarn = { fg = pal.sl.bg, bg = pal.warn, bold = true },
    UserSLError = { fg = pal.sl.bg, bg = pal.error, bold = true },
    UserSLStatus = { fg = status.fg, bg = status.bg, bold = true },
    UserTLActive = { fg = pal.sel.fg, bg = pal.sel.bg, },

    UserSLFtHint = { fg = pal.sel.bg, bg = pal.hint },
    UserSLHintInfo = { fg = pal.hint, bg = pal.info },
    UserSLInfoWarn = { fg = pal.info, bg = pal.warn },
    UserSLWarnError = { fg = pal.warn, bg = pal.error },
    UserSLErrorStatus = { fg = pal.error, bg = status.bg },
    UserSLStatusBg = { fg = status.bg, bg = pal.sl.bg },

    UserSLAlt = pal.sel,
    UserSLAltSep = { fg = pal.sl.bg, bg = pal.sel.bg },
    UserSLGitBranch = { fg = pal.yellow, bg = pal.sl.bg },
    UserSLGitBranchSep = { fg = pal.sl.bg, bg = pal.sl.bg },
  }

  set_highlights(vim.tbl_extend("force", colors, groups))
end

_generate_user_statusline_highlights()

vim.api.nvim_create_augroup("UserStatuslineHighlightGroups", { clear = true })
vim.api.nvim_create_autocmd({ "SessionLoadPost", "ColorScheme" }, {
  callback = function()
    _generate_user_statusline_highlights()
  end,
})

-- configure feline
local function config(_, opts)
vim.cmd("colorscheme nightfox")
require('The Vanguard.plugins.fel')
	local colorscheme = vim.g.colors_name
	local palette = require('nightfox.palette').load(colorscheme)
	local feline = require('feline')
	local file = require('feline.providers.file')
	local separators = require('feline.defaults').statusline.separators.default_value

local vi = {
  -- Map vi mode to text name
  text = {
    n = "NORMAL",
    no = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    [""] = "V-BLOCK",
    c = "COMMAND",
    cv = "COMMAND",
    ce = "COMMAND",
    R = "REPLACE",
    Rv = "REPLACE",
    s = "SELECT",
    S = "SELECT",
    [""] = "SELECT",
    t = "TERMINAL",
  },

  -- Maps vi mode to highlight group color defined above
  colors = {
    n = "UserRvCyan",
    no = "UserRvCyan",
    i = "UserSLStatus",
    v = "UserRvMagenta",
    V = "UserRvMagenta",
    [""] = "UserRvMagenta",
    R = "UserRvRed",
    Rv = "UserRvRed",
    r = "UserRvBlue",
    rm = "UserRvBlue",
    s = "UserRvMagenta",
    S = "UserRvMagenta",
    [""] = "FelnMagenta",
    c = "UserRvYellow",
    ["!"] = "UserRvBlue",
    t = "UserRvBlue",
  },

  -- Maps vi mode to seperator highlight goup defined above
  sep = {
    n = "UserCyan",
    no = "UserCyan",
    i = "UserSLStatusBg",
    v = "UserMagenta",
    V = "UserMagenta",
    [""] = "UserMagenta",
    R = "UserRed",
    Rv = "UserRed",
    r = "UserBlue",
    rm = "UserBlue",
    s = "UserMagenta",
    S = "UserMagenta",
    [""] = "FelnMagenta",
    c = "UserYellow",
    ["!"] = "UserBlue",
    t = "UserBlue",
  },
}

-- local icons = {
--   locker = "", -- #f023
--   page = "☰", -- 2630
--   line_number = "", -- e0a1
--   connected = "", -- f817
--   dos = "", -- e70f
--   unix = "", -- f17c
--   mac = "", -- f179
--   mathematical_L = "𝑳",
--   vertical_bar = "┃",
--   vertical_bar_thin = "│",
--   left = "",
--   right = "",
--   block = "█",
--   left_filled = "",
--   right_filled = "",
--   slant_left = "",
--   slant_left_thin = "",
--   slant_right = "",
--   slant_right_thin = "",
--   slant_left_2 = "",
--   slant_left_2_thin = "",
--   slant_right_2 = "",
--   slant_right_2_thin = "",
--   left_rounded = "",
--   left_rounded_thin = "",
--   right_rounded = "",
--   right_rounded_thin = "",
--   circle = "●",
-- }

---Get the number of diagnostic messages for the provided severity
---@param str string [ERROR | WARN | INFO | HINT]
---@return string
local function get_diag(str)
  local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[str] })
  local count = #diagnostics

  return (count > 0) and " " .. count .. " " or ""
end

---Get highlight group from vi mode
---@return string
local function vi_mode_hl()
  return vi.colors[vim.fn.mode()] or "UserSLViBlack"
end

---Get sep highlight group from vi mode
local function vi_sep_hl()
  return vi.sep[vim.fn.mode()] or "UserSLBlack"
end

---Get the path of the file relative to the cwd
---@return string
local function file_info()
  local list = {}
  if vim.bo.readonly then
    table.insert(list, "🔒")
  end

  if vim.bo.modified then
    table.insert(list, "●")
  end

  table.insert(list, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:."))

  return table.concat(list, " ")
end


	local c = {
		vim_status = {
			provider = function()
				local s
				if require('lazy.status').has_updates() then
					s = require('lazy.status').updates()
				else
					s = ' '
				end
				s = string.format(' %s', s)
				return s
			end,
			hl =vi_mode_hl ,
            -- left_sep = {
            --   -- always_visible = true,
            --   str = "",
            --   hl =vi_sep_hl,
            -- },
			right_sep = {
				always_visible = true,
				str =  "",
				hl = vi_sep_hl,
			},
		},



		file_e = {
         provider=function()
           local str = {}
           str.str = ""
           str.hl={fg="#FFFFFF"}
           str="" .. str .. ""
           return str
end,
         hl ="UserCyan",
			left_sep = {
				always_visible = true,
				str = "",
				hl = "UserCyan",
			},
            right_sep = {
				always_visible = true,
				str = "",
				hl = "UserCyan",
            }
		},

		git_branch = {
			provider = function()
				local git = require('feline.providers.git')
				local branch, icon = git.git_branch()
				local s
				if #branch > 0 then
					s = string.format(' %s%s ', icon, branch)
				else
					s = string.format(' %s ', 'Untracked')
				end
				return s
			end,
			hl = "UserSLGitBranch",
			-- left_sep = {
			-- 	always_visible = true,
			-- 	str = '',
			-- 	hl = "UserSLGitBranch",
			-- },
			-- right_sep = {
			-- 	always_visible = true,
			-- 	str = '',
			-- 	hl ="UserSLGitBranch",
		 --  	},
		},

		lsp = {
          provider = function()
            return vim.tbl_count(vim.lsp.buf_get_clients(0)) == 1 and  " Λ " or ""
          end,
          hl = "UserSLStatus",
          left_sep = {
            always_visible = true,
            str = '',
            hl = "UserSLStatusBg",
          },
          right_sep = {
				always_visible = true,
				str = '',
				hl ="UserSLErrorStatus",
			},
		},

		-- right
 vi_mode = {
    provider = function()
      return fmt(" %s ", vi.text[vim.fn.mode()])
    end,
    hl = vi_mode_hl,
    left_sep = {
				always_visible = true,
				str ='',
				hl =vi_sep_hl,
			},
    right_sep = {
				always_visible = true,
				str ='',
				hl =vi_sep_hl,
			},
		},
        lsp_error = {
          provider = function()
            return get_diag("ERROR")
          end,
          hl = "UserSLError",
          right_sep = { str = "", hl = "UserSLWarnError", always_visible = true },
        },
        lsp_warn = {
          provider = function()
            return get_diag("WARN")
          end,
          hl = "UserSLWarn",
          right_sep = { str = "", hl = "UserSLInfoWarn", always_visible = true },
        },
        lsp_info = {
          provider = function()
            return get_diag("INFO")
          end,
          hl = "UserSLInfo",
          right_sep = { str = "", hl = "UserSLHintInfo", always_visible = true },
        },
        lsp_hint = {
          provider = function()
            return get_diag("HINT")
          end,
          hl = "UserSLHint",
          right_sep = { str = "", hl = "UserSLFtHint", always_visible = true },
        },

		macro = {
			provider = function()
				local s
				local recording_register = vim.fn.reg_recording()
				if #recording_register == 0 then
					s = ''
				else
					s = string.format(' Recording @%s ', recording_register)
				end
				return s
			end,
			hl = {fg="#393b44",bg="#BEADFA"},
			right_sep = {
				always_visible = true,
				str ="",
				hl = {fg="#BEADFA",bg="#F9F7C9"},
			},
		},

		-- search_count = {
		-- 	provider = function()
		-- 		if vim.v.hlsearch == 0 then return '' end
		--
		-- 		local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
		-- 		if not ok then return '' end
		-- 		if next(result) == nil then return '' end
		--
		-- 		local denominator = math.min(result.total, result.maxcount)
		-- 		return string.format(' [%d/%d] ', result.current, denominator)
		-- 	end,
		-- 	hl = { fg = 'none', bg = 'none' },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.left_filled,
		-- 		hl = function() return { fg = 'none', bg = 'none' } end,
		-- 	},
		-- 	right_sep = {
		-- 		always_visible = true,
		-- 		str = separators.left_filled,
		-- 		hl = { fg = 'none', bg = 'none' },
		-- 	},
		-- },
        in_file_type = {
    provider = function()
      return fmt(" %s ", vim.bo.filetype:upper())
    end,
    hl = "UserSLGitBranch",
    left_sep = {
				always_visible = true,
				str ='',
				hl ="UserSLGitBranch",
			},
    right_sep = {
				always_visible = true,
				str ='',
				hl ="UserSLGitBranch",--nightfox
				-- hl ={fg="#63cdcf",bg="#BEADFA"},--carbonfox
			},
		},
        file_type = {
    provider = function()
      return fmt(" %s ", vim.bo.filetype:upper())
    end,
    hl = "UserSLHint",
   --  left_sep = {
			-- 	always_visible = true,
			-- 	str ='',
			-- 	hl ="UserSLInfoWarn",
			-- },
    right_sep = {
				always_visible = true,
				str ='',
				hl ={fg="#81b29a",bg="#BEADFA"},--nightfox
				-- hl ={fg="#63cdcf",bg="#BEADFA"},--carbonfox
			},
		},

		cursor_position = {
			provider = {
				name = 'position',
				opts = { padding = false },
			},
			hl ={fg="#393b44",bg="#F9F7C9"},
			-- left_sep = {
			-- 	always_visible = true,
			-- 	str = string.format('%s%s', separators.left_filled,separators.block),
			-- 	hl = function() return { fg = 'none', bg = 'none' } end,
			-- },
			-- right_sep = {
			-- 	always_visible = true,
			-- 	str = '  ',
			-- 	hl = { fg = 'none', bg = 'none' },
			-- },
		},
	word_count = {
	         provider=function()
    -- -- the third string here is the string for visual-block mode (^V)
    -- if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
    --     return vim.fn.wordcount().visual_words ..""
    -- else
    --     return vim.fn.wordcount().words ..""
    -- end
    return ""
end,
			hl ={fg="#393b44",bg="#F9F7C9"},
			-- left_sep = {
			-- 	always_visible = true,
			-- 	str = string.format('%s%s', separators.left_filled,separators.block),
			-- 	hl = function() return { fg = 'none', bg = 'none' } end,
			-- },
			right_sep = {
				always_visible = true,
				str ="",
				hl = {fg="#F9F7C9",bg="#AF0FF1"},
			},
		},

		-- scroll_bar = {
		-- 	provider = {
		-- 		name = 'scroll_bar',
		-- 		opts = { reverse = true },
		-- 	},
		-- 	hl = { fg = palette.blue.dim, bg = palette.blue.base },
		-- },

		-- inactive statusline
		-- in_file_info = {
		-- 	provider = function()
		-- 		if vim.api.nvim_buf_get_name(0) ~= '' then
		-- 			return file.file_info({}, { colored_icon = true })
		-- 		else
		-- 			return file.file_type({}, { colored_icon = true, case = 'lowercase' })
		-- 		end
		-- 	end,
		-- 	hl = { fg = 'none', bg = 'none' },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = string.format('%s%s', separators.left_filled, separators.block),
		-- 		hl = { fg = 'none', bg = 'none' },
  -- 		},
		-- 	right_sep = {
		-- 		always_visible = true,
		-- 		str = ' ',
		-- 		hl = { fg = 'none', bg = 'none' },
		-- 	},
		-- },
  --         default = { -- needed to pass the parent StatusLine hl group to right hand side
  --   provider = "",
  --   hl = "StatusLine",
  -- },
	}

	local active = {
		{ -- left
			c.vim_status,
			c.git_branch,
            -- c.file_e,
            c.vi_mode,
            -- c.default,
		},
		{ -- right
            c.lsp,
            c.lsp_error,
            c.lsp_warn,
            c.lsp_info,
            c.file_type,
			c.macro,
			-- c.cursor_position,
            c.word_count,
		},
	}

	local inactive = {
      {
       c.git_branch,
       c.default
      },
      {
        c.in_file_type,
      }
	}

	opts.components = { active = active, inactive = inactive }

	feline.setup(opts)
end

	init = function()
		-- use a global statusline
		-- vim.opt.laststatus = 3

		-- update statusbar when there's a plugin update
		vim.api.nvim_create_autocmd('User', {
			pattern = 'LazyCheck',
			callback = function() vim.opt.statusline = vim.opt.statusline end,
		})


		-- hide the mode
		vim.opt.showmode = false

		-- hide search count on command line
		vim.opt.shortmess:append({ S = true })
	end

