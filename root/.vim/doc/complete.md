在没有插件的情况下，Vim 提供了一些基础的代码自动补全选项。其中最常用的可能是 Omnicomplete 和关键字补全。

1. **Omnicomplete（全能补全）**: Omnicomplete 可以对诸如 C/C++, Python, Java 等编程语言进行上下文相关的补全。使用 `<C-x><C-o>`（按住 `Ctrl` 键然后依次按 `x` 和 `o`）来触发 Omnicomplete。

2. **关键字补全**: 使用 `<C-n>` 和 `<C-p>` 可以进行关键字补全。这个功能会查找当前打开的所有文件，找到与你已经键入的文本匹配的单词。

3. **行补全**: 使用 `<C-x><C-l>` 可以补全整行。这在编写具有重复模式的代码时非常有用。

4. **文件名补全**: `<C-x><C-f>` 可以用来补全文件名。

5. **字典补全**: 通过在 `.vimrc` 文件中设置字典，你可以使用 `<C-x><C-k>` 来进行字典补全。

6. **标签补全**: 如果你有一个标签文件（通常由 `ctags` 程序生成），你可以使用 `<C-x><C-]>` 来进行标签补全。

例如，在 `.vimrc` 中为 Python 设置 Omnicomplete：

```vim
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
```

虽然 Vim 的内建补全功能相对较弱，但是它们是可用的，并且在没有插件的情况下也能提供一定程度的自动补全支持。如果你需要更高级的功能，那通常需要依赖外部插件，比如 `YouCompleteMe` 或 `Coc.nvim`。


`filetype plugin on` 通常是启用 Omnicomplete（全能补全）所需的。这个设置不仅激活 Vim 的文件类型检测机制，还启用了针对各种文件类型的插件，这其中就包括 Omnicomplete 功能。

在你的 `.vimrc` 文件里，你可能会看到这样的设置：

```vim
filetype plugin on
```

或者更全面地：

```vim
filetype plugin indent on
```

这样也会启用针对不同文件类型的自动缩进。

设置了 `filetype plugin on` 之后，Vim 会根据当前文件的类型来加载相应的插件。这些插件通常会设置一些特定于该文件类型的行为，比如补全函数、语法高亮等。对于像 Python 这样的编程语言，这通常也会设置一个适当的 `omnifunc`（全能补全函数），从而使得 `<C-x><C-o>` 可以工作。

所以，如果你想用 Omnicomplete，确保在 `.vimrc` 文件中启用了 `filetype plugin on` 是一个好主意。
