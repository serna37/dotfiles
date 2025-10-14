[![tag](https://img.shields.io/badge/tag-v9.5.0-green)](https://github.com/serna37/dotfiles/releases/tag/v9.5.0)

# dotfiles
<a href="https://github.com/serna37/dotfiles/blob/master/install.sh">
    <img src="http://img.shields.io/badge/homebrew-4.2.21-FBB040.svg?logo=homebrew&logoColor=FBB040&labelColor=fafffe&style=for-the-badge">
</a>
<br />
<a href="https://github.com/serna37/dotfiles/blob/master/.zshrc">
    <img src="http://img.shields.io/badge/zsh-5.9_x86_64-0000cd.svg?logo=zsh&logoColor=0000cd&labelColor=a3a3a3&style=popout-square">
</a>
<a href="https://github.com/serna37/dotfiles/blob/master/.vimrc">
    <img src="http://img.shields.io/badge/vim-9.0-019733.svg?logo=vim&logoColor=019733&labelColor=dedede&style=popout-square">
</a>

## Installation
- このレポジトリでの設定ファイルをシンボリックリンクします
- lazyinstall式を採用しており、初期投入以外のコマンドは、必要な時にinstallされます
- zshrc中で、必要に応じて設定ファイルが作成されます

> [!Note]
> ChromeはPC初期化時点で手動で入れる
> その他の必要なアプリはinstall.shで入れる

まずは`Command Line Tools`を導入します
```shell
xcode-select --install
```

続いてHomebrewを導入します(sudo権限承認が必要です)
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

本レポのinstall.shを実行します
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"
```

必要に応じてvimのためのコマンドを実行
```sh
# vim-plugを入れる
curl -fSsLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && vim -c "PlugInstall
# codium認証のために以下URLへのアクセス
https://www.codeium.com/profile?response_type=token&redirect_uri=vim-show-auth-token&state=a&scope=openid%20profile%20email&redirect_parameters_type=query
```

## 一時コピペ用
- shell
```shell
alias l='ls -AFlihrt --color=auto'
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
alias rm='rm -i'
alias re='exec $SHELL -l'
alias q='exit'
```
- vim
```vim
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1|let &titleold=getcwd()|syntax on|filetype plugin on|au QuickFixCmdPost *grep* cwindow
inoremap <C-l> <right>|inoremap <C-h> <left>
vnoremap <C-j> "zx"zp`[V`]|vnoremap <C-k> "zx<Up>"zP`[V`]
inoremap ( ()<left>|inoremap [ []<left>|inoremap { {}<left>|inoremap ` ``<left>|inoremap ' ''<left>|inoremap " ""<left>
inoremap <expr>) getline('.')[col('.')-1] == ")" ? "\<right>" : ")"
inoremap <expr>] getline('.')[col('.')-1] == "]" ? "\<right>" : "]"
inoremap <expr>} getline('.')[col('.')-1] == "}" ? "\<right>" : "}"
inoremap <expr><BS> (len(getline('.'))>=col('.')&&match(["()", "[]", "{}", "``","''", '""'], getline('.')[col('.')-2:col('.')-1])!=-1)?(col('.')>1?"\<right>\<BS>\<BS>":"\<BS>"):"\<BS>"
nnoremap vv ^v$h
nnoremap j gj|nnoremap k gk
nnoremap <Tab> 5j|nnoremap <S-Tab> 5k|vnoremap <Tab> 5j|vnoremap <S-Tab> 5k
nnoremap <silent><C-u> :<C-u>cal <SID>scroll(0,25)<CR>|nnoremap <silent><C-d> :<C-u>cal <SID>scroll(1,25)<CR>
nnoremap <silent><C-b> :<C-u>cal <SID>scroll(0,15)<CR>|nnoremap <silent><C-f> :<C-u>cal <SID>scroll(1,15)<CR>
fu! s:scroll(vector,delta)
    let tid=timer_start(a:delta,{->feedkeys(a:vector?"\<C-e>":"\<C-y>")},{'repeat':-1})
    cal timer_start(600,{->timer_stop(tid)})
endf
nnoremap <silent><C-n> :<C-u>bp<CR>|nnoremap <silent><C-p> :<C-u>bn<CR>|nnoremap <silent><Space>x :<C-u>bd<CR>
au BufRead * if line("'\"")>0&&line("'\"")<=line("$")|exe "norm g`\""|endif
nnoremap # *N|nnoremap <silent><Space>q :<C-u>noh<CR>
nnoremap <silent><Space>g :<C-u>exe "vim /".expand("<cword>")."/gj ".(system('git status')=~'fatal'?'** **/.':join(split(system('git ls-files'))))<CR>:echo "Quickfix移動:cn cp"<CR>
nnoremap <silent>cn :<C-u>cn<CR>|nnoremap <silent>cp :<C-u>cp<CR>
set splitbelow termwinkey=<C-e>
au ColorScheme * hi User1 cterm=bold ctermfg=235 ctermbg=39
au ColorScheme * hi User2 cterm=bold ctermfg=235 ctermbg=114
au ColorScheme * hi User3 cterm=bold ctermfg=235 ctermbg=204
au ColorScheme * hi User4 cterm=bold ctermfg=235 ctermbg=180
au ColorScheme * hi User5 cterm=bold ctermfg=235 ctermbg=170
let LF={'dos':'CRLF','unix':'LF','mac':'CR'}
fu! SetStatusLine()
    let dict={'i':'1* INSERT','n':'2* NORMAL','R':'3* REPLACE','c':'4* COMMAND','t':'4* TERMIAL','v':'5* VISUAL','V':'5* VISUAL',"\<C-v>":'5* VISUAL'}
    retu '%'.(match(keys(dict),mode())!=-1?dict[mode()]:"5* SP").' %* %<%F%m%r%h%w%=%2* %p%% %l/%L %02v | %{&filetype} | %{&fenc!=""?&fenc:&enc} | %{LF[&ff]} %*'
endf
set statusline=%!SetStatusLine()
fu! SetTabLine()
    let s=''
    for b in range(1,bufnr('$'))
        if bufexists(b)&&buflisted(b)
            let n=empty(bufname(b))?'[No Name]':fnamemodify(bufname(b),':t')
            let m=getbufvar(b,'&modified')?'*':''
            let s.=(b==bufnr('%')?'%#TabLineSel#':'%#TabLine#').'%'.b.'T '.n.m.' '
        endif
    endfor
    retu s.'%#TabLineFill#'
endf
set tabline=%!SetTabLine()
```

## 関連
- 主に[Terminal Trove](https://terminaltrove.com/)からコマンドを選んでいます

## dotfiles構成
<!-- file tree -->
<a href="https://tree.nathanfriend.io/">
  <img src="https://img.shields.io/badge/file-tree-lightgray.svg?logo=files&style=flat">
</a>

```
.
├── conf/
│   ├── cpp/      : C++用設定ファイル デバッグ、フォーマット設定等
│   ├── snippets/ : (削除予定)雑多スニペットファイル
│   ├── vim/      : (削除予定)vim用設定ファイル
│   └── zsh/      : (メンテ要: cpp系をcppに移動しフォルダ削除)zsh用設定ファイル
│
├── .vimrc        : vim設定
├── .wezterm.lua  : wezterm設定
├── .zshrc        : zsh設定
├── config.toml   : mise設定(ツールバージョン・環境変数・カスタムコマンド)
│
└── install.sh    : インストーラ
```

---

> [!Note]
> - コードの署名: [参考](https://blog.symdon.info/posts/1610113408/)

