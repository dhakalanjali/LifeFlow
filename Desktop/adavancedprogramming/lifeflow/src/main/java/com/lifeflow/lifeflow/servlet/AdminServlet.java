package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.model.Donor;
import com.lifeflow.lifeflow.model.User;
import com.lifeflow.lifeflow.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Check if admin is logged in
        HttpSession session = req.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (loggedUser == null || !loggedUser.getRole().equals("admin")) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            showDashboard(req, res);
        } else if (path.equals("/manageUsers")) {
            showManageUsers(req, res);
        } else if (path.equals("/approve")) {
            handleApprove(req, res);
        } else if (path.equals("/reject")) {
            handleReject(req, res);
        } else {
            showDashboard(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doGet(req, res);
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int[] s = userService.getDashboardStats();
            req.setAttribute("totalUsers", s[0]);
            req.setAttribute("pendingUsers", s[1]);
            req.setAttribute("approvedUsers", s[2]);
            req.setAttribute("totalDonors", s[3]);
            req.setAttribute("countAPos", userService.getDonorsByBloodGroup("A+").size());
            req.setAttribute("countBPos", userService.getDonorsByBloodGroup("B+").size());
            req.setAttribute("countOPos", userService.getDonorsByBloodGroup("O+").size());
            req.setAttribute("countABPos", userService.getDonorsByBloodGroup("AB+").size());
            req.setAttribute("countANeg", userService.getDonorsByBloodGroup("A-").size());
            req.setAttribute("countBNeg", userService.getDonorsByBloodGroup("B-").size());
            req.setAttribute("countONeg", userService.getDonorsByBloodGroup("O-").size());
            req.setAttribute("countABNeg", userService.getDonorsByBloodGroup("AB-").size());
            req.setAttribute("pendingList", userService.getPendingUsers());
        } catch (Exception e) {
            req.setAttribute("totalUsers", 0);
            req.setAttribute("pendingUsers", 0);
            req.setAttribute("approvedUsers", 0);
            req.setAttribute("totalDonors", 0);
            req.setAttribute("countAPos", 0);
            req.setAttribute("countBPos", 0);
            req.setAttribute("countOPos", 0);
            req.setAttribute("countABPos", 0);
            req.setAttribute("countANeg", 0);
            req.setAttribute("countBNeg", 0);
            req.setAttribute("countONeg", 0);
            req.setAttribute("countABNeg", 0);
            req.setAttribute("pendingList", new ArrayList<>());
        }
        // Fixed JSP path!
        req.getRequestDispatcher("/adminDashboard.jsp").forward(req, res);
    }

    private void showManageUsers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("users", userService.getAllUsers());
            req.setAttribute("pendingUsers", userService.getPendingUsers());
            req.setAttribute("donors", userService.getAllDonors());
        } catch (Exception e) {
            req.setAttribute("users", new ArrayList<>());
            req.setAttribute("pendingUsers", new ArrayList<>());
            req.setAttribute("donors", new ArrayList<>());
        }
        // Fixed JSP path!
        req.getRequestDispatcher("/manageUsers.jsp").forward(req, res);
    }

    private void handleApprove(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            userService.approveUser(id);
            req.getSession().setAttribute("successMessage", "User approved successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Could not approve user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/manageUsers");
    }

    private void handleReject(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            userService.rejectUser(id);
            req.getSession().setAttribute("successMessage", "User rejected successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "Could not reject user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/manageUsers");
    }
}