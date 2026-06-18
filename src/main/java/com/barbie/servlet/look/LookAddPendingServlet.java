package com.barbie.servlet.look;

import com.barbie.dao.LookDao;
import com.barbie.dao.ProductDao;
import com.barbie.model.Look;
import com.barbie.model.Product;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class LookAddPendingServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();
    private ProductDao productDao = new ProductDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("请先登录");
            return;
        }

        int lookId = Integer.parseInt(req.getParameter("lookId"));
        int productId = Integer.parseInt(req.getParameter("productId"));

        Look look = lookDao.findById(lookId, user.getId());
        if (look == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("搭配不存在");
            return;
        }

        Product product = productDao.findById(productId);
        if (product == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write("商品不存在");
            return;
        }

        String pendingIds = look.getPendingIds();
        if (pendingIds == null || pendingIds.isEmpty()) {
            pendingIds = String.valueOf(productId);
        } else {
            String[] ids = pendingIds.split(",");
            for (String id : ids) {
                if (id.equals(String.valueOf(productId))) {
                    resp.getWriter().write("已添加");
                    return;
                }
            }
            pendingIds += "," + productId;
        }

        look.setPendingIds(pendingIds);
        boolean success = lookDao.update(look);

        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("pendingIds", pendingIds);

        resp.setContentType("application/json;charset=utf-8");
        new Gson().toJson(result, resp.getWriter());
    }
}