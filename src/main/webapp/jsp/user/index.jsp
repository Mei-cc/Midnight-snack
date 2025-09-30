<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户首页 - 深夜美食</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/user-index.css" onerror="console.error('Failed to load user-index.css')">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" onerror="console.error('Failed to load Font Awesome')" crossorigin="anonymous">
</head>
<body>
    <!-- 导航栏 -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-moon"></i>
                    <h1>深夜美食</h1>
                </div>
                <nav class="user-nav">
                    <div class="user-info">
                        <i class="fas fa-user-circle"></i>
                        <span>欢迎，${user.username}！</span>
                    </div>
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/user/profile" class="nav-link">
                            <i class="fas fa-user-cog"></i>个人中心
                        </a>
                        <a href="${pageContext.request.contextPath}/user/cart" class="nav-link">
                            <i class="fas fa-shopping-cart"></i>购物车
                        </a>
                        <a href="${pageContext.request.contextPath}/user/orders" class="nav-link">
                            <i class="fas fa-clipboard-list"></i>我的订单
                        </a>
                        <a href="${pageContext.request.contextPath}/user/favorites" class="nav-link">
                            <i class="fas fa-heart"></i>我的收藏
                        </a>
                        <a href="${pageContext.request.contextPath}/user/logout" class="nav-link logout">
                            <i class="fas fa-sign-out-alt"></i>退出
                        </a>
                    </div>
                </nav>
            </div>
        </div>
    </header>

    <!-- 轮播图 -->
    <section class="carousel-section">
        <div class="container">
            <div class="carousel-container">
                <div class="carousel-wrapper">
                    <div class="carousel-slides" id="carouselSlides">
                        <!-- 进度条 -->
                        <div class="carousel-progress">
                            <div class="progress-bar" id="progressBar"></div>
                        </div>
                        <c:choose>
                            <c:when test="${not empty banners}">
                                <c:forEach var="banner" items="${banners}" varStatus="status">
                                    <div class="carousel-slide ${status.index == 0 ? 'active' : ''}">
                                        <div class="slide-image">
                                            <c:choose>
                                                <c:when test="${not empty banner.image}">
                                                    <img src="${banner.image}" alt="${banner.title}" 
                                                         onerror="this.src='https://picsum.photos/800/400?random=${status.index + 1}';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://picsum.photos/800/400?random=${status.index + 1}" 
                                                         alt="${banner.title}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="slide-content">
                                            <h3>${banner.title}</h3>
                                            <p>深夜美食，为你的夜晚增添美味</p>
                                            <c:if test="${banner.linkUrl != null}">
                                                <button class="order-btn" onclick="window.location.href='${banner.linkUrl}'">
                                                    <i class="fas fa-external-link-alt"></i>了解更多
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="product" items="${carouselProducts}" varStatus="status">
                                    <div class="carousel-slide ${status.index == 0 ? 'active' : ''}">
                                        <div class="slide-image">
                                            <c:choose>
                                                <c:when test="${not empty product.imageUrl}">
                                                    <img src="${product.imageUrl}" alt="${product.name}" 
                                                         onerror="this.src='https://picsum.photos/800/400?random=${status.index + 10}';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://picsum.photos/800/400?random=${status.index + 10}" 
                                                         alt="${product.name}">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="slide-content">
                                            <h3>${product.name}</h3>
                                            <p>${product.description}</p>
                                            <div class="slide-price">
                                                <span class="current-price">¥${product.price}</span>
                                                <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                                    <span class="original-price">¥${product.originalPrice}</span>
                                                </c:if>
                                            </div>
                                            <button class="order-btn" onclick="orderProduct(${product.id})">
                                                <i class="fas fa-shopping-cart"></i>立即下单
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- 默认轮播图（当没有数据时显示） -->
                        <c:if test="${empty banners and empty carouselProducts}">
                            <div class="carousel-slide active">
                                <div class="slide-image">
                                    <img src="https://picsum.photos/800/400?random=1" alt="深夜美食特惠">
                                </div>
                                <div class="slide-content">
                                    <h3>深夜美食特惠</h3>
                                    <p>深夜美食，为你的夜晚增添美味</p>
                                    <button class="order-btn" onclick="searchProducts()">
                                        <i class="fas fa-search"></i>了解更多
                                    </button>
                                </div>
                            </div>
                            <div class="carousel-slide">
                                <div class="slide-image">
                                    <img src="https://picsum.photos/800/400?random=2" alt="夜宵小食">
                                </div>
                                <div class="slide-content">
                                    <h3>夜宵小食</h3>
                                    <p>精选夜宵，满足你的深夜食欲</p>
                                    <button class="order-btn" onclick="searchByCategory('nightsnack')">
                                        <i class="fas fa-utensils"></i>立即品尝
                                    </button>
                                </div>
                            </div>
                            <div class="carousel-slide">
                                <div class="slide-image">
                                    <img src="https://picsum.photos/800/400?random=3" alt="热销饮品">
                                </div>
                                <div class="slide-content">
                                    <h3>热销饮品</h3>
                                    <p>温暖饮品，陪伴你的每一个夜晚</p>
                                    <button class="order-btn" onclick="searchByCategory('drinks')">
                                        <i class="fas fa-coffee"></i>立即下单
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </div>
                    <button class="carousel-btn prev" onclick="previousSlide()">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="carousel-btn next" onclick="nextSlide()">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
                <div class="carousel-dots">
                    <c:choose>
                        <c:when test="${not empty banners}">
                            <c:forEach var="banner" items="${banners}" varStatus="status">
                                <span class="dot ${status.index == 0 ? 'active' : ''}" onclick="goToSlide(${status.index})"></span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="product" items="${carouselProducts}" varStatus="status">
                                <span class="dot ${status.index == 0 ? 'active' : ''}" onclick="goToSlide(${status.index})"></span>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- 默认指示点（当没有数据时显示） -->
                    <c:if test="${empty banners and empty carouselProducts}">
                        <span class="dot active" onclick="goToSlide(0)"></span>
                        <span class="dot" onclick="goToSlide(1)"></span>
                        <span class="dot" onclick="goToSlide(2)"></span>
                    </c:if>
                </div>
            </div>
        </div>
    </section>

    <!-- 主要内容区域 -->
    <main class="main-content">
        <div class="container">
            <!-- 搜索栏 -->
            <section class="search-section">
                <div class="search-container">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="搜索你想要的深夜美食...">
                        <button onclick="searchProducts()">搜索</button>
                    </div>
                </div>
            </section>

            <!-- 商品分类 -->
            <section class="categories-section">
                <div class="section-header">
                    <h2><i class="fas fa-th-large"></i>美食分类</h2>
                    <p>多样美食分类，满足你的不同口味需求</p>
                </div>
                <div class="categories-grid">
                    <!-- 动态分类数据 -->
                    <c:if test="${not empty categories}">
                        <c:forEach var="category" items="${categories}" varStatus="status">
                            <div class="category-card" onclick="searchByCategory(${category.id})">
                                <div class="category-icon">
                                    <c:choose>
                                        <c:when test="${category.name == '夜宵小食'}">🍢</c:when>
                                        <c:when test="${category.name == '饮品'}">🥤</c:when>
                                        <c:when test="${category.name == '甜品'}">🍰</c:when>
                                        <c:when test="${category.name == '烧烤'}">🍖</c:when>
                                        <c:when test="${category.name == '面食'}">🍜</c:when>
                                        <c:when test="${category.name == '粥类'}">🥣</c:when>
                                        <c:otherwise>🍽️</c:otherwise>
                                    </c:choose>
                                </div>
                                <h3>${category.name}</h3>
                                <p>${category.description}</p>
                            </div>
                        </c:forEach>
                    </c:if>
                    
                    <!-- 静态分类展示（当数据库无数据时显示） -->
                    <c:if test="${empty categories}">
                        <div class="category-card" onclick="searchByCategory('nightsnack')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=150&h=150&fit=crop&crop=center" 
                                     alt="夜宵小食" onerror="this.style.display='none'; this.parentNode.innerHTML='🍢';" />
                            </div>
                            <h3>夜宵小食</h3>
                            <p>烧烤、炸鸡、薯条等美味小食</p>
                        </div>
                        <div class="category-card" onclick="searchByCategory('drinks')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1544145945-f90425340c7e?w=150&h=150&fit=crop&crop=center" 
                                     alt="饮品" onerror="this.style.display='none'; this.parentNode.innerHTML='🥤';" />
                            </div>
                            <h3>饮品</h3>
                            <p>奶茶、咖啡、果汁等各类饮品</p>
                        </div>
                        <div class="category-card" onclick="searchByCategory('dessert')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1551024506-0bccd828d307?w=150&h=150&fit=crop&crop=center" 
                                     alt="甜品" onerror="this.style.display='none'; this.parentNode.innerHTML='🍰';" />
                            </div>
                            <h3>甜品</h3>
                            <p>蛋糕、布丁、冰淇淋等精美甜品</p>
                        </div>
                        <div class="category-card" onclick="searchByCategory('bbq')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1529193591184-b1d58069ecdd?w=150&h=150&fit=crop&crop=center" 
                                     alt="烧烤" onerror="this.style.display='none'; this.parentNode.innerHTML='🍖';" />
                            </div>
                            <h3>烧烤</h3>
                            <p>烤肉、烤鸡翅等各种烧烤美食</p>
                        </div>
                        <div class="category-card" onclick="searchByCategory('noodles')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=150&h=150&fit=crop&crop=center" 
                                     alt="面食" onerror="this.style.display='none'; this.parentNode.innerHTML='🍜';" />
                            </div>
                            <h3>面食</h3>
                            <p>面条、饺子、包子等传统面食</p>
                        </div>
                        <div class="category-card" onclick="searchByCategory('soup')">
                            <div class="category-icon">
                                <img src="https://images.unsplash.com/photo-1547592180-85f173990554?w=150&h=150&fit=crop&crop=center" 
                                     alt="汤类" onerror="this.style.display='none'; this.parentNode.innerHTML='🥣';" />
                            </div>
                            <h3>汤类</h3>
                            <p>热汤、粥品等各种暖胃汤品</p>
                        </div>
                    </c:if>
                </div>
            </section>

            <!-- 公告区域 -->
            <c:if test="${not empty announcements or not empty activityAnnouncements}">
                <section class="announcements-section">
                    <div class="announcements-container">
                        <c:if test="${not empty announcements}">
                            <div class="announcement-group">
                                <h3><i class="fas fa-bullhorn"></i>系统公告</h3>
                                <div class="announcement-list">
                                    <c:forEach var="announcement" items="${announcements}" varStatus="status">
                                        <div class="announcement-item" onclick="showAnnouncementDetail('${announcement.title}', '${announcement.content}')">
                                            <div class="announcement-icon">
                                                <i class="fas fa-info-circle"></i>
                                            </div>
                                            <div class="announcement-content">
                                                <h4>${announcement.title}</h4>
                                                <p>${announcement.content.length() > 50 ? announcement.content.substring(0, 50) + '...' : announcement.content}</p>
                                                <span class="announcement-time">
                                                    <i class="fas fa-clock"></i>
                                                    <script>document.write(new Date('${announcement.createTime}').toLocaleDateString());</script>
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty activityAnnouncements}">
                            <div class="announcement-group">
                                <h3><i class="fas fa-gift"></i>活动公告</h3>
                                <div class="announcement-list">
                                    <c:forEach var="activity" items="${activityAnnouncements}" varStatus="status">
                                        <div class="announcement-item activity" onclick="showAnnouncementDetail('${activity.title}', '${activity.content}')">
                                            <div class="announcement-icon">
                                                <i class="fas fa-star"></i>
                                            </div>
                                            <div class="announcement-content">
                                                <h4>${activity.title}</h4>
                                                <p>${activity.content.length() > 50 ? activity.content.substring(0, 50) + '...' : activity.content}</p>
                                                <span class="announcement-time">
                                                    <i class="fas fa-clock"></i>
                                                    <script>document.write(new Date('${activity.createTime}').toLocaleDateString());</script>
                                                </span>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </section>
            </c:if>

            <!-- 推荐商品 -->
            <section class="products-section">
                <div class="section-header">
                    <h2><i class="fas fa-star"></i>今日推荐</h2>
                    <p>精选优质美食，为你的深夜时光增添美味</p>
                </div>
                <div class="product-grid" id="recommendedProducts">
                    <c:forEach var="product" items="${recommendedProducts}" varStatus="status">
                        <div class="product-card" onclick="viewProduct(${product.id})">
                            <div class="product-image">
                            <c:choose>
                                <c:when test="${not empty product.image}">
                                    <img src="${product.image}" alt="${product.name}" onerror="this.src='https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop&crop=center';">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop&crop=center" 
                                         alt="${product.name}" onerror="this.parentNode.classList.add('default-image');">
                                </c:otherwise>
                            </c:choose>
                                <div class="product-overlay">
                                    <button class="favorite-btn" onclick="event.stopPropagation(); toggleFavorite(${product.id})">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <c:if test="${product.isRecommended == 1}">
                                    <div class="product-badge recommended">推荐</div>
                                </c:if>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${product.name}</h3>
                                <p class="product-desc">${product.description}</p>
                                <div class="product-stats">
                                    <span class="sales-count"><i class="fas fa-fire"></i>销量 ${product.salesCount}</span>
                                    <span class="merchant-name"><i class="fas fa-store"></i>${product.merchantName}</span>
                                </div>
                                <div class="product-price">
                                    <span class="current-price">¥${product.price}</span>
                                    <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                        <span class="original-price">¥${product.originalPrice}</span>
                                    </c:if>
                                </div>
                                <button class="add-cart-btn" onclick="event.stopPropagation(); addToCart(${product.id})">
                                    <i class="fas fa-shopping-cart"></i>加入购物车
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <!-- 热销商品 -->
            <section class="products-section">
                <div class="section-header">
                    <h2><i class="fas fa-fire"></i>热销美食</h2>
                    <p>人气爆款，深受食客喜爱的美味选择</p>
                </div>
                <div class="product-grid" id="hotSalesProducts">
                    <c:forEach var="product" items="${hotSalesProducts}" varStatus="status">
                        <div class="product-card" onclick="viewProduct(${product.id})">
                            <div class="product-image">
                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=200&fit=crop&crop=center';">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-${1504674900247 + (status.index * 987654)}?w=300&h=200&fit=crop&crop=center" 
                                         alt="${product.name}" onerror="this.src='https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=300&h=200&fit=crop&crop=center';">
                                </c:otherwise>
                            </c:choose>
                                <div class="product-overlay">
                                    <button class="favorite-btn" onclick="event.stopPropagation(); toggleFavorite(${product.id})">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="product-badge hot">热销</div>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${product.name}</h3>
                                <p class="product-desc">${product.description}</p>
                                <div class="product-stats">
                                    <span class="sales-count"><i class="fas fa-fire"></i>销量 ${product.salesCount}</span>
                                    <span class="merchant-name"><i class="fas fa-store"></i>${product.merchantName}</span>
                                </div>
                                <div class="product-price">
                                    <span class="current-price">¥${product.price}</span>
                                    <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                        <span class="original-price">¥${product.originalPrice}</span>
                                    </c:if>
                                </div>
                                <button class="add-cart-btn" onclick="event.stopPropagation(); addToCart(${product.id})">
                                    <i class="fas fa-shopping-cart"></i>加入购物车
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

            <!-- 最新商品 -->
            <section class="products-section">
                <div class="section-header">
                    <h2><i class="fas fa-sparkles"></i>新品上市</h2>
                    <p>最新上架的美味佳肴，抢先品尝</p>
                </div>
                <div class="product-grid" id="newProducts">
                    <c:forEach var="product" items="${newProducts}" varStatus="status">
                        <div class="product-card" onclick="viewProduct(${product.id})">
                            <div class="product-image">
                            <c:choose>
                                <c:when test="${not empty product.imageUrl}">
                                    <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src='https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=200&fit=crop&crop=center';">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-${1414235077428 + (status.index * 555555)}?w=300&h=200&fit=crop&crop=center" 
                                         alt="${product.name}" onerror="this.src='https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=300&h=200&fit=crop&crop=center';">
                                </c:otherwise>
                            </c:choose>
                                <div class="product-overlay">
                                    <button class="favorite-btn" onclick="event.stopPropagation(); toggleFavorite(${product.id})">
                                        <i class="fas fa-heart"></i>
                                    </button>
                                </div>
                                <div class="product-badge new">新品</div>
                            </div>
                            <div class="product-info">
                                <h3 class="product-name">${product.name}</h3>
                                <p class="product-desc">${product.description}</p>
                                <div class="product-stats">
                                    <span class="sales-count"><i class="fas fa-fire"></i>销量 ${product.salesCount}</span>
                                    <span class="merchant-name"><i class="fas fa-store"></i>${product.merchantName}</span>
                                </div>
                                <div class="product-price">
                                    <span class="current-price">¥${product.price}</span>
                                    <c:if test="${product.originalPrice != null && product.originalPrice > product.price}">
                                        <span class="original-price">¥${product.originalPrice}</span>
                                    </c:if>
                                </div>
                                <button class="add-cart-btn" onclick="event.stopPropagation(); addToCart(${product.id})">
                                    <i class="fas fa-shopping-cart"></i>加入购物车
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </div>
    </main>

    <!-- 页尾 -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <div class="footer-logo">
                        <i class="fas fa-moon"></i>
                        <h3>深夜美食</h3>
                    </div>
                    <p>专注深夜美食配送，为你的夜晚增添美味</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-weixin"></i></a>
                        <a href="#"><i class="fab fa-weibo"></i></a>
                        <a href="#"><i class="fab fa-qq"></i></a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h4>服务支持</h4>
                    <ul>
                        <li><a href="#">帮助中心</a></li>
                        <li><a href="#">配送说明</a></li>
                        <li><a href="#">退款政策</a></li>
                        <li><a href="#">联系客服</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>商家合作</h4>
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/merchant/register">商家入驻</a></li>
                        <li><a href="#">合作政策</a></li>
                        <li><a href="#">营销推广</a></li>
                        <li><a href="#">数据报告</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h4>关于我们</h4>
                    <ul>
                        <li><a href="#">公司简介</a></li>
                        <li><a href="#">发展历程</a></li>
                        <li><a href="#">招聘信息</a></li>
                        <li><a href="#">隐私政策</a></li>
                    </ul>
                </div>
                
                <div class="footer-section contact">
                    <h4>联系我们</h4>
                    <div class="contact-info">
                        <p><i class="fas fa-phone"></i>客服热线：400-123-4567</p>
                        <p><i class="fas fa-envelope"></i>邮箱：service@midnightsnack.com</p>
                        <p><i class="fas fa-map-marker-alt"></i>地址：北京市朝阳区美食街123号</p>
                        <p><i class="fas fa-clock"></i>服务时间：18:00-06:00</p>
                    </div>
                </div>
            </div>
            
            <div class="footer-bottom">
                <div class="copyright">
                    <p>&copy; 2024 深夜美食. 保留所有权利. | 京ICP备12345678号</p>
                </div>
                <div class="footer-links">
                    <a href="#">服务条款</a>
                    <a href="#">隐私政策</a>
                    <a href="#">网站地图</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- 返回顶部按钮 -->
    <button id="backToTop" class="back-to-top" onclick="scrollToTop()">
        <i class="fas fa-arrow-up"></i>
    </button>

    <script src="${pageContext.request.contextPath}/static/js/jquery.min.js" onerror="console.error('Failed to load jQuery')"></script>
    <script>
        // 错误处理
        window.addEventListener('error', function(e) {
            console.error('JavaScript Error:', e.error);
        });
        
        // 全局变量
        var currentSlide = 0;
        var slides = [];
        var dots = [];
        var totalSlides = 0;
        var carouselInterval = null;
        var progressInterval = null;
        var autoPlayDuration = 5000; // 5秒
        var touchStartX = 0;
        var touchEndX = 0;
        var isTransitioning = false;
        
        // 全局函数定义（供HTML onclick使用）- 使用window对象确保全局可访问
        // 下一张图片
        window.nextSlide = function() {
            try {
                // 如果轮播图还未初始化，先初始化
                if (totalSlides === 0) {
                    slides = document.querySelectorAll('.carousel-slide');
                    dots = document.querySelectorAll('.dot');
                    totalSlides = slides.length;
                }
                
                if (totalSlides === 0 || isTransitioning) return;
                
                const nextIndex = (currentSlide + 1) % totalSlides;
                window.goToSlide(nextIndex);
            } catch (error) {
                console.error('Error in nextSlide:', error);
            }
        };

        // 上一张图片
        window.previousSlide = function() {
            try {
                // 如果轮播图还未初始化，先初始化
                if (totalSlides === 0) {
                    slides = document.querySelectorAll('.carousel-slide');
                    dots = document.querySelectorAll('.dot');
                    totalSlides = slides.length;
                }
                
                if (totalSlides === 0 || isTransitioning) return;
                
                const prevIndex = (currentSlide - 1 + totalSlides) % totalSlides;
                window.goToSlide(prevIndex);
            } catch (error) {
                console.error('Error in previousSlide:', error);
            }
        };

        // 跳转到指定图片
        window.goToSlide = function(index) {
            try {
                // 如果轮播图还未初始化，先初始化
                if (totalSlides === 0) {
                    slides = document.querySelectorAll('.carousel-slide');
                    dots = document.querySelectorAll('.dot');
                    totalSlides = slides.length;
                }
                
                if (totalSlides === 0 || isTransitioning || index === currentSlide) return;
                
                // 确保索引在有效范围内
                if (index < 0 || index >= totalSlides) return;
                
                isTransitioning = true;
                
                // 移除当前活动状态
                if (slides[currentSlide]) {
                    slides[currentSlide].classList.remove('active');
                }
                if (dots[currentSlide]) {
                    dots[currentSlide].classList.remove('active');
                }
                
                // 设置新的活动状态
                currentSlide = index;
                if (slides[currentSlide]) {
                    slides[currentSlide].classList.add('active');
                }
                if (dots[currentSlide]) {
                    dots[currentSlide].classList.add('active');
                }
                
                // 重启自动播放
                if (typeof startCarouselAutoPlay === 'function' && carouselInterval) {
                    startCarouselAutoPlay();
                }
                
                // 过渡完成后重置状态
                setTimeout(() => {
                    isTransitioning = false;
                }, 600);
            } catch (error) {
                console.error('Error in goToSlide:', error);
                isTransitioning = false;
            }
        };
        
        // 页面加载完成后初始化
        document.addEventListener('DOMContentLoaded', function() {
            initializeCarousel();
        });
        
        // 初始化轮播图
        function initializeCarousel() {
            slides = document.querySelectorAll('.carousel-slide');
            dots = document.querySelectorAll('.dot');
            totalSlides = slides.length;
            
            if (totalSlides > 0) {
                setupEventListeners();
                startCarouselAutoPlay();
                preloadImages();
            }
        }
        
        // 设置事件监听器
        function setupEventListeners() {
            const carouselContainer = document.querySelector('.carousel-container');
            if (!carouselContainer) return;
            
            // 鼠标事件
            carouselContainer.addEventListener('mouseenter', pauseCarouselAutoPlay);
            carouselContainer.addEventListener('mouseleave', startCarouselAutoPlay);
            
            // 触摸事件
            carouselContainer.addEventListener('touchstart', handleTouchStart, { passive: true });
            carouselContainer.addEventListener('touchmove', handleTouchMove, { passive: true });
            carouselContainer.addEventListener('touchend', handleTouchEnd, { passive: true });
            
            // 键盘事件
            document.addEventListener('keydown', handleKeyDown);
            
            // 窗口大小变化事件
            window.addEventListener('resize', handleResize);
        }

        // 启动轮播图自动播放
        function startCarouselAutoPlay() {
            if (totalSlides <= 1) return;
            
            clearInterval(carouselInterval);
            clearInterval(progressInterval);
            
            // 启动自动切换
            carouselInterval = setInterval(window.nextSlide, autoPlayDuration);
            
            // 启动进度条动画
            startProgressAnimation();
        }
        
        // 启动进度条动画
        function startProgressAnimation() {
            const progressBar = document.getElementById('progressBar');
            if (!progressBar) return;
            
            progressBar.style.width = '0%';
            progressBar.style.transition = 'none';
            
            setTimeout(() => {
                progressBar.style.transition = `width ${autoPlayDuration}ms linear`;
                progressBar.style.width = '100%';
            }, 50);
        }
        
        // 暂停轮播图自动播放
        function pauseCarouselAutoPlay() {
            clearInterval(carouselInterval);
            clearInterval(progressInterval);
            
            const progressBar = document.getElementById('progressBar');
            if (progressBar) {
                progressBar.style.transition = 'none';
            }
        }


        // 触摸事件处理
        function handleTouchStart(e) {
            touchStartX = e.touches[0].clientX;
            pauseCarouselAutoPlay();
        }
        
        function handleTouchMove(e) {
            touchEndX = e.touches[0].clientX;
        }
        
        function handleTouchEnd(e) {
            const touchDiff = touchStartX - touchEndX;
            const minSwipeDistance = 50;
            
            if (Math.abs(touchDiff) > minSwipeDistance) {
                if (touchDiff > 0) {
                    window.nextSlide(); // 向左滑动，显示下一张
                } else {
                    window.previousSlide(); // 向右滑动，显示上一张
                }
            } else {
                startCarouselAutoPlay(); // 重启自动播放
            }
        }
        
        // 键盘事件处理
        function handleKeyDown(e) {
            if (document.querySelector('.carousel-container:hover')) {
                switch(e.key) {
                    case 'ArrowLeft':
                        e.preventDefault();
                        window.previousSlide();
                        break;
                    case 'ArrowRight':
                        e.preventDefault();
                        window.nextSlide();
                        break;
                    case ' ': // 空格键暂停/恢复
                        e.preventDefault();
                        if (carouselInterval) {
                            pauseCarouselAutoPlay();
                        } else {
                            startCarouselAutoPlay();
                        }
                        break;
                }
            }
        }
        
        // 窗口大小变化处理
        function handleResize() {
            // 重新计算轮播图尺寸
            const slides = document.querySelectorAll('.carousel-slide');
            slides.forEach(slide => {
                slide.style.width = '100%';
            });
        }
        
        // 预加载图片
        function preloadImages() {
            const images = document.querySelectorAll('.carousel-slide img');
            images.forEach((img, index) => {
                if (index > 0) { // 跳过第一张，它已经显示了
                    const preloadImg = new Image();
                    preloadImg.src = img.src;
                }
            });
        }

        // 搜索商品
        function searchProducts() {
            const keyword = document.getElementById('searchInput').value.trim();
            if (keyword) {
                window.location.href = `${pageContext.request.contextPath}/products?keyword=${encodeURIComponent(keyword)}`;
            }
        }

        // 按分类搜索
        function searchByCategory(categoryId) {
            window.location.href = `${pageContext.request.contextPath}/products?categoryId=${categoryId}`;
        }

        // 显示公告详情
        function showAnnouncementDetail(title, content) {
            const modal = document.createElement('div');
            modal.className = 'announcement-modal';
            modal.innerHTML = `
                <div class="modal-overlay" onclick="closeModal()"></div>
                <div class="modal-content">
                    <div class="modal-header">
                        <h3>${title}</h3>
                        <button class="close-btn" onclick="closeModal()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p>${content}</p>
                    </div>
                </div>
            `;
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 10000;
                display: flex;
                align-items: center;
                justify-content: center;
            `;
            
            const overlay = modal.querySelector('.modal-overlay');
            overlay.style.cssText = `
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                backdrop-filter: blur(5px);
            `;
            
            const modalContent = modal.querySelector('.modal-content');
            modalContent.style.cssText = `
                background: var(--midnight-glass);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 20px;
                max-width: 600px;
                width: 90%;
                max-height: 80%;
                overflow-y: auto;
                position: relative;
                animation: modalSlideIn 0.3s ease-out;
            `;
            
            const modalHeader = modal.querySelector('.modal-header');
            modalHeader.style.cssText = `
                padding: 30px 30px 20px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            `;
            
            const modalBody = modal.querySelector('.modal-body');
            modalBody.style.cssText = `
                padding: 30px;
                line-height: 1.8;
                color: var(--midnight-text-muted);
            `;
            
            const closeBtn = modal.querySelector('.close-btn');
            closeBtn.style.cssText = `
                background: none;
                border: none;
                color: var(--midnight-text);
                font-size: 1.5rem;
                cursor: pointer;
                padding: 5px;
                border-radius: 50%;
                transition: all 0.3s ease;
            `;
            
            document.body.appendChild(modal);
            
            window.closeModal = function() {
                document.body.removeChild(modal);
                delete window.closeModal;
            };
        }

        // 查看商品详情
        function viewProduct(productId) {
            window.location.href = `${pageContext.request.contextPath}/product/${productId}`;
        }

        // 加入购物车
        function addToCart(productId) {
            $.ajax({
                url: `${pageContext.request.contextPath}/api/cart/add`,
                method: 'POST',
                data: {
                    productId: productId,
                    quantity: 1
                },
                success: function(result) {
                    if (result.success) {
                        showMessage('已加入购物车', 'success');
                    } else {
                        showMessage(result.message || '加入购物车失败', 'error');
                    }
                },
                error: function() {
                    showMessage('网络错误，请稍后重试', 'error');
                }
            });
        }

        // 切换收藏
        function toggleFavorite(productId) {
            $.ajax({
                url: `${pageContext.request.contextPath}/api/favorites/toggle`,
                method: 'POST',
                data: {
                    productId: productId
                },
                success: function(result) {
                    if (result.success) {
                        showMessage(result.message, 'success');
                        // 更新收藏按钮状态
                        const btn = event.target.closest('.favorite-btn');
                        btn.classList.toggle('active');
                    } else {
                        showMessage(result.message || '操作失败', 'error');
                    }
                },
                error: function() {
                    showMessage('网络错误，请稍后重试', 'error');
                }
            });
        }

        // 立即下单
        function orderProduct(productId) {
            addToCart(productId);
            setTimeout(() => {
                window.location.href = `${pageContext.request.contextPath}/user/cart`;
            }, 1000);
        }

        // 显示消息
        function showMessage(message, type) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${type}`;
            messageDiv.textContent = message;
            
            messageDiv.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 12px 24px;
                border-radius: 8px;
                color: white;
                font-weight: 500;
                z-index: 10000;
                animation: slideInRight 0.3s ease;
                background: ` + (type === 'success' ? '#10B981' : '#EF4444') + `;
            `;
            
            document.body.appendChild(messageDiv);
            
            setTimeout(() => {
                messageDiv.remove();
            }, 3000);
        }

        // 返回顶部
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // 监听滚动事件，显示/隐藏返回顶部按钮
        window.addEventListener('scroll', function() {
            const backToTop = document.getElementById('backToTop');
            if (window.pageYOffset > 300) {
                backToTop.classList.add('show');
            } else {
                backToTop.classList.remove('show');
            }
        });

        // 搜索框回车事件
        document.getElementById('searchInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchProducts();
            }
        });

        // 图片加载优化
        function initImageLoading() {
            // 处理轮播图图片
            const carouselImages = document.querySelectorAll('.slide-image img');
            carouselImages.forEach(img => {
                if (img.complete) {
                    img.classList.add('loaded');
                } else {
                    img.addEventListener('load', function() {
                        this.classList.add('loaded');
                    });
                }
            });

            // 处理分类图片
            const categoryImages = document.querySelectorAll('.category-icon img');
            categoryImages.forEach(img => {
                if (img.complete) {
                    img.classList.add('loaded');
                } else {
                    img.addEventListener('load', function() {
                        this.classList.add('loaded');
                    });
                }
            });

            // 处理商品图片
            const productImages = document.querySelectorAll('.product-image img');
            productImages.forEach(img => {
                if (img.complete) {
                    img.classList.add('loaded');
                } else {
                    img.addEventListener('load', function() {
                        this.classList.add('loaded');
                    });
                }
            });
        }

        // jQuery 文档就绪（备用初始化）
        $(document).ready(function() {
            // 在 DOMContentLoaded 中已经初始化，这里作为备用
            if (totalSlides === 0) {
                slides = document.querySelectorAll('.carousel-slide');
                dots = document.querySelectorAll('.dot');
                totalSlides = slides.length;
                startCarouselAutoPlay();
            }
            
            // 初始化图片加载效果
            initImageLoading();
        });
    </script>
</body>
</html>