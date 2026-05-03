package com.lifeflow.lifeflow.service;

import com.lifeflow.lifeflow.dao.BloodRequestDAO;
import com.lifeflow.lifeflow.model.BloodRequest;

import java.util.*;
import java.util.stream.Collectors;

public class DonationService {

    private final BloodRequestDAO bloodRequestDAO;
    private static final Map<String, Integer> BLOOD_STOCK = Collections.synchronizedMap(new LinkedHashMap<>());

    static {
        BLOOD_STOCK.put("A+",  45);
        BLOOD_STOCK.put("A-",  12);
        BLOOD_STOCK.put("B+",  38);
        BLOOD_STOCK.put("B-",   8);
        BLOOD_STOCK.put("AB+", 22);
        BLOOD_STOCK.put("AB-",  5);
        BLOOD_STOCK.put("O+",  60);
        BLOOD_STOCK.put("O-",  18);
    }

    public DonationService() {
        this.bloodRequestDAO = new BloodRequestDAO();
    }

    public boolean submitBloodRequest(BloodRequest request) {
        if (!isValidRequest(request)) return false;
        return bloodRequestDAO.insertRequest(request);
    }

    private boolean isValidRequest(BloodRequest request) {
        return request != null && 
               request.getPatientName() != null && !request.getPatientName().trim().isEmpty() &&
               request.getBloodGroup() != null &&
               request.getHospitalName() != null &&
               request.getRequestDate() != null;
    }

    public List<BloodRequest> getAllRequestsForReport() {
        return bloodRequestDAO.getAllRequests();
    }

    public List<BloodRequest> getPendingRequests() {
        return bloodRequestDAO.getAllRequests().stream()
                  .filter(BloodRequest::isPending)
                  .collect(Collectors.toList());
    }

    public Map<String, Integer> getBloodStockLevels() {
        return Collections.unmodifiableMap(BLOOD_STOCK);
    }
}
