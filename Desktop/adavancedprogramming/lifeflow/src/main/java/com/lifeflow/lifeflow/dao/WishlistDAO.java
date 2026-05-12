package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import java.sql.*;
import java.util.*;

public class WishlistDAO {

    public boolean addToWishlist(int userId, int campId) {
        String sql = "INSERT INTO wishlist (user_id, camp_id) VALUES (?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, campId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean removeFromWishlist(int userId, int campId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND camp_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, campId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<Map<String, String>> getWishlist(int userId) {
        String sql = "SELECT dc.camp_id, dc.camp_name, dc.location, " +
                "dc.camp_date, dc.status " +
                "FROM wishlist w " +
                "JOIN donation_camps dc ON w.camp_id = dc.camp_id " +
                "WHERE w.user_id = ? " +
                "ORDER BY dc.camp_date ASC";
        List<Map<String, String>> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> camp = new HashMap<>();
                camp.put("campId", rs.getString("camp_id"));
                camp.put("campName", rs.getString("camp_name"));
                camp.put("location", rs.getString("location"));
                camp.put("campDate", rs.getString("camp_date"));
                camp.put("status", rs.getString("status"));
                list.add(camp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public boolean isWishlisted(int userId, int campId) {
        String sql = "SELECT * FROM wishlist WHERE user_id = ? AND camp_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, campId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }
}
