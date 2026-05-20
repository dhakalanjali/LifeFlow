package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.DonationRecord;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class DonationRecordDAO {
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