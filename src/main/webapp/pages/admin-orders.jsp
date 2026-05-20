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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>AuraLuxe Admin | Orders</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f0f2; color: #1a0a10; min-height: 100vh; width: 100%; -webkit-text-size-adjust: 100%; }

        /* ════ Admin Navbar ════ */
        .adm-nav {
            background: linear-gradient(135deg, #1a0a10 0%, #3d1020 100%);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 32px; height: 62px;
            position: sticky; top: 0; z-index: 200;
            box-shadow: 0 2px 12px rgba(0,0,0,.35);
        }
        .adm-nav__brand { font-size: 1.2rem; font-weight: 800; color: #fff; text-decoration: none; letter-spacing: .5px; flex-shrink: 0; display: flex; align-items: center; }
        .adm-nav__brand-accent { color: #e8a0b0; }
        .adm-nav__badge { background: #c0394b; color: #fff; font-size: 9px; font-weight: 700; padding: 2px 7px; border-radius: 50px; margin-left: 8px; letter-spacing: 1px; text-transform: uppercase; }
        .adm-nav__links { display: flex; gap: 4px; list-style: none; margin: 0; padding: 0; }
        .adm-nav__link { color: rgba(255,255,255,.7); text-decoration: none; padding: 8px 16px; border-radius: 8px; font-size: .88rem; font-weight: 500; display: flex; align-items: center; gap: 6px; white-space: nowrap; transition: background .2s, color .2s; }
        .adm-nav__link:hover, .adm-nav__link--active { background: rgba(255,255,255,.12); color: #fff; }
        .adm-nav__right { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
        .adm-nav__user { font-size: .83rem; opacity: .75; white-space: nowrap; max-width: 120px; overflow: hidden; text-overflow: ellipsis; }
        .adm-nav__logout { background: rgba(255,255,255,.12); color: #fff; border: 1px solid rgba(255,255,255,.2); border-radius: 8px; padding: 6px 14px; font-size: .82rem; text-decoration: none; white-space: nowrap; transition: background .2s; }
        .adm-nav__logout:hover { background: rgba(255,255,255,.22); }
        .adm-nav__hamburger { display: none; flex-direction: column; justify-content: center; align-items: center; gap: 5px; background: rgba(255,255,255,.1); border: 1px solid rgba(255,255,255,.2); border-radius: 8px; cursor: pointer; width: 42px; height: 38px; padding: 0; }
        .adm-nav__hamburger span { display: block; width: 20px; height: 2px; background: #fff; border-radius: 2px; transition: transform .25s, opacity .25s; }
        .adm-nav__hamburger.is-open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .adm-nav__hamburger.is-open span:nth-child(2) { opacity: 0; }
        .adm-nav__hamburger.is-open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
        .adm-nav__drawer { display: none; position: fixed; top: 62px; left: 0; right: 0; background: #2a0d17; border-top: 1px solid rgba(255,255,255,.08); box-shadow: 0 8px 24px rgba(0,0,0,.5); z-index: 199; padding: 8px 16px 20px; }
        .adm-nav__drawer.is-open { display: block; animation: admSlide .2s ease; }
        @keyframes admSlide { from{opacity:0;transform:translateY(-6px)} to{opacity:1;transform:translateY(0)} }
        .adm-drawer__list { list-style: none; margin: 0; padding: 0; }
        .adm-drawer__list li { border-bottom: 1px solid rgba(255,255,255,.07); }
        .adm-drawer__list li:last-child { border-bottom: none; }
        .adm-drawer__link { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,.85); text-decoration: none; padding: 14px 8px; font-size: .95rem; font-weight: 500; border-radius: 6px; transition: background .15s; }
        .adm-drawer__link:hover, .adm-drawer__link--active { background: rgba(255,255,255,.1); color: #fff; }
        .adm-drawer__divider { border: none; border-top: 1px solid rgba(255,255,255,.1); margin: 8px 0; }
        .adm-drawer__user { color: rgba(255,255,255,.55); font-size: .82rem; padding: 10px 8px 4px; }
        .adm-drawer__logout { display: block; text-align: center; margin-top: 8px; background: rgba(192,57,75,.3); border: 1px solid rgba(192,57,75,.55); color: #fff; padding: 11px; border-radius: 8px; font-size: .9rem; font-weight: 600; text-decoration: none; }
        .adm-drawer__logout:hover { background: rgba(192,57,75,.5); }
        @media (max-width: 640px) {
            .adm-nav { padding: 0 16px; }
            .adm-nav__links  { display: none !important; }
            .adm-nav__right  { display: none !important; }
            .adm-nav__hamburger { display: flex !important; }
        }

        /* ════ Page ════ */
        .adm-page { max-width: 1200px; margin: 36px auto; padding: 0 24px 60px; }
        .adm-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; flex-wrap: wrap; gap: 12px; }
        .adm-head__title { font-size: 1.6rem; font-weight: 800; }
        .adm-head__count { background: #c0394b; color: #fff; border-radius: 50px; padding: 3px 12px; font-size: .8rem; font-weight: 700; margin-left: 10px; }
        .adm-toast { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: .9rem; font-weight: 600; }

        /* Desktop table */
        .adm-table-wrap { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(26,10,16,.08); overflow-x: auto; -webkit-overflow-scrolling: touch; width: 100%; }
        table { width: 100%; border-collapse: collapse; min-width: 750px; }
        thead { background: linear-gradient(135deg, #2a0d17, #5c1a2e); color: #fff; }
        thead th { padding: 14px 16px; font-size: .82rem; font-weight: 600; text-align: left; letter-spacing: .4px; text-transform: uppercase; }
        tbody tr { border-bottom: 1px solid #f0e8eb; transition: background .15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fdf6f8; }
        tbody td { padding: 14px 16px; font-size: .88rem; vertical-align: middle; }

        /* Mobile cards */
        .adm-cards { display: none; flex-direction: column; gap: 12px; }
        .adm-card { background: #fff; border-radius: 14px; box-shadow: 0 2px 12px rgba(26,10,16,.08); padding: 16px; }
        .adm-card__header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
        .adm-card__id { font-weight: 700; font-size: .82rem; color: #5c1a2e; }
        .adm-card__row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; font-size: .86rem; }
        .adm-card__label { color: #8a5060; font-size: .75rem; text-transform: uppercase; letter-spacing: .4px; margin-bottom: 2px; }
        .adm-card__value { font-weight: 600; }
        .adm-card__amount { font-weight: 700; font-size: 1rem; color: #2a0d17; }
        .adm-card__divider { border: none; border-top: 1px solid #f0e8eb; margin: 12px 0; }
        .adm-card__update { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; margin-top: 4px; }

        /* Badges */
        .badge { display: inline-block; padding: 3px 12px; border-radius: 50px; font-size: .72rem; font-weight: 700; text-transform: uppercase; letter-spacing: .4px; white-space: nowrap; }
        .badge--pending   { background: #fff3cd; color: #856404; }
        .badge--confirmed { background: #d1ecf1; color: #0c5460; }
        .badge--shipped   { background: #cce5ff; color: #004085; }
        .badge--delivered { background: #d4edda; color: #155724; }
        .badge--cancelled { background: #f8d7da; color: #721c24; }

        .status-form { display: flex; align-items: center; gap: 8px; white-space: nowrap; }
        .status-select { border: 1.5px solid #e0cdd2; border-radius: 8px; padding: 5px 10px; font-size: .82rem; background: #fff; color: #1a0a10; cursor: pointer; }
        .btn-update { background: linear-gradient(135deg,#7b1d36,#c0394b); color: #fff; border: none; border-radius: 8px; padding: 6px 14px; font-size: .8rem; font-weight: 600; cursor: pointer; transition: opacity .2s; }
        .btn-update:hover { opacity: .85; }
        .order-id { font-weight: 700; font-size: .82rem; color: #5c1a2e; }
        .user-name { font-weight: 600; white-space: nowrap; }
        .user-id   { font-size: .78rem; color: #8a5060; }
        .amount    { font-weight: 700; white-space: nowrap; }
        .adm-empty { text-align: center; padding: 60px 20px; color: #8a5060; }
        .adm-empty__icon { font-size: 3rem; margin-bottom: 12px; }

        @media (max-width: 640px) {
            .adm-page { margin: 16px auto; padding: 0 12px 40px; }
            .adm-head__title { font-size: 1.25rem; }
            .adm-table-wrap { display: none; }
            .adm-cards { display: flex; }
            .status-form { flex-wrap: wrap; }
            .status-select { flex: 1; min-width: 0; }
        }
        @media (max-width: 992px) and (min-width: 641px) {
            .adm-page { margin: 20px auto; padding: 0 16px 40px; }
            .adm-head__title { font-size: 1.3rem; }
            thead th, tbody td { padding: 12px 10px; font-size: .82rem; }
        }
    </style>
</head>
<body>

<%-- Navbar HTML (no <style> tag, CSS is in <head> above) --%>
<%
    String adminName = (String) session.getAttribute("fullName");
    String adminId   = (String) session.getAttribute("userID");
    if (adminName == null) adminName = (adminId != null ? adminId : "Admin");
    String currentUri = request.getRequestURI();
    boolean onOrders   = currentUri.contains("AdminOrders")  || currentUri.contains("admin-orders");
    boolean onProducts = currentUri.contains("AdminProducts") || currentUri.contains("admin-products");
%>
<nav class="adm-nav">
    <a class="adm-nav__brand" href="${pageContext.request.contextPath}/AdminOrdersServlet">
        ✦ Aura<span class="adm-nav__brand-accent">Luxe</span>
        <span class="adm-nav__badge">Admin</span>
    </a>
    <ul class="adm-nav__links">
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"   class="adm-nav__link <%= onOrders   ? "adm-nav__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet" class="adm-nav__link <%= onProducts ? "adm-nav__link--active" : "" %>">💄 Products</a></li>
    </ul>
    <div class="adm-nav__right">
        <span class="adm-nav__user">👤 <%= adminName %></span>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-nav__logout">Sign Out</a>
    </div>
    <button class="adm-nav__hamburger" id="admHamburger" aria-label="Toggle menu" aria-expanded="false">
        <span></span><span></span><span></span>
    </button>
</nav>
<div class="adm-nav__drawer" id="admDrawer">
    <ul class="adm-drawer__list">
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"   class="adm-drawer__link <%= onOrders   ? "adm-drawer__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet" class="adm-drawer__link <%= onProducts ? "adm-drawer__link--active" : "" %>">💄 Products</a></li>
    </ul>
    <hr class="adm-drawer__divider">
    <div class="adm-drawer__user">👤 <%= adminName %></div>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-drawer__logout">Sign Out</a>
</div>
<script>
(function(){var b=document.getElementById('admHamburger'),d=document.getElementById('admDrawer');if(!b||!d)return;function s(v){d.classList.toggle('is-open',v);b.classList.toggle('is-open',v);b.setAttribute('aria-expanded',v);}b.addEventListener('click',function(e){e.stopPropagation();s(!d.classList.contains('is-open'));});d.querySelectorAll('a').forEach(function(a){a.addEventListener('click',function(){s(false);});});document.addEventListener('click',function(e){if(!d.contains(e.target)&&e.target!==b)s(false);});})();
</script>

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

    <% if (orders.isEmpty()) { %>
        <div class="adm-empty"><div class="adm-empty__icon">📋</div><div>No orders found.</div></div>
    <% } else { %>

    <%-- Desktop Table --%>
    <div class="adm-table-wrap">
        <table>
            <thead><tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Payment</th><th>Date</th><th>Status</th><th>Update</th></tr></thead>
            <tbody>
            <% for (OrdersModel order : orders) {
                String status = order.getStatus() != null ? order.getStatus() : "Pending";
                String bc = "badge--pending";
                if      (status.equalsIgnoreCase("Confirmed")) bc="badge--confirmed";
                else if (status.equalsIgnoreCase("Shipped"))   bc="badge--shipped";
                else if (status.equalsIgnoreCase("Delivered")) bc="badge--delivered";
                else if (status.equalsIgnoreCase("Cancelled")) bc="badge--cancelled";
            %>
                <tr>
                    <td><span class="order-id">#<%= order.getOrderId() %></span></td>
                    <td><div class="user-name"><%= order.getFullName()!=null?order.getFullName():"—" %></div><div class="user-id"><%= order.getUserId() %></div></td>
                    <td><span class="amount">Rs <%= String.format("%,.0f",order.getTotalAmount()) %></span></td>
                    <td><%= order.getPaymentMethod()!=null?order.getPaymentMethod():"—" %></td>
                    <td><%= order.getCreatedAt()!=null?order.getCreatedAt():"—" %></td>
                    <td><span class="badge <%= bc %>"><%= status %></span></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/AdminOrdersServlet" method="post" class="status-form">
                            <input type="hidden" name="orderId" value="<%= order.getOrderId() %>"/>
                            <select name="status" class="status-select">
                                <option value="Pending"   <%= status.equals("Pending")  ?"selected":"" %>>Pending</option>
                                <option value="Shipped"   <%= status.equals("Shipped")  ?"selected":"" %>>Shipped</option>
                                <option value="Delivered" <%= status.equals("Delivered")?"selected":"" %>>Delivered</option>
                                <option value="Cancelled" <%= status.equals("Cancelled")?"selected":"" %>>Cancelled</option>
                            </select>
                            <button type="submit" class="btn-update">Update</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <%-- Mobile Cards --%>
    <div class="adm-cards">
    <% for (OrdersModel order : orders) {
        String status = order.getStatus() != null ? order.getStatus() : "Pending";
        String bc = "badge--pending";
        if      (status.equalsIgnoreCase("Confirmed")) bc="badge--confirmed";
        else if (status.equalsIgnoreCase("Shipped"))   bc="badge--shipped";
        else if (status.equalsIgnoreCase("Delivered")) bc="badge--delivered";
        else if (status.equalsIgnoreCase("Cancelled")) bc="badge--cancelled";
    %>
        <div class="adm-card">
            <div class="adm-card__header">
                <div><div class="adm-card__label">Order ID</div><div class="adm-card__id">#<%= order.getOrderId() %></div></div>
                <span class="badge <%= bc %>"><%= status %></span>
            </div>
            <div class="adm-card__row">
                <div><div class="adm-card__label">Customer</div><div class="adm-card__value"><%= order.getFullName()!=null?order.getFullName():"—" %></div><div class="user-id"><%= order.getUserId() %></div></div>
                <div style="text-align:right"><div class="adm-card__label">Amount</div><div class="adm-card__amount">Rs <%= String.format("%,.0f",order.getTotalAmount()) %></div></div>
            </div>
            <div class="adm-card__row">
                <div><div class="adm-card__label">Payment</div><div class="adm-card__value"><%= order.getPaymentMethod()!=null?order.getPaymentMethod():"—" %></div></div>
                <div style="text-align:right"><div class="adm-card__label">Date</div><div class="adm-card__value" style="font-size:.8rem"><%= order.getCreatedAt()!=null?order.getCreatedAt():"—" %></div></div>
            </div>
            <hr class="adm-card__divider">
            <div class="adm-card__label" style="margin-bottom:8px">Update Status</div>
            <form action="<%= request.getContextPath() %>/AdminOrdersServlet" method="post" class="status-form">
                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>"/>
                <select name="status" class="status-select">
                    <option value="Pending"   <%= status.equals("Pending")  ?"selected":"" %>>Pending</option>
                    <option value="Shipped"   <%= status.equals("Shipped")  ?"selected":"" %>>Shipped</option>
                    <option value="Delivered" <%= status.equals("Delivered")?"selected":"" %>>Delivered</option>
                    <option value="Cancelled" <%= status.equals("Cancelled")?"selected":"" %>>Cancelled</option>
                </select>
                <button type="submit" class="btn-update">Update</button>
            </form>
        </div>
    <% } %>
    </div>

    <% } %>
</div>
</body>
</html>
