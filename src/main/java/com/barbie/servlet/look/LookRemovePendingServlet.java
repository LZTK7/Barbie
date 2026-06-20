package com.barbie.servlet.look;

import com.barbie.dao.LookDao;
import com.barbie.model.Look;
import com.barbie.model.User;
import com.barbie.util.SessionUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class LookRemovePendingServlet extends HttpServlet {

    private LookDao lookDao = new LookDao();

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

        int lookId = Integer.parseInt(req.getParameter("lookId"));
        int productId = Integer.parseInt(req.getParameter("productId"));

        Look look = lookDao.findById(lookId, user.getId());
        if (look == null) {
            resp.getWriter().write("{\"success\":false,\"msg\":\"搭配不存在\"}");
            return;
        }

        String pendingIds = look.getPendingIds();
        if (pendingIds == null || pendingIds.isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"msg\":\"empty\"}");
            return;
        }

        List<String> list = new ArrayList<>(Arrays.asList(pendingIds.split(",")));
        list.remove(String.valueOf(productId));
        look.setPendingIds(String.join(",", list));
        boolean success = lookDao.update(look);

        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("pendingIds", look.getPendingIds());

        new Gson().toJson(result, resp.getWriter());
    }
}