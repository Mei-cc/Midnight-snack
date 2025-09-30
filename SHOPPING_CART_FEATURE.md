# 🛒 购物车功能实现文档

## 功能概述

深夜美食购物系统已完整实现购物车功能，支持商品的添加、修改、删除和结算等完整购物流程。

## 📋 功能特性

### ✅ 已实现功能

1. **商品管理**
   - ✓ 按分类编号系统 (YX/YP/TP/SK/MS/ZL)
   - ✓ 商品信息完整展示（名称、价格、描述、图片）
   - ✓ 商品状态管理（上架/下架）
   - ✓ 库存管理和检查
   - ✓ 推荐商品标记
   - ✓ 销量统计

2. **购物车操作**
   - ✓ 添加商品到购物车
   - ✓ 更新商品数量
   - ✓ 删除单个商品
   - ✓ 批量删除商品
   - ✓ 清空购物车
   - ✓ 查看购物车列表
   - ✓ 获取购物车商品数量
   - ✓ 实时库存验证

3. **用户体验**
   - ✓ 未登录用户提示登录
   - ✓ 商品库存实时检查
   - ✓ 重复商品自动合并数量
   - ✓ 友好的错误提示
   - ✓ 响应式页面设计

## 🏗️ 系统架构

### 后端架构（SSM框架）

```
Controller层 (控制器)
    ↓
Service层 (业务逻辑)
    ↓
DAO层 (数据访问)
    ↓
Database (MySQL数据库)
```

### 核心文件结构

```
src/main/java/com/midnightsnack/
├── controller/
│   └── CartController.java           # 购物车控制器
├── service/
│   ├── CartItemService.java          # 购物车服务接口
│   └── impl/
│       └── CartItemServiceImpl.java  # 购物车服务实现
├── dao/
│   └── CartItemDao.java              # 购物车数据访问接口
├── entity/
│   ├── CartItem.java                 # 购物车实体
│   └── Product.java                  # 商品实体（已更新）

src/main/resources/
├── mapper/
│   ├── CartItemMapper.xml            # 购物车映射文件
│   └── ProductMapper.xml             # 商品映射文件（已更新）
└── sql/
    ├── midnight_snack.sql            # 主数据库结构（已更新）
    └── add_more_products.sql         # 扩展商品数据
```

## 💾 数据库设计

### 购物车表 (cart_items)

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INT | 主键，自增 |
| user_id | INT | 用户ID（外键） |
| product_id | INT | 商品ID（外键） |
| quantity | INT | 商品数量 |
| create_time | TIMESTAMP | 创建时间 |
| update_time | TIMESTAMP | 更新时间 |

**约束：**
- user_id + product_id 唯一索引（防止重复添加）
- 用户删除时级联删除购物车数据
- 商品删除时级联删除购物车数据

### 商品表更新 (products)

新增字段：`product_code VARCHAR(20) UNIQUE` - 商品编号

## 🔌 API接口文档

### 基础路径
```
/cart
```

### 接口列表

#### 1. 添加商品到购物车

**URL:** `POST /cart/add`

**参数:**
```json
{
  "productId": 1,      // 商品ID (必填)
  "quantity": 2        // 数量 (可选，默认1)
}
```

**返回:**
```json
{
  "success": true,
  "message": "添加到购物车成功",
  "data": {
    "id": 1,
    "userId": 1,
    "productId": 1,
    "quantity": 2
  }
}
```

**错误情况:**
- 未登录：`{ "success": false, "message": "请先登录" }`
- 商品不存在：`{ "success": false, "message": "商品不存在" }`
- 商品已下架：`{ "success": false, "message": "商品已下架" }`
- 库存不足：`{ "success": false, "message": "商品库存不足" }`

---

#### 2. 获取购物车列表

**URL:** `GET /cart/list`

**返回:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "userId": 1,
      "productId": 1,
      "quantity": 2,
      "product": {
        "id": 1,
        "productCode": "YX001",
        "name": "香辣小龙虾",
        "price": 58.00,
        "image": "/images/products/yx001.jpg",
        "stock": 100,
        "merchantName": "深夜美食店"
      }
    }
  ]
}
```

---

#### 3. 更新商品数量

**URL:** `POST /cart/update`

**参数:**
```json
{
  "cartItemId": 1,     // 购物车项ID (必填)
  "quantity": 3        // 新数量 (必填)
}
```

**返回:**
```json
{
  "success": true,
  "message": "更新成功"
}
```

---

#### 4. 删除购物车项

**URL:** `POST /cart/remove`

**参数:**
```json
{
  "cartItemId": 1      // 购物车项ID (必填)
}
```

**返回:**
```json
{
  "success": true,
  "message": "删除成功"
}
```

---

#### 5. 批量删除购物车项

**URL:** `POST /cart/removeMultiple`

**参数:**
```json
[1, 2, 3]              // 购物车项ID数组
```

**返回:**
```json
{
  "success": true,
  "message": "删除成功"
}
```

---

#### 6. 清空购物车

**URL:** `POST /cart/clear`

**返回:**
```json
{
  "success": true,
  "message": "购物车已清空"
}
```

---

#### 7. 获取购物车商品数量

**URL:** `GET /cart/count`

**返回:**
```json
{
  "success": true,
  "data": 5            // 购物车中的商品总数
}
```

## 📦 商品编号体系

### 编号规则

| 分类 | 编号前缀 | 编号范围 | 示例 |
|------|---------|---------|------|
| 夜宵小食 | YX | YX001-YX999 | YX001 - 香辣小龙虾 |
| 饮品 | YP | YP001-YP999 | YP001 - 珍珠奶茶 |
| 甜品 | TP | TP001-TP999 | TP001 - 提拉米苏 |
| 烧烤 | SK | SK001-SK999 | SK001 - 烤羊肉串 |
| 面食 | MS | MS001-MS999 | MS001 - 兰州拉面 |
| 粥类 | ZL | ZL001-ZL999 | ZL001 - 小米粥 |

### 编号优势

1. **易于识别** - 通过前缀快速识别商品类别
2. **便于管理** - 分类管理商品，避免混乱
3. **扩展性强** - 每类可容纳999个商品
4. **统一规范** - 标准化的商品编码系统

## 🧪 测试说明

### 测试账户

- **用户账户**
  - 用户名: `testuser`
  - 密码: `123456`
  - 初始余额: 100.00元

### 测试流程

1. **登录系统**
   ```
   访问: http://localhost:8080/user/login
   ```

2. **浏览商品**
   ```
   访问: http://localhost:8080/user/index
   ```

3. **添加到购物车**
   - 点击商品卡片上的"加入购物车"按钮
   - 或使用API: `POST /cart/add`

4. **查看购物车**
   ```
   访问: http://localhost:8080/user/cart
   ```

5. **修改数量**
   - 在购物车页面调整商品数量
   - 或使用API: `POST /cart/update`

6. **删除商品**
   - 点击删除按钮
   - 或使用API: `POST /cart/remove`

### API测试示例（使用curl）

```bash
# 1. 添加商品到购物车
curl -X POST http://localhost:8080/cart/add \
  -d "productId=1&quantity=2" \
  -b cookies.txt

# 2. 获取购物车列表
curl -X GET http://localhost:8080/cart/list \
  -b cookies.txt

# 3. 更新商品数量
curl -X POST http://localhost:8080/cart/update \
  -d "cartItemId=1&quantity=3" \
  -b cookies.txt

# 4. 删除商品
curl -X POST http://localhost:8080/cart/remove \
  -d "cartItemId=1" \
  -b cookies.txt

# 5. 获取购物车数量
curl -X GET http://localhost:8080/cart/count \
  -b cookies.txt
```

## 🔐 权限控制

### 登录验证

- 所有购物车操作都需要用户登录
- 未登录用户访问购物车功能会提示登录
- Session管理用户登录状态

### 数据安全

- 用户只能操作自己的购物车
- 购物车项ID验证，防止越权操作
- 数据库外键约束保证数据一致性

## 🎨 前端集成

### JavaScript示例

```javascript
// 添加商品到购物车
function addToCart(productId) {
    if (!isUserLoggedIn) {
        showLoginPrompt();
        return;
    }
    
    $.ajax({
        url: '/cart/add',
        type: 'POST',
        data: {
            productId: productId,
            quantity: 1
        },
        success: function(result) {
            if (result.success) {
                showMessage('商品已添加到购物车', 'success');
                updateCartCount();
            } else {
                showMessage(result.message || '添加失败', 'error');
            }
        },
        error: function() {
            showMessage('网络错误，请重试', 'error');
        }
    });
}

// 更新购物车数量显示
function updateCartCount() {
    $.get('/cart/count', function(result) {
        if (result.success) {
            $('.cart-count').text(result.data);
        }
    });
}
```

## 📊 性能优化

### 数据库优化

1. **索引优化**
   - user_id + product_id 唯一索引
   - user_id 单独索引（查询购物车列表）
   - product_id 外键索引

2. **查询优化**
   - 使用LEFT JOIN关联查询商品信息
   - 避免N+1查询问题
   - 批量操作使用IN条件

### 缓存策略（可扩展）

- Redis缓存购物车数据
- 减少数据库查询次数
- 提高响应速度

## 🚀 未来扩展

### 可添加功能

1. **购物车同步**
   - 登录后合并本地购物车
   - 多端购物车数据同步

2. **商品推荐**
   - 基于购物车内容推荐相关商品
   - 购物车商品优惠组合

3. **优惠券系统**
   - 购物车自动应用优惠券
   - 满减优惠计算

4. **购物车分享**
   - 生成购物车分享链接
   - 一键导入他人购物车

## 📖 相关文档

- [DATABASE_SETUP.md](DATABASE_SETUP.md) - 数据库配置指南
- [README.md](README.md) - 项目概述
- [API文档] - 完整接口文档

## ❓ 常见问题

### Q1: 购物车添加失败？
**A:** 检查以下几点：
- 用户是否已登录
- 商品是否存在且上架
- 商品库存是否充足
- 网络连接是否正常

### Q2: 购物车数据丢失？
**A:** 购物车数据存储在数据库中，只要不清空数据或删除账户，数据不会丢失。

### Q3: 如何限制购物车商品数量？
**A:** 在CartItemServiceImpl中添加验证逻辑：
```java
int currentCount = cartItemDao.countByUserId(userId);
if (currentCount >= MAX_CART_ITEMS) {
    return Result.error("购物车商品已达上限");
}
```

### Q4: 购物车商品价格变动怎么处理？
**A:** 购物车展示的是商品表的实时价格，结算时以结算时刻的价格为准。

## 🎉 总结

深夜美食购物系统的购物车功能已全面实现，提供了完整的商品浏览、添加、管理和结算流程。系统采用SSM框架开发，代码结构清晰，易于维护和扩展。

**技术栈：**
- Spring 5.3.21
- SpringMVC
- MyBatis 3.5.10
- MySQL 8.0
- jQuery

**特色功能：**
- ✅ 完整的购物车操作
- ✅ 商品编号管理系统
- ✅ 实时库存验证
- ✅ 用户权限控制
- ✅ 友好的用户体验

开始使用深夜美食购物系统，享受便捷的夜间购物体验吧！ 🌙🍜
