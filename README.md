[![tag](https://img.shields.io/badge/tag-v8.5.2-green)](https://github.com/serna37/dotfiles/releases/tag/v8.5.2)
[![tag_release](https://github.com/serna37/dotfiles/actions/workflows/tag_release.yml/badge.svg?branch=master)](https://github.com/serna37/dotfiles/actions/workflows/tag_release.yml)
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

- [Author Profile](https://github.com/serna37)

## Installation
- `Homebrew`を入れる
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

- このレポジトリでの設定を適用する
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"
```

ちょっとサーバで作業したいときの最低限コマンド
```vim
syntax on | set number laststatus=2 showtabline=2 incsearch hlsearch ignorecase smartcase shortmess-=S
```
また、依存なしを重視した[軽量版vimrc](https://github.com/serna37/dotfiles/blob/master/conf/vim/.vimrc.light)を用意している。

## 関連
- [serna37/library](https://github.com/serna37/library)
(`install.sh`からcloneし設定されます)

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
│   ├── devbox/   : 自作Devコンテナ用設定ファイル
│   ├── gobang/   : gobang用設定ファイル
│   ├── snippets/ : 雑多スニペットファイル
│   ├── sshs/     : sshs用設定ファイル
│   ├── vim/      : vim用追加設定ファイル
│   └── yazi/     : yazi用設定ファイル
│
├── .p10k.zsh     : powerlevel10k設定
├── .vimrc        : vim設定
├── .wezterm.lua  : wezterm設定
├── .zshrc        : zsh設定
│
├── install-docker.sh  : devコンテナ用インストーラ
├── install-mac.sh     : Mac用インストーラ
├── install.sh         : OSで分岐するインストーラ
└── setup.sh           : dotfilesの適用, install.shから呼ばれる
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

