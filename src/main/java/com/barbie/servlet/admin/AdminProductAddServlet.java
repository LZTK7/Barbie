package com.barbie.servlet.admin;

import com.barbie.dao.ProductDao;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.FileUploadUtil;
import com.barbie.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;

@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class AdminProductAddServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        req.getRequestDispatcher("/pages/admin/adminProductAdd.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String style = req.getParameter("style");
        String color = req.getParameter("color");
        String season = req.getParameter("season");
        double price = Double.parseDouble(req.getParameter("price"));
        String description = req.getParameter("description");
        int sales = Integer.parseInt(req.getParameter("sales"));
        int status = Integer.parseInt(req.getParameter("status"));

        // 图片上传
        Part filePart = req.getPart("image");
        String imagePath = FileUploadUtil.saveFile(filePart, req.getServletContext().getRealPath("/"));

        Product p = new Product();
        p.setName(name);
        p.setImages(imagePath != null ? imagePath : "");
        p.setCategory(category);
        p.setStyle(style);
        p.setColor(color);
        p.setSeason(season);
        p.setPrice(price);
        p.setDescription(description);
        p.setSales(sales);
        p.setStatus(status);

        boolean success = productDao.add(p);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } else {
            req.setAttribute("error", "添加失败");
            req.getRequestDispatcher("/pages/admin/adminProductAdd.jsp").forward(req, resp);
        }
    }
}