local mark = require("harpoon.mark")
local term = require("harpoon.term")             -- navigates to term 1
local ui = require("harpoon.ui")
local keymap = require"vim.keymap"

keymap.set("n", "<leader>a", mark.add_file)
keymap.set("n", "<C-e>", ui.toggle_quick_menu)
keymap.set("n", "<C-a>", function() ui.nav_file(1) end)
keymap.set("n", "<C-b>", function() ui.nav_file(2) end)
keymap.set("n", "<C-c>", function() ui.nav_file(3) end)
keymap.set("n", "<C-d>", function() ui.nav_file(4) end)
keymap.set("n", "<leader>tE", function() term.gotoTerminal(1) end)
