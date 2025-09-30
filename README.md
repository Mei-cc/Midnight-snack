# 深夜美食购物系统

基于SSM框架（Spring + SpringMVC + MyBatis）开发的深夜美食购物系统，使用MySQL数据库，运行在Tomcat服务器上。

## 系统特点

- **三端分离**：用户端、商家端、管理员端
- **完整功能**：商品浏览、购物车、订单管理、用户管理等
- **现代架构**：SSM框架 + Maven项目管理
- **响应式设计**：支持PC和移动端访问

## 技术栈

### 后端技术
- **Spring 5.3.21** - 依赖注入和AOP
- **SpringMVC** - Web MVC框架
- **MyBatis 3.5.10** - ORM框架
- **MySQL 8.0** - 关系型数据库
- **Druid** - 数据库连接池
- **Maven** - 项目构建工具

### 前端技术
- **JSP** - 服务端渲染
- **JSTL** - JSP标准标签库
- **jQuery** - JavaScript库
- **CSS3** - 样式设计
- **Bootstrap**（可选）- UI框架

## 系统架构

```
├── 表现层 (Controller)
│   ├── UserController - 用户控制器
│   ├── MerchantController - 商家控制器
│   ├── AdminController - 管理员控制器
│   └── HomeController - 首页控制器
├── 业务层 (Service)
│   ├── UserService - 用户服务
│   ├── MerchantService - 商家服务
│   ├── ProductService - 商品服务
│   └── AdminService - 管理员服务
├── 持久层 (DAO)
│   ├── UserDao - 用户数据访问
│   ├── MerchantDao - 商家数据访问
│   ├── ProductDao - 商品数据访问
│   └── OrderDao - 订单数据访问
└── 实体层 (Entity)
    ├── User - 用户实体
    ├── Merchant - 商家实体
    ├── Product - 商品实体
    └── Order - 订单实体
```

## 数据库设计

系统包含以下核心数据表：

- **users** - 用户表
- **merchants** - 商家表
- **admins** - 管理员表
- **products** - 商品表
- **orders** - 订单表
- **order_items** - 订单明细表
- **categories** - 商品分类表
- **cart_items** - 购物车表
- **favorites** - 收藏表
- **reviews** - 评价表

## 安装部署

### 环境要求
- **JDK 8+**
- **Maven 3.6+**
- **MySQL 8.0+**
- **Tomcat 9.0+**

### 部署步骤

1. **克隆项目**
   ```bash
   git clone <project-url>
   cd midnight-snack
   ```

2. **创建数据库**
   ```sql
   # 导入数据库脚本
   mysql -u root -p < src/main/resources/sql/midnight_snack.sql
   ```

3. **配置数据库连接**
   ```properties
   # 修改 src/main/resources/database.properties
   jdbc.url=jdbc:mysql://localhost:3306/midnight_snack
   jdbc.username=your_username
   jdbc.password=your_password
   ```

4. **编译项目**
   ```bash
   mvn clean compile
   ```

5. **启动服务**
   ```bash
   # 使用Maven Tomcat插件启动
   mvn tomcat7:run
   
   # 或者打包部署到Tomcat
   mvn clean package
   # 将target/Midnightsnack-1.0-SNAPSHOT.war部署到Tomcat
   ```

6. **访问系统**
   - 系统首页: http://localhost:8080/midnight-snack/
   - 用户登录: http://localhost:8080/midnight-snack/user/login
   - 商家登录: http://localhost:8080/midnight-snack/merchant/login
   - 管理员登录: http://localhost:8080/midnight-snack/admin/login

## 默认账户

### 管理员账户
- 用户名: `admin`
- 密码: `123456`

### 测试用户
- 用户名: `testuser`
- 密码: `123456`

### 测试商家
- 用户名: `testmerchant`
- 密码: `123456`

## 功能模块

### 用户端功能
- ✅ 用户注册/登录
- ✅ 商品浏览
- ✅ 购物车管理
- ✅ 订单管理
- ✅ 个人信息管理
- ✅ 商品搜索
- ✅ 商品收藏

### 商家端功能
- ✅ 商家注册/登录
- ✅ 店铺信息管理
- ✅ 商品管理（增删改查）
- ✅ 订单管理
- ✅ 销售统计
- ✅ 评价管理

### 管理员端功能
- ✅ 管理员登录
- ✅ 用户管理
- ✅ 商家管理
- ✅ 商家审核
- ✅ 订单管理
- ✅ 分类管理
- ✅ 系统统计

## 项目结构

```
src/
├── main/
│   ├── java/
│   │   └── com/midnightsnack/
│   │       ├── controller/    # 控制器层
│   │       ├── service/       # 服务层
│   │       ├── dao/          # 数据访问层
│   │       ├── entity/       # 实体类
│   │       └── util/         # 工具类
│   ├── resources/
│   │   ├── mapper/           # MyBatis映射文件
│   │   ├── sql/              # 数据库脚本
│   │   ├── spring-context.xml   # Spring配置
│   │   ├── spring-mvc.xml       # SpringMVC配置
│   │   └── database.properties  # 数据库配置
│   └── webapp/
│       ├── WEB-INF/
│       │   └── web.xml       # Web配置
│       ├── jsp/              # JSP页面
│       └── static/           # 静态资源
└── test/                     # 测试代码
```

## API接口

### 用户相关
- `POST /user/login` - 用户登录
- `POST /user/register` - 用户注册
- `POST /user/updateProfile` - 更新个人信息
- `POST /user/changePassword` - 修改密码

### 商品相关
- `GET /api/search` - 搜索商品
- `GET /api/recommended` - 获取推荐商品
- `GET /api/hotSales` - 获取热销商品
- `GET /product/{id}` - 商品详情

### 商家相关
- `POST /merchant/login` - 商家登录
- `POST /merchant/register` - 商家注册
- `POST /merchant/addProduct` - 添加商品
- `POST /merchant/updateProduct` - 更新商品

## 开发说明

### 代码规范
- 使用驼峰命名法
- 类名首字母大写
- 方法名和变量名首字母小写
- 常量全大写，用下划线分隔

### 注释规范
- 类和方法必须有JavaDoc注释
- 重要的业务逻辑需要行内注释
- 数据库字段需要注释说明

### 异常处理
- 使用统一的Result类返回结果
- 业务异常在Service层处理
- 系统异常在Controller层处理

## 扩展功能

可以进一步开发的功能：
- 微信/支付宝支付集成
- 短信验证码服务
- 邮件通知系统
- 实时聊天客服
- 商品推荐算法
- 数据可视化大屏
- 移动端APP
- 微信小程序

## 性能优化

建议的优化方案：
- Redis缓存热点数据
- 数据库读写分离
- CDN加速静态资源
- 图片压缩和懒加载
- 接口响应缓存
- SQL语句优化

## 安全考虑

- 密码MD5加密存储
- SQL注入防护
- XSS攻击防护
- CSRF攻击防护
- 用户权限验证
- 登录拦截器

## 许可证

本项目基于MIT许可证开源。

## 联系方式

如有问题或建议，请联系开发团队。

---

**深夜美食购物系统** - 让深夜的美食触手可及 🌙🍜
