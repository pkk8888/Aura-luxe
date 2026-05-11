<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.util.Map" %>
<%@ page import="model.OrdersModel, model.OrderProductsModel" %>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null) fullName = checkUser;

    ArrayList<OrdersModel> orders =
        (ArrayList<OrdersModel>) request.getAttribute("orders");

    Map<String, ArrayList<OrderProductsModel>> orderItemsMap =
        (Map<String, ArrayList<OrderProductsModel>>) request.getAttribute("orderItemsMap");

    if (orders == null) orders = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | My Orders</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #fdf6f8; color: #2a0d17; min-height: 100vh; }

        /* ── Header ── */
        .mo-header {
            background: linear-gradient(135deg, #2a0d17 0%, #5c1a2e 100%);
            color: #fff;
            text-align: center;
            padding: 48px 20px 36px;
        }
        .mo-header__eyebrow { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; opacity: .6; display: block; margin-bottom: 10px; }
        .mo-header__title   { font-size: 2.2rem; font-weight: 700; margin-bottom: 8px; }
        .mo-header__sub     { font-size: 1rem; opacity: .75; }

        /* ── Layout ── */
        .mo-main {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px 60px;
        }

        /* ── Empty state ── */
        .mo-empty {
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(42,13,23,.07);
        }
        .mo-empty__icon  { font-size: 4rem; margin-bottom: 16px; }
        .mo-empty__title { font-size: 1.5rem; font-weight: 700; margin-bottom: 10px; }
        .mo-empty__sub   { color: #8a5060; margin-bottom: 28px; }
        .mo-empty__btn {
            display: inline-block;
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff; padding: 14px 32px;
            border-radius: 50px; font-weight: 600;
            text-decoration: none; transition: opacity .2s;
        }
        .mo-empty__btn:hover { opacity: .88; }

        /* ── Order card ── */
        .mo-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 14px rgba(42,13,23,.08);
            margin-bottom: 28px;
            overflow: hidden;
        }

        /* Card header row */
        .mo-card__head {
            background: #fdf0f4;
            padding: 18px 24px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px 32px;
            align-items: center;
            border-bottom: 1.5px solid #f0dce3;
        }
        .mo-card__order-id { font-weight: 800; font-size: .95rem; color: #2a0d17; }
        .mo-card__meta     { font-size: .82rem; color: #8a5060; }
        .mo-card__meta span { font-weight: 600; color: #5c1a2e; }

        /* Status badge */
        .mo-badge {
            display: inline-block;
            padding: 4px 14px;
            border-radius: 50px;
            font-size: .75rem;
            font-weight: 700;
            letter-spacing: .4px;
            text-transform: uppercase;
            margin-left: auto;
        }
        .mo-badge--pending   { background: #fff3cd; color: #856404; }
        .mo-badge--confirmed { background: #d1ecf1; color: #0c5460; }
        .mo-badge--shipped   { background: #cce5ff; color: #004085; }
        .mo-badge--delivered { background: #d4edda; color: #155724; }
        .mo-badge--cancelled { background: #f8d7da; color: #721c24; }

        /* Items list inside card */
        .mo-items { padding: 20px 24px; display: flex; flex-direction: column; gap: 16px; }

        .mo-item {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .mo-item__img {
            width: 70px; height: 70px;
            border-radius: 10px;
            object-fit: cover;
            border: 1px solid #f0dce3;
            flex-shrink: 0;
        }
        .mo-item__info { flex: 1; min-width: 0; }
        .mo-item__name  { font-weight: 700; font-size: .95rem; color: #2a0d17; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .mo-item__meta  { font-size: .82rem; color: #8a5060; }
        .mo-item__total { font-weight: 800; font-size: .95rem; color: #2a0d17; flex-shrink: 0; }

        /* Card footer */
        .mo-card__foot {
            border-top: 1.5px solid #f0dce3;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .mo-card__delivery { font-size: .83rem; color: #8a5060; }
        .mo-card__delivery span { font-weight: 600; color: #2a0d17; }
        .mo-card__total { font-size: 1.05rem; font-weight: 800; color: #2a0d17; }

        @media (max-width: 600px) {
            .mo-card__head { flex-direction: column; align-items: flex-start; }
            .mo-badge { margin-left: 0; }
            .mo-item__img { width: 54px; height: 54px; }
        }
    </style>
</head>
<body>

<%-- Navbar --%>
<jsp:include page="/components/navbar.jsp" />

<%-- Header --%>
<div class="mo-header">
    <span class="mo-header__eyebrow">AuraLuxe</span>
    <h1 class="mo-header__title">My Orders</h1>
    <p class="mo-header__sub">
        <% if (!orders.isEmpty()) { %>
            You have <%= orders.size() %> order<%= orders.size() != 1 ? "s" : "" %>
        <% } else { %>
            No orders yet
        <% } %>
    </p>
</div>

<%-- Main --%>
<div class="mo-main">

<% if (orders.isEmpty()) { %>
    <div class="mo-empty">
        <div class="mo-empty__icon">📦</div>
        <div class="mo-empty__title">No orders yet</div>
        <div class="mo-empty__sub">Looks like you haven't placed any orders. Start shopping!</div>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="mo-empty__btn">Shop Now</a>
    </div>

<% } else {
    for (OrdersModel order : orders) {
        ArrayList<OrderProductsModel> items = orderItemsMap.get(order.getOrderId());
        if (items == null) items = new ArrayList<>();

        // Determine badge CSS class based on status
        String status    = order.getStatus() != null ? order.getStatus() : "Pending";
        String badgeClass = "mo-badge--pending";
        if      (status.equalsIgnoreCase("Confirmed")) badgeClass = "mo-badge--confirmed";
        else if (status.equalsIgnoreCase("Shipped"))   badgeClass = "mo-badge--shipped";
        else if (status.equalsIgnoreCase("Delivered")) badgeClass = "mo-badge--delivered";
        else if (status.equalsIgnoreCase("Cancelled")) badgeClass = "mo-badge--cancelled";
%>

    <div class="mo-card">

        <%-- Card header --%>
        <div class="mo-card__head">
            <div>
                <div class="mo-card__order-id">Order #<%= order.getOrderId() %></div>
                <div class="mo-card__meta">
                    Placed on <span><%= order.getCreatedAt() != null ? order.getCreatedAt() : "—" %></span>
                    &nbsp;·&nbsp;
                    Payment: <span><%= order.getPaymentMethod() %></span>
                </div>
            </div>
            <span class="mo-badge <%= badgeClass %>"><%= status %></span>
        </div>

        <%-- Items --%>
        <div class="mo-items">
        <% for (OrderProductsModel item : items) { %>
            <div class="mo-item">
                <img class="mo-item__img"
                     src="${pageContext.request.contextPath}/images/<%= item.getImage() %>"
                     alt="<%= item.getProductName() %>"
                     onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" />
                <div class="mo-item__info">
                    <div class="mo-item__name"><%= item.getProductName() %></div>
                    <div class="mo-item__meta">
                        Rs <%= String.format("%,.0f", item.getUnitPrice()) %> &times; <%= item.getQuantity() %>
                    </div>
                </div>
                <div class="mo-item__total">Rs <%= String.format("%,.0f", item.getLineTotal()) %></div>
            </div>
        <% } %>
        </div>

        <%-- Card footer --%>
        <div class="mo-card__foot">
            <div class="mo-card__delivery">
                Deliver to: <span><%= order.getCity() %>, <%= order.getDeliveryAddress() %></span>
            </div>
            <div class="mo-card__total">
                Total: Rs <%= String.format("%,.0f", order.getTotalAmount()) %>
            </div>
        </div>

    </div>

<% } } %>

</div>

<jsp:include page="/components/footer.jsp" />

</body>
</html>
