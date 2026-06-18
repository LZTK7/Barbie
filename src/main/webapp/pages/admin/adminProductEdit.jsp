<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.barbie.model.Product" %>
<%
    Product p = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑商品 - Barbie后台</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 22px; color: #333; }
        .back-btn { color: #666; text-decoration: none; }
        .form-box { background: white; padding: 24px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-weight: bold; font-size: 14px; margin-bottom: 4px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        .form-group textarea { height: 80px; resize: vertical; }
        .btn-submit { width: 100%; padding: 12px; background: #ff6b81; color: white; border: none; border-radius: 6px; font-size: 16px; cursor: pointer; }
        .btn-submit:hover { background: #e8556b; }
        .error { color: red; text-align: center; margin-bottom: 10px; }
        .current-img { max-width: 100px; border-radius: 4px; margin-top: 4px; }
        .nav-link { margin-top: 16px; text-align: center; }
        .nav-link a { color: #999; text-decoration: none; }
        .nav-link a:hover { color: #ff6b81; }
        .img-container { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .img-label { font-size: 13px; color: #666; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>✏️ 编辑商品</h2>
        <a href="${pageContext.request.contextPath}/admin/product/list" class="back-btn">← 返回</a>
    </div>

    <div class="form-box">
        <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin/product/edit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%= p.getId() %>">

            <div class="form-group">
                <label>商品名称 *</label>
                <input type="text" name="name" value="<%= p.getName() %>" required>
            </div>
            <div class="form-group">
                <label>当前图片</label>
                <div class="img-container">
                    <%
                        String img = p.getImages();
                        if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                            img = "uploads/" + img;
                        }
                        if (img != null && !img.isEmpty()) {
                    %>
                    <img src="${pageContext.request.contextPath}/<%= img %>" class="current-img">
                    <% } else { %>
                    <span style="color:#ccc;font-size:13px;">暂无图片</span>
                    <% } %>
                </div>
                <br>
                <label style="font-weight:normal;font-size:13px;color:#666;">更换图片（选填）</label>
                <input type="file" name="image" accept="image/*">
            </div>
            <div class="form-group">
                <label>品类 *</label>
                <select name="category" required>
                    <option value="上装" <%= "上装".equals(p.getCategory()) ? "selected" : "" %>>上装</option>
                    <option value="下装" <%= "下装".equals(p.getCategory()) ? "selected" : "" %>>下装</option>
                    <option value="外套" <%= "外套".equals(p.getCategory()) ? "selected" : "" %>>外套</option>
                    <option value="连衣裙" <%= "连衣裙".equals(p.getCategory()) ? "selected" : "" %>>连衣裙</option>
                    <option value="鞋" <%= "鞋".equals(p.getCategory()) ? "selected" : "" %>>鞋</option>
                    <option value="包" <%= "包".equals(p.getCategory()) ? "selected" : "" %>>包</option>
                    <option value="配饰" <%= "配饰".equals(p.getCategory()) ? "selected" : "" %>>配饰</option>
                </select>
            </div>
            <div class="form-group">
                <label>风格</label>
                <select name="style">
                    <option value="">请选择</option>
                    <option value="通勤" <%= "通勤".equals(p.getStyle()) ? "selected" : "" %>>通勤</option>
                    <option value="街头" <%= "街头".equals(p.getStyle()) ? "selected" : "" %>>街头</option>
                    <option value="约会" <%= "约会".equals(p.getStyle()) ? "selected" : "" %>>约会</option>
                    <option value="运动" <%= "运动".equals(p.getStyle()) ? "selected" : "" %>>运动</option>
                    <option value="度假" <%= "度假".equals(p.getStyle()) ? "selected" : "" %>>度假</option>
                </select>
            </div>
            <div class="form-group">
                <label>颜色</label>
                <select name="color">
                    <option value="">请选择</option>
                    <option value="白色" <%= "白色".equals(p.getColor()) ? "selected" : "" %>>白色</option>
                    <option value="黑色" <%= "黑色".equals(p.getColor()) ? "selected" : "" %>>黑色</option>
                    <option value="红色" <%= "红色".equals(p.getColor()) ? "selected" : "" %>>红色</option>
                    <option value="蓝色" <%= "蓝色".equals(p.getColor()) ? "selected" : "" %>>蓝色</option>
                    <option value="绿色" <%= "绿色".equals(p.getColor()) ? "selected" : "" %>>绿色</option>
                    <option value="黄色" <%= "黄色".equals(p.getColor()) ? "selected" : "" %>>黄色</option>
                    <option value="粉色" <%= "粉色".equals(p.getColor()) ? "selected" : "" %>>粉色</option>
                    <option value="棕色" <%= "棕色".equals(p.getColor()) ? "selected" : "" %>>棕色</option>
                    <option value="灰色" <%= "灰色".equals(p.getColor()) ? "selected" : "" %>>灰色</option>
                </select>
            </div>
            <div class="form-group">
                <label>季节</label>
                <select name="season">
                    <option value="">请选择</option>
                    <option value="春" <%= "春".equals(p.getSeason()) ? "selected" : "" %>>春</option>
                    <option value="夏" <%= "夏".equals(p.getSeason()) ? "selected" : "" %>>夏</option>
                    <option value="秋" <%= "秋".equals(p.getSeason()) ? "selected" : "" %>>秋</option>
                    <option value="冬" <%= "冬".equals(p.getSeason()) ? "selected" : "" %>>冬</option>
                    <option value="四季" <%= "四季".equals(p.getSeason()) ? "selected" : "" %>>四季</option>
                </select>
            </div>
            <div class="form-group">
                <label>价格 *</label>
                <input type="number" name="price" step="0.01" value="<%= p.getPrice() %>" required>
            </div>
            <div class="form-group">
                <label>描述</label>
                <textarea name="description"><%= p.getDescription() != null ? p.getDescription() : "" %></textarea>
            </div>
            <div class="form-group">
                <label>销量</label>
                <input type="number" name="sales" value="<%= p.getSales() %>">
            </div>
            <div class="form-group">
                <label>状态</label>
                <select name="status">
                    <option value="1" <%= p.getStatus() == 1 ? "selected" : "" %>>上架</option>
                    <option value="0" <%= p.getStatus() == 0 ? "selected" : "" %>>下架</option>
                </select>
            </div>
            <button type="submit" class="btn-submit">💾 保存修改</button>
        </form>
    </div>

    <div class="nav-link">
        <a href="${pageContext.request.contextPath}/admin/product/list">← 返回商品列表</a>
    </div>
</div>
</body>
</html>