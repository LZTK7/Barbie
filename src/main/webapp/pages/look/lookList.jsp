<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Look" %>
<%
    List<Look> lookList = (List<Look>) request.getAttribute("lookList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的搭配 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .btn-create { background: #ff6b81; color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; }
        .btn-create:hover { background: #e8556b; }
        .look-card { background: white; border-radius: 10px; padding: 16px; margin-bottom: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .look-card .name { font-size: 16px; font-weight: bold; }
        .look-card .meta { font-size: 13px; color: #999; margin-top: 4px; }
        .look-card .tags { display: flex; gap: 8px; margin-top: 8px; flex-wrap: wrap; }
        .look-card .tag { font-size: 12px; padding: 2px 12px; border-radius: 12px; background: #f0f0f0; color: #666; }
        .tag-pending { background: #fff3cd; color: #856404; }
        .tag-cart { background: #cce5ff; color: #004085; }
        .tag-shipped { background: #d4edda; color: #155724; }
        .look-card .actions { margin-top: 12px; display: flex; gap: 8px; flex-wrap: wrap; }
        .look-card .actions a { font-size: 13px; color: #ff6b81; text-decoration: none; padding: 4px 12px; border: 1px solid #ff6b81; border-radius: 4px; }
        .look-card .actions a:hover { background: #ff6b81; color: white; }
        .look-card .actions .btn-delete { background: none; border: 1px solid #ff6b81; color: #ff6b81; padding: 4px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .look-card .actions .btn-delete:hover { background: #ff6b81; color: white; }
        .empty { text-align: center; padding: 60px 0; color: #999; }
        .empty span { font-size: 48px; display: block; margin-bottom: 16px; }
        .nav-links { margin-top: 20px; display: flex; gap: 16px; justify-content: center; }
        .nav-links a { color: #999; text-decoration: none; font-size: 14px; transition: all 0.3s; }
        .nav-links a:hover { color: #ff6b81; }
        .nav-links .home-link { color: #ff6b81; font-weight: bold; }
        .nav-links .home-link:hover { color: #e8556b; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>👗 我的搭配</h2>
        <a href="${pageContext.request.contextPath}/pages/look/lookCreate.jsp" class="btn-create">+ 创建搭配</a>
    </div>

    <%
        if (lookList == null || lookList.isEmpty()) {
    %>
    <div class="empty">
        <span>👗</span>
        还没有搭配<br>
        去 <a href="${pageContext.request.contextPath}/pages/look/lookCreate.jsp" style="color:#ff6b81;">创建</a> 你的第一个搭配吧！
    </div>
    <%
    } else {
        for (Look look : lookList) {
            int ownedCount = look.getWardrobeIds() != null && !look.getWardrobeIds().isEmpty() ? look.getWardrobeIds().split(",").length : 0;
            int pendingCount = look.getPendingIds() != null && !look.getPendingIds().isEmpty() ? look.getPendingIds().split(",").length : 0;
            int cartCount = look.getCartIds() != null && !look.getCartIds().isEmpty() ? look.getCartIds().split(",").length : 0;
            int shippedCount = look.getShippedIds() != null && !look.getShippedIds().isEmpty() ? look.getShippedIds().split(",").length : 0;
    %>
    <div class="look-card">
        <div class="name"><%= look.getName() %></div>
        <div class="meta">创建于：<%= look.getCreatedAt() %></div>
        <div class="tags">
            <% if (look.getScene() != null && !look.getScene().isEmpty()) { %>
            <span class="tag">📍 <%= look.getScene() %></span>
            <% } %>
            <% if (look.getSeason() != null && !look.getSeason().isEmpty()) { %>
            <span class="tag">🌸 <%= look.getSeason() %></span>
            <% } %>
            <span class="tag">👔 已有 <%= ownedCount %> 件</span>
            <% if (pendingCount > 0) { %>
            <span class="tag tag-pending">🟡 待加购 <%= pendingCount %> 件</span>
            <% } %>
            <% if (cartCount > 0) { %>
            <span class="tag tag-cart">🟠 待购买 <%= cartCount %> 件</span>
            <% } %>
            <% if (shippedCount > 0) { %>
            <span class="tag tag-shipped">🔵 待收货 <%= shippedCount %> 件</span>
            <% } %>
        </div>
        <div class="actions">
            <a href="${pageContext.request.contextPath}/look/detail?id=<%= look.getId() %>">🔍 预览搭配</a>
            <button class="btn-delete" onclick="deleteLook(<%= look.getId() %>)">🗑️ 删除</button>
        </div>
    </div>
    <%
            }
        }
    %>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index" class="home-link">🏠 返回首页</a>
        <a href="${pageContext.request.contextPath}/wardrobe/list">👔 我的衣橱</a>
    </div>
</div>

<script>
    function deleteLook(id) {
        if (confirm('确定要删除这个搭配吗？')) {
            fetch('${pageContext.request.contextPath}/look/delete?id=' + id, {
                method: 'POST'
            })
                .then(response => {
                    if (response.ok) {
                        alert('删除成功！');
                        location.reload();
                    } else {
                        alert('删除失败，请重试');
                    }
                })
                .catch(error => {
                    alert('请求失败：' + error);
                });
        }
    }
</script>

</body>
</html>