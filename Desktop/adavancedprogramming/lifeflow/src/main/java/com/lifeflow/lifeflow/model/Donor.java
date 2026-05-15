package com.lifeflow.lifeflow.model;

public class Donor {

    private int donorId;
    private int userId;
    private String lastDonationDate;
    private String isEligible;

    // Default constructor
    public Donor() {}

    // Parameterized constructor
    public Donor(int donorId, int userId, String lastDonationDate, String isEligible) {
        this.donorId = donorId;
        this.userId = userId;
        this.lastDonationDate = lastDonationDate;
        this.isEligible = isEligible;
    }

    // Getters
    public int getDonorId() { return donorId; }
    public int getUserId() { return userId; }
    public String getLastDonationDate() { return lastDonationDate; }
    public String getIsEligible() { return isEligible; }

    // Setters
    public void setDonorId(int donorId) { this.donorId = donorId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setLastDonationDate(String lastDonationDate) { this.lastDonationDate = lastDonationDate; }
    public void setIsEligible(String isEligible) { this.isEligible = isEligible; }
}