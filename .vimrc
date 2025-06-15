" 共通
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark title showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smartindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview,popup incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1 | let &titleold=getcwd() | syntax on | au QuickFixCmdPost *grep* cwindow

" 編集
inoremap <C-l> <right>
inoremap <C-h> <left>
vnoremap <C-j> "zx"zp`[V`]
vnoremap <C-k> "zx<Up>"zP`[V`]
nnoremap vv ^v$h

" 移動
nnoremap j gj
nnoremap k gk
nnoremap <Tab> 5j
nnoremap <S-Tab> 5k
vnoremap <Tab> 5j
vnoremap <S-Tab> 5k
nnoremap <silent><C-u> :<C-u>cal <SID>scroll(0, 25)<CR>
nnoremap <silent><C-d> :<C-u>cal <SID>scroll(1, 25)<CR>
nnoremap <silent><C-b> :<C-u>cal <SID>scroll(0, 15)<CR>
nnoremap <silent><C-f> :<C-u>cal <SID>scroll(1, 15)<CR>
fu! s:scroll(vector, delta)
    let vec = a:vector == 0 ? "\<C-y>" : "\<C-e>"
    let tmp = timer_start(a:delta, { -> feedkeys(vec) }, {'repeat': -1})
    cal timer_start(600, { -> timer_stop(tmp) })
endf
nnoremap <silent><C-n> :<C-u>bp<CR>
nnoremap <silent><C-p> :<C-u>bn<CR>
nnoremap <silent><Space>x :<C-u>bd<CR>
au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "norm g`\"" | endif

" 検索
nnoremap # *N
nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>cal <SID>grep()<CR>
fu! s:grep()
    let w = input('(empty to end) vimgrep currentfile [word]>>', expand('<cword>'))
    if w == '' | echo "grep cancel." | return | endif
    exe 'vimgrep /'.w.'/gj % | cw'
    cal popup_notification(["cnで次のQuickfix"], #{line: &lines/2, col: &columns/3})
endf
nnoremap cn :<C-u>cn<CR>

" ターミナル
set termwinkey=<C-e>
nnoremap <silent><Space>t :<C-u>rightbelow vertical terminal ++cols=60<CR>
tnoremap <silent><C-n> <C-e>N

" vim-plug導入コマンド
"curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall"
call plug#begin()
" 編集
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
" 移動
Plug 'unblevable/quick-scope'
Plug 'rhysd/clever-f.vim'
Plug 'machakann/vim-highlightedyank'
" 外観
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'preservim/vim-indent-guides'
Plug 'airblade/vim-gitgutter'
" 高機能
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector'
Plug 'Exafunction/codeium.vim'
call plug#end()

let mapleader = "\<Space>"
let g:AutoPairsMapCh=0
let g:clever_f_smart_case = 1
let g:airline#extensions#tabline#enabled = 1
au ColorScheme * hi Comment term=bold ctermfg=245
au ColorScheme * hi Normal ctermbg=none
au ColorScheme * hi LineNr ctermfg=245
au ColorScheme * hi Visual ctermbg=240
au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=153
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
au Colorscheme * hi IndentGuidesOdd ctermbg=236
au Colorscheme * hi IndentGuidesEven ctermbg=240
nnoremap <silent><Space>f :exe system('git status')=~'fatal'?'Files':'GitFiles'<CR>
nnoremap <silent><Leader>e :CocCommand explorer --width 30<CR>
let g:coc_global_extensions = ['coc-snippets', 'coc-explorer',
            \ 'coc-vimlsp', 'coc-sh', 'coc-json',
            \ 'coc-sql', 'coc-html', 'coc-css', 'coc-tsserver',
            \ 'coc-clangd', 'coc-pyright',
            \ 'coc-rust-analyzer', 'coc-go', 'coc-java',
            \ ]
nnoremap <silent><Leader>d <Plug>(coc-definition)
nnoremap <silent><Leader>r :CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent><Leader>R <Plug>(coc-rename)
nnoremap <silent><Leader>F :<C-u>cal CocActionAsync('format')<CR>
nnoremap <silent><Leader>, <plug>(coc-diagnostic-next)
nnoremap <silent><Leader>. <plug>(coc-diagnostic-prev)
nnoremap <silent><Leader>? :cal CocAction('doHover')<CR>
"nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : <C-d>
"nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : <C-u>
nnoremap <silent><Leader>l :<C-u>w<CR>:e!<CR>:echo 'Reload Buffer'<CR><Esc>
let g:vimspector_base_dir=$HOME.'/.vim/plugged/vimspector'
let g:vimspector_sign_priority = {
            \'vimspectorBP':          99,
            \'vimspectorBPCond':      99,
            \'vimspectorBPLog':       99,
            \'vimspectorBPDisabled':  99,
            \'vimspectorNonActivePC': 99,
            \'vimspectorPC':          999,
            \'vimspectorPCBP':        999,
            \ }
" ブレークポイント
nnoremap <F9> <Plug>VimspectorToggleBreakpoint
nnoremap <S-F9> :<C-u>cal vimspector#ClearBreakpoints()<CR>
" デバッグ開始 / 次のブレークポイントまで進む
nnoremap <F5> <Plug>VimspectorContinue
" デバッグモード終了
nnoremap <S-F5> :VimspectorReset<CR>
" 再度、あたまからデバッグ
nnoremap <F4> <Plug>VimspectorRestart
" ステップオーバー
nnoremap <F10> <Plug>VimspectorStepOver
" ステップイン / ステップアウト
nnoremap <F11> <Plug>VimspectorStepInto
nnoremap <S-F11> <Plug>VimspectorStepOut
" カーソルの変数を監視登録
nnoremap <F3> :cal execute('VimspectorWatch '.expand('<cword>'))<CR>
" カーソルの変数の値を表示
nnoremap <Leader>_ <Plug>VimspectorBalloonEval

" codium認証のために以下URLへのアクセス
"https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
let g:codeium_disable_bindings = 1
inoremap <silent><C-n> <Cmd>cal codeium#CycleCompletions(1)<CR>
inoremap <silent><C-p> <Cmd>cal codeium#CycleCompletions(-1)<CR>
inoremap <script><silent><nowait><expr><C-i> codeium#Accept()

if !glob('~/.vim/plugged/onedark.vim')->empty() | colorscheme onedark | endif



