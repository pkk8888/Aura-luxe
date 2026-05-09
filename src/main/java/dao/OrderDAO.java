package dao;

import model.OrdersModel;
import util.DBConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class OrderDAO {

    private Connection conn;
    private boolean isConnectionError = false;

    public OrderDAO() {
        try {
            conn = DBConfig.getConnection();
        } catch (SQLException | ClassNotFoundException ex) {
            isConnectionError = true;
            System.out.println(ex.getLocalizedMessage());
        }
    }

    public boolean isConnectionError() {
        return isConnectionError;
    }

    // ──────────────────────────────────────────────────────────────
    //  PLACE ORDER (orders + order_products in one transaction)
    // ──────────────────────────────────────────────────────────────

    /**
     * Saves the order and all its items in a single transaction.
     * cartItems: each String[] is { productId, quantity }
     * Returns the orderId on success, null on failure.
     */
    public String placeOrder(OrdersModel order, ArrayList<String[]> cartItems) {
        final String INSERT_ORDER =
            "INSERT INTO orders (order_id, user_id, total_amount, status, city, address, payment) " +
            "VALUES (?, ?, ?, 'Pending', ?, ?, ?)";

        final String INSERT_ORDER_PRODUCT =
            "INSERT INTO order_products (order_id, product_id, quantity) VALUES (?, ?, ?)";

        try {
            conn.setAutoCommit(false); // begin transaction

            try (PreparedStatement psOrder = conn.prepareStatement(INSERT_ORDER)) {
                psOrder.setString(1, order.getOrderId());
                psOrder.setString(2, order.getUserId());
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setString(4, order.getCity());
                psOrder.setString(5, order.getDeliveryAddress());
                psOrder.setString(6, order.getPaymentMethod());
                psOrder.executeUpdate();
            }

            try (PreparedStatement psItem = conn.prepareStatement(INSERT_ORDER_PRODUCT)) {
                for (String[] item : cartItems) {
                    psItem.setString(1, order.getOrderId());
                    psItem.setString(2, item[0]); // productId
                    psItem.setInt(3, Integer.parseInt(item[1])); // quantity
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            conn.commit();
            return order.getOrderId();

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            try { conn.rollback(); } catch (SQLException e) { System.out.println(e.getLocalizedMessage()); }
            return null;

        } finally {
            try { conn.setAutoCommit(true); } catch (SQLException e) { System.out.println(e.getLocalizedMessage()); }
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  GET ALL ORDERS (for admin order list)
    // ──────────────────────────────────────────────────────────────

    public ArrayList<OrdersModel> getAllOrders() {
        final String GET_ALL_ORDERS =
            "SELECT o.order_id, o.user_id, u.full_name, o.total_amount, " +
            "o.status, o.payment, o.created_at " +
            "FROM orders o JOIN users u ON o.user_id = u.user_id";

        ArrayList<OrdersModel> orders = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(GET_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                OrdersModel order = new OrdersModel();
                order.setOrderId(rs.getString("order_id"));
                order.setUserId(rs.getString("user_id"));
                order.setFullName(rs.getString("full_name"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment"));
                order.setCreatedAt(rs.getString("created_at"));
                orders.add(order);
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return orders;
    }

    // ──────────────────────────────────────────────────────────────
    //  UPDATE ORDER STATUS (admin)
    // ──────────────────────────────────────────────────────────────

    public boolean updateOrderStatus(String orderId, String newStatus) {
        final String UPDATE_ORDER_STATUS =
            "UPDATE orders SET status = ? WHERE order_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
            ps.setString(1, newStatus);
            ps.setString(2, orderId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }
}
