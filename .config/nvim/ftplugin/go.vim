""" Plugins

" ale
let b:ale_linters = ['gopls']

autocmd BufWritePre :call LanguageClient#textDocument_formatting_sync()
