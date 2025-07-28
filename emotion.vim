nnoremap s :<C-u>cal <SID>emotion()<CR>
let s:keys=['s','w','a','d','j','k','h','l']
let s:all_combinations=[]
fu! s:gen_comb(str,k,M)" keysでM桁の文字列を全組み合わせ作る
    if a:k==a:M|cal add(s:all_combinations,a:str)|retu|endif" 桁満たした
    for ch in s:keys|cal s:gen_comb(a:str.ch,a:k+1,a:M)|endfor" keysの各要素を今のに追加して再帰
endf
fu! s:emotion()
    echohl User3|echom 'emotion'|echohl None|hi Wip ctermfg=166 cterm=bold
    let [c1,c2]=[nr2char(getchar()),nr2char(getchar())]" 入力を2文字とる
    let [sl,el,cl,cc,ctx]=[line('w0'),line('w$'),line('.'),col('.'),getline('w0','w$')]
    sil! exe 'e emotion'|setl buftype=nofile bufhidden=wipe nobuflisted" 偽のバッファを作る
    cal setline(1,range(1,el))|cal setline(sl,ctx)|cal cursor(sl+5,cc)|norm! zt|cal cursor(cl,cc)
    hi Base ctermfg=59|cal matchadd('Base','.',100)|redraw
    " TODO 単語の先頭を、case無視で検索、位置を取得
    let pos=[]
    "この型
    cal add(pos,#{line:7,col:5,key:'ss'})
    cal add(pos,#{line:15,col:3,key:'aa'})

    let len=1|while pow(len(s:keys),len)<len(pos)|let len+=1|endwhile" 必要な桁数を知る
    let s:all_combinations=[]|cal s:gen_comb("",0,len)" 各posのキーを作る
    for i in range(len(pos))|let pos[i].key=s:all_combinations[i]|endfor
    for v in range(1,len)" キー入力を監視、押されたら描画更新
        echom pos
        " TODO posに従ってバッファを描画、setline
        ""let hlpos_wip = []
        ""let hlpos_fin = []
        ""for r in a:keypos
        ""    let line = getline(r.row)
        ""    for c in r.col
        ""        let colidx = c.pos-1
        ""        let view_keystroke = c.key[:0]
        ""        let offset = colidx-1
        ""        cal add(hlpos_fin, [r.row, c.pos])
        ""        if len(c.key)>=2
        ""            let view_keystroke = c.key[:1]
        ""            cal add(hlpos_wip, [r.row, c.pos, 2])
        ""        endif
        ""        let line = colidx == 0
        ""            \ ? view_keystroke.line[len(view_keystroke):]
        ""            \ : line[0:offset].view_keystroke.line[colidx+len(view_keystroke):]
        ""    endfor
        ""    cal setline(r.row, line)
        ""endfor

        "for t in hlpos_wip
            " cal matchaddpos('Wip', [t], 100)
        "endfor"
        redraw
        let w=nr2char(getchar())" 入力でposを絞りkeyを更新
        let pos=filter(pos,{_,v->v.key=~'^'.w})->map({_,v->#{line:v.line,col:v.col,key:strpart(v.key,1)}})
    endfor
    b #|cal getmatches()->filter({_,v->match(['Wip','Base'],v.group)!=-1})->map({_,v->matchdelete(v.id)})
    if !empty(pos)|cal cursor(pos[0].line,pos[0].col)|endif" バッファ閉じて、カーソル移動
    echohl User1|echom 'emotion: fin'|echohl None
endf

