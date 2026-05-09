package controller.servlet;

import dao.Userdao;
import model.UsersModel;
import util.PasswordUtil;
import util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Userdao userDAO = new Userdao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId          = (String) session.getAttribute("userID");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // ── Validate inputs ───────────────────────────────────────
        if (ValidationUtil.isNullOrEmpty(currentPassword) ||
            ValidationUtil.isNullOrEmpty(newPassword)     ||
            ValidationUtil.isNullOrEmpty(confirmPassword)) {
            request.setAttribute("errorMsg", "All fields are required.");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.doPasswordsMatch(newPassword, confirmPassword)) {
            request.setAttribute("errorMsg", "New passwords do not match.");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidPassword(newPassword)) {
            request.setAttribute("errorMsg",
                "New password must be at least 8 characters and include uppercase, " +
                "lowercase, a number, and a special character (@#$!%*?&).");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }

        // ── Verify current password via DAO ───────────────────────
        int loginResult = userDAO.validateLogin(userId, currentPassword);
        if (loginResult == 3 || loginResult == 0) {
            request.setAttribute("errorMsg", "Current password is incorrect.");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }
        if (loginResult == -1) {
            request.setAttribute("errorMsg", "A server error occurred. Please try again.");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }

        // ── Hash new password and save via DAO ────────────────────
        String hashedNew = PasswordUtil.getHashPassword(newPassword);
        boolean saved    = userDAO.updatePassword(userId, hashedNew);

        if (!saved) {
            request.setAttribute("errorMsg", "Could not update password. Please try again.");
            request.getRequestDispatcher("/pages/change-password.jsp").forward(request, response);
            return;
        }

        // ── Success: forward to profile with message ──────────────
        UsersModel user = userDAO.getUserById(userId);
        if (user != null) {
            request.setAttribute("fullName", user.getFullName());
            request.setAttribute("email",    user.getEmail());
            request.setAttribute("phone",    user.getPhoneNumber());
            request.setAttribute("address",  user.getAddress());
        }
        request.setAttribute("successMsg", "Password changed successfully!");
        request.getRequestDispatcher("/pages/profile.jsp").forward(request, response);
    }
}
