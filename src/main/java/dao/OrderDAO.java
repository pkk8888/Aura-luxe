package dao;

import model.OrdersModel;
import model.OrderProductsModel;
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
            conn.setAutoCommit(false);

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
                    psItem.setString(2, item[0]);
                    psItem.setInt(3, Integer.parseInt(item[1]));
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
    //  GET ORDERS BY USER (for My Orders page)
    // ──────────────────────────────────────────────────────────────

    /**
     * Fetches all orders placed by a specific user, newest first.
     */
    public ArrayList<OrdersModel> getOrdersByUser(String userId) {
        final String GET_ORDERS_BY_USER =
            "SELECT order_id, total_amount, status, city, address, payment, created_at " +
            "FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        ArrayList<OrdersModel> orders = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(GET_ORDERS_BY_USER)) {
            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrdersModel order = new OrdersModel();
                    order.setOrderId(rs.getString("order_id"));
                    order.setUserId(userId);
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setCity(rs.getString("city"));
                    order.setDeliveryAddress(rs.getString("address"));
                    order.setPaymentMethod(rs.getString("payment"));
                    order.setCreatedAt(rs.getString("created_at"));
                    orders.add(order);
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return orders;
    }

    // ──────────────────────────────────────────────────────────────
    //  GET ORDER ITEMS BY ORDER ID (products inside one order)
    // ──────────────────────────────────────────────────────────────

    /**
     * Fetches all items for a specific order, joined with product name and price.
     */
    public ArrayList<OrderProductsModel> getOrderItems(String orderId) {
        final String GET_ORDER_ITEMS =
            "SELECT op.product_id, p.product_name, op.quantity, p.price, p.image " +
            "FROM order_products op " +
            "JOIN products p ON op.product_id = p.product_id " +
            "WHERE op.order_id = ?";

        ArrayList<OrderProductsModel> items = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(GET_ORDER_ITEMS)) {
            ps.setString(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderProductsModel item = new OrderProductsModel();
                    item.setOrderId(orderId);
                    item.setProductId(rs.getString("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getDouble("price"));
                    item.setImage(rs.getString("image"));
                    items.add(item);
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return items;
    }

    // ──────────────────────────────────────────────────────────────
    //  GET ALL ORDERS (for admin order list)
    // ──────────────────────────────────────────────────────────────

    public ArrayList<OrdersModel> getAllOrders() {
        final String GET_ALL_ORDERS =
            "SELECT o.order_id, o.user_id, u.full_name, o.total_amount, " +
            "o.status, o.payment, o.created_at " +
            "FROM orders o JOIN users u ON o.user_id = u.user_id " +
            "ORDER BY o.created_at DESC";

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
