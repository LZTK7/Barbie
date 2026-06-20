package com.barbie.dao;

import com.barbie.model.Wardrobe;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class WardrobeDao {

    /**
     * 从订单添加衣物到衣橱，返回插入的衣橱ID
     */
    public int addFromOrder(int userId, int orderItemId, String name, String image, String category, String color, String season) {
        String sql = "INSERT INTO wardrobe (user_id, source_type, order_item_id, name, images, category, color, season) VALUES (?, 'order', ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setInt(2, orderItemId);
            ps.setString(3, name);
            ps.setString(4, image);
            ps.setString(5, category);
            ps.setString(6, color);
            ps.setString(7, season);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return -1;
    }

    /**
     * 手动导入衣服
     */
    public void addManual(int userId, String name, String imagePath, String category,
                          String color, String season, String style, String brand, String note) {
        String sql = "INSERT INTO wardrobe (user_id, source_type, name, images, category, color, season, style, brand, note) "
                + "VALUES (?, 'manual', ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.setString(3, imagePath);
            ps.setString(4, category);
            ps.setString(5, color);
            ps.setString(6, season);
            ps.setString(7, style);
            ps.setString(8, brand);
            ps.setString(9, note);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 查询用户的衣橱列表
     */
    public List<Wardrobe> findByUserId(int userId) {
        List<Wardrobe> list = new ArrayList<>();
        String sql = "SELECT * FROM wardrobe WHERE user_id = ? AND deleted_at IS NULL ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Wardrobe w = new Wardrobe();
                w.setId(rs.getInt("id"));
                w.setUserId(rs.getInt("user_id"));
                w.setSourceType(rs.getString("source_type"));
                w.setOrderItemId(rs.getInt("order_item_id"));
                if (rs.wasNull()) {
                    w.setOrderItemId(null);
                }
                w.setName(rs.getString("name"));
                w.setImages(rs.getString("images"));
                w.setCategory(rs.getString("category"));
                w.setColor(rs.getString("color"));
                w.setSeason(rs.getString("season"));
                w.setStyle(rs.getString("style"));
                w.setBrand(rs.getString("brand"));
                w.setNote(rs.getString("note"));
                w.setWearCount(rs.getInt("wear_count"));
                w.setIsFrequent(rs.getInt("is_frequent"));
                w.setCreatedAt(rs.getTimestamp("created_at"));
                w.setUpdatedAt(rs.getTimestamp("updated_at"));
                w.setDeletedAt(rs.getTimestamp("deleted_at"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 根据ID查询单件衣物
     */
    public Wardrobe findById(int id, int userId) {
        String sql = "SELECT * FROM wardrobe WHERE id = ? AND user_id = ? AND deleted_at IS NULL";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.setInt(2, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                Wardrobe w = new Wardrobe();
                w.setId(rs.getInt("id"));
                w.setUserId(rs.getInt("user_id"));
                w.setSourceType(rs.getString("source_type"));
                w.setOrderItemId(rs.getInt("order_item_id"));
                if (rs.wasNull()) {
                    w.setOrderItemId(null);
                }
                w.setName(rs.getString("name"));
                w.setImages(rs.getString("images"));
                w.setCategory(rs.getString("category"));
                w.setColor(rs.getString("color"));
                w.setSeason(rs.getString("season"));
                w.setStyle(rs.getString("style"));
                w.setBrand(rs.getString("brand"));
                w.setNote(rs.getString("note"));
                w.setWearCount(rs.getInt("wear_count"));
                w.setIsFrequent(rs.getInt("is_frequent"));
                w.setCreatedAt(rs.getTimestamp("created_at"));
                w.setUpdatedAt(rs.getTimestamp("updated_at"));
                w.setDeletedAt(rs.getTimestamp("deleted_at"));
                return w;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * 删除衣物（软删除）
     */
    public boolean deleteById(int id, int userId) {
        String sql = "UPDATE wardrobe SET deleted_at = NOW() WHERE id = ? AND user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
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
     * 统计用户衣橱各品类的数量
     */
    public Map<String, Integer> countByCategory(int userId) {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT category, COUNT(*) as count FROM wardrobe WHERE user_id = ? AND deleted_at IS NULL GROUP BY category";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return map;
    }
}