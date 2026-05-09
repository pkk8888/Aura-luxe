package controller.servlet;

import dao.Userdao;
import model.UsersModel;
import util.PasswordUtil;
import util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Userdao userDAO = new Userdao();

    private static final String CHECK_DUP_USERID = "SELECT user_id FROM users WHERE user_id = ?";
    private static final String CHECK_DUP_EMAIL  = "SELECT user_id FROM users WHERE email = ?";
    private static final String CHECK_DUP_PHONE  = "SELECT user_id FROM users WHERE phone_number = ?";

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
        String address     = request.getParameter("address");

        // ── 2. Null safety ─────────────────────────────────────────
        userId      = (userId      != null) ? userId.trim()      : "";
        fullName    = (fullName    != null) ? fullName.trim()    : "";
        email       = (email       != null) ? email.trim()       : "";
        phoneNumber = (phoneNumber != null) ? phoneNumber.trim() : "";
        password    = (password    != null) ? password           : "";
        confirmPass = (confirmPass != null) ? confirmPass        : "";
        role        = (role        != null) ? role.trim()        : "user";

        // ── 3. Empty field check ───────────────────────────────────
        if (ValidationUtil.isNullOrEmpty(userId)   || ValidationUtil.isNullOrEmpty(fullName) ||
            ValidationUtil.isNullOrEmpty(email)    || ValidationUtil.isNullOrEmpty(phoneNumber) ||
            ValidationUtil.isNullOrEmpty(password) || ValidationUtil.isNullOrEmpty(confirmPass)) {
            sendError(request, response, "All fields are required. Please fill in every field.");
            return;
        }

        // ── 4. Full name must contain only letters and spaces ──────
        if (!ValidationUtil.isValidFullName(fullName)) {
            sendError(request, response, "Full name must contain letters only. Numbers and symbols are not allowed.");
            return;
        }

        // ── 5. User ID must be at least 6 characters ──────────────
        if (!ValidationUtil.isValidUserId(userId)) {
            sendError(request, response, "User ID must be at least 6 characters long.");
            return;
        }

        // ── 6. Email format ────────────────────────────────────────
        if (!ValidationUtil.isValidEmail(email)) {
            sendError(request, response, "Please enter a valid email address. Example: name@email.com");
            return;
        }

        // ── 7. Phone number must be exactly 10 digits ──────────────
        if (!ValidationUtil.isValidPhoneNumber(phoneNumber)) {
            sendError(request, response, "Phone number must be exactly 10 digits. No spaces, dashes or symbols.");
            return;
        }

        // ── 8. Password strength ───────────────────────────────────
        if (!ValidationUtil.isValidPassword(password)) {
            sendError(request, response,
                "Password must be at least 8 characters and must include: " +
                "one uppercase letter, one lowercase letter, one number, " +
                "and one special character (@#$!%*?&).");
            return;
        }

        // ── 9. Passwords must match ────────────────────────────────
        if (!ValidationUtil.doPasswordsMatch(password, confirmPass)) {
            sendError(request, response, "Passwords do not match. Please try again.");
            return;
        }

        // ── 10. Duplicate checks via DAO ───────────────────────────
        if (userDAO.isDuplicate(userId, CHECK_DUP_USERID)) {
            sendError(request, response, "That User ID is already taken. Please choose another.");
            return;
        }
        if (userDAO.isDuplicate(email, CHECK_DUP_EMAIL)) {
            sendError(request, response, "An account with that email already exists.");
            return;
        }
        if (userDAO.isDuplicate(phoneNumber, CHECK_DUP_PHONE)) {
            sendError(request, response, "An account with that phone number already exists.");
            return;
        }

        // ── 11. Hash password before saving ───────────────────────
        String hashedPassword = PasswordUtil.getHashPassword(password);

        // ── 12. Build model and save via DAO ───────────────────────
        UsersModel newUser = new UsersModel(
            userId, fullName, email, hashedPassword, phoneNumber, role, address
        );

        int result = userDAO.insertUser(newUser);

        if (result == 1) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?registered=true");
        } else {
            sendError(request, response, "Registration failed. Please try again.");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/register.jsp");
    }

    private void sendError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
    }
}
