package com.barbie.util;

import com.barbie.model.User;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    private static final String USER_KEY = "loginUser";

    /**
     * 保存登录用户到 Session
     */
    public static void setLoginUser(HttpSession session, User user) {
        session.setAttribute(USER_KEY, user);
    }

    /**
     * 从 Session 获取登录用户
     */
    public static User getLoginUser(HttpSession session) {
        return (User) session.getAttribute(USER_KEY);
    }

    /**
     * 判断是否已登录
     */
    public static boolean isLogin(HttpSession session) {
        return getLoginUser(session) != null;
    }

    /**
     * 退出登录
     */
    public static void logout(HttpSession session) {
        session.removeAttribute(USER_KEY);
        session.invalidate();
    }
}