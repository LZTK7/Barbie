<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Product" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%
    User user = SessionUtil.getLoginUser(session);
    List<Product> products = (List<Product>) request.getAttribute("products");
    String keyword = (String) request.getAttribute("keyword");
    String color = (String) request.getAttribute("color");
    String style = (String) request.getAttribute("style");
    String sort = (String) request.getAttribute("sort");
    if (keyword == null) keyword = "";
    if (color == null) color = "";
    if (style == null) style = "";
    if (sort == null) sort = "default";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>搜索结果 - Barbie</title>
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
        .top-bar .back-home {
            color: #999;
            text-decoration: none;
            font-size: 14px;
        }
        .top-bar .back-home:hover { color: #ff6b81; }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px 40px;
        }

        .search-bar {
            background: white;
            border-radius: 14px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 20px;
        }
        .search-bar .row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: center;
        }
        .search-bar .row input, .search-bar .row select {
            padding: 8px 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            background: white;
            transition: border-color 0.3s;
        }
        .search-bar .row input:focus, .search-bar .row select:focus {
            outline: none;
            border-color: #ff6b81;
        }
        .search-bar .row input[type="text"] {
            flex: 1;
            min-width: 200px;
        }
        .search-bar .row select {
            min-width: 120px;
        }
        .search-bar .row .btn-search {
            padding: 8px 28px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }
        .search-bar .row .btn-search:hover { background: #e8556b; }
        .search-bar .row .btn-reset {
            padding: 8px 20px;
            background: #f0f0f0;
            color: #666;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.3s;
        }
        .search-bar .row .btn-reset:hover { background: #e0e0e0; }

        .result-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            flex-wrap: wrap;
            gap: 8px;
        }
        .result-stats .count {
            font-size: 14px;
            color: #666;
        }
        .result-stats .count span { color: #ff6b81; font-weight: bold; }
        .result-stats .sort-options {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }
        .result-stats .sort-options a {
            padding: 4px 14px;
            border-radius: 14px;
            font-size: 13px;
            color: #666;
            text-decoration: none;
            border: 1px solid #ddd;
            transition: all 0.3s;
        }
        .result-stats .sort-options a:hover {
            border-color: #ff6b81;
            color: #ff6b81;
        }
        .result-stats .sort-options a.active {
            background: #ff6b81;
            color: white;
            border-color: #ff6b81;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }
        .product-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: all 0.3s;
            cursor: pointer;
        }
        .product-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
        }
        .product-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .product-card .info {
            padding: 12px 14px;
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
            margin-top: 6px;
        }

        .empty-result {
            text-align: center;
            padding: 60px 0;
            color: #999;
            grid-column: 1/5;
        }
        .empty-result .icon { font-size: 48px; display: block; margin-bottom: 12px; }

        .footer {
            text-align: center;
            color: #ccc;
            font-size: 13px;
            padding: 30px 0 16px;
            border-top: 1px solid #f0f0f0;
            margin-top: 24px;
        }

        @media (max-width: 900px) {
            .top-bar { padding: 0 16px; }
            .container { padding: 16px; }
            .product-grid { grid-template-columns: repeat(2, 1fr); }
            .search-bar .row input[type="text"] { min-width: 100px; }
            .search-bar .row select { min-width: 80px; }
        }
        @media (max-width: 600px) {
            .product-grid { grid-template-columns: 1fr; }
            .search-bar .row { flex-direction: column; }
            .search-bar .row input[type="text"] { width: 100%; }
            .search-bar .row select { width: 100%; }
        }
    </style>
</head>
<body>

<div class="top-bar">
    <a href="${pageContext.request.contextPath}/index" class="logo">👗 Barbie</a>
    <a href="${pageContext.request.contextPath}/index" class="back-home">← 返回首页</a>
</div>

<div class="container">

    <div class="search-bar">
        <form id="searchForm" action="${pageContext.request.contextPath}/search" method="get">
            <div class="row">
                <input type="text" name="keyword" placeholder="输入关键词搜索（如：黑色裙子）..." value="<%= keyword %>">
                <select name="color" id="searchColor">
                    <option value="">全部颜色</option>
                    <option value="白色" <%= "白色".equals(color) ? "selected" : "" %>>白色</option>
                    <option value="黑色" <%= "黑色".equals(color) ? "selected" : "" %>>黑色</option>
                    <option value="红色" <%= "红色".equals(color) ? "selected" : "" %>>红色</option>
                    <option value="蓝色" <%= "蓝色".equals(color) ? "selected" : "" %>>蓝色</option>
                    <option value="绿色" <%= "绿色".equals(color) ? "selected" : "" %>>绿色</option>
                    <option value="黄色" <%= "黄色".equals(color) ? "selected" : "" %>>黄色</option>
                    <option value="粉色" <%= "粉色".equals(color) ? "selected" : "" %>>粉色</option>
                    <option value="棕色" <%= "棕色".equals(color) ? "selected" : "" %>>棕色</option>
                    <option value="灰色" <%= "灰色".equals(color) ? "selected" : "" %>>灰色</option>
                </select>
                <select name="style" id="searchStyle">
                    <option value="">全部风格</option>
                    <option value="通勤" <%= "通勤".equals(style) ? "selected" : "" %>>通勤</option>
                    <option value="街头" <%= "街头".equals(style) ? "selected" : "" %>>街头</option>
                    <option value="约会" <%= "约会".equals(style) ? "selected" : "" %>>约会</option>
                    <option value="运动" <%= "运动".equals(style) ? "selected" : "" %>>运动</option>
                    <option value="度假" <%= "度假".equals(style) ? "selected" : "" %>>度假</option>
                </select>
                <button type="submit" class="btn-search">🔍 搜索</button>
                <a href="${pageContext.request.contextPath}/search" class="btn-reset">重置</a>
            </div>
        </form>
    </div>

    <div class="result-stats">
        <div class="count">共找到 <span id="resultCount"><%= products != null ? products.size() : 0 %></span> 件商品</div>
        <div class="sort-options">
            <a href="#" data-sort="default" class="<%= "default".equals(sort) ? "active" : "" %>">默认</a>
            <a href="#" data-sort="price_asc" class="<%= "price_asc".equals(sort) ? "active" : "" %>">价格 ↑</a>
            <a href="#" data-sort="price_desc" class="<%= "price_desc".equals(sort) ? "active" : "" %>">价格 ↓</a>
            <a href="#" data-sort="sales" class="<%= "sales".equals(sort) ? "active" : "" %>">销量</a>
        </div>
    </div>

    <div class="product-grid" id="productGrid">
        <%
            if (products == null || products.isEmpty()) {
        %>
        <div class="empty-result">
            <span class="icon">🔍</span>
            没有找到符合条件的商品<br>
            试试其他关键词或筛选条件吧！
        </div>
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
            <div style="width:100%;height:200px;background:#f0f0f0;display:flex;align-items:center;justify-content:center;font-size:48px;color:#ddd;">👕</div>
            <%
                }
            %>
            <div class="info">
                <div class="name"><%= p.getName() %></div>
                <div class="category"><%= p.getCategory() %> · <%= p.getColor() != null ? p.getColor() : "" %> · <%= p.getStyle() != null ? p.getStyle() : "" %></div>
                <div class="price">¥<%= p.getPrice() %></div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <div class="footer">
        © 2026 Barbie · 网上衣橱电商平台 · 课程设计
    </div>
</div>

<script>
    document.getElementById('searchColor').addEventListener('change', function() {
        document.getElementById('searchForm').submit();
    });
    document.getElementById('searchStyle').addEventListener('change', function() {
        document.getElementById('searchForm').submit();
    });

    document.querySelectorAll('.sort-options a').forEach(function(link) {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            var sort = this.dataset.sort;
            var keyword = document.getElementById('searchForm').querySelector('input[name="keyword"]').value;
            var color = document.getElementById('searchColor').value;
            var style = document.getElementById('searchStyle').value;
            var url = '${pageContext.request.contextPath}/search?';
            if (keyword) url += 'keyword=' + encodeURIComponent(keyword) + '&';
            if (color) url += 'color=' + encodeURIComponent(color) + '&';
            if (style) url += 'style=' + encodeURIComponent(style) + '&';
            url += 'sort=' + sort;
            window.location.href = url;
        });
    });

    document.querySelectorAll('.sort-options a').forEach(function(link) {
        link.classList.remove('active');
    });
    var currentSort = '<%= sort %>';
    document.querySelectorAll('.sort-options a').forEach(function(link) {
        if (link.dataset.sort === currentSort) {
            link.classList.add('active');
        }
    });
</script>

</body>
</html>