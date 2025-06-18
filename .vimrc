" 共通
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark title showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smartindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview,popup incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1 | let &titleold=getcwd() | syntax on | filetype plugin on | au QuickFixCmdPost *grep* cwindow


" 編集
inoremap <C-l> <right>
inoremap <C-h> <left>
vnoremap <C-j> "zx"zp`[V`]
vnoremap <C-k> "zx<Up>"zP`[V`]
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ` ``<left>
inoremap ' ''<left>
inoremap " ""<left>
inoremap <expr>) getline('.')[col('.')-1] == ")" ? "\<right>" : ")"
inoremap <expr>] getline('.')[col('.')-1] == "]" ? "\<right>" : "]"
inoremap <expr>} getline('.')[col('.')-1] == "}" ? "\<right>" : "}"
inoremap <expr><BS> match(["()", "[]", "{}", "``","''", '""'], getline('.')[col('.')-2:col('.')-1]) >=0 ? "\<right>\<BS>\<BS>" : "\<BS>"
nnoremap vv ^v$h
au TextYankPost * cal s:hl_yank()
fu! s:hl_yank() abort
    let t = join(v:event.regcontents, "\n")
    if v:event.operator !=# 'y' || v:event.regtype !=# 'v' || len(v:event.regcontents) != 1 | retu | endif
    let word = v:event.regcontents[0]
    let id = matchaddpos('IncSearch', [[line('.'), match(getline('.'), escape(word, '\')) + 1, strlen(word)]])
    cal timer_start(300, {-> matchdelete(id)})
endf


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
    let tid = timer_start(a:delta, { -> feedkeys(a:vector == 0 ? "\<C-y>" : "\<C-e>") }, {'repeat': -1})
    cal timer_start(600, { -> timer_stop(tid) })
endf
nnoremap <silent><C-n> :<C-u>bp<CR>
nnoremap <silent><C-p> :<C-u>bn<CR>
nnoremap <silent><Space>x :<C-u>bd<CR>
au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") | exe "norm g`\"" | endif
au ColorScheme * hi WordStart cterm=bold
au CursorMoved,CursorMovedI * cal <SID>hl_scope()
fu! s:hl_scope()
    if exists('w:fscope') && w:fscope != -1 | sil! cal matchdelete(w:fscope) | let w:fscope = -1 | endif
    let w:fscope = matchadd('WordStart', '\%' . line('.') . 'l\(\<\w\)', 99)
endf
nnoremap <silent>f :<C-u>cal <SID>fmode(1)<CR>
nnoremap <silent>F :<C-u>cal <SID>fmode(0)<CR>
au ColorScheme * hi FChar ctermfg=155 cterm=bold,underline
fu! s:fmode(vec)
    if !exists('w:fmode') || w:fmode == 0 | let w:fmode = 1 | let w:char = nr2char(getchar()) | endif
    if exists('w:fmatch') && w:fmatch != -1 | sil! cal matchdelete(w:fmatch) | let w:fmatch = -1 | endif
    let w:fmatch = matchadd('FChar', '\%' . line('.') . 'l' . w:char, 100)
    exe "normal! ".(a:vec == 1 ? "f" : "F").w:char
    if exists('s:fid') && s:fid != -1 | call timer_stop(s:fid) | endif
    let s:fid = timer_start(1000, { -> execute("let w:fmode = 0 | sil! cal matchdelete(w:fmatch)") })
endf


" 検索
nnoremap # *N
au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=153
nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>exe "vim /".expand("<cword>")."/gj ".(system('git status')=~'fatal'?'** **/.':join(split(system('git ls-files'))))<CR>:echo "Quickfix移動:cn cp"<CR>
nnoremap <silent>cn :<C-u>cn<CR>
nnoremap <silent>cp :<C-u>cp<CR>
nnoremap <silent><Space>e :<C-u>cal <SID>toggle_netrw()<CR>
fu! s:toggle_netrw()
    let winids = getwininfo()->filter("has_key(v:val.variables, 'netrw_liststyle')")->map('v:val.winid')
    if empty(winids) | exe 'topleft vertical 30new | Explore'
    else | for id in winids | sil! cal win_execute(id, 'close') | endfor
    endif
endf
au FileType netrw nnoremap <buffer>o :<C-u>cal <SID>netrw_open()<CR>
fu! s:netrw_open() abort
    let filepath = fnamemodify(getline('.'), ':p')
    if isdirectory(filepath) | exe 'Explore '.fnameescape(filepath)
    else
        if winnr() < winnr('$') | exe 'wincmd l'
        else | exe 'rightbelow vs' | exe 'vertical resize '.(&columns - 30)
        endif
        exe 'e '.fnameescape(filepath)
    endif
endf
" TODO ファイラほしい fzf的なの
nnoremap <silent><Space>f :<C-u>cal <SID>fzf()<CR>
let s:enter_wd = []
let s:enter_id = -1
let s:list_id = -1
let s:files = []
fu! s:fzf()
    let s:files = system(system('git status')=~'fatal' ? "find . -type f" : "git ls-files")->split('\n')
    let list_id = popup_create(s:files[0:30], #{title: "result", zindex: 99})
    let s:enter_id = popup_create('>>', #{zindex: 100, line: &lines, col: &columns*-1, mapping: 0, filter: function('s:fzf_filter')})
    cal win_execute(s:enter_id, "mapclear <buffer>") | echo ''
    "cal popup_setoptions(s:enter_id, #{zindex: 100})
    "cal popup_setoptions(list_id, #{zindex: 99})
endf
fu! s:fzf_filter(winid, key)
    if a:key == "\<CR>"
        cal popup_close(s:enter_id)
        retu 1
    endif
    if a:key == "\<BS>" && !empty(s:enter_wd)
        cal remove(s:enter_wd, -1)
    elseif a:key == "\<C-w>"
        let s:enter_wd = []
    else
        cal add(s:enter_wd, a:key)
    endif
    let res = empty(s:enter_wd) ? s:files : matchfuzzy(s:files, join(s:enter_wd, ''))[0:30]
    cal popup_settext(s:enter_id, '>>'.join(s:enter_wd, ''))
    call popup_settext(s:list_id, join(res, ""))
    " TODO 絞ったリストの描画更新
    " TODO リストから選択する
    retu 1
endf


" ターミナル
set termwinkey=<C-e>
nnoremap <silent><Space>t :<C-u>rightbelow vertical terminal ++cols=60<CR>
tnoremap <silent><C-n> <C-e>N


" 外観
au ColorScheme * hi User1 cterm=bold ctermfg=7 ctermbg=4
au ColorScheme * hi User2 cterm=bold ctermfg=2 ctermbg=0
au ColorScheme * hi User3 cterm=bold ctermfg=0 ctermbg=5
au ColorScheme * hi User4 cterm=bold ctermfg=7 ctermbg=56
au ColorScheme * hi User5 cterm=bold ctermfg=7 ctermbg=5
let ff_table = {'dos' : 'CRLF', 'unix' : 'LF', 'mac' : 'CR'}
fu! SetStatusLine()
    let dict = {'i': '1* INSERT', 'n': '2* NORMAL', 'R': '3* REPLACE', 'c': '4* COMMAND', 't': '4* TERMIAL', 'v': '5* VISUAL', 'V': '5* VISUAL', "\<C-v>": '5* VISUAL'}
    let mode = match(keys(dict), mode()) != -1 ? dict[mode()] : '5* SP'
    retu '%' . mode . ' %* %<%F%m%r%h%w%=%2* %p%% %l/%L %02v | %{&filetype} | %{&fenc!=""?&fenc:&enc} | %{ff_table[&ff]} %*'
endf
set statusline=%!SetStatusLine()
fu! SetTabLine()
    let s=''
    let c=bufnr('%')
    for b in range(1,bufnr('$'))
        if bufexists(b)&&buflisted(b)
            let n=bufname(b)
            let n=empty(n)?'[No Name]':fnamemodify(n,':t')
            let modified = getbufvar(b, '&modified') ? '*' : ''
            let s.=(b==c?'%#TabLineSel#':'%#TabLine#').'%'.b.'T '.n.modified.' '
        endif
    endfor
    retu s.'%#TabLineFill#'
endf
set tabline=%!SetTabLine()
au ColorScheme * hi Comment term=bold ctermfg=245
au ColorScheme * hi Normal ctermbg=none
au ColorScheme * hi LineNr ctermfg=245
au ColorScheme * hi Visual ctermbg=240
colorscheme habamax



" 高機能(プラグイン) vim-plug導入コマンド
"curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall"
call plug#begin()
"Plug 'joshdick/onedark.vim'
"Plug 'sheerun/vim-polyglot'
" TODO けしたい
"Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
" TODO けしたい
"Plug 'junegunn/fzf.vim'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'puremourning/vimspector'
"Plug 'Exafunction/codeium.vim'
call plug#end()
"if !glob('~/.vim/plugged/onedark.vim')->empty() | colorscheme onedark | endif
"let g:coc_global_extensions = ['coc-snippets', 'coc-explorer',
"            \ 'coc-vimlsp', 'coc-sh', 'coc-json',
"            \ 'coc-sql', 'coc-html', 'coc-css', 'coc-tsserver',
"            \ 'coc-clangd', 'coc-pyright',
"            \ 'coc-rust-analyzer', 'coc-go', 'coc-java',
"            \ ]
"nnoremap <silent><Space>d <Plug>(coc-definition)
"nnoremap <silent><Space>r :CocCommand fzf-preview.CocReferences<CR>
"nnoremap <silent><Space>r <Plug>(coc-references)
"nnoremap <silent><Space>R <Plug>(coc-rename)
"nnoremap <silent><Space>F :<C-u>cal CocActionAsync('format')<CR>
"nnoremap <silent><Space>, <Plug>(coc-diagnostic-next)
"nnoremap <silent><Space>. <Plug>(coc-diagnostic-prev)
"nnoremap <silent><Space>? :cal CocAction('doHover')<CR>
"nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : <C-d>
"nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : <C-u>
"nnoremap <silent><Space>l :<C-u>w<CR>:e!<CR>:echo 'Reload Buffer'<CR><Esc>
"let g:vimspector_base_dir=$HOME.'/.vim/plugged/vimspector'
"let g:vimspector_sign_priority = {
"            \'vimspectorBP':          99,
"            \'vimspectorBPCond':      99,
"            \'vimspectorBPLog':       99,
"            \'vimspectorBPDisabled':  99,
"            \'vimspectorNonActivePC': 99,
"            \'vimspectorPC':          999,
"            \'vimspectorPCBP':        999,
"            \ }
" ブレークポイント
"nnoremap <F9> <Plug>VimspectorToggleBreakpoint
"nnoremap <S-F9> :<C-u>cal vimspector#ClearBreakpoints()<CR>
" デバッグ開始 / 次のブレークポイントまで進む
"nnoremap <F5> <Plug>VimspectorContinue
" デバッグモード終了
"nnoremap <S-F5> :VimspectorReset<CR>
" 再度、あたまからデバッグ
"nnoremap <F4> <Plug>VimspectorRestart
" ステップオーバー
"nnoremap <F10> <Plug>VimspectorStepOver
" ステップイン / ステップアウト
"nnoremap <F11> <Plug>VimspectorStepInto
"nnoremap <S-F11> <Plug>VimspectorStepOut
" カーソルの変数を監視登録
"nnoremap <F3> :cal execute('VimspectorWatch '.expand('<cword>'))<CR>
" カーソルの変数の値を表示
"nnoremap <Space>_ <Plug>VimspectorBalloonEval

" codium認証のために以下URLへのアクセス
"https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
"let g:codeium_disable_bindings = 1
"inoremap <silent><C-n> <Cmd>cal codeium#CycleCompletions(1)<CR>
"inoremap <silent><C-p> <Cmd>cal codeium#CycleCompletions(-1)<CR>
"inoremap <script><silent><nowait><expr><C-i> codeium#Accept()





