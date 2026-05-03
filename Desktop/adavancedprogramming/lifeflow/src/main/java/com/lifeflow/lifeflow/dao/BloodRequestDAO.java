package com.lifeflow.lifeflow.dao;

import com.lifeflow.lifeflow.model.BloodRequest;
import com.lifeflow.lifeflow.db.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BloodRequestDAO {

    public boolean insertRequest(BloodRequest bloodRequest) {
        String sql = "INSERT INTO blood_requests " +
                     "(user_id, patient_name, blood_group, hospital_name, " +
                     "contact_number, urgency_level, request_date, additional_notes, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
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
            e.printStackTrace();
            return false;
        }
    }

    public List<BloodRequest> getAllRequests() {
        List<BloodRequest> requestList = new ArrayList<>();
        String sql = "SELECT * FROM blood_requests ORDER BY request_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                requestList.add(mapResultSetToBloodRequest(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requestList;
    }

    public BloodRequest getRequestById(int requestId) {
        String sql = "SELECT * FROM blood_requests WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, requestId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSetToBloodRequest(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRequestStatus(int requestId, String newStatus) {
        String sql = "UPDATE blood_requests SET status = ? WHERE request_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, requestId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private BloodRequest mapResultSetToBloodRequest(ResultSet rs) throws SQLException {
        BloodRequest br = new BloodRequest();
        br.setRequestId(rs.getInt("request_id"));
        br.setUserId(rs.getInt("user_id"));
        br.setPatientName(rs.getString("patient_name"));
        br.setBloodGroup(rs.getString("blood_group"));
        br.setHospitalName(rs.getString("hospital_name"));
        br.setContactNumber(rs.getString("contact_number"));
        br.setUrgencyLevel(rs.getString("urgency_level"));
        Date sqlDate = rs.getDate("request_date");
        if (sqlDate != null) br.setRequestDate(sqlDate.toLocalDate());
        br.setAdditionalNotes(rs.getString("additional_notes"));
        br.setStatus(rs.getString("status"));
        return br;
    }
}
