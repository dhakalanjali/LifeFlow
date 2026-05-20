package com.lifeflow.lifeflow.service;

import com.lifeflow.lifeflow.dao.DonorDAO;
import com.lifeflow.lifeflow.dao.UserDAO;
import com.lifeflow.lifeflow.model.Donor;
import com.lifeflow.lifeflow.model.User;

import java.util.ArrayList;
import java.util.List;

public class UserService {

    private UserDAO userDAO = new UserDAO();
    private DonorDAO donorDAO = new DonorDAO();

    // Get all users
    public List<User> getAllUsers() {
        try { return userDAO.getAllUsers(); }
        catch (Exception e) { return new ArrayList<>(); }
    }

    // Get pending users
    public List<User> getPendingUsers() {
        try { return userDAO.getPendingUsers(); }
        catch (Exception e) { return new ArrayList<>(); }
    }

    // Approve user
    public boolean approveUser(int userId) {
        try { return userDAO.approveUser(userId); }
        catch (Exception e) { return false; }
    }

    // Reject user
    public boolean rejectUser(int userId) {
        try { return userDAO.rejectUser(userId); }
        catch (Exception e) { return false; }
    }

    // Delete user
    public boolean deleteUser(int userId) {
        try { return userDAO.deleteUser(userId); }
        catch (Exception e) { return false; }
    }

    // Update user
    public boolean updateUser(int userId, String fullName, String email, String phone, String bloodType, String role) {
        try {
            User u = userDAO.getUserById(userId);
            if (u == null) return false;
            u.setFullName(fullName);
            u.setEmail(email);
            u.setPhone(phone);
            u.setBloodType(bloodType);
            u.setRole(role);
            return userDAO.updateUser(u);
        }
        catch (Exception e) { return false; }
    }

    // Get dashboard stats
    public int[] getDashboardStats() {
        int[] s = new int[4];
        try { s[0] = userDAO.getTotalUserCount(); } catch (Exception e) {}
        try { s[1] = userDAO.countUsersByStatus("pending"); } catch (Exception e) {}
        try { s[2] = userDAO.countUsersByStatus("approved"); } catch (Exception e) {}
        try { s[3] = donorDAO.getTotalDonorCount(); } catch (Exception e) {}
        return s;
    }

    // Get all donors
    public List<Donor> getAllDonors() {
        try { return donorDAO.getAllDonors(); }
        catch (Exception e) { return new ArrayList<>(); }
    }

    // Get donors by blood group
    public List<Donor> getDonorsByBloodGroup(String bg) {
        try {
            if (bg == null || bg.trim().isEmpty())
                return donorDAO.getAllDonors();
            return donorDAO.getDonorsByBloodGroup(bg);
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // Login user
    public User loginUser(String email, String password) {
        try { return userDAO.loginUser(email, password); }
        catch (Exception e) { return null; }
    }

    // Get user by id
    public User getUserById(int userId) {
        try { return userDAO.getUserById(userId); }
        catch (Exception e) { return null; }
    }
}