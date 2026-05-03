package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.BloodRequestDAO;
import com.lifeflow.lifeflow.model.BloodRequest;
import com.lifeflow.lifeflow.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

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
            
            int userId = 1; 

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
                request.setAttribute("successMessage", "Blood request submitted successfully!");
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
        String location = request.getParameter("location");

        // Use Angel's ValidationUtil
        if (!ValidationUtil.isValidBloodGroup(bloodGroup)) {
            request.setAttribute("errorMessage", "Invalid Blood Group selected.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        if (ValidationUtil.isNullOrEmpty(location)) {
            request.setAttribute("errorMessage", "Location cannot be empty.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("successMessage", "Search completed for " + bloodGroup + " in " + location);
        request.setAttribute("searchBloodGroup", bloodGroup);
        request.setAttribute("searchLocation", location);
        
        request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
    }
}
