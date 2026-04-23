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

/**
 * AddToCartServlet
 * Handles POST /AddToCartServlet
 * Adds a product to the logged-in user's cart (quantity 1).
 * If the item already exists, shows an error instead of duplicating.
 */
public class AddToCartServlet extends HttpServlet {

    private final DatabaseController db = new DatabaseController();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // ── 1. Must be logged in ──────────────────────────────────
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            // Not logged in — redirect to login page with a hint
            resp.sendRedirect(req.getContextPath() + StringUtils.LOGIN_PAGE + "?error=login_required");
            return;
        }

        String userId    = (String) session.getAttribute(StringUtils.SESSION_USER_ID);
        String productId = req.getParameter("productId");

        if (productId == null || productId.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET);
            return;
        }

        // ── 2. Check if already in cart ──────────────────────────
        try (Connection conn = db.getConnection();
             PreparedStatement check = conn.prepareStatement(StringUtils.CHECK_CART_EXISTS)) {

            check.setString(1, userId);
            check.setString(2, productId);

            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) {
                    // Already in cart — update quantity by 1
                    int currentQty = rs.getInt("quantity");
                    try (PreparedStatement upd = conn.prepareStatement(
                            "UPDATE carts SET quantity = ? WHERE user_id = ? AND product_id = ?")) {
                        upd.setInt(1, currentQty + 1);
                        upd.setString(2, userId);
                        upd.setString(3, productId);
                        upd.executeUpdate();
                    }
                    // Redirect back with success
                    String referer = req.getHeader("Referer");
                    if (referer != null && !referer.isEmpty()) {
                        resp.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + "cartMsg=updated");
                    } else {
                        resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET + "?cartMsg=updated");
                    }
                    return;
                }
            }

            // ── 3. Insert new cart row ────────────────────────────
            try (PreparedStatement insert = conn.prepareStatement(StringUtils.ADD_TO_CART)) {
                insert.setString(1, userId);
                insert.setString(2, productId);
                insert.setInt(3, 1);
                insert.executeUpdate();
            }

            // ── 4. Redirect back with success toast ───────────────
            String referer = req.getHeader("Referer");
            if (referer != null && !referer.isEmpty()) {
                resp.sendRedirect(referer + (referer.contains("?") ? "&" : "?") + "cartMsg=added");
            } else {
                resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET + "?cartMsg=added");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET + "?cartMsg=error");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // GET not supported — redirect to shop
        resp.sendRedirect(req.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET);
    }
}
