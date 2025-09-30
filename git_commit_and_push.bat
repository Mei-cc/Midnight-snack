@echo off
chcp 65001 >nul
echo ================================
echo Git 提交并推送到 GitHub
echo ================================
echo.

REM 显示当前状态
echo [1/4] 检查当前修改...
git status -s
echo.

REM 添加所有修改
echo [2/4] 添加所有文件到暂存区...
git add .
echo.

REM 提交
echo [3/4] 提交更改...
set /p commit_msg="请输入提交信息 (直接回车使用默认信息): "

if "%commit_msg%"=="" (
    set commit_msg=自动提交 - %date% %time%
)

git --no-pager commit -m "%commit_msg%"
echo.

REM 推送到 GitHub
echo [4/4] 推送到 GitHub...
git push origin master

if %errorlevel% equ 0 (
    echo.
    echo ================================
    echo ✓ 提交并推送成功！
    echo ================================
    echo.
    echo 最近的提交记录:
    git --no-pager log --oneline -3
    echo.
    echo 查看您的项目: https://github.com/Mei-cc/Midnight-snack
    echo.
) else (
    echo.
    echo ================================
    echo ✗ 推送失败（但本地提交已完成）
    echo ================================
    echo.
    echo 本地提交记录:
    git --no-pager log --oneline -3
    echo.
    echo 您可以稍后手动推送: git push origin master
    echo.
)

pause
