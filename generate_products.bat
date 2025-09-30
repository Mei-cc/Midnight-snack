@echo off
chcp 65001 >nul
echo ========================================
echo 生成商品占位图
echo ========================================
echo.

python generate_product_images.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ❌ Python 脚本执行失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo ✅ 图片生成完成！
echo ========================================
pause
