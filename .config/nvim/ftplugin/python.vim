""" General
setlocal tabstop=4
setlocal shiftwidth=4

""" Plugins

" vim indent guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" ale
let b:ale_linters = ['flask8']
let b:ale_fixers = ['autopep8']

" vim lsp
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
endif
