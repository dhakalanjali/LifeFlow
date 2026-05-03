package com.lifeflow.dao;

import com.lifeflow.model.BloodRequest;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BloodRequestDAO.java
 * Author: Pritam Rai
 * Module: Data Access Layer (MVC)
 * Description: Handles all JDBC database operations for BloodRequest entities.
 *              Implements the DAO (Data Access Object) pattern to separate
 *              database logic from business logic.
 * London Metropolitan University - Blood Bank Management System
 *
 * DATABASE TABLE STRUCTURE (MySQL):
 * CREATE TABLE blood_requests (
 *     request_id       INT AUTO_INCREMENT PRIMARY KEY,
 *     user_id          INT NOT NULL,
 *     patient_name     VARCHAR(100) NOT NULL,
 *     blood_group      VARCHAR(5) NOT NULL,
 *     hospital_name    VARCHAR(150) NOT NULL,
 *     contact_number   VARCHAR(15) NOT NULL,
 *     urgency_level    ENUM('Critical','Urgent','Normal') NOT NULL,
 *     request_date     DATE NOT NULL,
 *     additional_notes TEXT,
 *     status           ENUM('Pending','Fulfilled','Cancelled') DEFAULT 'Pending',
 *     created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 * );
 */
public class BloodRequestDAO {

    // =========================================================
    // DATABASE CONNECTION DETAILS
    // Replace these with actual values or use a connection pool
    // =========================================================
    private static final String DB_URL      = "jdbc:mysql://localhost:3306/bloodbank_db";
    private static final String DB_USER     = "root";
    private static final String DB_PASSWORD = "your_password_here";

    // =========================================================
    // HELPER: Get a database connection
    // =========================================================

    /**
     * Opens and returns a JDBC connection to the MySQL database.
     * In a production system, this would use a connection pool (e.g., DBCP or HikariCP).
     *
     * @return Connection object
     * @throws SQLException if connection fails
     */
    private Connection getConnection() throws SQLException {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found. Add mysql-connector-java to your classpath.", e);
        }
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    // =========================================================
    // INSERT - Add a new blood request
    // =========================================================

    /**
     * Inserts a new BloodRequest record into the database.
     * Uses PreparedStatement to prevent SQL injection.
     *
     * @param bloodRequest the BloodRequest object to insert
     * @return true if insertion was successful, false otherwise
     */
    public boolean insertRequest(BloodRequest bloodRequest) {
        String sql = "INSERT INTO blood_requests " +
                     "(user_id, patient_name, blood_group, hospital_name, " +
                     "contact_number, urgency_level, request_date, additional_notes, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Use try-with-resources to auto-close connection and statement
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bloodRequest.getUserId());
            pstmt.setString(2, bloodRequest.getPatientName());
            pstmt.setString(3, bloodRequest.getBloodGroup());
            pstmt.setString(4, bloodRequest.getHospitalName());
            pstmt.setString(5, bloodRequest.getContactNumber());
            pstmt.setString(6, bloodRequest.getUrgencyLevel());
            pstmt.setDate(7, Date.valueOf(bloodRequest.getRequestDate()));
            pstmt.setString(8, bloodRequest.getAdditionalNotes());
            pstmt.setString(9, bloodRequest.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[BloodRequestDAO] Error inserting request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // SELECT ALL - Retrieve all blood requests
    // =========================================================

    /**
     * Retrieves all blood request records from the database.
     * Results are ordered by request date descending (most recent first).
     *
     * @return List of BloodRequest objects, or empty list if none found
     */
    public List<BloodRequest> getAllRequests() {
        List<BloodRequest> requestList = new ArrayList<>();
        String sql = "SELECT * FROM blood_requests ORDER BY request_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                BloodRequest br = mapResultSetToBloodRequest(rs);
                requestList.add(br);
            }

        } catch (SQLException e) {
            System.err.println("[BloodRequestDAO] Error retrieving all requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requestList;
    }

    // =========================================================
    // SELECT BY ID - Retrieve a single request by its ID
    // =========================================================

    /**
     * Retrieves a single BloodRequest by its primary key (requestId).
     *
     * @param requestId the ID of the request to retrieve
     * @return BloodRequest object if found, or null if not found
     */
    public BloodRequest getRequestById(int requestId) {
        String sql = "SELECT * FROM blood_requests WHERE request_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, requestId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBloodRequest(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[BloodRequestDAO] Error retrieving request by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null; // not found
    }

    // =========================================================
    // UPDATE STATUS - Change the status of a request
    // =========================================================

    /**
     * Updates the status of an existing blood request.
     * Valid statuses: Pending, Fulfilled, Cancelled.
     *
     * @param requestId the ID of the request to update
     * @param newStatus the new status value
     * @return true if update was successful, false otherwise
     */
    public boolean updateRequestStatus(int requestId, String newStatus) {
        // Validate status value before updating
        if (!newStatus.equals("Pending") &&
            !newStatus.equals("Fulfilled") &&
            !newStatus.equals("Cancelled")) {
            System.err.println("[BloodRequestDAO] Invalid status value: " + newStatus);
            return false;
        }

        String sql = "UPDATE blood_requests SET status = ? WHERE request_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, newStatus);
            pstmt.setInt(2, requestId);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[BloodRequestDAO] Error updating request status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // DELETE - Remove a request by ID
    // =========================================================

    /**
     * Deletes a blood request record from the database by its ID.
     * This is a hard delete - use with caution.
     *
     * @param requestId the ID of the request to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteRequest(int requestId) {
        String sql = "DELETE FROM blood_requests WHERE request_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, requestId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[BloodRequestDAO] Error deleting request: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // HELPER: Map a ResultSet row to a BloodRequest object
    // =========================================================

    /**
     * Maps a single row from the ResultSet to a BloodRequest object.
     * Centralises column-to-field mapping to avoid repetition.
     *
     * @param rs the ResultSet positioned at the current row
     * @return a populated BloodRequest object
     * @throws SQLException if a column cannot be read
     */
    private BloodRequest mapResultSetToBloodRequest(ResultSet rs) throws SQLException {
        BloodRequest br = new BloodRequest();
        br.setRequestId(rs.getInt("request_id"));
        br.setUserId(rs.getInt("user_id"));
        br.setPatientName(rs.getString("patient_name"));
        br.setBloodGroup(rs.getString("blood_group"));
        br.setHospitalName(rs.getString("hospital_name"));
        br.setContactNumber(rs.getString("contact_number"));
        br.setUrgencyLevel(rs.getString("urgency_level"));

        // Convert java.sql.Date to java.time.LocalDate
        Date sqlDate = rs.getDate("request_date");
        if (sqlDate != null) {
            br.setRequestDate(sqlDate.toLocalDate());
        }

        br.setAdditionalNotes(rs.getString("additional_notes"));
        br.setStatus(rs.getString("status"));
        return br;
    }
}
