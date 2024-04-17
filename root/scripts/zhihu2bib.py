#!/usr/bin/env -S env python3

# Example:
# Nvidia Tensor Core初探 - 木子知的文章 - 知乎
# https://zhuanlan.zhihu.com/p/620185229
#
# Output:
# @misc{Nvidia_Tensor_Core初探_-_木子知的文章_-_知乎,
# title = {Nvidia Tensor Core初探 - 木子知的文章 - 知乎},
# url = {https://zhuanlan.zhihu.com/p/620185229}
# }

zhihu_link = []
while True:
    try:
        zhihu_link.append(input())
    except EOFError:
        break

assert len(zhihu_link) == 2

title: str = zhihu_link[0]
url: str = zhihu_link[1]

# substitute space with underscore
reference: str = title.replace(' ', '_').replace('（', '(').replace('）', ')')

print(f"""
@misc{{{reference},
      title = {{{title}}},
      url = {{{url}}},
}}""")

