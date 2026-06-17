package com.barbie.servlet.wardrobe;

import com.barbie.dao.WardrobeDao;
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
public class WardrobeImportServlet extends HttpServlet {

    private WardrobeDao wardrobeDao = new WardrobeDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/pages/user/login.jsp");
            return;
        }

        // 获取表单数据
        String name = req.getParameter("name");
        String category = req.getParameter("category");
        String color = req.getParameter("color");
        String season = req.getParameter("season");
        String style = req.getParameter("style");
        String brand = req.getParameter("brand");
        String note = req.getParameter("note");

        // 处理图片上传
        Part filePart = req.getPart("image");
        String imagePath = FileUploadUtil.saveFile(filePart, req.getServletContext().getRealPath("/"));

        // 保存到数据库
        wardrobeDao.addManual(
                user.getId(),
                name,
                imagePath,
                category,
                color,
                season,
                style,
                brand,
                note
        );

        resp.sendRedirect(req.getContextPath() + "/wardrobe/list");
    }
}