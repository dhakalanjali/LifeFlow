package com.lifeflow.lifeflow.service;

import com.lifeflow.lifeflow.dao.BloodStockDAO;
import com.lifeflow.lifeflow.model.BloodStock;

import java.util.List;

public class BloodService {

    private BloodStockDAO bloodStockDAO = new BloodStockDAO();

    // Get all blood stock
    public List<BloodStock> getAllBloodStock() {
        return bloodStockDAO.getAllBloodStock();
    }

    // Get stock by blood group
    public BloodStock getStockByBloodGroup(String bloodGroup) {
        return bloodStockDAO.getStockByBloodGroup(bloodGroup);
    }

    // Update blood units
    public boolean updateBloodUnits(String bloodGroup, int units) {
        if (units < 0) return false;
        return bloodStockDAO.updateUnits(bloodGroup, units);
    }

    // Check if blood is available
    public boolean isBloodAvailable(String bloodGroup) {
        BloodStock bs = bloodStockDAO.getStockByBloodGroup(bloodGroup);
        return bs != null && bs.getUnitsAvailable() > 0;
    }
}
