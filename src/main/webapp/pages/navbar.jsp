<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ============================================================
     AuraLuxe - Reusable Navbar Component
     Usage: <jsp:include page="/components/navbar.jsp" />
     ============================================================ --%>
<%
    String navUserId   = (String) session.getAttribute("userID");
    String navFullName = (String) session.getAttribute("fullName");
    String navDisplay  = (navFullName != null && !navFullName.isEmpty()) ? navFullName : navUserId;
%>
<nav class="al-navbar">
    <div class="al-navbar__inner">

        <!-- Logo -->
        <a class="al-navbar__brand" href="${pageContext.request.contextPath}/pages/home.jsp">
            <span class="al-navbar__brand-star">✦</span>
            Aura<span class="al-navbar__brand-luxe">Luxe</span>
            <span class="al-navbar__brand-star">✦</span>
        </a>

        <!-- Desktop links -->
        <ul class="al-navbar__links">
            <li><a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__link">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__link">Shop</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/home.jsp#collections" class="al-navbar__link">Collections</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/about-us.jsp" class="al-navbar__link">About</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/contact-us.jsp" class="al-navbar__link">Contact</a></li>
        </ul>

        <!-- Right actions -->
        <div class="al-navbar__actions">
            <% if (navUserId != null) { %>
                <span class="al-navbar__welcome">Hello, <%= navDisplay %></span>

                <!-- Cart icon -->
                <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__icon-btn" title="My Bag">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 01-8 0"/>
                    </svg>
                </a>

                <!-- My Profile icon -->
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="al-navbar__icon-btn" title="My Profile">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </a>

                <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="al-navbar__btn al-navbar__btn--outline">Sign In</a>
                <a href="${pageContext.request.contextPath}/pages/register.jsp" class="al-navbar__btn al-navbar__btn--solid">Join Now</a>
            <% } %>
        </div>

        <!-- Hamburger (mobile) -->
        <button class="al-navbar__hamburger" id="alNavToggle" aria-label="Toggle menu">
            <span></span><span></span><span></span>
        </button>

    </div>

    <!-- Mobile drawer -->
    <div class="al-navbar__mobile" id="alNavMobile">
        <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
        <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
        <a href="${pageContext.request.contextPath}/pages/home.jsp#collections" class="al-navbar__mobile-link">Collections</a>
        <a href="${pageContext.request.contextPath}/pages/about-us.jsp" class="al-navbar__mobile-link">About</a>
        <a href="${pageContext.request.contextPath}/pages/contact-us.jsp" class="al-navbar__mobile-link">Contact</a>
        <% if (navUserId != null) { %>
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="al-navbar__mobile-link">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/EditProfileServlet" class="al-navbar__mobile-link">✏️ Edit Profile</a>
            <a href="${pageContext.request.contextPath}/pages/change-password.jsp" class="al-navbar__mobile-link">🔒 Change Password</a>
            <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__mobile-link">🛍️ My Cart</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="al-navbar__mobile-link">Sign In</a>
            <a href="${pageContext.request.contextPath}/pages/register.jsp" class="al-navbar__mobile-link">Join Now</a>
        <% } %>
    </div>
</nav>

<script>
(function(){
    const btn    = document.getElementById('alNavToggle');
    const drawer = document.getElementById('alNavMobile');
    if (btn && drawer) {
        btn.addEventListener('click', function(){
            drawer.classList.toggle('al-navbar__mobile--open');
            btn.classList.toggle('al-navbar__hamburger--open');
        });
    }
    window.addEventListener('scroll', function(){
        const nav = document.querySelector('.al-navbar');
        if (nav) nav.classList.toggle('al-navbar--scrolled', window.scrollY > 60);
    });
})();
</script>
