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

/**
 * CheckoutServlet
 * GET /CheckoutServlet — loads cart items and forwards to checkout.jsp
 */
public class CheckoutServlet extends HttpServlet {

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

        req.setAttribute("cartItems",  cartItems);
        req.setAttribute("grandTotal", grandTotal);
        req.getRequestDispatcher("/pages/checkout.jsp").forward(req, resp);
    }
}
