<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Product" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品管理 - Barbie后台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 1000px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 22px; color: #333; }
        .btn { padding: 8px 20px; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; display: inline-block; font-size: 14px; }
        .btn-primary { background: #ff6b81; color: white; }
        .btn-primary:hover { background: #e8556b; }
        .btn-edit { background: #4ecdc4; color: white; }
        .btn-edit:hover { background: #3bbdb5; }
        .btn-danger { background: #ff6b6b; color: white; }
        .btn-danger:hover { background: #e85555; }
        .btn-logout { background: #999; color: white; }
        .btn-logout:hover { background: #777; }
        table { width: 100%; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        th { background: #ff6b81; color: white; padding: 12px; text-align: left; }
        td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
        tr:hover { background: #fafafa; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
        .actions a { margin-right: 6px; }
        .status-badge { padding: 2px 10px; border-radius: 10px; font-size: 12px; }
        .status-on { background: #d4edda; color: #155724; }
        .status-off { background: #f8d7da; color: #721c24; }
        .empty { text-align: center; padding: 40px; color: #999; }
        .top-bar { display: flex; gap: 12px; align-items: center; }
        .nav-links { margin-top: 16px; text-align: center; }
        .nav-links a { color: #999; text-decoration: none; }
        .nav-links a:hover { color: #ff6b81; text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>📦 商品管理</h2>
        <div class="top-bar">
            <a href="${pageContext.request.contextPath}/pages/admin/adminProductAdd.jsp" class="btn btn-primary">+ 添加商品</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">退出</a>
        </div>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>图片</th>
            <th>名称</th>
            <th>品类</th>
            <th>价格</th>
            <th>状态</th>
            <th>操作</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (products == null || products.isEmpty()) {
        %>
        <tr><td colspan="7" class="empty">暂无商品数据</td></tr>
        <%
        } else {
            for (Product p : products) {
                String img = p.getImages();
                if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                    img = "uploads/" + img;
                }
        %>
        <tr>
            <td><%= p.getId() %></td>
            <td>
                <% if (img != null && !img.isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= img %>" class="product-img">
                <% } else { %>
                <span style="color:#ccc;font-size:12px;">无图</span>
                <% } %>
            </td>
            <td><%= p.getName() %></td>
            <td><%= p.getCategory() %></td>
            <td>¥<%= p.getPrice() %></td>
            <td>
                    <span class="status-badge <%= p.getStatus() == 1 ? "status-on" : "status-off" %>">
                        <%= p.getStatus() == 1 ? "上架" : "下架" %>
                    </span>
            </td>
            <td class="actions">
                <a href="${pageContext.request.contextPath}/admin/product/edit?id=<%= p.getId() %>" class="btn btn-edit">编辑</a>
                <a href="${pageContext.request.contextPath}/admin/product/delete?id=<%= p.getId() %>" class="btn btn-danger" onclick="return confirm('确定删除？')">删除</a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/index">🏠 回到后台首页</a>
    </div>
</div>
</body>
</html>