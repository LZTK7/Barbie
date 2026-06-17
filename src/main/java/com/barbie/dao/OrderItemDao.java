package com.barbie.dao;

import com.barbie.model.OrderItem;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDao {

    public List<OrderItem> findByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, orderId);
            rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setProductImage(rs.getString("product_image"));
                item.setSku(rs.getString("sku"));
                item.setPrice(rs.getDouble("price"));
                item.setQuantity(rs.getInt("quantity"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return list;
    }
}