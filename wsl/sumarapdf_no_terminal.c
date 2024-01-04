/*
 * Copyright (C) 2024 Yinzuo Jiang
 */
#include "execute_command.h"

int main(int argc, char** argv) {
  if (argc >= 2) execute_command(argv[1]);
  return 0;
}
