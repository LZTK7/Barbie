package com.barbie.dao;

import com.barbie.model.Product;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    // ===== 前台搜索 =====
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

    // ===== 根据ID查询 =====
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

    // ===== 热销商品 =====
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

    // ===== 按品类查询 =====
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

    // ===== 查询所有商品（后台用） =====
    public List<Product> findAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
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

    // ===== 添加商品 =====
    public boolean add(Product p) {
        String sql = "INSERT INTO products (name, images, category, style, color, season, price, description, sales, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getImages());
            ps.setString(3, p.getCategory());
            ps.setString(4, p.getStyle());
            ps.setString(5, p.getColor());
            ps.setString(6, p.getSeason());
            ps.setDouble(7, p.getPrice());
            ps.setString(8, p.getDescription());
            ps.setInt(9, p.getSales());
            ps.setInt(10, p.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    // ===== 更新商品 =====
    public boolean update(Product p) {
        String sql = "UPDATE products SET name=?, images=?, category=?, style=?, color=?, season=?, price=?, description=?, sales=?, status=? WHERE id=?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getImages());
            ps.setString(3, p.getCategory());
            ps.setString(4, p.getStyle());
            ps.setString(5, p.getColor());
            ps.setString(6, p.getSeason());
            ps.setDouble(7, p.getPrice());
            ps.setString(8, p.getDescription());
            ps.setInt(9, p.getSales());
            ps.setInt(10, p.getStatus());
            ps.setInt(11, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    // ===== 删除商品 =====
    public boolean delete(int id) {
        String sql = "DELETE FROM products WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }
}