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
        String wardrobeIds = req.getParameter("wardrobeIds");
        String pendingIds = req.getParameter("pendingIds");
        String scene = req.getParameter("scene");
        String season = req.getParameter("season");

        System.out.println("========== 创建搭配 ==========");
        System.out.println("wardrobeIds: " + wardrobeIds);
        System.out.println("pendingIds: " + pendingIds);

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "请输入搭配名称");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        if (wardrobeIds == null || wardrobeIds.trim().isEmpty()) {
            req.setAttribute("error", "请选择已有衣服");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        Look look = new Look();
        look.setUserId(user.getId());
        look.setName(name);
        look.setWardrobeIds(wardrobeIds);
        look.setPendingIds(pendingIds != null ? pendingIds : "");  // ← 关键：保存待购
        look.setScene(scene);
        look.setSeason(season);

        boolean success = lookDao.create(look);
        System.out.println("保存结果: " + success);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
        } else {
            req.setAttribute("error", "创建搭配失败，请重试");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
        }
    }
}