package com.lifeflow.lifeflow.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil.java
 * Author: Angely Dhakal
 * Utility class for password encryption and verification using BCrypt.
 * BCrypt is used instead of MD5 as it includes built-in salting and
 * is resistant to brute-force attacks.
 */
public class PasswordUtil {

    // Number of salt rounds - higher = more secure but slower
    // 12 is the recommended value for production
    private static final int SALT_ROUNDS = 12;

    /**
     * Encrypts a plain text password using BCrypt hashing.
     * BCrypt automatically generates a salt and includes it in the hash.
     * @param password - plain text password from user
     * @return BCrypt hashed password (60 character string)
     */
    public static String encryptPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(SALT_ROUNDS));
    }

    /**
     * Verifies a plain text password against a stored BCrypt hash.
     * @param inputPassword - plain text password entered by user
     * @param storedPassword - BCrypt hash stored in database
     * @return true if passwords match, false otherwise
     */
    public static boolean checkPassword(String inputPassword, String storedPassword) {
        if (inputPassword == null || storedPassword == null) {
            return false;
        }
        return BCrypt.checkpw(inputPassword, storedPassword);
    }
}