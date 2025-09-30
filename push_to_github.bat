@echo off
chcp 65001 >nul
echo ================================
echo 推送代码到 GitHub
echo ================================
echo.

REM 检查是否已经添加远程仓库
git remote -v | findstr "origin" >nul 2>&1
if %errorlevel% equ 0 (
    echo 远程仓库已存在，正在更新...
    git remote set-url origin https://github.com/Mei-cc/Midnight-snack.git
) else (
    echo 正在添加远程仓库...
    git remote add origin https://github.com/Mei-cc/Midnight-snack.git
)

echo.
echo 远程仓库配置完成！
git remote -v
echo.

REM 推送到 GitHub
echo 正在推送到 GitHub...
echo.
git push -u origin master

if %errorlevel% equ 0 (
    echo.
    echo ================================
    echo ✓ 推送成功！
    echo ================================
    echo.
    echo 您的代码已成功推送到:
    echo https://github.com/Mei-cc/Midnight-snack
    echo.
) else (
    echo.
    echo ================================
    echo ✗ 推送失败
    echo ================================
    echo.
    echo 可能的原因:
    echo 1. 需要先登录 GitHub 账号
    echo 2. 没有推送权限
    echo 3. 网络连接问题
    echo.
    echo 建议: 确保您已经配置了 GitHub 凭据
    echo.
)

pause
