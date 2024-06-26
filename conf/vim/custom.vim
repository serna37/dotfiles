" =====================================================================
" LSPのための追加設定
" =====================================================================
" LSP再起動のため、バッファ再読み込み
nnoremap <silent><Leader>l :<C-u>w<CR>:e!<CR>zz:<C-u>echo 'Reload Buffer'<CR>

" SNIPモードを強制終了 (バッファ再読み込み)
inoremap <silent><C-k> <Esc>:<C-u>w<CR>:e!<CR>zza

" =====================================================================
" 高速編集のための設定
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

" =====================================================================
" その他
" =====================================================================
" シェルで変なことするので無効化
nnoremap K :<C-u>echo 'K'<CR>

" sandboxで連番ファイル作成
fu! s:asc(x, y) abort
    return a:x == a:y ? 0 : a:x > a:y ? 1 : -1
endf
fu! s:sandboxNextCpp() abort
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
com! SandboxNextCpp cal <SID>sandboxNextCpp()

