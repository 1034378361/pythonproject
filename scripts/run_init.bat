@echo off
echo 正在启动PowerShell初始化脚本...

:: 以管理员权限启动PowerShell脚本
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0init.ps1\"' -Verb RunAs"

:: 如果PowerShell无法启动，尝试直接运行cmd版本
if %errorlevel% neq 0 (
    echo PowerShell启动失败，尝试运行命令行版本...
    call "%~dp0init.cmd"
)

:: 保持窗口打开
echo.
echo 脚本执行完毕，请查看结果。
echo 按任意键退出...
pause >nul
