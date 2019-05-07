let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%](%severity%) %s'
let g:ale_lint_delay = 500
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0
let g:ale_linters_ignore = ['ccls']

call AddKeyBinding('nnoremap [a :ALEPreviousWrap<CR>', 'Jump to previous lint error')
call AddKeyBinding('nnoremap ]a :ALENextWrap<CR>', 'Jump to next lint error')
call AddKeyBinding('nnoremap <leader>ad :ALEDetail<CR>', 'Show all lint details')
