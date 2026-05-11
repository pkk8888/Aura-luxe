package controller.servlet;

import dao.OrderDAO;
import model.OrderProductsModel;
import model.OrdersModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

public class MyOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAO();

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

        // 2. Fetch all orders for this user via DAO
        ArrayList<OrdersModel> orders = orderDAO.getOrdersByUser(userId);

        // 3. For each order, fetch its items and store in a map keyed by orderId
        //    LinkedHashMap preserves insertion order (newest first)
        Map<String, ArrayList<OrderProductsModel>> orderItemsMap = new LinkedHashMap<>();

        for (OrdersModel order : orders) {
            ArrayList<OrderProductsModel> items = orderDAO.getOrderItems(order.getOrderId());
            orderItemsMap.put(order.getOrderId(), items);
        }

        // 4. Forward to my-orders.jsp
        request.setAttribute("orders",        orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.getRequestDispatcher("/pages/my-orders.jsp").forward(request, response);
    }
}
