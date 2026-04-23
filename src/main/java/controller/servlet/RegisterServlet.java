package controller.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import controller.DatabaseController;
import controller.PasswordUtil;
import model.UsersModel;
import util.StringUtils;

/**
 * RegisterServlet
 * Handles POST from register.jsp.
 * Validates all fields, checks duplicates,
 * encrypts password, then saves the new user.
 */

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DatabaseController db = new DatabaseController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Read all form fields ────────────────────────────────
        String userId      = request.getParameter("userID");
        String fullName    = request.getParameter("fullName");
        String email       = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String password    = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");
        String role        = request.getParameter("role");

        // ── 2. Null safety - trim all fields ──────────────────────
        userId      = (userId      != null) ? userId.trim()      : "";
        fullName    = (fullName    != null) ? fullName.trim()    : "";
        email       = (email       != null) ? email.trim()       : "";
        phoneNumber = (phoneNumber != null) ? phoneNumber.trim() : "";
        password    = (password    != null) ? password           : "";
        confirmPass = (confirmPass != null) ? confirmPass        : "";
        role        = (role        != null) ? role.trim()        : "user";

        // ── 3. Check no field is empty ─────────────────────────────
        if (userId.isEmpty() || fullName.isEmpty() || email.isEmpty()
                || phoneNumber.isEmpty() || password.isEmpty() || confirmPass.isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required. Please fill in every field.");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 4. Full name must have letters and spaces only ─────────
        if (!fullName.matches("[a-zA-Z ]+")) {
            request.setAttribute("errorMessage",
                "Full name must contain letters only. Numbers and symbols are not allowed.");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 5. User ID must be at least 6 characters ──────────────
        if (userId.length() < 6) {
            request.setAttribute("errorMessage",
                "User ID must be at least 6 characters long.");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 6. Email format validation ─────────────────────────────
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            request.setAttribute("errorMessage",
                "Please enter a valid email address. Example: name@email.com");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 7. Phone number must be exactly 10 digits ──────────────
        if (!phoneNumber.matches("\\d{10}")) {
            request.setAttribute("errorMessage",
                "Phone number must be exactly 10 digits. No spaces, dashes or symbols.");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 8. Password strength check ─────────────────────────────
        // Must be at least 8 characters and contain:
        // uppercase letter, lowercase letter, digit, special character
        if (!password.matches(
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@#$!%*?&])[A-Za-z\\d@#$!%*?&]{8,}$")) {
            request.setAttribute("errorMessage",
                "Password must be at least 8 characters and must include: "
                + "one uppercase letter, one lowercase letter, one number, "
                + "and one special character (@#$!%*?&).");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 9. Passwords must match ────────────────────────────────
        if (!password.equals(confirmPass)) {
            request.setAttribute("errorMessage", StringUtils.ERR_PASSWORD_MISMATCH);
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 10. Check duplicate User ID ────────────────────────────
        if (db.isDuplicate(userId, StringUtils.CHECK_DUP_USERID)) {
            request.setAttribute("errorMessage", StringUtils.ERR_DUP_USERID);
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 11. Check duplicate email ──────────────────────────────
        if (db.isDuplicate(email, StringUtils.CHECK_DUP_EMAIL)) {
            request.setAttribute("errorMessage", StringUtils.ERR_DUP_EMAIL);
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 12. Check duplicate phone number ───────────────────────
        if (db.isDuplicate(phoneNumber, StringUtils.CHECK_DUP_PHONE)) {
            request.setAttribute("errorMessage", StringUtils.ERR_DUP_PHONE);
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 13. Encrypt the password before saving to database ─────
        String encryptedPassword = PasswordUtil.encrypt(password, userId);
        if (encryptedPassword == null) {
            request.setAttribute("errorMessage", StringUtils.ERR_SERVER);
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
            return;
        }

        // ── 14. Build UsersModel and save to database ──────────────
        UsersModel newUser = new UsersModel(
            userId, fullName, email, encryptedPassword, phoneNumber, role
        );

        int result = db.registerUser(newUser);

        if (result == 1) {
            // Registration successful - go to login page with success message
            response.sendRedirect(
                request.getContextPath() + StringUtils.LOGIN_PAGE + "?registered=true"
            );
        } else {
            // Something went wrong with the insert
            request.setAttribute("errorMessage",
                "Registration failed. Please try again.");
            request.getRequestDispatcher(StringUtils.REGISTER_PAGE).forward(request, response);
        }
    }

    // If someone goes to /RegisterServlet directly, send to register page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + StringUtils.REGISTER_PAGE);
    }
}
