package controller.servlet;

import dao.OrderDAO;
import model.OrdersModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

public class AdminOrdersServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAO();

    // ── GET: show all orders ──────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Admin guard
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        ArrayList<OrdersModel> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/pages/admin-orders.jsp").forward(request, response);
    }

    // ── POST: update order status ─────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String orderId   = request.getParameter("orderId");
        String newStatus = request.getParameter("status");

        if (orderId != null && newStatus != null) {
            orderDAO.updateOrderStatus(orderId.trim(), newStatus.trim());
        }

        response.sendRedirect(request.getContextPath() + "/AdminOrdersServlet");
    }

    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        return Boolean.TRUE.equals(isAdmin);
    }
}
