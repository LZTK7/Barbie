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

        // 获取用户所有搭配中的商品ID
        com.barbie.dao.LookDao lookDao = new com.barbie.dao.LookDao();
        List<com.barbie.model.Look> allLooks = lookDao.findByUserId(user.getId());

        List<Integer> excludedProductIds = new ArrayList<>();
        for (com.barbie.model.Look look : allLooks) {
            // 待购买（已加购未结算）
            String cartIds = look.getCartIds();
            if (cartIds != null && !cartIds.isEmpty()) {
                for (String id : cartIds.split(",")) {
                    try {
                        excludedProductIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {}
                }
            }
            // 待收货（已结算未确认）
            String shippedIds = look.getShippedIds();
            if (shippedIds != null && !shippedIds.isEmpty()) {
                for (String id : shippedIds.split(",")) {
                    try {
                        excludedProductIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {}
                }
            }
            // 已拥有（wardrobe_ids）
            String wardrobeIds = look.getWardrobeIds();
            if (wardrobeIds != null && !wardrobeIds.isEmpty()) {
                for (String id : wardrobeIds.split(",")) {
                    try {
                        excludedProductIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {}
                }
            }
        }

        // 搜索商品
        List<Product> products = productDao.searchWithFilter(keyword, "", "", "default");

        // 过滤掉已排除的商品
        List<Product> filteredProducts = new ArrayList<>();
        for (Product p : products) {
            if (!excludedProductIds.contains(p.getId())) {
                filteredProducts.add(p);
            }
        }

        // 修复图片路径
        for (Product p : filteredProducts) {
            String img = p.getImages();
            if (img != null && !img.isEmpty() && !img.startsWith("uploads/") && !img.startsWith("http")) {
                p.setImages("uploads/" + img);
            }
        }

        new Gson().toJson(filteredProducts, out);
    }
}