" 先頭空白と改行コードを除く行選択
nnoremap vv ^v$h

" シェルで辺なことするので無効化
nnoremap K :echo 'K'<CR>

" 提出用圧縮コピペ
fu! Fmt4Submisstion() abort
    " 0. clangdが停止しているとフォーマッタ機能しないので再読み込み
    w | e!
    " (debugライブラリ直書き時用)
    " 1. debug定義を削除
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
    " 2. debugのincludeを削除
    let row = 0
    for v in getline(0, '$')
        let row += 1
        if v == '#include <bits/debug.hpp>'
            cal setline(row, '')
            break
        endif
    endfor
    " 3. debug出力も削除
    try | %s/debug(.*/ /g | catch
    endtry
    " 4. //から右を全て削除
    try | %s/\/\/.*/ /g | catch
    endtry
    " 5. フォーマッタ、保存、全コピ
    cal CocAction('format')
    w
    %y
    " end. 一番上にいく
    cal cursor(1, 1)
    cal popup_notification(['⭐️ 圧縮&コピー完了⭐️'], #{line: &lines/2, col: &columns/3})
endf
nnoremap <silent><Leader>u :<C-u>cal Fmt4Submisstion()<CR><Esc>

" clangd(LSP)再起動のため、バッファ再読み込み
nnoremap <silent><Leader>l :<C-u>w<CR>:e!<CR>zz

" 定数等の記述のためにヘッド(main関数の1行上)に行く
nnoremap <silent><Leader>H 0<Plug>(edgemotion-k)O

" SANDBOX 連番ファイル作成
fu! s:asc(x, y) abort
    return a:x == a:y ? 0 : a:x > a:y ? 1 : -1
endf
fu! SandboxNextCpp() abort
    let f = system('\fd -d 1 -t f')->split('\n')
    let arr = []
    for v in f
        if stridx(v, 'cpp') != -1
            let a = split(v, '.cpp')[0]
            let a = str2nr(a)
            cal add(arr, a)
        endif
    endfor
    cal sort(arr, "s:asc")
    let next = (arr[-1] + 1) . ".cpp"
    call execute('e '.next)
endf
com! SandboxNextCpp cal SandboxNextCpp()

