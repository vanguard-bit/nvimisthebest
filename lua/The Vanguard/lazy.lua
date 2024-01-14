local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" 
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.g.mapleader = " "
vim.opt.rtp:prepend(lazypath)
vim.opt.termguicolors = true
require("lazy").setup({{import = "The Vanguard.plugins"},{import = "The Vanguard.plugins.lsp"},
})