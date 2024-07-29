syntax on | set number laststatus=2 showtabline=2 incsearch hlsearch ignorecase smartcase shortmess-=S
let mapleader = "\<Space>"

" Plugin管理
" =====================================================================
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
Plug 'terryma/vim-expand-region'
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
Plug 'tomasiser/vim-code-dark'

" Filer
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
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
Plug 'bronson/vim-trailing-whitespace'
Plug 'matze/vim-move'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'thinca/vim-partedit'

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
"[Note] Migrate for .vimrc.cpp

call plug#end()
" =====================================================================

" Pluginの追加設定
" =====================================================================
" AI Copilot
" =====================================================================
" Exafunction/codeium.vim
" !! auth needs to see
" https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
" !! Codeium Authコマンドで出るリンクからのクリックだと、画面表示幅の問題でフルパスに飛べないことがあるので注意
let g:codeium_disable_bindings = 1
inoremap <silent><C-n> <Cmd>call codeium#CycleCompletions(1)<CR>
inoremap <silent><C-p> <Cmd>call codeium#CycleCompletions(-1)<CR>
inoremap <script><silent><nowait><expr><C-i> codeium#Accept()
"imap <silent><C-d> <Cmd>call codeium#Clear()<CR>

" =====================================================================
" Enhanced vim motion
" =====================================================================
" easymotion/vim-easymotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys='sfjkdawh'
let g:EasyMotion_smartcase = 1
let g:EasyMotion_disable_two_key_combo = 1
nnoremap s <Plug>(clever-f-reset)<Plug>(easymotion-s2)
nnoremap <Leader><Leader>s <Plug>(clever-f-reset)<Plug>(easymotion-sn)
nnoremap <Leader><Leader>w <Plug>(easymotion-overwin-w)

" haya14busa/vim-edgemotion
nnoremap <C-j> <Plug>(edgemotion-j)<Plug>(anchor)
nnoremap <C-k> <Plug>(edgemotion-k)<Plug>(anchor)

" rhysd/clever-f.vim
let g:clever_f_smart_case = 1
let g:clever_f_timeout_ms = 1500
let g:clever_f_highlight_timeout_ms = 1500
aug cleaver_f
    au!
    au ColorScheme * hi CleverFDefaultLabel cterm=BOLD,underline ctermfg=40 ctermbg=0
aug END

" unblevable/quick-scope
"aug quick_scope
    "au!
    "au ColorScheme * hi QuickScopePrimary ctermfg=204 cterm=BOLD
    "au ColorScheme * hi QuickScopeSecondary ctermfg=81 cterm=BOLD
"aug END
nnoremap <silent><leader>w <Plug>(clever-f-reset):QuickScopeToggle<CR>

" serna37/vim-fscope-around
let g:fscope_init_active = 0

" t9md/vim-quickhl
" haya14busa/vim-asterisk
nnoremap # <Plug>(asterisk-z*)<Plug>(quickhl-manual-this)
nnoremap <silent><Leader>q <Plug>(quickhl-manual-reset)<Plug>(clever-f-reset):noh<CR>

" yuttie/comfortable-motion.vim
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_interval = 1000.0 / 60
let g:comfortable_motion_friction = 70.0
let g:comfortable_motion_air_drag = 5.0
nnoremap <silent><C-f> :cal comfortable_motion#flick(200)<CR>
nnoremap <silent><C-b> :cal comfortable_motion#flick(-200)<CR>

" voldikss/vim-floaterm
set termwinkey=<C-e>
tnoremap <C-w> <Esc><BS>
tnoremap <C-x> <C-w><S-n>
tnoremap <silent><C-t> <C-\><C-n>:FloatermNew<CR>
tnoremap <silent><S-Tab> <C-\><C-n>:FloatermNext<CR>
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_width = 0.6
let g:floaterm_height = 1.2
let g:floaterm_position = 'bottomright'

" =====================================================================
" Enhanced Visualization
" =====================================================================
" vim-airline/vim-airline
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

" junegunn/goyo.vim
let s:zen_lsp_watch_tid = -1
fu! s:goyo_enter()
    colorscheme codedark
    set number
    if &filetype =~ 'cpp'
        " LSPサーバが停止したときに自動で再起動
        let s:zen_lsp_watch_tid = timer_start(2000, { -> s:chkLSP() })
    endif
endf

fu! s:goyo_leave()
    cal s:colorscheme_onedark()
    if &filetype =~ 'cpp'
        cal timer_stop(s:zen_lsp_watch_tid)
    endif
endf

" LSPサーバが停止したときに自動で再起動する関数
let s:should_reboot_clangd = 0
fu! s:chkLSP() abort
    if g:coc_status =~ 'clangd: parsing includes, running Update'
        if s:should_reboot_clangd == 1
            let s:should_reboot_clangd = 0
            "clangd: parsing includes, running Update
            sil! exe 'CocRestart'
            echom '[INFO] restart coc to reboot clangd.'
        else
            let s:should_reboot_clangd = 1
        endif
    endif
endf

au! User GoyoEnter nested cal <SID>goyo_enter()
au! User GoyoLeave nested cal <SID>goyo_leave()
nnoremap <silent><Leader>z :Goyo<CR>

" machakann/vim-highlightedyank
let g:highlightedyank_highlight_duration = 300

" liuchengxu/vim-which-key
nnoremap <silent><Leader> :WhichKey '<Space>'<CR>
set timeoutlen=500

" =====================================================================
" Filer
" =====================================================================
" junegunn/fzf
" junegunn/fzf.vim
let $FZF_PREVIEW_PREVIEW_BAT_THEME = 'TwoDark'
let g:fzf_preview_use_dev_icons = 1
nnoremap <silent><Leader>f :cal execute('CocCommand fzf-preview.'.(system('git rev-parse --is-inside-work-tree') =~ 'fatal'?'DirectoryFiles':'ProjectFiles'))<CR>
nnoremap <silent><Leader>b :CocCommand fzf-preview.Buffers<CR>
nnoremap <silent><Leader>h :CocCommand fzf-preview.MruFiles<CR>
nnoremap <silent><Leader>e :CocCommand explorer --width 30<CR>
nnoremap <silent><Leader>s :CocCommand fzf-preview.Lines<CR>
nnoremap <silent><Leader>m :CocCommand fzf-preview.Bookmarks<CR>
nnoremap <silent><Leader>nn :CocCommand fzf-preview.MemoList<CR>
nnoremap <silent><Leader>ng :CocCommand fzf-preview.MemoListGrep .<CR>
fu! s:grep() abort
    let w = input('[word]>>', expand('<cword>'))
    execute('CocCommand fzf-preview.ProjectGrep '.w)
endf
noremap <silent><Plug>(fzf-grep) :<C-u>cal <SID>grep()<CR>
nnoremap <Leader>g <Plug>(fzf-grep)
au DirChanged * cal execute('CocCommand explorer --no-focus --width 30')

" =====================================================================
" Reading
" =====================================================================
" junegunn/rainbow_parentheses.vim
au VimEnter * RainbowParentheses

" preservim/vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
let g:indent_guides_exclude_filetypes = ['help', 'coc-explorer', 'startify']
let g:indent_guides_auto_colors = 0
aug indent_guide
    au!
    au ColorScheme * hi IndentGuidesOdd ctermbg=236
    au ColorScheme * hi IndentGuidesEven ctermbg=234
aug END

" liuchengxu/vista.vim
let g:vista_sidebar_width = 15

" wfxr/minimap.vim
let g:minimap_git_colors = 1

" =====================================================================
" Writing
" =====================================================================
" matze/vim-move
let g:move_key_modifier_visualmode = 'C'

" jiangmiao/auto-pairs
let g:AutoPairsMapCh = 0

" =====================================================================
" LSP IDE
" =====================================================================
" neoclide/coc.nvim
let g:coc_global_extensions = [
    \ 'coc-fzf-preview',
    \ 'coc-snippets',
    \ 'coc-explorer',
    \ 'coc-vimlsp',
    \ 'coc-sh',
    \ 'coc-json',
    \ 'coc-sql',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-tsserver',
    \ 'coc-clangd',
    \ 'coc-pyright',
    \ 'coc-rust-analyzer',
    \ 'coc-go',
    \ 'coc-java',
\ ]
let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'
inoremap <C-s> <Plug>(coc-snippets-expand)
au CursorHold * sil cal CocActionAsync('highlight')

" 補完の選択
inoremap <expr><CR> pumvisible() ? '<C-y>' : '<CR>'
"inoremap <expr><Tab> pumvisible() ? '<C-n>' : '<C-t>'
"inoremap <expr><S-Tab> pumvisible() ? '<C-p>' : '<S-Tab>'

" cocからの補完の選択
inoremap <silent><expr><CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
inoremap <silent><expr><Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

" IDE系 定義元 呼び出し エラー等
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <silent><Leader>r :CocCommand fzf-preview.CocReferences<CR>
nnoremap <silent><Leader>o :CocCommand fzf-preview.CocOutline<CR>
nnoremap <silent><Leader>? :cal CocAction('doHover')<CR>
nnoremap <Leader>, <plug>(coc-diagnostic-next)
nnoremap <Leader>. <plug>(coc-diagnostic-prev)
nnoremap <silent><Leader><S-F> :<C-u>cal CocActionAsync('format')<CR>
nnoremap <silent><Leader><S-R> <Plug>(coc-rename)

" ホバードキュメントスクロールを有効に
nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : comfortable_motion#flick(100)
nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : comfortable_motion#flick(-100)

" LSP再起動のため、バッファ再読み込み
nnoremap <silent><Leader>l :<C-u>w<CR>:e!<CR>zz:<C-u>echo 'Reload Buffer'<CR>
"nnoremap <silent><Leader>l :silent! exe 'CocRestart'<CR>:echom '[INFO] restart coc to reboot clangd.'<CR>

" SNIPモードを強制終了 (バッファ再読み込み)
inoremap <silent><C-k> <Esc>:<C-u>w<CR>:e!<CR>zza

" 保存時の自動フォーマット
"aug fmt_cpp
    "au!
    "au BufWrite *.cpp :try | cal CocAction('format') | catch | endtry
"aug END

" puremourning/vimspector
let g:vimspector_base_dir=$HOME.'/.vim/plugged/vimspector'
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_sign_priority = {
    \'vimspectorBP':          99,
    \'vimspectorBPCond':      99,
    \'vimspectorBPLog':       99,
    \'vimspectorBPDisabled':  99,
    \'vimspectorNonActivePC': 99,
    \'vimspectorPC':          999,
    \'vimspectorPCBP':        999,
    \ }

" =====================================================================
" Util
" =====================================================================
" segeljakt/vim-silicon
let g:silicon = {}
let g:silicon['output'] = '~/Desktop/tmp.png'

" =====================================================================
" Initiation, Art
" =====================================================================
" mhinz/vim-startify
let s:start = #{}

" ぼっちざろっく{{{
let s:start.btr_logo = [
    \'                                                                                                                                  dN',
    \'                                                                                                  ..                             JMF',
    \'                                                                                             ..gMMMM%                           JMF',
    \'                                                                                           .MM9^ .MF                           (MF',
    \'                                                                                  .(,      ("   .M#                  .g,      .MF',
    \'                            .,  dN                                             gg,,M@          .M#                  .M#!      (M>',
    \'                            JM} M#             .MNgg.                     .g,  ?M[ 7B         .MMg+gg,.           .MM"        ."',
    \'                    ...gNMN,.Mb MN           .gMM9!                      .(MN,  .=           .MMM9=  ?MN,         (WN,      .MM ',
    \'       jN-      ..gMMN#!     (Mp(M}       .+MMYMF                    ..kMMWM%               ,M#^       dN.          .WNJ,   JM',
    \'       MM     .MM9^  dN,                 dNB^ (M%                   ?M"!  ,M\        .,               .M#   .&MMMN,    ?"   M#',
    \'       MN            .MN#^                    dM:  ..(J-,                 ,B         .TM             .M#   ,M@  .MF',
    \'       MN.       ..MMBMN_                     dN_.MM@"!?MN.   TMm     .a,                           (M@         MM^',
    \'       MN.     .MM"  JMb....       ..        dMMM=     .Mb            ?HNgJ..,                   .MM^',
    \'       dM{          -MMM#7"T""   .dN#TMo       ?      .MM^                 ?!                 +gM#=',
    \'       (M]         .MN(N#       .M@  .MF              .MM^                                      ~',
    \'       .MN          ?"""             MM!            .MMD',
    \'        ?N[                                         7"',
    \'         TMe',
    \'          ?MN,',
    \'            TMNg,'
    \]
"}}}

let g:startify_custom_header = s:start.btr_logo

" joshdick/onedark.vim
fu! s:del_col() abort
    aug onedark_comment
        au!
    aug END
endf
fu! s:colorscheme_onedark() abort
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
            au ColorScheme * hi CursorLine ctermbg=236
            au ColorScheme * hi CursorColumn ctermbg=236
            au ColorScheme * hi Visual ctermbg=240
        aug END
        colorscheme onedark
        cal timer_start(2000, { -> s:del_col() })
    endif
endf
cal s:colorscheme_onedark()

" =====================================================================
" LSPのための追加設定
" =====================================================================

" 依存スニペット展開用。トリガ文言を展開する
fu! s:expandSnippet() abort
    cal feedkeys("A\<C-s>\<Esc>", 'x')
    w
endf
noremap <silent><Plug>(exp-snip) :<C-u>cal <SID>expandSnippet()<CR>
nnoremap <Leader>t <Plug>(exp-snip)

" 一番下行から書く時に、フォーマットして画面真ん中フォーカス
fu! s:asyncFormat() abort
    try | cal CocAction('format') | catch | endtry
endf
noremap <silent><Plug>(async-fmt) :<C-u>cal <SID>asyncFormat()<CR>
nnoremap O zz<Plug>(async-fmt)O

" 行のどこにいても、行末に{を入力、行末に移動
inoremap {{ <Esc>A{}<Left>

" 行のどこにいても、行末にセミコロンを、なければ入れる
fu! s:tailsemi() abort
    if getline('.')[-1:] != ';'
        execute('normal A;')
    endif
    w
endf
noremap <silent><Plug>(tailsemi) :<C-u>cal <SID>tailsemi()<CR>
inoremap ;; <Esc><Plug>(tailsemi)
inoremap ;<CR> <Esc><Plug>(tailsemi)o

" main関数の上に移動しlibやconstなど書くための移動
nnoremap <silent><Leader>H 0<Plug>(edgemotion-k)O

" コメント設計のための補助
let s:cmt_design_step = 1
fu! s:comment_design() abort
    let txt = input('step'.s:cmt_design_step.'>')
    cal append(line('.')-1, '// '.s:cmt_design_step.'. '.txt)
    let s:cmt_design_step += 1
endf
fu! s:comment_design_reset() abort
    let s:cmt_design_step = 1
endf
nnoremap <silent><C-c> :cal <SID>comment_design_reset()<CR>:echom '[INFO] comment sequence reset'<CR>
nnoremap <silent><Leader>j :cal <SID>comment_design()<CR>

" =====================================================================
" その他
" =====================================================================
" シェルで変なことするので無効化
nnoremap K :<C-u>echo 'K'<CR>

" C++用設定
" 提出用圧縮コピペ
fu! s:fmt4Submisstion() abort
    w | e!
    " // --- debug_start
    " から
    " // --- debug_end
    " までの行を全て削除
    let flg = 0
    let row = 0
    for v in getline(0, '$')
        let row += 1
        if v == '// --- debug_start'
            let flg = 1
        endif
        if v == '// --- debug_end'
            let flg = 0
        endif
        if flg
            cal setline(row, '')
        endif
    endfor
    " debugのincludeを削除
    let row = 0
    for v in getline(0, '$')
        let row += 1
        if v == '#include <bits/debug.hpp>'
            cal setline(row, '')
            break
        endif
    endfor
    " debug出力も削除
    try | %s/debug(.*/ /g | catch
    endtry
    " //から右を全て削除
    try | %s/\/\/.*/ /g | catch
    endtry

    cal CocAction('format')
    w
    %y
    cal cursor(1, 1)
    cal popup_notification(['⭐️ 圧縮&コピー完了⭐️'], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>u :<C-u>cal <SID>fmt4Submisstion()<CR><Esc>


" 非同期でテスト結果をポップアップに表示
aug AC_TEST_COLOR
    au!
    au ColorScheme * hi AC_TEST_WIN ctermfg=39 ctermbg=237
    au ColorScheme * hi AC_ALERT ctermfg=204
aug END
let s:ac_test = #{wid: -1, res: [], tid: -1}
fu! s:ac_test.gettask() abort
    let target_bufname = "nodata"
    for wid in range(1, winnr('$'))
        let bufname = bufname(winbufnr(wid))
        if bufname =~ ".*\/main\.cpp"
            let target_bufname = bufname
            break
        endif
    endfor
    retu split(target_bufname, '/')[-2]
endf
fu! s:ac_test.close() abort
        if self.wid != -1
        cal popup_close(self.wid)
        let self.wid = -1
        let self.res = []
    endif
endf
fu! s:ac_test.exe() abort
    cal timer_stop(self.tid)
    let task = s:ac_test.gettask()
    if task == "nodata" || len(task) != 1
        echohl AC_ALERT
        echom "[ERROR] AtCoder Format Program Not Found. sample: 'a/main.cpp'"
        echohl None
        retu
    endif
    cal self.close()
    let self.wid = popup_create(self.res, #{title: ' Test - '.task.' ',
        \ zindex: -1,
        \ scrollbar: 0,
        \ fixed: 1,
        \ border: [], borderchars: ['─','│','─','│','╭','╮','╯','╰'], borderhighlight: ['AC_TEST_WIN'],
        \ minwidth: 50, maxwidth: 50,
        \ minheight: 35, maxheight: 35,
        \ pos: 'topleft',
        \ line: 35, col: &columns - 50,
        \ })
    cal setbufvar(winbufnr(self.wid), '&filetype', 'log')
    cal matchadd('AC_TEST_WIN', 'SUCCESS',  16, -1, #{window: self.wid})
    let cmd = "cd ".task
    let cmd = cmd.' && '.$CC_BUILD_CMD.' main main.cpp'
    let cmd = cmd.' && oj t -c "./main"'
    cal job_start(["/bin/zsh", "-c", cmd], #{out_cb: self.async})
    let self.tid = timer_start(10000, { -> self.close()})
endf
fu! s:ac_test.async(ch, msg) abort
    cal add(self.res, a:msg)
    cal setbufline(winbufnr(self.wid), 1, self.res)
endf
fu! s:ac_test_call() abort
    cal s:ac_test.exe()
endf
fu! s:ac_test_off() abort
    cal s:ac_test.close()
endf
noremap <silent><Plug>(atcoder-oj-test) :<C-u>cal <SID>ac_test_call()<CR>
noremap <silent><Plug>(atcoder-oj-test-off) :<C-u>cal <SID>ac_test_off()<CR>
nnoremap <silent><Leader>a <Plug>(atcoder-oj-test)
nnoremap <silent><Leader><Leader>a <Plug>(atcoder-oj-test-off)

" URLからテストケースをダウンロード
fu! s:atcoderSetTestUrl() abort
    let task = s:ac_test.gettask()
    if task == "nodata" || len(task) != 1
        echohl AC_ALERT
        echom "[ERROR] AtCoder Format Program Not Found. sample: 'a/main.cpp'"
        echohl None
        retu
    endif
    let contest_url = input('input URL>')
    if !glob('./'.task.'/test')->empty()
        cal system('cd '.task.'/ && rm -rf test')
    endif
    cal system('cd '.task.'/ && oj d '.contest_url)
    cal popup_notification(['DL Test Data By', contest_url], #{line: &lines})
endf
com! AtCoderSetTestUrl cal <SID>atcoderSetTestUrl()

