<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Wardrobe" %>
<%
    List<Wardrobe> list = (List<Wardrobe>) request.getAttribute("wardrobeList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的虚拟衣橱 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .btn-add { background: #ff6b81; color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; }
        .btn-add:hover { background: #e8556b; }
        .stats { background: white; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; color: #666; }
        .wardrobe-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
        .wardrobe-item { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .wardrobe-item img { width: 100%; height: 150px; object-fit: cover; background: #f0f0f0; }
        .wardrobe-item .info { padding: 8px 10px; }
        .wardrobe-item .name { font-size: 13px; font-weight: bold; }
        .wardrobe-item .tags { display: flex; gap: 4px; margin-top: 4px; flex-wrap: wrap; }
        .wardrobe-item .tag { font-size: 10px; padding: 2px 8px; border-radius: 10px; background: #f0f0f0; color: #666; }
        .tag-order { background: #d4edda; color: #155724; }
        .tag-manual { background: #fff3cd; color: #856404; }
        .empty { text-align: center; padding: 60px 0; color: #999; }
        .empty span { font-size: 48px; display: block; margin-bottom: 16px; }
        .nav-links { margin-top: 20px; display: flex; gap: 16px; justify-content: center; }
        .nav-links a { color: #ff6b81; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>👔 我的虚拟衣橱</h2>
        <a href="${pageContext.request.contextPath}/pages/wardrobe/wardrobeImport.jsp" class="btn-add">+ 导入衣服</a>
    </div>

    <div class="stats">
        共 <%= list == null ? 0 : list.size() %> 件衣服
    </div>

    <%
        if (list == null || list.isEmpty()) {
    %>
    <div class="empty">
        <span>👗</span>
        衣橱还是空的<br>
        去 <a href="${pageContext.request.contextPath}/pages/wardrobe/wardrobeImport.jsp" style="color:#ff6b81;">导入</a> 你的第一件衣服吧！
    </div>
    <%
    } else {
    %>
    <div class="wardrobe-grid">
        <%
            for (Wardrobe w : list) {
                String imgPath = w.getImages();
                if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                    imgPath = "uploads/" + imgPath;
                }
        %>
        <div class="wardrobe-item">
            <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
            <div class="info">
                <div class="name"><%= w.getName() %></div>
                <div class="tags">
                    <span class="tag <%= "order".equals(w.getSourceType()) ? "tag-order" : "tag-manual" %>">
                        <%= "order".equals(w.getSourceType()) ? "平台购入" : "手动导入" %>
                    </span>
                    <span class="tag"><%= w.getCategory() %></span>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/order/list?status=all">📦 我的订单</a>
        <a href="${pageContext.request.contextPath}/pages/look/lookList.jsp">👗 我的搭配</a>
    </div>
</div>
</body>
</html>