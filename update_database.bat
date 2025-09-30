@echo off
chcp 65001 >nul
echo.
echo ============================================
echo   深夜美食 - 数据库更新工具
echo ============================================
echo.

set /p db_user="请输入MySQL用户名 (默认: root): "
if "%db_user%"=="" set db_user=root

set /p db_pass="请输入MySQL密码 (默认: 123456): "
if "%db_pass%"=="" set db_pass=123456

set /p db_host="请输入MySQL主机 (默认: localhost): "
if "%db_host%"=="" set db_host=localhost

set /p db_port="请输入MySQL端口 (默认: 3306): "
if "%db_port%"=="" set db_port=3306

echo.
echo --------------------------------------------
echo 正在连接MySQL...
echo --------------------------------------------

:: 测试MySQL连接
mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -e "SELECT 1;" >nul 2>&1
if errorlevel 1 (
    echo ❌ MySQL连接失败！请检查用户名、密码和MySQL服务是否启动。
    pause
    exit /b 1
)

echo ✓ MySQL连接成功！
echo.

echo --------------------------------------------
echo 更新数据库结构...
echo --------------------------------------------
echo.

:: 检查并添加 product_code 字段
echo [1/4] 检查 products 表结构...
mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "SHOW COLUMNS FROM products LIKE 'product_code';" 2>nul | find "product_code" >nul
if errorlevel 1 (
    echo   添加 product_code 字段...
    mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "ALTER TABLE products ADD COLUMN product_code VARCHAR(20) UNIQUE AFTER id;"
    if errorlevel 1 (
        echo ⚠ product_code 字段添加失败
    ) else (
        echo ✓ product_code 字段添加成功！
    )
) else (
    echo ✓ product_code 字段已存在
)

:: 检查购物车表
echo.
echo [2/4] 检查 cart_items 表...
mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "SHOW TABLES LIKE 'cart_items';" 2>nul | find "cart_items" >nul
if errorlevel 1 (
    echo   创建 cart_items 表...
    mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "CREATE TABLE cart_items (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, quantity INT NOT NULL DEFAULT 1, create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, UNIQUE KEY unique_user_product (user_id, product_id), INDEX idx_user_id (user_id), FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='购物车表';"
    if errorlevel 1 (
        echo ⚠ cart_items 表创建失败
    ) else (
        echo ✓ cart_items 表创建成功！
    )
) else (
    echo ✓ cart_items 表已存在
)

:: 更新现有商品的商品编号
echo.
echo [3/4] 更新现有商品编号...
mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "UPDATE products p JOIN categories c ON p.category_id = c.id SET p.product_code = CASE WHEN c.name = '夜宵小食' THEN CONCAT('YX', LPAD(p.id, 3, '0')) WHEN c.name = '饮品' THEN CONCAT('YP', LPAD(p.id, 3, '0')) WHEN c.name = '甜品' THEN CONCAT('TP', LPAD(p.id, 3, '0')) WHEN c.name = '烧烤' THEN CONCAT('SK', LPAD(p.id, 3, '0')) WHEN c.name = '面食' THEN CONCAT('MS', LPAD(p.id, 3, '0')) WHEN c.name = '粥类' THEN CONCAT('ZL', LPAD(p.id, 3, '0')) ELSE CONCAT('SP', LPAD(p.id, 3, '0')) END WHERE p.product_code IS NULL OR p.product_code = '';" 2>nul
if errorlevel 1 (
    echo ⚠ 商品编号更新失败
) else (
    echo ✓ 商品编号更新成功！
)

:: 导入扩展商品数据
echo.
set /p import_more="[4/4] 是否导入更多商品数据？(Y/N, 默认: Y): "
if "%import_more%"=="" set import_more=Y
if /i "%import_more%"=="Y" (
    echo   导入扩展商品数据...
    mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% midnight_snack < "src\main\resources\sql\add_more_products.sql" 2>nul
    if errorlevel 1 (
        echo ⚠ 部分商品数据导入失败（可能已存在）
    ) else (
        echo ✓ 扩展商品数据导入成功！
    )
)

echo.
echo --------------------------------------------
echo 验证数据...
echo --------------------------------------------
echo.

:: 验证数据
echo 数据统计：
mysql -h %db_host% -P %db_port% -u %db_user% -p%db_pass% -D midnight_snack -e "SELECT '用户数量：' as info, COUNT(*) as count FROM users UNION ALL SELECT '商家数量：', COUNT(*) FROM merchants UNION ALL SELECT '管理员数量：', COUNT(*) FROM admins UNION ALL SELECT '商品分类：', COUNT(*) FROM categories UNION ALL SELECT '商品数量：', COUNT(*) FROM products UNION ALL SELECT '有编号商品：', COUNT(*) FROM products WHERE product_code IS NOT NULL;" -t

echo.
echo ============================================
echo   ✅ 数据库更新完成！
echo ============================================
echo.
echo 📝 默认账户信息：
echo    管理员: admin / 123456
echo    用户: testuser / 123456  
echo    商家: testmerchant / 123456
echo.
echo 🚀 启动项目: mvn tomcat7:run
echo 🌐 访问地址: http://localhost:8080/user/index
echo.
pause
