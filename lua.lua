local str ={}
local str1 ={}
str1.str=""
str1.hl={fg="#10f023",bg="#000000"}
str.str=""
str.hl={fg="#10f023"}
        str = vim.tbl_deep_extend('keep',str1 , str)
print(str.hl)
