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
import java.util.Arrays;
import java.util.List;

public class LookEditServlet extends HttpServlet {

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

        // 获取当前搭配选中的衣服ID列表
        String[] ids = look.getWardrobeIds().split(",");
        List<String> selectedIds = Arrays.asList(ids);

        // 获取用户所有衣橱衣服
        List<Wardrobe> wardrobeList = wardrobeDao.findByUserId(user.getId());

        req.setAttribute("look", look);
        req.setAttribute("selectedIds", selectedIds);
        req.setAttribute("wardrobeList", wardrobeList);
        req.getRequestDispatcher("/pages/look/lookEdit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String wardrobeIdsStr = req.getParameter("wardrobeIds");
        String scene = req.getParameter("scene");
        String season = req.getParameter("season");

        System.out.println("========== 修改搭配开始 ==========");
        System.out.println("搭配ID: " + id);
        System.out.println("搭配名称: " + name);
        System.out.println("wardrobeIds: " + wardrobeIdsStr);
        System.out.println("场景: " + scene);
        System.out.println("季节: " + season);

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "请输入搭配名称");
            doGet(req, resp);
            return;
        }

        if (wardrobeIdsStr == null || wardrobeIdsStr.trim().isEmpty()) {
            req.setAttribute("error", "请选择衣服");
            doGet(req, resp);
            return;
        }

        String[] wardrobeIds = wardrobeIdsStr.split(",");
        if (wardrobeIds.length < 2) {
            req.setAttribute("error", "请至少选择2件衣服");
            doGet(req, resp);
            return;
        }

        Look look = new Look();
        look.setId(id);
        look.setUserId(user.getId());
        look.setName(name);
        look.setWardrobeIds(wardrobeIdsStr);
        look.setScene(scene);
        look.setSeason(season);

        boolean success = lookDao.update(look);
        System.out.println("修改结果: " + success);
        System.out.println("========== 修改搭配结束 ==========");

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
        } else {
            req.setAttribute("error", "修改搭配失败，请重试");
            doGet(req, resp);
        }
    }
}