package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.DonationRecord;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DonationRecordDAO.java
 * Handles all database operations for the donation_records table.
 *
 * DB Table columns:
 *   record_id (PK, AUTO_INCREMENT)
 *   user_id   (FK → users)
 *   camp_id   (FK → donation_camps, nullable)
 *   blood_type
 *   units_donated
 *   donation_date
 */
public class DonationRecordDAO {

    // ─────────────────────────────────────────────────────
    // INSERT a new donation record
    // ─────────────────────────────────────────────────────
    /**
     * Inserts a new donation record into the database.
     *
     * @param record  DonationRecord object filled from the form
     * @return true if insert was successful, false otherwise
     */
    public boolean insertDonation(DonationRecord record) {
        String sql = "INSERT INTO donation_records (user_id, camp_id, blood_type, units_donated, donation_date) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, record.getDonorId());          // user_id
            if (record.getCampId() > 0) {
                ps.setInt(2, record.getCampId());        // camp_id (optional)
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            ps.setString(3, record.getBloodGroup());    // blood_type
            ps.setInt(4, record.getQuantity());          // units_donated
            ps.setDate(5, Date.valueOf(record.getDonationDate())); // donation_date

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.out.println("insertDonation error: " + e.getMessage());
            return false;
        }
    }

    // ─────────────────────────────────────────────────────
    // GET all donations by a specific user (donation history)
    // ─────────────────────────────────────────────────────
    /**
     * Retrieves all donation records for a given user.
     *
     * @param userId  the logged-in user's ID
     * @return List of DonationRecord objects
     */
    public List<DonationRecord> getDonationsByUserId(int userId) {
        List<DonationRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM donation_records WHERE user_id = ? ORDER BY donation_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("getDonationsByUserId error: " + e.getMessage());
        }
        return list;
    }

    // ─────────────────────────────────────────────────────
    // GET all donations (admin view)
    // ─────────────────────────────────────────────────────
    /**
     * Retrieves all donation records from the database.
     *
     * @return List of all DonationRecord objects
     */
    public List<DonationRecord> getAllDonations() {
        List<DonationRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM donation_records ORDER BY donation_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("getAllDonations error: " + e.getMessage());
        }
        return list;
    }

    // ─────────────────────────────────────────────────────
    // GET total donation count (for admin dashboard stats)
    // ─────────────────────────────────────────────────────
    public int getTotalDonationCount() {
        String sql = "SELECT COUNT(*) FROM donation_records";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (SQLException e) {
            System.out.println("getTotalDonationCount error: " + e.getMessage());
        }
        return 0;
    }

    // ─────────────────────────────────────────────────────
    // PRIVATE HELPER - map ResultSet row → DonationRecord
    // ─────────────────────────────────────────────────────
    private DonationRecord mapRow(ResultSet rs) throws SQLException {
        DonationRecord r = new DonationRecord();
        r.setId(rs.getInt("record_id"));
        r.setDonorId(rs.getInt("user_id"));
        r.setCampId(rs.getInt("camp_id"));              // returns 0 if NULL
        r.setBloodGroup(rs.getString("blood_type"));
        r.setQuantity(rs.getInt("units_donated"));
        Date d = rs.getDate("donation_date");
        if (d != null) r.setDonationDate(d.toLocalDate());
        return r;
    }
}