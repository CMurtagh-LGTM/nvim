if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au!
    au BufRead,BufNewFile *.mdx setfiletype markdown
    au BufRead,BufNewFile *.g,*.gi,*.gd set filetype=gap comments=s:##\ \ ,m:##\ \ ,e:##\ \ b:#
augroup END
