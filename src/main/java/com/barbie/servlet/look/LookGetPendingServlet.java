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
import java.util.ArrayList;
import java.util.List;

public class LookGetPendingServlet extends HttpServlet {

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

        String idsParam = req.getParameter("ids");
        if (idsParam == null || idsParam.trim().isEmpty()) {
            out.write("[]");
            return;
        }

        String[] idArray = idsParam.split(",");
        List<Product> products = new ArrayList<>();
        for (String idStr : idArray) {
            try {
                Product p = productDao.findById(Integer.parseInt(idStr.trim()));
                if (p != null) {
                    products.add(p);
                }
            } catch (NumberFormatException e) {
                // 忽略无效ID
            }
        }

        new Gson().toJson(products, out);
    }
}