if !exists("*GetLispIndent")
   function GetLispIndent()
      return lispindent(v:lnum)
   endfunction
endif
