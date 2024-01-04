/*
 * Copyright (C) 2024 Yinzuo Jiang
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "execute_command.h"

int main(int argc, char** argv) {
  if (argc >= 2 && strncmp(argv[1], "mycmd://", 8) == 0) {
    char cmd[1024];
    strcpy(cmd, "cmd.exe /c start \"\" ");
    strcat(cmd, argv[1] + 8);
    execute_command(cmd);
  } else {
    printf("Usage: %s mycmd://<command>\n", argv[0]);
    system("pause");
  }
  return 0;
}
