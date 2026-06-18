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

        // 默认推荐品类
        String recommendCategory = null;
        List<Product> recommendProducts = new ArrayList<>();

        if (user != null) {
            // 获取衣橱品类统计
            Map<String, Integer> categoryCount = wardrobeDao.countByCategory(user.getId());

            // 所有品类列表
            String[] allCategories = {"上装", "下装", "外套", "鞋", "连衣裙", "包", "配饰"};

            // 找出数量最少的品类（缺什么推荐什么）
            String minCategory = null;
            int minCount = Integer.MAX_VALUE;

            for (String cat : allCategories) {
                int count = categoryCount.getOrDefault(cat, 0);
                if (count < minCount) {
                    minCount = count;
                    minCategory = cat;
                }
            }

            // 如果所有品类都 > 3件，推荐热销
            if (minCount >= 3) {
                recommendCategory = "热销新品";
                recommendProducts = productDao.getHotProducts(8);
            } else if (minCategory != null) {
                recommendCategory = minCategory;
                recommendProducts = productDao.findByCategory(minCategory, 8);
            }
        }

        // 未登录或衣橱为空时，推荐热销
        if (recommendProducts.isEmpty()) {
            recommendCategory = "热销新品";
            recommendProducts = productDao.getHotProducts(8);
        }

        req.setAttribute("recommendCategory", recommendCategory);
        req.setAttribute("recommendProducts", recommendProducts);
        req.getRequestDispatcher("/pages/index.jsp").forward(req, resp);
    }
}