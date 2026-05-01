package com.lifeflow.lifeflow.model;

public class User {

    // Attributes
    private int userId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String bloodType;
    private String role;
    private String isApproved;

    // Constructor
    public User() {}

    public User(int userId, String fullName, String email,
                String password, String phone, String bloodType,
                String role, String isApproved) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.bloodType = bloodType;
        this.role = role;
        this.isApproved = isApproved;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getBloodType() { return bloodType; }
    public void setBloodType(String bloodType) { this.bloodType = bloodType; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getIsApproved() { return isApproved; }
    public void setIsApproved(String isApproved) { this.isApproved = isApproved; }
}