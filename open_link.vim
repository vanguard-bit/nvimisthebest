fun! Open_link()
    let keyword = getline(".")
    " let url = "http://www.google.com/search?q=" . keyword
    let path = "C:\\Program Files\\Google\\Chrome\\Application\\"
    exec '!"' . path . 'chrome.exe" ' . keyword
endfun
