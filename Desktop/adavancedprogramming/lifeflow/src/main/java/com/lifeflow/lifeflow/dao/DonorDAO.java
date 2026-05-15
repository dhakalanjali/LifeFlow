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
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM donor");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(buildDonor(rs));
        } catch (SQLException e) {
            System.out.println("getAllDonors: " + e.getMessage());
        }
        return list;
    }

    // Get donors by blood group (joins users table since blood_type is in users)
    public List<Donor> getDonorsByBloodGroup(String bg) {
        List<Donor> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT d.* FROM donor d " +
                             "JOIN users u ON d.user_id = u.user_id " +
                             "WHERE u.blood_type = ?")) {
            ps.setString(1, bg);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildDonor(rs));
        } catch (SQLException e) {
            System.out.println("getDonorsByBloodGroup: " + e.getMessage());
        }
        return list;
    }

    // Get total donor count
    public int getTotalDonorCount() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM donor");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("getTotalDonorCount: " + e.getMessage());
        }
        return 0;
    }

    // Get donor by user_id
    public Donor getDonorByUserId(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM donor WHERE user_id = ?")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return buildDonor(rs);
        } catch (SQLException e) {
            System.out.println("getDonorByUserId: " + e.getMessage());
        }
        return null;
    }

    // Save new donor
    public boolean saveDonor(Donor donor) {
        String sql = "INSERT INTO donor (user_id, last_donation_date, is_eligible) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, donor.getUserId());
            ps.setString(2, donor.getLastDonationDate());
            ps.setString(3, donor.getIsEligible());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("saveDonor: " + e.getMessage());
            return false;
        }
    }

    // Delete donor
    public boolean deleteDonor(int donorId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "DELETE FROM donor WHERE donor_id = ?")) {
            ps.setInt(1, donorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteDonor: " + e.getMessage());
            return false;
        }
    }
}