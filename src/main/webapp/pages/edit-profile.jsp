<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String checkUser = (String) session.getAttribute("userID");
    if (checkUser == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=login_required");
        return;
    }

    String userId   = (String) session.getAttribute("userID");
    String fullName = (String) request.getAttribute("fullName");
    String email    = (String) request.getAttribute("email");
    String phone    = (String) request.getAttribute("phone");
    String address  = (String) request.getAttribute("address");

    if (fullName == null) fullName = (String) session.getAttribute("fullName");
    if (fullName == null) fullName = userId;

    String initials  = String.valueOf(fullName.charAt(0)).toUpperCase();
    String errorMsg  = (String) request.getAttribute("errorMsg");
    String successMsg= (String) request.getAttribute("successMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Edit Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css" />
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<%-- ── HEADER ────────────────────────────────────────────────── --%>
<div class="pf-header">
    <span class="pf-header__eyebrow">AuraLuxe</span>
    <h1 class="pf-header__title">Edit Profile</h1>
    <p class="pf-header__sub">Update your personal information</p>
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
            <a href="${pageContext.request.contextPath}/EditProfileServlet" class="pf-nav__link pf-nav__link--active">
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
                <span class="pf-card__icon">✏️</span>
                <div>
                    <div class="pf-card__title">Edit Profile</div>
                    <div class="pf-card__subtitle">Changes are saved immediately</div>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/EditProfileServlet" method="post" class="pf-form">

                <div class="pf-form-row">
                    <div class="pf-field">
                        <label class="pf-label" for="fullName">Full Name <span class="pf-req">*</span></label>
                        <input type="text" id="fullName" name="fullName"
                               class="pf-input" placeholder="e.g. Pranisha K.C."
                               value="<%= fullName != null ? fullName : "" %>" required />
                    </div>
                    <div class="pf-field">
                        <label class="pf-label" for="userId">User ID</label>
                        <input type="text" id="userId" class="pf-input"
                               value="<%= userId %>" disabled />
                        <span class="pf-input-hint">User ID cannot be changed</span>
                    </div>
                </div>

                <div class="pf-form-row">
                    <div class="pf-field">
                        <label class="pf-label" for="email">Email</label>
                        <input type="email" id="email" class="pf-input"
                               value="<%= email != null ? email : "" %>" disabled />
                        <span class="pf-input-hint">Email cannot be changed</span>
                    </div>
                    <div class="pf-field">
                        <label class="pf-label" for="phone">Phone</label>
                        <input type="text" id="phone" class="pf-input"
                               value="<%= phone != null ? phone : "" %>" disabled />
                        <span class="pf-input-hint">Phone cannot be changed</span>
                    </div>
                </div>

                <div class="pf-field pf-field--full">
                    <label class="pf-label" for="address">Delivery Address</label>
                    <input type="text" id="address" name="address"
                           class="pf-input" placeholder="Street / Area / Landmark / City"
                           value="<%= address != null ? address : "" %>" />
                </div>

                <div class="pf-actions">
                    <button type="submit" class="pf-btn pf-btn--primary">
                        <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <polyline points="20 6 9 17 4 12"/>
                        </svg>
                        Save Changes
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

</body>
</html>
