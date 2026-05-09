package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.BloodRequestDAO;
import com.lifeflow.lifeflow.db.DBConnection;
import com.lifeflow.lifeflow.model.BloodRequest;
import com.lifeflow.lifeflow.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * BloodRequestServlet.java
 * Merged version combining Pritam's Request Submission and Angel's Blood Search.
 * Paths: /bloodRequest (Search), /BloodRequestServlet (Submit)
 */
@WebServlet({"/bloodRequest", "/BloodRequestServlet"})
public class BloodRequestServlet extends HttpServlet {

    private BloodRequestDAO bloodRequestDAO;

    @Override
    public void init() throws ServletException {
        bloodRequestDAO = new BloodRequestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Angel's Search Logic
        String action = request.getParameter("action");
        if ("search".equals(action)) {
            request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
        } else {
            response.sendRedirect("searchBlood.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if this is Pritam's Submit Request or Angel's Search
        String patientName = request.getParameter("patientName");

        if (patientName != null && !patientName.isEmpty()) {
            // ==========================================
            // PRITAM'S PART: SUBMIT BLOOD REQUEST
            // ==========================================
            handleRequestSubmission(request, response);
        } else {
            // ==========================================
            // ANGEL'S PART: SEARCH FOR BLOOD
            // ==========================================
            handleBloodSearch(request, response);
        }
    }

    private void handleRequestSubmission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String patientName = request.getParameter("patientName");
            String bloodGroup = request.getParameter("bloodGroup");
            String hospitalName = request.getParameter("hospitalName");
            String contactNumber = request.getParameter("contactNumber");
            String urgencyLevel = request.getParameter("urgencyLevel");
            String requestDateStr = request.getParameter("requestDate");
            String additionalNotes = request.getParameter("additionalNotes");

            // Get userId from session
            com.lifeflow.lifeflow.model.User sessionUser =
                    (com.lifeflow.lifeflow.model.User) request.getSession().getAttribute("user");
            int userId = (sessionUser != null) ? sessionUser.getUserId() : 1;

            LocalDate requestDate = null;
            if (requestDateStr != null && !requestDateStr.isEmpty()) {
                requestDate = LocalDate.parse(requestDateStr);
            }

            BloodRequest bloodRequest = new BloodRequest(userId, patientName, bloodGroup,
                    hospitalName, contactNumber,
                    urgencyLevel, requestDate,
                    additionalNotes);

            boolean isInserted = bloodRequestDAO.insertRequest(bloodRequest);

            if (isInserted) {
                request.setAttribute("successMessage", "Blood request submitted successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to submit blood request. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred while processing your request.");
        }
        request.getRequestDispatcher("requestBlood.jsp").forward(request, response);
    }

    private void handleBloodSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bloodGroup = request.getParameter("bloodGroup");
        String location   = request.getParameter("location");

        // Validate inputs
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            request.setAttribute("errorMessage", "Invalid Blood Group selected.");
            request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
            return;
        }

        if (ValidationUtil.isNullOrEmpty(location)) {
            request.setAttribute("errorMessage", "Location cannot be empty.");
            request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
            return;
        }

        // ── REAL DATABASE SEARCH ──
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Search blood_stock by blood_type
            String sql = "SELECT stock_id, blood_type, units_available, last_updated " +
                    "FROM blood_stock WHERE blood_type = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, bloodGroup);
            ResultSet rs = ps.executeQuery();

            List<Map<String, String>> results = new ArrayList<>();

            if (rs.next()) {
                int units = rs.getInt("units_available");
                Map<String, String> row = new HashMap<>();
                row.put("blood_type", rs.getString("blood_type"));
                row.put("units_available", String.valueOf(units));
                row.put("last_updated", rs.getString("last_updated"));
                row.put("status", units > 0 ? "Available" : "Out of Stock");
                row.put("status_class", units > 0 ? "available" : "unavailable");
                results.add(row);
            }

            rs.close();
            ps.close();

            // Pass results to JSP
            request.setAttribute("searchResults", results);
            request.setAttribute("searchBloodGroup", bloodGroup);
            request.setAttribute("searchLocation", location);

            if (results.isEmpty()) {
                request.setAttribute("searchMessage", "No stock found for blood group " + bloodGroup + ".");
            } else {
                request.setAttribute("searchMessage", "Results for " + bloodGroup + " in " + location);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }

        request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
    }
}
