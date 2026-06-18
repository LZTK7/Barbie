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

        // 检查登录
        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        // 获取参数
        String name = req.getParameter("name");
        String wardrobeIdsStr = req.getParameter("wardrobeIds");
        String scene = req.getParameter("scene");
        String season = req.getParameter("season");

        // 调试输出
        System.out.println("========== 创建搭配开始 ==========");
        System.out.println("用户ID: " + user.getId());
        System.out.println("搭配名称: " + name);
        System.out.println("wardrobeIds原始字符串: " + wardrobeIdsStr);
        System.out.println("场景: " + scene);
        System.out.println("季节: " + season);

        // 校验
        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "请输入搭配名称");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        if (wardrobeIdsStr == null || wardrobeIdsStr.trim().isEmpty()) {
            req.setAttribute("error", "请选择衣服");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        // 拆分字符串为数组
        String[] wardrobeIds = wardrobeIdsStr.split(",");
        System.out.println("拆分后数组长度: " + wardrobeIds.length);

        if (wardrobeIds.length < 2) {
            req.setAttribute("error", "请至少选择2件衣服");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
            return;
        }

        // 创建 Look 对象
        Look look = new Look();
        look.setUserId(user.getId());
        look.setName(name);
        look.setWardrobeIds(wardrobeIdsStr);
        look.setScene(scene);
        look.setSeason(season);

        // 保存到数据库
        boolean success = lookDao.create(look);
        System.out.println("保存结果: " + success);
        System.out.println("========== 创建搭配结束 ==========");

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/look/list");
        } else {
            req.setAttribute("error", "创建搭配失败，请检查数据库连接");
            req.getRequestDispatcher("/pages/look/lookCreate.jsp").forward(req, resp);
        }
    }
}