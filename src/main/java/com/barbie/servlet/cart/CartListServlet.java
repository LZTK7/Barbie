package com.barbie.servlet.cart;

import com.barbie.dao.CartDao;
import com.barbie.model.CartItem;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class CartListServlet extends HttpServlet {

    private CartDao cartDao = new CartDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        List<CartItem> cartItems = cartDao.findByUserId(user.getId());
        req.setAttribute("cartItems", cartItems);
        req.getRequestDispatcher("/pages/cart/cart.jsp").forward(req, resp);
    }
}