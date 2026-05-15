package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.UserDAO;
import com.lifeflow.lifeflow.model.BloodStock;
import com.lifeflow.lifeflow.model.User;
import com.lifeflow.lifeflow.service.BloodService;
import com.lifeflow.lifeflow.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet({"/user/*", "/updateProfile"})
public class UserServlet extends HttpServlet {

    private BloodService bloodService = new BloodService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/donationHistory":
                showDonationHistory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        String fullName  = request.getParameter("fullName");
        String phone     = request.getParameter("phone");
        String bloodType = request.getParameter("bloodType");
        String newPass   = request.getParameter("newPassword");

        // Update user object
        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);
        currentUser.setBloodType(bloodType);

        // Update password if provided
        if (newPass != null && !newPass.trim().isEmpty()) {
            currentUser.setPassword(PasswordUtil.encryptPassword(newPass));
        }

        UserDAO userDAO = new UserDAO();
        boolean updated = userDAO.updateUser(currentUser);

        if (updated) {
            // Update session
            session.setAttribute("user", currentUser);
            session.setAttribute("userName", fullName);
            session.setAttribute("userPhone", phone);
            session.setAttribute("userBloodType", bloodType);
            session.setAttribute("success", "Profile updated successfully!");
        } else {
            session.setAttribute("error", "Update failed! Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/profile.jsp");
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BloodStock> stockList = bloodService.getAllBloodStock();
        request.setAttribute("stockList", stockList);
        request.getRequestDispatcher("/userDashboard.jsp").forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    private void showDonationHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/donationHistory.jsp").forward(request, response);
    }
}
