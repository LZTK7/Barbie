package com.barbie.test;

import com.barbie.util.DBUtil;
import java.sql.Connection;

public class TestDB {
    public static void main(String[] args) {
        try {
            Connection conn = DBUtil.getConnection();
            System.out.println("数据库连接成功！");
            System.out.println("数据库版本：" + conn.getMetaData().getDatabaseProductVersion());
            conn.close();
        } catch (Exception e) {
            System.out.println("连接失败：" + e.getMessage());
            e.printStackTrace();
        }
    }
}