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

        resp.setContentType("application/json;charset=utf-8");

        User user = SessionUtil.getLoginUser(req.getSession());
        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"success\":false,\"msg\":\"请先登录\"}");
            return;
        }

        String lookIdParam = req.getParameter("lookId");
        String productIdParam = req.getParameter("productId");

        System.out.println("========== LookAddPendingServlet ==========");
        System.out.println("lookIdParam: " + lookIdParam);
        System.out.println("productIdParam: " + productIdParam);

        if (lookIdParam == null || productIdParam == null) {
            resp.getWriter().write("{\"success\":false,\"msg\":\"参数缺失\"}");
            return;
        }

        int lookId = Integer.parseInt(lookIdParam);
        int productId = Integer.parseInt(productIdParam);

        Look look = lookDao.findById(lookId, user.getId());
        if (look == null) {
            resp.getWriter().write("{\"success\":false,\"msg\":\"搭配不存在\"}");
            return;
        }

        Product product = productDao.findById(productId);
        if (product == null) {
            resp.getWriter().write("{\"success\":false,\"msg\":\"商品不存在\"}");
            return;
        }

        String pendingIds = look.getPendingIds();
        if (pendingIds == null || pendingIds.isEmpty()) {
            pendingIds = String.valueOf(productId);
        } else {
            String[] ids = pendingIds.split(",");
            for (String id : ids) {
                if (id.equals(String.valueOf(productId))) {
                    resp.getWriter().write("{\"success\":false,\"msg\":\"已添加\"}");
                    return;
                }
            }
            pendingIds += "," + productId;
        }

        look.setPendingIds(pendingIds);
        boolean success = lookDao.update(look);

        System.out.println("更新后的pendingIds: " + pendingIds);
        System.out.println("保存结果: " + success);

        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("pendingIds", pendingIds);

        new Gson().toJson(result, resp.getWriter());
    }
}