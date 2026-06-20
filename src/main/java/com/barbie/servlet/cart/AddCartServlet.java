package com.barbie.servlet.cart;

import com.barbie.dao.CartDao;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class AddCartServlet extends HttpServlet {

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

        int productId = Integer.parseInt(req.getParameter("productId"));
        int quantity = 1;
        if (req.getParameter("quantity") != null) {
            quantity = Integer.parseInt(req.getParameter("quantity"));
        }

        boolean success = cartDao.addToCart(user.getId(), productId, "默认", quantity);
        result.put("success", success);
        if (success) {
            result.put("message", "已加入购物车");
        } else {
            result.put("message", "加入失败，请重试");
        }

        new Gson().toJson(result, resp.getWriter());
    }
}