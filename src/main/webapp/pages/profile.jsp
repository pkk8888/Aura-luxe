<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=login_required");
        return;
    }

    // These are set by ProfileServlet
    String userId    = (String) session.getAttribute("userID");
    String fullName  = (String) request.getAttribute("fullName");
    String email     = (String) request.getAttribute("email");
    String phone     = (String) request.getAttribute("phone");
    String address   = (String) request.getAttribute("address");

    if (fullName == null) fullName = userId;
    String initials = fullName.length() >= 2
        ? String.valueOf(fullName.charAt(0)).toUpperCase()
        : String.valueOf(fullName.charAt(0)).toUpperCase();

    String successMsg = (String) request.getAttribute("successMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css" />
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
            <span class="al-navbar__welcome">Hello, <%= fullName %></span>
            <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__icon-btn" title="Cart">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 01-8 0"/>
                </svg>
            </a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
        </div>
        <button class="al-navbar__hamburger" id="alNavToggle" aria-label="Toggle menu">
            <span></span><span></span><span></span>
        </button>
    </div>
    <div class="al-navbar__mobile" id="alNavMobile">
        <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
        <a href="${pageContext.request.contextPath}/ProfileServlet" class="al-navbar__mobile-link">My Profile</a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
    </div>
</nav>

<%-- ── HEADER ────────────────────────────────────────────────── --%>
<div class="pf-header">
    <span class="pf-header__eyebrow">AuraLuxe</span>
    <h1 class="pf-header__title">My Profile</h1>
    <p class="pf-header__sub">Manage your account details</p>
</div>

<%-- ── LAYOUT ───────────────────────────────────────────────── --%>
<div class="pf-layout">

    <%-- Sidebar --%>
    <aside class="pf-sidebar">
        <div class="pf-avatar">
            <div class="pf-avatar__circle"><%= initials %></div>
            <div class="pf-avatar__name"><%= fullName %></div>
            <div class="pf-avatar__id">@<%= userId %></div>
        </div>
        <nav class="pf-nav">
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="pf-nav__link pf-nav__link--active">
                <span class="pf-nav__icon">👤</span> My Profile
            </a>
            <a href="${pageContext.request.contextPath}/EditProfileServlet" class="pf-nav__link">
                <span class="pf-nav__icon">✏️</span> Edit Profile
            </a>
            <a href="${pageContext.request.contextPath}/pages/change-password.jsp" class="pf-nav__link">
                <span class="pf-nav__icon">🔒</span> Change Password
            </a>
            <div class="pf-nav__divider"></div>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="pf-nav__link">
                <span class="pf-nav__icon">🛍️</span> Shop
            </a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="pf-nav__link">
                <span class="pf-nav__icon">🚪</span> Sign Out
            </a>
        </nav>
    </aside>

    <%-- Main --%>
    <main>
        <% if (successMsg != null && !successMsg.isEmpty()) { %>
        <div class="pf-alert pf-alert--success">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <polyline points="20 6 9 17 4 12"/>
            </svg>
            <%= successMsg %>
        </div>
        <% } %>

        <div class="pf-card">
            <div class="pf-card__head">
                <span class="pf-card__icon">👤</span>
                <div>
                    <div class="pf-card__title">Account Details</div>
                    <div class="pf-card__subtitle">Your personal information</div>
                </div>
            </div>

            <div class="pf-info">
                <div class="pf-info__row">
                    <span class="pf-info__label">User ID</span>
                    <span class="pf-info__value"><%= userId %></span>
                </div>
                <div class="pf-info__row">
                    <span class="pf-info__label">Full Name</span>
                    <span class="pf-info__value"><%= fullName %></span>
                </div>
                <div class="pf-info__row">
                    <span class="pf-info__label">Email</span>
                    <span class="pf-info__value"><%= email != null ? email : "<span class='pf-info__empty'>Not set</span>" %></span>
                </div>
                <div class="pf-info__row">
                    <span class="pf-info__label">Phone</span>
                    <span class="pf-info__value"><%= phone != null ? phone : "<span class='pf-info__empty'>Not set</span>" %></span>
                </div>
                <div class="pf-info__row">
                    <span class="pf-info__label">Address</span>
                    <span class="pf-info__value"><%= (address != null && !address.isEmpty()) ? address : "<span class='pf-info__empty'>Not set</span>" %></span>
                </div>
            </div>

            <div class="pf-actions" style="margin-top: 28px;">
                <a href="${pageContext.request.contextPath}/EditProfileServlet" class="pf-btn pf-btn--primary">
                    <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/>
                        <path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/>
                    </svg>
                    Edit Profile
                </a>
                <a href="${pageContext.request.contextPath}/pages/change-password.jsp" class="pf-btn pf-btn--ghost">
                    🔒 Change Password
                </a>
            </div>
        </div>
    </main>

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
