package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.UserDAO;
import com.lifeflow.lifeflow.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    // Show register page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    // Handle register form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String bloodType = request.getParameter("bloodType");

        UserDAO userDAO = new UserDAO();

        // Validation checks
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!fullName.matches("[a-zA-Z ]+")) {
            request.setAttribute("error", "Full name must contain letters only!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!email.contains("@") || !email.contains(".")) {
            request.setAttribute("error", "Please enter a valid email!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Phone number is required!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!phone.matches("[0-9]{10}")) {
            request.setAttribute("error", "Phone must be 10 digits only!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (bloodType == null || bloodType.trim().isEmpty()) {
            request.setAttribute("error", "Please select your blood type!");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already registered! Please use another email.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if phone already exists
        if (userDAO.phoneExists(phone)) {
            request.setAttribute("error", "Phone number already registered! Please use another number.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setBloodType(bloodType);

        // Save to database
        boolean success = userDAO.registerUser(user);

        if (success) {
            request.setAttribute("success", "Registration successful! Please wait for admin approval.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
