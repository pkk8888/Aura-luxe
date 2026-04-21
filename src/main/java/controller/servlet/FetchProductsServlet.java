package controller.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import controller.DatabaseController;
import model.ProductModel;
import util.StringUtils;

/**
 * FetchProductsServlet
 * Handles GET /FetchProductsServlet
 * Fetches all products (optionally filtered by category or search)
 * and forwards to products.jsp
 */
@WebServlet("/FetchProductsServlet")
public class FetchProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DatabaseController db = new DatabaseController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Redirect to login if not logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String category = request.getParameter("category"); // optional filter
        String search   = request.getParameter("search");   // optional search

        List<ProductModel> products = new ArrayList<>();

        try (Connection conn = db.getConnection()) {

            String sql;
            PreparedStatement ps;

            if (search != null && !search.trim().isEmpty()) {
                // Search by name
                sql = "SELECT * FROM products WHERE product_name LIKE ? ORDER BY product_name";
                ps  = conn.prepareStatement(sql);
                ps.setString(1, "%" + search.trim() + "%");

            } else if (category != null && !category.trim().isEmpty()) {
                // Filter by category (case-insensitive)
                sql = "SELECT * FROM products WHERE LOWER(category) LIKE ? ORDER BY product_name";
                ps  = conn.prepareStatement(sql);
                ps.setString(1, "%" + category.trim().toLowerCase() + "%");

            } else {
                // All products
                sql = "SELECT * FROM products ORDER BY product_name";
                ps  = conn.prepareStatement(sql);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
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
                products.add(p);
            }
            rs.close();
            ps.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Pass data to JSP
        request.setAttribute("products", products);
        request.setAttribute("selectedCategory", category != null ? category : "");
        request.setAttribute("searchQuery", search != null ? search : "");
        request.getRequestDispatcher("/pages/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
