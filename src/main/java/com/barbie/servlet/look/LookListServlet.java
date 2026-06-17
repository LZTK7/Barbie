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
import java.util.List;

public class LookListServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        List<Look> lookList = lookDao.findByUserId(user.getId());
        req.setAttribute("lookList", lookList);
        req.getRequestDispatcher("/pages/look/lookList.jsp").forward(req, resp);
    }
}