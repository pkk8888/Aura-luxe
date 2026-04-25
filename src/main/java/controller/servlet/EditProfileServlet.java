package controller.servlet;

import controller.DatabaseController;
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
 * EditProfileServlet
 * GET  /EditProfileServlet — loads user data and forwards to edit-profile.jsp
 * POST /EditProfileServlet — saves updated fullName + address, redirects to profile
 */
public class EditProfileServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

    // ── GET: load current data into the edit form ─────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String userId = (String) session.getAttribute(StringUtils.SESSION_USER_ID);
        UsersModel user = db.getUserById(userId);

        if (user != null) {
            req.setAttribute("fullName", user.getFullName());
            req.setAttribute("email",    user.getEmail());
            req.setAttribute("phone",    user.getPhoneNumber());
            req.setAttribute("address",  user.getAddress());
        }

        req.getRequestDispatcher("/pages/edit-profile.jsp").forward(req, resp);
    }

    // ── POST: save changes ────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String userId  = (String) session.getAttribute(StringUtils.SESSION_USER_ID);
        String fullName = req.getParameter("fullName");
        String address  = req.getParameter("address");

        if (fullName == null || fullName.trim().isEmpty()) {
            // Reload form with error
            UsersModel user = db.getUserById(userId);
            if (user != null) {
                req.setAttribute("fullName", user.getFullName());
                req.setAttribute("email",    user.getEmail());
                req.setAttribute("phone",    user.getPhoneNumber());
                req.setAttribute("address",  user.getAddress());
            }
            req.setAttribute("errorMsg", "Full name cannot be empty.");
            req.getRequestDispatcher("/pages/edit-profile.jsp").forward(req, resp);
            return;
        }

        // Update in DB
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.UPDATE_USER_PROFILE)) {
            ps.setString(1, fullName.trim());
            ps.setString(2, address != null ? address.trim() : "");
            ps.setString(3, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", StringUtils.ERR_SERVER);
            req.getRequestDispatcher("/pages/edit-profile.jsp").forward(req, resp);
            return;
        }

        // Update session so navbar shows new name immediately
        session.setAttribute("fullName", fullName.trim());

        // Forward to profile page with success message
        req.setAttribute("successMsg", "Profile updated successfully!");
        // Re-load fresh data for profile.jsp
        UsersModel updated = db.getUserById(userId);
        if (updated != null) {
            req.setAttribute("fullName", updated.getFullName());
            req.setAttribute("email",    updated.getEmail());
            req.setAttribute("phone",    updated.getPhoneNumber());
            req.setAttribute("address",  updated.getAddress());
        }
        req.getRequestDispatcher("/pages/profile.jsp").forward(req, resp);
    }
}
