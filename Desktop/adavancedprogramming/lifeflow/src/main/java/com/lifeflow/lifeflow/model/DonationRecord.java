package com.lifeflow.lifeflow.model;

import java.time.LocalDate;

public class DonationRecord {
    private int id;
    private int donorId;
    private int campId;
    private String bloodGroup;
    private int quantity; // in ml
    private LocalDate donationDate;

    public DonationRecord() {
    }

    public DonationRecord(int id, int donorId, int campId, String bloodGroup, int quantity, LocalDate donationDate) {
        this.id = id;
        this.donorId = donorId;
        this.campId = campId;
        this.bloodGroup = bloodGroup;
        this.quantity = quantity;
        this.donationDate = donationDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDonorId() {
        return donorId;
    }

    public void setDonorId(int donorId) {
        this.donorId = donorId;
    }

    public int getCampId() {
        return campId;
    }

    public void setCampId(int campId) {
        this.campId = campId;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public LocalDate getDonationDate() {
        return donationDate;
    }

    public void setDonationDate(LocalDate donationDate) {
        this.donationDate = donationDate;
    }
}
