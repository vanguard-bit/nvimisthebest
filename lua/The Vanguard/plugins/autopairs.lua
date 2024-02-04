return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts={},
-- If you want insert `(` after select function or method item
-- -- config = function()
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- local cmp = require('cmp')
-- cmp.event:on(
-- 'confirm_done',
-- cmp_autopairs.on_confirm_done()
-- )
-- end,
}
