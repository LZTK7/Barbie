<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.barbie.model.Look, com.barbie.model.Wardrobe, com.barbie.model.Product" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%
    Look look = (Look) request.getAttribute("look");
    List<Wardrobe> items = (List<Wardrobe>) request.getAttribute("items");
    List<Product> pendingProducts = (List<Product>) request.getAttribute("pendingProducts");
    if (pendingProducts == null) pendingProducts = new ArrayList<>();

    // 按区域分类已有衣服
    List<Wardrobe> headItems = new ArrayList<>();
    List<Wardrobe> bodyItems = new ArrayList<>();
    List<Wardrobe> footItems = new ArrayList<>();
    boolean hasDress = false;

    for (Wardrobe w : items) {
        String category = w.getCategory();
        if ("帽子".equals(category) || "头饰".equals(category) || "配饰".equals(category)) {
            headItems.add(w);
        } else if ("袜子".equals(category) || "鞋".equals(category)) {
            footItems.add(w);
        } else {
            bodyItems.add(w);
            if ("连衣裙".equals(category)) {
                hasDress = true;
            }
        }
    }

    // 如果有连衣裙，过滤掉上装和下装（合并模式）
    if (hasDress) {
        bodyItems = bodyItems.stream()
                .filter(w -> "连衣裙".equals(w.getCategory()) || "外套".equals(w.getCategory()) || "包".equals(w.getCategory()))
                .collect(java.util.stream.Collectors.toList());
    }

    // 计算待购总价
    double pendingTotal = 0;
    for (Product p : pendingProducts) {
        pendingTotal += p.getPrice();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>搭配预览 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Microsoft YaHei", sans-serif;
            background: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        .modal {
            background: white;
            border-radius: 16px;
            padding: 24px;
            max-width: 600px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }
        .modal-header h2 { font-size: 20px; color: #333; }
        .modal-header .close-btn { font-size: 24px; color: #999; text-decoration: none; }
        .modal-header .close-btn:hover { color: #333; }
        .look-name {
            font-size: 14px;
            color: #666;
            text-align: center;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid #f0f0f0;
        }
        .look-name .tag {
            display: inline-block;
            background: #f0f0f0;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 12px;
            color: #666;
            margin: 0 4px;
        }
        .tag-pending { background: #d4edda; color: #155724; }
        .zone { margin-bottom: 16px; }
        .zone-title {
            font-size: 12px;
            color: #ccc;
            text-align: center;
            margin-bottom: 8px;
            letter-spacing: 2px;
            font-weight: bold;
        }
        .zone-items {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 10px;
        }
        .item-card {
            background: #f9f9f9;
            border-radius: 10px;
            padding: 10px;
            text-align: center;
            width: 80px;
            border: 2px solid #eee;
            transition: all 0.3s;
        }
        .item-card:hover {
            border-color: #ff6b81;
            transform: translateY(-2px);
        }
        .item-card img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            background: #f0f0f0;
        }
        .item-card .item-name {
            font-size: 11px;
            color: #333;
            margin-top: 4px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .item-card .item-category {
            font-size: 10px;
            color: #999;
        }
        .item-card .badge {
            font-size: 9px;
            padding: 1px 6px;
            border-radius: 8px;
            color: white;
            display: inline-block;
            margin-top: 2px;
        }
        .badge-owned { background: #6c757d; }
        .badge-pending { background: #4ecdc4; }
        .zone-body .item-card { width: 90px; padding: 12px; }
        .zone-body .item-card img { width: 70px; height: 70px; }
        .zone-head .item-card { width: 90px; }
        .empty-slot {
            color: #ddd;
            font-size: 12px;
            padding: 10px 16px;
            background: #fafafa;
            border-radius: 8px;
            border: 2px dashed #eee;
        }
        .footer {
            margin-top: 20px;
            padding-top: 16px;
            border-top: 1px solid #f0f0f0;
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn {
            padding: 10px 24px;
            border-radius: 20px;
            border: none;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary { background: #ff6b81; color: white; }
        .btn-primary:hover { background: #e8556b; }
        .btn-secondary { background: #f0f0f0; color: #666; }
        .btn-secondary:hover { background: #e0e0e0; }
        .btn-disabled { background: #e8e8e8; color: #bbb; cursor: not-allowed; }
        .btn-success { background: #4ecdc4; color: white; }
        .btn-success:hover { background: #3bbdb5; }
        .back-link { text-align: center; margin-top: 12px; }
        .back-link a { color: #999; text-decoration: none; font-size: 13px; }
        .back-link a:hover { color: #666; }
        .pending-section {
            background: #f0fffe;
            border-radius: 10px;
            padding: 12px;
            margin-top: 12px;
        }
        .pending-section .title {
            font-size: 13px;
            font-weight: bold;
            color: #4ecdc4;
            margin-bottom: 8px;
        }
        .pending-section .total {
            font-size: 14px;
            color: #333;
            margin-top: 8px;
            text-align: right;
        }
        .pending-section .total span { color: #ff6b81; font-weight: bold; font-size: 18px; }
        .dress-hint {
            text-align: center;
            font-size: 11px;
            color: #ff6b81;
            margin-top: 6px;
        }
        @media (max-width: 480px) {
            .zone-body .item-card { width: 70px; padding: 8px; }
            .zone-body .item-card img { width: 50px; height: 50px; }
            .item-card { width: 65px; padding: 8px; }
            .item-card img { width: 45px; height: 45px; }
        }
    </style>
</head>
<body>
<div class="modal">
    <div class="modal-header">
        <h2>👀 搭配预览</h2>
        <a href="${pageContext.request.contextPath}/look/list" class="close-btn">&times;</a>
    </div>

    <div class="look-name">
        📌 <%= look.getName() %>
        <% if (look.getScene() != null && !look.getScene().isEmpty()) { %>
        <span class="tag">📍 <%= look.getScene() %></span>
        <% } %>
        <% if (look.getSeason() != null && !look.getSeason().isEmpty()) { %>
        <span class="tag">🌸 <%= look.getSeason() %></span>
        <% } %>
        <span class="tag">👔 已有 <%= items.size() %> 件</span>
        <span class="tag tag-pending">🛒 待购 <%= pendingProducts.size() %> 件</span>
    </div>

    <!-- 头部 -->
    <div class="zone zone-head">
        <div class="zone-title">— 头部 —</div>
        <div class="zone-items">
            <% if (headItems.isEmpty()) { %>
            <span class="empty-slot">暂无帽子/头饰</span>
            <% } else {
                for (Wardrobe w : headItems) {
                    String imgPath = w.getImages();
                    if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                        imgPath = "uploads/" + imgPath;
                    }
            %>
            <div class="item-card">
                <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
                <div class="item-name"><%= w.getName() %></div>
                <div class="item-category"><%= w.getCategory() %></div>
                <span class="badge badge-owned">已有</span>
            </div>
            <% } } %>
        </div>
    </div>

    <!-- 身体 -->
    <div class="zone zone-body">
        <div class="zone-title">— 身体 —</div>
        <div class="zone-items">
            <% if (bodyItems.isEmpty()) { %>
            <span class="empty-slot">暂无衣服</span>
            <% } else {
                for (Wardrobe w : bodyItems) {
                    String imgPath = w.getImages();
                    if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                        imgPath = "uploads/" + imgPath;
                    }
            %>
            <div class="item-card">
                <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
                <div class="item-name"><%= w.getName() %></div>
                <div class="item-category"><%= w.getCategory() %></div>
                <span class="badge badge-owned">已有</span>
            </div>
            <% } } %>
        </div>
        <% if (hasDress) { %>
        <div class="dress-hint">👗 连衣裙穿搭（上装、下装已合并）</div>
        <% } %>
    </div>

    <!-- 脚部 -->
    <div class="zone zone-foot">
        <div class="zone-title">— 脚部 —</div>
        <div class="zone-items">
            <% if (footItems.isEmpty()) { %>
            <span class="empty-slot">暂无袜子/鞋子</span>
            <% } else {
                for (Wardrobe w : footItems) {
                    String imgPath = w.getImages();
                    if (imgPath != null && !imgPath.isEmpty() && !imgPath.startsWith("uploads/")) {
                        imgPath = "uploads/" + imgPath;
                    }
            %>
            <div class="item-card">
                <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= w.getName() %>">
                <div class="item-name"><%= w.getName() %></div>
                <div class="item-category"><%= w.getCategory() %></div>
                <span class="badge badge-owned">已有</span>
            </div>
            <% } } %>
        </div>
    </div>

    <!-- 待购衣服 -->
    <% if (!pendingProducts.isEmpty()) { %>
    <div class="pending-section">
        <div class="title">🛒 待购衣服</div>
        <div class="zone-items">
            <% for (Product p : pendingProducts) {
                String img = p.getImages();
                if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                    img = "uploads/" + img;
                }
            %>
            <div class="item-card" style="border-color:#4ecdc4;">
                <img src="${pageContext.request.contextPath}/<%= img %>" alt="<%= p.getName() %>">
                <div class="item-name"><%= p.getName() %></div>
                <div style="font-size:11px;color:#ff6b81;font-weight:bold;">¥<%= p.getPrice() %></div>
                <span class="badge badge-pending">待购</span>
            </div>
            <% } %>
        </div>
        <div class="total">待购合计：<span>¥<%= String.format("%.2f", pendingTotal) %></span></div>
    </div>
    <% } %>

    <!-- 底部按钮 -->
    <div class="footer">
        <a href="${pageContext.request.contextPath}/look/list" class="btn btn-secondary">← 返回</a>
        <a href="${pageContext.request.contextPath}/look/edit?id=<%= look.getId() %>" class="btn btn-primary">✏️ 编辑</a>
        <% if (pendingProducts.isEmpty()) { %>
        <span class="btn btn-disabled">✅ 已拥有全部</span>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/look/buyAll?lookId=<%= look.getId() %>" class="btn btn-success">🛒 一键加购（<%= pendingProducts.size() %>件）</a>
        <% } %>
    </div>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/look/list">返回搭配列表</a>
    </div>
</div>
</body>
</html>