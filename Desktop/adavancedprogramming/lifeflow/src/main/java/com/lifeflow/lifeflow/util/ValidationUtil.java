package com.lifeflow.lifeflow.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final String EMAIL_PATTERN = "^[A-Za-z0-9+_.-]+@(.+)$";
    private static final String PHONE_PATTERN = "^[0-9]{10}$";

    public static boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        if (isNullOrEmpty(email)) return false;
        return Pattern.matches(EMAIL_PATTERN, email);
    }

    public static boolean isValidPhone(String phone) {
        if (isNullOrEmpty(phone)) return false;
        return Pattern.matches(PHONE_PATTERN, phone);
    }
    
    public static boolean isValidBloodGroup(String bg) {
        if (isNullOrEmpty(bg)) return false;
        String[] validGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};
        for (String group : validGroups) {
            if (group.equalsIgnoreCase(bg.trim())) {
                return true;
            }
        }
        return false;
    }
}
