let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%](%severity%) %s'
let g:ale_lint_delay = 500
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_cpp_ccls_init_options = {
            \ 'cache': {
            \    'directory': '/tmp/ccls-cache'
            \ },
            \ 'index': {
            \     'threads': 2,
            \     'comments': 0
            \ }
            \ }
let g:ale_completion_enabled = 0
let g:ale_linters_ignore = ['ccls']
