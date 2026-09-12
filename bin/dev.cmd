@echo off
rem Enter the developer environment in a new pwsh session.
rem
rem   dev.cmd           clang64 (default)
rem   dev.cmd clang64   MSYS2 CLANG64: clang + libc++ + lld, MinGW-w64 ABI
rem   dev.cmd clang-cl  not implemented yet
rem   dev.cmd msvc      not implemented yet
rem
rem %~dp0 is the directory holding this file (with a trailing backslash), so
rem the repo works wherever it is cloned. %* passes arguments straight through.

pwsh.exe -NoProfile -NoExit -File "%~dp0..\PowerShell\dev.ps1" %*
