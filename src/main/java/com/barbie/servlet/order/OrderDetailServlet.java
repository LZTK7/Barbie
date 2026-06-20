package com.barbie.servlet.order;

import com.barbie.dao.OrderDao;
import com.barbie.dao.OrderItemDao;
import com.barbie.model.Order;
import com.barbie.model.OrderItem;
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

public class OrderDetailServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
    private OrderItemDao orderItemDao = new OrderItemDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.getWriter().write("{\"success\":false,\"message\":\"请先登录\"}");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("id"));
        Order order = orderDao.findById(orderId);

        if (order == null || order.getUserId() != user.getId()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"订单不存在\"}");
            return;
        }

        List<OrderItem> items = orderItemDao.findByOrderId(orderId);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("order", order);
        result.put("items", items);

        new Gson().toJson(result, resp.getWriter());
    }
}