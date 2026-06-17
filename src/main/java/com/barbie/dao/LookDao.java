package com.barbie.dao;

import com.barbie.model.Look;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LookDao {

    public boolean create(Look look) {
        String sql = "INSERT INTO looks (user_id, name, wardrobe_ids, scene, season) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, look.getUserId());
            ps.setString(2, look.getName());
            ps.setString(3, look.getWardrobeIds());
            ps.setString(4, look.getScene());
            ps.setString(5, look.getSeason());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    look.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps);
        }
        return false;
    }

    public List<Look> findByUserId(int userId) {
        List<Look> list = new ArrayList<>();
        String sql = "SELECT * FROM looks WHERE user_id = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Look look = new Look();
                look.setId(rs.getInt("id"));
                look.setUserId(rs.getInt("user_id"));
                look.setName(rs.getString("name"));
                look.setWardrobeIds(rs.getString("wardrobe_ids"));
                look.setScene(rs.getString("scene"));
                look.setSeason(rs.getString("season"));
                look.setWearDate(rs.getDate("wear_date"));
                look.setIsFavorite(rs.getInt("is_favorite"));
                look.setCreatedAt(rs.getTimestamp("created_at"));
                look.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(look);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    public Look findById(int id, int userId) {
        String sql = "SELECT * FROM looks WHERE id = ? AND user_id = ?";
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
                Look look = new Look();
                look.setId(rs.getInt("id"));
                look.setUserId(rs.getInt("user_id"));
                look.setName(rs.getString("name"));
                look.setWardrobeIds(rs.getString("wardrobe_ids"));
                look.setScene(rs.getString("scene"));
                look.setSeason(rs.getString("season"));
                look.setWearDate(rs.getDate("wear_date"));
                look.setIsFavorite(rs.getInt("is_favorite"));
                look.setCreatedAt(rs.getTimestamp("created_at"));
                look.setUpdatedAt(rs.getTimestamp("updated_at"));
                return look;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }

    public boolean deleteById(int id, int userId) {
        String sql = "DELETE FROM looks WHERE id = ? AND user_id = ?";
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
}