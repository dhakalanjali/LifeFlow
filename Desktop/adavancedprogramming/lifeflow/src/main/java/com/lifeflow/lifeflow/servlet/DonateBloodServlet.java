package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.dao.DonationCampDAO;
import com.lifeflow.lifeflow.dao.DonationRecordDAO;
import com.lifeflow.lifeflow.model.DonationCamp;
import com.lifeflow.lifeflow.model.DonationRecord;
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

    // ─────────────────────────────────────────────────────
    // doGet — show the donation form
    // ─────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check session — user must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Load camps for the dropdown
        List<DonationCamp> camps = donationCampDAO.getAllCamps();
        request.setAttribute("camps", camps);

        // 3. Forward to JSP — file is at webapp/donateBlood.jsp
        request.getRequestDispatcher("/donateBlood.jsp")
                .forward(request, response);
    }

    // ─────────────────────────────────────────────────────
    // doPost — process the submitted donation form
    // ─────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");
        int userId = loggedInUser.getUserId();

        // 2. Read form fields
        String bloodType       = request.getParameter("bloodType");
        String unitStr         = request.getParameter("unitsDonated");
        String campIdStr       = request.getParameter("campId");
        String donationDateStr = request.getParameter("donationDate");

        // 3. Validation — all required fields must be present
        if (bloodType == null || bloodType.trim().isEmpty() ||
                unitStr == null || unitStr.trim().isEmpty() ||
                donationDateStr == null || donationDateStr.trim().isEmpty()) {

            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("/donateBlood.jsp")
                    .forward(request, response);
            return;
        }

        // 4. Validate units range
        int unitsDonated;
        try {
            unitsDonated = Integer.parseInt(unitStr);
            if (unitsDonated < 1 || unitsDonated > 5) {
                throw new NumberFormatException("out of range");
            }
        } catch (NumberFormatException e) {
            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Units donated must be between 1 and 5.");
            request.getRequestDispatcher("/donateBlood.jsp")
                    .forward(request, response);
            return;
        }

        // 5. Build DonationRecord object
        DonationRecord record = new DonationRecord();
        record.setDonorId(userId);                                 // → user_id in DB
        record.setBloodGroup(bloodType.trim());                    // → blood_type in DB
        record.setQuantity(unitsDonated);                          // → units_donated in DB
        record.setDonationDate(LocalDate.parse(donationDateStr));  // → donation_date in DB

        // camp_id is optional — 0 means walk-in, DAO inserts NULL
        if (campIdStr != null && !campIdStr.trim().isEmpty() && !campIdStr.equals("0")) {
            try {
                record.setCampId(Integer.parseInt(campIdStr));
            } catch (NumberFormatException ignored) {
                record.setCampId(0);
            }
        } else {
            record.setCampId(0);
        }

        // 6. Save to database
        boolean success = donationRecordDAO.insertDonation(record);

        if (success) {
            // 7a. Success → redirect to success page
            response.sendRedirect(request.getContextPath() + "/donationSuccess.jsp");
        } else {
            // 7b. DB error → reload form with error message
            List<DonationCamp> camps = donationCampDAO.getAllCamps();
            request.setAttribute("camps", camps);
            request.setAttribute("error", "Database error. Please try again.");
            request.getRequestDispatcher("/donateBlood.jsp")
                    .forward(request, response);
        }
    }
}