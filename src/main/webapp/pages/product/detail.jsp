<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.barbie.model.Product" %>
<%@ page import="com.barbie.dao.ProductDao" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    ProductDao productDao = new ProductDao();
    Product p = productDao.findById(id);
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/index");
        return;
    }
    String img = p.getImages();
    if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
        img = "uploads/" + img;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= p.getName() %> - Barbie</title>
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
        .logo { font-size: 22px; font-weight: bold; color: #ff6b81; text-decoration: none; }
        .logo:hover { color: #e8556b; }
        .top-bar .back { color: #999; text-decoration: none; font-size: 14px; }
        .top-bar .back:hover { color: #ff6b81; }

        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px 40px;
        }
        .detail-card {
            background: white;
            border-radius: 14px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .detail-card img {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 8px;
            background: #f0f0f0;
        }
        .detail-card .name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-top: 16px;
        }
        .detail-card .price {
            font-size: 28px;
            font-weight: bold;
            color: #ff6b81;
            margin-top: 8px;
        }
        .detail-card .meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: #999;
            margin-top: 12px;
            flex-wrap: wrap;
        }
        .detail-card .description {
            margin-top: 16px;
            font-size: 14px;
            color: #666;
            line-height: 1.8;
            border-top: 1px solid #f0f0f0;
            padding-top: 16px;
        }
        .btn-add-cart {
            margin-top: 20px;
            padding: 12px 40px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-add-cart:hover { background: #e8556b; }

        .footer {
            text-align: center;
            color: #ccc;
            font-size: 13px;
            padding: 20px 0 16px;
            border-top: 1px solid #f0f0f0;
            margin-top: 24px;
        }
        @media (max-width: 768px) {
            .container { padding: 16px; }
            .top-bar { padding: 0 16px; }
        }
    </style>
</head>
<body>

<div class="top-bar">
    <a href="${pageContext.request.contextPath}/index" class="logo">👗 Barbie</a>
    <a href="javascript:history.back()" class="back">← 返回</a>
</div>

<div class="container">
    <div class="detail-card">
        <%
            if (img != null && !img.isEmpty()) {
        %>
        <img src="${pageContext.request.contextPath}/<%= img %>" alt="<%= p.getName() %>">
        <%
        } else {
        %>
        <div style="width:100%;height:300px;background:#f0f0f0;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:64px;color:#ddd;">👕</div>
        <%
            }
        %>
        <div class="name"><%= p.getName() %></div>
        <div class="price">¥<%= p.getPrice() %></div>
        <div class="meta">
            <span>品类：<%= p.getCategory() %></span>
            <span>风格：<%= p.getStyle() != null ? p.getStyle() : "-" %></span>
            <span>颜色：<%= p.getColor() != null ? p.getColor() : "-" %></span>
            <span>季节：<%= p.getSeason() != null ? p.getSeason() : "-" %></span>
        </div>
        <div class="description">
            <%= p.getDescription() != null ? p.getDescription() : "暂无描述" %>
        </div>
        <button class="btn-add-cart" onclick="addToCart(<%= p.getId() %>)">🛒 加入购物车</button>
    </div>

    <div class="footer">
        © 2026 Barbie · 网上衣橱电商平台 · 课程设计
    </div>
</div>

<script>
    function addToCart(productId) {
        fetch('${pageContext.request.contextPath}/cart/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'productId=' + productId + '&quantity=1'
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.success) {
                alert('✅ 已加入购物车！');
            } else {
                alert(data.message || '加入失败，请重试');
            }
        }).catch(function() {
            alert('请求失败，请重试');
        });
    }
</script>

</body>
</html>