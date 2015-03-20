" autocmd VimEnter * NERDTree
" autocmd BufEnter * NERDTreeMirror
" First thing first: pathogen to load everything
call pathogen#infect()


" Utility functions

function! DoAndComeBack(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! ToggleCopy()
    if (&number)
        set nonumber
        set nolist
        set showbreak=
    else
        set number
        set list
        set showbreak=↪
    endif
endfunction

function! CompleteOrTab()
    if (strpart(getline('.'),col('.')-2,1)!~'\w')
        return "\<tab>"
    else
        return "\<c-n>"
    endif
endfunction

" set vim scroll faster
set ttyfast
set lazyredraw
set scrolljump=10

"" Functional options

" Unicode FTW
set fileencodings=utf8

" File type detection should have been on my default
filetype plugin indent on

" Some systems don't turn on syntax by default
syntax on
nnoremap <leader>sf :syntax off<cr>
nnoremap <leader>ss :syntax on<cr>

" To have list of options instead of one default
set wildmenu
set wildmode=longest,full

" Search as I type
set incsearch

" Case insensitive for searching
set ignorecase
" But allow for case sensitive when I seem to mean it
set smartcase

" Line numbers are good
set number

" Remove any trailing whitespace that is in the file
autocmd BufWrite * if ! &bin | call DoAndComeBack("%s/\\s\\+$//e") | endif

" I don't mean Make, I mean Mako
autocmd BufNewFile,BufRead *.mak  set filetype=html
" JSON syntax highlighting for free
autocmd BufNewFile,BufRead *.json set filetype=javascript

" Enable mouse support in console
set mouse=a

" Keep cursor in the middle of screen
set scrolloff=99

" Use + to copy to clipboard
" let g:clipbrdDefaultReg = '+'
" copy paste directly to clipboard
" set clipboard=unnamedplus
" Map ctrl+c ctrl+v to copy from clipboard
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <C-r><C-o>+

" Spaces no tabs
set expandtab
"set tabstop=4
"set shiftwidth=4
" Switch to 2  for ruby on rails projects
set tabstop=2
set shiftwidth=2

" Always show file info
set laststatus=2

" Show title
set title

" Lemme know what I'm doing
set showcmd
set report=0

" Be smart and try do indenting right
set autoindent
set smartindent
set preserveindent

" g as default flag for :substitute, make sense!
set gdefault

" Show funny characters!
set list
set listchars=tab:»⋅,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" Fold by indentation, fine for most programming languages
set nofoldenable
set foldmethod=indent
set foldnestmax=1


"" Display options

" We should have as many colors as possible!
set t_Co=256

" Transparent background too
autocmd ColorScheme * highlight Normal  ctermbg=None
autocmd ColorScheme * highlight NonText ctermbg=None

" Have a line indicate the cursor location
set cursorline

" My favorite color scheme, for now
" colorscheme buikhanh
colorscheme xoria256

" set cursorcolumn

" Highlight search results
set hlsearch

" ctrl.vim should use current directory
let g:ctrlp_working_path_mode = 0

" grep ignores binary files
set grepprg=grep\ -HIn\ $*\ /dev/null


"" Key mappings

" Forgot to sudo when opening a file
cnoremap w!! %!sudo tee > /dev/null %

" Remap jj to escape in insert mode.
inoremap jj <esc>

" Ctrl-jklm changes to that split
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Next/previous in quickfix list
" nnoremap <c-n> :cnext<cr>
" nnoremap <c-p> :cprevious<cr>

" Improve up/down movement on wrapped lines
nnoremap j gj
nnoremap k gk

" Search CTRL_P
" nnoremap <c-p> g:ctrlp_map<cr>
set wildignore+=*/tmp/*,*/.git/*,*.so,*.swp,*.zip,*.orig
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)|[\/]images|[\/]icons|[\/]doc|[\/]tmp|[\/]vendor|[\/]framework|[\/]bkt\/assets|[\/]tinymce|[\/]cache|[\/]filemanager|[\/]fancybox2$',
      \ 'file': '\v\.(log|swp|so|zip|orig)$',
      \ 'link': 'some_bad_symbolic_links',
      \ }

" Nerdtree toogle display
nnoremap <c-n> :NERDTreeToggle<CR>
nnoremap <leader>n :NERDTreeFind<cr>

" Show buffer file. Recently using
nnoremap <c-b> :ls<cr>

nnoremap <leader>s :!<cr>

" Let nerdtree show hidden files
let NERDTreeShowHidden=1

" Temporarily disable search highlight
nnoremap <leader>h :nohlsearch<cr>

" * only highlight, not move
nnoremap * :set hlsearch<cr>:let @/="\\<".expand("<cword>")."\\>"<cr>

" Quick paste toggle
nnoremap <leader>p :set paste!<cr>
" Automatically disable paste mode
au InsertLeave * set nopaste

" Quick fold toggle
" nnoremap <space> za

" For easy copying
nnoremap <leader>c :call ToggleCopy()<cr>

" Smart tab completion
inoremap <tab> <c-r>=CompleteOrTab()<cr>

" create new tab not in Nerdtree
nnoremap <Leader>t :tab new<cr>

" adjust windows width  Leader increate | Leader decreate
nnoremap <Leader>1 :vertical resize +20<cr>
nnoremap <Leader>2 :vertical resize -20<cr>

" search with ack
let g:path_to_search_app = "/usr/bin/X11/ack-grep"

" ------------------------- Rspec config --------------------------
noremap <Leader>rs :call RunSpec('spec', '-fp')<CR>
noremap <Leader>rd :call RunSpec(expand('%:h'), '-fd')<CR>
noremap <Leader>rf :call RunSpec(expand('%'), '-fd')<CR>
noremap <Leader>rl :call RunSpec(expand('%'), '-fd -l ' . line('.'))<CR>

function! RunSpec(spec_path, spec_opts)
  let speccish = match(@%, '_spec.rb$') != -1
  if speccish
    exec '!clear & bundle exec rspec ' . a:spec_opts . ' ' . a:spec_path
  else
    echo '<< WARNING >> RunSpec() can only be called from inside spec files!'
  endif
endfunction
" ------------------------ end Rspec config-----------------------

" indent line config
let g:indentLine_color_term = 239
