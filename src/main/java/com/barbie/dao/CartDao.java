package com.barbie.dao;

import com.barbie.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CartDao {

    public boolean addToCart(int userId, int productId, String sku, int quantity) {
        String checkSql = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ? AND sku = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(checkSql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, sku);
            rs = ps.executeQuery();
            if (rs.next()) {
                int newQuantity = rs.getInt("quantity") + quantity;
                String updateSql = "UPDATE cart SET quantity = ? WHERE id = ?";
                PreparedStatement ps2 = conn.prepareStatement(updateSql);
                ps2.setInt(1, newQuantity);
                ps2.setInt(2, rs.getInt("id"));
                int affected = ps2.executeUpdate();
                ps2.close();
                return affected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }

        String sql = "INSERT INTO cart (user_id, product_id, sku, quantity) VALUES (?, ?, ?, ?)";
        conn = null;
        ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setString(3, sku);
            ps.setInt(4, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }
}