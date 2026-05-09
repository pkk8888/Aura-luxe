package controller.servlet;

import dao.CartDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class AddToCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId    = (String) session.getAttribute("userID");
        String productId = request.getParameter("productId");

        if (productId == null || productId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            return;
        }

        // 2. Add to cart via DAO (handles both insert and quantity increment)
        boolean success = cartDAO.addToCart(userId, productId.trim());

        // 3. Redirect back with message
        String referer = request.getHeader("Referer");
        String msg     = success ? "cartMsg=added" : "cartMsg=error";

        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + msg);
        } else {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet?" + msg);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
    }
}
