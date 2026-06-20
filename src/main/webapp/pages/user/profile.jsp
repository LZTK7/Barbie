<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.model.Order" %>
<%@ page import="com.barbie.model.OrderItem" %>
<%@ page import="com.barbie.dao.OrderDao" %>
<%@ page import="com.barbie.dao.OrderItemDao" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%@ page import="java.util.List" %>
<%
    User user = SessionUtil.getLoginUser(session);
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/user/login.jsp");
        return;
    }

    OrderDao orderDao = new OrderDao();
    OrderItemDao orderItemDao = new OrderItemDao();
    String status = request.getParameter("status");
    if (status == null || status.isEmpty()) {
        status = "all";
    }
    List<Order> orders = orderDao.findByUserIdAndStatus(user.getId(), status);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人中心 - Barbie</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Microsoft YaHei", sans-serif; background: #f5f5f5; }

        .top-bar {
            background: white;
            padding: 0 40px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 999;
        }
        .logo {
            font-size: 22px;
            font-weight: bold;
            color: #ff6b81;
            text-decoration: none;
        }
        .logo:hover { color: #e8556b; }
        .top-bar .back-home {
            color: #999;
            text-decoration: none;
            font-size: 14px;
        }
        .top-bar .back-home:hover { color: #ff6b81; }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 30px 40px;
        }

        .user-card {
            background: white;
            border-radius: 14px;
            padding: 24px 30px;
            display: flex;
            align-items: center;
            gap: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            margin-bottom: 24px;
        }
        .user-card .avatar {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #ff6b81;
            color: white;
            font-size: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .user-card .info .name {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        .user-card .info .detail {
            font-size: 14px;
            color: #999;
            margin-top: 4px;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }
        .menu-item {
            background: white;
            padding: 24px 16px;
            text-align: center;
            border-radius: 12px;
            text-decoration: none;
            color: #333;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: all 0.3s;
        }
        .menu-item:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(255,107,129,0.15);
            color: #ff6b81;
        }
        .menu-item .icon {
            font-size: 32px;
            display: block;
            margin-bottom: 8px;
        }
        .menu-item .label {
            font-size: 14px;
            font-weight: bold;
        }

        .order-section {
            background: white;
            border-radius: 14px;
            padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .order-section .title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
        }
        .order-tabs {
            display: flex;
            gap: 4px;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 0;
            flex-wrap: wrap;
        }
        .order-tabs a {
            padding: 10px 20px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .order-tabs a:hover {
            color: #ff6b81;
            border-bottom-color: #ff6b81;
        }
        .order-tabs a.active {
            color: #ff6b81;
            border-bottom-color: #ff6b81;
            font-weight: bold;
        }

        .order-list { margin-top: 16px; }
        .order-card {
            border: 1px solid #f0f0f0;
            border-radius: 10px;
            padding: 14px 18px;
            margin-bottom: 12px;
            border-left: 4px solid #ddd;
            cursor: pointer;
            transition: all 0.3s;
        }
        .order-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
        }
        .order-card .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 8px;
            border-bottom: 1px solid #f0f0f0;
        }
        .order-card .order-no { font-size: 13px; color: #999; }
        .order-card .order-status {
            font-size: 12px;
            padding: 2px 12px;
            border-radius: 12px;
        }
        .status-shipped { background: #fff3cd; color: #856404; }
        .status-completed { background: #d4edda; color: #155724; }

        .order-card .order-item-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
        }
        .order-card .order-item-row img {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
        .order-card .order-item-row .info { flex: 1; }
        .order-card .order-item-row .info .name { font-size: 14px; font-weight: bold; color: #333; }
        .order-card .order-item-row .info .qty { font-size: 12px; color: #999; }
        .order-card .order-item-row .price { font-size: 14px; font-weight: bold; color: #ff6b81; }

        .order-card .order-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 8px;
            border-top: 1px solid #f0f0f0;
        }
        .order-card .order-footer .total { font-size: 15px; font-weight: bold; color: #333; }
        .order-card .order-footer .total span { color: #ff6b81; }
        .order-card .order-footer .actions { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
        .order-card .order-footer .time { font-size: 12px; color: #ccc; }

        .btn-confirm {
            background: #ff6b81;
            color: white;
            border: none;
            padding: 6px 20px;
            border-radius: 20px;
            font-size: 13px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-confirm:hover { background: #e8556b; }

        .btn-delete-order {
            background: none;
            color: #ccc;
            border: 1px solid #ddd;
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-delete-order:hover { color: #ff6b81; border-color: #ff6b81; }

        .order-empty {
            text-align: center;
            padding: 30px 0;
            color: #999;
        }
        .order-empty .icon { font-size: 40px; display: block; margin-bottom: 8px; }
        .order-empty a { color: #ff6b81; text-decoration: none; }

        .footer {
            text-align: center;
            color: #ccc;
            font-size: 13px;
            padding: 20px 0 16px;
            border-top: 1px solid #f0f0f0;
            margin-top: 24px;
        }

        /* 弹窗 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        .modal-overlay.show { display: flex; }
        .modal-content {
            background: white;
            border-radius: 14px;
            padding: 28px;
            max-width: 500px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            position: relative;
        }
        .modal-content .close-btn {
            position: absolute;
            top: 12px;
            right: 18px;
            font-size: 28px;
            cursor: pointer;
            color: #999;
            background: none;
            border: none;
        }
        .modal-content .close-btn:hover { color: #333; }
        .modal-content .modal-title {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 16px;
        }
        .modal-content .info-row {
            display: flex;
            padding: 6px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .modal-content .info-row .label {
            width: 70px;
            color: #999;
            font-size: 14px;
            flex-shrink: 0;
        }
        .modal-content .info-row .value {
            flex: 1;
            color: #333;
            font-size: 14px;
        }
        .modal-content .item-list { margin-top: 12px; }
        .modal-content .item-list .item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 0;
            border-bottom: 1px solid #f5f5f5;
        }
        .modal-content .item-list .item img {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 4px;
            background: #f0f0f0;
        }
        .modal-content .item-list .item .info { flex: 1; }
        .modal-content .item-list .item .info .name { font-size: 13px; color: #333; }
        .modal-content .item-list .item .info .price { font-size: 12px; color: #999; }

        @media (max-width: 768px) {
            .container { padding: 16px; }
            .menu-grid { grid-template-columns: repeat(3, 1fr); }
            .top-bar { padding: 0 16px; }
            .order-tabs a { padding: 8px 12px; font-size: 13px; }
        }
        @media (max-width: 480px) {
            .menu-grid { grid-template-columns: 1fr 1fr; }
            .user-card { flex-direction: column; text-align: center; }
        }
    </style>
</head>
<body>

<div class="top-bar">
    <a href="${pageContext.request.contextPath}/index" class="logo">👗 Barbie</a>
    <a href="${pageContext.request.contextPath}/index" class="back-home">← 返回首页</a>
</div>

<div class="container">

    <div class="user-card">
        <div class="avatar">👤</div>
        <div class="info">
            <div class="name"><%= user.getNickname() %></div>
            <div class="detail">用户名：<%= user.getUsername() %> &nbsp;|&nbsp; 角色：<%= "admin".equals(user.getRole()) ? "管理员" : "普通用户" %></div>
        </div>
    </div>

    <div class="menu-grid">
        <a href="${pageContext.request.contextPath}/wardrobe/list" class="menu-item">
            <span class="icon">👔</span>
            <span class="label">我的衣橱</span>
        </a>
        <a href="${pageContext.request.contextPath}/look/list" class="menu-item">
            <span class="icon">👗</span>
            <span class="label">我的搭配</span>
        </a>
        <a href="${pageContext.request.contextPath}/pages/user/profile.jsp" class="menu-item">
            <span class="icon">⚙️</span>
            <span class="label">个人设置</span>
        </a>
    </div>

    <div class="order-section">
        <div class="title">📋 我的订单</div>
        <div class="order-tabs">
            <a href="${pageContext.request.contextPath}/pages/user/profile.jsp?status=all" class="<%= "all".equals(status) ? "active" : "" %>">全部</a>
            <a href="${pageContext.request.contextPath}/pages/user/profile.jsp?status=shipped" class="<%= "shipped".equals(status) ? "active" : "" %>">待收货</a>
            <a href="${pageContext.request.contextPath}/pages/user/profile.jsp?status=completed" class="<%= "completed".equals(status) ? "active" : "" %>">已完结</a>
        </div>

        <div class="order-list">
            <%
                if (orders == null || orders.isEmpty()) {
            %>
            <div class="order-empty">
                <span class="icon">🛍️</span>
                暂无订单，去 <a href="${pageContext.request.contextPath}/index">逛逛</a> 吧！
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
                    List<OrderItem> items = orderItemDao.findByOrderId(o.getId());
                    OrderItem firstItem = (items != null && !items.isEmpty()) ? items.get(0) : null;
            %>
            <div class="order-card" style="border-left-color: <%= "shipped".equals(o.getStatus()) ? "#ff6b81" : "#4ecdc4" %>;" onclick="showOrderDetail(<%= o.getId() %>)">
                <div class="order-header">
                    <span class="order-no">订单号：<%= o.getOrderNo() %></span>
                    <span class="order-status <%= statusClass %>"><%= statusText %></span>
                </div>

                <div class="order-item-row">
                    <%
                        if (firstItem != null) {
                            String img = firstItem.getProductImage();
                            if (img != null && !img.isEmpty() && !img.startsWith("uploads/")) {
                                img = "uploads/" + img;
                            }
                            if (img != null && !img.isEmpty()) {
                    %>
                    <img src="${pageContext.request.contextPath}/<%= img %>">
                    <%
                    } else {
                    %>
                    <div style="width:50px;height:50px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:20px;color:#ddd;">👕</div>
                    <%
                        }
                    %>
                    <div class="info">
                        <div class="name"><%= firstItem.getProductName() %></div>
                        <div class="qty">× <%= firstItem.getQuantity() %></div>
                    </div>
                    <div class="price">¥<%= String.format("%.2f", firstItem.getPrice()) %></div>
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
                    <div class="actions">
                        <span class="time"><%= o.getCreatedAt() %></span>
                        <% if ("shipped".equals(o.getStatus())) { %>
                        <form action="${pageContext.request.contextPath}/order/confirm" method="post" onclick="event.stopPropagation();">
                            <input type="hidden" name="orderId" value="<%= o.getId() %>">
                            <button type="submit" class="btn-confirm">✅ 确认收货</button>
                        </form>
                        <% } else if ("completed".equals(o.getStatus())) { %>
                        <button class="btn-delete-order" onclick="event.stopPropagation();deleteOrder(<%= o.getId() %>)">🗑️ 删除订单</button>
                        <% } %>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <div class="footer">
        © 2026 Barbie · 网上衣橱电商平台 · 课程设计
    </div>
</div>

<!-- ===== 订单详情弹窗 ===== -->
<div class="modal-overlay" id="orderModal">
    <div class="modal-content">
        <button class="close-btn" onclick="closeModal()">&times;</button>
        <div class="modal-title">📄 订单详情</div>
        <div id="modalBody">
            <div class="info-row"><span class="label">订单号</span><span class="value" id="modalOrderNo">-</span></div>
            <div class="info-row"><span class="label">收货人</span><span class="value" id="modalReceiver">-</span></div>
            <div class="info-row"><span class="label">电　话</span><span class="value" id="modalPhone">-</span></div>
            <div class="info-row"><span class="label">付款时间</span><span class="value" id="modalTime">-</span></div>
            <div class="info-row"><span class="label">状　态</span><span class="value" id="modalStatus">-</span></div>
            <div class="info-row"><span class="label">总　价</span><span class="value" id="modalTotal" style="color:#ff6b81;font-weight:bold;">-</span></div>
            <div style="margin-top:12px;font-weight:bold;font-size:14px;color:#333;">商品明细</div>
            <div class="item-list" id="modalItems"></div>
        </div>
    </div>
</div>

<script>
    // ===== 弹窗控制 =====
    function showOrderDetail(orderId) {
        fetch('${pageContext.request.contextPath}/order/detail?id=' + orderId)
            .then(function(response) {
                if (!response.ok) throw new Error('请求失败');
                return response.json();
            })
            .then(function(data) {
                if (!data.success) {
                    alert(data.message || '获取订单详情失败');
                    return;
                }
                var order = data.order;
                document.getElementById('modalOrderNo').textContent = order.orderNo;
                document.getElementById('modalReceiver').textContent = order.receiver;
                document.getElementById('modalPhone').textContent = order.phone;
                document.getElementById('modalTime').textContent = order.createdAt || '-';
                var statusMap = { 'shipped': '待收货', 'completed': '已完结', 'pending': '待付款', 'paid': '待发货' };
                document.getElementById('modalStatus').textContent = statusMap[order.status] || order.status;
                document.getElementById('modalTotal').textContent = '¥' + parseFloat(order.totalAmount).toFixed(2);

                var itemsHtml = '';
                if (data.items && data.items.length > 0) {
                    data.items.forEach(function(item) {
                        var img = item.productImage || '';
                        if (img && !img.startsWith('uploads/') && !img.startsWith('http')) {
                            img = 'uploads/' + img;
                        }
                        itemsHtml += '<div class="item">';
                        if (img) {
                            itemsHtml += '<img src="${pageContext.request.contextPath}/' + img + '" alt="' + item.productName + '">';
                        } else {
                            itemsHtml += '<div style="width:40px;height:40px;background:#f0f0f0;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:20px;color:#ddd;">👕</div>';
                        }
                        itemsHtml += '<div class="info">';
                        itemsHtml += '<div class="name">' + item.productName + ' × ' + item.quantity + '</div>';
                        itemsHtml += '<div class="price">¥' + parseFloat(item.price).toFixed(2) + '</div>';
                        itemsHtml += '</div></div>';
                    });
                } else {
                    itemsHtml = '<div style="color:#999;padding:12px 0;">暂无商品信息</div>';
                }
                document.getElementById('modalItems').innerHTML = itemsHtml;
                document.getElementById('orderModal').classList.add('show');
            })
            .catch(function(error) {
                console.error('加载订单详情失败:', error);
                alert('加载订单详情失败，请重试');
            });
    }

    function closeModal() {
        document.getElementById('orderModal').classList.remove('show');
    }

    document.getElementById('orderModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    // ===== 删除订单 =====
    function deleteOrder(orderId) {
        if (!confirm('确定要删除这个订单吗？\n（衣橱中的衣服不会被删除）')) return;
        fetch('${pageContext.request.contextPath}/order/delete?id=' + orderId, {
            method: 'POST'
        })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    alert('✅ 订单已删除');
                    location.reload();
                } else {
                    alert(data.message || '删除失败，请重试');
                }
            })
            .catch(function() {
                alert('请求失败，请重试');
            });
    }
</script>

</body>
</html>