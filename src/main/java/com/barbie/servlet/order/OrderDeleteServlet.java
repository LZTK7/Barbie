package com.barbie.servlet.order;

import com.barbie.dao.OrderDao;
import com.barbie.model.Order;
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

public class OrderDeleteServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

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

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            result.put("success", false);
            result.put("message", "参数错误");
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        int orderId = Integer.parseInt(idParam);

        // 先查询订单确认属于当前用户
        Order order = orderDao.findById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            result.put("success", false);
            result.put("message", "订单不存在");
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        // 只能删除已完结的订单
        if (!"completed".equals(order.getStatus())) {
            result.put("success", false);
            result.put("message", "只能删除已完结的订单");
            new Gson().toJson(result, resp.getWriter());
            return;
        }

        boolean success = orderDao.deleteById(orderId);
        result.put("success", success);
        if (success) {
            result.put("message", "订单已删除");
        } else {
            result.put("message", "删除失败，请重试");
        }
        new Gson().toJson(result, resp.getWriter());
    }
}