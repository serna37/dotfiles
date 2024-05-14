# brew cask install
repos=(
wezterm
maccy
keycastr
)

echo "=========================================================="
echo "brew cask install"
echo "=========================================================="
for v in ${repos[@]}; do
    echo "=========================================================="
    echo "${v}"
    echo "=========================================================="
    brew reinstall --cask ${v}
done


