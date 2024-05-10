" 先頭空白と改行コードを除く行選択
nnoremap vv ^v$h

" シェルで辺なことするので無効化
nnoremap K :echo 'K'<CR>

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

