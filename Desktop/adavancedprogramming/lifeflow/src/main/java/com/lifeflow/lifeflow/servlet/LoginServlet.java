package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.UserDAO;
import com.lifeflow.lifeflow.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Show login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK IF COOKIE EXISTS → pre-fill email
        String savedEmail = "";
        Cookie[] cookies = request.getCookies();
        if(cookies != null) {
            for(Cookie cookie : cookies) {
                if(cookie.getName().equals("savedEmail")) {
                    savedEmail = cookie.getValue();
                }
            }
        }

        // Send saved email to login page
        request.setAttribute("savedEmail", savedEmail);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // Handle login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

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

            // CREATE SESSION
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());

            // SAVE COOKIE IF REMEMBER ME CHECKED
            if(rememberMe != null && rememberMe.equals("on")) {
                // Save email in cookie for 7 days
                Cookie emailCookie = new Cookie("savedEmail", email);
                emailCookie.setMaxAge(60 * 60 * 24 * 7); // 7 days
                emailCookie.setPath("/");
                response.addCookie(emailCookie);
            } else {
                // Delete cookie if not checked
                Cookie emailCookie = new Cookie("savedEmail", "");
                emailCookie.setMaxAge(0); // Delete immediately
                emailCookie.setPath("/");
                response.addCookie(emailCookie);
            }

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