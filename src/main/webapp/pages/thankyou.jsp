<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }

    String fullName    = (String) session.getAttribute("fullName");
    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : checkUser;

    /* Order details passed from PlaceOrderServlet */
    String  orderId      = (String)  request.getAttribute("orderId");
    String  paymentMethod = (String) request.getAttribute("paymentMethod");
    String  deliveryAddr  = (String) request.getAttribute("deliveryAddress");
    String  deliveryCity  = (String) session.getAttribute("city");
    Double  orderTotal    = (Double) request.getAttribute("orderTotal");
    Integer itemCount     = (Integer) request.getAttribute("itemCount");

    if (orderId     == null) orderId      = "AL-" + System.currentTimeMillis();
    if (paymentMethod == null) paymentMethod = "Cash on Delivery";
    if (deliveryAddr  == null) deliveryAddr  = "Your saved address";
    if (deliveryCity  == null) deliveryCity  = "";
    if (orderTotal    == null) orderTotal    = 0.0;
    if (itemCount     == null) itemCount     = 0;

    /* Friendly payment label */
    String payLabel = paymentMethod;
    if ("cod".equalsIgnoreCase(paymentMethod))    payLabel = "Cash on Delivery";
    if ("esewa".equalsIgnoreCase(paymentMethod))  payLabel = "eSewa";
    if ("khalti".equalsIgnoreCase(paymentMethod)) payLabel = "Khalti";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Order Confirmed ✦</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/thankyou.css" />
</head>
<body>

<%-- ── NAVBAR ──────────────────────────────────────────────── --%>
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
            <li><a href="${pageContext.request.contextPath}/pages/home.jsp#collections" class="al-navbar__link">Collections</a></li>
        </ul>
        <div class="al-navbar__actions">
            <span class="al-navbar__welcome">Hello, <%= displayName %></span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
        </div>
        <button class="al-navbar__hamburger" id="alNavToggle" aria-label="Toggle menu">
            <span></span><span></span><span></span>
        </button>
    </div>
    <div class="al-navbar__mobile" id="alNavMobile">
        <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
    </div>
</nav>

<%-- ── BREADCRUMB ───────────────────────────────────────────── --%>
<div class="co-breadcrumb">
    <div class="co-breadcrumb__inner">
        <span class="co-breadcrumb__step co-breadcrumb__step--done">
            <span class="co-breadcrumb__dot">✓</span> Bag
        </span>
        <span class="co-breadcrumb__line"></span>
        <span class="co-breadcrumb__step co-breadcrumb__step--done">
            <span class="co-breadcrumb__dot">✓</span> Checkout
        </span>
        <span class="co-breadcrumb__line"></span>
        <span class="co-breadcrumb__step co-breadcrumb__step--active">
            <span class="co-breadcrumb__dot">3</span> Confirmation
        </span>
    </div>
</div>

<%-- ── HERO ─────────────────────────────────────────────────── --%>
<div class="ty-hero">
    <div class="ty-hero__petals" aria-hidden="true">
        <span class="ty-petal ty-petal--1">✦</span>
        <span class="ty-petal ty-petal--2">❀</span>
        <span class="ty-petal ty-petal--3">✦</span>
        <span class="ty-petal ty-petal--4">❀</span>
        <span class="ty-petal ty-petal--5">✦</span>
        <span class="ty-petal ty-petal--6">❀</span>
    </div>

    <div class="ty-hero__check">
        <svg class="ty-hero__check-svg" viewBox="0 0 60 60" fill="none" xmlns="http://www.w3.org/2000/svg">
            <circle class="ty-hero__check-ring" cx="30" cy="30" r="27" stroke-width="2.5"/>
            <polyline class="ty-hero__check-tick" points="16,30 25,40 44,20" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
    </div>

    <span class="ty-hero__eyebrow">AuraLuxe</span>
    <h1 class="ty-hero__title">Thank You, <%= displayName %>!</h1>
    <p class="ty-hero__sub">Your order has been placed and is being lovingly prepared for you.</p>

    <div class="ty-hero__order-badge">
        <span class="ty-hero__order-label">Order ID</span>
        <span class="ty-hero__order-id"><%= orderId %></span>
    </div>
</div>

<%-- ── DETAILS GRID ────────────────────────────────────────── --%>
<div class="ty-grid">

    <%-- Card: Order Summary --%>
    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">🛍️</span>
            <h2 class="ty-card__title">Order Summary</h2>
        </div>
        <div class="ty-card__rows">
            <div class="ty-card__row">
                <span class="ty-card__key">Items</span>
                <span class="ty-card__val"><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %></span>
            </div>
            <div class="ty-card__row">
                <span class="ty-card__key">Shipping</span>
                <span class="ty-card__val ty-card__val--free">Free</span>
            </div>
            <div class="ty-card__divider"></div>
            <div class="ty-card__row ty-card__row--total">
                <span class="ty-card__key">Total Paid</span>
                <span class="ty-card__val ty-card__val--total">Rs <%= String.format("%,.0f", orderTotal) %></span>
            </div>
        </div>
    </div>

    <%-- Card: Delivery Info --%>
    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">📦</span>
            <h2 class="ty-card__title">Delivery Details</h2>
        </div>
        <div class="ty-card__rows">
            <div class="ty-card__row">
                <span class="ty-card__key">Name</span>
                <span class="ty-card__val"><%= displayName %></span>
            </div>
            <div class="ty-card__row">
                <span class="ty-card__key">Address</span>
                <span class="ty-card__val"><%= deliveryAddr %><% if (!deliveryCity.isEmpty()) { %>, <%= deliveryCity %><% } %></span>
            </div>
            <div class="ty-card__row">
                <span class="ty-card__key">Estimated</span>
                <span class="ty-card__val">3–5 Business Days</span>
            </div>
        </div>
    </div>

    <%-- Card: Payment --%>
    <div class="ty-card">
        <div class="ty-card__head">
            <span class="ty-card__icon">💳</span>
            <h2 class="ty-card__title">Payment</h2>
        </div>
        <div class="ty-card__rows">
            <div class="ty-card__row">
                <span class="ty-card__key">Method</span>
                <span class="ty-card__val"><%= payLabel %></span>
            </div>
            <div class="ty-card__row">
                <span class="ty-card__key">Status</span>
                <span class="ty-card__val ty-card__val--confirmed">
                    <span class="ty-status-dot"></span>
                    <% if ("cod".equalsIgnoreCase(paymentMethod)) { %>Pending on Delivery<% } else { %>Confirmed<% } %>
                </span>
            </div>
        </div>
    </div>

</div>

<%-- ── WHAT'S NEXT ────────────────────────────────────────── --%>
<div class="ty-timeline">
    <h3 class="ty-timeline__heading">What Happens Next?</h3>
    <div class="ty-timeline__track">
        <div class="ty-timeline__item ty-timeline__item--done">
            <div class="ty-timeline__dot">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <polyline points="20 6 9 17 4 12"/>
                </svg>
            </div>
            <div class="ty-timeline__content">
                <div class="ty-timeline__step">Order Placed</div>
                <div class="ty-timeline__desc">We've received your order</div>
            </div>
        </div>
        <div class="ty-timeline__connector"></div>
        <div class="ty-timeline__item ty-timeline__item--active">
            <div class="ty-timeline__dot">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path d="M20 7H4a2 2 0 00-2 2v10a2 2 0 002 2h16a2 2 0 002-2V9a2 2 0 00-2-2z"/><path d="M16 3H8a2 2 0 00-2 2v2h12V5a2 2 0 00-2-2z"/>
                </svg>
            </div>
            <div class="ty-timeline__content">
                <div class="ty-timeline__step">Packing</div>
                <div class="ty-timeline__desc">Your beauty products are being packed</div>
            </div>
        </div>
        <div class="ty-timeline__connector"></div>
        <div class="ty-timeline__item">
            <div class="ty-timeline__dot">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <rect x="1" y="3" width="15" height="13"/><path d="M16 8h4l3 3v5h-7V8z"/><circle cx="5.5" cy="18.5" r="2.5"/><circle cx="18.5" cy="18.5" r="2.5"/>
                </svg>
            </div>
            <div class="ty-timeline__content">
                <div class="ty-timeline__step">Out for Delivery</div>
                <div class="ty-timeline__desc">On its way to your doorstep</div>
            </div>
        </div>
        <div class="ty-timeline__connector"></div>
        <div class="ty-timeline__item">
            <div class="ty-timeline__dot">
                <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path d="M3 9l9-7 9 7v11a2 2 0 01-2 2H5a2 2 0 01-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
                </svg>
            </div>
            <div class="ty-timeline__content">
                <div class="ty-timeline__step">Delivered</div>
                <div class="ty-timeline__desc">Enjoy your AuraLuxe order!</div>
            </div>
        </div>
    </div>
</div>

<%-- ── CTA BUTTONS ─────────────────────────────────────────── --%>
<div class="ty-actions">
    <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="ty-btn ty-btn--primary">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/><path d="M16 10a4 4 0 01-8 0"/>
        </svg>
        Continue Shopping
    </a>
    <a href="${pageContext.request.contextPath}/pages/home.jsp" class="ty-btn ty-btn--ghost">
        Back to Home
    </a>
</div>

<%-- ── FOOTER ───────────────────────────────────────────────── --%>
<jsp:include page="/components/footer.jsp" />

<script>
(function(){
    var btn    = document.getElementById('alNavToggle');
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
