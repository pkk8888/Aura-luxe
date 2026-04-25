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

/**
 * ProfileServlet
 * GET /ProfileServlet — loads user details from DB and forwards to profile.jsp
 */
public class ProfileServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

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

            // Keep fullName in session so navbar always shows it
            session.setAttribute("fullName", user.getFullName());
        }

        req.getRequestDispatcher("/pages/profile.jsp").forward(req, resp);
    }
}
