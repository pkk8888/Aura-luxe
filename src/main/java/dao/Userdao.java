package dao;

import model.UsersModel;
import util.DBConfig;
import util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Userdao {

    private Connection conn;
    private boolean isConnectionError = false;

    public Userdao() {
        try {
            conn = DBConfig.getConnection();
        } catch (SQLException | ClassNotFoundException ex) {
            isConnectionError = true;
            System.out.println(ex.getLocalizedMessage());
        }
    }

    public boolean isConnectionError() {
        return isConnectionError;
    }

    // ──────────────────────────────────────────────────────────────
    //  LOGIN
    // ──────────────────────────────────────────────────────────────

    /**
     * Validates login credentials.
     * Returns: 1=admin, 2=user, 0=user not found, 3=wrong password, -1=DB error
     */
    public int validateLogin(String userId, String enteredPassword) {
        final String SELECT_USER_LOGIN =
            "SELECT user_id, password, role FROM users WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(SELECT_USER_LOGIN)) {
            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return 0; // user not found
                }

                String hashedPassword = rs.getString("password");
                String role           = rs.getString("role");

                if (PasswordUtil.checkPassword(enteredPassword, hashedPassword)) {
                    return "admin".equalsIgnoreCase(role) ? 1 : 2;
                } else {
                    return 3; // wrong password
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return -1;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  REGISTER
    // ──────────────────────────────────────────────────────────────

    /**
     * Inserts a new user. Password inside UsersModel must already be hashed.
     * Returns: 1=success, 0=insert failed, -1=DB error
     */
    public int insertUser(UsersModel user) {
        final String INSERT_USER =
            "INSERT INTO users (user_id, full_name, email, phone_number, password, role) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(INSERT_USER)) {
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getPassword()); // already hashed
            ps.setString(6, user.getRole());

            int rows = ps.executeUpdate();
            return rows > 0 ? 1 : 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return -1;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  FETCH USER
    // ──────────────────────────────────────────────────────────────

    /**
     * Fetches one user's full profile by userId.
     * Returns null if no user is found.
     */
    public UsersModel getUserById(String userId) {
        final String SELECT_USER_BY_ID = "SELECT * FROM users WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(SELECT_USER_BY_ID)) {
            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UsersModel user = new UsersModel();
                    user.setUserId(rs.getString("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setRole(rs.getString("role"));
                    user.setAddress(rs.getString("address"));
                    return user;
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return null;
    }

    // ──────────────────────────────────────────────────────────────
    //  DUPLICATE CHECK
    // ──────────────────────────────────────────────────────────────

    /**
     * Checks if a value already exists using the provided SQL query.
     * Returns true if a duplicate is found.
     */
    public boolean isDuplicate(String value, String sqlQuery) {
        try (PreparedStatement ps = conn.prepareStatement(sqlQuery)) {
            ps.setString(1, value);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  UPDATE PROFILE
    // ──────────────────────────────────────────────────────────────

    /**
     * Updates a user's full name and address.
     * Returns true on success.
     */
    public boolean updateProfile(String userId, String fullName, String address) {
        final String UPDATE_USER_PROFILE =
            "UPDATE users SET full_name = ?, address = ? WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(UPDATE_USER_PROFILE)) {
            ps.setString(1, fullName);
            ps.setString(2, address);
            ps.setString(3, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  UPDATE PASSWORD
    // ──────────────────────────────────────────────────────────────

    /**
     * Updates a user's password (must already be hashed before calling).
     * Returns true on success.
     */
    public boolean updatePassword(String userId, String hashedPassword) {
        final String UPDATE_USER_PASSWORD =
            "UPDATE users SET password = ? WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(UPDATE_USER_PASSWORD)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, userId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }
}
