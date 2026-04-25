<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=login_required");
        return;
    }

    String userId   = (String) session.getAttribute("userID");
    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null) fullName = userId;
    String initials = String.valueOf(fullName.charAt(0)).toUpperCase();

    String errorMsg   = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Change Password</title>
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
    <h1 class="pf-header__title">Change Password</h1>
    <p class="pf-header__sub">Keep your account safe and secure</p>
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
            <a href="${pageContext.request.contextPath}/ProfileServlet" class="pf-nav__link">
                <span class="pf-nav__icon">👤</span> My Profile
            </a>
            <a href="${pageContext.request.contextPath}/EditProfileServlet" class="pf-nav__link">
                <span class="pf-nav__icon">✏️</span> Edit Profile
            </a>
            <a href="${pageContext.request.contextPath}/pages/change-password.jsp" class="pf-nav__link pf-nav__link--active">
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
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
        <div class="pf-alert pf-alert--error">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
            </svg>
            <%= errorMsg %>
        </div>
        <% } %>

        <div class="pf-card">
            <div class="pf-card__head">
                <span class="pf-card__icon">🔒</span>
                <div>
                    <div class="pf-card__title">Change Password</div>
                    <div class="pf-card__subtitle">Choose a strong, unique password</div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/ChangePasswordServlet" method="post" class="pf-form" id="pwForm">

                <div class="pf-field">
                    <label class="pf-label" for="currentPassword">Current Password <span class="pf-req">*</span></label>
                    <input type="password" id="currentPassword" name="currentPassword"
                           class="pf-input" placeholder="Enter your current password" required />
                </div>

                <div class="pf-field">
                    <label class="pf-label" for="newPassword">New Password <span class="pf-req">*</span></label>
                    <input type="password" id="newPassword" name="newPassword"
                           class="pf-input" placeholder="At least 6 characters"
                           oninput="checkStrength(this.value)" required />
                    <div class="pf-strength">
                        <div class="pf-strength__bar">
                            <div class="pf-strength__fill" id="strengthFill"></div>
                        </div>
                        <span class="pf-strength__label" id="strengthLabel">Enter a new password</span>
                    </div>
                </div>

                <div class="pf-field">
                    <label class="pf-label" for="confirmPassword">Confirm New Password <span class="pf-req">*</span></label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           class="pf-input" placeholder="Repeat your new password"
                           oninput="checkMatch()" required />
                    <span class="pf-input-hint" id="matchHint"></span>
                </div>

                <div class="pf-actions">
                    <button type="submit" class="pf-btn pf-btn--primary" id="submitBtn">
                        🔒 Update Password
                    </button>
                    <a href="${pageContext.request.contextPath}/ProfileServlet" class="pf-btn pf-btn--ghost">
                        Cancel
                    </a>
                </div>

            </form>
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

function checkStrength(val) {
    var fill  = document.getElementById('strengthFill');
    var label = document.getElementById('strengthLabel');
    if (!fill || !label) return;
    var score = 0;
    if (val.length >= 6)  score++;
    if (val.length >= 10) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    var levels = [
        { w: '0%',   bg: 'transparent', text: 'Enter a new password' },
        { w: '25%',  bg: '#e74c3c',     text: 'Weak' },
        { w: '50%',  bg: '#e67e22',     text: 'Fair' },
        { w: '75%',  bg: '#f1c40f',     text: 'Good' },
        { w: '100%', bg: '#27ae60',     text: 'Strong' }
    ];
    var lvl = val.length === 0 ? levels[0] : levels[Math.min(score, 4)];
    fill.style.width      = lvl.w;
    fill.style.background = lvl.bg;
    label.textContent     = lvl.text;
    label.style.color     = lvl.bg === 'transparent' ? '' : lvl.bg;
}

function checkMatch() {
    var np   = document.getElementById('newPassword').value;
    var cp   = document.getElementById('confirmPassword').value;
    var hint = document.getElementById('matchHint');
    var btn  = document.getElementById('submitBtn');
    if (!hint) return;
    if (cp.length === 0) { hint.textContent = ''; return; }
    if (np === cp) {
        hint.textContent = '✓ Passwords match';
        hint.style.color = '#27ae60';
        if (btn) btn.disabled = false;
    } else {
        hint.textContent = '✗ Passwords do not match';
        hint.style.color = '#e74c3c';
        if (btn) btn.disabled = true;
    }
}
</script>
</body>
</html>
