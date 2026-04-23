package controller.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import controller.DatabaseController;
import util.StringUtils;
/**
 * LoginServlet
 * Handles the POST request from login.jsp.
 * Reads the userID and password, validates them against the DB,
 * then either starts a session and redirects, or shows an error.
 */

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // One shared DatabaseController instance for this servlet
    private DatabaseController db = new DatabaseController();

    /**
     * doPost - triggered when the login form is submitted.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read what the user typed in the form
        String userId   = request.getParameter("userID").trim();
        String password = request.getParameter("password");

        // 2. Basic empty field check
        if (userId.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Please fill in both User ID and Password.");
            request.getRequestDispatcher(StringUtils.LOGIN_PAGE).forward(request, response);
            return;
        }

        // 3. Validate credentials against the database
        int result = db.validateLogin(userId, password);

        if (result == 1) {
            // ── Admin login ──────────────────────────────────────
            HttpSession session = request.getSession();
            session.setAttribute(StringUtils.SESSION_USER_ID,  userId);
            session.setAttribute(StringUtils.SESSION_IS_ADMIN, true);
            // Send admin to the admin dashboard
            response.sendRedirect(request.getContextPath() + StringUtils.ADMIN_PAGE);

        } else if (result == 2) {
        	 // ── Normal user login ────────────────────────────────
            HttpSession session = request.getSession();
            session.setAttribute(StringUtils.SESSION_USER_ID,  userId);
            session.setAttribute(StringUtils.SESSION_IS_ADMIN, false);
            // Send user to home page via servlet so products load
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

    /**
     * doGet - if someone navigates to /LoginServlet in the browser,
     * just redirect them to the login page.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + StringUtils.LOGIN_PAGE);
    }
}
