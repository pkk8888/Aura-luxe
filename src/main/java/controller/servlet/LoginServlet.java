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

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Userdao userDAO = new Userdao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Read form fields — email now instead of userID
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Null safety
        email    = (email    != null) ? email.trim() : "";
        password = (password != null) ? password     : "";

        // 3. Empty field check
        if (ValidationUtil.isNullOrEmpty(email) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Please fill in both Email and Password.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        // 4. Email format check
        if (!ValidationUtil.isValidEmail(email)) {
            request.setAttribute("errorMessage", "Please enter a valid email address.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        // 5. Validate credentials via DAO (login by email)
        int result = userDAO.validateLogin(email, password);

        if (result == 1 || result == 2) {
            // Get the userId from email to store in session
            String userId = userDAO.getUserIdByEmail(email);
            UsersModel user = userDAO.getUserById(userId);

            HttpSession session = request.getSession();
            session.setAttribute("userID",   userId);
            session.setAttribute("isAdmin",  result == 1);
            if (user != null) session.setAttribute("fullName", user.getFullName());

            if (result == 1) {
                // Admin
                response.sendRedirect(request.getContextPath() + "/AdminOrdersServlet");
            } else {
                // Normal user
                response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            }

        } else if (result == 0) {
            request.setAttribute("errorMessage", "No account found with that email. Please register first.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);

        } else if (result == 3) {
            request.setAttribute("errorMessage", "Incorrect email or password. Please try again.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);

        } else {
            request.setAttribute("errorMessage", "A server error occurred. Please try again later.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
}
