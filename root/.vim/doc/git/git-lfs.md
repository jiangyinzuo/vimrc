使用 Git Large File Storage (LFS) 时，如果你希望在克隆仓库时不自动下载大文件，可以采取以下步骤：

1. **克隆时禁用 Git LFS：** 在克隆仓库时，你可以使用 `GIT_LFS_SKIP_SMUDGE=1` 环境变量来禁用自动下载 LFS 对象。命令如下：

   ```bash
   GIT_LFS_SKIP_SMUDGE=1 git clone <repository-url>
   ```

   这个命令会克隆仓库，但不会下载 LFS 管理的文件。相反，它会下载这些文件的指针文件。

2. **稍后按需下载文件：** 如果之后你需要某个或某些 LFS 管理的文件，可以使用 `git lfs pull` 命令下载它们。你可以选择性地指定一个文件路径或使用通配符来下载特定的 LFS 文件。

   ```bash
   git lfs pull
   # 或者
   git lfs pull --include="path/to/file"
   ```

3. **配置仓库以禁用自动下载：** 如果你经常需要以这种方式工作，可以在仓库的配置中设置这个选项，这样每次克隆时都不会自动下载 LFS 文件。

   ```bash
   git config lfs.fetchexclude '*'
   ```

   这将为当前仓库设置一个配置项，告诉 Git LFS 默认不下载任何文件。你可以在需要时手动下载特定文件。

使用这种方法，你可以更好地控制何时下载大文件，特别是在带宽有限或只需查看仓库历史记录时非常有用。
