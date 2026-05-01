package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.model.BloodStock;
import com.lifeflow.lifeflow.service.BloodService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/user/*")
public class UserServlet extends HttpServlet {

    private BloodService bloodService = new BloodService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) action = "/dashboard";

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/donationHistory":
                showDonationHistory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user/dashboard");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<BloodStock> stockList = bloodService.getAllBloodStock();
        request.setAttribute("stockList", stockList);
        request.getRequestDispatcher("/WEB-INF/views/userDashboard.jsp")
                .forward(request, response);
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/profile.jsp")
                .forward(request, response);
    }

    private void showDonationHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/donationHistory.jsp")
                .forward(request, response);
    }
}
