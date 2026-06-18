package com.barbie.servlet.look;

import com.barbie.dao.ProductDao;
import com.barbie.model.Product;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class LookSearchServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (SessionUtil.getLoginUser(req.getSession()) == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("请先登录");
            return;
        }

        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            resp.getWriter().write("[]");
            return;
        }

        List<Product> products = productDao.search(keyword);
        resp.setContentType("application/json;charset=utf-8");
        new Gson().toJson(products, resp.getWriter());
    }
}