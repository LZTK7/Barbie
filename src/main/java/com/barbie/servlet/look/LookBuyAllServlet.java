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
        if (pendingIds == null || pendingIds.isEmpty()) {
            req.setAttribute("error", "没有待购商品");
            req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
            return;
        }

        String[] ids = pendingIds.split(",");
        List<Product> products = new ArrayList<>();
        for (String id : ids) {
            Product p = productDao.findById(Integer.parseInt(id));
            if (p != null) {
                products.add(p);
            }
        }

        if (products.isEmpty()) {
            req.setAttribute("error", "没有可加购的商品");
            req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
            return;
        }

        int addedCount = 0;
        for (Product p : products) {
            boolean success = cartDao.addToCart(user.getId(), p.getId(), "默认", 1);
            if (success) addedCount++;
        }

        if (addedCount > 0) {
            resp.sendRedirect(req.getContextPath() + "/pages/cart/cart.jsp");
        } else {
            req.setAttribute("error", "加购失败，请重试");
            req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
        }
    }
}