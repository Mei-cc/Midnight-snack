@echo off
chcp 65001 >nul
echo ================================
echo Git 快速提交工具
echo ================================
echo.

REM 显示当前状态
echo [1/3] 检查当前修改...
git status -s
echo.

REM 添加所有修改
echo [2/3] 添加所有文件到暂存区...
git add .
echo.

REM 提交
echo [3/3] 提交更改...
set /p commit_msg="请输入提交信息 (直接回车使用默认信息): "

if "%commit_msg%"=="" (
    set commit_msg=自动提交 - %date% %time%
)

git commit -m "%commit_msg%"
echo.

echo ================================
echo 提交完成！
echo ================================
echo.

REM 显示最近的提交
echo 最近的提交记录:
git log --oneline -3
echo.

pause
