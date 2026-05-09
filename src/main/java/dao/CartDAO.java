package dao;

import model.CartsModel;
import util.DBConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class CartDAO {

    private Connection conn;
    private boolean isConnectionError = false;

    public CartDAO() {
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
    //  ADD TO CART (insert new row, or increment quantity if exists)
    // ──────────────────────────────────────────────────────────────

    public boolean addToCart(String userId, String productId) {
        final String CHECK_CART_EXISTS =
            "SELECT quantity FROM carts WHERE user_id = ? AND product_id = ?";
        final String UPDATE_CART_QUANTITY =
            "UPDATE carts SET quantity = ? WHERE user_id = ? AND product_id = ?";
        final String INSERT_CART =
            "INSERT INTO carts (user_id, product_id, quantity) VALUES (?, ?, ?)";

        try {
            try (PreparedStatement check = conn.prepareStatement(CHECK_CART_EXISTS)) {
                check.setString(1, userId);
                check.setString(2, productId);

                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        // Already in cart — increment quantity by 1
                        int currentQty = rs.getInt("quantity");
                        try (PreparedStatement update = conn.prepareStatement(UPDATE_CART_QUANTITY)) {
                            update.setInt(1, currentQty + 1);
                            update.setString(2, userId);
                            update.setString(3, productId);
                            return update.executeUpdate() > 0;
                        }
                    }
                }
            }

            // Not in cart — insert with quantity 1
            try (PreparedStatement insert = conn.prepareStatement(INSERT_CART)) {
                insert.setString(1, userId);
                insert.setString(2, productId);
                insert.setInt(3, 1);
                return insert.executeUpdate() > 0;
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  UPDATE QUANTITY (removes item if qty <= 0)
    // ──────────────────────────────────────────────────────────────

    public boolean updateQuantity(String userId, String productId, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(userId, productId);
        }

        final String UPDATE_QUANTITY =
            "UPDATE carts SET quantity = ? WHERE user_id = ? AND product_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(UPDATE_QUANTITY)) {
            ps.setInt(1, quantity);
            ps.setString(2, userId);
            ps.setString(3, productId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  REMOVE FROM CART
    // ──────────────────────────────────────────────────────────────

    public boolean removeFromCart(String userId, String productId) {
        final String REMOVE_FROM_CART =
            "DELETE FROM carts WHERE user_id = ? AND product_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(REMOVE_FROM_CART)) {
            ps.setString(1, userId);
            ps.setString(2, productId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  CLEAR CART
    // ──────────────────────────────────────────────────────────────

    public boolean clearCart(String userId) {
        final String CLEAR_CART = "DELETE FROM carts WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(CLEAR_CART)) {
            ps.setString(1, userId);
            return ps.executeUpdate() >= 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  GET CART ITEMS (joined with products for name, price, image)
    // ──────────────────────────────────────────────────────────────

    public ArrayList<CartsModel> getCartItems(String userId) {
        final String GET_CART_ITEMS =
            "SELECT p.product_id, p.product_name, p.price, p.image, c.quantity " +
            "FROM carts c " +
            "JOIN products p ON c.product_id = p.product_id " +
            "WHERE c.user_id = ?";

        ArrayList<CartsModel> cartItems = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(GET_CART_ITEMS)) {
            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartsModel item = new CartsModel();
                    item.setUserId(userId);
                    item.setProductId(rs.getString("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setPrice(rs.getDouble("price"));
                    item.setImage(rs.getString("image"));
                    item.setQuantity(rs.getInt("quantity"));
                    cartItems.add(item);
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return cartItems;
    }

    // ──────────────────────────────────────────────────────────────
    //  GET CART COUNT (for navbar badge)
    // ──────────────────────────────────────────────────────────────

    public int getCartCount(String userId) {
        final String GET_CART_COUNT =
            "SELECT COUNT(*) AS total FROM carts WHERE user_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(GET_CART_COUNT)) {
            ps.setString(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return 0;
    }
}
