# 数据库配置与商品数据导入指南

## 📋 概述

本文档说明如何配置数据库、导入商品数据和设置购物车功能。

## 🗄️ 数据库设置

### 1. 创建数据库

```bash
# 登录MySQL
mysql -u root -p

# 创建数据库并导入初始结构
source src/main/resources/sql/midnight_snack.sql
```

或者直接执行：

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS midnight_snack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE midnight_snack;

-- 导入SQL文件
source C:/Users/ruoxi/Desktop/2301/Midnight snack/src/main/resources/sql/midnight_snack.sql
```

### 2. 验证数据库结构

```sql
USE midnight_snack;

-- 查看所有表
SHOW TABLES;

-- 查看商品表结构（应包含product_code字段）
DESCRIBE products;

-- 查看购物车表结构
DESCRIBE cart_items;
```

### 3. 检查默认数据

```sql
-- 查看分类
SELECT * FROM categories;

-- 查看商家
SELECT * FROM merchants;

-- 查看管理员
SELECT * FROM admins;

-- 查看商品（按分类统计）
SELECT 
    c.name as category_name,
    COUNT(*) as product_count,
    SUM(p.sales_count) as total_sales
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
GROUP BY p.category_id
ORDER BY c.id;
```

## 📦 商品数据说明

### 商品编号体系

每个商品都有唯一的商品编号（product_code），按分类前缀编号：

| 分类ID | 分类名称 | 编号前缀 | 编号范围 | 示例 |
|--------|---------|---------|---------|------|
| 1 | 夜宵小食 | YX | YX001-YX999 | YX001 (香辣小龙虾) |
| 2 | 饮品 | YP | YP001-YP999 | YP001 (珍珠奶茶) |
| 3 | 甜品 | TP | TP001-TP999 | TP001 (提拉米苏) |
| 4 | 烧烤 | SK | SK001-SK999 | SK001 (烤羊肉串) |
| 5 | 面食 | MS | MS001-MS999 | MS001 (兰州拉面) |
| 6 | 粥类 | ZL | ZL001-ZL999 | ZL001 (小米粥) |

### 默认商品清单

数据库已包含 24 个测试商品：
- **夜宵小食 (YX)**: 4个商品
- **饮品 (YP)**: 4个商品
- **甜品 (TP)**: 4个商品
- **烧烤 (SK)**: 4个商品
- **面食 (MS)**: 4个商品
- **粥类 (ZL)**: 4个商品

### 查看商品详情

```sql
-- 查看所有商品
SELECT product_code, name, price, category_id, sales_count, is_recommended
FROM products
ORDER BY category_id, product_code;

-- 查看推荐商品
SELECT product_code, name, price, sales_count
FROM products
WHERE is_recommended = 1
ORDER BY sales_count DESC;

-- 查看热销商品（销量前10）
SELECT product_code, name, price, sales_count
FROM products
WHERE status = 1
ORDER BY sales_count DESC
LIMIT 10;
```

## 🛒 购物车功能

### 数据库表

购物车使用 `cart_items` 表：

```sql
CREATE TABLE cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id)
);
```

### API接口

#### 添加商品到购物车
```
POST /cart/add
参数: productId, quantity (可选，默认1)
返回: { "success": true, "message": "添加到购物车成功", "data": {...} }
```

#### 获取购物车列表
```
GET /cart/list
返回: { "success": true, "data": [购物车商品列表] }
```

#### 更新商品数量
```
POST /cart/update
参数: cartItemId, quantity
返回: { "success": true, "message": "更新成功" }
```

#### 删除购物车项
```
POST /cart/remove
参数: cartItemId
返回: { "success": true, "message": "删除成功" }
```

#### 清空购物车
```
POST /cart/clear
返回: { "success": true, "message": "购物车已清空" }
```

#### 获取购物车数量
```
GET /cart/count
返回: { "success": true, "data": 商品数量 }
```

## 🖼️ 商品图片

### 图片目录结构

```
src/main/webapp/images/
├── banners/          # 轮播图
├── categories/       # 分类图标
└── products/         # 商品图片
    ├── yx001.jpg     # 夜宵小食图片
    ├── yp001.jpg     # 饮品图片
    ├── tp001.jpg     # 甜品图片
    ├── sk001.jpg     # 烧烤图片
    ├── ms001.jpg     # 面食图片
    └── zl001.jpg     # 粥类图片
```

### 图片路径格式

- 数据库中存储：`/images/products/yx001.jpg`
- 实际访问：`http://localhost:8080/static/images/products/yx001.jpg`
- JSP引用：`${pageContext.request.contextPath}/static/images/products/yx001.jpg`

### 添加商品图片

1. 将图片文件放到 `src/main/webapp/images/products/` 目录
2. 图片命名规范：使用商品编号小写 + 文件扩展名（如：yx001.jpg）
3. 推荐尺寸：600x600 像素，格式：JPG/PNG
4. 确保图片大小小于 500KB

## 🧪 测试账户

### 管理员
- 用户名: `admin`
- 密码: `123456`

### 测试用户
- 用户名: `testuser`
- 密码: `123456`
- 账户余额: 100.00元

### 测试商家
- 用户名: `testmerchant`
- 密码: `123456`
- 店铺: 深夜美食店

## 📝 使用流程

### 1. 用户购物流程

1. **浏览商品**
   - 访问 `/user/index` 查看首页
   - 查看推荐商品、热销商品、最新商品

2. **添加购物车**
   - 点击商品的"加入购物车"按钮
   - 系统检查库存后添加到购物车

3. **查看购物车**
   - 访问 `/user/cart` 或点击导航栏"购物车"
   - 查看已选商品，可修改数量

4. **结算订单**
   - 选择商品后点击"去结算"
   - 填写收货信息，选择支付方式
   - 完成订单创建

### 2. 商家管理流程

1. **登录商家后台**
   - 访问 `/merchant/login`

2. **管理商品**
   - 添加新商品（自动生成商品编号）
   - 修改商品信息（价格、库存、描述等）
   - 上传商品图片

3. **处理订单**
   - 查看新订单
   - 接单并准备配送

## 🔧 开发配置

### 数据库连接配置

文件：`src/main/resources/database.properties`

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/midnight_snack?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&useSSL=false
jdbc.username=root
jdbc.password=123456
```

### MyBatis映射文件

- 商品Mapper: `src/main/resources/mapper/ProductMapper.xml`
- 购物车Mapper: `src/main/resources/mapper/CartItemMapper.xml`

## 🚀 启动项目

```bash
# 编译项目
mvn clean compile

# 启动服务器
mvn tomcat7:run

# 访问应用
# 用户首页: http://localhost:8080/user/index
# 用户登录: http://localhost:8080/user/login
# 商家登录: http://localhost:8080/merchant/login
# 管理员登录: http://localhost:8080/admin/login
```

## ❓ 常见问题

### 1. 商品不显示？
- 检查数据库中products表是否有数据
- 检查商品status字段是否为1（上架状态）
- 检查商家status字段是否为1（正常营业）

### 2. 购物车添加失败？
- 确保用户已登录
- 检查商品库存是否充足
- 检查商品是否已上架

### 3. 图片不显示？
- 检查图片文件是否存在
- 检查图片路径是否正确
- 检查静态资源配置是否正确

### 4. 如何添加新商品？
```sql
INSERT INTO products (product_code, merchant_id, category_id, name, description, price, original_price, image, stock, sales_count, is_recommended, status) 
VALUES ('YX005', 1, 1, '新商品名称', '商品描述', 25.00, 30.00, '/images/products/yx005.jpg', 100, 0, 0, 1);
```

## 📚 相关文档

- [README.md](README.md) - 项目概述
- [src/main/resources/sql/midnight_snack.sql](src/main/resources/sql/midnight_snack.sql) - 数据库结构
- [src/main/resources/sql/add_more_products.sql](src/main/resources/sql/add_more_products.sql) - 更多商品数据

## 🎉 完成！

现在您已经成功配置了数据库、导入了商品数据，并了解了购物车功能的使用方法。开始享受深夜美食购物系统吧！
