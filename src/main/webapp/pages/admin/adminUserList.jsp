<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理 - Barbie后台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 22px; color: #333; }
        .btn-logout { padding: 8px 20px; background: #999; color: white; border: none; border-radius: 6px; cursor: pointer; text-decoration: none; }
        .btn-logout:hover { background: #777; }
        table { width: 100%; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        th { background: #ff6b81; color: white; padding: 12px; text-align: left; }
        td { padding: 10px 12px; border-bottom: 1px solid #f0f0f0; }
        tr:hover { background: #fafafa; }
        .role-badge { padding: 2px 10px; border-radius: 10px; font-size: 12px; }
        .role-admin { background: #fff3cd; color: #856404; }
        .role-user { background: #d4edda; color: #155724; }
        .empty { text-align: center; padding: 40px; color: #999; }
        .nav-links { margin-top: 16px; text-align: center; }
        .nav-links a { color: #999; text-decoration: none; }
        .nav-links a:hover { color: #ff6b81; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>👤 用户管理</h2>
        <div>
            <a href="${pageContext.request.contextPath}/admin/index" style="color:#666;text-decoration:none;margin-right:16px;">← 返回后台首页</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">退出</a>
        </div>
    </div>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>昵称</th>
            <th>角色</th>
            <th>注册时间</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (users == null || users.isEmpty()) {
        %>
        <tr><td colspan="5" class="empty">暂无用户</td></tr>
        <%
        } else {
            for (User u : users) {
        %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getUsername() %></td>
            <td><%= u.getNickname() %></td>
            <td>
                    <span class="role-badge <%= "admin".equals(u.getRole()) ? "role-admin" : "role-user" %>">
                        <%= "admin".equals(u.getRole()) ? "管理员" : "普通用户" %>
                    </span>
            </td>
            <td><%= u.getCreatedAt() %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/index">← 返回后台首页</a>
    </div>
</div>
</body>
</html>