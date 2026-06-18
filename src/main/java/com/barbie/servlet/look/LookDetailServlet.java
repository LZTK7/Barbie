package com.barbie.servlet.look;

import com.barbie.dao.LookDao;
import com.barbie.dao.ProductDao;
import com.barbie.dao.WardrobeDao;
import com.barbie.model.Look;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.model.Wardrobe;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class LookDetailServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();
    private WardrobeDao wardrobeDao = new WardrobeDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int lookId = Integer.parseInt(req.getParameter("id"));
        Look look = lookDao.findById(lookId, user.getId());

        if (look == null) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
            return;
        }

        // 获取搭配中的所有已有衣物
        List<Wardrobe> items = new ArrayList<>();
        String wardrobeIds = look.getWardrobeIds();
        if (wardrobeIds != null && !wardrobeIds.isEmpty()) {
            String[] ids = wardrobeIds.split(",");
            for (String idStr : ids) {
                Wardrobe w = wardrobeDao.findById(Integer.parseInt(idStr.trim()), user.getId());
                if (w != null) {
                    items.add(w);
                }
            }
        }

        // 获取待购商品
        List<Product> pendingProducts = new ArrayList<>();
        String pendingIds = look.getPendingIds();
        if (pendingIds != null && !pendingIds.isEmpty()) {
            String[] ids = pendingIds.split(",");
            for (String idStr : ids) {
                Product p = productDao.findById(Integer.parseInt(idStr.trim()));
                if (p != null) {
                    pendingProducts.add(p);
                }
            }
        }

        req.setAttribute("look", look);
        req.setAttribute("items", items);
        req.setAttribute("pendingProducts", pendingProducts);
        req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
    }
}