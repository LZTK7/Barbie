package com.barbie.servlet.look;

import com.barbie.dao.LookDao;
import com.barbie.dao.WardrobeDao;
import com.barbie.model.Look;
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

        // 获取搭配中的所有衣物
        String[] ids = look.getWardrobeIds().split(",");
        List<Wardrobe> items = new ArrayList<>();
        for (String idStr : ids) {
            Wardrobe w = wardrobeDao.findById(Integer.parseInt(idStr), user.getId());
            if (w != null) {
                items.add(w);
            }
        }

        req.setAttribute("look", look);
        req.setAttribute("items", items);
        req.getRequestDispatcher("/pages/look/lookDetail.jsp").forward(req, resp);
    }
}