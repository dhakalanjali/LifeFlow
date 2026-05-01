package com.lifeflow.lifeflow.model;

public class BloodStock {

    private int stockId;
    private String bloodGroup;
    private int unitsAvailable;

    public BloodStock() {}

    public BloodStock(int stockId, String bloodGroup, int unitsAvailable) {
        this.stockId = stockId;
        this.bloodGroup = bloodGroup;
        this.unitsAvailable = unitsAvailable;
    }

    // Getters
    public int getStockId() { return stockId; }
    public String getBloodGroup() { return bloodGroup; }
    public int getUnitsAvailable() { return unitsAvailable; }

    // Setters
    public void setStockId(int stockId) { this.stockId = stockId; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public void setUnitsAvailable(int unitsAvailable) { this.unitsAvailable = unitsAvailable; }
}
