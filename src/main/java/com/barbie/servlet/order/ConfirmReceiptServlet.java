package com.barbie.servlet.order;

import com.barbie.dao.OrderDao;
import com.barbie.dao.OrderItemDao;
import com.barbie.dao.WardrobeDao;
import com.barbie.model.OrderItem;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class ConfirmReceiptServlet extends HttpServlet {

    private OrderDao orderDao = new OrderDao();
    private OrderItemDao orderItemDao = new OrderItemDao();
    private WardrobeDao wardrobeDao = new WardrobeDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int orderId = Integer.parseInt(req.getParameter("orderId"));

        // 1. 更新订单状态为已完结
        orderDao.updateStatus(orderId, "completed");

        // 2. 查询该订单的所有商品
        List<OrderItem> items = orderItemDao.findByOrderId(orderId);

        // 3. 逐件添加到虚拟衣橱
        for (OrderItem item : items) {
            wardrobeDao.addFromOrder(
                    user.getId(),
                    item.getId(),
                    item.getProductName(),
                    item.getProductImage(),
                    "上装",
                    "白色",
                    "四季"
            );
        }

        // 4. 重定向回订单列表
        resp.sendRedirect(req.getContextPath() + "/order/list?status=all");
    }
}