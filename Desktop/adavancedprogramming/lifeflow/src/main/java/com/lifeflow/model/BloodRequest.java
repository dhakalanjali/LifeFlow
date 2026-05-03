package com.lifeflow.model;

import java.time.LocalDate;

/**
 * BloodRequest.java
 * Author: Pritam Rai
 * Module: Model Layer (MVC)
 * Description: Represents a blood request entity with full encapsulation.
 *              Maps to the 'blood_requests' table in the MySQL database.
 * London Metropolitan University - Blood Bank Management System
 */
public class BloodRequest {

    // =========================================================
    // FIELDS - private for encapsulation
    // =========================================================

    /** Auto-generated primary key from the database */
    private int requestId;

    /** Foreign key referencing the user who submitted the request */
    private int userId;

    /** Full name of the patient requiring blood */
    private String patientName;

    /** Blood group required (e.g., A+, O-, AB+) */
    private String bloodGroup;

    /** Name of the hospital or clinic where blood is needed */
    private String hospitalName;

    /** Contact phone number for the requester */
    private String contactNumber;

    /** Urgency level: Critical, Urgent, or Normal */
    private String urgencyLevel;

    /** Date by which the blood is required */
    private LocalDate requestDate;

    /** Any additional notes or special requirements */
    private String additionalNotes;

    /** Current status of the request: Pending, Fulfilled, Cancelled */
    private String status;

    // =========================================================
    // CONSTRUCTORS
    // =========================================================

    /**
     * Default no-argument constructor.
     * Required for frameworks and manual object creation.
     */
    public BloodRequest() {
        this.status = "Pending"; // default status on creation
    }

    /**
     * Full constructor for creating a complete BloodRequest object.
     * Typically used when retrieving records from the database.
     *
     * @param requestId       auto-generated request ID
     * @param userId          ID of the user who submitted the request
     * @param patientName     full name of the patient
     * @param bloodGroup      required blood group
     * @param hospitalName    hospital or clinic name
     * @param contactNumber   contact phone number
     * @param urgencyLevel    urgency level (Critical / Urgent / Normal)
     * @param requestDate     date blood is required by
     * @param additionalNotes any extra notes
     * @param status          current request status
     */
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

    /**
     * Constructor for creating a new request (without requestId, which is DB-generated).
     * Used when inserting a new record via the form submission.
     */
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
        this.status          = "Pending"; // new requests always start as Pending
    }

    // =========================================================
    // GETTERS AND SETTERS
    // =========================================================

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        // Basic sanitisation: trim whitespace
        this.patientName = (patientName != null) ? patientName.trim() : null;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public String getHospitalName() {
        return hospitalName;
    }

    public void setHospitalName(String hospitalName) {
        this.hospitalName = (hospitalName != null) ? hospitalName.trim() : null;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = (contactNumber != null) ? contactNumber.trim() : null;
    }

    public String getUrgencyLevel() {
        return urgencyLevel;
    }

    public void setUrgencyLevel(String urgencyLevel) {
        this.urgencyLevel = urgencyLevel;
    }

    public LocalDate getRequestDate() {
        return requestDate;
    }

    public void setRequestDate(LocalDate requestDate) {
        this.requestDate = requestDate;
    }

    public String getAdditionalNotes() {
        return additionalNotes;
    }

    public void setAdditionalNotes(String additionalNotes) {
        this.additionalNotes = additionalNotes;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // =========================================================
    // UTILITY METHODS
    // =========================================================

    /**
     * Returns true if this request is marked as critical urgency.
     * Useful for highlighting in the UI.
     */
    public boolean isCritical() {
        return "Critical".equalsIgnoreCase(this.urgencyLevel);
    }

    /**
     * Returns true if the request is still pending.
     */
    public boolean isPending() {
        return "Pending".equalsIgnoreCase(this.status);
    }

    /**
     * Provides a readable string representation for debugging.
     */
    @Override
    public String toString() {
        return "BloodRequest{" +
                "requestId=" + requestId +
                ", patientName='" + patientName + '\'' +
                ", bloodGroup='" + bloodGroup + '\'' +
                ", hospitalName='" + hospitalName + '\'' +
                ", urgencyLevel='" + urgencyLevel + '\'' +
                ", requestDate=" + requestDate +
                ", status='" + status + '\'' +
                '}';
    }
}
