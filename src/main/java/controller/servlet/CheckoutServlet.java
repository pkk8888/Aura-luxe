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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

        // 2. Fetch cart items via DAO
        ArrayList<CartsModel> items = cartDAO.getCartItems(userId);

        if (items.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
            return;
        }

        // 3. Convert to List<Map> so checkout.jsp works without any changes
        List<Map<String, Object>> cartItems = new ArrayList<>();
        double grandTotal = 0;

        for (CartsModel item : items) {
            double lineTotal = item.getLineTotal();
            grandTotal += lineTotal;

            Map<String, Object> map = new HashMap<>();
            map.put("productId",   item.getProductId());
            map.put("productName", item.getProductName());
            map.put("price",       item.getPrice());
            map.put("image",       item.getImage());
            map.put("quantity",    item.getQuantity());
            map.put("lineTotal",   lineTotal);
            cartItems.add(map);
        }

        // 4. Forward to checkout page
        request.setAttribute("cartItems",  cartItems);
        request.setAttribute("grandTotal", grandTotal);
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
