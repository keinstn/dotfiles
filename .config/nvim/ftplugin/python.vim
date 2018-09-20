""" General


""" Plugins

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
