package com.lifeflow.lifeflow.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtil {

    // Method to encrypt password using MD5
    public static String encryptPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hashBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Method to check password during login
    public static boolean checkPassword(String inputPassword, String storedPassword) {
        String encryptedInput = encryptPassword(inputPassword);
        return encryptedInput != null && encryptedInput.equals(storedPassword);
    }
}