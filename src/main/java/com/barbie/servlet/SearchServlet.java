package com.barbie.servlet;

import com.barbie.dao.ProductDao;
import com.barbie.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class SearchServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String color = req.getParameter("color");
        String style = req.getParameter("style");
        String sort = req.getParameter("sort");

        if (keyword == null) keyword = "";
        if (color == null || color.isEmpty()) color = "";
        if (style == null || style.isEmpty()) style = "";
        if (sort == null || sort.isEmpty()) sort = "default";

        List<Product> products = productDao.searchWithFilter(keyword, color, style, sort);

        req.setAttribute("products", products);
        req.setAttribute("keyword", keyword);
        req.setAttribute("color", color);
        req.setAttribute("style", style);
        req.setAttribute("sort", sort);
        req.getRequestDispatcher("/pages/search.jsp").forward(req, resp);
    }
}