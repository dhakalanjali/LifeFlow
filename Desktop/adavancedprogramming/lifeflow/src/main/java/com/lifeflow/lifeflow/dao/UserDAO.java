package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.User;
import com.lifeflow.lifeflow.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    // Method to register new user
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, blood_type, role, is_approved) VALUES (?, ?, ?, ?, ?, 'user', 'pending')";
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, PasswordUtil.encryptPassword(user.getPassword()));
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getBloodType());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(connection);
        }
    }

    // Method to check if email already exists
    public boolean emailExists(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(connection);
        }
    }

    // Method to check if phone already exists
    public boolean phoneExists(String phone) {
        String sql = "SELECT * FROM users WHERE phone = ?";
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeConnection(connection);
        }
    }

    // Method to login user
    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ? AND is_approved = 'approved'";
        Connection connection = null;
        try {
            connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, PasswordUtil.encryptPassword(password));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setBloodType(rs.getString("blood_type"));
                user.setRole(rs.getString("role"));
                user.setIsApproved(rs.getString("is_approved"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeConnection(connection);
        }
        return null;
    }
}