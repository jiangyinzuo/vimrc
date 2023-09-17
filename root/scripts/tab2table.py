#!/bin/python3

"""
Usage in vim:
    :'<,'>!tab2table.py
"""


def tab_format(lines: list):
    if len(lines) == 0:
        return

    header_lines = []
    for i in range(len(lines[0])):
        # find max length of cell
        max_len_of_cell = 0
        for line in lines:
            max_len_of_cell = max(max_len_of_cell, len(line[i]))

        header_lines.append('-' * max_len_of_cell)

        # add tab to each cell
        for line in lines:
            line[i] = line[i] + ' ' * (max_len_of_cell - len(line[i]))

    lines.insert(1, header_lines)
    for line in lines:
        print('| ' + ' | '.join(line) + ' |')


def main():
    lines = []
    while True:
        try:
            line = input()
            lines.append(line.split())
        except EOFError:
            break
    tab_format(lines)


if __name__ == '__main__':
    main()
