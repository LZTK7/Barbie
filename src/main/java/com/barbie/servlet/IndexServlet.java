package com.barbie.servlet;

import com.barbie.dao.ProductDao;
import com.barbie.dao.WardrobeDao;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class IndexServlet extends HttpServlet {

    private WardrobeDao wardrobeDao = new WardrobeDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());

        // 衣橱补全推荐（传给右侧）
        String recommendCategory = null;
        List<Product> recommendProducts = new ArrayList<>();

        if (user != null) {
            Map<String, Integer> categoryCount = wardrobeDao.countByCategory(user.getId());
            String[] allCategories = {"上装", "下装", "外套", "鞋", "连衣裙", "包", "配饰"};
            String minCategory = null;
            int minCount = Integer.MAX_VALUE;

            for (String cat : allCategories) {
                int count = categoryCount.getOrDefault(cat, 0);
                if (count < minCount) {
                    minCount = count;
                    minCategory = cat;
                }
            }

            if (minCount >= 3) {
                recommendCategory = "热销新品";
                recommendProducts = productDao.getHotProducts(3);
            } else if (minCategory != null) {
                recommendCategory = minCategory;
                recommendProducts = productDao.findByCategory(minCategory, 3);
            }
        }

        if (recommendProducts.isEmpty()) {
            recommendCategory = "热销新品";
            recommendProducts = productDao.getHotProducts(3);
        }

        req.setAttribute("recommendCategory", recommendCategory);
        req.setAttribute("recommendProducts", recommendProducts);

        // 商品列表数据由 JSP 直接通过 ProductDao 查询，IndexServlet 只负责推荐
        req.getRequestDispatcher("/pages/index.jsp").forward(req, resp);
    }
}