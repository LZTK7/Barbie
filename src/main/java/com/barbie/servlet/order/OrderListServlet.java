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

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        String status = req.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "all";
        }

        List<Order> orders = orderDao.findByUserIdAndStatus(user.getId(), status);

        // 打印调试信息
        System.out.println("当前用户ID: " + user.getId());
        System.out.println("查询状态: " + status);
        System.out.println("查到订单数: " + (orders == null ? 0 : orders.size()));
        if (orders != null && !orders.isEmpty()) {
            for (Order o : orders) {
                System.out.println("订单号: " + o.getOrderNo() + ", 状态: " + o.getStatus());
            }
        }

        req.setAttribute("orders", orders);
        req.setAttribute("currentStatus", status);
        req.getRequestDispatcher("/pages/order/orderList.jsp").forward(req, resp);
    }
}