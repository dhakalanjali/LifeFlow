package com.lifeflow.lifeflow.model;

import java.time.LocalDate;

public class BloodRequest {
    private int requestId;
    private int userId;
    private String patientName;
    private String bloodGroup;
    private String hospitalName;
    private String contactNumber;
    private String urgencyLevel;
    private LocalDate requestDate;
    private String additionalNotes;
    private String status;

    public BloodRequest() {
        this.status = "pending"; // ✅ FIXED: lowercase to match DB
    }

    public BloodRequest(int requestId, int userId, String patientName,
                        String bloodGroup, String hospitalName,
                        String contactNumber, String urgencyLevel,
                        LocalDate requestDate, String additionalNotes,
                        String status) {
        this.requestId       = requestId;
        this.userId          = userId;
        this.patientName     = patientName;
        this.bloodGroup      = bloodGroup;
        this.hospitalName    = hospitalName;
        this.contactNumber   = contactNumber;
        this.urgencyLevel    = urgencyLevel;
        this.requestDate     = requestDate;
        this.additionalNotes = additionalNotes;
        this.status          = status;
    }

    public BloodRequest(int userId, String patientName, String bloodGroup,
                        String hospitalName, String contactNumber,
                        String urgencyLevel, LocalDate requestDate,
                        String additionalNotes) {
        this.userId          = userId;
        this.patientName     = patientName;
        this.bloodGroup      = bloodGroup;
        this.hospitalName    = hospitalName;
        this.contactNumber   = contactNumber;
        this.urgencyLevel    = urgencyLevel;
        this.requestDate     = requestDate;
        this.additionalNotes = additionalNotes;
        this.status          = "pending"; // ✅ FIXED: lowercase to match DB
    }

    // Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = (patientName != null) ? patientName.trim() : null; }
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public String getHospitalName() { return hospitalName; }
    public void setHospitalName(String hospitalName) { this.hospitalName = (hospitalName != null) ? hospitalName.trim() : null; }
    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = (contactNumber != null) ? contactNumber.trim() : null; }
    public String getUrgencyLevel() { return urgencyLevel; }
    public void setUrgencyLevel(String urgencyLevel) { this.urgencyLevel = urgencyLevel; }
    public LocalDate getRequestDate() { return requestDate; }
    public void setRequestDate(LocalDate requestDate) { this.requestDate = requestDate; }
    public String getAdditionalNotes() { return additionalNotes; }
    public void setAdditionalNotes(String additionalNotes) { this.additionalNotes = additionalNotes; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // ✅ FIXED: all helpers use equalsIgnoreCase so they work regardless of case
    public boolean isCritical()  { return "critical".equalsIgnoreCase(this.urgencyLevel); }
    public boolean isPending()   { return "pending".equalsIgnoreCase(this.status); }
    public boolean isApproved()  { return "approved".equalsIgnoreCase(this.status); }  // ✅ NEW
    public boolean isCancelled() { return "cancelled".equalsIgnoreCase(this.status); } // ✅ NEW

    @Override
    public String toString() {
        return "BloodRequest{" +
                "requestId=" + requestId +
                ", patientName='" + patientName + '\'' +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}