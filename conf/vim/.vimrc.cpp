" ==============================
" 問題番号のmain.cppを開く
" ==============================
" cppファイル一覧を取得
fu! Atcoder_maincpp_completion(A, L, P) abort
    retu system("find . -name '*.cpp' | cut -d '/' -f 2 | sort -u")->split("\n")
endf

" 任意のcppファイルを開く
fu! s:atcoder_maincpp_open() abort
    let w = input("input problem code >", "", "customlist,Atcoder_maincpp_completion")
    exe "e ".w."/main.cpp"
    cal s:atcoder_debug_on_save_start()
endf

" 次の問題のcppファイルを開く
fu! s:atcoder_maincpp_next() abort
    " バッファを開いていない = コンテスト最初
    if expand("%")->empty()
        if glob("contest.acc.json")->empty()
            echom "[ERROR] Not a contest project."
            retu
        endif
        exe "e a/main.cpp"
        cal s:atcoder_debug_on_save_start()
        cal popup_notification(["open a/main.cpp"], #{line: &lines/4, col: &columns/2})
        retu
    endif

    if expand("%:t") != "main.cpp"
        echom "[ERROR] Not a main.cpp"
        retu
    endif

    let current = expand("%:h")
    cal s:atcoder_debug_on_save_start()

    " バッファがz/main.cpp = 書き捨て
    if current == "z"
        let res = s:atcoder_set_test_url()
        if res == 0
            retu
        endif
        exe "%d"
        cal popup_notification(["next problem"], #{line: &lines/4, col: &columns/2})
        retu
    endif

    " 次の問題を取得
    let all = Atcoder_maincpp_completion("", "", "")
    let idx = match(all, current)
    if idx + 1 < len(all)
        let w = all[idx + 1]
        exe "e ".w."/main.cpp"
        cal popup_notification(["next ".w], #{line: &lines/4, col: &columns/2})
    else
        cal popup_notification(["last problem"], #{line: &lines/4, col: &columns/2})
    endif
endf

com! MainOpen cal s:atcoder_maincpp_open()
com! MainNext cal s:atcoder_maincpp_next()
nnoremap <silent><Leader>a :<C-u>MainNext<CR>

" ==============================
" URLからテストケースをダウンロード
" ==============================
let g:contest_url = ""
fu! s:atcoder_set_test_url() abort

    if expand("%:t") != "main.cpp"
        echom "[ERROR] Not a main.cpp"
        retu 0
    endif

    let g:contest_url = input("input URL>")
    if g:contest_url == ""
        cal popup_notification(["cancel"], #{line: &lines})
        retu 0
    endif

    let current = expand("%:h")
    if !glob("./".current."/test")->empty()
        cal system("cd ".current."/ && rm -rf test")
    endif
    cal system("cd ".current."/ && oj d ".g:contest_url)
    cal popup_notification(["DL Test Data :", g:contest_url], #{line: &lines})
    retu 1
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
fu! s:ac_test.close() abort
        if self.wid != -1
        cal popup_close(self.wid)
        let self.wid = -1
        let self.res = []
    endif
endf
fu! s:ac_test.exe() abort
    cal timer_stop(self.tid)
    if expand("%:t") != "main.cpp"
        echom "[ERROR] Not a main.cpp"
        retu
    endif
    let current = expand("%:h")
    cal self.close()
    let self.wid = popup_create(self.res, #{title: ' Test - '.current.' ',
        \ scrollbar: 0, zindex: -1, fixed: 1,
        \ border: [], borderchars: ['─','│','─','│','╭','╮','╯','╰'], borderhighlight: ['AC_TEST_WIN'],
        \ minwidth: 50, maxwidth: 50, minheight: 40, maxheight: 40,
        \ pos: 'topleft', line: 40, col: &columns - 50,
        \ })
    cal setbufvar(winbufnr(self.wid), '&filetype', 'log')
    cal matchadd('AC_TEST_WIN', 'SUCCESS',  16, -1, #{window: self.wid})
    let cmd = "cd ".current
    let cmd = cmd." && eval $CPP_BUILD_CMD main main.cpp"
    let cmd = cmd." && oj t -e 1e-6 -c ./main"
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
com! TestAtCoderCpp cal s:ac_test_call()

" ==============================
" C++のdebug結果見る用に、右画面にターミナル画面(floatでない)
" ==============================
fu s:atcoder_debug_window() abort
    let debug_cmd = "\<C-l>cpp_debug ".expand("%:h")."\<CR>\<C-e>h"
    " 右端が3つ目のウィンドウである前提
    " ない場合開く
    if winnr("$") != 3
        exe "vert term ++cols=60"
    endif
    cal feedkeys("\<C-w>l")
    cal feedkeys(debug_cmd)
endf
com! DebugWindowAtCoderCpp cal s:atcoder_debug_window()

" ==============================
" ファイル保存時にdebug実行 ホットリロード
" ==============================
fu! s:atcoder_debug_on_save_start() abort
    aug debug_on_save
        au!
        au BufWrite *.cpp cal s:atcoder_debug_window()
    aug END
endf
fu! s:atcoder_debug_on_save_end() abort
    aug debug_on_save
        au!
    aug END
endf
com! DebugOnSaveAtCoderCpp cal s:atcoder_debug_on_save_start()
com! DebugOnSaveAtCoderCppEnd cal s:atcoder_debug_on_save_end()

" ==============================
" 提出用の圧縮フォーマット
" ==============================
fu! s:atcoder_fmt() abort
    cal s:atcoder_debug_on_save_end()
    w | e!
    " //から右を全て削除
    try | %s/\/\/.*/ /g | catch
    endtry
    cal CocAction("format")
    w
    cal s:atcoder_debug_on_save_start()
endf
noremap <silent><Plug>(atcoder-fmt) :<C-u>cal <SID>atcoder_fmt()<CR><Esc>
nnoremap <silent><Leader><Leader>F <Plug>(atcoder-fmt)

" ==============================
" C++のロゴAAにコードフォーマットする
" ==============================
fu! s:atcoder_fmt_cpp() abort
    " コメントを全て削除+フォーマット
    cal s:atcoder_fmt()

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
    cal timer_start(1000, { -> popup_notification(["Format C++ AA"], #{line: &lines/2, col: &columns/3}) })
endf
com! FmtAtCoderCppAALogo cal s:atcoder_fmt_cpp()

" ==============================
" 提出
" ==============================
fu! s:atcoder_submit() abort
    " コンテストの場合: atcoder_submit a
    " 書き捨ての場合: atcoder_submit z https://xxxx...
    " ダウンロード済みURLがあれば書き捨て
    let url = g:contest_url == "" ? "" : g:contest_url
    let cmd = "atcoder_submit ".expand("%:h")." ".url."\<CR>\<C-e>h"

    " debugと同様
    " 右端が3つ目のウィンドウである前提
    " ない場合開く
    if winnr("$") != 3
        exe "vert term ++cols=60"
    endif
    cal feedkeys("\<C-w>l")
    cal feedkeys(cmd)

    cal popup_notification(["⭐️提出⭐️"], #{line: &lines/2, col: &columns/3})
endf
noremap <silent><Plug>(atcoder-submit) :<C-u>cal <SID>atcoder_submit()<CR>
nnoremap <silent><Leader>u <Plug>(atcoder-fmt)<Plug>(atcoder-submit)

