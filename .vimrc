" ############################################################
" #### Base
" ############################################################
" leader
let mapleader = "\<Space>"

" completion with Tab
inoremap <expr><CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr><Tab> pumvisible() ? '<C-n>' : '<C-t>'
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" custom
source ~/git/dotfiles/conf/vim/custom.vim
 
" ############################################################
" #### PLUGINS
" ############################################################
call plug#begin()

" ### AI Copilot
Plug 'Exafunction/codeium.vim'

" ### Enhanced vim motion
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'serna37/edgemotion-vertical'
Plug 'rhysd/clever-f.vim'
Plug 'unblevable/quick-scope'
"Plug 'serna37/vim-fscope-around'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'simeji/winresizer'
Plug 'yuttie/comfortable-motion.vim'
Plug 'voldikss/vim-floaterm'

" ### Enhanced Visualization
Plug 'ryanoasis/vim-devicons'
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'rafi/awesome-vim-colorschemes'

" ### Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" ### Git
"Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter' " <- too heavy with clangd LSP, snippet stop.

" ### Reading
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'
Plug 'liuchengxu/vista.vim'
Plug 'wfxr/minimap.vim'

" ### Writing
"Plug 'SirVer/ultisnips'
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" ### LSP IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
Plug 'serna37/vim-IDE-menu'
Plug 'rhysd/wandbox-vim'

" ### util
Plug 'serna37/vim-tutorial'
Plug 'soywod/unfog.vim'
Plug 'glidenote/memolist.vim'
Plug 'segeljakt/vim-silicon'
Plug 'nanotee/zoxide.vim'
"Plug 'serna37/vim-atcoder-menu'

call plug#end()

source ~/git/dotfiles/conf/vim/plugconf.vim
