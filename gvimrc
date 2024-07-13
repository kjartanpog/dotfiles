" let g:disable_bg = 0
" set guifont=SauceCodePro\ Nerd\ Font\ Mono:h12
set guifont=SauceCodePro\ Nerd\ Font\ Mono\ 13

" Visual bell instead of audio
set vb

noremap <Leader>+ :let &guifont=substitute(&guifont, '\(\d\+\)', '\=submatch(1)+1', '')<cr>
noremap <Leader>- :let &guifont=substitute(&guifont, '\(\d\+\)', '\=submatch(1)-1', '')<cr>

" See :h 'go'
" Disable GUI tool bar
set guioptions -=T
" Disable GUI menu bar
" set guioptions -=m
" Disable GUI tab bar
set guioptions -=e

set guioptions -=l
set guioptions -=L
set guioptions -=r
set guioptions -=R

" nnoremap <leader>m :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
" nnoremap <leader>T :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
" set guioptions +=k " Keep the GUI window size when adding/removing a scrollbar

" Set paste keymap in terminal (insert) mode
" tmap <C-S-v> <C-W>"+
" Set paste keymap in insert & command mode
" noremap! <C-S-v> <C-r>+

" Right mouse button pops up a menu. The shifted left mouse button extends a selection. This works like with Microsoft Windows.
set mousemodel=popup

" set lines=40 columns=170

" Completely black background for OLED monitors
if $OLED==1
    hi Normal guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi NormalNC guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi SignColumn guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi StatusLineNC guifg=#6e6a86 guibg=#000000 gui=NONE cterm=NONE
    " hi Menu guifg=#1F1D2E guibg=#000000
    " hi Menu guifg=#e0def4 guibg=#000000
    " hi Menu guibg=#000000
endif
