" ==============================
" 自動フォーマット / 操作補助
" ==============================
" C++のみ、保存時に自動フォーマット
aug fmt_cpp
    au!
    au BufWrite *.cpp :try | cal CocAction('format') | catch | endtry
aug END

" 一番下の行から書く時、フォーマット+画面真ん中フォーカス
fu! s:format_file() abort
    try | cal CocAction('format') | catch | endtry
endf
noremap <silent><Plug>(fmt) :<C-u>cal <SID>format_file()<CR>
nnoremap O zz<Plug>(fmt)O

" main関数の上に移動しlibやconstなど書くための移動
nnoremap <silent><Leader>H /using namespace std<CR>o

" ==============================
" 問題番号のmain.cppを開く
" ==============================
" cppファイル一覧を取得
fu! Atcoder_maincpp_completion(A, L, P) abort
    retu system("find . -name '*.cpp' | cut -d '/' -f 2 | sort -u")->split("\n")
endf

" 任意のcppファイルを開く
fu! s:atcoder_maincpp_open() abort
    let w = input("開く問題 >", "", "customlist,Atcoder_maincpp_completion")
    exe "e ".w."/main.cpp"
    cal s:atcoder_hot_debug()
endf
com! AtCoderOpenMain cal s:atcoder_maincpp_open()

" 次の問題のcppファイルを開く
" 書き捨ての場合、次のURLを入れる
fu! s:atcoder_maincpp_next() abort
    " バッファを開いていない = コンテスト最初
    if expand("%")->empty()
        if glob("contest.acc.json")->empty()
            echom "[ERROR] コンテスト用のファイル「contest.acc.json」がありません."
            retu
        endif
        exe "e a/main.cpp"
        cal s:atcoder_hot_debug()
        cal popup_notification(["open a/main.cpp"], #{line: &lines/4, col: &columns/2})
        retu
    endif
    if expand("%:t") != "main.cpp"
        echom "[ERROR] 現在のファイルがmain.cppではありません"
        retu
    endif
    let current = expand("%:h")
    cal s:atcoder_hot_debug()
    " バッファがz/main.cpp = 書き捨て
    if current == "z"
        let res = s:atcoder_set_test_url()
        if res == 0
            retu
        endif
        exe "%d"
        cal popup_notification(["次の問題を解きましょう"], #{line: &lines/4, col: &columns/2})
        retu
    endif
    " 次の問題を取得
    let all = Atcoder_maincpp_completion("", "", "")
    let idx = match(all, current)
    if idx + 1 < len(all)
        let w = all[idx + 1]
        exe "e ".w."/main.cpp"
        cal popup_notification([w], #{line: &lines/4, col: &columns/2, time: 30000})
        let cc = execute("pwd")->split("\n")[0]->split("/")[-1]
        let next_url = "open https://atcoder.jp/contests/".cc."/tasks/".cc."_".w
        cal system(next_url)
    else
        cal popup_notification(["最後の問題です"], #{line: &lines/4, col: &columns/2})
    endif
endf
nnoremap <silent><Leader>a :<C-u>cal <SID>atcoder_maincpp_next()<CR>

" ==============================
" (書き捨て用) URLからテストケースをダウンロード
" ==============================
let g:contest_url = ""
fu! s:atcoder_set_test_url() abort
    if expand("%:t") != "main.cpp"
        echom "[ERROR] 現在のファイルがmain.cppではありません"
        retu 0
    endif
    let g:contest_url = input("[テストケースDL] - 問題URL >>")
    if g:contest_url == ""
        cal popup_notification(["cancel"], #{line: &lines})
        retu 0
    endif
    let current = expand("%:h")
    if !glob("./".current."/test")->empty()
        cal system("cd ".current."/ && rm -rf test")
    endif
    cal system("cd ".current."/ && oj d ".g:contest_url)
    cal popup_notification(["[テストケースをDL] :", g:contest_url], #{line: &lines})
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
        echom "[ERROR] 現在のファイルがmain.cppではありません"
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
com! AtCoderTestPopup cal s:ac_test_call()

" ==============================
" C++ debug用 右splitにターミナル画面
" ==============================
fu s:atcoder_debug_window() abort
    if expand("%:t") != "main.cpp"
        echom "[ERROR] 現在のファイルがmain.cppではありません"
        retu
    endif
    " zshで定義した関数cpp_debugを使用、現在のファイルをデバッグ実行
    let debug_cmd = "\<C-l>cpp_debug ".expand("%:h")."\<CR>\<C-e>h"
    if winnr("$") != 3 " 右端が3つ目のウィンドウである前提
        exe "vert term ++cols=60"
    endif " ない場合開く
    cal feedkeys("\<C-w>l")
    cal feedkeys(debug_cmd)
endf
com! AtCoderDebug cal s:atcoder_debug_window()

" ==============================
" ファイル保存時にdebug ホットリロード
" ==============================
fu! s:atcoder_hot_debug() abort
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

" ==============================
" 提出用の圧縮フォーマット
" ==============================
fu! s:atcoder_fmt() abort
    cal s:atcoder_debug_on_save_end()
    w | e!
    " //から右を全て削除(URLを除く)
    try | %s/[^https:]\/\/.*/ /g | catch
    endtry
    cal CocAction("format")
    w
    cal s:atcoder_hot_debug()
endf
com! AtCoderFormat cal s:atcoder_fmt()

" ==============================
" C++のロゴAAにコードフォーマットする
" ==============================
fu! s:atcoder_fmt_cpp() abort
    cal s:atcoder_fmt() " コメントを全て削除+フォーマット

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
com! AtCoderFormatCppAALogo cal s:atcoder_fmt_cpp()

" ==============================
" 提出
" ==============================
" コンテストの場合: atcoder_submit a
" 書き捨ての場合: atcoder_submit z https://xxxx...
fu! s:atcoder_submit() abort
    if expand("%:t") != "main.cpp"
        echom "[ERROR] 現在のファイルがmain.cppではありません"
        retu
    endif
    " ダウンロード済みURLがあれば書き捨てとみなす
    " zshで定義した関数atcoder_submitを使用
    let url = g:contest_url == "" ? "" : g:contest_url
    let cmd = "atcoder_submit ".expand("%:h")." ".url."\<CR>\<C-e>h"
    cal s:atcoder_fmt() " コメントを全て削除+フォーマット
    if winnr("$") != 3 " 右端が3つ目のウィンドウである前提
        exe "vert term ++cols=60"
    endif " ない場合開く
    cal feedkeys("\<C-w>l")
    cal feedkeys(cmd)
    cal popup_notification(["⭐️提出しました⭐️"], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>u :<C-u>cal <SID>atcoder_submit()<CR>

