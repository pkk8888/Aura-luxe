<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String navUserId   = (String) session.getAttribute("userID");
    String navFullName = (String) session.getAttribute("fullName");
    String navDisplay  = (navFullName != null && !navFullName.isEmpty()) ? navFullName : navUserId;
%>
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
            <li><a href="${pageContext.request.contextPath}/pages/about-us.jsp" class="al-navbar__link">About</a></li>
            <li><a href="${pageContext.request.contextPath}/pages/contact-us.jsp" class="al-navbar__link">Contact</a></li>
        </ul>

        <div class="al-navbar__actions">
            <% if (navUserId != null) { %>
                <span class="al-navbar__welcome">Hello, <%= navDisplay %></span>
                <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__icon-btn" title="My Bag">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4z"/>
                        <line x1="3" y1="6" x2="21" y2="6"/>
                        <path d="M16 10a4 4 0 01-8 0"/>
                    </svg>
                </a>
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="al-navbar__icon-btn" title="My Profile">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                        <circle cx="12" cy="7" r="4"/>
                    </svg>
                </a>
                <a href="${pageContext.request.contextPath}/MyOrdersServlet" class="al-navbar__icon-btn" title="My Orders">
                    <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2"/>
                        <rect x="9" y="3" width="6" height="4" rx="1"/>
                        <path d="M9 12h6M9 16h4"/>
                    </svg>
                </a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__btn al-navbar__btn--outline">Sign Out</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="al-navbar__btn al-navbar__btn--outline">Sign In</a>
                <a href="${pageContext.request.contextPath}/pages/register.jsp" class="al-navbar__btn al-navbar__btn--solid">Join Now</a>
            <% } %>
        </div>

        <button class="al-navbar__hamburger" id="alNavToggle" aria-label="Toggle menu" aria-expanded="false">
            <span></span><span></span><span></span>
        </button>

    </div>

    <div class="al-navbar__mobile" id="alNavMobile" aria-hidden="true">
        <div class="al-navbar__mobile-section">
            <a href="${pageContext.request.contextPath}/pages/home.jsp" class="al-navbar__mobile-link">Home</a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-navbar__mobile-link">Shop</a>
            <a href="${pageContext.request.contextPath}/pages/about-us.jsp" class="al-navbar__mobile-link">About</a>
            <a href="${pageContext.request.contextPath}/pages/contact-us.jsp" class="al-navbar__mobile-link">Contact</a>
        </div>
        <% if (navUserId != null) { %>
            <div class="al-navbar__mobile-divider"></div>
            <div class="al-navbar__mobile-section">
                <a href="${pageContext.request.contextPath}/ProfileServlet" class="al-navbar__mobile-link">
                    <span class="al-navbar__mobile-icon">👤</span> My Profile
                </a>
                <a href="${pageContext.request.contextPath}/MyOrdersServlet" class="al-navbar__mobile-link">
                    <span class="al-navbar__mobile-icon">📦</span> My Orders
                </a>
                <a href="${pageContext.request.contextPath}/EditProfileServlet" class="al-navbar__mobile-link">
                    <span class="al-navbar__mobile-icon">✏️</span> Edit Profile
                </a>
                <a href="${pageContext.request.contextPath}/pages/change-password.jsp" class="al-navbar__mobile-link">
                    <span class="al-navbar__mobile-icon">🔒</span> Change Password
                </a>
                <a href="${pageContext.request.contextPath}/CartServlet" class="al-navbar__mobile-link">
                    <span class="al-navbar__mobile-icon">🛍️</span> My Cart
                </a>
            </div>
            <div class="al-navbar__mobile-divider"></div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="al-navbar__mobile-link al-navbar__mobile-link--signout">
                <span class="al-navbar__mobile-icon">🚪</span> Sign Out
            </a>
        <% } else { %>
            <div class="al-navbar__mobile-divider"></div>
            <div class="al-navbar__mobile-section al-navbar__mobile-auth">
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="al-navbar__mobile-btn al-navbar__mobile-btn--outline">Sign In</a>
                <a href="${pageContext.request.contextPath}/pages/register.jsp" class="al-navbar__mobile-btn al-navbar__mobile-btn--solid">Join Now</a>
            </div>
        <% } %>
    </div>
</nav>

<script>
(function(){
    var btn    = document.getElementById('alNavToggle');
    var drawer = document.getElementById('alNavMobile');
    if (btn && drawer) {
        btn.addEventListener('click', function(){
            var isOpen = drawer.classList.toggle('al-navbar__mobile--open');
            btn.classList.toggle('al-navbar__hamburger--open');
            btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
            drawer.setAttribute('aria-hidden', isOpen ? 'false' : 'true');
        });
        /* close on outside click */
        document.addEventListener('click', function(e){
            if (!btn.contains(e.target) && !drawer.contains(e.target)) {
                drawer.classList.remove('al-navbar__mobile--open');
                btn.classList.remove('al-navbar__hamburger--open');
                btn.setAttribute('aria-expanded', 'false');
                drawer.setAttribute('aria-hidden', 'true');
            }
        });
    }
    window.addEventListener('scroll', function(){
        var nav = document.querySelector('.al-navbar');
        if (nav) nav.classList.toggle('al-navbar--scrolled', window.scrollY > 60);
    });
})();
</script>
