package com.barbie.dao;

import com.barbie.model.Product;
import com.barbie.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDao {

    // ===== 前台搜索（搭配内使用） =====
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

    // ===== 多条件搜索 + 排序（支持词根提取） =====
    public List<Product> searchWithFilter(String keyword, String color, String style, String sort) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE status = 1");

        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // ===== 关键词处理（匹配 name、category、color、style） =====
        if (keyword != null && !keyword.trim().isEmpty()) {
            String[] words = keyword.trim().split("\\s+");
            for (String word : words) {
                String root = extractRoot(word);
                conditions.add("(name LIKE ? OR category LIKE ? OR color LIKE ? OR style LIKE ?)");
                String like = "%" + root + "%";
                params.add(like);
                params.add(like);
                params.add(like);
                params.add(like);
            }
        }

        // ===== 颜色筛选 =====
        if (color != null && !color.trim().isEmpty()) {
            conditions.add("color = ?");
            params.add(color.trim());
        }

        // ===== 风格筛选 =====
        if (style != null && !style.trim().isEmpty()) {
            conditions.add("style = ?");
            params.add(style.trim());
        }

        // ===== 组装SQL =====
        if (!conditions.isEmpty()) {
            sql.append(" AND ");
            for (int i = 0; i < conditions.size(); i++) {
                if (i > 0) sql.append(" AND ");
                sql.append("(").append(conditions.get(i)).append(")");
            }
        }

        // ===== 排序 =====
        switch (sort) {
            case "price_asc":
                sql.append(" ORDER BY price ASC");
                break;
            case "price_desc":
                sql.append(" ORDER BY price DESC");
                break;
            case "sales":
                sql.append(" ORDER BY sales DESC");
                break;
            default:
                sql.append(" ORDER BY id DESC");
                break;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

    // ===== 提取词根 =====
    private String extractRoot(String word) {
        word = word.trim();
        if (word.isEmpty()) return word;

        // ===== 第一步：直接匹配完整词，返回核心词根 =====
        // 下装类 → 裤
        if (word.contains("短裤") || word.contains("长裤") || word.contains("裤子") || word.contains("牛仔裤") || word.contains("休闲裤")) {
            return "裤";
        }
        // 鞋类 → 鞋
        if (word.contains("运动鞋") || word.contains("高跟鞋") || word.contains("帆布鞋") ||
                word.contains("凉鞋") || word.contains("拖鞋") || word.contains("靴子") ||
                word.contains("鞋子") || word.contains("皮鞋")) {
            return "鞋";
        }
        // 裙类 → 裙
        if (word.contains("连衣裙") || word.contains("半身裙") || word.contains("短裙") ||
                word.contains("长裙") || word.contains("裙子")) {
            return "裙";
        }
        // 上装类
        if (word.contains("T恤") || word.contains("恤")) {
            return "恤";
        }
        if (word.contains("衬衫") || word.contains("衬衣")) {
            return "衬衫";
        }
        if (word.contains("卫衣")) {
            return "卫衣";
        }
        if (word.contains("毛衣") || word.contains("毛衫")) {
            return "毛衣";
        }
        if (word.contains("外套") || word.contains("大衣") || word.contains("风衣")) {
            return "外套";
        }
        if (word.contains("夹克")) {
            return "夹克";
        }
        if (word.contains("西装")) {
            return "西装";
        }
        if (word.contains("背心")) {
            return "背心";
        }
        // 配饰类
        if (word.contains("帽子") || word.contains("帽")) {
            return "帽";
        }
        if (word.contains("包包") || word.contains("包")) {
            return "包";
        }
        if (word.contains("围巾") || word.contains("围")) {
            return "围巾";
        }
        if (word.contains("手套")) {
            return "手套";
        }
        if (word.contains("腰带") || word.contains("腰")) {
            return "腰带";
        }
        if (word.contains("眼镜") || word.contains("眼")) {
            return "眼镜";
        }
        if (word.contains("首饰") || word.contains("饰")) {
            return "首饰";
        }
        if (word.contains("手表") || word.contains("表")) {
            return "表";
        }

        // ===== 第二步：颜色词 → 提取颜色核心字 =====
        if (word.contains("黑色") || word.contains("黑")) {
            return "黑";
        }
        if (word.contains("白色") || word.contains("白")) {
            return "白";
        }
        if (word.contains("红色") || word.contains("红")) {
            return "红";
        }
        if (word.contains("蓝色") || word.contains("蓝")) {
            return "蓝";
        }
        if (word.contains("绿色") || word.contains("绿")) {
            return "绿";
        }
        if (word.contains("黄色") || word.contains("黄")) {
            return "黄";
        }
        if (word.contains("粉色") || word.contains("粉")) {
            return "粉";
        }
        if (word.contains("棕色") || word.contains("棕")) {
            return "棕";
        }
        if (word.contains("灰色") || word.contains("灰")) {
            return "灰";
        }

        // ===== 第三步：风格词 =====
        if (word.contains("通勤")) return "通勤";
        if (word.contains("街头")) return "街头";
        if (word.contains("约会")) return "约会";
        if (word.contains("运动")) return "运动";
        if (word.contains("度假")) return "度假";

        // ===== 第四步：去除无意义后缀（子、色等） =====
        if (word.endsWith("子")) {
            String trimmed = word.substring(0, word.length() - 1);
            if (trimmed.length() >= 1) {
                return trimmed;
            }
        }
        if (word.endsWith("色")) {
            String trimmed = word.substring(0, word.length() - 1);
            if (trimmed.length() >= 1) {
                return trimmed;
            }
        }

        // ===== 默认返回原词 =====
        if (word.length() > 2) {
            return word.substring(0, 2);
        }
        return word;
    }
}