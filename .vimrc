" ############################################################
" #### Custom
" ############################################################
" leader
let mapleader = "\<Space>"
" completion with Tab
inoremap <expr><CR> pumvisible() ? '<C-y>' : '<CR>'
inoremap <expr><Tab> pumvisible() ? '<C-n>' : '<C-t>'
inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" terminal
nnoremap <silent><Leader>t :cal popup_create(term_start([&shell],#{hidden:1,term_finish:'close'}),#{border:[],minwidth:&columns*3/4,minheight:&lines*3/4})<CR>
nnoremap <silent><Leader>g :cal popup_create(term_start(['lazygit'],#{hidden:1,term_finish:'close'}),#{border:[],minwidth:&columns*3/4,minheight:&lines*3/4})<CR>

" row visual
nnoremap vv ^v$h

" insert move
inoremap <C-l> <C-o>l
inoremap {{ <C-o>A{}<C-o>h

" ############################################################
" #### PLUGINS
" ############################################################
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin()

" ### Enhanced vim motion
Plug 'serna37/vim-modern-basic'
Plug 'serna37/vim-anchor5'
Plug 'easymotion/vim-easymotion'
Plug 'haya14busa/vim-edgemotion'
Plug 'rhysd/clever-f.vim'
Plug 'serna37/vim-fscope-around'
Plug 't9md/vim-quickhl'
Plug 'haya14busa/vim-asterisk'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'simeji/winresizer'
Plug 'yuttie/comfortable-motion.vim'
nnoremap <C-h> ^<Plug>(anchor)
nnoremap <C-l> $<Plug>(anchor)
let g:EasyMotion_do_mapping = 0
nnoremap s <Plug>(easymotion-sn)
nnoremap <Leader><Leader>w <Plug>(easymotion-bd-w)
nnoremap <C-j> <Plug>(edgemotion-j)<Plug>(anchor)
nnoremap <C-k> <Plug>(edgemotion-k)<Plug>(anchor)
let g:clever_f_smart_case = 1
let g:clever_f_timeout_ms = 2000
let g:clever_f_highlight_timeout_ms = 2000
aug cleaver_f
    au!
    au ColorScheme * hi CleverFDefaultLabel cterm=bold,underline ctermfg=9 ctermbg=24
aug END
nnoremap <leader>w <Plug>(fscope-around-toggle)<Plug>(clever-f-reset)
nnoremap # <Plug>(asterisk-z*)<Plug>(quickhl-manual-this)
nnoremap <silent><Leader>q <Plug>(quickhl-manual-reset)<Plug>(clever-f-reset):noh<CR>
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_interval = 1000.0 / 60
let g:comfortable_motion_friction = 70.0
let g:comfortable_motion_air_drag = 5.0
nnoremap <silent><C-f> :cal comfortable_motion#flick(200)<CR>
nnoremap <silent><C-b> :cal comfortable_motion#flick(-200)<CR>


" ### Enhanced Visualization
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_highlighting_cache = 1
fu! s:moveBuf(flg) abort
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

fu! s:closeBuf() abort
    let now_b = bufnr('%')
    cal s:moveBuf('prev')
    execute('bd ' . now_b)
endf

noremap <silent><Plug>(buf-prev) :<C-u>cal <SID>moveBuf('prev')<CR>
noremap <silent><Plug>(buf-next) :<C-u>cal <SID>moveBuf('next')<CR>
noremap <silent><Plug>(buf-close) :<C-u>cal <SID>closeBuf()<CR>
nnoremap <C-n> <Plug>(buf-prev)
nnoremap <C-p> <Plug>(buf-next)
nnoremap <Leader>x <Plug>(buf-close)
nnoremap <silent><Leader>z :Goyo<CR>
nnoremap <silent><Leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" ### Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'TwoDark'
nnoremap <silent><Leader>f :cal execute('CocCommand fzf-preview.'.(system('git rev-parse --is-inside-work-tree') =~ 'fatal'?'DirectoryFiles':'ProjectFiles'))<CR>
nnoremap <silent><Leader>b :CocCommand fzf-preview.Buffers<CR>
nnoremap <silent><Leader>hf :CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent><Leader>e :CocCommand explorer --width 30<CR>
nnoremap <silent><Leader>s :CocCommand fzf-preview.Lines<CR>
nnoremap <silent><Leader><Leader>s :CocCommand fzf-preview.ProjectGrep .<CR>
nnoremap <silent><Leader>m :CocCommand fzf-preview.Bookmarks<CR>
nnoremap <silent><Leader>nn :CocCommand fzf-preview.MemoList<CR>
nnoremap <silent><Leader>ng :CocCommand fzf-preview.MemoListGrep .<CR>
au DirChanged * cal execute('CocCommand explorer --no-focus --width 30')

" ### Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" ### Reading
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'andymass/vim-matchup'
Plug 'preservim/vim-indent-guides'
Plug 'liuchengxu/vista.vim'
" brew install code-minimap
Plug 'wfxr/minimap.vim'
au VimEnter * RainbowParentheses
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_exclude_filetypes = ['help', 'coc-explorer', 'startify']
let g:indent_guides_auto_colors = 0
aug indent_guide
    au!
    au ColorScheme * hi IndentGuidesOdd ctermbg=236
    au ColorScheme * hi IndentGuidesEven ctermbg=236
aug END
let g:vista_sidebar_width = 15
nnoremap <silent><Leader><Leader>o :Vista!!<CR>
let g:minimap_git_colors = 1
nnoremap <silent><Leader><Leader>m :MinimapToggle<CR>

" ### Writing
Plug 'SirVer/ultisnips'
Plug 'markonm/traces.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'lfilho/cosco.vim'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
let g:UltiSnipsExpandTrigger="<C-s>"
" o -> A+CR (adhoc for snippet tabstop bug...)
nnoremap o A<CR>
let g:cosco_filetype_whitelist = ['cpp']
" return normal & save
inoremap jj <Esc>:CommaOrSemiColon<CR>:w<CR>
let g:move_key_modifier_visualmode = 'C'

" ### LSP IDE
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'thinca/vim-quickrun'
Plug 'puremourning/vimspector'
let g:coc_global_extensions = ['coc-explorer', 'coc-snippets', 'coc-fzf-preview',
            \ 'coc-sh', 'coc-vimlsp', 'coc-json', 'coc-sql',
            \ 'coc-html', 'coc-css', 'coc-tsserver',
            \ 'coc-clangd', 'coc-go', 'coc-pyright', 'coc-java',
            \ ]
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
au CursorHold * sil cal CocActionAsync('highlight')
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <silent><Leader>r :CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent><Leader>o :CocCommand fzf-preview.CocOutline<CR>
nnoremap <silent><Leader>? :cal CocAction('doHover')<CR>
nnoremap <Leader>, <plug>(coc-diagnostic-next)
nnoremap <Leader>. <plug>(coc-diagnostic-prev)
nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : comfortable_motion#flick(100)
nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : comfortable_motion#flick(-100)

" ### util
Plug 'soywod/unfog.vim'
Plug 'glidenote/memolist.vim'
Plug 'segeljakt/vim-silicon'
Plug 'nanotee/zoxide.vim'

call plug#end()


" ################# IDE #################
" IDE menu
aug dark_color
    au!
    au ColorScheme * hi DarkRed ctermfg=204
    au ColorScheme * hi DarkOrange ctermfg=180
    au ColorScheme * hi DarkBlue ctermfg=39
aug END
let s:idemenu = #{
    \ menuid: 0, mttl: ' IDE MENU (j / k) Enter choose ',
    \ menu: [
        \ '[⚙️  AcTest]       test by oj cmd',
        \ '[Format]          applay format for this file',
        \ '[ReName]          rename current word recursively',
        \ '[Snippet]         edit snippets',
        \ '[🚀 ContestCode]  checkout contest code',
        \ '[⏱️ Ac Timer]     start timer for AtCoder ',
        \ '[🔓 Ac Stop]      stop timer for AtCoder',
        \ '[♻️  Ac Prev]      undo cut & return  prev Problem ',
        \ '[🎬 Ac Cut]       cut all & next Problem ',
    \ ],
    \ cheatid: 0, cheattitle: ' LSP KeyMaps ',
    \ cheat: [
        \ ' (Space d) [Definition]     Go to Definition ',
        \ ' (Space r) [Reference]      Reference ',
        \ ' (Space o) [Outline]        view outline on popup ',
        \ ' (Space*2 o) [Vista]        view vista on side ',
        \ ' (Space*2 m) [MiniMap]      view MiniMap on side ',
        \ ' (Space ?) [Document]       show document on popup scroll C-f/b ',
        \ ' (Space ,) [Next Diagnosis] jump next diagnosis ',
        \ ' (Space .) [Prev Diagnosis] jump prev diagnosis ',
    \ ],
    \ }

fu! s:idemenu.open() abort
    let self.menuid = popup_menu(self.menu, #{title: self.mttl, border: [], borderchars: ['─','│','─','│','╭','╮','╯','╰'],
        \ callback: 's:idemenu_exe'})
    cal setwinvar(self.menuid, '&wincolor', 'String')
    cal matchadd('DarkRed', '\[.*\]', 16, -1, #{window: self.menuid})
    let self.cheatid = popup_create(self.cheat, #{title: self.cheattitle, line: &lines-5, border: [], borderchars: ['─','│','─','│','╭','╮','╯','╰']})
    cal setwinvar(self.cheatid, '&wincolor', 'String')
    cal matchadd('DarkRed', '\[.*\]', 16, -1, #{window: self.cheatid})
    cal matchadd('DarkBlue', '(.*)', 16, -1, #{window: self.cheatid})
endf


fu! s:idemenu_exe(_, idx) abort
    if a:idx == 1
        " ❯ python3 -m pip install online-judge-tools
        let contest_txt = readfile('contest_setting.txt')[0]
        cal popup_notification(['contest_setting : '.contest_txt], #{border:[], zindex:999, line: &lines-30, col: &columns-40, time:2000})
        let work_dir = '~/work/ac_cpp'
        let test_cmd = 'g++ -std=c++20 main.cpp && oj t'
        let contest_cd = split(contest_txt, '_')[0]
        let pre = 'cd '.work_dir.' && rm -rf test && oj d https://atcoder.jp/contests/'.contest_cd.'/tasks/'.contest_txt
        cal system(pre)
        let cmd = 'cd '.work_dir.' && '.test_cmd
        let s:ac_test_winid = bufwinid('ac_test')
        let current_win = winnr()
        if s:ac_test_winid == -1
            sil! exe 'vne ac_test'
        else
            call win_gotoid(s:ac_test_winid)
            exe '%d'
        endif
        let s:ac_test_bufnr = bufnr()
        setl buftype=nofile bufhidden=wipe nobuflisted modifiable
        setl nonumber norelativenumber nocursorline nocursorcolumn signcolumn=no
        setl filetype=log
        cal matchadd('DarkBlue', 'SUCCESS')
        sil! exe 'r!'.cmd
        exe current_win.'wincmd w'
        let s:ac_test_timer_id = timer_start(200, {tid -> s:ac_test_timer(tid)}, { 'repeat' : 10 })
    elseif a:idx == 2
        cal CocActionAsync('format')
    elseif a:idx == 3
        cal CocActionAsync('rename')
    elseif a:idx == 4
        exe 'UltiSnipsEdit'
    elseif a:idx == 5
        echohl DarkBlue
        let code = input('AtCode Contest Code :', readfile('contest_setting.txt')[0])
        echohl None
        cal writefile([code], 'contest_setting.txt')
        cal popup_notification(['contest_setting : '.code], #{border:[], zindex:999, line: &lines-30, col: &columns-40, time:2000})
    elseif a:idx == 6
        cal s:bell_hero()
        cal s:atcoder_timer_start()
    elseif a:idx == 7
        cal s:bell_submarine()
        cal s:atcoder_timer_stop()
    elseif a:idx == 8
        exe 'u'
        exe 'w'
        let alp = #{a:'a',b:'a',c:'b',d:'c',e:'d',f:'e',g:'f'}
        let contest_txt = readfile('contest_setting.txt')[0]
        let contest_cd = split(contest_txt, '_')[0]
        let question_cd = split(contest_txt, '_')[1]
        let next = contest_cd.'_'.get(alp, question_cd, 'a')
        cal writefile([next], 'contest_setting.txt')
        cal popup_notification(['contest_setting : '.next], #{border:[], zindex:999, line: &lines-30, col: &columns-40, time:2000})
    elseif a:idx == 9
        exe '%d'
        exe 'w'
        let alp = #{a:'b',b:'c',c:'d',d:'e',e:'f',f:'g'}
        let contest_txt = readfile('contest_setting.txt')[0]
        let contest_cd = split(contest_txt, '_')[0]
        let question_cd = split(contest_txt, '_')[1]
        let next = contest_cd.'_'.get(alp, question_cd, 'a')
        cal writefile([next], 'contest_setting.txt')
        cal popup_notification(['contest_setting : '.next], #{border:[], zindex:999, line: &lines-30, col: &columns-40, time:2000})
    endif
    cal popup_close(s:idemenu.cheatid)
    retu 0
endf

fu! s:idemenu() abort
    cal s:idemenu.open()
endf
noremap <silent><Plug>(ide-menu) :<C-u>cal <SID>idemenu()<CR>
nnoremap <Leader>v <Plug>(ide-menu)


" AtCoder用テストsuccess時のベル
let s:ac_test_timer_id = 0
let s:ac_test_winid = -1
let s:ac_test_bufnr = -1
fu! s:ac_test_timer(tid) abort
    for i in getbufline(s:ac_test_bufnr, 0, line("$"))
        if match(i, "test success") != -1
            cal s:bell_hero()
            cal timer_stop(a:tid)
            retu
        endif
    endfor
endf

fu! s:bell_hero() abort
    cal job_start(["/bin/zsh","-c","afplay /System/Library/Sounds/Hero.aiff"])
endf
fu! s:bell_submarine() abort
    cal job_start(["/bin/zsh","-c","afplay /System/Library/Sounds/Submarine.aiff"])
endf

" AtCoder用100分タイマー
let s:actimer_sec = 0
let s:actimer_view = ['000:00']
let s:actimer_pid = -1
let s:actimer_tid = -1

fu! s:atcoder_timer_start() abort
    let s:actimer_sec = 0
    let s:actimer_view = ['000:00']
    cal timer_stop(s:actimer_tid)
    cal popup_close(s:actimer_pid)
    let s:actimer_pid = popup_create(s:actimer_view, #{
        \ zindex: 99, mapping: 0, scrollbar: 1,
        \ border: [], borderchars: ['─','│','─','│','╭','╮','╯','╰'], borderhighlight: ['DarkBlue'],
        \ line: &lines-10, col: 10,
        \ })
    let s:actimer_tid = timer_start(1000, { tid -> s:atcoder_timer(tid) }, { 'repeat' : -1 })
endf

fu! s:atcoder_timer_stop() abort
    cal timer_stop(s:actimer_tid)
    cal popup_close(s:actimer_pid)
endf

fu! s:atcoder_timer(tid) abort
    let s:actimer_sec += 1
    " bell at 1min, 3min, 8min, 18min, 40min
    if s:actimer_sec==60 || s:actimer_sec==180 || s:actimer_sec==480 || s:actimer_sec==1080 || s:actimer_sec==2400
        cal s:bell_submarine()
    endif
    " bell every 20min
    if s:actimer_sec>2400 && s:actimer_sec%1200==0
        cal s:bell_submarine()
    endif
    " LPAD 0埋め
    let minutes = s:actimer_sec / 60
    let minutes = minutes < 10 ? '00'.minutes : '0'.minutes
    let seconds = s:actimer_sec % 60
    if seconds < 10
        let seconds = '0'.seconds
    endif
    " view
    let s:actimer_view = [minutes.':'.seconds]
    cal setbufline(winbufnr(s:actimer_pid), 1, s:actimer_view)
    if s:actimer_sec > 5400
        cal matchadd('DarkRed', '[^ ]', 16, -1, #{window: s:actimer_pid})
    endif
endf

" startify -------------------------------
let s:start = #{}

" ぼっちざろっく{{{
let s:start.btr_logo = [
    \'                                                                                                                                              dN',
    \'                                                                                                              ..                             JMF',
    \'                                                                                                         ..gMMMM%                           JMF',
    \'                                                                                                       .MM9^ .MF                           (MF',
    \'                                                                                              .(,      ("   .M#                  .g,      .MF',
    \'                                        .,  dN                                             gg,,M@          .M#                  .M#!      (M>',
    \'                                        JM} M#             .MNgg.                     .g,  ?M[ 7B         .MMg+gg,.           .MM"        ."',
    \'                                ...gNMN,.Mb MN           .gMM9!                      .(MN,  .=           .MMM9=  ?MN,         (WN,      .MM ',
    \'                   jN-      ..gMMN#!     (Mp(M}       .+MMYMF                    ..kMMWM%               ,M#^       dN.          .WNJ,   JM',
    \'                   MM     .MM9^  dN,                 dNB^ (M%                   ?M"!  ,M\        .,               .M#   .&MMMN,    ?"   M#',
    \'                   MN            .MN#^                    dM:  ..(J-,                 ,B         .TM             .M#   ,M@  .MF',
    \'                   MN.       ..MMBMN_                     dN_.MM@"!?MN.   TMm     .a,                           (M@         MM^',
    \'                   MN.     .MM"  JMb....       ..        dMMM=     .Mb            ?HNgJ..,                   .MM^',
    \'                   dM{          -MMM#7"T""   .dN#TMo       ?      .MM^                 ?!                 +gM#=',
    \'                   (M]         .MN(N#       .M@  .MF              .MM^                                      ~',
    \'                   .MN          ?"""             MM!            .MMD',
    \'                    ?N[                                         7"',
    \'                     TMe',
    \'                      ?MN,',
    \'                        TMNg,'
    \]
"}}}

" AtCoder{{{
let s:start.ac_logo = [
    \'                                                                           .',
    \'                                                                         .dN.',
    \'                                                                      ..d@M#J#(,',
    \'                                                                   vRMPMJNd#dbMG#(F',
    \'                                                         (O.  U6..  WJNdPMJFMdFdb#`  .JU` .Zo',
    \'                                                      .. +NM=(TB5.-^.BMDNdJbEddMd ,n.?T@3?MNm  ..',
    \'                                                     .mg@_J~/?`.a-XNxvMMW9""TWMMF.NHa._ ?_,S.Tmg|',
    \'                                                  .Js ,3,`..-XNHMT"= ...d"5Y"X+.. ?"8MNHHa.. (,b uZ..',
    \'                                                 J"17"((dNMMB"^ ..JTYGJ7"^  ?"T&JT9QJ..?"TMNNHa,?727N',
    \'                                                 .7    T"^..JT"GJv"=`             ?"4JJT9a.,?T"`  .7!',
    \'                                                         M~JY"!     ....<.Zj+,(...     .7Ta_M',
    \'                                             .JWkkWa,    d-F     .+;.ge.ga&.aa,ua+.g,     ,}#    .(Wkkkn,',
    \'                                            .W9AaeVY=-.. J;b   .XH3dHHtdHHDJHHH(HHH(WH,   J(F  ..?T4agdTH-',
    \'                                             6XkkkH=!    ,]d  .HHtdHHH.HHHbJHHH[WHHH(HHL  k.]    _7HkkkHJ:',
    \'                                             JqkP?H_      N(; TYY?YYY9(YYYD?YYYt7YYY\YY9 .Fd!     .WPjqqh',
    \'                                             .mmmH,``      d/b WHHJHH@NJHHH@dHHHFdHHHtHH#`.1#       `(dqqq]',
    \'                                            ,gmmgghJQQVb  ,bq.,YY%7YYY(YYY$?YYY^TYYY(YY^ K.]  JUQmAJmmmmg%',
    \'                                             ggggggggh,R   H,]  T#mTNNbWNN#dNN#(NN@(N@! .t#   d(Jgggggggg:',
    \'                                            .@@@@@#"_JK4,  ,bX.   ?i,1g,jge.g2+g2i,?`   K.t  .ZW&,7W@@@@@h.',
    \'                                        `..H@@@@@P   7 .H`  W/b        .^."?^(!        -1#   W, ?   T@@@@@Ma,`',
    \'                                        dH@HHHM"       U\   .N,L        ..            .$d    .B`     ."MHHH@HN.',
    \'                                   ....JMHHHHH@              ,N(p      .dH.d"77h.    .$J\              dHHHHHMU....',
    \'                                  ` WHH#,7MHHM{               ,N,h     d^.W,        .^J^               .MHHM"_d#HN.',
    \'                                   ,jH#Mo .MMW:                .W,4,  J\   Ta.-Y` .J(#                 .HMM- .M#MF!',
    \'                                     .MN/ d@?M+                  7e(h.           .3.F                  .MDd# (MML`',
    \'                                     .M4%  ?H, 7a,                .S,7a.       .Y.#^                .,"`.d=  ,PWe',
    \'                                    .! ?     dN .N,                 (N,7a.   .Y(d=                 .d! d@     4 .!',
    \'                                             .W` .!                   ?H,?GJ".d"                    ^  B',
    \'                                                                        (SJ.#=',
    \'                                                       J             ....            .M:',
    \'                                                      JUb     .   .#    (\            M~',
    \'                                                     .\.M;  .W@"` M}       .y7"m. .J"7M~ .v74e ,M7B',
    \'                                                    .F  ,N.  J]   M]       M)  JF M_  M~ d-     M`',
    \'                                                   .W,  .db, Jh.   Th...J\ /N..Y` ?N-.Ma.-M&.> .M-',
    \]
"}}}

let g:startify_custom_header = s:start.btr_logo
com! AtCoderLogo cal <SID>aclogo()
fu! s:aclogo() abort
    let g:startify_custom_header = s:start.ac_logo
    cal timer_start(500, {->execute('0')})
endf


" onedark ---------------------------------
if !glob('~/.vim/plugged/onedark.vim')->empty()
    colorscheme onedark
endif

