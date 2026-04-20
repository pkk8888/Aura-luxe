package controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.UsersModel;
import util.StringUtils;

/**
 * DatabaseController
 * Handles all database operations for AuraLuxe.
 * Each method opens and closes its own connection safely.
 */
public class DatabaseController {

    // ── Open a database connection ─────────────────────────────────
    public Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName(StringUtils.DRIVER);
        return DriverManager.getConnection(
            StringUtils.CONN_URL,
            StringUtils.DB_USER,
            StringUtils.DB_PASS
        );
    }

    // ══════════════════════════════════════════════════════════════
    //  LOGIN
    // ══════════════════════════════════════════════════════════════

    /**
     * Validates login credentials against the database.
     * Returns:
     *   1  = valid admin
     *   2  = valid user
     *   0  = user ID not found
     *   3  = wrong password
     *  -1  = server or DB error
     */
    public int validateLogin(String userId, String enteredPassword) {
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(StringUtils.GET_USER_LOGIN)) {

            st.setString(1, userId);

            try (ResultSet rs = st.executeQuery()) {
                if (!rs.next()) {
                    return 0; // user not found
                }

                String storedEncrypted = rs.getString("password");
                String role            = rs.getString("role");

                // Decrypt the stored password and compare with entered password
                String decryptedPassword = PasswordUtil.decrypt(storedEncrypted, userId);

                if (decryptedPassword != null && decryptedPassword.equals(enteredPassword)) {
                    if (StringUtils.ROLE_ADMIN.equalsIgnoreCase(role)) {
                        return 1; // admin
                    } else {
                        return 2; // normal user
                    }
                } else {
                    return 3; // wrong password
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    // ══════════════════════════════════════════════════════════════
    //  REGISTER
    // ══════════════════════════════════════════════════════════════

    /**
     * Inserts a new user into the database.
     * The password inside the UsersModel must already be encrypted
     * before calling this method.
     * Returns:
     *   1  = inserted successfully
     *   0  = insert failed
     *  -1  = server or DB error
     */
    public int registerUser(UsersModel user) {
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(StringUtils.INSERT_USER)) {

            st.setString(1, user.getUserId());
            st.setString(2, user.getFullName());
            st.setString(3, user.getEmail());
            st.setString(4, user.getPhoneNumber());
            st.setString(5, user.getPassword()); // already encrypted
            st.setString(6, user.getRole());

            int rows = st.executeUpdate();
            return rows > 0 ? 1 : 0;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Checks if a value already exists in the database.
     * Used to prevent duplicate user_id, email, and phone number.
     * Returns true if a duplicate is found.
     */
    public boolean isDuplicate(String value, String sqlQuery) {
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sqlQuery)) {

            st.setString(1, value);

            try (ResultSet rs = st.executeQuery()) {
                return rs.next(); // true = duplicate found
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // ══════════════════════════════════════════════════════════════
    //  GET USER BY ID
    // ══════════════════════════════════════════════════════════════

    /**
     * Fetches one user's full profile details by their user_id.
     * Returns null if no user is found.
     */
    public UsersModel getUserById(String userId) {
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(StringUtils.GET_USER_BY_ID)) {

            st.setString(1, userId);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    UsersModel user = new UsersModel();
                    user.setUserId(rs.getString("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setRole(rs.getString("role"));
                    user.setAddress(rs.getString("address"));
                    user.setImgLink(rs.getString("img_link"));
                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
