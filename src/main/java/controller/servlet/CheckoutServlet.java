package controller.servlet;

import dao.CartDAO;
import model.CartsModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;

public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Must be logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userID") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userID");

        // 2. Fetch cart items via DAO (includes product name, price, image from JOIN)
        ArrayList<CartsModel> cartItems = cartDAO.getCartItems(userId);

        double grandTotal = 0;
        for (CartsModel item : cartItems) {
            grandTotal += item.getLineTotal();
        }

        // 3. Forward to checkout page
        request.setAttribute("cartItems",  cartItems);
        request.setAttribute("grandTotal", grandTotal);
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }
}
