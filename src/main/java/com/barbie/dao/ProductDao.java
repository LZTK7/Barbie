package com.barbie.dao;

import com.barbie.model.Product;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    /**
     * 搜索商品
     */
    public List<Product> search(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE name LIKE ? AND status = 1 ORDER BY sales DESC LIMIT 20";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImages(rs.getString("images"));
                p.setCategory(rs.getString("category"));
                p.setStyle(rs.getString("style"));
                p.setColor(rs.getString("color"));
                p.setSeason(rs.getString("season"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setSales(rs.getInt("sales"));
                p.setStatus(rs.getInt("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 根据ID查询商品
     */
    public Product findById(int id) {
        String sql = "SELECT * FROM products WHERE id = ? AND status = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImages(rs.getString("images"));
                p.setCategory(rs.getString("category"));
                p.setStyle(rs.getString("style"));
                p.setColor(rs.getString("color"));
                p.setSeason(rs.getString("season"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setSales(rs.getInt("sales"));
                p.setStatus(rs.getInt("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    /**
     * 获取热销商品
     */
    public List<Product> getHotProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE status = 1 ORDER BY sales DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImages(rs.getString("images"));
                p.setCategory(rs.getString("category"));
                p.setStyle(rs.getString("style"));
                p.setColor(rs.getString("color"));
                p.setSeason(rs.getString("season"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setSales(rs.getInt("sales"));
                p.setStatus(rs.getInt("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 根据品类查询商品
     */
    public List<Product> findByCategory(String category, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category = ? AND status = 1 ORDER BY sales DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, category);
            ps.setInt(2, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setImages(rs.getString("images"));
                p.setCategory(rs.getString("category"));
                p.setStyle(rs.getString("style"));
                p.setColor(rs.getString("color"));
                p.setSeason(rs.getString("season"));
                p.setPrice(rs.getDouble("price"));
                p.setDescription(rs.getString("description"));
                p.setSales(rs.getInt("sales"));
                p.setStatus(rs.getInt("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }
}