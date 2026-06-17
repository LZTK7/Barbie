package com.barbie.dao;

import com.barbie.model.Order;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    /**
     * 根据用户ID和状态查询订单列表
     */
    public List<Order> findByUserIdAndStatus(int userId, String status) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ?";
        if (status != null && !"all".equals(status)) {
            sql += " AND status = ?";
        }
        sql += " ORDER BY created_at DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            if (status != null && !"all".equals(status)) {
                ps.setString(2, status);
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNo(rs.getString("order_no"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setAddress(rs.getString("address"));
                order.setReceiver(rs.getString("receiver"));
                order.setPhone(rs.getString("phone"));
                order.setRemark(rs.getString("remark"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }

    /**
     * 更新订单状态（确认收货用）
     */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 根据ID查询订单
     */
    public Order findById(int id) {
        String sql = "SELECT * FROM orders WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderNo(rs.getString("order_no"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setAddress(rs.getString("address"));
                order.setReceiver(rs.getString("receiver"));
                order.setPhone(rs.getString("phone"));
                order.setRemark(rs.getString("remark"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return null;
    }
}