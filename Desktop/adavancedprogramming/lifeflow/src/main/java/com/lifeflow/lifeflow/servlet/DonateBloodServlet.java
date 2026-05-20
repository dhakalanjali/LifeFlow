package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.DonationCampDAO;
import com.lifeflow.lifeflow.dao.DonationRecordDAO;
import com.lifeflow.lifeflow.dao.DonorDAO;
import com.lifeflow.lifeflow.model.DonationCamp;
import com.lifeflow.lifeflow.model.DonationRecord;
import com.lifeflow.lifeflow.model.Donor;
import com.lifeflow.lifeflow.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/donate-blood")
public class DonateBloodServlet extends HttpServlet {

    private final DonationRecordDAO donationRecordDAO = new DonationRecordDAO();
    private final DonationCampDAO   donationCampDAO   = new DonationCampDAO();
    private final DonorDAO          donorDAO          = new DonorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        // Check if user is a registered donor
        Donor donor = donorDAO.getDonorByUserId(loggedInUser.getUserId());

        // Load camps
        List<DonationCamp> camps = donationCampDAO.getAllCamps();

        // Pass donor (null if not registered yet) and camps to JSP
        request.setAttribute("donor", donor);
        request.setAttribute("camps", camps);

        request.getRequestDispatcher("/donateBlood.jsp").forward(request, response);
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

        //  Read form fields
        String bloodType       = request.getParameter("bloodType");
        String unitStr         = request.getParameter("unitsDonated");
        String campIdStr       = request.getParameter("campId");
        String donationDateStr = request.getParameter("donationDate");

        //  Validation — all required fields must be present
        if (bloodType == null || bloodType.trim().isEmpty() ||
                unitStr == null || unitStr.trim().isEmpty() ||
                donationDateStr == null || donationDateStr.trim().isEmpty()) {

            Donor donor = donorDAO.getDonorByUserId(userId);
            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("donor", donor);
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("/donateBlood.jsp").forward(request, response);
            return;
        }

        //  Validate units range
        int unitsDonated;
        try {
            unitsDonated = Integer.parseInt(unitStr);
            if (unitsDonated < 1 || unitsDonated > 5) {
                throw new NumberFormatException("out of range");
            }
        } catch (NumberFormatException e) {
            Donor donor = donorDAO.getDonorByUserId(userId);
            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("donor", donor);
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Units donated must be between 1 and 5.");
            request.getRequestDispatcher("/donateBlood.jsp").forward(request, response);
            return;
        }

        //  Build DonationRecord object
        DonationRecord record = new DonationRecord();
        record.setDonorId(userId);
        record.setBloodGroup(bloodType.trim());
        record.setQuantity(unitsDonated);
        record.setDonationDate(LocalDate.parse(donationDateStr));

        if (campIdStr != null && !campIdStr.trim().isEmpty() && !campIdStr.equals("0")) {
            try {
                record.setCampId(Integer.parseInt(campIdStr));
            } catch (NumberFormatException ignored) {
                record.setCampId(0);
            }
        } else {
            record.setCampId(0);
        }

        //  Save to database
        boolean success = donationRecordDAO.insertDonation(record);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/donationSuccess.jsp");
        } else {
            Donor donor = donorDAO.getDonorByUserId(userId);
            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("donor", donor);
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Database error. Please try again.");
            request.getRequestDispatcher("/donateBlood.jsp").forward(request, response);
        }
    }
}