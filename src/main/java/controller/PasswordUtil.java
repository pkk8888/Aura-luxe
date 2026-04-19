package controller;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.Base64;

/**
 * PasswordUtil
 * Encrypts and decrypts passwords using AES encryption.
 * The userId is used to build the secret key so each
 * user's password is encrypted differently.
 *
 * encrypt() is called during registration before saving to DB.
 * decrypt() is called during login to compare with entered password.
 */
public class PasswordUtil {

    private static final String ALGORITHM = "AES";

    /**
     * Builds a 16-byte AES key from the userId.
     * Pads with spaces if userId is shorter than 16 chars.
     * Trims to 16 chars if userId is longer.
     */
    private static SecretKeySpec buildKey(String userId) {
        String keyStr = String.format("%-16s", userId).substring(0, 16);
        return new SecretKeySpec(keyStr.getBytes(), ALGORITHM);
    }

    /**
     * Encrypts a plain-text password.
     * @param plainPassword  the password the user typed
     * @param userId         used to build the unique key
     * @return               Base64-encoded encrypted string, or null on failure
     */
    public static String encrypt(String plainPassword, String userId) {
        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, buildKey(userId));
            byte[] encrypted = cipher.doFinal(plainPassword.getBytes("UTF-8"));
            return Base64.getEncoder().encodeToString(encrypted);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Decrypts an encrypted password back to plain text.
     * @param encryptedPassword  the encrypted string from the database
     * @param userId             used to rebuild the same key
     * @return                   the original plain-text password, or null on failure
     */
    public static String decrypt(String encryptedPassword, String userId) {
        try {
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, buildKey(userId));
            byte[] decoded   = Base64.getDecoder().decode(encryptedPassword);
            byte[] decrypted = cipher.doFinal(decoded);
            return new String(decrypted, "UTF-8");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
