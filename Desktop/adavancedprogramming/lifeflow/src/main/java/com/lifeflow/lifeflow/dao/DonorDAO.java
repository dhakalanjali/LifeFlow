package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.model.Donor;
import com.lifeflow.lifeflow.db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {

    // Helper method to build Donor from ResultSet
    private Donor buildDonor(ResultSet rs) {
        Donor d = new Donor();
        try { d.setDonorId(rs.getInt("donor_id")); }
        catch (SQLException e) {}
        try { d.setUserId(rs.getInt("user_id")); }
        catch (SQLException e) {}
        try { d.setLastDonationDate(rs.getString("last_donation_date")); }
        catch (SQLException e) {}
        try { d.setIsEligible(rs.getString("is_eligible")); }
        catch (SQLException e) {}
        return d;
    }

    // Get all donors
    public List<Donor> getAllDonors() {
        List<Donor> list = new ArrayList<>();
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("getAllDonors: connection is null"); return list; }
        try {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM donors");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildDonor(rs));
        } catch (SQLException e) {
            System.out.println("getAllDonors ERROR: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(c);
        }
        return list;
    }

    // Get donors by blood group
    public List<Donor> getDonorsByBloodGroup(String bg) {
        List<Donor> list = new ArrayList<>();
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("getDonorsByBloodGroup: connection is null"); return list; }
        try {
            PreparedStatement ps = c.prepareStatement(
                    "SELECT d.* FROM donors d " +
                            "JOIN users u ON d.user_id = u.user_id " +
                            "WHERE u.blood_type = ?");
            ps.setString(1, bg);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildDonor(rs));
        } catch (SQLException e) {
            System.out.println("getDonorsByBloodGroup ERROR: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(c);
        }
        return list;
    }

    // Get total donor count
    public int getTotalDonorCount() {
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("getTotalDonorCount: connection is null"); return 0; }
        try {
            PreparedStatement ps = c.prepareStatement("SELECT COUNT(*) FROM donors");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("getTotalDonorCount ERROR: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(c);
        }
        return 0;
    }

    // Get donor by user_id
    public Donor getDonorByUserId(int userId) {
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("getDonorByUserId: connection is null"); return null; }
        try {
            PreparedStatement ps = c.prepareStatement(
                    "SELECT * FROM donors WHERE user_id = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildDonor(rs);
        } catch (SQLException e) {
            System.out.println("getDonorByUserId ERROR: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(c);
        }
        return null;
    }

    // Save new donor
    public boolean saveDonor(Donor donor) {
        String sql = "INSERT INTO donors (user_id, last_donation_date, is_eligible) VALUES (?, ?, ?)";
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("saveDonor: connection is null"); return false; }
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setInt(1, donor.getUserId());

            if (donor.getLastDonationDate() == null) {
                ps.setNull(2, java.sql.Types.DATE);
            } else {
                ps.setString(2, donor.getLastDonationDate());
            }

            ps.setString(3, donor.getIsEligible());
            int rows = ps.executeUpdate();
            System.out.println("saveDonor: rows inserted = " + rows);
            return rows > 0;

        } catch (SQLException e) {
            System.out.println("saveDonor ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(c);
        }
    }

    // Delete donor
    public boolean deleteDonor(int donorId) {
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("deleteDonor: connection is null"); return false; }
        try {
            PreparedStatement ps = c.prepareStatement(
                    "DELETE FROM donors WHERE donor_id = ?");
            ps.setInt(1, donorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteDonor ERROR: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(c);
        }
    }

    // ✅ NEW — called by AdminServlet after recording a donation
    // Updates last_donation_date and sets is_eligible = 'no'
    public boolean updateAfterDonation(int userId, String donationDate) {
        String sql = "UPDATE donors SET last_donation_date = ?, is_eligible = 'no' WHERE user_id = ?";
        Connection c = DBConnection.getConnection();
        if (c == null) { System.out.println("updateAfterDonation: connection is null"); return false; }
        try {
            PreparedStatement ps = c.prepareStatement(sql);
            ps.setString(1, donationDate);  // e.g. "2025-05-14"
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            System.out.println("updateAfterDonation: rows updated = " + rows);
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateAfterDonation ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(c);
        }
    }
}