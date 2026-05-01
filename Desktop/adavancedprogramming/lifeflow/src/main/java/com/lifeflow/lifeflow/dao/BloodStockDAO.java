package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.BloodStock;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BloodStockDAO {

    // Get all blood stock
    public List<BloodStock> getAllBloodStock() {
        List<BloodStock> list = new ArrayList<>();
        String sql = "SELECT * FROM blood_stock";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BloodStock bs = new BloodStock();
                bs.setStockId(rs.getInt("stock_id"));
                bs.setBloodGroup(rs.getString("blood_group"));
                bs.setUnitsAvailable(rs.getInt("units_available"));
                list.add(bs);
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Get stock by blood group
    public BloodStock getStockByBloodGroup(String bloodGroup) {
        BloodStock bs = null;
        String sql = "SELECT * FROM blood_stock WHERE blood_group = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, bloodGroup);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                bs = new BloodStock();
                bs.setStockId(rs.getInt("stock_id"));
                bs.setBloodGroup(rs.getString("blood_group"));
                bs.setUnitsAvailable(rs.getInt("units_available"));
            }
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bs;
    }

    // Update units
    public boolean updateUnits(String bloodGroup, int units) {
        String sql = "UPDATE blood_stock SET units_available = ? WHERE blood_group = ?";
        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, units);
            ps.setString(2, bloodGroup);
            int rows = ps.executeUpdate();
            conn.close();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}