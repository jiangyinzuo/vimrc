wget --output-document root/z.sh https://github.com/rupa/z/raw/master/z.sh &
wget --output-document root/fzf/fzf-git.sh https://github.com/junegunn/fzf-git.sh/raw/main/fzf-git.sh &
wget --output-document root/scripts/lsix https://github.com/hackerb9/lsix/raw/master/lsix &
wget --output-document root/scripts/v https://github.com/rupa/v/raw/master/v &
wget --output-document root/goto.sh https://github.com/iridakos/goto/raw/master/goto.sh &

# Satanson's perl scripts: https://github.com/satanson/cpp_etudes
# C++阅码神器cpptree.pl和calltree.pl的使用 - satanson的文章 - 知乎 https://zhuanlan.zhihu.com/p/339910341
for perl_script in calltree.pl java_calltree.pl cpptree.pl javatree.pl deptree.pl ; do
	( wget --output-document root/scripts/$perl_script https://github.com/satanson/cpp_etudes/raw/master/$perl_script && chmod +x root/scripts/$perl_script ) &
done

wait
