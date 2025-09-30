-- 更新所有商品图片路径为PNG格式
USE midnight_snack;

-- 更新商品图片路径
UPDATE products SET image = '/images/products/yx001.png' WHERE id = 1;
UPDATE products SET image = '/images/products/yx002.png' WHERE id = 2;
UPDATE products SET image = '/images/products/yx003.png' WHERE id = 3;
UPDATE products SET image = '/images/products/yx004.png' WHERE id = 4;
UPDATE products SET image = '/images/products/yx005.png' WHERE id = 5;
UPDATE products SET image = '/images/products/yx006.png' WHERE id = 6;
UPDATE products SET image = '/images/products/yx007.png' WHERE id = 7;
UPDATE products SET image = '/images/products/yx008.png' WHERE id = 8;
UPDATE products SET image = '/images/products/yp001.png' WHERE id = 9;
UPDATE products SET image = '/images/products/yp002.png' WHERE id = 10;
UPDATE products SET image = '/images/products/yp003.png' WHERE id = 11;
UPDATE products SET image = '/images/products/yp004.png' WHERE id = 12;
UPDATE products SET image = '/images/products/yp005.png' WHERE id = 13;
UPDATE products SET image = '/images/products/yp006.png' WHERE id = 14;
UPDATE products SET image = '/images/products/yp007.png' WHERE id = 15;
UPDATE products SET image = '/images/products/yp008.png' WHERE id = 16;
UPDATE products SET image = '/images/products/tp001.png' WHERE id = 17;
UPDATE products SET image = '/images/products/tp002.png' WHERE id = 18;
UPDATE products SET image = '/images/products/tp003.png' WHERE id = 19;
UPDATE products SET image = '/images/products/tp004.png' WHERE id = 20;
UPDATE products SET image = '/images/products/tp005.png' WHERE id = 21;
UPDATE products SET image = '/images/products/tp006.png' WHERE id = 22;
UPDATE products SET image = '/images/products/tp007.png' WHERE id = 23;
UPDATE products SET image = '/images/products/tp008.png' WHERE id = 24;
UPDATE products SET image = '/images/products/sk001.png' WHERE id = 25;
UPDATE products SET image = '/images/products/sk002.png' WHERE id = 26;
UPDATE products SET image = '/images/products/sk003.png' WHERE id = 27;
UPDATE products SET image = '/images/products/sk004.png' WHERE id = 28;
UPDATE products SET image = '/images/products/sk005.png' WHERE id = 29;
UPDATE products SET image = '/images/products/sk006.png' WHERE id = 30;
UPDATE products SET image = '/images/products/sk007.png' WHERE id = 31;
UPDATE products SET image = '/images/products/sk008.png' WHERE id = 32;
UPDATE products SET image = '/images/products/ms001.png' WHERE id = 33;
UPDATE products SET image = '/images/products/ms002.png' WHERE id = 34;
UPDATE products SET image = '/images/products/ms003.png' WHERE id = 35;
UPDATE products SET image = '/images/products/ms004.png' WHERE id = 36;
UPDATE products SET image = '/images/products/ms005.png' WHERE id = 37;
UPDATE products SET image = '/images/products/ms006.png' WHERE id = 38;
UPDATE products SET image = '/images/products/ms007.png' WHERE id = 39;
UPDATE products SET image = '/images/products/ms008.png' WHERE id = 40;
UPDATE products SET image = '/images/products/zl001.png' WHERE id = 41;
UPDATE products SET image = '/images/products/zl002.png' WHERE id = 42;
UPDATE products SET image = '/images/products/zl003.png' WHERE id = 43;
UPDATE products SET image = '/images/products/zl004.png' WHERE id = 44;
UPDATE products SET image = '/images/products/zl005.png' WHERE id = 45;
UPDATE products SET image = '/images/products/zl006.png' WHERE id = 46;
UPDATE products SET image = '/images/products/zl007.png' WHERE id = 47;
UPDATE products SET image = '/images/products/zl008.png' WHERE id = 48;
UPDATE products SET image = '/images/products/yx009.png' WHERE id = 49;
UPDATE products SET image = '/images/products/yx010.png' WHERE id = 50;
UPDATE products SET image = '/images/products/ms009.png' WHERE id = 51;
UPDATE products SET image = '/images/products/sk009.png' WHERE id = 52;
UPDATE products SET image = '/images/products/sk010.png' WHERE id = 53;
UPDATE products SET image = '/images/products/yp009.png' WHERE id = 54;

-- 验证更新结果
SELECT '分类统计：' as info;
SELECT 
    c.id as category_id,
    c.name as category_name,
    COUNT(p.id) as product_count,
    GROUP_CONCAT(SUBSTRING_INDEX(p.image, '/', -1) ORDER BY p.id SEPARATOR ', ') as images
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY c.id;

SELECT '所有商品图片：' as info;
SELECT id, name, image FROM products ORDER BY id;
