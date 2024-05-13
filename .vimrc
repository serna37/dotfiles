let mapleader = "\<Space>"

call plug#begin()

" AI Copilot
Plug 'Exafunction/codeium.vim'

" Enhanced vim motion
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'serna37/edgemotion-vertical'
Plug 'rhysd/clever-f.vim'
Plug 'unblevable/quick-scope'
Plug 'serna37/vim-fscope-around'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'yuttie/comfortable-motion.vim'
Plug 'simeji/winresizer'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'voldikss/vim-floaterm'

" Enhanced Visualization
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'rafi/awesome-vim-colorschemes'

" Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Git
"Plug 'tpope/vim-fugitive'
"Plug 'airblade/vim-gitgutter'
" [Note] Too heavy with clangd LSP, snippet stop.

" Reading
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'
Plug 'liuchengxu/vista.vim'
Plug 'wfxr/minimap.vim'

" Writing
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" LSP IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
Plug 'serna37/vim-IDE-menu'
Plug 'rhysd/wandbox-vim'

" Util
Plug 'segeljakt/vim-silicon'
Plug 'glidenote/memolist.vim'
Plug 'nanotee/zoxide.vim'
Plug 'soywod/unfog.vim'
Plug 'serna37/vim-tutorial'
"Plug 'serna37/vim-atcoder-menu'

call plug#end()

" Pluginの追加設定
source ~/git/dotfiles/conf/vim/plugconf.vim
" カスタム設定
source ~/git/dotfiles/conf/vim/custom.vim
" C++用設定
source ~/git/dotfiles/conf/cpp/.vimrc.cpp

