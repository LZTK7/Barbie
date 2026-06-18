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
public class AdminProductEditServlet extends HttpServlet {

    private ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        Product product = productDao.findById(id);
        req.setAttribute("product", product);
        req.getRequestDispatcher("/pages/admin/adminProductEdit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null || !"admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String style = req.getParameter("style");
        String color = req.getParameter("color");
        String season = req.getParameter("season");
        double price = Double.parseDouble(req.getParameter("price"));
        String description = req.getParameter("description");
        int sales = Integer.parseInt(req.getParameter("sales"));
        int status = Integer.parseInt(req.getParameter("status"));

        Product p = new Product();
        p.setId(id);
        p.setName(name);
        p.setCategory(category);
        p.setStyle(style);
        p.setColor(color);
        p.setSeason(season);
        p.setPrice(price);
        p.setDescription(description);
        p.setSales(sales);
        p.setStatus(status);

        // 图片上传（如果有新图片）
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String imagePath = FileUploadUtil.saveFile(filePart, req.getServletContext().getRealPath("/"));
            p.setImages(imagePath);
        } else {
            // 保留原图片
            Product old = productDao.findById(id);
            p.setImages(old.getImages());
        }

        boolean success = productDao.update(p);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/list");
        } else {
            req.setAttribute("error", "修改失败");
            req.getRequestDispatcher("/pages/admin/adminProductEdit.jsp").forward(req, resp);
        }
    }
}