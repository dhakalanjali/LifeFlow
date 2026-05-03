package com.lifeflow.service;

import com.lifeflow.dao.BloodRequestDAO;
import com.lifeflow.model.BloodRequest;

import java.util.*;
import java.util.stream.Collectors;

/**
 * DonationService.java
 * Author: Pritam Rai
 * Module: Service / Business Logic Layer (MVC)
 * Description: Contains business logic for blood donation management,
 *              report generation, stock calculations, and statistics.
 *              Acts as the intermediary between the Servlet (Controller)
 *              and the DAO (Data Access Layer).
 * London Metropolitan University - Blood Bank Management System
 */
public class DonationService {

    // =========================================================
    // DEPENDENCIES
    // =========================================================

    /** DAO instance for database operations */
    private final BloodRequestDAO bloodRequestDAO;

    /**
     * Simulated blood stock levels (units available per blood group).
     * In a real system, this would be retrieved from a blood_stock table.
     * synchronizedMap used to prevent concurrent modification issues.
     */
    private static final Map<String, Integer> BLOOD_STOCK =
            Collections.synchronizedMap(new LinkedHashMap<>());

    static {
        // Initialise with sample stock values
        BLOOD_STOCK.put("A+",  45);
        BLOOD_STOCK.put("A-",  12);
        BLOOD_STOCK.put("B+",  38);
        BLOOD_STOCK.put("B-",   8);
        BLOOD_STOCK.put("AB+", 22);
        BLOOD_STOCK.put("AB-",  5);
        BLOOD_STOCK.put("O+",  60);
        BLOOD_STOCK.put("O-",  18);
    }

    /** Minimum safe stock threshold per blood group */
    private static final int LOW_STOCK_THRESHOLD = 10;

    // =========================================================
    // CONSTRUCTOR
    // =========================================================

    /**
     * Default constructor - creates a new BloodRequestDAO instance.
     */
    public DonationService() {
        this.bloodRequestDAO = new BloodRequestDAO();
    }

    /**
     * Constructor with dependency injection (useful for testing).
     *
     * @param bloodRequestDAO a pre-configured DAO instance
     */
    public DonationService(BloodRequestDAO bloodRequestDAO) {
        this.bloodRequestDAO = bloodRequestDAO;
    }

    // =========================================================
    // REQUEST SUBMISSION
    // =========================================================

    /**
     * Validates and submits a new blood request.
     * Performs server-side validation before passing to the DAO.
     *
     * @param request the BloodRequest to submit
     * @return true if submitted successfully, false if validation fails or DB error
     */
    public boolean submitBloodRequest(BloodRequest request) {
        // Server-side validation
        if (!isValidRequest(request)) {
            System.err.println("[DonationService] Blood request failed validation.");
            return false;
        }
        return bloodRequestDAO.insertRequest(request);
    }

    /**
     * Validates the required fields of a BloodRequest.
     *
     * @param request the BloodRequest to validate
     * @return true if all required fields are present and valid
     */
    public boolean isValidRequest(BloodRequest request) {
        if (request == null) return false;
        if (request.getPatientName() == null || request.getPatientName().trim().isEmpty()) return false;
        if (request.getBloodGroup() == null || request.getBloodGroup().trim().isEmpty()) return false;
        if (request.getHospitalName() == null || request.getHospitalName().trim().isEmpty()) return false;
        if (request.getContactNumber() == null || request.getContactNumber().trim().isEmpty()) return false;
        if (request.getUrgencyLevel() == null || request.getUrgencyLevel().trim().isEmpty()) return false;
        if (request.getRequestDate() == null) return false;
        return true;
    }

    // =========================================================
    // REPORT GENERATION
    // =========================================================

    /**
     * Retrieves all blood requests for the reports dashboard.
     *
     * @return List of all BloodRequest records
     */
    public List<BloodRequest> getAllRequestsForReport() {
        return bloodRequestDAO.getAllRequests();
    }

    /**
     * Retrieves only pending blood requests.
     * Useful for the admin dashboard to show outstanding work.
     *
     * @return List of BloodRequest objects with status "Pending"
     */
    public List<BloodRequest> getPendingRequests() {
        List<BloodRequest> all = bloodRequestDAO.getAllRequests();
        return all.stream()
                  .filter(BloodRequest::isPending)
                  .collect(Collectors.toList());
    }

    /**
     * Retrieves only critical blood requests.
     * Used to highlight urgent cases in the dashboard.
     *
     * @return List of BloodRequest objects with urgency "Critical"
     */
    public List<BloodRequest> getCriticalRequests() {
        List<BloodRequest> all = bloodRequestDAO.getAllRequests();
        return all.stream()
                  .filter(BloodRequest::isCritical)
                  .collect(Collectors.toList());
    }

    // =========================================================
    // STATISTICS METHODS
    // =========================================================

    /**
     * Returns the total number of blood requests in the system.
     *
     * @return total request count
     */
    public int getTotalRequestCount() {
        return bloodRequestDAO.getAllRequests().size();
    }

    /**
     * Returns the count of requests by a specific status.
     *
     * @param status the status to count (e.g., "Pending", "Fulfilled")
     * @return count of requests matching the given status
     */
    public long getRequestCountByStatus(String status) {
        return bloodRequestDAO.getAllRequests().stream()
                .filter(r -> status.equalsIgnoreCase(r.getStatus()))
                .count();
    }

    /**
     * Returns a map of blood group to request count.
     * Useful for generating bar charts or summary tables.
     *
     * @return Map where key = blood group, value = number of requests
     */
    public Map<String, Long> getRequestCountByBloodGroup() {
        List<BloodRequest> all = bloodRequestDAO.getAllRequests();
        Map<String, Long> countMap = new LinkedHashMap<>();

        // Initialise all blood groups with 0
        String[] groups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String g : groups) {
            countMap.put(g, 0L);
        }

        // Count requests per blood group
        for (BloodRequest r : all) {
            String group = r.getBloodGroup();
            countMap.put(group, countMap.getOrDefault(group, 0L) + 1);
        }

        return countMap;
    }

    // =========================================================
    // BLOOD STOCK CALCULATIONS
    // =========================================================

    /**
     * Returns the current blood stock levels for all blood groups.
     *
     * @return Map of blood group to available units
     */
    public Map<String, Integer> getBloodStockLevels() {
        return Collections.unmodifiableMap(BLOOD_STOCK);
    }

    /**
     * Returns the stock level for a specific blood group.
     *
     * @param bloodGroup the blood group to check (e.g., "O+")
     * @return number of units available, or 0 if not found
     */
    public int getStockForBloodGroup(String bloodGroup) {
        return BLOOD_STOCK.getOrDefault(bloodGroup, 0);
    }

    /**
     * Returns the total number of blood units across all groups.
     *
     * @return total units in stock
     */
    public int getTotalBloodUnits() {
        return BLOOD_STOCK.values().stream().mapToInt(Integer::intValue).sum();
    }

    /**
     * Returns a list of blood groups that are below the safe threshold.
     * Used to trigger low-stock alerts in the dashboard.
     *
     * @return List of blood group names with critically low stock
     */
    public List<String> getLowStockBloodGroups() {
        List<String> lowStock = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : BLOOD_STOCK.entrySet()) {
            if (entry.getValue() < LOW_STOCK_THRESHOLD) {
                lowStock.add(entry.getKey());
            }
        }
        return lowStock;
    }

    /**
     * Checks whether a specific blood group has sufficient stock
     * to fulfil a request.
     *
     * @param bloodGroup the blood group to check
     * @return true if stock is above the low threshold
     */
    public boolean isStockAvailable(String bloodGroup) {
        return getStockForBloodGroup(bloodGroup) >= LOW_STOCK_THRESHOLD;
    }

    // =========================================================
    // STATUS MANAGEMENT
    // =========================================================

    /**
     * Marks a blood request as fulfilled and decrements stock.
     * Combines status update with stock adjustment.
     *
     * @param requestId the ID of the request to fulfil
     * @return true if the operation was successful
     */
    public boolean fulfillRequest(int requestId) {
        BloodRequest request = bloodRequestDAO.getRequestById(requestId);
        if (request == null) {
            System.err.println("[DonationService] Request not found: " + requestId);
            return false;
        }

        // Check stock availability before fulfilling
        String bloodGroup = request.getBloodGroup();
        int currentStock = getStockForBloodGroup(bloodGroup);

        if (currentStock <= 0) {
            System.err.println("[DonationService] Insufficient stock for blood group: " + bloodGroup);
            return false;
        }

        // Update status in database
        boolean updated = bloodRequestDAO.updateRequestStatus(requestId, "Fulfilled");

        if (updated) {
            // Decrement stock (in a real system, this would update the DB)
            BLOOD_STOCK.put(bloodGroup, currentStock - 1);
        }

        return updated;
    }

    /**
     * Cancels a blood request by updating its status.
     *
     * @param requestId the ID of the request to cancel
     * @return true if cancellation was successful
     */
    public boolean cancelRequest(int requestId) {
        return bloodRequestDAO.updateRequestStatus(requestId, "Cancelled");
    }
}
