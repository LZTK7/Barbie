package com.barbie.dao;

import com.barbie.model.Order;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    /**
     * 创建订单，返回订单ID
     */
    public int create(Order order) {
        String sql = "INSERT INTO orders (user_id, order_no, total_amount, status, address, receiver, phone, remark) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getOrderNo());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getStatus());
            ps.setString(5, order.getAddress());
            ps.setString(6, order.getReceiver());
            ps.setString(7, order.getPhone());
            ps.setString(8, order.getRemark());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return 0;
    }

    /**
     * 删除订单（先删除订单商品，再删除订单）
     */
    public boolean deleteById(int orderId) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = true;

        try {
            conn = DBUtil.getConnection();

            // 先删除订单商品
            String deleteItemsSql = "DELETE FROM order_items WHERE order_id = ?";
            ps = conn.prepareStatement(deleteItemsSql);
            ps.setInt(1, orderId);
            ps.executeUpdate();
            ps.close();

            // 再删除订单
            String deleteOrderSql = "DELETE FROM orders WHERE id = ?";
            ps = conn.prepareStatement(deleteOrderSql);
            ps.setInt(1, orderId);
            success = ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            success = false;
        } finally {
            DBUtil.close(conn, ps);
        }
        return success;
    }

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