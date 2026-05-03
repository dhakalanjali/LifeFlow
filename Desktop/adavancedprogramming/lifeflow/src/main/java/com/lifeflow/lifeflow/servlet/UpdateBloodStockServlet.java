package com.lifeflow.lifeflow.servlet;

import com.lifeflow.lifeflow.db.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/updateBloodStock")
public class UpdateBloodStockServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
        String stockId = request.getParameter("stockId");
        String units = request.getParameter("units");

        // Validation
        if (stockId == null || units == null || units.trim().isEmpty()) {
            request.setAttribute("error", "Invalid input!");
            request.getRequestDispatcher("/manageBloodStock.jsp").forward(request, response);
            return;
        }

        // Update database
        String sql = "UPDATE blood_stock SET units_available = ? WHERE stock_id = ?";
        Connection connection = null;

        try {
            connection = DBConnection.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(units));
            ps.setInt(2, Integer.parseInt(stockId));
            int rows = ps.executeUpdate();

            if (rows > 0) {
                request.setAttribute("success", "Blood stock updated successfully!");
            } else {
                request.setAttribute("error", "Update failed! Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error! Please try again.");
        } finally {
            DBConnection.closeConnection(connection);
        }

        // Go back to manage blood stock page
        request.getRequestDispatcher("/manageBloodStock.jsp").forward(request, response);
    }
}