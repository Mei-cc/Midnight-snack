@echo off
chcp 65001
cls
echo =========================================
echo    夜宵系统 - 轮播图真实图片配置
echo =========================================
echo.

echo [第1步] 复制真实美食图片...
echo.
if not exist "1.png" (
    echo 错误: 找不到 1.png 文件！
    pause
    exit /b 1
)
if not exist "2.png" (
    echo 错误: 找不到 2.png 文件！
    pause
    exit /b 1
)
if not exist "3.png" (
    echo 错误: 找不到 3.png 文件！
    pause
    exit /b 1
)
if not exist "4.png" (
    echo 错误: 找不到 4.png 文件！
    pause
    exit /b 1
)

copy "1.png" "src\main\webapp\static\images\carousel\slide1.png" /Y
copy "2.png" "src\main\webapp\static\images\carousel\slide2.png" /Y
copy "3.png" "src\main\webapp\static\images\carousel\slide3.png" /Y
copy "4.png" "src\main\webapp\static\images\carousel\slide4.png" /Y

echo ✓ 图片复制完成！
echo.

echo [第2步] 更新数据库轮播图数据...
echo 请输入MySQL root密码：
mysql -u root -p < update_banners.sql

if %ERRORLEVEL% EQU 0 (
    echo ✓ 数据库更新成功！
    echo.
    echo =========================================
    echo    所有步骤完成！
    echo =========================================
    echo.
    echo 下一步操作：
    echo 1. 刷新浏览器页面 ^(Ctrl + F5^)
    echo 2. 查看全新的真实美食轮播图！
    echo.
) else (
    echo × 数据库更新失败，请检查MySQL连接！
    echo.
)

pause
