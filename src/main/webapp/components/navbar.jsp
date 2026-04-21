<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ============================================================
     AuraLuxe - Reusable Navbar Component
     Usage: <%@ include file="/components/navbar.jsp" %>
     ============================================================ --%>

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
            <li><a href="${pageContext.request.contextPath}/pages/home.jsp#about" class="al-navbar__link">About</a></li>
        </ul>

        <!-- Right actions -->
        <div class="al-navbar__actions">
            <%
                String navUser = (String) session.getAttribute("userID");
                if (navUser != null) {
            %>
                <span class="al-navbar__welcome">Hello, <%= navUser %></span>
                <a href="${pageContext.request.contextPath}/pages/cart.jsp" class="al-navbar__icon-btn" title="Cart">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/><line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 01-8 0"/>
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
        <a href="${pageContext.request.contextPath}/pages/home.jsp#about" class="al-navbar__mobile-link">About</a>
        <%
            String navUser2 = (String) session.getAttribute("userID");
            if (navUser2 != null) {
        %>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link">Sign Out</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="al-navbar__mobile-link">Sign In</a>
            <a href="${pageContext.request.contextPath}/pages/register.jsp" class="al-navbar__mobile-link">Join Now</a>
        <% } %>
    </div>
</nav>

<script>
(function(){
    const btn = document.getElementById('alNavToggle');
    const drawer = document.getElementById('alNavMobile');
    if(btn && drawer){
        btn.addEventListener('click', function(){
            drawer.classList.toggle('al-navbar__mobile--open');
            btn.classList.toggle('al-navbar__hamburger--open');
        });
    }
    // Shrink navbar on scroll
    window.addEventListener('scroll', function(){
        const nav = document.querySelector('.al-navbar');
        if(nav) nav.classList.toggle('al-navbar--scrolled', window.scrollY > 60);
    });
})();
</script>
