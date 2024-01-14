local vim = vim
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>n", "nzzzv")
vim.keymap.set("n", "<leader>m", "Nzzzv")

--[[vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)--]]

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-z>", "<Esc>")
--godly telescope remaps
vim.keymap.set("n", "\"", ":Telescope registers<CR>")
vim.keymap.set("n", "<leader>rb", ":Telescope buffers<CR>")

vim.keymap.set("n", "Q", "<nop>")
--vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz",{noremap = true})
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/AppData/Local/nvim/lua/The Vanguard/lazy.lua<CR>");
vim.keymap.set("n", "<leader>km", "<cmd>e ~/AppData/Local/nvim/lua/The Vanguard/remap.lua<CR>");
--vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

--vim.keymap.set("n", "<leader><leader>", function()
--    vim.cmd("so")
--end)
--for compiling
vim.keymap.set('n', 'py', ':w <bar> !python "%"<CR>', { silent = true })
vim.keymap.set('n', 'cpp', ':w <bar> !c++ "%" -o "%:r".exe', { silent = true })
vim.keymap.set('n', 'sh', ':w <bar> !chmod +x "%" && source "%"<CR>', { silent = true })
vim.keymap.set('n', 'c', ':w <bar> !gcc "%" -o "C:/Users/Prajwal/OneDrive/Desktop/new/Newfolder/nvimoutput/a.exe"<CR><CR>', { silent = true })
vim.keymap.set('n', 'jv', ':w <bar> !javac "%" && java "%:r"<CR>', { silent =true })

vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
vim.keymap.set("n", "r","<C-r>")--redo
vim.keymap.set("n","<leader><leader>",":w|so<CR>")
vim.keymap.set("n", "n", ":n<CR>")
vim.keymap.set("n", "m", ":N<CR>")
vim.keymap.set({"n","v"},"<leader>x",'"_x')--delete but not to register
vim.keymap.set("n","<leader>w","<C-w>w")
vim.keymap.set("n","<leader>wf","<C-w>o")
vim.keymap.set("n","<leader>wq","<C-w>q")
vim.keymap.set("n","<leader>u",":UndotreeToggle<CR>")

--lazyvim keymaps
vim.keymap.set("n","<leader>l",":Lazy<CR>")
vim.keymap.set("n","<leader>fn",":enew<CR>")
--vim.keymap.set("n","<leader>te","<C-w>s:term<CR>13<C-w>-")
vim.keymap.set("n","te","<C-w>l|ia.exe<CR>")
-- Terminal Mappings
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-left>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
--vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
--vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
--vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
--vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
--vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
--vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
--vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
vim.keymap.set("i","<S-Tab>","<cmd>Telescope symbols<CR>")
