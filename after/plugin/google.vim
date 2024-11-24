function! Google()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;]*')
  echo s:uri
  if s:uri != ""
    let url = "http://www.google.com/search?q=" . s:uri
    let path = "C:\\Program Files\\Google\\Chrome\\Application\\"
    exec '!"' . path . 'chrome.exe" ' . url
  else
    echo "No URI found in line."
  endif
endfunction
" fun! Google()
"     let keyword = expand("<cWORD>")
"     let url = "http://www.google.com/search?q=" . keyword
"     let path = "C:\\Program Files\\Google\\Chrome\\Application\\"
"     exec '!"' . path . 'chrome.exe" ' . url
" endfun
