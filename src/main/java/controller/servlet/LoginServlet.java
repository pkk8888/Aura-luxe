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

        // 1. Read form fields
        String userId   = request.getParameter("userID");
        String password = request.getParameter("password");

        // 2. Null safety
        userId   = (userId   != null) ? userId.trim() : "";
        password = (password != null) ? password      : "";

        // 3. Empty field check
        if (ValidationUtil.isNullOrEmpty(userId) || ValidationUtil.isNullOrEmpty(password)) {
            request.setAttribute("errorMessage", "Please fill in both User ID and Password.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }

        // 4. Validate credentials via DAO
        int result = userDAO.validateLogin(userId, password);

        if (result == 1) {
            // Admin login
            HttpSession session = request.getSession();
            session.setAttribute("userID",  userId);
            session.setAttribute("isAdmin", true);

            UsersModel admin = userDAO.getUserById(userId);
            if (admin != null) session.setAttribute("fullName", admin.getFullName());

            response.sendRedirect(request.getContextPath() + "/pages/order_list.jsp");

        } else if (result == 2) {
            // Normal user login
            HttpSession session = request.getSession();
            session.setAttribute("userID",  userId);
            session.setAttribute("isAdmin", false);

            UsersModel user = userDAO.getUserById(userId);
            if (user != null) session.setAttribute("fullName", user.getFullName());

            response.sendRedirect(request.getContextPath() + "/pages/home.jsp");

        } else if (result == 0) {
            request.setAttribute("errorMessage", "No account found with that User ID. Please register first.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);

        } else if (result == 3) {
            request.setAttribute("errorMessage", "Incorrect User ID or Password. Please try again.");
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
