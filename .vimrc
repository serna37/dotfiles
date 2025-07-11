" 共通
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark title showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smartindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,noselect,preview,popup incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1 | let &titleold=getcwd() | syntax on | filetype plugin on | au QuickFixCmdPost *grep* cwindow


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
fu! s:autocomplete()
    if pumvisible()|retu|endif
    let prev_str=(slice(getline('.'),0,charcol('.')-1)..v:char)->substitute('.*[^[:keyword:]]','','')
    if strchars(prev_str)<2|retu|endif|cal feedkeys("\<c-n>",'ni')
endf
au InsertCharPre * cal <SID>autocomplete()


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
au ColorScheme * hi FC cterm=bold
au CursorMoved,CursorMovedI * if exists('w:f')&&w:f!=-1|sil! cal matchdelete(w:f)|let w:f=-1|endif|let w:f=matchadd('FC','\%'.line('.').'l\(\<\w\)',99)
nnoremap <silent>f :<C-u>cal <SID>fmode(1)<CR>
nnoremap <silent>F :<C-u>cal <SID>fmode(0)<CR>
au ColorScheme * hi FChar ctermfg=155 cterm=bold,underline
fu! s:fmode(vector)
    if !exists('w:fmode')||w:fmode==0|let w:fmode=1|let w:char=nr2char(getchar())| endif
    if exists('w:fmatch')&&w:fmatch!=-1|sil! cal matchdelete(w:fmatch)|let w:fmatch=-1|endif
    let w:fmatch=matchadd('FChar','\%'.line('.').'l'.w:char,100)
    exe "normal! ".(a:vector?"f":"F").w:char
    if exists('g:fmode_tid')&&g:fmode_tid!=-1|cal timer_stop(g:fmode_tid)|endif
    let g:fmode_tid=timer_start(1000,{->execute("let w:fmode=0|sil! cal matchdelete(w:fmatch)")})
endf

nnoremap <silent>s :<C-u>cal <SID>emotion()<CR>
let s:emotion_keypos=[]|let s:emotion_klen=1|let g:emotion_keys = ['s','w','a','d','j','k','h','l']
let s:emotion_popid=0
fu! s:emotion()
    let c1=nr2char(getchar())
    let s:emotion_keypos=[]|let wininfo=[]|let tarcnt=0|let rn=line('w0')|let crn=line('.')|let s:emotion_klen=1
    for l in getline('w0', 'w$')
        if l !~ '^[ -~]\+$' | let rn+=1 | continue | endif
        let chars = [] | let ofst = 0
        while ofst != -1
            let st = matchstrpos(l, '\<.', ofst) | let ofst = matchstrpos(l, '.\>', ofst)[2]
            if st[0] != '' && st[0] ==# c1 | cal add(chars, st[2]) | endif
        endwhile
        if !empty(chars) | cal add(wininfo, #{row: rn, col: chars}) | endif
        let tarcnt = tarcnt+len(chars) | let rn+=1
    endfor
    if tarcnt==0 | retu | endif
    while tarcnt > pow(len(g:emotion_keys), s:emotion_klen) | let s:emotion_klen+=1 | endwhile
    let keyOrder = range(1, s:emotion_klen)->map({->0})
    for r in sort(deepcopy(wininfo), { x,y -> abs(x.row-crn) - abs(y.row-crn) })
        let tmp = []
        for col in r.col
            cal add(tmp, #{key: copy(keyOrder)->map({i,v->g:emotion_keys[v]})->join(''), pos: col})
            let keyOrder = s:incrementNOrder(len(g:emotion_keys)-1, keyOrder)
        endfor
        cal add(s:emotion_keypos, #{row: r.row, col: tmp})
    endfor
    for rn in range(line('w0'), line('w$')) | cal matchaddpos('EmotionBase', [rn], 200) | endfor
    cal s:emotion_draw(s:emotion_keypos) | cal popup_close(s:emotion_popid)
    let s:emotion_popid = popup_create('e-motion', #{line: &lines, col: &columns*-1, mapping: 0, filter: function('s:emotion_char_enter')})
    cal win_execute(s:emotion_popid, "mapclear <buffer>") | echo ''
endf
fu! s:incrementNOrder(nOrder, keyOrder)
    if len(a:keyOrder) == 1 | retu [a:keyOrder[0]+1] | endif
    let tmp = [] | let overflow = 0
    for idx in reverse(range(0, len(a:keyOrder)-1))
        if idx == len(a:keyOrder)-1
            cal insert(tmp, a:keyOrder[idx] == a:nOrder ? 0 : a:keyOrder[idx]+1)
            if tmp[0] == 0 | let overflow = 1 | endif | continue
        endif
        if overflow
            cal insert(tmp, a:keyOrder[idx] == a:nOrder ? 0 : a:keyOrder[idx]+1)
            let overflow = a:keyOrder[idx] == a:nOrder ? 1 : 0
        else
            cal insert(tmp, a:keyOrder[idx])
        endif
    endfor
    retu tmp
endf
au ColorScheme * hi EmotionBase ctermfg=59
au ColorScheme * hi EmotionWip ctermfg=166 cterm=bold
au ColorScheme * hi EmotionFin ctermfg=196 cterm=bold
fu! s:hiResetAll(group_name)
    cal getmatches()->filter({ _,v -> v.group == a:group_name })->map('execute("cal matchdelete(v:val.id)")')
endf
fu! s:emotion_draw(keypos)
    cal s:hiResetAll('EmotionFin') | cal s:hiResetAll('EmotionWip')
    let hlpos_wip = [] | let hlpos_fin = []
    for r in a:keypos | let line = getline(r.row)
        for c in r.col
            let colidx = c.pos-1 | let view_keystroke = c.key[:0] | let offset = colidx-1
            cal add(hlpos_fin, [r.row, c.pos])
            if len(c.key)>=2
                let view_keystroke = c.key[:1]
                cal add(hlpos_wip, [r.row, c.pos, 2])
            endif
            let line = colidx == 0
                        \ ? view_keystroke.line[len(view_keystroke):]
                        \ : line[0:offset].view_keystroke.line[colidx+len(view_keystroke):]
        endfor
        cal setline(r.row, line)
    endfor
    for t in hlpos_fin | cal matchaddpos('EmotionFin', [t], 201) | endfor
    for t in hlpos_wip | cal matchaddpos('EmotionWip', [t], 202) | endfor
endf
fu! s:emotion_char_enter(winid, key)
    if g:emotion_keys->index(a:key) == -1
        cal popup_close(s:emotion_popid) | let p = getpos('.') | u | cal cursor(p[1],p[2])
        cal s:hiResetAll('EmotionFin') | cal s:hiResetAll('EmotionWip') | cal s:hiResetAll('EmotionBase')
        echohl Special | echo 'e-motion: go out' | echohl None | retu 1
    endif
    let tmp = s:emotion_keypos->deepcopy()->map({ _,r -> #{row: r.row,
                \col: r.col->filter({_,v->v.key[0]==a:key})->map({_,v->#{key: v.key[1:], pos: v.pos}})} })
                \->filter({_,v->!empty(v.col)})
    if empty(tmp) | retu 1 | else | let s:emotion_keypos = tmp | endif
    if len(s:emotion_keypos) == 1 && len(s:emotion_keypos[0].col) == 1
        cal popup_close(s:emotion_popid) | u | cal cursor(s:emotion_keypos[0].row, s:emotion_keypos[0].col[0].pos)
        cal s:hiResetAll('EmotionFin') | cal s:hiResetAll('EmotionWip') | cal s:hiResetAll('EmotionBase')
        echohl Special | echo 'e-motion: finish' | echohl None | retu 1
    endif
    let p = getpos('.') | u | cal cursor(p[1],p[2]) | echo '' | cal s:emotion_draw(s:emotion_keypos)
    retu 1
endf


" 検索
nnoremap # *N
au ColorScheme * hi Search cterm=bold ctermfg=16 ctermbg=153
nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>exe "vim /".expand("<cword>")."/gj ".(system('git status')=~'fatal'?'** **/.':join(split(system('git ls-files'))))<CR>:echo "Quickfix移動:cn cp"<CR>
nnoremap <silent>cn :<C-u>cn<CR>
nnoremap <silent>cp :<C-u>cp<CR>
nnoremap <silent><Space>f :<C-u>cal <SID>fzf()<CR>
au ColorScheme * hi FzfCurLine ctermfg=235 ctermbg=114
fu! s:fzf()
    let g:fzf_query=[]|let g:fzf_cur=0
    let g:fzf_files=system(system('git status')=~'fatal'?"find . -type f":"git ls-files")->split('\n')
    let g:fzf_matches=g:fzf_files[0:29]
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
    cal popup_settext(g:fzf_q_wid,join(g:fzf_query,''))|cal popup_settext(g:fzf_wid,g:fzf_matches)
    retu 1
endf


" ターミナル
set termwinkey=<C-e>
set splitbelow
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
colorscheme habamax
au BufEnter * syn match GlobalOperator "+\|-\|\*\|/\|%\|\^\|<\|>\|&\||\|=\|?\|:\|!\|\~"
au BufEnter * hi link GlobalOperator Operator
au BufEnter * syn match GlobalFunctionCall "\<\h\w*\>\s*("me=e-1 containedin=ALLBUT,GlobalComment
au BufEnter * hi link GlobalFunctionCall Function
au BufEnter * syn match GlobalComment "//.*$\|/\*.*$"
au BufEnter * hi link GlobalComment Comment
au BufEnter * syn match GlobalTodo "TODO\|XXX\|FIXME" containedin=GlobalComment
au BufEnter * hi link GlobalTodo Todo
au BufEnter * syn match GlobalSymbol "length\|console\|Math\|JSON"
au BufEnter * hi link GlobalSymbol Type


" 高機能(プラグイン) vim-plug導入コマンド
"curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall"
cal plug#begin()
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'sidorares/node-vim-debugger'
"Plug 'eliba2/vim-node-inspect'
"Plug 'puremourning/vimspector'
"Plug 'Exafunction/codeium.vim'
cal plug#end()

" TODO XXX いまできないこと
" - (できなくはない)定義元検索がgdや検索
" - (できなくはない)呼び出し元検索がgrep
" - (できなくはないが、現場では無理)リネームが置換
" - (できなくはないが、現場では無理)フォーマットがインデントのみで言語無視
" - [!! できない]Lint診断がない
" - [!! できない]ステップ実行デバッグできない
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

