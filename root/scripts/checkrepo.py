#!/usr/bin/env python3

import git
import sys


def check_git_status(repo_path='.'):
    try:
        repo = git.Repo(repo_path)
    except git.InvalidGitRepositoryError:
        print("无效的Git仓库：", repo_path)
        sys.exit(1)

    # 检查是否有未提交的更改
    if repo.is_dirty(untracked_files=True):
        print("存在未提交的更改或未跟踪的文件")
        print(repo.git.status())
        sys.exit(1)

    # 检查所有本地分支
    for branch in repo.branches:
        if branch.tracking_branch() is None:
            print(f"分支 {branch} 没有追踪的远程分支。")
            sys.exit(1)

        # 比较本地分支和远程分支
        commits_ahead = list(repo.iter_commits(
            f'{branch}..{branch.tracking_branch()}'))
        commits_behind = list(repo.iter_commits(
            f'{branch.tracking_branch()}..{branch}'))

        if commits_ahead:
            print(f"分支 {branch} 落后于 {branch.tracking_branch()} {len(commits_ahead)} 个提交。")
            sys.exit(1)
        if commits_behind:
            print(f"分支 {branch} 超前于 {branch.tracking_branch()} {len(commits_behind)} 个提交。")
            sys.exit(1)

    print("所有检查完成，本地仓库与远程仓库同步。")


if __name__ == "__main__":
    import sys
    check_git_status(sys.argv[1])
