#!/bin/bash

# 深夜美食 - 数据库导入工具 (Linux/Mac版本)

echo ""
echo "============================================"
echo "  深夜美食 - 数据库导入工具"
echo "============================================"
echo ""

# 读取数据库配置
read -p "请输入MySQL用户名 (默认: root): " db_user
db_user=${db_user:-root}

read -sp "请输入MySQL密码 (默认: 123456): " db_pass
echo ""
db_pass=${db_pass:-123456}

read -p "请输入MySQL主机 (默认: localhost): " db_host
db_host=${db_host:-localhost}

read -p "请输入MySQL端口 (默认: 3306): " db_port
db_port=${db_port:-3306}

echo ""
echo "--------------------------------------------"
echo "正在连接MySQL..."
echo "--------------------------------------------"

# 测试MySQL连接
mysql -h $db_host -P $db_port -u $db_user -p$db_pass -e "SELECT 1;" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ MySQL连接失败！请检查用户名、密码和MySQL服务是否启动。"
    exit 1
fi

echo "✓ MySQL连接成功！"
echo ""

echo "--------------------------------------------"
echo "开始导入数据库..."
echo "--------------------------------------------"
echo ""

# 导入主数据库结构
echo "[1/2] 导入数据库结构和基础数据..."
mysql -h $db_host -P $db_port -u $db_user -p$db_pass < "src/main/resources/sql/midnight_snack.sql"
if [ $? -ne 0 ]; then
    echo "❌ 数据库结构导入失败！"
    exit 1
fi
echo "✓ 数据库结构导入成功！"

# 检查是否需要导入更多商品数据
echo ""
read -p "是否导入更多商品数据？(y/n, 默认: n): " import_more
if [ "$import_more" = "y" ] || [ "$import_more" = "Y" ]; then
    echo "[2/2] 导入扩展商品数据..."
    mysql -h $db_host -P $db_port -u $db_user -p$db_pass midnight_snack < "src/main/resources/sql/add_more_products.sql"
    if [ $? -ne 0 ]; then
        echo "⚠ 扩展商品数据导入失败，但基础数据已导入成功。"
    else
        echo "✓ 扩展商品数据导入成功！"
    fi
fi

echo ""
echo "--------------------------------------------"
echo "验证数据..."
echo "--------------------------------------------"
echo ""

# 验证数据
echo "数据统计："
mysql -h $db_host -P $db_port -u $db_user -p$db_pass -D midnight_snack -e "SELECT '用户数量：' as info, COUNT(*) as count FROM users UNION ALL SELECT '商家数量：', COUNT(*) FROM merchants UNION ALL SELECT '管理员数量：', COUNT(*) FROM admins UNION ALL SELECT '商品分类：', COUNT(*) FROM categories UNION ALL SELECT '商品数量：', COUNT(*) FROM products;" -t

echo ""
echo "============================================"
echo "  ✅ 数据导入完成！"
echo "============================================"
echo ""
echo "📝 默认账户信息："
echo "   管理员: admin / 123456"
echo "   用户: testuser / 123456"
echo "   商家: testmerchant / 123456"
echo ""
echo "🚀 启动项目: mvn tomcat7:run"
echo "🌐 访问地址: http://localhost:8080/user/index"
echo ""
echo "📖 详细文档请查看: DATABASE_SETUP.md"
echo ""
