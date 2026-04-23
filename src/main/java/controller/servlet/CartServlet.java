package controller.servlet;

import controller.DatabaseController;
import util.StringUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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

/**
 * CartServlet
 * Handles GET /CartServlet
 * Loads the current user's cart items and forwards to cart.jsp.
 * Also handles POST for removing items or updating quantity.
 */
public class CartServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Not logged in → redirect to login
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE + "?error=login_required");
            return;
        }

        String userId = (String) session.getAttribute(StringUtils.SESSION_USER_ID);

        // ── Handle remove action from query param ─────────────────
        String removeId = req.getParameter("remove");
        if (removeId != null && !removeId.isEmpty()) {
            try (Connection conn = db.getConnection();
                 PreparedStatement st = conn.prepareStatement(StringUtils.REMOVE_FROM_CART)) {
                st.setString(1, userId);
                st.setString(2, removeId);
                st.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ── Handle quantity update ─────────────────────────────────
        String updateId  = req.getParameter("updateId");
        String updateQty = req.getParameter("qty");
        if (updateId != null && updateQty != null) {
            try {
                int qty = Integer.parseInt(updateQty);
                if (qty <= 0) {
                    // Remove if qty = 0
                    try (Connection conn = db.getConnection();
                         PreparedStatement st = conn.prepareStatement(StringUtils.REMOVE_FROM_CART)) {
                        st.setString(1, userId);
                        st.setString(2, updateId);
                        st.executeUpdate();
                    }
                } else {
                    try (Connection conn = db.getConnection();
                         PreparedStatement st = conn.prepareStatement(
                                 "UPDATE carts SET quantity = ? WHERE user_id = ? AND product_id = ?")) {
                        st.setInt(1, qty);
                        st.setString(2, userId);
                        st.setString(3, updateId);
                        st.executeUpdate();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ── Fetch cart items ──────────────────────────────────────
        List<Map<String, Object>> cartItems = new ArrayList<>();
        double grandTotal = 0;

        try (Connection conn = db.getConnection();
             PreparedStatement st = conn.prepareStatement(StringUtils.GET_CART_ITEMS)) {

            st.setString(1, userId);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    item.put("productId",   rs.getString("product_id"));
                    item.put("productName", rs.getString("product_name"));
                    item.put("price",       rs.getDouble("price"));
                    item.put("image",       rs.getString("image"));
                    item.put("quantity",    rs.getInt("quantity"));

                    double lineTotal = rs.getDouble("price") * rs.getInt("quantity");
                    item.put("lineTotal", lineTotal);
                    grandTotal += lineTotal;

                    cartItems.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("cartItems",  cartItems);
        req.setAttribute("grandTotal", grandTotal);
        req.getRequestDispatcher("/pages/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
