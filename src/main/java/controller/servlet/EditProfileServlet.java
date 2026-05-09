package controller.servlet;

import dao.Userdao;
import model.UsersModel;
import util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class EditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Userdao userDAO = new Userdao();

    // ── GET: load current data into the edit form ─────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userID");
        UsersModel user = userDAO.getUserById(userId);

        if (user != null) {
            request.setAttribute("fullName", user.getFullName());
            request.setAttribute("email",    user.getEmail());
            request.setAttribute("phone",    user.getPhoneNumber());
            request.setAttribute("address",  user.getAddress());
        }

        request.getRequestDispatcher("/pages/edit-profile.jsp").forward(request, response);
    }

    // ── POST: save changes via DAO ────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId  = (String) session.getAttribute("userID");
        String fullName = request.getParameter("fullName");
        String address  = request.getParameter("address");

        // Validate full name
        if (ValidationUtil.isNullOrEmpty(fullName)) {
            UsersModel user = userDAO.getUserById(userId);
            if (user != null) {
                request.setAttribute("fullName", user.getFullName());
                request.setAttribute("email",    user.getEmail());
                request.setAttribute("phone",    user.getPhoneNumber());
                request.setAttribute("address",  user.getAddress());
            }
            request.setAttribute("errorMsg", "Full name cannot be empty.");
            request.getRequestDispatcher("/pages/edit-profile.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidFullName(fullName)) {
            UsersModel user = userDAO.getUserById(userId);
            if (user != null) {
                request.setAttribute("fullName", user.getFullName());
                request.setAttribute("email",    user.getEmail());
                request.setAttribute("phone",    user.getPhoneNumber());
                request.setAttribute("address",  user.getAddress());
            }
            request.setAttribute("errorMsg", "Full name must contain letters only.");
            request.getRequestDispatcher("/pages/edit-profile.jsp").forward(request, response);
            return;
        }

        // Update via DAO
        boolean updated = userDAO.updateProfile(userId, fullName.trim(), address != null ? address.trim() : "");

        if (!updated) {
            request.setAttribute("errorMsg", "Could not update profile. Please try again.");
            request.getRequestDispatcher("/pages/edit-profile.jsp").forward(request, response);
            return;
        }

        // Update session so navbar shows new name immediately
        session.setAttribute("fullName", fullName.trim());

        // Reload fresh data and forward to profile page
        UsersModel updated2 = userDAO.getUserById(userId);
        if (updated2 != null) {
            request.setAttribute("fullName", updated2.getFullName());
            request.setAttribute("email",    updated2.getEmail());
            request.setAttribute("phone",    updated2.getPhoneNumber());
            request.setAttribute("address",  updated2.getAddress());
        }
        request.setAttribute("successMsg", "Profile updated successfully!");
        request.getRequestDispatcher("/pages/profile.jsp").forward(request, response);
    }
}
