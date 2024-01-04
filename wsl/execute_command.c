#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

void execute_command(char *command) {
  STARTUPINFO si;
  PROCESS_INFORMATION pi;

  ZeroMemory(&si, sizeof(si));
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;
  si.wShowWindow = SW_HIDE;  // 隐藏新的控制台窗口

  ZeroMemory(&pi, sizeof(pi));

  if (!CreateProcess(NULL, command, NULL, NULL, FALSE, 0, NULL, NULL, &si,
                     &pi)) {
    printf("CreateProcess failed (%d).\n", GetLastError());
    system("pause");
    return;
  }

  // 等待子进程结束
  WaitForSingleObject(pi.hProcess, INFINITE);

  // 关闭子进程和主线程的句柄
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);
}
