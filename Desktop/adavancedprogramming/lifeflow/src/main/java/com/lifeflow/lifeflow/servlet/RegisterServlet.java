package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. GET ALL FORM DATA
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String bloodType = request.getParameter("bloodType");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. SERVER SIDE VALIDATION

        // Check empty fields
        if(fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                dateOfBirth == null || dateOfBirth.trim().isEmpty() ||
                gender == null || gender.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                bloodType == null || bloodType.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check name has no numbers
        if(fullName.matches(".*\\d.*")) {
            request.setAttribute("error", "Full name cannot contain numbers!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check phone is 10 digits
        if(!phone.matches("\\d{10}")) {
            request.setAttribute("error", "Phone number must be exactly 10 digits!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check passwords match
        if(!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Check password length
        if(password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // 3. CHECK EMAIL EXISTS
            String checkEmail = "SELECT * FROM users WHERE email = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkEmail);
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if(rs.next()) {
                request.setAttribute("error", "Email already exists! Please use a different email.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // CHECK PHONE EXISTS
            String checkPhone = "SELECT * FROM users WHERE phone = ?";
            PreparedStatement checkPhoneStmt = conn.prepareStatement(checkPhone);
            checkPhoneStmt.setString(1, phone);
            ResultSet rsPhone = checkPhoneStmt.executeQuery();
            if(rsPhone.next()) {
                request.setAttribute("error", "Phone number already exists! Please use a different number.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // 4. ENCRYPT PASSWORD ← FIXED HERE!
            String encryptedPassword = PasswordUtil.encryptPassword(password);

            // 5. SAVE TO DATABASE
            String insertQuery = "INSERT INTO users " +
                    "(full_name, email, phone, date_of_birth, gender, address, blood_type, password, role, is_approved) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'user', 'pending')";

            PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
            insertStmt.setString(1, fullName);
            insertStmt.setString(2, email);
            insertStmt.setString(3, phone);
            insertStmt.setString(4, dateOfBirth);
            insertStmt.setString(5, gender);
            insertStmt.setString(6, address);
            insertStmt.setString(7, bloodType);
            insertStmt.setString(8, encryptedPassword);

            int result = insertStmt.executeUpdate();

            if(result > 0) {
                // 6. SUCCESS
                request.setAttribute("success",
                        "Registration successful! Please wait for admin approval before logging in.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed! Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }

        } catch(Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Something went wrong! Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            if(conn != null) {
                try { conn.close(); } catch(SQLException e) { e.printStackTrace(); }
            }
        }
    }
}