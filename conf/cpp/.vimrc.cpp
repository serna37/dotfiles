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
        if bufname =~ ".\/main\.cpp"
            let target_bufname = bufname
            break
        endif
    endfor
    retu split(target_bufname, '/')[0]
endf
fu! s:ac_test.close() abort
        if self.wid != -1
        cal popup_close(self.wid)
        let self.wid = -1
        let self.res = []
    endif
endf
fu! s:ac_test.exe() abort
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

" main関数の上に移動しlibやconstなど書くための移動
nnoremap <silent><Leader>H 0<Plug>(edgemotion-k)O

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

