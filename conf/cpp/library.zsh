#!/bin/zsh

# clone
cd ~/git && git clone https://github.com/serna37/library

# profile
library_root=~/git/library/
snippet_dir=~/.vim/UltiSnips/
dotfiles_snippet_dir=~/git/dotfiles/conf/cpp/snippets
trigger_prefix=lib
work_dir=__work

# whitelist
cd $dotfiles_snippet_dir
no_del=($(ls))

if command -v genact > /dev/null 2>&1; then
    genact -s 10 --exit-after-modules 1 -m botnet
fi
echo "===================================================="
echo " START"
echo "===================================================="

sleep 0.5
echo " >> STEP1. DELETE old snippets ( without whitelist )"
cd $snippet_dir
for v in $(\find . -maxdepth 1 -type f ! -name '${no_del[@]}'); do
    rm "$v"
done

sleep 0.5
echo " >> STEP2. GENERATE snippets up to over 200 char"
cd $library_root
files=($(\find . -mindepth 2 -type f -not -path '*/.*'))
mkdir $work_dir
cnt=1
create=$work_dir/$cnt.snippets
touch $create
line=0
for v in $files; do
    l=$(wc -l < $v)
    if [[ $((line + l + 2))  -gt 200 ]] then
        ((cnt++))
        line=0
        create=$work_dir/$cnt.snippets
        touch $create
    fi
    ((line += l + 2))
    # ./aaa/bbb.hpp -> ._aaa_bbb.hpp
    file=${${v}//\//_}
    # _aaa_bbb hpp
    sni=(${(s:.:)file})
    # ww_aaa_bbb
    echo "snippet $trigger_prefix$sni[1] \"\" b" >> $create
    # ヘッダ2行を無視
    tail -n +3 $v >> $create
    echo "endsnippet" >> $create
done

sleep 0.5
echo " >> STEP3. Move snippets files for extension root ( $snippet_dir )"
cd $library_root/$work_dir
generated=(*.snippets)
mv *.snippets $snippet_dir
cd $library_root && rm -r $work_dir

sleep 0.5
echo " >> STEP4. Bundle snippets in the root file"
cd $snippet_dir
root_sni=cpp.snippets
echo "# generate: $(date '+%Y-%m-%d %H:%M:%S')" > $root_sni
for v in $no_del; do
    if [[ $v == "cpp.snippets" ]]; then
      continue
    fi
    echo "extends ${v:r}" >> $root_sni
done
for v in $generated; do
    echo "extends ${v:r}" >> $root_sni
done

echo "===================================================="
echo " DONE"
echo "===================================================="
if command -v genact > /dev/null 2>&1; then
    genact -s 10 --exit-after-modules 1 -m bruteforce
fi

