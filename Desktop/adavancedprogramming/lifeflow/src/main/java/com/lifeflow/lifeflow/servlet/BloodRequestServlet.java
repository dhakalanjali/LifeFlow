package com.lifeflow.lifeflow.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.lifeflow.lifeflow.util.ValidationUtil;

import java.io.IOException;

@WebServlet("/bloodRequest")
public class BloodRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("search".equals(action)) {
            // Forward to searchBlood.jsp if they just want to view the page
            request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
        } else {
            // Default behaviour
            response.sendRedirect("searchBlood.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handling blood search submission
        String bloodGroup = request.getParameter("bloodGroup");
        String location = request.getParameter("location");

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

        // TODO: In a real application, you would call a Service/DAO to find available blood matching criteria.
        // For now, we simulate a successful search result.
        request.setAttribute("successMessage", "Search completed for " + bloodGroup + " in " + location);
        request.setAttribute("searchBloodGroup", bloodGroup);
        request.setAttribute("searchLocation", location);
        
        // Forward back to searchBlood.jsp to display results
        request.getRequestDispatcher("/searchBlood.jsp").forward(request, response);
    }
}
