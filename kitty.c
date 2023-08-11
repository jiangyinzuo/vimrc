/*
 * Copyright (C) 2023 Yinzuo Jiang
 */
// gcc -o no_terminal.exe sumarapdf_no_terminal.c -mwindows
#include <windows.h>

#include <stdio.h>

void execute_command(char *command) {
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;  // 隐藏新的控制台窗口

    ZeroMemory(&pi, sizeof(pi));

    if (!CreateProcess(NULL, command, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        printf("CreateProcess failed (%d).\n", GetLastError());
        return;
    }

    // 等待子进程结束
    WaitForSingleObject(pi.hProcess, INFINITE);

    // 关闭子进程和主线程的句柄
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
}

int main(int argc, char**argv) {
    execute_command("wsl.exe --cd ~ -e kitty");
    return 0;
}

