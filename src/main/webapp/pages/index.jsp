<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Product" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%@ page import="com.barbie.dao.ProductDao" %>
<%
    User user = SessionUtil.getLoginUser(session);
    ProductDao productDao = new ProductDao();

    String category = request.getParameter("cat");
    String sort = request.getParameter("sort");
    if (category == null) category = "";
    if (sort == null) sort = "default";

    List<Product> products;
    if (!category.isEmpty()) {
        products = productDao.findByCategory(category, 20);
    } else {
        products = productDao.findAll();
    }

    String recommendCategory = (String) request.getAttribute("recommendCategory");
    List<Product> recommendProducts = (List<Product>) request.getAttribute("recommendProducts");
    if (recommendProducts == null) {
        recommendProducts = productDao.getHotProducts(3);
        if (recommendCategory == null) recommendCategory = "热销";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Barbie - 网上衣橱</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; }

        .top-bar {
            background: white;
            padding: 0 40px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 999;
        }
        .logo {
            font-size: 22px;
            font-weight: bold;
            color: #ff6b81;
            text-decoration: none;
        }
        .logo:hover { color: #e8556b; }

        .nav-menu {
            display: flex;
            align-items: center;
            gap: 6px;
            flex: 1;
            margin-left: 30px;
        }
        .nav-item {
            padding: 8px 18px;
            color: #333;
            text-decoration: none;
            font-size: 15px;
            border-radius: 6px;
            transition: all 0.3s;
            background: transparent;
            border: none;
            font-family: inherit;
            cursor: pointer;
        }
        .nav-item:hover {
            background: #ff6b81;
            color: white;
        }

        .dropdown { position: relative; }
        .dropdown-menu {
            display: none;
            position: absolute;
            top: 40px;
            left: 0;
            background: white;
            border-radius: 10px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
            padding: 8px 0;
            min-width: 160px;
            z-index: 1000;
            border: 1px solid #f0f0f0;
        }
        .dropdown-menu a {
            display: block;
            padding: 10px 24px;
            color: #333;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.2s;
        }
        .dropdown-menu a:hover {
            background: #fff0f2;
            color: #ff6b81;
        }
        .dropdown .arrow {
            font-size: 10px;
            margin-left: 4px;
            transition: transform 0.3s;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: #f5f5f5;
            border-radius: 20px;
            padding: 0 16px;
            height: 36px;
            flex: 1;
            max-width: 280px;
            margin: 0 16px;
            transition: all 0.3s;
        }
        .search-box:focus-within {
            background: white;
            box-shadow: 0 0 0 2px #ff6b81;
        }
        .search-box input {
            border: none;
            background: transparent;
            outline: none;
            font-size: 14px;
            width: 100%;
            color: #333;
        }
        .search-box input::placeholder { color: #bbb; }
        .search-box button {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            color: #999;
            padding: 0 4px;
        }
        .search-box button:hover { color: #ff6b81; }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .nav-right .nav-item { font-size: 14px; padding: 8px 12px; }

        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .user-info .username { font-size: 14px; color: #333; }
        .user-info .logout-link {
            font-size: 13px;
            color: #999;
            text-decoration: none;
            transition: all 0.3s;
        }
        .user-info .logout-link:hover { color: #ff6b81; }

        .container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 20px 40px;
            display: flex;
            gap: 24px;
            align-items: flex-start;
        }

        .main-content {
            flex: 1;
            background: white;
            border-radius: 14px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }

        .category-title {
            font-size: 14px;
            color: #999;
            margin-bottom: 16px;
        }
        .category-title span {
            color: #ff6b81;
            font-weight: bold;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        .product-card {
            background: #fafafa;
            border-radius: 10px;
            overflow: hidden;
            transition: all 0.3s;
            cursor: pointer;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
        }
        .product-card img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .product-card .info {
            padding: 10px 14px;
        }
        .product-card .name {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .product-card .category {
            font-size: 12px;
            color: #999;
            margin-top: 2px;
        }
        .product-card .price {
            font-size: 18px;
            font-weight: bold;
            color: #ff6b81;
            margin-top: 4px;
        }

        .empty-products {
            text-align: center;
            color: #999;
            padding: 40px 0;
            grid-column: 1/5;
        }

        .sidebar {
            width: 280px;
            flex-shrink: 0;
        }
        .recommend-box {
            background: white;
            border-radius: 14px;
            padding: 16px 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .recommend-box .title {
            font-size: 14px;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }
        .recommend-box .subtitle {
            font-size: 12px;
            color: #999;
            margin-bottom: 12px;
        }
        .recommend-box .subtitle span { color: #ff6b81; font-weight: bold; }

        .recommend-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid #f5f5f5;
            text-decoration: none;
            transition: all 0.3s;
            cursor: pointer;
        }
        .recommend-item:last-child { border-bottom: none; }
        .recommend-item:hover { transform: translateX(4px); }
        .recommend-item img {
            width: 56px;
            height: 56px;
            object-fit: cover;
            border-radius: 6px;
            background: #f0f0f0;
            flex-shrink: 0;
        }
        .recommend-item .info { flex: 1; }
        .recommend-item .info .name {
            font-size: 13px;
            font-weight: bold;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .recommend-item .info .price {
            font-size: 14px;
            color: #ff6b81;
            font-weight: bold;
        }
        .recommend-item .info .tag {
            font-size: 10px;
            color: #999;
        }

        .footer {
            text-align: center;
            color: #ccc;
            font-size: 13px;
            padding: 20px 40px 16px;
            border-top: 1px solid #f0f0f0;
            margin-top: 8px;
        }

        @media (max-width: 1100px) {
            .container { flex-direction: column; }
            .sidebar { width: 100%; }
            .recommend-item { padding: 8px 0; }
            .recommend-item img { width: 48px; height: 48px; }
        }
        @media (max-width: 900px) {
            .top-bar { padding: 0 16px; flex-wrap: wrap; height: auto; gap: 10px; padding: 12px 16px; }
            .nav-menu { margin-left: 0; flex-wrap: wrap; }
            .search-box { max-width: 100%; margin: 0; }
            .product-grid { grid-template-columns: repeat(2, 1fr); }
            .container { padding: 16px; }
            .main-content { padding: 16px; }
        }
        @media (max-width: 600px) {
            .product-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- ===== 顶部导航 ===== -->
<div class="top-bar">
    <a href="${pageContext.request.contextPath}/index" class="logo">👗 Barbie</a>

    <div class="nav-menu">
        <a href="${pageContext.request.contextPath}/index" class="nav-item">首页</a>
        <div class="dropdown" id="categoryDropdownContainer">
            <span class="nav-item" onclick="toggleDropdown(event)" style="display:inline-block;cursor:pointer;">
                服装类别 <span class="arrow" id="dropdownArrow">▼</span>
            </span>
            <div class="dropdown-menu" id="categoryDropdown">
                <a href="${pageContext.request.contextPath}/index?cat=上装" onclick="closeDropdown()">👕 上装</a>
                <a href="${pageContext.request.contextPath}/index?cat=下装" onclick="closeDropdown()">👗 下装</a>
                <a href="${pageContext.request.contextPath}/index?cat=外套" onclick="closeDropdown()">🧥 外套</a>
                <a href="${pageContext.request.contextPath}/index?cat=连衣裙" onclick="closeDropdown()">👗 连衣裙</a>
                <a href="${pageContext.request.contextPath}/index?cat=鞋" onclick="closeDropdown()">👟 鞋</a>
                <a href="${pageContext.request.contextPath}/index?cat=包" onclick="closeDropdown()">👜 包</a>
                <a href="${pageContext.request.contextPath}/index?cat=配饰" onclick="closeDropdown()">💍 配饰</a>
            </div>
        </div>
    </div>

    <div class="search-box">
        <input type="text" id="searchInput" placeholder="搜索衣服..." onkeyup="if(event.keyCode==13) doSearch()">
        <button onclick="doSearch()">🔍</button>
    </div>

    <div class="nav-right">
        <a href="${pageContext.request.contextPath}/cart/list" class="nav-item">🛒 购物车</a>
        <a href="${pageContext.request.contextPath}/pages/user/profile.jsp" class="nav-item">👤 个人中心</a>
        <%
            if (user != null) {
        %>
        <div class="user-info">
            <span class="username">欢迎，<%= user.getNickname() %></span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-link">退出</a>
        </div>
        <%
        } else {
        %>
        <a href="${pageContext.request.contextPath}/pages/user/login.jsp" class="nav-item" style="background:#ff6b81;color:white;border-radius:20px;padding:8px 20px;">登录</a>
        <%
            }
        %>
    </div>
</div>

<!-- ===== 主要内容区 ===== -->
<div class="container">

    <div class="main-content">
        <div class="category-title">
            当前筛选：<span><%= category.isEmpty() ? "全部商品" : category %></span>
        </div>

        <div class="product-grid">
            <%
                if (products == null || products.isEmpty()) {
            %>
            <div class="empty-products">暂无商品</div>
            <%
            } else {
                for (Product p : products) {
                    String img = p.getImages();
                    if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
                        img = "uploads/" + img;
                    }
            %>
            <div class="product-card" onclick="window.location.href='${pageContext.request.contextPath}/pages/product/detail.jsp?id=<%= p.getId() %>'">
                <%
                    if (img != null && !img.isEmpty()) {
                %>
                <img src="${pageContext.request.contextPath}/<%= img %>" alt="<%= p.getName() %>">
                <%
                } else {
                %>
                <div style="width:100%;height:180px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;font-size:48px;color:#ddd;">👕</div>
                <%
                    }
                %>
                <div class="info">
                    <div class="name"><%= p.getName() %></div>
                    <div class="category"><%= p.getCategory() %> · <%= p.getColor() != null ? p.getColor() : "" %></div>
                    <div class="price">¥<%= p.getPrice() %></div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <div class="sidebar">
        <div class="recommend-box">
            <div class="title">🧠 衣橱补全</div>
            <div class="subtitle">根据你的衣橱，推荐 <span><%= recommendCategory != null ? recommendCategory : "热销" %></span></div>
            <%
                if (recommendProducts != null && !recommendProducts.isEmpty()) {
                    for (Product p : recommendProducts) {
                        String img = p.getImages();
                        if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
                            img = "uploads/" + img;
                        }
            %>
            <a href="${pageContext.request.contextPath}/pages/product/detail.jsp?id=<%= p.getId() %>" class="recommend-item">
                <%
                    if (img != null && !img.isEmpty()) {
                %>
                <img src="${pageContext.request.contextPath}/<%= img %>" alt="<%= p.getName() %>">
                <%
                } else {
                %>
                <div style="width:56px;height:56px;background:#f0f0f0;border-radius:6px;display:flex;align-items:center;justify-content:center;font-size:24px;color:#ddd;">👕</div>
                <%
                    }
                %>
                <div class="info">
                    <div class="name"><%= p.getName() %></div>
                    <div class="price">¥<%= p.getPrice() %></div>
                    <div class="tag"><%= p.getCategory() %></div>
                </div>
            </a>
            <%
                }
            } else {
            %>
            <div style="color:#999;font-size:13px;padding:12px 0;">暂无推荐</div>
            <%
                }
            %>
        </div>
    </div>

</div>

<div class="footer">
    © 2026 Barbie · 网上衣橱电商平台 · 课程设计
</div>

<script>
    var dropdownOpen = false;
    function toggleDropdown(e) {
        e.stopPropagation();
        var menu = document.getElementById('categoryDropdown');
        var arrow = document.getElementById('dropdownArrow');
        if (dropdownOpen) {
            menu.style.display = 'none';
            arrow.textContent = '▼';
            dropdownOpen = false;
        } else {
            menu.style.display = 'block';
            arrow.textContent = '▲';
            dropdownOpen = true;
        }
    }
    function closeDropdown() {
        var menu = document.getElementById('categoryDropdown');
        var arrow = document.getElementById('dropdownArrow');
        menu.style.display = 'none';
        arrow.textContent = '▼';
        dropdownOpen = false;
    }
    document.addEventListener('click', function(e) {
        var container = document.getElementById('categoryDropdownContainer');
        if (container && !container.contains(e.target)) {
            closeDropdown();
        }
    });

    function doSearch() {
        var keyword = document.getElementById('searchInput').value.trim();
        if (keyword) {
            window.location.href = '${pageContext.request.contextPath}/search?keyword=' + encodeURIComponent(keyword);
        }
    }
</script>

</body>
</html>