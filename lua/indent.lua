local M = {}

-- this makes unmapped ctrl f indet the current line
-- you can use it without recursive mapping
-- you should call restore_user_configuration after this to fix the user's formmatting keys
M.enable_ctrl_f_formatting = function()
   M.old_cinkeys = vim.o.cinkeys
   M.old_indentkeys = vim.o.indentkeys
   M.old_cindent = vim.o.cindent
   M.old_indentexpr = vim.o.indentexpr
   -- incase they set a custom lisp formatter
   if vim.o.indentexpr == '' and vim.o.filetype == 'lisp' then
      vim.o.indentexpr = 'GetLispIndent()'
   end
   if vim.o.indentexpr ~= '' then
      vim.o.indentkeys = '!^F'
   else
      vim.o.cinkeys = '!^F'
      vim.o.cindent = true
   end
end

M.restore_user_configuration = function()
   vim.o.cindent = M.old_cindent
   vim.o.cinkeys = M.old_cinkeys
   vim.o.indentexpr = M.old_indentexpr
   vim.o.indentkeys = M.old_indentkeys
end

--- @param lnum number 0 indexed
--  returns negative values for errors / invalid lines
M.getline_indent = function(lnum)
   lnum = lnum or (vim.api.nvim_win_get_cursor(0)[1] - 1)
   lnum = lnum + 1
   if vim.o.indentexpr == '' and vim.o.filetype == 'lisp' then
      return vim.fn.lispindent(lnum)
   end
   if vim.o.indentexpr ~= '' then
      vim.v.lnum = lnum
      return vim.fn.eval(vim.o.indentexpr)
   else
      return vim.fn.cindent(lnum)
   end
end

return M
