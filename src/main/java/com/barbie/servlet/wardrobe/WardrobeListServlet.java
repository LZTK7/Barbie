package com.barbie.servlet.wardrobe;

import com.barbie.dao.WardrobeDao;
import com.barbie.model.User;
import com.barbie.model.Wardrobe;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class WardrobeListServlet extends HttpServlet {

    private WardrobeDao wardrobeDao = new WardrobeDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        List<Wardrobe> list = wardrobeDao.findByUserId(user.getId());
        req.setAttribute("wardrobeList", list);
        req.getRequestDispatcher("/pages/wardrobe/wardrobeList.jsp").forward(req, resp);
    }
}