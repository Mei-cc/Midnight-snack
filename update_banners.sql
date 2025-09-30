-- 更新轮播图数据脚本
USE midnight_snack;

-- 查看当前数据
SELECT * FROM banners;

-- 先删除所有旧的轮播图数据
DELETE FROM banners;

-- 插入新的轮播图数据（使用真实美食图片）
INSERT INTO banners (title, image, link_url, sort_order, status) VALUES 
('深夜火锅盛宴', '/images/carousel/slide1.png', '/products?category=火锅', 1, 1),
('甜蜜时刻', '/images/carousel/slide2.png', '/products?category=甜品', 2, 1),
('炭火烧烤', '/images/carousel/slide3.png', '/products?category=烧烤', 3, 1),
('缤纷饮品', '/images/carousel/slide4.png', '/products?category=饮品', 4, 1);

-- 查看更新结果
SELECT * FROM banners;
