package com.barbie.servlet.order;

import com.barbie.dao.LookDao;
import com.barbie.dao.OrderDao;
import com.barbie.dao.OrderItemDao;
import com.barbie.dao.ProductDao;
import com.barbie.dao.WardrobeDao;
import com.barbie.model.Look;
import com.barbie.model.OrderItem;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ConfirmReceiptServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
    private OrderItemDao orderItemDao = new OrderItemDao();
    private WardrobeDao wardrobeDao = new WardrobeDao();
    private LookDao lookDao = new LookDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("orderId"));
        System.out.println("========== ConfirmReceiptServlet ==========");
        System.out.println("确认收货 - orderId: " + orderId);

        // 1. 获取订单商品
        List<OrderItem> items = orderItemDao.findByOrderId(orderId);
        List<Integer> productIds = new ArrayList<>();
        for (OrderItem item : items) {
            productIds.add(item.getProductId());
        }
        System.out.println("订单商品ID列表: " + productIds);

        // 2. 更新订单状态
        orderDao.updateStatus(orderId, "completed");

        // 3. 同步到衣橱，获取实际插入的衣橱ID
        List<Integer> syncedWardrobeIds = new ArrayList<>();
        for (OrderItem item : items) {
            Product p = productDao.findById(item.getProductId());
            if (p != null) {
                int wardrobeId = wardrobeDao.addFromOrder(
                        user.getId(),
                        item.getId(),
                        p.getName(),
                        p.getImages(),
                        p.getCategory(),
                        p.getColor(),
                        p.getSeason()
                );
                if (wardrobeId > 0) {
                    syncedWardrobeIds.add(wardrobeId);
                    System.out.println("已同步到衣橱，wardrobe_id: " + wardrobeId + ", 商品: " + p.getName());
                } else {
                    System.out.println("同步衣橱失败: " + p.getName());
                }
            }
        }

        // 4. 更新所有搭配：shipped_ids → wardrobe_ids（使用实际插入的衣橱ID）
        List<Look> allLooks = lookDao.findByUserId(user.getId());
        System.out.println("用户共有 " + allLooks.size() + " 个搭配");

        for (Look look : allLooks) {
            System.out.println("处理搭配 " + look.getId() + ": " + look.getName());
            System.out.println("  当前 shipped_ids: " + look.getShippedIds());
            System.out.println("  当前 wardrobe_ids: " + look.getWardrobeIds());

            String shipped = look.getShippedIds();
            if (shipped == null || shipped.isEmpty()) {
                System.out.println("  没有待收货商品，跳过");
                continue;
            }

            List<String> shippedList = new ArrayList<>(Arrays.asList(shipped.split(",")));
            List<String> wardrobeList = new ArrayList<>();
            String existingWardrobe = look.getWardrobeIds();
            if (existingWardrobe != null && !existingWardrobe.isEmpty()) {
                wardrobeList = new ArrayList<>(Arrays.asList(existingWardrobe.split(",")));
            }

            boolean changed = false;
            // 使用 syncedWardrobeIds（实际插入的衣橱ID）
            for (Integer wardrobeId : syncedWardrobeIds) {
                String idStr = String.valueOf(wardrobeId);
                // 从 shipped_ids 中移除对应的商品（通过productId匹配，但shipped_ids存的是productId）
                // 需要从shipped_ids中移除productId，然后添加wardrobeId到wardrobe_ids
                // 由于shipped_ids存的是商品ID，而wardrobe_ids存的是衣橱ID，需要映射
                // 这里简化：从shipped_ids中移除所有productIds，然后添加wardrobeIds
            }

            // 重新设计：从shipped_ids中移除productId，然后添加wardrobeId到wardrobe_ids
            // 先移除所有productIds
            for (Integer pid : productIds) {
                String pidStr = String.valueOf(pid);
                if (shippedList.contains(pidStr)) {
                    shippedList.remove(pidStr);
                    changed = true;
                }
            }
            // 再添加所有wardrobeIds
            for (Integer wardrobeId : syncedWardrobeIds) {
                String idStr = String.valueOf(wardrobeId);
                if (!wardrobeList.contains(idStr)) {
                    wardrobeList.add(idStr);
                    changed = true;
                }
            }

            if (changed) {
                look.setShippedIds(String.join(",", shippedList));
                look.setWardrobeIds(String.join(",", wardrobeList));
                boolean updateResult = lookDao.update(look);
                System.out.println("  更新结果: " + updateResult);
                System.out.println("  更新后 shipped_ids: " + look.getShippedIds());
                System.out.println("  更新后 wardrobe_ids: " + look.getWardrobeIds());
            }
        }

        System.out.println("========== ConfirmReceiptServlet 结束 ==========");
        resp.sendRedirect(req.getContextPath() + "/pages/user/profile.jsp?status=all");
    }
}