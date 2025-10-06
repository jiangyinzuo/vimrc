#!/bin/python3

"""
Converts tab-separated data into a formatted markdown table.

Usage in vim:
    :'<,'>!tab2table.py

Input: Tab-separated values from stdin
Output: Formatted markdown table to stdout

Example input:
    Name	Age	City
    Alice	25	New York
    Bob	30	London

Example output:
    | Name  | Age | City     |
    | ----- | --- | -------- |
    | Alice | 25  | New York |
    | Bob   | 30  | London   |
"""


def tab_format(lines: list):
    if len(lines) == 0:
        return

    header_lines = []
    # Calculate maximum width for each column
    for i in range(len(lines[0])):
        # find max length of cell in this column
        max_len_of_cell = 0
        for line in lines:
            max_len_of_cell = max(max_len_of_cell, len(line[i]))

        # Create header separator line for markdown table
        header_lines.append('-' * max_len_of_cell)

        # Pad each cell in the column to the maximum width
        for line in lines:
            line[i] = line[i] + ' ' * (max_len_of_cell - len(line[i]))

    # Insert header separator line after the first row (header)
    lines.insert(1, header_lines)
    # Print the formatted markdown table
    for line in lines:
        print('| ' + ' | '.join(line) + ' |')


def main():
    lines = []
    while True:
        try:
            line = input()
            # Split each line by tabs to get individual cells
            lines.append(line.split('\t'))
        except EOFError:
            # End of input reached
            break
    tab_format(lines)


if __name__ == '__main__':
    main()
