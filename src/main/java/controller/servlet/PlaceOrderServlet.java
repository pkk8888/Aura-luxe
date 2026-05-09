package controller.servlet;

import dao.CartDAO;
import dao.OrderDAO;
import model.CartsModel;
import model.OrdersModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO  cartDAO  = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Session guard ──────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userID");

        // ── 2. Read form fields ───────────────────────────────────
        String name    = request.getParameter("fullName");
        String phone   = request.getParameter("phone");
        String city    = request.getParameter("city");
        String address = request.getParameter("address");
        String payment = request.getParameter("payment");

        // ── 3. Basic validation ───────────────────────────────────
        if (isAnyEmpty(name, phone, city, address, payment)) {
            request.setAttribute("errorMsg", "Please fill in all required fields.");
            forwardBackToCheckout(request, response, userId);
            return;
        }

        // ── 4. Load cart from DAO ─────────────────────────────────
        ArrayList<CartsModel> cartItems = cartDAO.getCartItems(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            return;
        }

        // ── 5. Calculate total and build order items list ─────────
        double grandTotal = 0;
        ArrayList<String[]> orderItems = new ArrayList<>();

        for (CartsModel item : cartItems) {
            grandTotal += item.getLineTotal();
            orderItems.add(new String[]{ item.getProductId(), String.valueOf(item.getQuantity()) });
        }

        // ── 6. Build OrdersModel ──────────────────────────────────
        String orderId = "AL-" + UUID.randomUUID().toString()
                                     .replace("-", "")
                                     .substring(0, 10)
                                     .toUpperCase();

        OrdersModel order = new OrdersModel(orderId, userId, grandTotal, city, address, payment);

        // ── 7. Place order via DAO (transaction inside) ───────────
        String savedOrderId = orderDAO.placeOrder(order, orderItems);

        if (savedOrderId == null) {
            request.setAttribute("errorMsg", "Could not place your order. Please try again.");
            forwardBackToCheckout(request, response, userId);
            return;
        }

        // ── 8. Clear the cart ─────────────────────────────────────
        cartDAO.clearCart(userId);

        // ── 9. Forward to thank you page ──────────────────────────
        request.setAttribute("orderId",         savedOrderId);
        request.setAttribute("paymentMethod",   payment);
        request.setAttribute("deliveryAddress", address);
        request.setAttribute("orderTotal",      grandTotal);
        request.setAttribute("itemCount",       cartItems.size());
        session.setAttribute("city",            city);

        request.getRequestDispatcher("/pages/thankyou.jsp").forward(request, response);
    }

    private void forwardBackToCheckout(HttpServletRequest request,
                                       HttpServletResponse response,
                                       String userId)
            throws ServletException, IOException {

        ArrayList<CartsModel> cartItems = cartDAO.getCartItems(userId);
        double grandTotal = 0;
        for (CartsModel item : cartItems) grandTotal += item.getLineTotal();

        request.setAttribute("prefName",    request.getParameter("fullName"));
        request.setAttribute("prefPhone",   request.getParameter("phone"));
        request.setAttribute("prefCity",    request.getParameter("city"));
        request.setAttribute("prefAddr",    request.getParameter("address"));
        request.setAttribute("prefPayment", request.getParameter("payment"));
        request.setAttribute("cartItems",   cartItems);
        request.setAttribute("grandTotal",  grandTotal);
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }

    private boolean isAnyEmpty(String... values) {
        for (String v : values) {
            if (v == null || v.trim().isEmpty()) return true;
        }
        return false;
    }
}
