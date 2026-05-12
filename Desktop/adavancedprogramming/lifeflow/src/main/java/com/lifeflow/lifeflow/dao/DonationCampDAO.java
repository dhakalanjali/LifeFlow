package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.DonationCamp;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DonationCampDAO.java
 * Handles all database operations for donation camps.
 */
public class DonationCampDAO {

    /**
     * Returns all donation camps from the database.
     */
    public List<DonationCamp> getAllCamps() {
        List<DonationCamp> camps = new ArrayList<>();
        String sql = "SELECT * FROM donation_camps ORDER BY camp_date ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                camps.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return camps;
    }

    /**
     * Inserts a new donation camp into the database.
     */
    public boolean addCamp(DonationCamp camp) {
        String sql = "INSERT INTO donation_camps (camp_name, location, camp_date, organizer) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, camp.getName());
            ps.setString(2, camp.getLocation());
            ps.setDate(3, Date.valueOf(camp.getDate()));
            ps.setString(4, camp.getOrganizer());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates an existing donation camp.
     */
    public boolean updateCamp(DonationCamp camp) {
        String sql = "UPDATE donation_camps SET camp_name=?, location=?, camp_date=?, organizer=? WHERE camp_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, camp.getName());
            ps.setString(2, camp.getLocation());
            ps.setDate(3, Date.valueOf(camp.getDate()));
            ps.setString(4, camp.getOrganizer());
            ps.setInt(5, camp.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a donation camp by ID.
     */
    public boolean deleteCamp(int campId) {
        String sql = "DELETE FROM donation_camps WHERE camp_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, campId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Maps a ResultSet row to a DonationCamp object.
     */
    private DonationCamp mapRow(ResultSet rs) throws SQLException {
        DonationCamp camp = new DonationCamp();
        camp.setId(rs.getInt("camp_id"));
        camp.setName(rs.getString("camp_name"));
        camp.setLocation(rs.getString("location"));
        Date sqlDate = rs.getDate("camp_date");
        if (sqlDate != null) camp.setDate(sqlDate.toLocalDate());
        camp.setOrganizer(rs.getString("organizer"));
        return camp;
    }
}
