<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Product" %>
<%
    String recommendCategory = (String) request.getAttribute("recommendCategory");
    List<Product> recommendProducts = (List<Product>) request.getAttribute("recommendProducts");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Barbie - 衣橱电商</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; }
        .header {
            background: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .header .logo { font-size: 20px; font-weight: bold; color: #ff6b81; }
        .header .nav a {
            color: #666;
            text-decoration: none;
            margin-left: 16px;
            font-size: 14px;
        }
        .header .nav a:hover { color: #ff6b81; }
        .container { max-width: 600px; margin: 0 auto; padding: 16px; }

        /* 补全推荐 */
        .recommend-section {
            background: white;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .recommend-section .title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }
        .recommend-section .subtitle {
            font-size: 13px;
            color: #999;
            margin-bottom: 12px;
        }
        .recommend-section .subtitle span {
            color: #ff6b81;
            font-weight: bold;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }
        .product-card {
            background: #f9f9f9;
            border-radius: 10px;
            overflow: hidden;
            transition: all 0.3s;
        }
        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .product-card img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            background: #f0f0f0;
        }
        .product-card .info {
            padding: 10px 12px;
        }
        .product-card .name {
            font-size: 13px;
            font-weight: bold;
            color: #333;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .product-card .category {
            font-size: 11px;
            color: #999;
            margin-top: 2px;
        }
        .product-card .price {
            font-size: 16px;
            font-weight: bold;
            color: #ff6b81;
            margin-top: 4px;
        }
        .product-card .btn-buy {
            display: inline-block;
            margin-top: 8px;
            padding: 4px 16px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            text-decoration: none;
        }
        .product-card .btn-buy:hover { background: #e8556b; }

        .empty-products {
            text-align: center;
            color: #999;
            padding: 30px 0;
        }

        /* 快捷入口 */
        .quick-links {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
            margin-bottom: 16px;
        }
        .quick-links a {
            background: white;
            padding: 14px 0;
            text-align: center;
            border-radius: 10px;
            text-decoration: none;
            color: #666;
            font-size: 13px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            transition: all 0.3s;
        }
        .quick-links a:hover {
            transform: translateY(-2px);
            color: #ff6b81;
        }
        .quick-links .icon { font-size: 24px; display: block; margin-bottom: 4px; }

        .footer-nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 16px 0;
            border-top: 1px solid #eee;
            margin-top: 8px;
        }
        .footer-nav a {
            color: #999;
            text-decoration: none;
            font-size: 13px;
        }
        .footer-nav a:hover { color: #ff6b81; }
    </style>
</head>
<body>

<!-- 顶部导航 -->
<div class="header">
    <div class="logo">👗 Barbie</div>
    <div class="nav">
        <a href="${pageContext.request.contextPath}/index">首页</a>
        <a href="${pageContext.request.contextPath}/wardrobe/list">衣橱</a>
        <a href="${pageContext.request.contextPath}/look/list">搭配</a>
        <a href="${pageContext.request.contextPath}/pages/cart/cart.jsp">🛒</a>
        <a href="${pageContext.request.contextPath}/pages/user/login.jsp">登录</a>
    </div>
</div>

<div class="container">
    <!-- 快捷入口 -->
    <div class="quick-links">
        <a href="${pageContext.request.contextPath}/pages/product/category.jsp?cat=上装">
            <span class="icon">👕</span> 上装
        </a>
        <a href="${pageContext.request.contextPath}/pages/product/category.jsp?cat=下装">
            <span class="icon">👗</span> 下装
        </a>
        <a href="${pageContext.request.contextPath}/pages/product/category.jsp?cat=外套">
            <span class="icon">🧥</span> 外套
        </a>
        <a href="${pageContext.request.contextPath}/pages/product/category.jsp?cat=鞋">
            <span class="icon">👟</span> 鞋子
        </a>
    </div>

    <!-- 衣橱补全推荐 -->
    <div class="recommend-section">
        <div class="title">🧠 衣橱补全建议</div>
        <div class="subtitle">
            根据你的衣橱，推荐 <span><%= recommendCategory %></span>
        </div>

        <div class="product-grid">
            <%
                if (recommendProducts == null || recommendProducts.isEmpty()) {
            %>
            <div class="empty-products">暂无推荐商品，快去逛逛吧！</div>
            <%
            } else {
                for (Product p : recommendProducts) {
                    String img = p.getImages();
                    if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                        img = "uploads/" + img;
                    }
            %>
            <div class="product-card">
                <img src="${pageContext.request.contextPath}/<%= img %>" alt="<%= p.getName() %>">
                <div class="info">
                    <div class="name"><%= p.getName() %></div>
                    <div class="category"><%= p.getCategory() %></div>
                    <div class="price">¥<%= p.getPrice() %></div>
                    <a href="${pageContext.request.contextPath}/pages/product/detail.jsp?id=<%= p.getId() %>" class="btn-buy">查看</a>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <!-- 底部导航 -->
    <div class="footer-nav">
        <a href="${pageContext.request.contextPath}/wardrobe/list">👔 我的衣橱</a>
        <a href="${pageContext.request.contextPath}/look/list">👗 我的搭配</a>
        <a href="${pageContext.request.contextPath}/order/list?status=all">📦 我的订单</a>
    </div>
</div>

</body>
</html>