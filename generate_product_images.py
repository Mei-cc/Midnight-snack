from PIL import Image, ImageDraw, ImageFont
import os

# 创建输出目录
output_dir = "src/main/webapp/static/images/products"
os.makedirs(output_dir, exist_ok=True)

# 商品配置
products = {
    'yx': {'count': 10, 'color': (255, 107, 107), 'name': '夜宵小食'},
    'yp': {'count': 9, 'color': (78, 205, 196), 'name': '饮品'},
    'tp': {'count': 8, 'color': (255, 182, 193), 'name': '甜品'},
    'sk': {'count': 10, 'color': (255, 160, 122), 'name': '烧烤'},
    'ms': {'count': 9, 'color': (244, 164, 96), 'name': '面食'},
    'zl': {'count': 8, 'color': (221, 160, 221), 'name': '粥类'}
}

# 商品名称映射
product_names = {
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
}

def create_product_image(filename, color, product_code, product_name):
    # 创建图片
    img = Image.new('RGB', (400, 400), color='white')
    draw = ImageDraw.Draw(img)
    
    # 绘制背景渐变效果（简化版）
    for i in range(400):
        shade = int(color[0] * (1 - i/800))
        draw.line([(0, i), (400, i)], fill=(
            max(color[0] - shade, 0),
            max(color[1] - shade, 0),
            max(color[2] - shade, 0)
        ))
    
    # 绘制装饰性边框
    draw.rectangle([20, 20, 380, 380], outline='white', width=3)
    draw.rectangle([30, 30, 370, 370], outline='white', width=1)
    
    # 尝试加载字体
    try:
        # Windows 系统字体
        font_large = ImageFont.truetype("msyh.ttc", 40)  # 微软雅黑
        font_medium = ImageFont.truetype("msyh.ttc", 28)
        font_small = ImageFont.truetype("msyh.ttc", 20)
    except:
        try:
            font_large = ImageFont.truetype("simhei.ttf", 40)  # 黑体
            font_medium = ImageFont.truetype("simhei.ttf", 28)
            font_small = ImageFont.truetype("simhei.ttf", 20)
        except:
            font_large = ImageFont.load_default()
            font_medium = ImageFont.load_default()
            font_small = ImageFont.load_default()
    
    # 绘制文字
    # 商品编号
    code_text = product_code.upper()
    code_bbox = draw.textbbox((0, 0), code_text, font=font_large)
    code_width = code_bbox[2] - code_bbox[0]
    draw.text(((400 - code_width) / 2, 120), code_text, fill='white', font=font_large)
    
    # 商品名称
    name_bbox = draw.textbbox((0, 0), product_name, font=font_medium)
    name_width = name_bbox[2] - name_bbox[0]
    draw.text(((400 - name_width) / 2, 200), product_name, fill='white', font=font_medium)
    
    # 标识文字
    label_text = "商品图片"
    label_bbox = draw.textbbox((0, 0), label_text, font=font_small)
    label_width = label_bbox[2] - label_bbox[0]
    draw.text(((400 - label_width) / 2, 280), label_text, fill='white', font=font_small)
    
    # 保存图片
    img.save(os.path.join(output_dir, filename))
    print(f"✓ 已生成: {filename} - {product_name}")

# 生成所有商品图片
total = 0
for prefix, config in products.items():
    print(f"\n生成 {config['name']} 图片...")
    for i in range(1, config['count'] + 1):
        code = f"{prefix}{i:03d}"
        filename = f"{code}.png"
        product_name = product_names.get(code, f"商品{i}")
        create_product_image(filename, config['color'], code, product_name)
        total += 1

print(f"\n{'='*50}")
print(f"✅ 完成！共生成 {total} 个商品占位图")
print(f"📁 保存位置: {output_dir}")
print(f"{'='*50}")
