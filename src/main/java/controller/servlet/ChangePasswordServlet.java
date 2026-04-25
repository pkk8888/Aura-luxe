package controller.servlet;

import controller.DatabaseController;
import controller.PasswordUtil;
import model.UsersModel;
import util.StringUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * ChangePasswordServlet
 * POST /ChangePasswordServlet
 * Verifies current password, then updates to the new one (encrypted).
 */
public class ChangePasswordServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String userId          = (String) session.getAttribute(StringUtils.SESSION_USER_ID);
        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // ── Validate inputs ───────────────────────────────────────
        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword     == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {
            req.setAttribute("errorMsg", "All fields are required.");
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            req.setAttribute("errorMsg", "New passwords do not match.");
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        if (newPassword.length() < 6) {
            req.setAttribute("errorMsg", "New password must be at least 6 characters.");
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        // ── Verify current password ───────────────────────────────
        int loginResult = db.validateLogin(userId, currentPassword);
        if (loginResult == 3 || loginResult == 0) {
            req.setAttribute("errorMsg", "Current password is incorrect.");
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }
        if (loginResult == -1) {
            req.setAttribute("errorMsg", StringUtils.ERR_SERVER);
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        // ── Encrypt new password and save ─────────────────────────
        String encryptedNew = PasswordUtil.encrypt(newPassword, userId);
        if (encryptedNew == null) {
            req.setAttribute("errorMsg", "Could not encrypt the new password. Please try again.");
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.UPDATE_USER_PASSWORD)) {
            ps.setString(1, encryptedNew);
            ps.setString(2, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", StringUtils.ERR_SERVER);
            req.getRequestDispatcher("/pages/change-password.jsp").forward(req, resp);
            return;
        }

        // ── Success: forward to profile with message ──────────────
        UsersModel user = db.getUserById(userId);
        if (user != null) {
            req.setAttribute("fullName", user.getFullName());
            req.setAttribute("email",    user.getEmail());
            req.setAttribute("phone",    user.getPhoneNumber());
            req.setAttribute("address",  user.getAddress());
        }
        req.setAttribute("successMsg", "Password changed successfully!");
        req.getRequestDispatcher("/pages/profile.jsp").forward(req, resp);
    }
}
