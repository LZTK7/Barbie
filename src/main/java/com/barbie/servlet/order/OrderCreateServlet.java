package com.barbie.servlet.order;

import com.barbie.dao.CartDao;
import com.barbie.dao.LookDao;
import com.barbie.dao.OrderDao;
import com.barbie.dao.OrderItemDao;
import com.barbie.dao.ProductDao;
import com.barbie.model.CartItem;
import com.barbie.model.Look;
import com.barbie.model.Order;
import com.barbie.model.OrderItem;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderCreateServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();
    private OrderDao orderDao = new OrderDao();
    private OrderItemDao orderItemDao = new OrderItemDao();
    private ProductDao productDao = new ProductDao();
    private LookDao lookDao = new LookDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");
        Map<String, Object> result = new HashMap<>();

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            result.put("count", 0);
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        String cartIdsParam = req.getParameter("cartIds");
        System.out.println("========== OrderCreateServlet ==========");
        System.out.println("cartIdsParam: " + cartIdsParam);

        if (cartIdsParam == null || cartIdsParam.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "请选择商品");
            result.put("count", 0);
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        String[] idArray = cartIdsParam.split(",");
        List<Integer> cartIds = new ArrayList<>();
        for (String idStr : idArray) {
            try {
                cartIds.add(Integer.parseInt(idStr.trim()));
            } catch (NumberFormatException e) {}
        }

        System.out.println("cartIds: " + cartIds);

        if (cartIds.isEmpty()) {
            result.put("success", false);
            result.put("message", "没有有效的商品ID");
            result.put("count", 0);
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        List<CartItem> cartItems = cartDao.findByUserId(user.getId());
        List<CartItem> selectedItems = new ArrayList<>();
        List<Integer> productIds = new ArrayList<>();
        for (CartItem item : cartItems) {
            if (cartIds.contains(item.getId())) {
                selectedItems.add(item);
                productIds.add(item.getProductId());
            }
        }

        System.out.println("选中的商品数: " + selectedItems.size());
        System.out.println("商品ID列表: " + productIds);

        if (selectedItems.isEmpty()) {
            result.put("success", false);
            result.put("message", "购物车中没有选中的商品");
            result.put("count", 0);
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        // ===== 创建订单 =====
        List<Integer> createdOrderIds = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");

        for (CartItem item : selectedItems) {
            Product p = item.getProduct();
            String orderNo = "ORD" + sdf.format(new Date()) + System.nanoTime() % 1000;

            Order order = new Order();
            order.setUserId(user.getId());
            order.setOrderNo(orderNo);
            order.setTotalAmount(p.getPrice() * item.getQuantity());
            order.setStatus("shipped");
            order.setAddress("默认收货地址");
            order.setReceiver(user.getNickname());
            order.setPhone("13800138000");

            int orderId = orderDao.create(order);
            System.out.println("创建订单ID: " + orderId);
            if (orderId > 0) {
                createdOrderIds.add(orderId);
                OrderItem oi = new OrderItem();
                oi.setOrderId(orderId);
                oi.setProductId(p.getId());
                oi.setProductName(p.getName());
                oi.setProductImage(p.getImages());
                oi.setSku(item.getSku());
                oi.setPrice(p.getPrice());
                oi.setQuantity(item.getQuantity());
                List<OrderItem> items = new ArrayList<>();
                items.add(oi);
                orderItemDao.batchInsert(items);
                System.out.println("订单商品已插入: " + p.getName());
            }
        }

        // 删除购物车商品
        cartDao.deleteByIds(user.getId(), cartIds);
        System.out.println("已删除选中的购物车商品");

        // ===== 更新所有搭配的状态 =====
        List<Look> allLooks = lookDao.findByUserId(user.getId());
        System.out.println("用户共有 " + allLooks.size() + " 个搭配");

        for (Look look : allLooks) {
            System.out.println("处理搭配 " + look.getId() + ": " + look.getName());
            System.out.println("  当前 pending_ids: " + look.getPendingIds());
            System.out.println("  当前 cart_ids: " + look.getCartIds());
            System.out.println("  当前 shipped_ids: " + look.getShippedIds());

            boolean changed = false;

            // 1. 从 pending_ids 中移除已结算的商品
            String pending = look.getPendingIds();
            if (pending != null && !pending.isEmpty()) {
                List<String> pendingList = new ArrayList<>(Arrays.asList(pending.split(",")));
                for (Integer pid : productIds) {
                    String pidStr = String.valueOf(pid);
                    if (pendingList.contains(pidStr)) {
                        pendingList.remove(pidStr);
                        changed = true;
                        System.out.println("  从待加购移除商品: " + pid);
                    }
                }
                look.setPendingIds(String.join(",", pendingList));
            }

            // 2. cart_ids → shipped_ids
            String cart = look.getCartIds();
            if (cart != null && !cart.isEmpty()) {
                List<String> cartList = new ArrayList<>(Arrays.asList(cart.split(",")));
                List<String> shippedList = new ArrayList<>();
                String existingShipped = look.getShippedIds();
                if (existingShipped != null && !existingShipped.isEmpty()) {
                    shippedList = new ArrayList<>(Arrays.asList(existingShipped.split(",")));
                }

                for (Integer pid : productIds) {
                    String pidStr = String.valueOf(pid);
                    if (cartList.contains(pidStr)) {
                        cartList.remove(pidStr);
                        if (!shippedList.contains(pidStr)) {
                            shippedList.add(pidStr);
                        }
                        changed = true;
                        System.out.println("  搭配 " + look.getId() + ": 待购买 → 待收货, 商品: " + pid);
                    }
                }
                look.setCartIds(String.join(",", cartList));
                look.setShippedIds(String.join(",", shippedList));
            }

            if (changed) {
                lookDao.update(look);
                System.out.println("  更新后 pending_ids: " + look.getPendingIds());
                System.out.println("  更新后 cart_ids: " + look.getCartIds());
                System.out.println("  更新后 shipped_ids: " + look.getShippedIds());
            }
        }

        System.out.println("成功创建 " + createdOrderIds.size() + " 个订单");
        System.out.println("========== OrderCreateServlet 结束 ==========");

        result.put("success", true);
        result.put("count", createdOrderIds.size());
        result.put("message", createdOrderIds.size() + " 个订单已生成");
        new Gson().toJson(result, resp.getWriter());
    }
}