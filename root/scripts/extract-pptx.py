#!/bin/python3

from pptx import Presentation
from pptx.enum.shapes import MSO_SHAPE_TYPE
from pptx.enum.shapes import PP_PLACEHOLDER


# 定义一个函数，用于打印带缩进和bullet的段落文本
def _print_indented_text(paragraph):
    if len(paragraph.text) == 0:
        return
    indent_level = paragraph.level
    # 根据缩进级别添加制表符
    indent = '\t' * indent_level
    # 添加bullet或其他符号，如果有的话
    bullet_symbol = '- ' if indent_level > 0 else ''
    # 打印缩进和bullet后的段落文本
    print(f"{indent}{bullet_symbol}{paragraph.text}")


def extract_pptx(pptx_file: str):
    prs = Presentation(pptx_file)
    for i, slide in enumerate(prs.slides):
        print(f"=== Slide {i + 1}\n")
        for shape in slide.shapes:
            if hasattr(shape, "text"):
                # 遍历文本框中的每一个段落
                for paragraph in shape.text_frame.paragraphs:
                    _print_indented_text(paragraph)
                    pass
                print()


if __name__ == '__main__':
    from sys import argv
    if len(argv) != 2:
        print("Usage: extract-pptx.py <pptx file>")
        exit(1)
    extract_pptx(argv[1])
