return{
  'mfussenegger/nvim-dap',
  dependencies={
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',
  },
  config = function ()
    require("dapui").setup()     
    require("nvim-dap-virtual-text").setup()
local dap = require("dap")
local dap = require("dap")
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}
dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
  },
} 
end
}
