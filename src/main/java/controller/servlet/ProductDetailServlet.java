package controller.servlet;

import dao.ProductDao;
import model.ProductModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ProductDetailServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ProductDao productDAO = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String productId = request.getParameter("id");

        if (productId == null || productId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            return;
        }

        // 2. Fetch product via DAO
        ProductModel product = productDAO.getProductById(productId.trim());

        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            return;
        }

        // 3. Forward to product detail page
        request.setAttribute("product", product);
        request.getRequestDispatcher("/pages/product-detail.jsp").forward(request, response);
    }
}
