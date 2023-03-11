WSL创建软链接文件夹			mklinkd 2023-03-07-1  /mnt/d/doc2/group-meeting/readinggroup/2023-03-07-1


git提交把作者改成自己			git commit --amend --reset-author --no-edit
ssh生成key				1) ssh-keygen -t rsa -C '邮件地址@youremail.com'		2) cat ~/.ssh/id_rsa.pub
git回退版本				git reset --soft 需要回退的commit hash
git 先暂存自己的修改，再pull别人的提交	1) git stash 	2) git pull 	3) git pop
git复制某一分支				git remote set-url
git合并commit 				git reset

---

# git diff/merge

git difftool					git difftool HEAD mydoc.txt` or `git difftool -- mydoc.txt HEAD

git mergetool

tutorial: https://gist.github.com/karenyyng/f19ff75c60f18b4b8149

clean-LOCAL-BASE-REMOTE-files			git clean -i

---

# git checkout

撤销某一个文件的修改			git checkout -- 文件名
git checkout 可以checkout部分文件到某一次提交/分支。可以用于回滚部分文件。

git checkout历史文件			git checkout v0.2.2 -- markdown.vim

---

# Git在单体仓库中pull部分文件

monorepo

以clone [etcd/raft](https://github.com/etcd-io/etcd/tree/main/raft)为例

## partial clone

```
git clone --no-checkout https://hub.fastgit.org/etcd-io/etcd.git etcd_raft3 --depth=1 --filter=blob:none or git clone --no-checkout https://hub.fastgit.org/etcd-io/etcd.git etcd_raft3 --depth=1 --filter=tree:0
```

blob代表文件，tree代表文件夹。后者文件大小似乎略小一点。

## sparse-checkout

```
cd etcd_raft3 git sparse-checkout init git sparse-checkout set '!/*/' '/raft/' git checkout main
```

当git版本>=2.32.0时，可以添加在`git sparse-checkout init`中添加`--sparse-index`选项进一步减小git文件大小，见 [https://git-scm.com/docs/git-sparse-checkout/2.32.0](https://git-scm.com/docs/git-sparse-checkout/2.32.0)

最后只有raft目录在项目文件夹中。 `git sparse-checkout list` 可以查看当前sparse-checkout的规则。

其它参考资料： [https://github.blog/tag/monorepo/](https://github.blog/tag/monorepo/) [https://github.blog/2020-01-17-bring-your-monorepo-down-to-size-with-sparse-checkout/](https://github.blog/2020-01-17-bring-your-monorepo-down-to-size-with-sparse-checkout/) [https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/](https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/)

---

藏匿当前正在修改，但尚未commit的工作区。适合临时保存、切换工作区（比如临时hotfix）		git stash


