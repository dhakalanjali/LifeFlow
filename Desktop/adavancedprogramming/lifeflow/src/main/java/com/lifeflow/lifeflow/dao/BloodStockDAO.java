package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.BloodStock;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BloodStockDAO {

    public List<BloodStock> getAllBloodStock() {
        List<BloodStock> list = new ArrayList<>();
        String sql = "SELECT * FROM blood_stock";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BloodStock bs = new BloodStock();
                bs.setStockId(rs.getInt("stock_id"));
                bs.setBloodGroup(rs.getString("blood_type"));
                bs.setUnitsAvailable(rs.getInt("units_available"));
                list.add(bs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public BloodStock getStockByBloodGroup(String bloodType) {
        BloodStock bs = null;
        String sql = "SELECT * FROM blood_stock WHERE blood_type = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, bloodType);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                bs = new BloodStock();
                bs.setStockId(rs.getInt("stock_id"));
                bs.setBloodGroup(rs.getString("blood_type"));
                bs.setUnitsAvailable(rs.getInt("units_available"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return bs;
    }

    public boolean updateUnits(String bloodType, int units) {
        String sql = "UPDATE blood_stock SET units_available = ? WHERE blood_type = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, units);
            ps.setString(2, bloodType);
            int rows = ps.executeUpdate();
            conn.commit();
            return rows > 0;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
}