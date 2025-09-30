const { createCanvas } = require('canvas');
const fs = require('fs');
const path = require('path');

// 创建输出目录
const outputDir = path.join('src', 'main', 'webapp', 'static', 'images', 'products');
if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// 商品配置
const products = {
    'yx': { count: 10, color: '#FF6B6B', name: '夜宵小食' },
    'yp': { count: 9, color: '#4ECDC4', name: '饮品' },
    'tp': { count: 8, color: '#FFB6C1', name: '甜品' },
    'sk': { count: 10, color: '#FFA07A', name: '烧烤' },
    'ms': { count: 9, color: '#F4A460', name: '面食' },
    'zl': { count: 8, color: '#DDA0DD', name: '粥类' }
};

// 商品名称映射
const productNames = {
    'yx001': '香辣小龙虾', 'yx002': '麻辣烫套餐', 'yx003': '关东煮拼盘', 'yx004': '炸鸡排',
    'yx005': '鸭血粉丝汤', 'yx006': '炸串拼盘', 'yx007': '煎饼果子', 'yx008': '肉夹馍',
    'yx009': '深夜炒饭', 'yx010': '铁板鱿鱼',
    'yp001': '珍珠奶茶', 'yp002': '鲜榨果汁', 'yp003': '芝士奶盖茶', 'yp004': '柠檬水',
    'yp005': '冰咖啡', 'yp006': '水果茶', 'yp007': '豆浆', 'yp008': '酸梅汤',
    'yp009': '冰啤酒',
    'tp001': '提拉米苏', 'tp002': '芒果班戟', 'tp003': '双皮奶', 'tp004': '布丁',
    'tp005': '芝士蛋糕', 'tp006': '抹茶慕斯', 'tp007': '冰淇淋球', 'tp008': '红豆沙',
    'sk001': '烤羊肉串', 'sk002': '烤鸡翅', 'sk003': '烤韭菜', 'sk004': '烤茄子',
    'sk005': '烤鱿鱼', 'sk006': '烤玉米', 'sk007': '烤五花肉', 'sk008': '烤蘑菇',
    'sk009': '烧烤拼盘', 'sk010': '烤生蚝',
    'ms001': '兰州拉面', 'ms002': '小笼包', 'ms003': '炸酱面', 'ms004': '刀削面',
    'ms005': '馄饨', 'ms006': '饺子', 'ms007': '热干面', 'ms008': '担担面',
    'ms009': '川味牛肉面',
    'zl001': '小米粥', 'zl002': '海鲜粥', 'zl003': '皮蛋瘦肉粥', 'zl004': '南瓜粥',
    'zl005': '八宝粥', 'zl006': '紫薯粥', 'zl007': '红枣桂圆粥', 'zl008': '黑米粥'
};

function createProductImage(filename, color, productCode, productName) {
    const canvas = createCanvas(400, 400);
    const ctx = canvas.getContext('2d');
    
    // 绘制渐变背景
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, color);
    gradient.addColorStop(1, color + 'AA');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 400, 400);
    
    // 绘制装饰性边框
    ctx.strokeStyle = 'white';
    ctx.lineWidth = 3;
    ctx.strokeRect(20, 20, 360, 360);
    ctx.lineWidth = 1;
    ctx.strokeRect(30, 30, 340, 340);
    
    // 绘制文字
    ctx.fillStyle = 'white';
    ctx.textAlign = 'center';
    
    // 商品编号
    ctx.font = 'bold 40px Arial';
    ctx.fillText(productCode.toUpperCase(), 200, 160);
    
    // 商品名称
    ctx.font = 'bold 28px "Microsoft YaHei", SimHei, Arial';
    ctx.fillText(productName, 200, 230);
    
    // 标识文字
    ctx.font = '20px "Microsoft YaHei", SimHei, Arial';
    ctx.fillText('商品图片', 200, 310);
    
    // 保存图片
    const buffer = canvas.toBuffer('image/png');
    fs.writeFileSync(path.join(outputDir, filename), buffer);
    console.log(`✓ 已生成: ${filename} - ${productName}`);
}

// 生成所有商品图片
let total = 0;
for (const [prefix, config] of Object.entries(products)) {
    console.log(`\n生成 ${config.name} 图片...`);
    for (let i = 1; i <= config.count; i++) {
        const code = `${prefix}${String(i).padStart(3, '0')}`;
        const filename = `${code}.png`;
        const productName = productNames[code] || `商品${i}`;
        createProductImage(filename, config.color, code, productName);
        total++;
    }
}

console.log(`\n${'='.repeat(50)}`);
console.log(`✅ 完成！共生成 ${total} 个商品占位图`);
console.log(`📁 保存位置: ${outputDir}`);
console.log(`${'='.repeat(50)}`);
