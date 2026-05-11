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
    //  LOGIN (by email + password)
    // ──────────────────────────────────────────────────────────────

    /**
     * Validates login using email and password.
     * Returns: 1=admin, 2=user, 0=email not found, 3=wrong password, -1=DB error
     */
    public int validateLogin(String email, String enteredPassword) {
        final String SELECT_USER_LOGIN =
            "SELECT user_id, password, role FROM users WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(SELECT_USER_LOGIN)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return 0; // email not found
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
    //  GET USER ID BY EMAIL (needed to set session after login)
    // ──────────────────────────────────────────────────────────────

    /**
     * Fetches the userId for a given email.
     * Returns null if not found.
     */
    public String getUserIdByEmail(String email) {
        final String SELECT_USERID_BY_EMAIL =
            "SELECT user_id FROM users WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(SELECT_USERID_BY_EMAIL)) {
            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("user_id");
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return null;
    }

    // ──────────────────────────────────────────────────────────────
    //  REGISTER
    // ──────────────────────────────────────────────────────────────

    /**
     * Inserts a new user. Password must already be hashed.
     * Role is always forced to "user" — admin can only be set via DB.
     * Returns: 1=success, 0=insert failed, -1=DB error
     */
    public int insertUser(UsersModel user) {
        final String INSERT_USER =
            "INSERT INTO users (user_id, full_name, email, phone_number, password, role) " +
            "VALUES (?, ?, ?, ?, ?, 'user')";

        try (PreparedStatement ps = conn.prepareStatement(INSERT_USER)) {
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhoneNumber());
            ps.setString(5, user.getPassword()); // already hashed

            int rows = ps.executeUpdate();
            return rows > 0 ? 1 : 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return -1;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  FETCH USER BY ID
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
