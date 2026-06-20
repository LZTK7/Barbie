package com.barbie.dao;

import com.barbie.model.CartItem;
import com.barbie.model.Product;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDao {

    /**
     * 添加商品到购物车（如果已存在则增加数量）
     */
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

    /**
     * 获取用户购物车列表
     */
    public List<CartItem> findByUserId(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.*, p.name as product_name, p.images as product_images, p.price as product_price, p.category as product_category " +
                "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ? ORDER BY c.created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setSku(rs.getString("sku"));
                item.setQuantity(rs.getInt("quantity"));
                item.setCreatedAt(rs.getTimestamp("created_at"));

                Product p = new Product();
                p.setId(rs.getInt("product_id"));
                p.setName(rs.getString("product_name"));
                p.setImages(rs.getString("product_images"));
                p.setPrice(rs.getDouble("product_price"));
                p.setCategory(rs.getString("product_category"));
                item.setProduct(p);

                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 更新购物车商品数量
     */
    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 删除购物车商品
     */
    public boolean deleteById(int cartId, int userId) {
        String sql = "DELETE FROM cart WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, cartId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 清空用户购物车
     */
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

    /**
     * 根据购物车ID列表批量删除商品（只删除指定ID）
     */
    public boolean deleteByIds(int userId, List<Integer> cartIds) {
        if (cartIds == null || cartIds.isEmpty()) return true;
        StringBuilder sql = new StringBuilder("DELETE FROM cart WHERE user_id = ? AND id IN (");
        for (int i = 0; i < cartIds.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
        }
        sql.append(")");
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, userId);
            for (int i = 0; i < cartIds.size(); i++) {
                ps.setInt(i + 2, cartIds.get(i));
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }
}