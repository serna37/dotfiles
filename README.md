[![tag](https://img.shields.io/badge/tag-v9.4.1-green)](https://github.com/serna37/dotfiles/releases/tag/v9.4.1)

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
- コマンド等の追加時は[.zshrc.lazyload](https://github.com/serna37/dotfiles/blob/master/conf/zsh/.zshrc.lazyload)を改修
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"
```

## 軽量版
依存のない設定ファイルを用意しています
- [軽量版zshrc](https://github.com/serna37/dotfiles/blob/master/conf/light/.zshrc.light)
- [軽量版vimrc](https://github.com/serna37/dotfiles/blob/master/conf/light/.vimrc.light)

## 一時コピペ用
- zsh
```zsh
alias v='vim'
alias l='ls -AFlihrt --color=auto'
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'"
alias rm='rm -i'
alias q='exit'
```
- vim
```vim
syntax on | set number laststatus=2 showtabline=2 incsearch hlsearch ignorecase smartcase shortmess-=S noswapfile nobackup noundofile fileformat=unix fileencoding=utf8 clipboard+=unnamed list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
```

## 関連
- [serna37/library](https://github.com/serna37/library)を導入します
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
│   ├── devbox/   : 自作Devコンテナ用設定ファイル
│   ├── snippets/ : 雑多スニペットファイル
│   ├── ssh/      : ssh用設定ファイル
│   ├── vim/      : vim用設定ファイル
│   └── zsh/      : zsh用設定ファイル
│
├── .gitconfig    : git設定
├── .vimrc        : vim設定
├── .wezterm.lua  : wezterm設定
├── .zshrc        : zsh設定
│
└── install.sh    : OSで分岐するインストーラ
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

