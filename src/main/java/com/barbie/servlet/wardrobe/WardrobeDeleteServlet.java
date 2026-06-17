package com.barbie.servlet.wardrobe;

import com.barbie.dao.WardrobeDao;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class WardrobeDeleteServlet extends HttpServlet {

    private WardrobeDao wardrobeDao = new WardrobeDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("请先登录");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("缺少参数");
            return;
        }

        int id = Integer.parseInt(idParam);
        boolean success = wardrobeDao.deleteById(id, user.getId());

        if (success) {
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write("success");
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("删除失败");
        }
    }
}