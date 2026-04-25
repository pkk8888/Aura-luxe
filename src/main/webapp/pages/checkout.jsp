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

    if (cartItems == null) {
        response.sendRedirect(request.getContextPath() + "/CartServlet");
        return;
    }
    if (grandTotal == null) grandTotal = 0.0;

    if (cartItems.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
        return;
    }

    String fullName    = (String) session.getAttribute("fullName");
    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : checkUser;
    int itemCount      = cartItems.size();

    String errorMsg   = (String) request.getAttribute("errorMsg");
    String prefName   = (String) request.getAttribute("prefName");
    String prefPhone  = (String) request.getAttribute("prefPhone");
    String prefCity   = (String) request.getAttribute("prefCity");
    String prefAddr   = (String) request.getAttribute("prefAddr");
    String prefPay    = (String) request.getAttribute("prefPayment");
    if (prefName  == null) prefName  = fullName != null ? fullName : "";
    if (prefPhone == null) prefPhone = "";
    if (prefCity  == null) prefCity  = "";
    if (prefAddr  == null) prefAddr  = "";
    if (prefPay   == null) prefPay   = "cod";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Checkout</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css" />
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

<%-- ── PAGE HEADER ─────────────────────────────────────────── --%>
<div class="co-header">
    <span class="co-header__label">AuraLuxe</span>
    <h1 class="co-header__title">Checkout</h1>
    <p class="co-header__sub">You're one step away from your beauty haul</p>
</div>

<%-- ── BREADCRUMB ───────────────────────────────────────────── --%>
<div class="co-breadcrumb">
    <div class="co-breadcrumb__inner">
        <span class="co-breadcrumb__step co-breadcrumb__step--done">
            <span class="co-breadcrumb__dot">✓</span> Bag
        </span>
        <span class="co-breadcrumb__line"></span>
        <span class="co-breadcrumb__step co-breadcrumb__step--active">
            <span class="co-breadcrumb__dot">2</span> Checkout
        </span>
        <span class="co-breadcrumb__line"></span>
        <span class="co-breadcrumb__step">
            <span class="co-breadcrumb__dot">3</span> Confirmation
        </span>
    </div>
</div>

<%-- ── ERROR ────────────────────────────────────────────────── --%>
<% if (errorMsg != null && !errorMsg.isEmpty()) { %>
<div class="co-error-banner">
    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
    </svg>
    <%= errorMsg %>
</div>
<% } %>

<%-- ── MAIN ─────────────────────────────────────────────────── --%>
<div class="co-main">

    <%-- LEFT: Form --%>
    <div class="co-left">

        <%-- Delivery details --%>
        <div class="co-card">
            <div class="co-card__head">
                <span class="co-card__icon">📦</span>
                <h2 class="co-card__title">Delivery Details</h2>
            </div>

            <form action="${pageContext.request.contextPath}/PlaceOrderServlet" method="post" id="checkoutForm">

                <div class="co-form-row">
                    <div class="co-field">
                        <label class="co-label" for="fullName">Full Name <span class="co-req">*</span></label>
                        <input type="text" id="fullName" name="fullName"
                               class="co-input" placeholder="e.g. Prakriti Karki"
                               value="<%= prefName %>" required />
                    </div>
                    <div class="co-field">
                        <label class="co-label" for="phone">Phone Number <span class="co-req">*</span></label>
                        <input type="tel" id="phone" name="phone"
                               class="co-input" placeholder="e.g. 9800000000"
                               value="<%= prefPhone %>" required />
                    </div>
                </div>

                <div class="co-form-row">
                    <div class="co-field">
                        <label class="co-label" for="city">City <span class="co-req">*</span></label>
                        <select id="city" name="city" class="co-input co-select" required>
                            <option value="" disabled <%= prefCity.isEmpty() ? "selected" : "" %>>Select your city</option>
                            <option value="Kathmandu"    <%= "Kathmandu".equals(prefCity)    ? "selected" : "" %>>Kathmandu</option>
                            <option value="Lalitpur"     <%= "Lalitpur".equals(prefCity)     ? "selected" : "" %>>Lalitpur</option>
                            <option value="Bhaktapur"    <%= "Bhaktapur".equals(prefCity)    ? "selected" : "" %>>Bhaktapur</option>
                            <option value="Pokhara"      <%= "Pokhara".equals(prefCity)      ? "selected" : "" %>>Pokhara</option>
                            <option value="Chitwan"      <%= "Chitwan".equals(prefCity)      ? "selected" : "" %>>Chitwan</option>
                            <option value="Biratnagar"   <%= "Biratnagar".equals(prefCity)   ? "selected" : "" %>>Biratnagar</option>
                            <option value="Birgunj"      <%= "Birgunj".equals(prefCity)      ? "selected" : "" %>>Birgunj</option>
                            <option value="Dharan"       <%= "Dharan".equals(prefCity)       ? "selected" : "" %>>Dharan</option>
                            <option value="Butwal"       <%= "Butwal".equals(prefCity)       ? "selected" : "" %>>Butwal</option>
                            <option value="Other"        <%= "Other".equals(prefCity)        ? "selected" : "" %>>Other</option>
                        </select>
                    </div>
                    <div class="co-field">
                        <label class="co-label" for="address">Delivery Address <span class="co-req">*</span></label>
                        <input type="text" id="address" name="address"
                               class="co-input" placeholder="Street / Area / Landmark"
                               value="<%= prefAddr %>" required />
                    </div>
                </div>

                <%-- Payment method --%>
                <div class="co-card__head" style="margin-top:32px; margin-bottom:20px;">
                    <span class="co-card__icon">💳</span>
                    <h2 class="co-card__title">Payment Method</h2>
                </div>

                <div class="co-payment-options">

                    <label class="co-pay-option <%= "cod".equals(prefPay) ? "co-pay-option--selected" : "" %>" id="lbl-cod">
                        <input type="radio" name="payment" value="cod"
                               <%= "cod".equals(prefPay) ? "checked" : "" %>
                               onchange="selectPay('cod')" />
                        <div class="co-pay-option__icon co-pay-option__icon--cod">💵</div>
                        <div class="co-pay-option__text">
                            <div class="co-pay-option__name">Cash on Delivery</div>
                            <div class="co-pay-option__desc">Pay when your order arrives</div>
                        </div>
                        <div class="co-pay-option__check">✓</div>
                    </label>

                    <label class="co-pay-option <%= "esewa".equals(prefPay) ? "co-pay-option--selected" : "" %>" id="lbl-esewa">
                        <input type="radio" name="payment" value="esewa"
                               <%= "esewa".equals(prefPay) ? "checked" : "" %>
                               onchange="selectPay('esewa')" />
                        <div class="co-pay-option__icon co-pay-option__icon--esewa">
                            <span style="color:#60bb46;font-weight:800;font-size:13px;">e</span>Sewa
                        </div>
                        <div class="co-pay-option__text">
                            <div class="co-pay-option__name">eSewa</div>
                            <div class="co-pay-option__desc">Pay via eSewa digital wallet</div>
                        </div>
                        <div class="co-pay-option__check">✓</div>
                    </label>

                    <label class="co-pay-option <%= "khalti".equals(prefPay) ? "co-pay-option--selected" : "" %>" id="lbl-khalti">
                        <input type="radio" name="payment" value="khalti"
                               <%= "khalti".equals(prefPay) ? "checked" : "" %>
                               onchange="selectPay('khalti')" />
                        <div class="co-pay-option__icon co-pay-option__icon--khalti">
                            <span style="color:#5c2d91;font-weight:800;font-size:13px;">K</span>
                        </div>
                        <div class="co-pay-option__text">
                            <div class="co-pay-option__name">Khalti</div>
                            <div class="co-pay-option__desc">Pay via Khalti digital wallet</div>
                        </div>
                        <div class="co-pay-option__check">✓</div>
                    </label>

                </div>

            </form>
        </div>
    </div>

    <%-- RIGHT: Order summary --%>
    <div class="co-right">
        <div class="co-summary">
            <div class="co-summary__title">Order Summary</div>

            <div class="co-summary__items">
                <% for (Map<String, Object> item : cartItems) {
                    String pname  = (String) item.get("productName");
                    String pimg   = (String) item.get("image");
                    double pprice = (Double) item.get("price");
                    int    qty    = (Integer) item.get("quantity");
                    double lineT  = (Double) item.get("lineTotal");
                %>
                <div class="co-summary__item">
                    <div class="co-summary__item-img">
                        <img src="<%= pimg %>" alt="<%= pname %>"
                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" />
                        <span class="co-summary__item-qty"><%= qty %></span>
                    </div>
                    <div class="co-summary__item-info">
                        <div class="co-summary__item-name"><%= pname %></div>
                        <div class="co-summary__item-unit">Rs <%= String.format("%,.0f", pprice) %> each</div>
                    </div>
                    <div class="co-summary__item-total">Rs <%= String.format("%,.0f", lineT) %></div>
                </div>
                <% } %>
            </div>

            <div class="co-summary__divider"></div>

            <div class="co-summary__row">
                <span>Subtotal (<%= itemCount %> item<%= itemCount != 1 ? "s" : "" %>)</span>
                <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
            </div>
            <div class="co-summary__row">
                <span>Shipping</span>
                <span class="co-summary__free">Free</span>
            </div>

            <div class="co-summary__divider"></div>

            <div class="co-summary__total">
                <span>Total</span>
                <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
            </div>

            <button type="submit" form="checkoutForm" class="co-summary__btn">
                Place Order
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </button>

            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="co-summary__back">
                ← Back to Shop
            </a>
        </div>
    </div>

</div>

<%-- ── FOOTER ───────────────────────────────────────────────── --%>
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

function selectPay(val) {
    document.querySelectorAll('.co-pay-option').forEach(function(el) {
        el.classList.remove('co-pay-option--selected');
    });
    var lbl = document.getElementById('lbl-' + val);
    if (lbl) lbl.classList.add('co-pay-option--selected');
}
</script>

</body>
</html>
