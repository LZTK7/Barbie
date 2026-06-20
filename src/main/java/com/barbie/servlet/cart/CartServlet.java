package com.barbie.servlet.cart;

import com.barbie.dao.CartDao;
import com.barbie.model.CartItem;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");
        Map<String, Object> result = new HashMap<>();

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        String action = req.getParameter("action");
        int cartId = Integer.parseInt(req.getParameter("cartId"));

        switch (action) {
            case "update":
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                boolean updated = cartDao.updateQuantity(cartId, quantity);
                result.put("success", updated);
                if (updated) {
                    List<CartItem> items = cartDao.findByUserId(user.getId());
                    double total = 0;
                    for (CartItem item : items) {
                        total += item.getProduct().getPrice() * item.getQuantity();
                    }
                    result.put("total", total);
                }
                break;

            case "delete":
                boolean deleted = cartDao.deleteById(cartId, user.getId());
                result.put("success", deleted);
                break;

            default:
                result.put("success", false);
                result.put("message", "未知操作");
                break;
        }

        new Gson().toJson(result, resp.getWriter());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");
        Map<String, Object> result = new HashMap<>();

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        String action = req.getParameter("action");
        switch (action) {
            case "clear":
                boolean cleared = cartDao.clearCart(user.getId());
                result.put("success", cleared);
                break;
            default:
                result.put("success", false);
                break;
        }

        new Gson().toJson(result, resp.getWriter());
    }
}