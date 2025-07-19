" 共通
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark title showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1 | let &titleold=getcwd() | syntax on | filetype plugin on | au QuickFixCmdPost *grep* cwindow


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
inoremap <expr><BS> (len(getline('.'))>=col('.')&&match(["()", "[]", "{}", "``","''", '""'], getline('.')[col('.')-2:col('.')-1])!=-1)?(col('.')>1?"\<right>\<BS>\<BS>":"\<BS>"):"\<BS>"
nnoremap vv ^v$h
fu! s:autocomplete()
    if pumvisible()|retu|endif
    if strchars((slice(getline('.'),0,charcol('.')-1)..v:char)->substitute('.*[^[:keyword:]]','',''))<2|retu|endif
    cal feedkeys("\<C-n>",'ni')
endf
au InsertCharPre * cal <SID>autocomplete()
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
fu! s:indent()
    if pumvisible()|retu "\<C-y>"|endif
    if getline(".")[col(".")-1]=="}"&&getline(".")[col(".")-2]=="{"
        retu "\<CR>\<CR>\<up>    "
    else|retu "\<CR>"|endif
endf
inoremap <silent><expr><CR> <SID>indent()


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
fu! s:scroll(vector,delta)
    let tid=timer_start(a:delta,{->feedkeys(a:vector?"\<C-e>":"\<C-y>")},{'repeat':-1})
    cal timer_start(600,{->timer_stop(tid)})
endf
nnoremap <silent><C-n> :<C-u>bp<CR>
nnoremap <silent><C-p> :<C-u>bn<CR>
nnoremap <silent><Space>x :<C-u>bd<CR>
au BufRead * if line("'\"")>0&&line("'\"")<=line("$")|exe "norm g`\""|endif
au ColorScheme * hi FC cterm=bold,underline
au CursorMoved,CursorMovedI * if exists('w:f')&&w:f!=-1|sil! cal matchdelete(w:f)|let w:f=-1|endif|let w:f=matchadd('FC','\%'.line('.').'l\(\<\w\)',99)
nnoremap <silent>f :<C-u>cal <SID>fmode(1)<CR>
nnoremap <silent>F :<C-u>cal <SID>fmode(0)<CR>
au ColorScheme * hi FChar ctermfg=155 ctermbg=240 cterm=bold,underline
fu! s:fmode(vector)
    if !exists('w:fmode')||w:fmode==0|let w:fmode=1|let w:char=nr2char(getchar())| endif
    if exists('w:fmatch')&&w:fmatch!=-1|sil! cal matchdelete(w:fmatch)|let w:fmatch=-1|endif
    let w:fmatch=matchadd('FChar','\%'.line('.').'l'.w:char,100)
    exe "normal! ".(a:vector?"f":"F").w:char
    if exists('g:fmode_tid')&&g:fmode_tid!=-1|cal timer_stop(g:fmode_tid)|endif
    let g:fmode_tid=timer_start(1000,{->execute("let w:fmode=0|sil! cal matchdelete(w:fmatch)")})
endf


" 検索
nnoremap # *N
au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=153
nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>exe "vim /".expand("<cword>")."/gj ".(system('git status')=~'fatal'?'** **/.':join(split(system('git ls-files'))))<CR>:echo "Quickfix移動:cn cp"<CR>
nnoremap <silent>cn :<C-u>cn<CR>
nnoremap <silent>cp :<C-u>cp<CR>
au ColorScheme * hi CW ctermfg=none ctermbg=239
fu! s:cursorHi()
    if exists('w:w')&&w:w!=-1|sil! cal matchdelete(w:w)|let w:w=-1|endif
    if exists('g:cw_tid')&&g:cw_tid!=-1|cal timer_stop(g:cw_tid)|endif
    let g:cw_tid=timer_start(2000,{->execute("let w:w=matchadd('CW',expand('<cword>'),-1)")})
endf
au CursorMoved,CursorMovedI * cal <SID>cursorHi()
nnoremap <silent><Space>f :<C-u>cal <SID>fzf(system(system('git status')=~'fatal'?"find . -type f":"git ls-files")->split('\n'))<CR>
nnoremap <silent><Space>h :<C-u>cal <SID>fzf(execute('ol')->split('\n')->map({_,v->split(v,': ')[1]}))<CR>
au ColorScheme * hi FzfCurLine ctermfg=235 ctermbg=114
fu! s:fzf(files)
    let g:fzf_query=[]|let g:fzf_cur=0|let g:fzf_files=a:files|let g:fzf_matches=g:fzf_files[0:29]
    let g:fzf_wid=popup_create(g:fzf_files[0:29],#{title:"",zindex:99,line:18,col:50,minwidth:100,maxwidth:100,minheight:30,maxheight:30,border:[],borderchars:['─','│','─','│','╭','╮','╯','╰']})
    let g:fzf_q_wid=popup_create("",#{title:"fzf",zindex:100,line:15,col:50,minwidth:100,maxwidth:100,minheight:1,maxheight:1,border:[],borderchars:['─','│','─','│','╭','╮','╯','╰'],mapping:0,filter:function('s:fzf_filter')})
    let g:match_id=matchaddpos('FzfCurLine',[[g:fzf_cur+1]],10,-1,{'window':g:fzf_wid})
endf
fu! s:fzf_filter(winid, key)
    if a:key=="\<CR>"|cal popup_clear()|exe "e ".g:fzf_matches[g:fzf_cur]|retu 1
    elseif a:key=="\<ESC>"|cal popup_clear()|retu 1
    elseif a:key=="\<C-n>"|let g:fzf_cur=(g:fzf_cur+1)%len(g:fzf_matches)
    elseif a:key=="\<C-p>"|let g:fzf_cur=(g:fzf_cur-1+len(g:fzf_matches))%len(g:fzf_matches)
    elseif a:key=="\<BS>"|if !empty(g:fzf_query)|cal remove(g:fzf_query,-1)|endif
    elseif a:key=="\<C-w>"|let g:fzf_query=[]
    else|cal add(g:fzf_query,a:key)|endif
    let g:fzf_matches=empty(g:fzf_query)?g:fzf_files[0:29]:matchfuzzy(g:fzf_files,join(g:fzf_query,''))[0:29]
    if len(g:fzf_matches)-1<g:fzf_cur|let g:fzf_cur=0|endif
    if g:match_id!=-1|sil! cal matchdelete(g:match_id,g:fzf_wid)|endif
    let g:match_id=matchaddpos('FzfCurLine',[[g:fzf_cur+1]],10,-1,{'window':g:fzf_wid})
    cal popup_settext(g:fzf_q_wid,join(g:fzf_query,''))
    cal popup_settext(g:fzf_wid,g:fzf_matches)
endf

" TODO popupが使えないことを考慮して、quickfixに流せないか検討してみる
fu! GetQuickfixWindowId()
    for win_info in getwininfo()
        if getbufvar(win_info.bufnr,'&filetype')=='qf'
            retu win_info.winid
        endif
    endfor
    retu -1
endf

fu! Test()
    " TODO 引数で受け取る
    let g:fzf_files=execute('ol')->split('\n')->map({_,v->split(v,': ')[1]})
    copen
    sil! bo 1new
    setl buftype=nofile bufhidden=wipe nobuflisted modifiable nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no statusline=%%
    let query=""|cal setline(1,"> ".query)|redraw
    while 1
        let w=nr2char(getchar())
        if w=="\<CR>"
            q
            " TODO quickfixでCR
            cclose
            break
        elseif w=="\<ESC>"
            " TODO 閉じて、quickfixも閉じる
            break
        elseif w=="\<C-n>"
            " TODO quickfix上で下にj
            let qf_win_id = GetQuickfixWindowId()
            echom qf_win_id
            cal win_execute(qf_win_id, "normal! j")
            echom "C-n"
        elseif w=="\<C-p>"
            " TODO quickfix上で上にk
            echom "C-p"
        elseif w=="\<C-w>"||w=="\<C-u>"|let query=""
        else
            let query=query.w
            let g:fzf_matches=query==""?g:fzf_files:matchfuzzy(g:fzf_files,query)
            let tmp=&errorformat|let &errorformat='%f'|cgetexpr g:fzf_matches|let &errorformat=tmp
        endif
        cal setline(1,"> ".query)|redraw
    endwhile
endf

" ターミナル
set splitbelow termwinkey=<C-e>
tnoremap <silent><C-n> <C-e>N


" 外観
au ColorScheme * hi User1 cterm=bold ctermfg=235 ctermbg=39
au ColorScheme * hi User2 cterm=bold ctermfg=235 ctermbg=114
au ColorScheme * hi User3 cterm=bold ctermfg=235 ctermbg=204
au ColorScheme * hi User4 cterm=bold ctermfg=235 ctermbg=180
au ColorScheme * hi User5 cterm=bold ctermfg=235 ctermbg=170
let LF={'dos':'CRLF','unix':'LF','mac':'CR'}
fu! SetStatusLine()
    let dict={'i':'1* INSERT','n':'2* NORMAL','R':'3* REPLACE','c':'4* COMMAND','t':'4* TERMIAL','v':'5* VISUAL','V':'5* VISUAL',"\<C-v>":'5* VISUAL'}
    retu '%'.(match(keys(dict),mode())!=-1?dict[mode()]:"5* SP").' %* %<%F%m%r%h%w%=%2* %p%% %l/%L %02v | %{&filetype} | %{&fenc!=""?&fenc:&enc} | %{LF[&ff]} %*'
endf
set statusline=%!SetStatusLine()
fu! SetTabLine()
    let s=''
    for b in range(1,bufnr('$'))
        if bufexists(b)&&buflisted(b)
            let n=empty(bufname(b))?'[No Name]':fnamemodify(bufname(b),':t')
            let m=getbufvar(b,'&modified')?'*':''
            let s.=(b==bufnr('%')?'%#TabLineSel#':'%#TabLine#').'%'.b.'T '.n.m.' '
        endif
    endfor
    retu s.'%#TabLineFill#'
endf
set tabline=%!SetTabLine()
au ColorScheme * hi Comment ctermfg=245 term=bold
au ColorScheme * hi Normal ctermbg=none
au ColorScheme * hi LineNr ctermfg=245
au ColorScheme * hi Visual cterm=reverse ctermfg=240 ctermbg=235
au ColorScheme * hi Todo ctermfg=170 term=standout
au ColorScheme * hi String ctermfg=114
au ColorScheme * hi Number ctermfg=173
au ColorScheme * hi Boolean ctermfg=173
au ColorScheme * hi Function ctermfg=39
au ColorScheme * hi Operator ctermfg=170
au ColorScheme * hi Keyword ctermfg=170
au ColorScheme * hi Statement ctermfg=170
au ColorScheme * hi Type ctermfg=180
colorscheme torte
sil! colorscheme habamax
au BufEnter *.js syn match GlobalOperator "+\|-\|\*\|/\|%\|\^\|<\|>\|&\||\|=\|?\|:\|!\|\~"
au BufEnter *.js hi link GlobalOperator Operator
au BufEnter *.js syn match GlobalNumber "[0-9]\+n\|[0-9]\+l"
au BufEnter *.js hi link GlobalNumber Number
au BufEnter *.js syn match GlobalFunctionCall "\<\h\w*\>\s*("me=e-1 containedin=ALLBUT,GlobalComment
au BufEnter *.js hi link GlobalFunctionCall Function
au BufEnter *.js syn match GlobalComment "//.*$\|/\*.*$"
au BufEnter *.js hi link GlobalComment Comment
au BufEnter *.js syn match GlobalTodo "TODO\|XXX\|FIXME" containedin=GlobalComment
au BufEnter *.js hi link GlobalTodo Todo
au BufEnter *.js syn match GlobalSymbol "length\|console\|BigInt\|Math\|JSON"
au BufEnter *.js hi link GlobalSymbol Type


" 高機能(プラグイン) vim-plug導入コマンド
"curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall
""cal plug#begin()
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'sidorares/node-vim-debugger'
"Plug 'eliba2/vim-node-inspect'
"Plug 'puremourning/vimspector'
"Plug 'Exafunction/codeium.vim'
""cal plug#end()

" TODO lint診断

" TODO ステップ実行デバッグ

" TODO XXX いまできないこと
" - [!! できない]Lint診断がない
" - [!! できない]ステップ実行デバッグできない
" - (できなくはない)定義元検索がgdや検索
" - (できなくはない)呼び出し元検索がgrep
" - (できなくはないが、現場では無理)リネームが置換
" - (できなくはないが、現場では無理)フォーマットがインデントのみで言語無視
" - <いらんかなぁ>ドキュメントホバーが見られない

"let g:coc_global_extensions = ['coc-snippets', 'coc-explorer',
"            \ 'coc-vimlsp', 'coc-sh', 'coc-json',
"            \ 'coc-sql', 'coc-html', 'coc-css', 'coc-tsserver',
"            \ 'coc-clangd', 'coc-pyright',
"            \ 'coc-rust-analyzer', 'coc-go', 'coc-java',
"            \ ]
"nnoremap <silent><Space>d <Plug>(coc-definition)
"nnoremap <silent><Space>r <Plug>(coc-references)
"nnoremap <silent><Space>R <Plug>(coc-rename)
"nnoremap <silent><Space>F <Plug>(coc-format)
"nnoremap <silent><Space>, <Plug>(coc-diagnostic-next)
"nnoremap <silent><Space>. <Plug>(coc-diagnostic-prev)
"nnoremap <silent><Space>? :cal CocAction('doHover')<CR>
"nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : <C-d>
"nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : <C-u>
"nnoremap <silent><Space>l :<C-u>w<CR>:e!<CR>:echo 'Reload Buffer'<CR><Esc>
"let g:vimspector_base_dir=$HOME.'/.vim/plugged/vimspector'
"let g:vimspector_install_gadgets = ["vscode-js-debug"]
"let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
"let g:vimspector_log_file = '$HOME/vimspector.log'
"let g:vimspector_log_level = 'TRACE'
"let g:vimspector_sign_priority = {
"            \'vimspectorBP':          99,
"            \'vimspectorBPCond':      99,
"            \'vimspectorBPLog':       99,
"            \'vimspectorBPDisabled':  99,
"            \'vimspectorNonActivePC': 99,
"            \'vimspectorPC':          999,
"            \'vimspectorPCBP':        999,
"            \ }
"nnoremap <F9> <Plug>VimspectorToggleBreakpoint
"nnoremap <S-F9> :<C-u>cal vimspector#ClearBreakpoints()<CR>
"nnoremap <F5> <Plug>VimspectorContinue
"nnoremap <S-F5> :VimspectorReset<CR>
"nnoremap <F4> <Plug>VimspectorRestart
"nnoremap <F10> <Plug>VimspectorStepOver
"nnoremap <F11> <Plug>VimspectorStepInto
"nnoremap <S-F11> <Plug>VimspectorStepOut
"nnoremap <F3> :<C-u>cal execute('VimspectorWatch '.expand('<cword>'))<CR>
"nnoremap <Space>_ <Plug>VimspectorBalloonEval

" codium認証のために以下URLへのアクセス
"https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
"let g:codeium_disable_bindings = 1
"inoremap <script><silent><nowait><expr><C-i> codeium#Accept()

