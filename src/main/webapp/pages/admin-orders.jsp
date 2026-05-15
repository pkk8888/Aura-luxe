<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.OrdersModel" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (!Boolean.TRUE.equals(isAdmin)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    ArrayList<OrdersModel> orders = (ArrayList<OrdersModel>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>AuraLuxe Admin | Orders</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f0f2; color: #1a0a10; min-height: 100vh; }

        .adm-page { max-width: 1200px; margin: 36px auto; padding: 0 24px 60px; }

        /* Page header */
        .adm-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; flex-wrap: wrap; gap: 12px; }
        .adm-head__title { font-size: 1.6rem; font-weight: 800; }
        .adm-head__count { background: #c0394b; color: #fff; border-radius: 50px; padding: 3px 12px; font-size: .8rem; font-weight: 700; margin-left: 10px; }

        /* Toast */
        .adm-toast { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: .9rem; font-weight: 600; }

        /* Table */
        .adm-table-wrap { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(26,10,16,.08); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: linear-gradient(135deg, #2a0d17, #5c1a2e); color: #fff; }
        thead th { padding: 14px 16px; font-size: .82rem; font-weight: 600; text-align: left; letter-spacing: .4px; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0e8eb; transition: background .15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fdf6f8; }
        tbody td { padding: 14px 16px; font-size: .88rem; vertical-align: middle; }

        /* Status badge */
        .badge {
            display: inline-block; padding: 3px 12px; border-radius: 50px;
            font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .4px;
        }
        .badge--pending   { background: #fff3cd; color: #856404; }
        .badge--confirmed { background: #d1ecf1; color: #0c5460; }
        .badge--shipped   { background: #cce5ff; color: #004085; }
        .badge--delivered { background: #d4edda; color: #155724; }
        .badge--cancelled { background: #f8d7da; color: #721c24; }

        /* Status form */
        .status-form { display: flex; align-items: center; gap: 8px; }
        .status-select {
            border: 1.5px solid #e0cdd2; border-radius: 8px;
            padding: 5px 10px; font-size: .82rem; background: #fff;
            color: #1a0a10; cursor: pointer;
        }
        .btn-update {
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff; border: none; border-radius: 8px;
            padding: 6px 14px; font-size: .8rem; font-weight: 600;
            cursor: pointer; transition: opacity .2s;
        }
        .btn-update:hover { opacity: .85; }

        /* Order ID */
        .order-id { font-weight: 700; font-size: .82rem; color: #5c1a2e; }
        .user-name { font-weight: 600; }
        .user-id   { font-size: .78rem; color: #8a5060; }
        .amount    { font-weight: 700; }

        /* Empty */
        .adm-empty { text-align: center; padding: 60px 20px; color: #8a5060; }
        .adm-empty__icon { font-size: 3rem; margin-bottom: 12px; }

        @media (max-width: 768px) {
            thead th:nth-child(4),
            tbody td:nth-child(4) { display: none; }
        }
    </style>
</head>
<body>

<jsp:include page="/components/admin-navbar.jsp" />

<div class="adm-page">

    <div class="adm-head">
        <div>
            <span class="adm-head__title">All Orders</span>
            <span class="adm-head__count"><%= orders.size() %></span>
        </div>
    </div>

    <% if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="adm-toast">✅ Order status updated successfully.</div>
    <% } %>

    <div class="adm-table-wrap">
    <% if (orders.isEmpty()) { %>
        <div class="adm-empty">
            <div class="adm-empty__icon">📋</div>
            <div>No orders found.</div>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Customer</th>
                    <th>Amount</th>
                    <th>Payment</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Update</th>
                </tr>
            </thead>
            <tbody>
            <% for (OrdersModel order : orders) {
                String status = order.getStatus() != null ? order.getStatus() : "Pending";
                String badgeCls = "badge--pending";
                if      (status.equalsIgnoreCase("Confirmed")) badgeCls = "badge--confirmed";
                else if (status.equalsIgnoreCase("Shipped"))   badgeCls = "badge--shipped";
                else if (status.equalsIgnoreCase("Delivered")) badgeCls = "badge--delivered";
                else if (status.equalsIgnoreCase("Cancelled")) badgeCls = "badge--cancelled";
            %>
                <tr>
                    <td><span class="order-id">#<%= order.getOrderId() %></span></td>
                    <td>
                        <div class="user-name"><%= order.getFullName() != null ? order.getFullName() : "—" %></div>
                        <div class="user-id"><%= order.getUserId() %></div>
                    </td>
                    <td><span class="amount">Rs <%= String.format("%,.0f", order.getTotalAmount()) %></span></td>
                    <td><%= order.getPaymentMethod() != null ? order.getPaymentMethod() : "—" %></td>
                    <td><%= order.getCreatedAt() != null ? order.getCreatedAt() : "—" %></td>
                    <td><span class="badge <%= badgeCls %>"><%= status %></span></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/AdminOrdersServlet" method="post" class="status-form">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>"/>
                            <select name="status" class="status-select">
                                <option value="Pending"   <%= status.equals("Pending")   ? "selected" : "" %>>Pending</option>
                                <option value="Shipped"   <%= status.equals("Shipped")   ? "selected" : "" %>>Shipped</option>
                                <option value="Delivered" <%= status.equals("Delivered") ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled" <%= status.equals("Cancelled") ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
    </div>

</div>
</body>
</html>
