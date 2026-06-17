<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.Order" %>
<%
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String currentStatus = (String) request.getAttribute("currentStatus");
    if (currentStatus == null) currentStatus = "all";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的订单 - Barbie</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: "Microsoft YaHei", sans-serif;
            background: #f5f5f5;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h2 {
            font-size: 20px;
        }
        .back-btn {
            font-size: 14px;
            color: #666;
            text-decoration: none;
        }
        .tabs {
            display: flex;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
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
        .tabs a:hover {
            background: #fafafa;
        }
        .order-card {
            background: white;
            border-radius: 10px;
            padding: 16px;
            margin-bottom: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
        }
        .order-card .order-no {
            font-size: 13px;
            color: #999;
            margin-bottom: 6px;
        }
        .order-card .order-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .order-card .amount {
            font-size: 18px;
            font-weight: bold;
            color: #ff6b81;
        }
        .order-card .receiver {
            font-size: 14px;
            color: #333;
        }
        .order-card .status {
            font-size: 13px;
            padding: 2px 12px;
            border-radius: 12px;
            display: inline-block;
        }
        .status-shipped {
            background: #fff3cd;
            color: #856404;
        }
        .status-completed {
            background: #d4edda;
            color: #155724;
        }
        .order-card .time {
            font-size: 12px;
            color: #ccc;
            margin-top: 6px;
        }
        .order-card .actions {
            margin-top: 12px;
            text-align: right;
            border-top: 1px solid #f0f0f0;
            padding-top: 12px;
        }
        .btn-confirm {
            background: #ff6b81;
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            cursor: pointer;
        }
        .btn-confirm:hover {
            background: #e8556b;
        }
        .empty {
            text-align: center;
            padding: 60px 0;
            color: #999;
            font-size: 16px;
        }
        .empty span {
            font-size: 48px;
            display: block;
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <h2>📦 我的订单</h2>
        <a href="javascript:history.back()" class="back-btn">← 返回</a>
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
    %>
    <div class="order-card">
        <div class="order-no">订单号：<%= o.getOrderNo() %></div>
        <div class="order-info">
            <div>
                <div class="receiver">收货人：<%= o.getReceiver() %></div>
                <div style="font-size:13px;color:#999;margin-top:4px;">
                    电话：<%= o.getPhone() %>
                </div>
            </div>
            <div style="text-align:right;">
                <div class="amount">¥<%= String.format("%.2f", o.getTotalAmount()) %></div>
                <span class="status <%= statusClass %>"><%= statusText %></span>
            </div>
        </div>
        <div class="time"><%= o.getCreatedAt() %></div>

        <% if ("shipped".equals(o.getStatus())) { %>
        <div class="actions">
            <form action="${pageContext.request.contextPath}/order/confirm" method="post">
                <input type="hidden" name="orderId" value="<%= o.getId() %>">
                <button type="submit" class="btn-confirm">✅ 确认收货</button>
            </form>
        </div>
        <% } %>
    </div>
    <%
            }
        }
    %>
</div>
</body>
</html>