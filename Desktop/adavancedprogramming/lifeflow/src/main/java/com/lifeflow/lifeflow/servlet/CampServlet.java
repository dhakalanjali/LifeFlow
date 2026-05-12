package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.DonationCampDAO;
import com.lifeflow.lifeflow.model.DonationCamp;
import com.lifeflow.lifeflow.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * CampServlet.java
 * Author: Anjali dhakal
 * Handles Add, Edit, Delete operations for donation camps.
 */
@WebServlet("/manageCamps")
public class CampServlet extends HttpServlet {

    private DonationCampDAO campDAO;

    @Override
    public void init() throws ServletException {
        campDAO = new DonationCampDAO();
    }

    /**
     * GET — load all camps and forward to manageCamps.jsp
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        User loggedUser = (User) request.getSession().getAttribute("user");
        if (loggedUser == null || !loggedUser.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load all camps from database
        List<DonationCamp> camps = campDAO.getAllCamps();
        request.setAttribute("camps", camps);
        request.getRequestDispatcher("/manageCamps.jsp").forward(request, response);
    }

    /**
     * POST — handle add, edit, delete actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        User loggedUser = (User) request.getSession().getAttribute("user");
        if (loggedUser == null || !loggedUser.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                // ── ADD NEW CAMP ──
                DonationCamp camp = new DonationCamp();
                camp.setName(request.getParameter("campName"));
                camp.setLocation(request.getParameter("location"));
                camp.setDate(LocalDate.parse(request.getParameter("campDate")));
                camp.setOrganizer(request.getParameter("organizer"));

                boolean success = campDAO.addCamp(camp);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Camp added successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to add camp.");
                }

            } else if ("edit".equals(action)) {
                // ── EDIT CAMP ──
                DonationCamp camp = new DonationCamp();
                camp.setId(Integer.parseInt(request.getParameter("campId")));
                camp.setName(request.getParameter("campName"));
                camp.setLocation(request.getParameter("location"));
                camp.setDate(LocalDate.parse(request.getParameter("campDate")));
                camp.setOrganizer(request.getParameter("organizer"));

                boolean success = campDAO.updateCamp(camp);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Camp updated successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to update camp.");
                }

            } else if ("delete".equals(action)) {
                // ── DELETE CAMP ──
                int campId = Integer.parseInt(request.getParameter("campId"));
                boolean success = campDAO.deleteCamp(campId);
                if (success) {
                    request.getSession().setAttribute("successMessage", "Camp deleted successfully!");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to delete camp.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred: " + e.getMessage());
        }

        // Redirect back to manage camps
        response.sendRedirect(request.getContextPath() + "/manageCamps");
    }
}
