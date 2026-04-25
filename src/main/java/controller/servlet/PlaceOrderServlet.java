package controller.servlet;

import controller.DatabaseController;
import util.StringUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * PlaceOrderServlet
 * POST /PlaceOrderServlet
 * Reads delivery + payment form data from checkout.jsp,
 * saves the order and order_products to the DB,
 * clears the user's cart, then forwards to thankyou.jsp.
 */
public class PlaceOrderServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── 1. Session guard ──────────────────────────────────────
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String userId    = (String) session.getAttribute(StringUtils.SESSION_USER_ID);
        String fullName  = (String) session.getAttribute("fullName");
        String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : userId;

        // ── 2. Read form fields ───────────────────────────────────
        String name    = req.getParameter("fullName");
        String phone   = req.getParameter("phone");
        String city    = req.getParameter("city");
        String address = req.getParameter("address");
        String payment = req.getParameter("payment");

        // Basic validation — send back to checkout with error if anything is missing
        if (name == null || name.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            city == null || city.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            payment == null || payment.trim().isEmpty()) {

            req.setAttribute("errorMsg", "Please fill in all required fields.");
            // Re-load cart items so checkout page can re-render
            forwardBackToCheckout(req, resp, userId);
            return;
        }

        // ── 3. Load current cart from DB ──────────────────────────
        List<Map<String, Object>> cartItems = new ArrayList<>();
        double grandTotal = 0.0;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.GET_CART_ITEMS)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                double price    = rs.getDouble("price");
                int    quantity = rs.getInt("quantity");

                item.put("productId",  rs.getString("product_id"));
                item.put("quantity",   quantity);
                item.put("lineTotal",  price * quantity);
                cartItems.add(item);
                grandTotal += price * quantity;
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", StringUtils.ERR_SERVER);
            forwardBackToCheckout(req, resp, userId);
            return;
        }

        // If cart is empty, redirect to shop
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET);
            return;
        }

        // ── 4. Generate a unique Order ID ─────────────────────────
        String orderId = "AL-" + UUID.randomUUID().toString().replace("-", "").substring(0, 10).toUpperCase();

        // ── 5. Save order + order_products in one transaction ─────
        try (Connection conn = db.getConnection()) {

            conn.setAutoCommit(false); // begin transaction

            // Insert into orders table
            try (PreparedStatement psOrder = conn.prepareStatement(StringUtils.INSERT_ORDER)) {
                psOrder.setString(1, orderId);
                psOrder.setString(2, userId);
                psOrder.setDouble(3, grandTotal);
                psOrder.setString(4, city);
                psOrder.setString(5, address);
                psOrder.setString(6, payment);
                psOrder.executeUpdate();
            }

            // Insert each cart item into order_products
            try (PreparedStatement psItem = conn.prepareStatement(StringUtils.INSERT_ORDER_PRODUCT)) {
                for (Map<String, Object> item : cartItems) {
                    psItem.setString(1, orderId);
                    psItem.setString(2, (String) item.get("productId"));
                    psItem.setInt(3, (Integer) item.get("quantity"));
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            conn.commit(); // commit transaction

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Could not place your order. Please try again.");
            forwardBackToCheckout(req, resp, userId);
            return;
        }

        // ── 6. Clear the cart ─────────────────────────────────────
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.CLEAR_CART)) {
            ps.setString(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace(); // non-fatal — order is already placed
        }

        // ── 7. Set attributes for thankyou.jsp ───────────────────
        req.setAttribute("orderId",         orderId);
        req.setAttribute("paymentMethod",   payment);
        req.setAttribute("deliveryAddress", address);
        req.setAttribute("orderTotal",      grandTotal);
        req.setAttribute("itemCount",       cartItems.size());
        session.setAttribute("city",        city); // used by thankyou.jsp

        // ── 8. Forward to thank you page ──────────────────────────
        req.getRequestDispatcher("/pages/thankyou.jsp").forward(req, resp);
    }

    /**
     * Helper: re-loads cart items and forwards back to checkout.jsp with an error.
     */
    private void forwardBackToCheckout(HttpServletRequest req,
                                       HttpServletResponse resp,
                                       String userId)
            throws ServletException, IOException {

        List<Map<String, Object>> cartItems = new ArrayList<>();
        double grandTotal = 0.0;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.GET_CART_ITEMS)) {

            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                double price    = rs.getDouble("price");
                int    quantity = rs.getInt("quantity");
                double lineTotal = price * quantity;

                item.put("productId",   rs.getString("product_id"));
                item.put("productName", rs.getString("product_name"));
                item.put("price",       price);
                item.put("image",       rs.getString("image"));
                item.put("quantity",    quantity);
                item.put("lineTotal",   lineTotal);

                cartItems.add(item);
                grandTotal += lineTotal;
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Preserve entered values so user doesn't retype everything
        req.setAttribute("prefName",    req.getParameter("fullName"));
        req.setAttribute("prefPhone",   req.getParameter("phone"));
        req.setAttribute("prefCity",    req.getParameter("city"));
        req.setAttribute("prefAddr",    req.getParameter("address"));
        req.setAttribute("prefPayment", req.getParameter("payment"));

        req.setAttribute("cartItems",  cartItems);
        req.setAttribute("grandTotal", grandTotal);
        req.getRequestDispatcher("/pages/checkout.jsp").forward(req, resp);
    }
}
