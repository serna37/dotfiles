# dotfiles
## installation
- `Homebrew`を入れる
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

- このレポジトリを設定する
  - 本レポのclone
  - 関連するものも設定される
```sh
INSTALL_FILES=(
brew.sh
brew-cask.sh
install.sh
)
for v in ${INSTALL_FILES[@]}; do
    curl -fsSL https://raw.githubusercontent.com/serna37/dotfiles/master/${v} | sh
done && exec $SHELL -l
```

## relate
- [serna37/library](https://github.com/serna37/library)

---

> [!Note]
> - コードの署名: [参考](https://blog.symdon.info/posts/1610113408/)
> - Finderのキル
> ```
> defaults write com.apple.Finder QuitMenuItem -boolean true
> ```
