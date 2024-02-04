
--typos_lsp ignore
-- -- progress data
-- local clients = {}
-- local progress = { '⠋', '⠙', '⠸', '⢰', '⣠', '⣄', '⡆', '⠇' }
--
-- -- check for lsp progress data
-- local function is_lsp_loading(client) return client and clients[client] and clients[client].percentage < 100 end
--
-- -- update lsp progress
-- local function update_lsp_progress()
-- 	local messages = vim.lsp.util.get_progress_messages()
-- 	for _, message in ipairs(messages) do
-- 		if not message.name then goto continue end
--
-- 		local client_name = message.name
--
-- 		if not clients[client_name] then clients[client_name] = { percentage = 0, progress_index = 0 } end
--
-- 		if message.done then
-- 			clients[client_name].percentage = 100
-- 		else
-- 			if message.percentage then clients[client_name].percentage = message.percentage end
-- 		end
--
-- 		if clients[client_name].percentage % 5 == 0 or clients[client_name].progress_index == 0 then
-- 			vim.opt.statusline = vim.opt.statusline
-- 			clients[client_name].progress_index = clients[client_name].progress_index + 1
-- 		end
--
-- 		if clients[client_name].progress_index > #progress then clients[client_name].progress_index = 1 end
--
-- 		::continue::
-- 	end
-- end
--
-- get lsp client name for buffer
local function get_lsp_client_name()
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

  local status = vim.o.background == "dark" and { fg = pal.black, bg = pal.white } or { fg = pal.white, bg = pal.black }

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
    -- local colors = require("The Vanguard.utils.colors")
	local feline = require('feline')
	local vi_mode = require('feline.providers.vi_mode')
	local file = require('feline.providers.file')
	local separators = require('feline.defaults').statusline.separators.default_value
	-- local lsp = require('feline.providers.lsp')

	-- local theme = {
	-- 	fg = palette.fg1,
	-- 	bg = palette.bg1,
	-- 	black = palette.black.base,
	-- 	skyblue = palette.blue.bright,
	-- 	cyan = palette.cyan.base,
	-- 	green = palette.green.base,
	-- 	oceanblue = palette.blue.base,
	-- 	magenta = palette.magenta.base,
	-- 	orange = palette.orange.base,
	-- 	red = palette.red.base,
	-- 	violet = palette.magenta.bright,
	-- 	white = palette.white.base,
	-- 	yellow = palette.yellow.base,
	-- }
    -- Feline

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

local icons = {
  locker = "", -- #f023
  page = "☰", -- 2630
  line_number = "", -- e0a1
  connected = "", -- f817
  dos = "", -- e70f
  unix = "", -- f17c
  mac = "", -- f179
  mathematical_L = "𝑳",
  vertical_bar = "┃",
  vertical_bar_thin = "│",
  left = "",
  right = "",
  block = "█",
  left_filled = "",
  right_filled = "",
  slant_left = "",
  slant_left_thin = "",
  slant_right = "",
  slant_right_thin = "",
  slant_left_2 = "",
  slant_left_2_thin = "",
  slant_right_2 = "",
  slant_right_2_thin = "",
  left_rounded = "",
  left_rounded_thin = "",
  right_rounded = "",
  right_rounded_thin = "",
  circle = "●",
}

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

		-- local function git_diff(type)
		-- 	---@diagnostic disable-next-line: undefined-field
		-- 	local gsd = vim.b.gitsigns_status_dict
		-- 	if gsd and gsd[type] and gsd[type] > 0 then return tostring(gsd[type]) end
		-- 	return nil
		-- end

		-- left
		vim_status = {
			provider = function()
				local s
				if require('lazy.status').has_updates() then
					s = require('lazy.status').updates()
				else
					s = ''
				end
				s = string.format(' %s', s)
				return s
			end,
			hl =vi_mode_hl ,
            --[[ left_sep = {
              always_visible = true,
              str = separators.,
              hl ={ fg = palette.blue.base, bg ='none'},
            }, ]]
			right_sep = {
				always_visible = true,
				str =  "",
				hl = vi_sep_hl,
			},
		},

		file_name = {
			provider = {
				name = 'file_info',
				opts = { colored_icon = true },
			},
			hl = "UserSLAlt",
			left_sep = {
				always_visible = true,
				str = "",
				hl = "UserSLAltSep",
			},
            right_sep = {
				always_visible = true,
				str = "",
				hl = "UserSLAltSep",
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
			left_sep = {
				always_visible = true,
				str = '█',
				hl = "UserSLGitBranch",
			},
			right_sep = {
				always_visible = true,
				str = '',
				hl ="UserSLGitBranch",
		  	},
		},

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local status = git_diff('added')
		-- 		local s
		-- 		if status then
		-- 			s = string.format(' %s %s ', '', status)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.green.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.bg0, bg = palette.green.base },
		-- 	},
		-- })

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local status = git_diff('changed')
		-- 		local s
		-- 		if status then
		-- 			s = string.format(' %s %s ', '', status)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.yellow.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.green.base, bg = palette.yellow.base },
		-- 	},
		-- })

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local status = git_diff('removed')
		-- 		local s
		-- 		if status then
		-- 			s = string.format(' %s %s ', '', status)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.red.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.yellow.base, bg = palette.red.base },
		-- 	},
		-- 	right_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.red.base, bg = palette.bg0 },
		-- 	},
		-- })

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
				hl ="UserSLStatusBg",
			},
		},

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local s
		-- 		local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }))
		-- 		if count > 0 then
		-- 			s = string.format(' %s %d ', '', count)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
	-- 	hl = { fg = palette.bg0, bg = palette.red.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.bg0, bg = palette.red.base },
		-- 	},
		-- })

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local s
		-- 		local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }))
		-- 		if count > 0 then
		-- 			s = string.format(' %s %d ', '', count)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.magenta.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.red.base, bg = palette.magenta.base },
		-- 	},
		-- })

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local s
		-- 		local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }))
		-- 		if count > 0 then
		-- 			s = string.format(' %s %d ', '', count)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.blue.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.magenta.base, bg = palette.blue.base },
		-- 	},
		-- })

		-- table.insert(components.active[left], {
		-- 	provider = function()
		-- 		local s
		-- 		local count = vim.tbl_count(vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }))
		-- 		if count > 0 then
		-- 			s = string.format(' %s %d ', '', count)
		-- 		else
		-- 			s = ''
		-- 		end
		-- 		return s
		-- 	end,
		-- 	hl = { fg = palette.bg0, bg = palette.orange.base },
		-- 	left_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.blue.base, bg = palette.orange.base },
		-- 	},
		-- 	right_sep = {
		-- 		always_visible = true,
		-- 		str = separators.slant_right,
		-- 		hl = { fg = palette.orange.base, bg = 'none' },
		-- 	},
		-- })

		-- right
 vi_mode = {
    provider = function()
      return fmt(" %s ", vi.text[vim.fn.mode()])
    end,
    hl = vi_mode_hl,
    left_sep = {
				always_visible = true,
				str ='',
				hl =vi_sep_hl1,
			},
    right_sep = {
				always_visible = true,
				str ='',
				hl =vi_sep_hl1,
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
			hl = { fg = 'none', bg = 'none' },
			left_sep = {
				always_visible = true,
				str = separators.left_filled,
				hl = function() return { fg = 'none', bg = 'none' } end,
			},
		},

		search_count = {
			provider = function()
				if vim.v.hlsearch == 0 then return '' end

				local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 250 })
				if not ok then return '' end
				if next(result) == nil then return '' end

				local denominator = math.min(result.total, result.maxcount)
				return string.format(' [%d/%d] ', result.current, denominator)
			end,
			hl = { fg = 'none', bg = 'none' },
			left_sep = {
				always_visible = true,
				str = separators.left_filled,
				hl = function() return { fg = 'none', bg = 'none' } end,
			},
			right_sep = {
				always_visible = true,
				str = separators.left_filled,
				hl = { fg = 'none', bg = 'none' },
			},
		},
        file_type = {
    provider = function()
      return fmt(" %s ", vim.bo.filetype:upper())
    end,
    hl = "UserSLAlt",
  },

		cursor_position = {
			provider = {
				name = 'position',
				opts = { padding = false },
			},
			hl = { fg = 'none', bg = 'none' },
			left_sep = {
				always_visible = true,
				str = string.format('%s%s', separators.left_filled,separators.block),
				hl = function() return { fg = 'none', bg = 'none' } end,
			},
			right_sep = {
				always_visible = true,
				str = '  ',
				hl = { fg = 'none', bg = 'none' },
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
		in_file_info = {
			provider = function()
				if vim.api.nvim_buf_get_name(0) ~= '' then
					return file.file_info({}, { colored_icon = true })
				else
					return file.file_type({}, { colored_icon = true, case = 'lowercase' })
				end
			end,
			hl = { fg = 'none', bg = 'none' },
			left_sep = {
				always_visible = true,
				str = string.format('%s%s', separators.left_filled, separators.block),
				hl = { fg = 'none', bg = 'none' },
  		},
			right_sep = {
				always_visible = true,
				str = ' ',
				hl = { fg = 'none', bg = 'none' },
			},
		},
	}

	local active = {
		{ -- left
			c.vim_status,
			c.file_name,
			c.git_branch,
            c.vi_mode,
		},
		{ -- right
            c.lsp,
            c.lsp_error,
            c.lsp_warn,
            c.lsp_info,
            c.file_type,
			c.macro,
			c.search_count,
			c.cursor_position,
			-- c.scroll_bar,
		},
	}

	local inactive = {
		{ -- left
		},
		{ -- right
			c.in_file_info,
		},
	}

	opts.components = { active = active, inactive = inactive }

	feline.setup(opts)
     -- feline.use_theme(groups)
end

