package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.BloodRequestDAO;
import com.lifeflow.lifeflow.model.BloodRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/BloodRequestServlet")
public class BloodRequestServlet extends HttpServlet {

    private BloodRequestDAO bloodRequestDAO;

    @Override
    public void init() throws ServletException {
        bloodRequestDAO = new BloodRequestDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
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
}
