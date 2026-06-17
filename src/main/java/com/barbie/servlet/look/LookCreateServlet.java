package com.barbie.servlet.look;

import com.barbie.dao.LookDao;
import com.barbie.model.Look;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LookCreateServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        String name = req.getParameter("name");
        String[] wardrobeIds = req.getParameterValues("wardrobeIds");
        String scene = req.getParameter("scene");
        String season = req.getParameter("season");

        if (wardrobeIds == null || wardrobeIds.length < 2) {
            req.setAttribute("error", "请至少选择2件衣服");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        String idsStr = String.join(",", wardrobeIds);

        Look look = new Look();
        look.setUserId(user.getId());
        look.setName(name);
        look.setWardrobeIds(idsStr);
        look.setScene(scene);
        look.setSeason(season);

        boolean success = lookDao.create(look);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
        } else {
            req.setAttribute("error", "创建搭配失败，请重试");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
        }
    }
}