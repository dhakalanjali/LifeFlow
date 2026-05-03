package com.lifeflow.lifeflow.model;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String bloodType;
    private String role;
    private String isApproved;
    private String createdAt;
    private String dateOfBirth;
    private String gender;
    private String address;

    // Default constructor
    public User() {}

    // Getters
    public int getUserId() { return userId; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getPhone() { return phone; }
    public String getBloodType() { return bloodType; }
    public String getRole() { return role; }
    public String getIsApproved() { return isApproved; }
    public String getCreatedAt() { return createdAt; }
    public String getDateOfBirth() { return dateOfBirth; }
    public String getGender() { return gender; }
    public String getAddress() { return address; }

    // Setters
    public void setUserId(int userId) { this.userId = userId; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }
    public void setRole(String role) { this.role = role; }
    public void setIsApproved(String isApproved) { this.isApproved = isApproved; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public void setGender(String gender) { this.gender = gender; }
    public void setAddress(String address) { this.address = address; }

    // Helper methods
    public boolean isAdmin() {
        return "admin".equals(role);
    }

    public boolean isPending() {
        return "pending".equals(isApproved);
    }

    public String getStatus() { return isApproved; }
    public void setStatus(String v) { isApproved = v; }

    public String getPasswordHash() { return password; }
    public void setPasswordHash(String v) { password = v; }
}