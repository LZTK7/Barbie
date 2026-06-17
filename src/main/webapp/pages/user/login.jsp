<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .login-box { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 320px; }
        h2 { text-align: center; color: #ff6b81; margin-bottom: 30px; }
        input { width: 100%; padding: 12px; margin-bottom: 16px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; font-size: 14px; }
        button { width: 100%; padding: 12px; background: #ff6b81; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        button:hover { background: #e8556b; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .register-link { text-align: center; margin-top: 16px; font-size: 14px; }
        .register-link a { color: #ff6b81; text-decoration: none; }
    </style>
</head>
<body>
<div class="login-box">
    <h2>👗 Barbie 衣橱</h2>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form action="${pageContext.request.contextPath}/login" method="post">
        <input type="text" name="username" placeholder="用户名" required>
        <input type="password" name="password" placeholder="密码" required>
        <button type="submit">登 录</button>
    </form>
    <div class="register-link">
        <a href="#">还没有账号？去注册</a>
    </div>
</div>
</body>
</html>