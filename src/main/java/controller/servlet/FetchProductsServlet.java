package controller.servlet;

import dao.CartDAO;
import dao.ProductDao;
import model.ProductModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

public class FetchProductsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ProductDao productDAO = new ProductDao();
    private final CartDAO    cartDAO    = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId   = (String) session.getAttribute("userID");
        String category = request.getParameter("category");
        String search   = request.getParameter("search");

        // 2. Fetch products via DAO (filtered by category or search if provided)
        ArrayList<ProductModel> products = productDAO.getFilteredProducts(category, search);

        // 3. Fetch cart count for navbar badge via DAO
        int cartCount = cartDAO.getCartCount(userId);

        // 4. Forward to products page
        request.setAttribute("products",         products);
        request.setAttribute("cartCount",         cartCount);
        request.setAttribute("selectedCategory", category != null ? category : "");
        request.setAttribute("searchQuery",      search   != null ? search   : "");
        request.getRequestDispatcher("/pages/products.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
