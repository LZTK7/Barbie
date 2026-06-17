package com.barbie.servlet.order;

import com.barbie.dao.OrderDao;
import com.barbie.model.Order;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class OrderListServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. 获取当前登录用户
        User user = SessionUtil.getLoginUser(req.getSession());

        // 2. 获取状态参数（默认 all）
        String status = req.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "all";
        }

        // 3. 查询订单
        List<Order> orders = null;
        if (user != null) {
            orders = orderDao.findByUserIdAndStatus(user.getId(), status);
            System.out.println("当前用户ID: " + user.getId());
            System.out.println("查询状态: " + status);
            System.out.println("查到订单数: " + (orders == null ? 0 : orders.size()));
        } else {
            System.out.println("用户未登录！");
        }

        // 4. 存入 request 并转发到 JSP
        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", status);
        req.getRequestDispatcher("/pages/order/orderList.jsp").forward(req, resp);
    }
}