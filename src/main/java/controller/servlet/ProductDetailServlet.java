package controller.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
 * ProductDetailServlet
 * GET /ProductDetailServlet?id=PRD001
 * Fetches one product from DB and forwards to product-detail.jsp
 */
@WebServlet("/ProductDetailServlet")
public class ProductDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DatabaseController db = new DatabaseController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(StringUtils.SESSION_USER_ID) == null) {
            response.sendRedirect(request.getContextPath() + StringUtils.LOGIN_PAGE);
            return;
        }

        String productId = request.getParameter("id");

        if (productId == null || productId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET);
            return;
        }

        ProductModel product = null;

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(StringUtils.GET_PRODUCT_BY_ID)) {

            ps.setString(1, productId.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductModel();
                product.setProductId(rs.getString("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setCategory(rs.getString("category"));
                product.setShade(rs.getString("shade"));
                product.setBrand(rs.getString("brand"));
                product.setFeatures(rs.getString("features"));
                product.setNetWeight(rs.getString("net_weight"));
                product.setShelfLife(rs.getString("shelf_life"));
                product.setPrice(rs.getDouble("price"));
                product.setImage(rs.getString("image"));
            }
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (product == null) {
            // Product not found — go back to shop
            response.sendRedirect(request.getContextPath() + StringUtils.FETCH_PRODUCTS_SERVLET);
            return;
        }

        request.setAttribute("product", product);
        request.getRequestDispatcher("/pages/product-detail.jsp").forward(request, response);
    }
}
