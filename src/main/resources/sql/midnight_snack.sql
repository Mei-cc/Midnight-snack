-- =============================================
-- 深夜美食购物系统 - 数据库初始化脚本
-- =============================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS midnight_snack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE midnight_snack;

-- =============================================
-- 1. 分类表
-- =============================================
CREATE TABLE IF NOT EXISTS categories (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(200) COMMENT '分类描述',
    icon VARCHAR(100) COMMENT '分类图标',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态(0-禁用,1-启用)',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类表';

-- =============================================
-- 2. 用户表
-- =============================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    real_name VARCHAR(50) COMMENT '真实姓名',
    gender TINYINT COMMENT '性别(0-女,1-男)',
    birthday DATE COMMENT '生日',
    avatar VARCHAR(200) COMMENT '头像',
    address VARCHAR(200) COMMENT '默认地址',
    balance DECIMAL(10,2) DEFAULT 0.00 COMMENT '账户余额',
    points INT DEFAULT 0 COMMENT '积分',
    status TINYINT DEFAULT 1 COMMENT '状态(0-禁用,1-正常)',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    last_login_time TIMESTAMP NULL COMMENT '最后登录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- =============================================
-- 3. 商家表
-- =============================================
CREATE TABLE IF NOT EXISTS merchants (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商家ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    name VARCHAR(100) NOT NULL COMMENT '商家名称',
    description TEXT COMMENT '商家描述',
    logo VARCHAR(200) COMMENT '商家LOGO',
    phone VARCHAR(20) COMMENT '联系电话',
    address VARCHAR(200) COMMENT '商家地址',
    business_hours VARCHAR(100) COMMENT '营业时间',
    rating DECIMAL(3,2) DEFAULT 5.00 COMMENT '评分',
    status TINYINT DEFAULT 1 COMMENT '状态(0-关闭,1-营业)',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家表';

-- =============================================
-- 4. 管理员表
-- =============================================
CREATE TABLE IF NOT EXISTS admins (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '管理员ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    role TINYINT DEFAULT 1 COMMENT '角色(1-普通管理员,2-超级管理员)',
    status TINYINT DEFAULT 1 COMMENT '状态(0-禁用,1-正常)',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    last_login_time TIMESTAMP NULL COMMENT '最后登录时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- =============================================
-- 5. 商品表
-- =============================================
CREATE TABLE IF NOT EXISTS products (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '商品ID',
    product_code VARCHAR(20) UNIQUE COMMENT '商品编号',
    merchant_id INT NOT NULL COMMENT '商家ID',
    category_id INT NOT NULL COMMENT '分类ID',
    name VARCHAR(100) NOT NULL COMMENT '商品名称',
    description TEXT COMMENT '商品描述',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    original_price DECIMAL(10,2) COMMENT '原价',
    image VARCHAR(200) COMMENT '商品图片',
    stock INT DEFAULT 0 COMMENT '库存',
    sales_count INT DEFAULT 0 COMMENT '销量',
    is_recommended TINYINT DEFAULT 0 COMMENT '是否推荐(0-否,1-是)',
    status TINYINT DEFAULT 1 COMMENT '状态(0-下架,1-上架)',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    INDEX idx_category (category_id),
    INDEX idx_merchant (merchant_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- =============================================
-- 6. 购物车表
-- =============================================
CREATE TABLE IF NOT EXISTS cart_items (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '购物车项ID',
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    quantity INT NOT NULL DEFAULT 1 COMMENT '数量',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '添加时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

-- =============================================
-- 7. 订单表
-- =============================================
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    order_no VARCHAR(50) UNIQUE NOT NULL COMMENT '订单号',
    user_id INT NOT NULL COMMENT '用户ID',
    merchant_id INT NOT NULL COMMENT '商家ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总额',
    delivery_fee DECIMAL(10,2) DEFAULT 0.00 COMMENT '配送费',
    actual_amount DECIMAL(10,2) NOT NULL COMMENT '实付金额',
    receiver_name VARCHAR(50) NOT NULL COMMENT '收货人',
    receiver_phone VARCHAR(20) NOT NULL COMMENT '收货电话',
    receiver_address VARCHAR(200) NOT NULL COMMENT '收货地址',
    payment_method TINYINT DEFAULT 1 COMMENT '支付方式(1-余额,2-微信,3-支付宝)',
    payment_status TINYINT DEFAULT 0 COMMENT '支付状态(0-未支付,1-已支付)',
    payment_time TIMESTAMP NULL COMMENT '支付时间',
    order_status TINYINT DEFAULT 1 COMMENT '订单状态(1-待付款,2-待接单,3-配送中,4-已完成,5-已取消)',
    remark TEXT COMMENT '备注',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(id),
    INDEX idx_user (user_id),
    INDEX idx_merchant (merchant_id),
    INDEX idx_status (order_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- =============================================
-- 8. 订单明细表
-- =============================================
CREATE TABLE IF NOT EXISTS order_items (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单明细ID',
    order_id INT NOT NULL COMMENT '订单ID',
    product_id INT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(100) NOT NULL COMMENT '商品名称',
    product_image VARCHAR(200) COMMENT '商品图片',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    quantity INT NOT NULL COMMENT '数量',
    subtotal DECIMAL(10,2) NOT NULL COMMENT '小计',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- =============================================
-- 9. 收藏表
-- =============================================
CREATE TABLE IF NOT EXISTS favorites (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '收藏ID',
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='收藏表';

-- =============================================
-- 10. 评价表
-- =============================================
CREATE TABLE IF NOT EXISTS reviews (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
    order_id INT NOT NULL COMMENT '订单ID',
    user_id INT NOT NULL COMMENT '用户ID',
    product_id INT NOT NULL COMMENT '商品ID',
    rating INT NOT NULL COMMENT '评分(1-5)',
    content TEXT COMMENT '评价内容',
    images VARCHAR(500) COMMENT '评价图片(多张用逗号分隔)',
    reply TEXT COMMENT '商家回复',
    reply_time TIMESTAMP NULL COMMENT '回复时间',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '评价时间',
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id),
    INDEX idx_product (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评价表';

-- =============================================
-- 插入初始数据
-- =============================================

-- 插入分类数据
INSERT INTO categories (id, name, description, icon, sort_order) VALUES
(1, '夜宵小食', '各类夜宵小吃', 'fa-drumstick-bite', 1),
(2, '饮品', '各类饮料饮品', 'fa-coffee', 2),
(3, '甜品', '各类甜品点心', 'fa-ice-cream', 3),
(4, '烧烤', '各类烧烤美食', 'fa-fire', 4),
(5, '面食', '各类面食主食', 'fa-bowling-ball', 5),
(6, '粥类', '各类营养粥品', 'fa-bread-slice', 6);

-- 插入测试管理员
INSERT INTO admins (username, password, real_name, role) VALUES
('admin', '123456', '系统管理员', 2);

-- 插入测试商家
INSERT INTO merchants (username, password, name, description, phone, address, business_hours) VALUES
('testmerchant', '123456', '深夜美食店', '提供优质的深夜美食服务', '400-123-4567', '深夜美食总部', '18:00-06:00');

-- 插入测试用户
INSERT INTO users (username, password, real_name, phone, balance) VALUES
('testuser', '123456', '测试用户', '13800138000', 100.00);

-- 插入测试商品
INSERT INTO products (product_code, merchant_id, category_id, name, description, price, original_price, image, stock, sales_count, is_recommended) VALUES
('YX001', 1, 1, '香辣小龙虾', '新鲜美味的香辣小龙虾', 58.00, 68.00, '/images/products/yx001.jpg', 100, 156, 1),
('YX002', 1, 1, '麻辣烫', '香辣可口的麻辣烫', 25.00, 30.00, '/images/products/yx002.jpg', 100, 89, 0),
('YX003', 1, 1, '炸鸡腿', '外酥里嫩的炸鸡腿', 15.00, 18.00, '/images/products/yx003.jpg', 100, 203, 1),
('YX004', 1, 1, '薯条', '金黄酥脆的薯条', 12.00, 15.00, '/images/products/yx004.jpg', 100, 145, 0),

('YP001', 1, 2, '珍珠奶茶', '香浓醇厚的珍珠奶茶', 12.00, 15.00, '/images/products/yp001.jpg', 100, 234, 1),
('YP002', 1, 2, '柠檬茶', '清新爽口的柠檬茶', 10.00, 12.00, '/images/products/yp002.jpg', 100, 167, 0),
('YP003', 1, 2, '可乐', '冰镇可口可乐', 5.00, 6.00, '/images/products/yp003.jpg', 100, 289, 0),
('YP004', 1, 2, '果汁', '新鲜鲜榨果汁', 15.00, 18.00, '/images/products/yp004.jpg', 100, 123, 1),

('TP001', 1, 3, '提拉米苏', '经典意式提拉米苏', 28.00, 35.00, '/images/products/tp001.jpg', 100, 98, 1),
('TP002', 1, 3, '芒果班戟', '香甜芒果班戟', 22.00, 25.00, '/images/products/tp002.jpg', 100, 134, 0),
('TP003', 1, 3, '蛋挞', '港式蛋挞', 8.00, 10.00, '/images/products/tp003.jpg', 100, 276, 1),
('TP004', 1, 3, '双皮奶', '顺德双皮奶', 12.00, 15.00, '/images/products/tp004.jpg', 100, 189, 0),

('SK001', 1, 4, '烤羊肉串', '新疆烤羊肉串', 3.00, 4.00, '/images/products/sk001.jpg', 100, 456, 1),
('SK002', 1, 4, '烤鸡翅', '秘制烤鸡翅', 18.00, 22.00, '/images/products/sk002.jpg', 100, 312, 1),
('SK003', 1, 4, '烤茄子', '烤茄子', 10.00, 12.00, '/images/products/sk003.jpg', 100, 145, 0),
('SK004', 1, 4, '烤韭菜', '烤韭菜', 8.00, 10.00, '/images/products/sk004.jpg', 100, 167, 0),

('MS001', 1, 5, '兰州拉面', '正宗兰州拉面', 20.00, 25.00, '/images/products/ms001.jpg', 100, 234, 1),
('MS002', 1, 5, '炒面', '美味炒面', 18.00, 22.00, '/images/products/ms002.jpg', 100, 198, 0),
('MS003', 1, 5, '刀削面', '山西刀削面', 22.00, 26.00, '/images/products/ms003.jpg', 100, 156, 1),
('MS004', 1, 5, '意大利面', '经典意大利面', 28.00, 32.00, '/images/products/ms004.jpg', 100, 123, 0),

('ZL001', 1, 6, '小米粥', '养胃小米粥', 8.00, 10.00, '/images/products/zl001.jpg', 100, 267, 1),
('ZL002', 1, 6, '皮蛋瘦肉粥', '经典皮蛋瘦肉粥', 12.00, 15.00, '/images/products/zl002.jpg', 100, 345, 1),
('ZL003', 1, 6, '海鲜粥', '营养海鲜粥', 25.00, 30.00, '/images/products/zl003.jpg', 100, 189, 0),
('ZL004', 1, 6, '红豆粥', '香甜红豆粥', 10.00, 12.00, '/images/products/zl004.jpg', 100, 223, 0);

-- =============================================
-- 数据库初始化完成
-- =============================================
