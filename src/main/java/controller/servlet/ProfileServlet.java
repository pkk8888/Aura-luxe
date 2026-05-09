package controller.servlet;

import dao.Userdao;
import model.UsersModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final Userdao userDAO = new Userdao();

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

            // Keep fullName in session so navbar always shows it
            session.setAttribute("fullName", user.getFullName());
        }

        request.getRequestDispatcher("/pages/profile.jsp").forward(request, response);
    }
}
