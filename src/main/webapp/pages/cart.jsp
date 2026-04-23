<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    // Security: Must be logged in
    String cartUser = (String) session.getAttribute("userID");
    if (cartUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=login_required");
        return;
    }

    // Cart data is populated by CartServlet; if accessed directly, redirect
    List<Map<String, Object>> cartItems =
        (List<Map<String, Object>>) request.getAttribute("cartItems");
    Double grandTotal = (Double) request.getAttribute("grandTotal");

    if (cartItems == null) {
        // Accessed directly without servlet — forward through the servlet
        response.sendRedirect(request.getContextPath() + "/CartServlet");
        return;
    }
    if (grandTotal == null) grandTotal = 0.0;

    String fullName = (String) session.getAttribute("fullName");
    String displayName = (fullName != null && !fullName.isEmpty()) ? fullName : cartUser;
    int itemCount = cartItems.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | My Bag</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css" />
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
                <li><a href="${pageContext.request.contextPath}/pages/home.jsp#about" class="al-navbar__link">About</a></li>
            </ul>
            <div class="al-navbar__actions">
                <span class="al-navbar__welcome">Hello, <%= displayName %></span>
                <span class="al-navbar__cart-wrap">
                    <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__icon-btn" title="Cart" style="color:var(--al-mid);">
                        <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                            <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/>
                            <line x1="3" y1="6" x2="21" y2="6"/>
                            <path d="M16 10a4 4 0 01-8 0"/>
                        </svg>
                    </a>
                    <% if (itemCount > 0) { %>
                        <span class="al-navbar__cart-badge"><%= itemCount %></span>
                    <% } %>
                </span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
            </div>
            <button class="al-navbar__hamburger" id="alNavToggle" aria-label="Toggle menu">
                <span></span><span></span><span></span>
            </button>
        </div>
        <div class="al-navbar__mobile" id="alNavMobile">
            <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
            <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__mobile-link">My Bag</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
        </div>
    </nav>

    <%-- ── PAGE HEADER ─────────────────────────────────────────── --%>
    <div class="cart-header">
        <span class="cart-header__label">AuraLuxe</span>
        <h1 class="cart-header__title">Your Beauty Bag</h1>
        <p class="cart-header__sub">
            <%= itemCount %> item<%= itemCount != 1 ? "s" : "" %> waiting for you
        </p>
    </div>

    <%-- ── MAIN CONTENT ─────────────────────────────────────────── --%>
    <div class="cart-main">

        <% if (cartItems.isEmpty()) { %>
            <%-- Empty state --%>
            <div class="cart-empty">
                <span class="cart-empty__icon">🛍️</span>
                <div class="cart-empty__title">Your bag is empty</div>
                <p class="cart-empty__sub">
                    Looks like you haven't added anything yet.<br>
                    Explore our luxurious collection!
                </p>
                <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="cart-empty__cta">
                    Shop Now
                </a>
            </div>

        <% } else { %>

            <%-- ── Item list ─────────────────────────────────────── --%>
            <div class="cart-items">
                <% for (Map<String, Object> item : cartItems) {
                    String pid   = (String) item.get("productId");
                    String pname = (String) item.get("productName");
                    String pimg  = (String) item.get("image");
                    double pprice = (Double) item.get("price");
                    int    qty   = (Integer) item.get("quantity");
                    double lineT = (Double) item.get("lineTotal");
                %>
                <div class="cart-item" id="item-<%= pid %>">

                    <div class="cart-item__img-wrap">
                        <img src="<%= pimg %>"
                             alt="<%= pname %>"
                             class="cart-item__img"
                             onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" />
                    </div>

                    <div class="cart-item__info">
                        <div class="cart-item__name"><%= pname %></div>
                        <div class="cart-item__price">Rs <%= String.format("%,.0f", pprice) %> each</div>
                        <div class="cart-item__qty-row">
                            <button class="cart-item__qty-btn"
                                    onclick="changeQty('<%= pid %>', <%= qty - 1 %>)"
                                    title="Decrease">&#8722;</button>
                            <span class="cart-item__qty-val" id="qty-<%= pid %>"><%= qty %></span>
                            <button class="cart-item__qty-btn"
                                    onclick="changeQty('<%= pid %>', <%= qty + 1 %>)"
                                    title="Increase">&#43;</button>
                        </div>
                    </div>

                    <div class="cart-item__line-total">
                        Rs <%= String.format("%,.0f", lineT) %>
                    </div>

                    <button class="cart-item__remove"
                            onclick="removeItem('<%= pid %>')"
                            title="Remove item">
                        &#x2715;
                    </button>
                </div>
                <% } %>
            </div>

            <%-- ── Summary panel ──────────────────────────────────── --%>
            <div class="cart-summary">
                <div class="cart-summary__title">Order Summary</div>

                <div class="cart-summary__row">
                    <span>Subtotal (<%= itemCount %> item<%= itemCount != 1 ? "s" : "" %>)</span>
                    <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
                </div>
                <div class="cart-summary__row">
                    <span>Shipping</span>
                    <span style="color:#27ae60;">Free</span>
                </div>

                <div class="cart-summary__row total">
                    <span>Total</span>
                    <span>Rs <%= String.format("%,.0f", grandTotal) %></span>
                </div>

                <%-- Checkout button (placeholder — wire up CheckoutServlet when ready) --%>
                <a href="#" class="cart-summary__checkout"
                   onclick="showToast('Checkout coming soon! 🛍️'); return false;">
                    Proceed to Checkout
                </a>
                <a href="${pageContext.request.contextPath}/FetchProductsServlet"
                   class="cart-summary__shop-link">
                    ← Continue Shopping
                </a>
            </div>

        <% } %>
    </div>

    <%-- ── FOOTER ───────────────────────────────────────────────── --%>
    <jsp:include page="/components/footer.jsp" />

    <%-- ── Toast ─────────────────────────────────────────────────── --%>
    <div class="al-toast" id="alToast"></div>

    <%-- ── SCRIPTS ──────────────────────────────────────────────── --%>
    <script>
    // ── Navbar toggle ─────────────────────────────────────────────
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

    // ── Toast ─────────────────────────────────────────────────────
    function showToast(msg) {
        var t = document.getElementById('alToast');
        t.textContent = msg;
        t.classList.add('show');
        setTimeout(function(){ t.classList.remove('show'); }, 3000);
    }

    // ── Remove item ───────────────────────────────────────────────
    function removeItem(productId) {
        window.location.href = '${pageContext.request.contextPath}/CartServlet?remove=' + productId;
    }

    // ── Change quantity ──────────────────────────────────────────
    function changeQty(productId, newQty) {
        if (newQty < 0) return;
        if (newQty === 0) {
            // confirm remove
            if (!confirm('Remove this item from your bag?')) return;
        }
        window.location.href = '${pageContext.request.contextPath}/CartServlet'
            + '?updateId=' + productId + '&qty=' + newQty;
    }

    // ── Show toast if coming from add-to-cart redirect ────────────
    (function(){
        var params = new URLSearchParams(window.location.search);
        var msg = params.get('cartMsg');
        if (msg === 'added')   showToast('✦ Added to your bag!');
        if (msg === 'updated') showToast('✦ Quantity updated!');
        if (msg === 'error')   showToast('Something went wrong. Please try again.');
    })();
    </script>
</body>
</html>
