# dotfiles

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces?repository_id=661965495)

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

- lazyinstall式を採用しており、初期投入以外のコマンドは必要な時にinstallされます
- .zshrc中で設定ファイルが作成されます
- CodeSpacesのdotfiles自動適用に対応しています

## Installation

Macのセットアップ手順です。まずは`Command Line Tools`を導入。
```shell
xcode-select --install
```

本repoの`install.sh`で以下を行います。

- brew、基本コマンド、ツールをインストール
- このrepoの設定ファイルをシンボリックリンク

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/install.sh)"
```

> [!Note]
> ChromeはPC初期化時点で手動で入れる想定。

必要に応じてvimのためのコマンドを実行。

- vim-plugでプラグインを入れる
```sh
vim_init
```

- codium認証のために以下URLへのアクセス
```sh
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

## 関連

- C++関連では[このライブラリ](https://github.com/serna37/library-cpp)を使用します
- TUIコマンドは主に[Terminal Trove](https://terminaltrove.com/)から選んでいます

## dotfiles構成

<!-- file tree -->
<a href="https://tree.nathanfriend.io/">
  <img src="https://img.shields.io/badge/file-tree-lightgray.svg?logo=files&style=flat">
</a>

```txt
.
├── bk/
│   └── **        : すぐ参照したい、過去のファイル
│
├── .p10k.zsh     : zsh 外観設定
├── .vimrc        : vim設定
├── .zshrc        : zsh設定
├── config.toml   : mise設定(ツールバージョン・環境変数・カスタムコマンド)
├── cpp.snippets  : C++向けスニペット
├── cpp.zsh       : C++向けカスタムコマンド
├── ghostty_config: Ghosttyターミナル設定
└── install.sh    : インストーラ
```

---

> [!Note]
> - コードの署名: [参考](https://blog.symdon.info/posts/1610113408/)

