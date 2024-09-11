" Disable vi-compatible defaults
set nocompatible
" Don't display a warning when moving away from a modified buffer with unsaved changes
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

" let g:netrw_liststyle = 3
" Show again by pressing I
let g:netrw_banner = 0
" Set the default width of a netrw to 20% of window size
let g:netrw_winsize = 20
" Pressing <cr> will open the file in the previous window
let g:netrw_browse_split = 4

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

    if (executable('R'))
        au User lsp_setup call lsp#register_server({
        \ 'name': 'r',
        \ 'cmd': {server_info->['R', '--slave', '-e', 'languageserver::run()']},
        \ 'allowlist': ['r'],
        \ })
    endif


    " if executable('nil')
    "     autocmd User lsp_setup call lsp#register_server({
    "         \ 'name': 'nil',
    "         \ 'cmd': {server_info->['nil']},
    "         \ 'whitelist': ['nix'],
    "         \ })
    " endif
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

" Create a new file if it doesn't already exist while using the gf command.
nnoremap <silent> gf :call <sid>open_file_or_create_new()<CR>

" Read more in practical vim
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" VISUAL REPRESENTATION of the number of spaces that a <Tab> counts for

" Set SPACE as leader key
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" Copy to system clipboard mappings
noremap <Leader>y "+y
noremap <Leader>d "+d
noremap <Leader>p "+p

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
noremap <Leader>e :Lexplore! %:h<CR>
noremap <Leader>hi :LspHover<cr>
nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
nnoremap <buffer> <expr><c-k> lsp#scroll(-4)

" Map open terminal buffer
nmap <C-w>t :terminal<CR>

" Toggle floatterm
nnoremap   <silent>   <C-w>f   :FloatermToggle<CR>
tnoremap   <silent>   <C-w>f   <C-\><C-n>:FloatermToggle<CR>

" vim-slime
let g:slime_target = "vimterminal"
autocmd FileType r let b:slime_vimterminal_cmd='R'

" vimwiki
let g:vimwiki_list = [{
\ 'path': '~/Notes/',
\ 'name': 'Personal Notes',
\ 'syntax': 'markdown',
\ 'ext': '.md'
\}]

set foldcolumn=1

set foldmethod=expr
set foldexpr=lsp#ui#vim#folding#foldexpr()
set foldtext=lsp#ui#vim#folding#foldtext()

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

" Show (partial) command in the last line of the screen.
set showcmd

set statusline=%f\ %h%w%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=\ %{&paste?'󰅌':'󱘛'}

" Always show statusline
set laststatus=2

" Reference chart of values:
"
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinding underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).

" cursor normally visible (no blink)
let &t_VS = "\e[2 q"
" start insert mode (bar cursor shape)
let &t_SI = "\e[5 q"
" start replace mode (underline cursor shape)
let &t_SR = "\e[3 q"
" end insert or replace mode (block cursor shape)
let &t_EI = "\e[2 q"

set termguicolors

function! RosePineBlack()
    colorscheme rosepine
    hi Normal guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi NormalNC guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi SignColumn guifg=#e0def4 guibg=#000000 gui=NONE cterm=NONE
    hi StatusLineNC guifg=#6e6a86 guibg=#000000 gui=NONE cterm=NONE
    hi GitGutterAdd    guifg=#9ccfd8 guibg=#000000 gui=NONE cterm=NONE
    hi GitGutterChange guifg=#ebbcba guibg=#000000 gui=NONE cterm=NONE
    hi GitGutterDelete guifg=#eb6f92 guibg=#000000 gui=NONE cterm=NONE
endfunction

function! s:goyo_enter()
    set scrolloff=999
    set noshowmode
    set noshowcmd
    set nocursorline
    set Limelight
endfunction

function! s:goyo_leave()
    call RosePineBlack()
    set scrolloff=1
    set showmode
    set showcmd
    set Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
