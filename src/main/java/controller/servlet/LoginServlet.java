package controller.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import controller.DatabaseController;
import model.UsersModel;
import util.StringUtils;

/**
 * LoginServlet
 * Handles the POST request from login.jsp.
 * Reads the userID and password, validates them against the DB,
 * then either starts a session and redirects, or shows an error.
 */
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DatabaseController db = new DatabaseController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read form fields
        String userId   = request.getParameter("userID").trim();
        String password = request.getParameter("password");

        // 2. Basic empty field check
        if (userId.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in both User ID and Password.");
            request.getRequestDispatcher(StringUtils.LOGIN_PAGE).forward(request, response);
            return;
        }

        // 3. Validate credentials
        int result = db.validateLogin(userId, password);

        if (result == 1) {
            // ── Admin login ──────────────────────────────────────
            HttpSession session = request.getSession();
            session.setAttribute(StringUtils.SESSION_USER_ID,  userId);
            session.setAttribute(StringUtils.SESSION_IS_ADMIN, true);

            // Fetch full name for admin too
            UsersModel admin = db.getUserById(userId);
            if (admin != null && admin.getFullName() != null) {
                session.setAttribute("fullName", admin.getFullName());
            }

            response.sendRedirect(request.getContextPath() + StringUtils.ADMIN_PAGE);

        } else if (result == 2) {
            // ── Normal user login ────────────────────────────────
            HttpSession session = request.getSession();
            session.setAttribute(StringUtils.SESSION_USER_ID,  userId);
            session.setAttribute(StringUtils.SESSION_IS_ADMIN, false);

            // ✅ Fetch and store full name so navbar shows it
            UsersModel user = db.getUserById(userId);
            if (user != null && user.getFullName() != null) {
                session.setAttribute("fullName", user.getFullName());
            }

            response.sendRedirect(request.getContextPath() + StringUtils.HOME_PAGE);

        } else if (result == 0) {
            // ── User ID does not exist ───────────────────────────
            request.setAttribute("errorMessage", StringUtils.ERR_USER_NOT_FOUND);
            request.getRequestDispatcher(StringUtils.LOGIN_PAGE).forward(request, response);

        } else if (result == 3) {
            // ── Wrong password ───────────────────────────────────
            request.setAttribute("errorMessage", StringUtils.ERR_INVALID_LOGIN);
            request.getRequestDispatcher(StringUtils.LOGIN_PAGE).forward(request, response);

        } else {
            // ── Server or DB error ───────────────────────────────
            request.setAttribute("errorMessage", StringUtils.ERR_SERVER);
            request.getRequestDispatcher(StringUtils.LOGIN_PAGE).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + StringUtils.LOGIN_PAGE);
    }
}
