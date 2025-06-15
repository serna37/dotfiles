" プラグイン未インストール状態でも表示を改善するために設定
syntax on | set number laststatus=2 showtabline=2 incsearch hlsearch ignorecase smartcase shortmess-=S

" leaderキー
let mapleader = "\<Space>"

" visualモード中のヘルプ表示が往々にして邪魔なので消す
vnoremap <S-k> <Nop>

" バッファ移動
fu! s:move_buffer(flg) abort
    let current_id = ''
    let buf_arr = []
    for v in split(execute('ls'), '\n')->map({ _,v -> split(v, ' ')})
        let x = copy(v)->filter({ _,v -> !empty(v) })
        if stridx(x[1], 'F') == -1 && stridx(x[1], 'R') == -1
            cal add(buf_arr, x[0])
            if stridx(x[1], '%') != -1
                let current_id = x[0]
            endif
        endif
    endfor
    let buf_idx = a:flg == 'next' ? match(buf_arr, current_id) + 1 : match(buf_arr, current_id) - 1
    let buf_id = buf_idx == len(buf_arr) ? buf_arr[0] : buf_arr[buf_idx]
    exe 'b '.buf_id
endf
fu! s:close_buffer() abort
    let now_b = bufnr('%')
    cal s:move_buffer('prev')
    execute('bd ' . now_b)
endf
nnoremap <silent><C-n> :<C-u>cal <SID>move_buffer('prev')<CR>
nnoremap <silent><C-p> :<C-u>cal <SID>move_buffer('next')<CR>
nnoremap <silent><Leader>x :<C-u>cal <SID>close_buffer()<CR>

" 行のどこにいても、行末に{を入力、行末に移動
inoremap {{ <Esc>A{}<Left>

" 行のどこにいても、行末にセミコロンを、なければ入れる
fu! s:tail_semi() abort
    if getline('.')[-1:] != ';' | execute('normal A;') | endif
endf
inoremap ;; <Esc>:<C-u>cal <SID>tail_semi()<CR>
inoremap ;<CR> <Esc>:<C-u>cal <SID>tail_semi()<CR>o

" フォルダ内grep
fu! s:vimgrep() abort
    let w = input('vimgrep [word]>>', expand('<cword>'))
    if w == '' | echo "cancel!!" | return | endif
    let dir = 'vimgrep /'.w.'/gj * | cw'
    let git = 'vimgrep /'.w.'/gj `{ git ls-files; git ls-files -o --exclude-standard; }` | cw'
    let cmd = system('git rev-parse --is-inside-work-tree') =~ 'fatal' ? dir : git
    execute(cmd)
    cal popup_notification(["C-mで次のQuickfix"], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>g :<C-u>cal <SID>vimgrep()<CR>

" 現在フォルダをgrep
fu! s:vimgrep_current() abort
    let w = input('vimgrep currentfile [word]>>', expand('<cword>'))
    if w == '' | echo "cancel!!" | return | endif
    let cmd = 'vimgrep /'.w.'/gj % | cw'
    execute(cmd)
    cal popup_notification(["C-mで次のQuickfix"], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>G :<C-u>cal <SID>vimgrep_current()<CR>

" 次のQuickfix行
nnoremap <C-m> :cn<CR>


" Plugin管理
" =====================================================================
call plug#begin()

" 通常vimモーションの強化系
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'rhysd/clever-f.vim'
Plug 'unblevable/quick-scope'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'yuttie/comfortable-motion.vim'
Plug 'simeji/winresizer'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'voldikss/vim-floaterm'

" 外観
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'liuchengxu/vim-which-key'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'tomasiser/vim-code-dark'

" ファイラ / エクスプローラ
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" 視覚補助 可読性の強化
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'

" 入力補完強化
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'bronson/vim-trailing-whitespace'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'thinca/vim-partedit'

" LSP IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector'

" その他
" Copilot
Plug 'Exafunction/codeium.vim'
" メモリスト
Plug 'glidenote/memolist.vim'

call plug#end()
" =====================================================================

source ~/git/dotfiles/conf/vim/.vimrc.plug_conf
source ~/git/dotfiles/conf/vim/.vimrc.cpp


