package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Best value is between 10 and 12 for time complexity and robustness
    // 2^COST times iteration for hashing, COST 10 and 11 means double iteration
    private final static int COST = 10;

    public static String getHashPassword(String inputPassword) {
        // Generate a salt with a default work factor
        String salt = BCrypt.gensalt(COST);
        // Hash the password with the generated salt
        return BCrypt.hashpw(inputPassword, salt);
    }

    public static boolean checkPassword(String passwordTyped, String hashedPassword) {
        return BCrypt.checkpw(passwordTyped, hashedPassword);
    }
}
