
set nocompatible
" ===========
" KEYBINDINGS
" ===========

" Back to normal mode
imap jj <Esc>
tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"


" =========
" BEHAVIOUR
" =========

set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set incsearch
set encoding=utf-8

set undofile            " Use undofile for persistent undo
set undodir=~/.vimundo/ " set a directory to store the undo history
set regexpengine=1      " improve syntaxhighlight performance
set mouse=a



" =====
" LOOKS
" =====

set showcmd
set number
set nowrap
set noshowmode
set cursorline
set scrolloff=10
set signcolumn=yes

" Color configurations
if (has("termguicolors"))
 set termguicolors
endif

let $NVIM_TUI_ENABLE_TRUE_COLOR = 1


highlight CursorLineNR guibg=NONE guifg=NONE
highlight SignColumn guibg=NONE gui=bold


syntax on


" ========
" NERDTREE
" ========

" Nerd Tree settings
let g:nerdtree_tabs_open_on_gui_startup = 0
map <C-n> :NERDTreeToggle<CR>

" Open nerdtree on startup
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" close vim if the only window left open is a NERDTree?
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" ===============
" LEADER COMMANDS
" ===============
"
let mapleader = "\<Space>"
nnoremap <Leader>w :w              <CR>
nnoremap <Leader>q :q!             <CR>
nnoremap <Leader>p :Files          <CR>
nnoremap <Leader>g :GFiles?<CR>
nnoremap <Leader>f :Lines          <CR>
nnoremap <Leader>/ :BLines         <CR>
nnoremap <Leader>b :Buffers        <CR>
nnoremap <Leader>n :NERDTreeToggle <CR>

