<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String fullName    = (String) session.getAttribute("fullName");
    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : checkUser;

    String  orderId       = (String)  request.getAttribute("orderId");
    String  paymentMethod = (String)  request.getAttribute("paymentMethod");
    String  deliveryAddr  = (String)  request.getAttribute("deliveryAddress");
    String  deliveryCity  = (String)  request.getAttribute("deliveryCity");
    Double  orderTotal    = (Double)  request.getAttribute("orderTotal");
    Integer itemCount     = (Integer) request.getAttribute("itemCount");

    if (orderId       == null) orderId       = "AL-" + System.currentTimeMillis();
    if (paymentMethod == null) paymentMethod = "cod";
    if (deliveryAddr  == null) deliveryAddr  = "—";
    if (deliveryCity  == null) deliveryCity  = "";
    if (orderTotal    == null) orderTotal    = 0.0;
    if (itemCount     == null) itemCount     = 0;

    String payLabel = paymentMethod;
    if ("cod".equalsIgnoreCase(paymentMethod))    payLabel = "Cash on Delivery";
    if ("esewa".equalsIgnoreCase(paymentMethod))  payLabel = "eSewa";
    if ("khalti".equalsIgnoreCase(paymentMethod)) payLabel = "Khalti";

    String fullAddress = deliveryAddr + (deliveryCity.isEmpty() ? "" : ", " + deliveryCity);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Order Confirmed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #fdf6f8; color: #2a0d17; min-height: 100vh; }

        /* Hero */
        .ty-hero {
            background: linear-gradient(135deg, #2a0d17 0%, #5c1a2e 100%);
            color: #fff;
            text-align: center;
            padding: 60px 20px 50px;
        }
        .ty-hero__title { font-size: 2.4rem; font-weight: 800; margin-bottom: 12px; }
        .ty-hero__sub   { font-size: 1rem; opacity: .75; margin-bottom: 28px; }
        .ty-hero__badge {
            display: inline-block;
            background: rgba(255,255,255,.08);
            border: 1px solid rgba(255,255,255,.2);
            border-radius: 12px;
            padding: 14px 32px;
        }
        .ty-hero__badge-label { font-size: 10px; letter-spacing: 3px; text-transform: uppercase; opacity: .6; display: block; margin-bottom: 6px; }
        .ty-hero__badge-id    { font-size: 1.3rem; font-weight: 800; letter-spacing: 1px; }

        /* Cards grid */
        .ty-grid {
            max-width: 960px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        @media (max-width: 720px) { .ty-grid { grid-template-columns: 1fr; } }

        .ty-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 2px 14px rgba(42,13,23,.08);
            padding: 24px 22px;
        }
        .ty-card__head {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 20px;
        }
        .ty-card__icon  { font-size: 1.3rem; }
        .ty-card__title { font-size: 1rem; font-weight: 800; color: #2a0d17; }

        .ty-card__row {
            display: flex; justify-content: space-between; align-items: flex-start;
            font-size: .88rem; margin-bottom: 12px; gap: 12px;
        }
        .ty-card__key   { color: #9a6070; flex-shrink: 0; }
        .ty-card__val   { font-weight: 600; color: #2a0d17; text-align: right; }
        .ty-card__val--free    { color: #3a9a5c; }
        .ty-card__val--total   { color: #7b1d36; font-size: 1rem; }
        .ty-card__divider      { border-top: 1px solid #f0dce3; margin: 12px 0; }

        .ty-status-dot {
            display: inline-block; width: 8px; height: 8px;
            background: #3a9a5c; border-radius: 50; margin-right: 6px;
        }
        .ty-card__val--confirmed { color: #3a9a5c; display: flex; align-items: center; }

        /* Actions */
        .ty-actions {
            text-align: center;
            padding: 10px 20px 60px;
            display: flex; justify-content: center; gap: 14px; flex-wrap: wrap;
        }
        .ty-btn {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 13px 28px; border-radius: 50px;
            font-size: .95rem; font-weight: 600; text-decoration: none;
            transition: opacity .2s;
        }
        .ty-btn:hover { opacity: .85; }
        .ty-btn--primary { background: linear-gradient(135deg,#7b1d36,#c0394b); color: #fff; }
        .ty-btn--ghost   { border: 1.5px solid #c0394b; color: #c0394b; background: transparent; }
    </style>
</head>
<body>

<%-- Navbar --%>
<nav class="al-navbar">
    <div class="al-navbar__inner">
        <a class="al-navbar__brand" href="${pageContext.request.contextPath}/pages/home.jsp">
            <span class="al-navbar__brand-star">✦</span>
            Aura<span class="al-navbar__brand-luxe">Luxe</span>
            <span class="al-navbar__brand-star">✦</span>
        </a>
        <ul class="al-navbar__links">
            <li><a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__link">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__link">Shop</a></li>
        </ul>
        <div class="al-navbar__actions">
            <span class="al-navbar__welcome">Hello, <%= displayName %></span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
        </div>
        <button class="al-navbar__hamburger" id="alNavToggle"><span></span><span></span><span></span></button>
    </div>
    <div class="al-navbar__mobile" id="alNavMobile">
        <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
    </div>
</nav>

<%-- Hero --%>
<div class="ty-hero">
    <h1 class="ty-hero__title">Thank You, <%= displayName %>!</h1>
    <p class="ty-hero__sub">Your order has been placed and is being lovingly prepared for you.</p>
    <div class="ty-hero__badge">
        <span class="ty-hero__badge-label">Order ID</span>
        <span class="ty-hero__badge-id"><%= orderId %></span>
    </div>
</div>

<%-- 3 Cards --%>
<div class="ty-grid">

    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">🛍️</span>
            <h2 class="ty-card__title">Order Summary</h2>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Items</span>
            <span class="ty-card__val"><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %></span>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Shipping</span>
            <span class="ty-card__val ty-card__val--free">Free</span>
        </div>
        <div class="ty-card__divider"></div>
        <div class="ty-card__row">
            <span class="ty-card__key">Total Paid</span>
            <span class="ty-card__val ty-card__val--total">Rs <%= String.format("%,.0f", orderTotal) %></span>
        </div>
    </div>

    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">📦</span>
            <h2 class="ty-card__title">Delivery Details</h2>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Name</span>
            <span class="ty-card__val"><%= displayName %></span>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Address</span>
            <span class="ty-card__val"><%= fullAddress %></span>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Estimated</span>
            <span class="ty-card__val">3–5 Business Days</span>
        </div>
    </div>

    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">💳</span>
            <h2 class="ty-card__title">Payment</h2>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Method</span>
            <span class="ty-card__val"><%= payLabel %></span>
        </div>
        <div class="ty-card__row">
            <span class="ty-card__key">Status</span>
            <span class="ty-card__val ty-card__val--confirmed">
                <span class="ty-status-dot"></span>
                <%= "cod".equalsIgnoreCase(paymentMethod) ? "Pending on Delivery" : "Confirmed" %>
            </span>
        </div>
    </div>

</div>

<%-- Actions --%>
<div class="ty-actions">
    <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="ty-btn ty-btn--primary">Continue Shopping</a>
    <a href="${pageContext.request.contextPath}/pages/home.jsp" class="ty-btn ty-btn--ghost">Back to Home</a>
</div>

<jsp:include page="/components/footer.jsp" />

<script>
(function(){
    var btn = document.getElementById('alNavToggle');
    var drawer = document.getElementById('alNavMobile');
    if(btn && drawer){
        btn.addEventListener('click', function(){
            drawer.classList.toggle('al-navbar__mobile--open');
            btn.classList.toggle('al-navbar__hamburger--open');
        });
    }
    window.addEventListener('scroll', function(){
        var nav = document.querySelector('.al-navbar');
        if(nav) nav.classList.toggle('al-navbar--scrolled', window.scrollY > 60);
    });
})();
</script>

</body>
</html>
