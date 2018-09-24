""" General
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

setlocal completeopt-=preview

""" Plugins

" ale
let b:ale_linters = ['flake8']
let b:ale_fixers = ['autopep8']
