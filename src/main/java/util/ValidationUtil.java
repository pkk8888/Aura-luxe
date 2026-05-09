package util;

import java.util.regex.Pattern;
import jakarta.servlet.http.Part;

public class ValidationUtil {

    // 1. Validate if a field is null or empty
    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // 2. Validate if a string contains only letters and spaces (for full name)
    public static boolean isValidFullName(String value) {
        return value != null && value.matches("^[a-zA-Z ]+$");
    }

    // 3. Validate if a User ID is at least 6 characters
    public static boolean isValidUserId(String userId) {
        return userId != null && userId.trim().length() >= 6;
    }

    // 4. Validate if a string is a valid email address
    public static boolean isValidEmail(String email) {
        String emailRegex = "^[\\w.-]+@([\\w-]+\\.)+[\\w-]{2,4}$";
        return email != null && Pattern.matches(emailRegex, email);
    }

    // 5. Validate if a phone number is exactly 10 digits
    public static boolean isValidPhoneNumber(String number) {
        return number != null && number.matches("^\\d{10}$");
    }

    // 6. Validate password strength:
    //    at least 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special character
    public static boolean isValidPassword(String password) {
        String passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$!%*?&])[A-Za-z\\d@#$!%*?&]{8,}$";
        return password != null && password.matches(passwordRegex);
    }

    // 7. Validate if password and confirm password match
    public static boolean doPasswordsMatch(String password, String confirmPassword) {
        return password != null && password.equals(confirmPassword);
    }

    // 8. Validate if a Part's file extension matches image extensions
    public static boolean isValidImageExtension(Part imagePart) {
        if (imagePart == null || isNullOrEmpty(imagePart.getSubmittedFileName())) {
            return false;
        }
        String fileName = imagePart.getSubmittedFileName().toLowerCase();
        return fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")
            || fileName.endsWith(".png") || fileName.endsWith(".gif");
    }

    // 9. Validate if a quantity is a positive integer
    public static boolean isPositiveInteger(String value) {
        try {
            return value != null && Integer.parseInt(value) > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
