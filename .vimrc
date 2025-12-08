" 共通
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1|let &titleold=getcwd()|syntax on|filetype plugin on|au QuickFixCmdPost *grep* cwindow


" vim-plug導入
"curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall
cal plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'matze/vim-move'
Plug 'yuttie/comfortable-motion.vim'
Plug 'rhysd/clever-f.vim'
Plug 'unblevable/quick-scope'
Plug 'haya14busa/vim-asterisk'
Plug 'junegunn/goyo.vim'
Plug 'vim-airline/vim-airline'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Exafunction/codeium.vim'
cal plug#end()


" 最低限の設定
inoremap <C-l> <right>
inoremap <C-h> <left>
nnoremap vv ^v$h
nnoremap j gj
nnoremap k gk
nnoremap <Tab> 5j
nnoremap <S-Tab> 5k
vnoremap <Tab> 5j
vnoremap <S-Tab> 5k
nnoremap <silent><C-n> :<C-u>bp<CR>
nnoremap <silent><C-p> :<C-u>bn<CR>
nnoremap <silent><Space>x :<C-u>bd<CR>
au BufRead * if line("'\"")>0&&line("'\"")<=line("$")|exe "norm g`\""|endif
au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=153
nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>cal <SID>grep()<CR>
fu! s:grep()
    let tmp = input('grep> ', expand("<cword>"))
    exe "vim /".tmp."/gj ".(system('git status')=~'fatal'?'** **/.':join(split(system('git ls-files'))))
    echo "Quickfix移動:cn cp"
endf
nnoremap <silent>cn :<C-u>cn<CR>
nnoremap <silent>cp :<C-u>cp<CR>
set splitbelow termwinkey=<C-e>


" プラグインの設定
nnoremap # <Plug>(asterisk-z*)
nnoremap <silent><Space>z :<C-u>Goyo<CR>
au User GoyoEnter nested cal <SID>goyo_enter()
fu! s:goyo_enter()
    set number
    setlocal statusline=%*\ %<%F%m%r%h%w%=%2*\ %p%%\ %l/%L\ %02v\ %*<CR>
endf
let g:move_key_modifier_visualmode = 'C'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
if !glob('~/.vim/plugged/onedark.vim')->empty()
    aug onedark_comment
        au!
        " コメント色
        au ColorScheme * hi Comment term=bold ctermfg=245 guifg=#5C6370
        " 背景なし
        au ColorScheme * hi Normal ctermbg=none
        " 行番号
        au ColorScheme * hi LineNr ctermfg=245
        au ColorScheme * hi CursorLineNr ctermfg=245
        " カーソル
        au ColorScheme * hi Visual ctermbg=240
    aug END
    colorscheme onedark
endif
let g:coc_global_extensions = [
\ 'coc-explorer',
\ 'coc-fzf-preview',
"\ 'coc-vimlsp',
"\ 'coc-sh',
"\ 'coc-json',
"\ 'coc-sql',
"\ 'coc-html',
"\ 'coc-css',
"\ 'coc-tsserver',
"\ 'coc-clangd',
"\ 'coc-pyright',
"\ 'coc-rust-analyzer',
"\ 'coc-go',
"\ 'coc-java',
\ ]
nnoremap <silent><Space>e :CocCommand explorer --width 30<CR>
nnoremap <silent><Space>f :cal execute('CocCommand fzf-preview.'.(system('git rev-parse --is-inside-work-tree') =~ 'fatal'?'DirectoryFiles':'ProjectFiles'))<CR>
nnoremap <silent><Space>d <Plug>(coc-definition)
nnoremap <silent><Space>r <Plug>(coc-references)
nnoremap <silent><Space>R <Plug>(coc-rename)
nnoremap <silent><Space>F <Plug>(coc-format)
nnoremap <silent><Space>, <Plug>(coc-diagnostic-next)
nnoremap <silent><Space>. <Plug>(coc-diagnostic-prev)
nnoremap <silent><Space>? :cal CocAction('doHover')<CR>
nnoremap <silent><Space>l :<C-u>w<CR>:e!<CR>:echo 'Reload Buffer'<CR><Esc>


" codium認証のために以下URLへのアクセス
"https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
let g:codeium_disable_bindings = 1
inoremap <silent><C-n> <Cmd>call codeium#CycleCompletions(1)<CR>
inoremap <silent><C-p> <Cmd>call codeium#CycleCompletions(-1)<CR>
inoremap <script><silent><nowait><expr><C-i> codeium#Accept()

