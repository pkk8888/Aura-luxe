package dao;

import model.ProductModel;
import util.DBConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ProductDao {

    private Connection conn;
    private boolean isConnectionError = false;

    public ProductDao() {
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
    //  FETCH ALL PRODUCTS
    // ──────────────────────────────────────────────────────────────

    public ArrayList<ProductModel> getAllProducts() {
        final String SELECT_ALL_PRODUCTS =
            "SELECT * FROM products ORDER BY product_name";

        ArrayList<ProductModel> products = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(SELECT_ALL_PRODUCTS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(mapRow(rs));
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return products;
    }

    // ──────────────────────────────────────────────────────────────
    //  FETCH FILTERED PRODUCTS (by category or search keyword)
    // ──────────────────────────────────────────────────────────────

    public ArrayList<ProductModel> getFilteredProducts(String category, String search) {
        ArrayList<ProductModel> products = new ArrayList<>();

        try {
            PreparedStatement ps;

            if (search != null && !search.trim().isEmpty()) {
                ps = conn.prepareStatement(
                    "SELECT * FROM products WHERE product_name LIKE ? ORDER BY product_name");
                ps.setString(1, "%" + search.trim() + "%");

            } else if (category != null && !category.trim().isEmpty()) {
                ps = conn.prepareStatement(
                    "SELECT * FROM products WHERE LOWER(category) LIKE ? ORDER BY product_name");
                ps.setString(1, "%" + category.trim().toLowerCase() + "%");

            } else {
                return getAllProducts();
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapRow(rs));
                }
            }
            ps.close();

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return products;
    }

    // ──────────────────────────────────────────────────────────────
    //  FETCH SINGLE PRODUCT BY ID
    // ──────────────────────────────────────────────────────────────

    public ProductModel getProductById(String productId) {
        final String SELECT_PRODUCT_BY_ID =
            "SELECT * FROM products WHERE product_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(SELECT_PRODUCT_BY_ID)) {
            ps.setString(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
        }
        return null;
    }

    // ──────────────────────────────────────────────────────────────
    //  INSERT PRODUCT
    // ──────────────────────────────────────────────────────────────

    public boolean insertProduct(ProductModel product) {
        final String INSERT_PRODUCT =
            "INSERT INTO products " +
            "(product_id, product_name, category, shade, brand, features, net_weight, shelf_life, price, image) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(INSERT_PRODUCT)) {
            ps.setString(1, product.getProductId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getCategory());
            ps.setString(4, product.getShade());
            ps.setString(5, product.getBrand());
            ps.setString(6, product.getFeatures());
            ps.setString(7, product.getNetWeight());
            ps.setString(8, product.getShelfLife());
            ps.setDouble(9, product.getPrice());
            ps.setString(10, product.getImage());
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  UPDATE PRODUCT
    // ──────────────────────────────────────────────────────────────

    public boolean updateProduct(ProductModel product) {
        final String UPDATE_PRODUCT =
            "UPDATE products SET product_name=?, category=?, shade=?, brand=?, " +
            "features=?, net_weight=?, shelf_life=?, price=?, image=? " +
            "WHERE product_id=?";

        try (PreparedStatement ps = conn.prepareStatement(UPDATE_PRODUCT)) {
            ps.setString(1, product.getProductName());
            ps.setString(2, product.getCategory());
            ps.setString(3, product.getShade());
            ps.setString(4, product.getBrand());
            ps.setString(5, product.getFeatures());
            ps.setString(6, product.getNetWeight());
            ps.setString(7, product.getShelfLife());
            ps.setDouble(8, product.getPrice());
            ps.setString(9, product.getImage());
            ps.setString(10, product.getProductId());
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  DELETE PRODUCT
    // ──────────────────────────────────────────────────────────────

    public boolean deleteProduct(String productId) {
        final String DELETE_PRODUCT = "DELETE FROM products WHERE product_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(DELETE_PRODUCT)) {
            ps.setString(1, productId);
            return ps.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println(ex.getLocalizedMessage());
            return false;
        }
    }

    // ──────────────────────────────────────────────────────────────
    //  HELPER: map a ResultSet row to a ProductModel
    // ──────────────────────────────────────────────────────────────

    private ProductModel mapRow(ResultSet rs) throws SQLException {
        ProductModel p = new ProductModel();
        p.setProductId(rs.getString("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setCategory(rs.getString("category"));
        p.setShade(rs.getString("shade"));
        p.setBrand(rs.getString("brand"));
        p.setFeatures(rs.getString("features"));
        p.setNetWeight(rs.getString("net_weight"));
        p.setShelfLife(rs.getString("shelf_life"));
        p.setPrice(rs.getDouble("price"));
        p.setImage(rs.getString("image"));
        return p;
    }
}
