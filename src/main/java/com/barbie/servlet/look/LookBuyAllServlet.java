package com.barbie.servlet.look;

import com.barbie.dao.CartDao;
import com.barbie.dao.LookDao;
import com.barbie.dao.ProductDao;
import com.barbie.model.Look;
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

public class LookBuyAllServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();
    private ProductDao productDao = new ProductDao();
    private CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int lookId = Integer.parseInt(req.getParameter("lookId"));
        Look look = lookDao.findById(lookId, user.getId());

        if (look == null) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
            return;
        }

        String pendingIds = look.getPendingIds();
        System.out.println("========== LookBuyAllServlet ==========");
        System.out.println("lookId: " + lookId);
        System.out.println("pendingIds: " + pendingIds);

        if (pendingIds == null || pendingIds.isEmpty()) {
            req.setAttribute("error", "没有待加购商品");
            req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
            return;
        }

        String[] idArray = pendingIds.split(",");
        List<Integer> productIds = new ArrayList<>();
        List<Product> products = new ArrayList<>();
        for (String idStr : idArray) {
            try {
                Product p = productDao.findById(Integer.parseInt(idStr.trim()));
                if (p != null) {
                    productIds.add(p.getId());
                    products.add(p);
                }
            } catch (NumberFormatException e) {
                System.err.println("无效的商品ID: " + idStr);
            }
        }

        if (products.isEmpty()) {
            req.setAttribute("error", "没有可加购的商品");
            req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
            return;
        }

        System.out.println("待加购商品ID列表: " + productIds);

        // ===== 1. 从所有搭配中：pending_ids → cart_ids =====
        List<Look> allLooks = lookDao.findByUserId(user.getId());
        System.out.println("用户共有 " + allLooks.size() + " 个搭配");

        for (Look l : allLooks) {
            System.out.println("处理搭配 " + l.getId() + ": " + l.getName());
            System.out.println("  当前 pending_ids: " + l.getPendingIds());
            System.out.println("  当前 cart_ids: " + l.getCartIds());

            String pending = l.getPendingIds();
            if (pending == null || pending.isEmpty()) {
                System.out.println("  没有待加购商品，跳过");
                continue;
            }

            List<String> pendingList = new ArrayList<>(Arrays.asList(pending.split(",")));
            List<String> cartList = new ArrayList<>();
            String existingCart = l.getCartIds();
            if (existingCart != null && !existingCart.isEmpty()) {
                cartList = new ArrayList<>(Arrays.asList(existingCart.split(",")));
            }

            boolean changed = false;
            for (Integer pid : productIds) {
                String pidStr = String.valueOf(pid);
                if (pendingList.contains(pidStr)) {
                    pendingList.remove(pidStr);
                    if (!cartList.contains(pidStr)) {
                        cartList.add(pidStr);
                    }
                    changed = true;
                    System.out.println("  搭配 " + l.getId() + ": 待加购 → 待购买, 商品: " + pid);
                }
            }

            if (changed) {
                l.setPendingIds(String.join(",", pendingList));
                l.setCartIds(String.join(",", cartList));
                lookDao.update(l);
                System.out.println("  更新后 pending_ids: " + l.getPendingIds());
                System.out.println("  更新后 cart_ids: " + l.getCartIds());
            }
        }

        // ===== 2. 加入购物车 =====
        int addedCount = 0;
        for (Product p : products) {
            boolean success = cartDao.addToCart(user.getId(), p.getId(), "默认", 1);
            if (success) {
                addedCount++;
                System.out.println("加入购物车成功: " + p.getName());
            } else {
                System.out.println("加入购物车失败: " + p.getName());
            }
        }
        System.out.println("共加入购物车 " + addedCount + " 件商品");

        System.out.println("========== LookBuyAllServlet 结束 ==========");
        resp.sendRedirect(req.getContextPath() + "/cart/list");
    }
}