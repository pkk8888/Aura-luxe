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
 * Each method opens its own connection and closes it when done.
 * More methods will be added as we build each page.
 */
public class DatabaseController {

    // ── Open a database connection ─────────────────────────────────
    /**
     * Opens and returns a fresh MySQL connection.
     * Throws exception if driver or URL is wrong.
     */
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
     * Checks the entered User ID and password against the database.
     *
     * Returns:
     *   1  = valid login, role is admin
     *   2  = valid login, role is user
     *   0  = user ID not found in database
     *   3  = user ID found but password is wrong
     *  -1  = database or server error
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

                // Decrypt stored password and compare with what user typed
                String decryptedPassword = PasswordUtil.decrypt(storedEncrypted, userId);

                if (decryptedPassword != null && decryptedPassword.equals(enteredPassword)) {
                    // Password matches - check role
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
            return -1; // server error
        }
    }

    // ══════════════════════════════════════════════════════════════
    //  GET USER BY ID
    // ══════════════════════════════════════════════════════════════

    /**
     * Fetches one user's full details from the database by their user_id.
     * Used after login to store the user object in the session.
     * Returns null if user is not found.
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

    // ══════════════════════════════════════════════════════════════
    //  CHECK DUPLICATE  (ready for register page)
    // ══════════════════════════════════════════════════════════════

    /**
     * Runs any SELECT query that checks if a value already exists.
     * Returns true if a matching row is found (= duplicate exists).
     * Used to check user_id, email, and phone before registering.
     */
    public boolean isDuplicate(String value, String sqlQuery) {

        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sqlQuery)) {

            st.setString(1, value);

            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
