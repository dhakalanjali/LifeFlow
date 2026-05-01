package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.UserDAO;
import com.lifeflow.lifeflow.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Show login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // Handle login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check login
        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());

            // Redirect based on role
            if (user.getRole().equals("admin")) {
                response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password! Or your account is not approved yet.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}