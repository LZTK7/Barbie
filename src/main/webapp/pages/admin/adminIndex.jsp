<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.barbie.model.User" %>
<%
    User user = (User) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理后台 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; min-height: 100vh; display: flex; justify-content: center; align-items: center; }
        .container { max-width: 600px; width: 90%; }
        .header { background: white; padding: 24px; border-radius: 12px; text-align: center; margin-bottom: 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .header h1 { font-size: 24px; color: #333; }
        .header p { font-size: 14px; color: #999; margin-top: 4px; }
        .header .logout { color: #ff6b81; text-decoration: none; font-size: 13px; }
        .header .logout:hover { text-decoration: underline; }
        .menu { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .menu-item { background: white; padding: 30px 20px; border-radius: 12px; text-align: center; text-decoration: none; color: #333; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: all 0.3s; }
        .menu-item:hover { transform: translateY(-4px); box-shadow: 0 8px 24px rgba(0,0,0,0.12); }
        .menu-item .icon { font-size: 48px; display: block; margin-bottom: 12px; }
        .menu-item .title { font-size: 16px; font-weight: bold; }
        .menu-item .desc { font-size: 13px; color: #999; margin-top: 4px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>👋 管理后台</h1>
        <p>欢迎回来，<%= user != null ? user.getNickname() : "管理员" %></p>
        <a href="${pageContext.request.contextPath}/logout" class="logout">退出登录</a>
    </div>

    <div class="menu">
        <a href="${pageContext.request.contextPath}/admin/product/list" class="menu-item">
            <span class="icon">📦</span>
            <div class="title">商品管理</div>
            <div class="desc">添加、编辑、删除商品</div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/user/list" class="menu-item">
            <span class="icon">👤</span>
            <div class="title">用户管理</div>
            <div class="desc">查看、管理用户</div>
        </a>
    </div>
</div>
</body>
</html>