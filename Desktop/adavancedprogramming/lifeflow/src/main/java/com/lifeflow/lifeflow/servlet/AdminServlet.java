package com.lifeflow.lifeflow.servlet;

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
        } else if (path.equals("/deleteUser")) {
            handleDeleteUser(req, res);
        } else if (path.equals("/editUser")) {
            showEditUser(req, res);
        } else if (path.equals("/updateUser")) {
            handleUpdateUser(req, res);
        } else if (path.equals("/viewUser")) {
            showViewUser(req, res);
        } else {
            showDashboard(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path != null && path.equals("/updateUser")) {
            handleUpdateUser(req, res);
        } else {
            doGet(req, res);
        }
    }

    // ── DASHBOARD ──
    private void showDashboard(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int[] s = userService.getDashboardStats();
            req.setAttribute("totalUsers",    s[0]);
            req.setAttribute("pendingUsers",  s[1]);
            req.setAttribute("approvedUsers", s[2]);
            req.setAttribute("totalDonors",   s[3]);

            // Blood group counts
            req.setAttribute("countAPos",  userService.getDonorsByBloodGroup("A+").size());
            req.setAttribute("countBPos",  userService.getDonorsByBloodGroup("B+").size());
            req.setAttribute("countOPos",  userService.getDonorsByBloodGroup("O+").size());
            req.setAttribute("countABPos", userService.getDonorsByBloodGroup("AB+").size());
            req.setAttribute("countANeg",  userService.getDonorsByBloodGroup("A-").size());
            req.setAttribute("countBNeg",  userService.getDonorsByBloodGroup("B-").size());
            req.setAttribute("countONeg",  userService.getDonorsByBloodGroup("O-").size());
            req.setAttribute("countABNeg", userService.getDonorsByBloodGroup("AB-").size());

            // Pending list for approval table
            req.setAttribute("pendingList", userService.getPendingUsers());

            // ✅ NEW: All users for the All Users table
            req.setAttribute("allUsers", userService.getAllUsers());

        } catch (Exception e) {
            req.setAttribute("totalUsers",    0);
            req.setAttribute("pendingUsers",  0);
            req.setAttribute("approvedUsers", 0);
            req.setAttribute("totalDonors",   0);
            req.setAttribute("countAPos",  0);
            req.setAttribute("countBPos",  0);
            req.setAttribute("countOPos",  0);
            req.setAttribute("countABPos", 0);
            req.setAttribute("countANeg",  0);
            req.setAttribute("countBNeg",  0);
            req.setAttribute("countONeg",  0);
            req.setAttribute("countABNeg", 0);
            req.setAttribute("pendingList", new ArrayList<>());
            req.setAttribute("allUsers",    new ArrayList<>());
        }
        req.getRequestDispatcher("/adminDashboard.jsp").forward(req, res);
    }

    // ── MANAGE USERS PAGE ──
    private void showManageUsers(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("users",        userService.getAllUsers());
            req.setAttribute("pendingUsers", userService.getPendingUsers());
            req.setAttribute("donors",       userService.getAllDonors());
        } catch (Exception e) {
            req.setAttribute("users",        new ArrayList<>());
            req.setAttribute("pendingUsers", new ArrayList<>());
            req.setAttribute("donors",       new ArrayList<>());
        }
        req.getRequestDispatcher("/manageUsers.jsp").forward(req, res);
    }

    // ── APPROVE USER ──
    private void handleApprove(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            userService.approveUser(id);
            req.getSession().setAttribute("successMessage", "✅ User approved successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ Could not approve user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    // ── REJECT USER ──
    private void handleReject(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            userService.rejectUser(id);
            req.getSession().setAttribute("successMessage", "User rejected successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ Could not reject user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    // ── DELETE USER ──
    private void handleDeleteUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            userService.deleteUser(id);
            req.getSession().setAttribute("successMessage", "🗑 User deleted successfully.");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ Could not delete user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    // ── SHOW EDIT USER FORM ──
    private void showEditUser(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            User user = userService.getUserById(id);
            req.setAttribute("editUser", user);
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ User not found.");
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.getRequestDispatcher("/manageUsers.jsp").forward(req, res);
    }

    // ── UPDATE USER ──
    private void handleUpdateUser(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        try {
            int id        = Integer.parseInt(req.getParameter("userId"));
            String name   = req.getParameter("fullName");
            String email  = req.getParameter("email");
            String phone  = req.getParameter("phone");
            String blood  = req.getParameter("bloodType");
            String role   = req.getParameter("role");

            userService.updateUser(id, name, email, phone, blood, role);
            req.getSession().setAttribute("successMessage", "✏️ User updated successfully!");
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ Could not update user.");
        }
        res.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    // ── VIEW USER ──
    private void showViewUser(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("userId"));
            User user = userService.getUserById(id);
            req.setAttribute("viewUser", user);
        } catch (Exception e) {
            req.getSession().setAttribute("errorMessage", "❌ User not found.");
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }
        req.getRequestDispatcher("/manageUsers.jsp").forward(req, res);
    }
}
