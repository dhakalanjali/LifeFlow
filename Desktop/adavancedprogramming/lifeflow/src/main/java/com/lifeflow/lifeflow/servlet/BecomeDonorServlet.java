package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.DonorDAO;
import com.lifeflow.lifeflow.model.Donor;
import com.lifeflow.lifeflow.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/become-donor")
public class BecomeDonorServlet extends HttpServlet {

    private final DonorDAO donorDAO = new DonorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/becomeDonor.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        int userId = loggedInUser.getUserId();

        // Prevent duplicate registration
        Donor existing = donorDAO.getDonorByUserId(userId);
        if (existing != null) {
            request.setAttribute("error", "You are already registered as a donor.");
            request.getRequestDispatcher("/becomeDonor.jsp").forward(request, response);
            return;
        }

        // Create donor row
        Donor newDonor = new Donor();
        newDonor.setUserId(userId);
        newDonor.setLastDonationDate(null);
        newDonor.setIsEligible("yes");

        // 4. Save
        boolean success = donorDAO.saveDonor(newDonor);

        if (success) {
            request.setAttribute("success",
                    "You are now a registered donor! Browse upcoming camps and attend one to donate.");
            request.getRequestDispatcher("/becomeDonor.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/becomeDonor.jsp").forward(request, response);
        }
    }
}