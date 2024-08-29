" SETTINGS {{{

" Disable vi-compatible defaults
set nocompatible
" Don't display a warning when moving away from a modified buffer with unsaved
" changes
set hidden

set winminheight=0

" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=1

" Disable the default octal number interpretation when incrementing numbers
" with leading zeros
set nrformats=

" More sensible scrolling over wrapped text
" set smoothcroll

set ignorecase
" Applies case insensitive search for lowercase input
set smartcase
" Highlight matching search patterns
set hlsearch
" Show pattern while typing a search command
set incsearch

set wildignore=*.swp

set splitright
set splitbelow

" Wrap overextending text to the proceeding line
set wrap
" Always show signcolumn
set signcolumn=yes

" Activate List mode
set list

" When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set autoread

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

set tabstop=4 "READ :h 'tabstop' for effective tab setup configurations
set shiftwidth=4
" Insert number of spaces equal to 'tabstop' instead of <Tab>
set expandtab
set smarttab
" set softtabstop
" Enable backspace deletion of specified whitespace characters while in INSERT mode.
set backspace=indent,eol,nostop

" let g:netrw_liststyle = 3
" Show again by pressing I
let g:netrw_banner = 0

filetype on
filetype plugin on
filetype indent on

set history=200

set noswapfile

set showmatch

set path+=**
set wildmenu
" More Bash like tab completions
set wildmode=longest:full,full
" Nice vertical list window with fuzzy find
set wildoptions+=fuzzy
set wildoptions+=pum

" }}}

" LSP {{{

if version >= 824
    " Enable native lsp client support for vim 8.2.4780+
    let g:lsp_use_native_client = 1
    let g:lsp_semantic_enabled = 0
    let g:lsp_format_sync_timeout = 1000
    " Enables a floating window of diagnostic error for the current line
    let g:lsp_diagnostics_float_cursor = 1
    " Enables echo of diagnostic error for the current line to status
    let g:lsp_diagnostics_echo_cursor = 0
    " Enables virtual text to be shown next to diagnostic errors
    let g:lsp_diagnostics_virtual_text_enabled = 0

    if (executable('nixd'))
        au User lsp_setup call lsp#register_server({
            \ 'name': 'nixd',
            \ 'cmd': {server_info->['nixd']},
            \ 'allowlist': ['nix'],
            \ 'workspace_config': {
                \ 'nixpkgs': { 'expr': 'import (builtins.getFlake \"/home/kjartanm/flake.nix\").inputs.nixpkgs { }' },
                \ 'options': {
                    \ 'nixos': { 'expr': '(builtins.getFlake \"/home/kjartanm/flake.nix\").nixosConfigurations.T14.options' },
                    \ 'home-manager': { 'expr': '(builtins.getFlake \"/home/kjartanm/flake.nix\").homeConfigurations.\"kjartanm@T14\".options' }
                \ }
            \ }
        \ })
    endif

    function! s:on_lsp_buffer_enabled() abort
        setlocal omnifunc=lsp#complete
        setlocal signcolumn=yes
        nmap <buffer> gd <plug>(lsp-definition)
        nmap <buffer> <f2> <plug>(lsp-rename)
    endfunction

    augroup lsp_install
        au!
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
endif

" }}};

" MAPPINGS {{{

" Create a new file if it doesn't already exist while using the gf command.
nnoremap <silent> gf :call <sid>open_file_or_create_new()<CR>

nmap æ [
nmap ð ]
omap æ [
omap ð ]
xmap æ [
xmap ð ]

" Read more in practical vim
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" VISUAL REPRESENTATION of the number of spaces that a <Tab> counts for

" Set SPACE as leader key
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" Copy to system clipboard mappings
" noremap <Leader>y "+y
" noremap <Leader>d "+d
" noremap <Leader>p "+p
" noremap <C-S-v> "+p
" inoremap <C-S-v> <Esc>"+pi

setglobal pastetoggle=<F2>

noremap <Leader>fb :Buffers<CR>
noremap <Leader>ff :Files<CR>
noremap <Leader>sff :split<CR>:Files<CR>
noremap <Leader>fm :Marks<CR>
noremap <Leader>ft :Tags<CR>
noremap <Leader>fh :Helptags<CR>
noremap <leader>fc :Commands<CR>
noremap <Leader>bb :Buffers<CR>
noremap <Leader>bt :BTags<CR>
noremap <Leader>bf :BLines<CR>
noremap <Leader>tt :tab term<CR>
noremap <Leader>go :Goyo<CR>
noremap <Leader>ga :Git add %<CR>
noremap <Leader>gc :Git commit<CR>
noremap <Leader>gp :Git push<CR>
" }}}

" PLUGINS {{{

" vim-slime
let g:slime_target = "vimterminal"

" vimwiki
let g:vimwiki_list = [{
\ 'path': '~/Notes/',
\ 'name': 'Personal Notes',
\ 'syntax': 'markdown',
\ 'ext': '.md'
\}]

" }}}

" FOLDING {{{

set foldcolumn=1

" Auto enable code folding for vim configuration files using the marker method
" of folding (h fold-marker)
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal omnifunc=syntaxcomplete#Complete
augroup END

" }}}

" VIMSCRIPT {{{

" Control how certain whitepsace characters will get displayed in the editor
set listchars=tab:>\ ,extends:>,precedes:<,trail:~
" How trailing whitespace characters are displayed when NOT in INSERT mode
autocmd InsertEnter * set listchars-=trail:~
autocmd InsertLeave * set listchars+=trail:~

" Open file under cursor, or create a new if one if doesn't exits.
function! s:open_file_or_create_new() abort
  let l:path = expand('<cfile>')
  if empty(l:path)
    return
  endif

  try
    exe 'norm!gf'
  catch /.*/
    echo 'New file.'
    let l:new_path = fnamemodify(expand('%:p:h') . '/' . l:path, ':p')
    if !empty(fnamemodify(l:new_path, ':e')) "Edit immediately if file has extension
      return execute('edit '.l:new_path)
    endif

    let l:suffixes = split(&suffixesadd, ',')

    for l:suffix in l:suffixes
      if filereadable(l:new_path.l:suffix)
        return execute('edit '.l:new_path.l:suffix)
      endif
    endfor

    return execute('edit '.l:new_path.l:suffixes[0])
  endtry
endfunction

set number
set cursorline
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | set cursorline   | endif
:  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | set nocursorline | endif
:augroup END

" }}}

" STATUS LINE & LAST LINE {{{

" Show (partial) command in the last line of the screen.
set showcmd

set statusline=%f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=\ %{&paste?'󰅌':'󱘛'}

" Always show statusline
set laststatus=2


" }}}

" CURSOR {{{

" Change cursor shape based off the current mode.
"
" Reference chart of values:
"
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinding underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
"
" cursor normally visible (no blink)
let &t_VS = "\e[2 q"
" start insert mode (bar cursor shape)
let &t_SI = "\e[5 q"
" start replace mode (underline cursor shape)
let &t_SR = "\e[3 q"
" end insert or replace mode (block cursor shape)
let &t_EI = "\e[2 q"

" }}}

" RETIRED / SAVED FOR LATER {{{

" When on, Vim will change the current working directory whenever you change the directory of the shell running in a terminal window.
" set autoshelldir

"Write the contents of the file, if it has been modified, on each
" set autowrite

" set ruler

" set statusline=
" set statusline+=%{FugitiveStatusline()}    " Current branch and the currently edited file's commit.
" set statusline+=\ 
" set statusline+=%f                         " Path to the file in the buffer, as typed or relative to current directory
" set statusline+=\ 
" set statusline+=%m                         " Modified flag, text is "[+]"; "[-]" if 'modifiable' is off.
" set statusline+=\ 
" set statusline+=\ 
" set statusline+=%y                         " Type of file in the buffer
" set statusline+=\ 
" set statusline+=%{lsp#get_server_status()} " Get the status of a server.
" set statusline+=%=                         " Switch to the right side
" set statusline+=%b                         " Value of character under cursor in hexadecimal
" set statusline+=\ 
" set statusline+=%l                         " Current line
" set statusline+=:                          " Separator
" set statusline+=%v                         " Virtual column number (screen column)
" set statusline+=\|                         " Separator
" set statusline+=%L                         " Total lines
" set statusline+=\ 
" set statusline+=%{&fileencoding?&fileencoding:&encoding}
" set statusline+=\ 

" set statusline+=\ リナックス\ 
" set statusline+=\ 

" let g:lsp_settings = {
" \  'clangd': {'cmd': ['clangd']},
" \  'efm-langserver': {'disabled': v:true}
" \}



" function! s:on_lsp_buffer_enabled() abort
"     setlocal omnifunc=lsp#complete
"     " setlocal signcolumn=yes
"     " if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
"     " nmap <buffer> gd <plug>(lsp-definition)
"     " nmap <buffer> gs <plug>(lsp-document-symbol-search)
"     " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
"     " nmap <buffer> gr <plug>(lsp-references)
"     " nmap <buffer> gi <plug>(lsp-implementation)
"     " nmap <buffer> gt <plug>(lsp-type-definition)
"     " nmap <buffer> <leader>rn <plug>(lsp-rename)
"     " nmap <buffer> [g <plug>(lsp-previous-diagnostic)
"     " nmap <buffer> ]g <plug>(lsp-next-diagnostic)
"     " nmap <buffer> K <plug>(lsp-hover)
"     " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
"     " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
" 
"     " let g:lsp_format_sync_timeout = 1000
"     " autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
" 
"     " refer to doc to add more commands
" endfunction
" 
" augroup lsp_install
"     au!
"     " call s:on_lsp_buffer_enabled only for languages that has the server registered.
"     autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
" augroup END
" 
" 
" " set completefunc=emoji#complete
" set completefunc=vimwiki#emoji#complete
" 
set termguicolors
" " set background=dark
colorscheme rosepine
" let g:colors_name = 'rosepine'
" " let g:disable_bg = 1
" " let g:disable_float_bg = 1
" 
" " Complete blacks for oled monitor
" hi Normal guibg=#000000
" hi NormalNC guibg=#000000
" hi SignColumn guibg=#000000
" hi StatusLine guifg=#e0def4 guibg=#333c48 gui=NONE cterm=NONE
" hi StatusLineTerm guifg=#e0def4 guibg=#31748f gui=NONE cterm=NONE
" hi CursorLineNr guifg=#FFFFFF guibg=NONE gui=NONE cterm=NONE
" hi CursorLine guifg=NONE guibg=NONE gui=NONE cterm=NONE
" 
" function! s:goyo_enter()
"     set noshowmode
"     set noshowcmd
"     set scrolloff=999
"     Limelight
"     " ...
" endfunction
" 
" function! s:goyo_leave()
"     set showmode
"     set showcmd
"     set scrolloff=5
"     Limelight!
"     hi Normal guibg=#000000
"     hi NormalNC guibg=#000000
"     hi SignColumn guibg=#000000
"     hi StatusLine guifg=#e0def4 guibg=#333c48 gui=NONE cterm=NONE
"     hi StatusLineTerm guifg=#e0def4 guibg=#31748f gui=NONE cterm=NONE
"     hi CursorLineNr guifg=#FFFFFF guibg=NONE gui=NONE cterm=NONE
"     hi CursorLine guifg=NONE guibg=NONE gui=NONE cterm=NONE
"     " ...
" endfunction
" 
" autocmd! User GoyoEnter nested call <SID>goyo_enter()
" autocmd! User GoyoLeave nested call <SID>goyo_leave()
" 
" noremap <Leader>gy :Goyo<CR>
" 
" let g:vimwiki_list = [{'path': '~/vimwiki/',
"                           \ 'syntax': 'markdown', 'ext': 'md'}]
" 
" " let g:hlCursorLine = "false"
" 
" " function! Toggle_hlCursorLine()
" "     if &g:hlCursorLine == "false"
" "         set background=dark
" "         set g:hlCursorLine = "false"
" "     else
" "         set background=light
" "     endif
" " endfunction
"
" }}}
