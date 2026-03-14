set auto-load safe-path /
source /root/vimrc/root/gdb-dashboard.gdb
# 重新定义布局，剔除 source 模块，保留其他常用底层模块
dashboard -layout assembly registers stack threads memory expressions
# 将 prompt 修改为醒目的高亮青色
dashboard -style prompt '\033[1;36m(gdb)\033[0m'

# 开启结构体和类的漂亮打印（自动缩进和换行），这是最核心的美化命令（gdb-dashboard已设置）
# set print pretty on
# 开启数组的漂亮打印（按索引垂直排列）
# set print array on
# 打印 C++ 多态对象时，打印其实际的派生类型，而不是指针声明时的基类类型
set print object on
# 打印字符串和数组时，取消默认的长度限制（默认打印到一定长度会显示 "..."）
set print elements unlimited
# 打印包含虚函数的 C++ 对象时，隐藏虚函数表指针（让输出更干净，专注于数据成员）
set print vtbl off
# 在结构体中打印联合体时，不显示联合体的内部结构
set print union off
