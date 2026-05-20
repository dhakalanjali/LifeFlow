package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.User;
import com.lifeflow.lifeflow.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // HELPER - extract user from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setPhone(rs.getString("phone"));
        u.setBloodType(rs.getString("blood_type"));
        u.setRole(rs.getString("role"));
        u.setIsApproved(rs.getString("is_approved"));
        try {
            u.setDateOfBirth(rs.getString("date_of_birth"));
        } catch (SQLException e) {
        }
        try {
            u.setGender(rs.getString("gender"));
        } catch (SQLException e) {
        }
        try {
            u.setAddress(rs.getString("address"));
        } catch (SQLException e) {
        }
        return u;
    }

    // SAVE new user
    public boolean saveUser(User user) {
        String sql = "INSERT INTO users (full_name, email, phone, date_of_birth, gender, address, blood_type, password, role, is_approved) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getDateOfBirth());
            ps.setString(5, user.getGender());
            ps.setString(6, user.getAddress());
            ps.setString(7, user.getBloodType());
            ps.setString(8, user.getPassword());
            ps.setString(9, user.getRole());
            ps.setString(10, user.getIsApproved());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("saveUser: " + e.getMessage());
            return false;
        }
    }

    // GET user by email
    public User getUserByEmail(String email) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractUser(rs);
        } catch (SQLException e) {
            System.out.println("getUserByEmail: " + e.getMessage());
        }
        return null;
    }

    // GET user by ID
    public User getUserById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE user_id = ?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractUser(rs);
        } catch (SQLException e) {
            System.out.println("getUserById: " + e.getMessage());
        }
        return null;
    }

    // GET all users
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users ORDER BY created_at DESC");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extractUser(rs));
        } catch (SQLException e) {
            System.out.println("getAllUsers: " + e.getMessage());
        }
        return list;
    }

    // GET pending users
    public List<User> getPendingUsers() {
        List<User> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE is_approved = 'pending'");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(extractUser(rs));
        } catch (SQLException e) {
            System.out.println("getPendingUsers: " + e.getMessage());
        }
        return list;
    }

    // GET users by status
    public List<User> getUsersByStatus(String status) {
        List<User> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE is_approved = ?")) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractUser(rs));
        } catch (SQLException e) {
            System.out.println("getUsersByStatus: " + e.getMessage());
        }
        return list;
    }

    // APPROVE user
    public boolean approveUser(int userId) {
        return updateUserStatus(userId, "approved");
    }

    // REJECT user
    public boolean rejectUser(int userId) {
        return updateUserStatus(userId, "rejected");
    }

    // UPDATE user status
    public boolean updateUserStatus(int userId, String status) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "UPDATE users SET is_approved = ? WHERE user_id = ?")) {
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateUserStatus: " + e.getMessage());
            return false;
        }
    }

    // UPDATE user profile
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET full_name=?, phone=?, date_of_birth=?, gender=?, address=?, blood_type=? WHERE user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getDateOfBirth());
            ps.setString(4, user.getGender());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getBloodType());
            ps.setInt(7, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateUser: " + e.getMessage());
            return false;
        }
    }

    // DELETE user
    public boolean deleteUser(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "DELETE FROM users WHERE user_id = ?")) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("deleteUser: " + e.getMessage());
            return false;
        }
    }

    // CHECK email exists
    public boolean emailExists(String email) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE email = ?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("emailExists: " + e.getMessage());
            return false;
        }
    }

    // CHECK phone exists
    public boolean phoneExists(String phone) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT * FROM users WHERE phone = ?")) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("phoneExists: " + e.getMessage());
            return false;
        }
    }

    // GET total user count
    public int getTotalUserCount() {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM users");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("getTotalUserCount: " + e.getMessage());
        }
        return 0;
    }

    // COUNT users by status
    public int countUsersByStatus(String status) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                     "SELECT COUNT(*) FROM users WHERE is_approved = ?")) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("countUsersByStatus: " + e.getMessage());
        }
        return 0;
    }

    // LOGIN user
    public User loginUser(String email, String password) {
        //  Get user by email only
        String sql = "SELECT * FROM users WHERE email = ? AND is_approved = 'approved'";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                //  Get stored BCrypt hash from database
                String storedPassword = rs.getString("password");
                //  Use BCrypt to verify password
                if (PasswordUtil.checkPassword(password, storedPassword)) {
                    return extractUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("loginUser: " + e.getMessage());
        }
        return null;
    }
}
