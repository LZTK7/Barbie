<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.barbie.model.CartItem, com.barbie.model.Product" %>
<%@ page import="com.barbie.model.User" %>
<%@ page import="com.barbie.util.SessionUtil" %>
<%
    User user = SessionUtil.getLoginUser(session);
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/user/login.jsp");
        return;
    }
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    int totalCount = 0;
    double totalPrice = 0;
    if (cartItems != null) {
        for (CartItem item : cartItems) {
            totalCount += item.getQuantity();
            totalPrice += item.getProduct().getPrice() * item.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物车 - Barbie</title>
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
            max-width: 900px;
            margin: 0 auto;
            padding: 30px 40px;
        }
        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .cart-header h2 { font-size: 22px; color: #333; }
        .cart-header .empty-btn {
            color: #999;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            background: none;
            border: none;
        }
        .cart-header .empty-btn:hover { color: #ff6b81; }

        .select-all-bar {
            background: white;
            border-radius: 10px;
            padding: 12px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .select-all-bar input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #ff6b81;
        }
        .select-all-bar label {
            font-size: 14px;
            color: #333;
            cursor: pointer;
        }
        .select-all-bar .total-info {
            margin-left: auto;
            font-size: 14px;
            color: #666;
        }
        .select-all-bar .total-info span {
            color: #ff6b81;
            font-weight: bold;
            font-size: 18px;
        }

        .cart-item {
            background: white;
            border-radius: 10px;
            padding: 16px 20px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            transition: all 0.3s;
        }
        .cart-item:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

        .cart-item input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #ff6b81;
            flex-shrink: 0;
        }

        .cart-item .item-img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 6px;
            background: #f0f0f0;
            cursor: pointer;
            flex-shrink: 0;
        }
        .cart-item .item-img-placeholder {
            width: 70px;
            height: 70px;
            border-radius: 6px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            color: #ddd;
            cursor: pointer;
            flex-shrink: 0;
        }

        .cart-item .item-info {
            flex: 1;
            min-width: 0;
        }
        .cart-item .item-info .name {
            font-size: 15px;
            font-weight: bold;
            color: #333;
            cursor: pointer;
        }
        .cart-item .item-info .name:hover { color: #ff6b81; }
        .cart-item .item-info .category {
            font-size: 12px;
            color: #999;
            margin-top: 2px;
        }
        .cart-item .item-info .price {
            font-size: 16px;
            font-weight: bold;
            color: #ff6b81;
            margin-top: 4px;
        }

        .cart-item .item-actions {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-shrink: 0;
        }
        .cart-item .item-actions .qty-btn {
            width: 28px;
            height: 28px;
            border: 1px solid #ddd;
            border-radius: 50%;
            background: white;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
        }
        .cart-item .item-actions .qty-btn:hover {
            border-color: #ff6b81;
            color: #ff6b81;
        }
        .cart-item .item-actions .qty {
            font-size: 16px;
            font-weight: bold;
            min-width: 30px;
            text-align: center;
        }
        .cart-item .item-actions .delete-btn {
            color: #ccc;
            cursor: pointer;
            font-size: 18px;
            background: none;
            border: none;
            transition: all 0.3s;
        }
        .cart-item .item-actions .delete-btn:hover { color: #ff6b81; }

        .empty-cart {
            text-align: center;
            padding: 60px 0;
            color: #999;
        }
        .empty-cart .icon { font-size: 64px; display: block; margin-bottom: 16px; }
        .empty-cart a { color: #ff6b81; text-decoration: none; }

        .cart-footer {
            background: white;
            border-radius: 10px;
            padding: 16px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .cart-footer .total {
            font-size: 16px;
            color: #333;
        }
        .cart-footer .total span {
            font-size: 22px;
            font-weight: bold;
            color: #ff6b81;
        }
        .btn-checkout {
            padding: 10px 40px;
            background: #ff6b81;
            color: white;
            border: none;
            border-radius: 20px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-checkout:hover { background: #e8556b; }
        .btn-checkout:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .footer {
            text-align: center;
            color: #ccc;
            font-size: 13px;
            padding: 20px 0 16px;
            border-top: 1px solid #f0f0f0;
            margin-top: 24px;
        }

        @media (max-width: 768px) {
            .container { padding: 16px; }
            .top-bar { padding: 0 16px; }
            .cart-item { flex-wrap: wrap; }
            .cart-item .item-actions { margin-left: auto; }
            .cart-footer { flex-direction: column; gap: 12px; }
        }
    </style>
</head>
<body>

<div class="top-bar">
    <a href="${pageContext.request.contextPath}/index" class="logo">👗 Barbie</a>
    <a href="${pageContext.request.contextPath}/index" class="back-home">← 返回首页</a>
</div>

<div class="container">

    <div class="cart-header">
        <h2>🛒 购物车</h2>
        <button class="empty-btn" onclick="clearCart()">🗑️ 清空购物车</button>
    </div>

    <%
        if (cartItems == null || cartItems.isEmpty()) {
    %>
    <div class="empty-cart">
        <span class="icon">🛒</span>
        购物车是空的<br>
        去 <a href="${pageContext.request.contextPath}/index">逛逛</a> 吧！
    </div>
    <%
    } else {
    %>

    <div class="select-all-bar">
        <input type="checkbox" id="selectAll" onchange="toggleAll(this.checked)">
        <label for="selectAll">全选</label>
        <div class="total-info">
            共 <span id="selectedCount"><%= totalCount %></span> 件，合计 ¥<span id="selectedTotal"><%= String.format("%.2f", totalPrice) %></span>
        </div>
    </div>

    <div id="cartList">
        <%
            for (CartItem item : cartItems) {
                Product p = item.getProduct();
                String img = p.getImages();
                if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
                    img = "uploads/" + img;
                }
        %>
        <div class="cart-item" data-id="<%= item.getId() %>" data-price="<%= p.getPrice() %>" data-quantity="<%= item.getQuantity() %>">
            <input type="checkbox" class="item-checkbox" checked onchange="updateTotal()">
            <%
                if (img != null && !img.isEmpty()) {
            %>
            <img src="${pageContext.request.contextPath}/<%= img %>" class="item-img" onclick="goDetail(<%= p.getId() %>)">
            <%
            } else {
            %>
            <div class="item-img-placeholder" onclick="goDetail(<%= p.getId() %>)">👕</div>
            <%
                }
            %>
            <div class="item-info">
                <div class="name" onclick="goDetail(<%= p.getId() %>)"><%= p.getName() %></div>
                <div class="category"><%= p.getCategory() %></div>
                <div class="price">¥<%= p.getPrice() %></div>
            </div>
            <div class="item-actions">
                <button class="qty-btn" onclick="updateQty(<%= item.getId() %>, -1)">−</button>
                <span class="qty" id="qty_<%= item.getId() %>"><%= item.getQuantity() %></span>
                <button class="qty-btn" onclick="updateQty(<%= item.getId() %>, 1)">+</button>
                <button class="delete-btn" onclick="deleteItem(<%= item.getId() %>)">✕</button>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <div class="cart-footer">
        <div class="total">合计：¥<span id="footerTotal"><%= String.format("%.2f", totalPrice) %></span></div>
        <button class="btn-checkout" id="checkoutBtn" onclick="checkout()">去结算</button>
    </div>

    <%
        }
    %>

    <div class="footer">
        © 2026 Barbie · 网上衣橱电商平台 · 课程设计
    </div>
</div>

<script>
    // ===== 点击商品跳转详情 =====
    function goDetail(productId) {
        window.location.href = '${pageContext.request.contextPath}/pages/product/detail.jsp?id=' + productId;
    }

    // ===== 全选/取消全选 =====
    function toggleAll(checked) {
        document.querySelectorAll('.item-checkbox').forEach(function(cb) {
            cb.checked = checked;
        });
        updateTotal();
    }

    // ===== 更新总计 =====
    function updateTotal() {
        var total = 0;
        var count = 0;
        document.querySelectorAll('.cart-item').forEach(function(item) {
            var cb = item.querySelector('.item-checkbox');
            if (cb && cb.checked) {
                var price = parseFloat(item.dataset.price);
                var qty = parseInt(item.dataset.quantity);
                total += price * qty;
                count += qty;
            }
        });
        document.getElementById('selectedCount').textContent = count;
        document.getElementById('selectedTotal').textContent = total.toFixed(2);
        document.getElementById('footerTotal').textContent = total.toFixed(2);
    }

    // ===== 修改数量 =====
    function updateQty(cartId, delta) {
        var item = document.querySelector('.cart-item[data-id="' + cartId + '"]');
        var qtySpan = document.getElementById('qty_' + cartId);
        var currentQty = parseInt(qtySpan.textContent);
        var newQty = currentQty + delta;
        if (newQty < 1) return;

        qtySpan.textContent = newQty;
        item.dataset.quantity = newQty;
        updateTotal();

        fetch('${pageContext.request.contextPath}/cart/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=update&cartId=' + cartId + '&quantity=' + newQty
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (!data.success) {
                alert('更新失败，请重试');
                qtySpan.textContent = currentQty;
                item.dataset.quantity = currentQty;
                updateTotal();
            }
        }).catch(function() {
            alert('请求失败');
        });
    }

    // ===== 删除商品 =====
    function deleteItem(cartId) {
        if (!confirm('确定要删除这件商品吗？')) return;
        var item = document.querySelector('.cart-item[data-id="' + cartId + '"]');
        fetch('${pageContext.request.contextPath}/cart/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'action=delete&cartId=' + cartId
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.success) {
                item.remove();
                updateTotal();
                if (document.querySelectorAll('.cart-item').length === 0) {
                    location.reload();
                }
            } else {
                alert('删除失败');
            }
        }).catch(function() {
            alert('请求失败');
        });
    }

    // ===== 清空购物车 =====
    function clearCart() {
        if (!confirm('确定要清空购物车吗？')) return;
        fetch('${pageContext.request.contextPath}/cart/clear', {
            method: 'GET'
        }).then(function(response) {
            return response.json();
        }).then(function(data) {
            if (data.success) {
                location.reload();
            } else {
                alert('清空失败');
            }
        }).catch(function() {
            alert('请求失败');
        });
    }

    // ===== 去结算 =====
    function checkout() {
        var selectedItems = document.querySelectorAll('.item-checkbox:checked');
        if (selectedItems.length === 0) {
            alert('请至少选择一件商品');
            return;
        }

        if (!confirm('确认结算选中的 ' + selectedItems.length + ' 件商品吗？')) {
            return;
        }

        var cartIds = [];
        document.querySelectorAll('.cart-item').forEach(function(item) {
            var cb = item.querySelector('.item-checkbox');
            if (cb && cb.checked) {
                cartIds.push(item.dataset.id);
            }
        });

        fetch('${pageContext.request.contextPath}/order/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'cartIds=' + cartIds.join(',')
        })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.success) {
                    alert('✅ 已生成 ' + data.count + ' 个订单！');
                    location.reload();
                } else {
                    alert(data.message || '下单失败，请重试');
                }
            })
            .catch(function() {
                alert('请求失败，请重试');
            });
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateTotal();
    });
</script>

</body>
</html>