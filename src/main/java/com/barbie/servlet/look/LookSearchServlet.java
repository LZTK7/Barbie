package com.barbie.servlet.look;

import com.barbie.dao.ProductDao;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class LookSearchServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=utf-8");
        PrintWriter out = resp.getWriter();

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("[]");
            return;
        }

        String keyword = req.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            out.write("[]");
            return;
        }

        List<Product> products = productDao.search(keyword);

        // 修复图片路径
        for (Product p : products) {
            String img = p.getImages();
            if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
                p.setImages("uploads/" + img);
            }
        }

        new Gson().toJson(products, out);
    }
}