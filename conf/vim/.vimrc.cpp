" ==============================
" 問題番号のmain.cppを開く
" ==============================
fu! Atcoder_maincpp_completion(A, L, P) abort
    retu system("find . -name '*.cpp' | cut -d '/' -f 2 | sort -u")->split("\n")
endf
fu! s:atcoder_maincpp_open() abort
    let w = input("input problem code >", "", "customlist,Atcoder_maincpp_completion")
    exe "e ".w."/main.cpp"
endf
fu! s:atcoder_maincpp_next() abort
    let all = Atcoder_maincpp_completion("", "", "")
    if expand('%')->empty()
        exe "e a/main.cpp"
        retu
    endif
    let current = expand('%')->split('/')[0]
    if current == "z"
        " クリップボードのURLを退避
        let @a = @*
        exe "%d"
        let @* = @a
        exe "AtCoderSetTestUrl"
        retu
    endif
    let idx = match(all, current)
    if idx + 1 < len(all)
        exe "e ".all[idx + 1]."/main.cpp"
    else
        echom "last problem"
    endif
endf
com! MainOpen cal s:atcoder_maincpp_open()
com! MainNext cal s:atcoder_maincpp_next()
nnoremap <Leader>j :<C-u>MainNext<CR>
nnoremap <Leader>k :<C-u>MainOpen<CR>

" ==============================
" URLからテストケースをダウンロード
" ==============================
fu! s:atcoder_set_test_url() abort
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
com! AtCoderSetTestUrl cal s:atcoder_set_test_url()

" ==============================
" 非同期でテスト結果をポップアップに表示
" ==============================
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
    " フォーマッタ+保存
    "cal CocAction('format')
    w
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
        \ minheight: 40, maxheight: 40,
        \ pos: 'topleft',
        \ line: 40, col: &columns - 50,
        \ })
    cal setbufvar(winbufnr(self.wid), '&filetype', 'log')
    cal matchadd('AC_TEST_WIN', 'SUCCESS',  16, -1, #{window: self.wid})
    let cmd = "cd ".task
    let cmd = cmd.' && '.$CPP_BUILD_CMD.' main main.cpp'
    let cmd = cmd.' && oj t -c "./main"'
    " out_cb: 標準出力、err_cb: 標準エラー
    " callback: 両方
    " debugの出力をstderrにしている
    " 現状、debug出力の色コードが変な出力になるので、stderrは塞いでいる
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

" ==============================
" C++のdebug結果見る用に、右画面にターミナル画面(floatでない)
" ==============================
fu s:atcoder_debug_window() abort
    w
    let debug_cmd = "debug ".expand('%')->split('/')[0]."\<CR>\<C-e>h"
    " 右のウィンドウを閉じる(前回分のterminalがある想定)
    if winnr('$') == 3 " 右端が3つ目のウィンドウであること
        let terminal_winid = win_getid(3)
        cal win_execute(terminal_winid, 'q')
    endif
    exe "vert term ++cols=60"
    cal feedkeys("\<C-l>".debug_cmd)
endf
noremap <silent><Plug>(atcoder-debug-window) :<C-u>cal <SID>atcoder_debug_window()<CR>
nnoremap <Leader>t <Plug>(atcoder-oj-test-off)<Plug>(atcoder-debug-window)

" ==============================
" 提出用圧縮コピペ
" ==============================
fu! s:atcoder_fmt() abort
    w | e!
    " //から右を全て削除
    try | %s/\/\/.*/ /g | catch
    endtry
    cal CocAction('format')
    w
    %y
    cal cursor(1, 1)
    cal popup_notification(['⭐️ 圧縮&コピー完了⭐️'], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>u :<C-u>cal <SID>atcoder_fmt()<CR><Esc>

" ==============================
" C++のロゴAAにコードフォーマットする
" ==============================
fu! s:atcoder_fmt_cpp() abort
    " コメントを全て削除+フォーマット
    w | e!
    try | %s/\/\/.*/ /g | catch
    endtry
    cal CocAction('format')
    w
    cal cursor(1, 1)
    " C++のロゴAAにフォーマット
    let pg = "./AA/AAfmt.js"
    if glob(pg)->empty()
        echom "[ERROR] AAfmt.js not found. Please setup C++ for dotfiles"
        retu
    endif
    let tmp = "___tmp_fmt_cpp"
    cal system("node ".pg." < ".bufname("%")." > ".tmp)
    cal system("cat ".tmp." > ".bufname("%"))
    cal system("rm ".tmp)
    " 全てヤンク
    cal timer_start(900, { -> execute("%y") })
    cal timer_start(1000, { -> popup_notification(['Format C++ AA'], #{line: &lines}) })
endf
noremap <silent><Plug>(atcoder-fmt-cpp) :<C-u>cal <SID>atcoder_fmt_cpp()<CR>
nnoremap <Leader><Leader>F <Plug>(atcoder-fmt-cpp)

