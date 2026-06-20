<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Order" %>
<%@ page import="com.barbie.dao.OrderItemDao" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "all";
    OrderItemDao orderItemDao = new OrderItemDao();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; padding: 20px; }
        .container { max-width: 700px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .header h2 { font-size: 20px; }
        .back-btn { color: #666; text-decoration: none; font-size: 14px; }
        .tabs {
            display: flex;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .tabs a {
            flex: 1;
            text-align: center;
            padding: 12px 0;
            font-size: 14px;
            color: #666;
            text-decoration: none;
            transition: all 0.3s;
            border-bottom: 3px solid transparent;
        }
        .tabs a.active {
            color: #ff6b81;
            border-bottom-color: #ff6b81;
            font-weight: bold;
        }
        .tabs a:hover { background: #fafafa; }

        .order-card {
            background: white;
            border-radius: 10px;
            padding: 16px;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border-left: 4px solid #ddd;
        }
        .order-card .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-card .order-no { font-size: 13px; color: #999; }
        .order-card .order-status {
            font-size: 13px;
            padding: 2px 12px;
            border-radius: 12px;
            font-weight: bold;
        }
        .status-shipped { background: #fff3cd; color: #856404; }
        .status-completed { background: #d4edda; color: #155724; }

        .order-item {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .order-item:last-child { border-bottom: none; }
        .order-item .item-img {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 6px;
            background: #f0f0f0;
            flex-shrink: 0;
        }
        .order-item .item-img-placeholder {
            width: 60px;
            height: 60px;
            border-radius: 6px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #ddd;
            flex-shrink: 0;
        }
        .order-item .item-info { flex: 1; }
        .order-item .item-info .name { font-size: 14px; font-weight: bold; color: #333; }
        .order-item .item-info .qty { font-size: 12px; color: #999; }
        .order-item .item-price { font-size: 15px; font-weight: bold; color: #ff6b81; }

        .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 12px;
            border-top: 1px solid #f0f0f0;
            margin-top: 4px;
        }
        .order-footer .total { font-size: 16px; font-weight: bold; color: #333; }
        .order-footer .total span { color: #ff6b81; }
        .order-footer .time { font-size: 12px; color: #ccc; }

        .btn-confirm {
            background: #ff6b81;
            color: white;
            border: none;
            padding: 8px 24px;
            border-radius: 20px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-confirm:hover { background: #e8556b; }

        .empty {
            text-align: center;
            padding: 60px 0;
            color: #999;
        }
        .empty span { font-size: 48px; display: block; margin-bottom: 16px; }

        .back-home {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #999;
            text-decoration: none;
            font-size: 14px;
        }
        .back-home:hover { color: #ff6b81; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>📦 我的订单</h2>
        <a href="${pageContext.request.contextPath}/pages/user/profile.jsp" class="back-btn">← 返回个人中心</a>
    </div>

    <div class="tabs">
        <a href="${pageContext.request.contextPath}/order/list?status=all"
           class="<%= "all".equals(currentStatus) ? "active" : "" %>">全部</a>
        <a href="${pageContext.request.contextPath}/order/list?status=shipped"
           class="<%= "shipped".equals(currentStatus) ? "active" : "" %>">待收货</a>
        <a href="${pageContext.request.contextPath}/order/list?status=completed"
           class="<%= "completed".equals(currentStatus) ? "active" : "" %>">已完结</a>
    </div>

    <%
        if (orders == null || orders.isEmpty()) {
    %>
    <div class="empty">
        <span>🛍️</span>
        暂无订单
    </div>
    <%
    } else {
        for (Order o : orders) {
            String statusClass = "";
            String statusText = "";
            if ("shipped".equals(o.getStatus())) {
                statusClass = "status-shipped";
                statusText = "待收货";
            } else if ("completed".equals(o.getStatus())) {
                statusClass = "status-completed";
                statusText = "已完结";
            } else {
                statusText = o.getStatus();
            }
            List<com.barbie.model.OrderItem> items = orderItemDao.findByOrderId(o.getId());
            com.barbie.model.OrderItem firstItem = (items != null && !items.isEmpty()) ? items.get(0) : null;
    %>
    <div class="order-card" style="border-left-color: <%= "shipped".equals(o.getStatus()) ? "#ff6b81" : "#4ecdc4" %>;">
        <div class="order-header">
            <span class="order-no">订单号：<%= o.getOrderNo() %></span>
            <span class="order-status <%= statusClass %>"><%= statusText %></span>
        </div>

        <div class="order-item">
            <%
                if (firstItem != null) {
                    String img = firstItem.getProductImage();
                    if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                        img = "uploads/" + img;
                    }
                    if (img != null && !img.isEmpty()) {
            %>
            <img src="${pageContext.request.contextPath}/<%= img %>" class="item-img">
            <%
            } else {
            %>
            <div class="item-img-placeholder">👕</div>
            <%
                }
            %>
            <div class="item-info">
                <div class="name"><%= firstItem.getProductName() %></div>
                <div class="qty">× <%= firstItem.getQuantity() %></div>
            </div>
            <div class="item-price">¥<%= String.format("%.2f", firstItem.getPrice()) %></div>
            <%
            } else {
            %>
            <div style="color:#999;font-size:13px;padding:8px 0;">暂无商品信息</div>
            <%
                }
            %>
        </div>

        <div class="order-footer">
            <div class="total">合计：¥<span><%= String.format("%.2f", o.getTotalAmount()) %></span></div>
            <div>
                <span class="time"><%= o.getCreatedAt() %></span>
                <% if ("shipped".equals(o.getStatus())) { %>
                <form action="${pageContext.request.contextPath}/order/confirm" method="post" style="display:inline-block;margin-left:12px;">
                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
                    <button type="submit" class="btn-confirm">✅ 确认收货</button>
                </form>
                <% } %>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>

    <a href="${pageContext.request.contextPath}/pages/user/profile.jsp" class="back-home">← 返回个人中心</a>
</div>
</body>
</html>