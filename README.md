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
- このレポジトリでの設定を適用する(Macの場合Homebrewを導入します)
- lazyinstall式を採用しており、初期投入以外のコマンドは、必要な時にinstallされます
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"
```

## 軽量版
依存のない設定ファイルを用意しています
- [軽量版zshrc](https://github.com/serna37/dotfiles/blob/master/conf/light/.zshrc.light)
- [軽量版vimrc(古い、本体vimrcでよい)](https://github.com/serna37/dotfiles/blob/master/conf/light/.vimrc.light)

## 一時コピペ用
- zsh
```zsh
alias l='ls -AFlihrt --color=auto'
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
alias rm='rm -i'
alias q='exit'
```
- vim
```vim
set fileformat=unix fileencoding=utf8 noswapfile nobackup noundofile hidden autoread clipboard+=unnamed background=dark title showcmd list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:% number relativenumber signcolumn=yes scrolloff=5 cursorline cursorcolumn ruler laststatus=2 showtabline=2 notitle splitright virtualedit=all whichwrap=b,s,h,l,<,>,[,],~ backspace=indent,eol,start showmatch matchtime=3 autoindent smartindent smarttab shiftwidth=4 tabstop=4 expandtab wildmenu wildchar=<Tab> wildmode=full complete=.,w,b,u,U,k,kspell,s,i,d,t completeopt=menuone,noinsert,preview,popup incsearch hlsearch ignorecase smartcase shortmess-=S belloff=all ttyfast regexpengine=0 foldmethod=marker foldlevel=1 | let &titleold=getcwd() | syntax on | filetype plugin on | au QuickFixCmdPost *grep* cwindow
```

## 関連
- (古い) [serna37/library](https://github.com/serna37/library)を導入します
- 主に[Terminal Trove](https://terminaltrove.com/)からコマンドを選んでいます

## dotfiles構成
<!-- file tree -->
<a href="https://tree.nathanfriend.io/">
  <img src="https://img.shields.io/badge/file-tree-lightgray.svg?logo=files&style=flat">
</a>

```
.
├── conf/
│   ├── config/   : ~/.config配下のファイル
│   ├── cpp/      : C++用設定ファイル デバッグ、フォーマット設定等
│   ├── devbox/   : (削除)自作Devコンテナ用設定ファイル
│   ├── snippets/ : (古い)雑多スニペットファイル
│   ├── ssh/      : ssh用設定ファイル
│   ├── vim/      : vim用設定ファイル
│   └── zsh/      : zsh用設定ファイル
│
├── .gitconfig    : git設定
├── .vimrc        : vim設定
├── .wezterm.lua  : wezterm設定
├── .zshrc        : zsh設定
│
└── install.sh    : インストーラ
```

---

> [!Note]
> - コードの署名: [参考](https://blog.symdon.info/posts/1610113408/)
> - Finderのキルを有効化するコマンド
> ```
> defaults write com.apple.Finder QuitMenuItem -boolean true
> ```
> - Finderが`.DS_sotre`を作らないようにするコマンド
> ```
> defaults write com.apple.desktopservices DSDontWriteNetworkStores True
> ```

