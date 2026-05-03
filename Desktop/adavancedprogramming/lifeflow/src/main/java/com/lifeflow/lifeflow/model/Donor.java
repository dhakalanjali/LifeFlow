package com.lifeflow.lifeflow.model;

public class Donor {

    private int donorId;
    private int userId;
    private String bloodType;
    private String address;
    private String dateOfBirth;
    private String lastDonationDate;
    private String isEligible;

    // Default constructor
    public Donor() {}

    // Getters
    public int getDonorId() { return donorId; }
    public int getUserId() { return userId; }
    public String getBloodType() { return bloodType; }
    public String getAddress() { return address; }
    public String getDateOfBirth() { return dateOfBirth; }
    public String getLastDonationDate() { return lastDonationDate; }
    public String getIsEligible() { return isEligible; }

    // Setters
    public void setDonorId(int donorId) { this.donorId = donorId; }
    public void setUserId(int userId) { this.userId = userId; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }
    public void setAddress(String address) { this.address = address; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public void setLastDonationDate(String lastDonationDate) { this.lastDonationDate = lastDonationDate; }
    public void setIsEligible(String isEligible) { this.isEligible = isEligible; }
}