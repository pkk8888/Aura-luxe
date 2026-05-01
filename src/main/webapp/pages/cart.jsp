<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=login_required");
        return;
    }

    List<Map<String, Object>> cartItems =
        (List<Map<String, Object>>) request.getAttribute("cartItems");
    Double grandTotal = (Double) request.getAttribute("grandTotal");

    // If accessed directly (not via CartServlet), redirect through servlet
    if (cartItems == null) {
        response.sendRedirect(request.getContextPath() + "/CartServlet");
        return;
    }
    if (grandTotal == null) grandTotal = 0.0;

    String fullName    = (String) session.getAttribute("fullName");
    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : checkUser;
    int itemCount      = cartItems.size();
    Integer cartCount  = (Integer) request.getAttribute("cartCount");
    if (cartCount == null) cartCount = itemCount;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | My Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #fdf6f8; color: #2a0d17; min-height: 100vh; }

        /* ── Page header ── */
        .cart-header {
            background: linear-gradient(135deg, #2a0d17 0%, #5c1a2e 100%);
            color: #fff;
            text-align: center;
            padding: 48px 20px 36px;
        }
        .cart-header__label { font-size: 11px; letter-spacing: 3px; text-transform: uppercase; opacity: .6; display: block; margin-bottom: 10px; }
        .cart-header__title { font-size: 2.2rem; font-weight: 700; margin-bottom: 8px; }
        .cart-header__sub   { font-size: 1rem; opacity: .75; }

        /* ── Layout ── */
        .cart-main {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 32px;
            align-items: start;
        }
        @media (max-width: 800px) {
            .cart-main { grid-template-columns: 1fr; }
        }

        /* ── Empty state ── */
        .cart-empty {
            grid-column: 1 / -1;
            text-align: center;
            padding: 80px 20px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(42,13,23,.07);
        }
        .cart-empty__icon { font-size: 4rem; margin-bottom: 16px; }
        .cart-empty__title { font-size: 1.5rem; font-weight: 700; margin-bottom: 10px; color: #2a0d17; }
        .cart-empty__sub   { color: #8a5060; margin-bottom: 28px; }
        .cart-empty__btn {
            display: inline-block;
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff;
            padding: 14px 32px;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: opacity .2s;
        }
        .cart-empty__btn:hover { opacity: .88; }

        /* ── Items list ── */
        .cart-items { display: flex; flex-direction: column; gap: 16px; }
        .cart-item {
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(42,13,23,.07);
            display: flex;
            align-items: center;
            gap: 20px;
            padding: 18px 20px;
        }
        .cart-item__img {
            width: 88px; height: 88px;
            border-radius: 10px;
            object-fit: cover;
            flex-shrink: 0;
            border: 1px solid #f0dce3;
        }
        .cart-item__info { flex: 1; min-width: 0; }
        .cart-item__name { font-size: 1rem; font-weight: 700; color: #2a0d17; margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .cart-item__price { font-size: .9rem; color: #8a5060; }

        /* Quantity controls */
        .cart-item__qty-wrap { display: flex; align-items: center; gap: 0; border: 1.5px solid #e8c4d0; border-radius: 8px; overflow: hidden; }
        .cart-item__qty-btn {
            background: #fdf0f4; border: none; width: 34px; height: 34px;
            font-size: 1.1rem; font-weight: 700; color: #7b1d36;
            cursor: pointer; transition: background .15s;
            display: flex; align-items: center; justify-content: center;
        }
        .cart-item__qty-btn:hover { background: #f5d5df; }
        .cart-item__qty-val { width: 38px; text-align: center; font-weight: 700; font-size: .95rem; color: #2a0d17; border: none; background: #fff; }

        /* Line total & remove */
        .cart-item__right { display: flex; flex-direction: column; align-items: flex-end; gap: 12px; flex-shrink: 0; }
        .cart-item__total { font-weight: 800; font-size: 1.05rem; color: #2a0d17; }
        .cart-item__remove {
            background: none; border: none; cursor: pointer;
            color: #c0394b; font-size: .78rem; font-weight: 600;
            text-transform: uppercase; letter-spacing: .5px;
            padding: 4px 0; transition: opacity .15s;
        }
        .cart-item__remove:hover { opacity: .7; }

        /* ── Summary card ── */
        .cart-summary {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 16px rgba(42,13,23,.09);
            padding: 28px 24px;
            position: sticky;
            top: 80px;
        }
        .cart-summary__title { font-size: 1.15rem; font-weight: 800; color: #2a0d17; margin-bottom: 24px; }
        .cart-summary__row { display: flex; justify-content: space-between; font-size: .9rem; color: #6a3545; margin-bottom: 12px; }
        .cart-summary__free { color: #3a9a5c; font-weight: 700; }
        .cart-summary__divider { border: none; border-top: 1.5px solid #f0dce3; margin: 16px 0; }
        .cart-summary__total { display: flex; justify-content: space-between; font-size: 1.1rem; font-weight: 800; color: #2a0d17; margin-bottom: 24px; }
        .cart-summary__btn {
            display: flex; align-items: center; justify-content: center; gap: 8px;
            width: 100%;
            background: linear-gradient(135deg,#7b1d36,#c0394b);
            color: #fff;
            border: none; border-radius: 50px;
            padding: 15px 24px;
            font-size: 1rem; font-weight: 700;
            cursor: pointer; text-decoration: none;
            transition: opacity .2s;
        }
        .cart-summary__btn:hover { opacity: .88; }
        .cart-summary__back { display: block; text-align: center; margin-top: 14px; color: #8a5060; font-size: .85rem; text-decoration: none; }
        .cart-summary__back:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%-- ── NAVBAR ──────────────────────────────────────────────── --%>
<jsp:include page="/components/navbar.jsp" />

<%-- ── PAGE HEADER ─────────────────────────────────────────── --%>
<div class="cart-header">
    <span class="cart-header__label">AuraLuxe</span>
    <h1 class="cart-header__title">My Cart</h1>
    <p class="cart-header__sub">
        <% if (itemCount > 0) { %>
            <%= itemCount %> item<%= itemCount != 1 ? "s" : "" %> in your bag
        <% } else { %>
            Your bag is empty
        <% } %>
    </p>
</div>

<%-- ── MAIN ─────────────────────────────────────────────────── --%>
<div class="cart-main">

<% if (cartItems.isEmpty()) { %>
    <%-- Empty state --%>
    <div class="cart-empty">
        <div class="cart-empty__icon">🛍️</div>
        <div class="cart-empty__title">Your bag is empty</div>
        <div class="cart-empty__sub">Looks like you haven't added anything yet.</div>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="cart-empty__btn">Start Shopping</a>
    </div>

<% } else { %>

    <%-- LEFT: Items --%>
    <div class="cart-items">
        <% for (Map<String, Object> item : cartItems) {
            String pid   = (String)  item.get("productId");
            String pname = (String)  item.get("productName");
            String pimg  = (String)  item.get("image");
            double price = (Double)  item.get("price");
            int    qty   = (Integer) item.get("quantity");
            double lineT = (Double)  item.get("lineTotal");
        %>
        <div class="cart-item">
            <img class="cart-item__img"
                 src="${pageContext.request.contextPath}/images/<%= pimg %>"
                 alt="<%= pname %>"
                 onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" />

            <div class="cart-item__info">
                <div class="cart-item__name"><%= pname %></div>
                <div class="cart-item__price">Rs <%= String.format("%,.0f", price) %> each</div>
            </div>

            <%-- Quantity controls --%>
            <div class="cart-item__qty-wrap">
                <% int newDecrease = qty - 1; %>
                <a href="${pageContext.request.contextPath}/CartServlet?updateId=<%= pid %>&qty=<%= newDecrease %>"
                   class="cart-item__qty-btn" title="Decrease">−</a>
                <span class="cart-item__qty-val"><%= qty %></span>
                <% int newIncrease = qty + 1; %>
                <a href="${pageContext.request.contextPath}/CartServlet?updateId=<%= pid %>&qty=<%= newIncrease %>"
                   class="cart-item__qty-btn" title="Increase">+</a>
            </div>

            <div class="cart-item__right">
                <div class="cart-item__total">Rs <%= String.format("%,.0f", lineT) %></div>
                <form action="${pageContext.request.contextPath}/CartServlet" method="get" style="margin:0;">
                    <input type="hidden" name="remove" value="<%= pid %>" />
                    <button type="submit" class="cart-item__remove">Remove</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>

    <%-- RIGHT: Summary --%>
    <div class="cart-summary">
        <div class="cart-summary__title">Order Summary</div>

        <div class="cart-summary__row">
            <span>Subtotal (<%= itemCount %> item<%= itemCount != 1 ? "s" : "" %>)</span>
            <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
        </div>
        <div class="cart-summary__row">
            <span>Shipping</span>
            <span class="cart-summary__free">Free</span>
        </div>

        <hr class="cart-summary__divider" />

        <div class="cart-summary__total">
            <span>Total</span>
            <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
        </div>

        <a href="${pageContext.request.contextPath}/CheckoutServlet" class="cart-summary__btn">
            Proceed to Checkout
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                <path d="M5 12h14M12 5l7 7-7 7"/>
            </svg>
        </a>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="cart-summary__back">← Continue Shopping</a>
    </div>

<% } %>
</div>

<%-- ── FOOTER ───────────────────────────────────────────────── --%>
<jsp:include page="/components/footer.jsp" />

</body>
</html>
