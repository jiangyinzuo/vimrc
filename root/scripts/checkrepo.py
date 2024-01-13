#!/usr/bin/env python3

import git
import sys
import os


def is_git_worktree(repo_path):
    """
    检查指定仓库是否为 Git worktree
    """
    git_path = os.path.join(repo_path, '.git')
    if os.path.isfile(git_path):
        with open(git_path, 'r') as file:
            content = file.read()
            if content.startswith('gitdir:'):
                return True
    return False


def check_git_status(repo_path='.') -> bool:
    try:
        repo = git.Repo(repo_path)
    except git.InvalidGitRepositoryError:
        print("无效的Git仓库：", repo_path)
        return False

    # 检查是否有未提交的更改
    if repo.is_dirty(untracked_files=True):
        print("存在未提交的更改或未跟踪的文件")
        print(repo.git.status())
        return False

    # 检查所有本地分支
    for branch in repo.branches:
        if branch.tracking_branch() is None:
            print(f"分支 {branch} 没有追踪的远程分支。")
            return False

        # 比较本地分支和远程分支
        commits_ahead = list(repo.iter_commits(
            f'{branch}..{branch.tracking_branch()}'))
        commits_behind = list(repo.iter_commits(
            f'{branch.tracking_branch()}..{branch}'))

        if commits_ahead:
            print(
                f"分支 {branch} 落后于 {branch.tracking_branch()} {len(commits_ahead)} 个提交。")
            sys.exit(1)
        if commits_behind:
            print(
                f"分支 {branch} 超前于 {branch.tracking_branch()} {len(commits_behind)} 个提交。")
            return False

    print("所有检查完成，本地仓库与远程仓库同步。")
    return True


if __name__ == "__main__":
    import argparse
    # checkrepo.py status --repo /path/to/repo
    # checkrepo.py isworktree --repo /path/to/repo
    arg_parser = argparse.ArgumentParser(
        description='检查 Git 仓库状态',
        prog=__file__)
    arg_parser.add_argument(
        'command', help="""
            status: 检查 Git 仓库状态
            isworktree: 检查是否为 Git worktree
            safersync: 同时检查 Git 仓库状态和是否为 Git worktree，仅当Git仓库没有未提交更改、且为Git worktree时，返回0
            """, choices=['status', 'isworktree', 'safersync'])
    arg_parser.add_argument(
        '--repo', help='Git 仓库路径', default='.')

    args = arg_parser.parse_args()
    match args.command:
        case 'status':
            if not check_git_status(args.repo):
                sys.exit(1)
        case 'isworktree':
            print(is_git_worktree(args.repo))
        case 'safersync':
            if not (is_git_worktree(args.repo) and check_git_status(args.repo)):
                print("不是 Git worktree")
                sys.exit(1)
        case _:
            print("未知命令")
            sys.exit(1)
