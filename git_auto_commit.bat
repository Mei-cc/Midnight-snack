@echo off
chcp 65001 >nul
echo ================================
echo Git 自动提交守护进程
echo ================================
echo 此脚本将每5分钟自动检查并提交更改
echo 按 Ctrl+C 可以停止
echo ================================
echo.

:loop
echo [%date% %time%] 检查是否有更改...

REM 检查是否有未提交的更改
git status --porcelain > nul 2>&1
if errorlevel 1 (
    echo Git 仓库未初始化，正在初始化...
    git init
)

REM 获取状态
for /f %%i in ('git status --porcelain ^| find /c /v ""') do set changes=%%i

if %changes% gtr 0 (
    echo 发现 %changes% 个更改，正在提交...
    git add .
    git commit -m "自动提交 - %date% %time%"
    echo 提交完成！
    echo.
) else (
    echo 没有新的更改。
)

echo 等待5分钟后继续检查...
echo.
timeout /t 300 /nobreak >nul
goto loop
