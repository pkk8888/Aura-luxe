<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("fullName");
    String adminId   = (String) session.getAttribute("userID");
    if (adminName == null) adminName = (adminId != null ? adminId : "Admin");
    String currentUri = request.getRequestURI();
%>
<style>
    .adm-nav {
        background: linear-gradient(135deg, #1a0a10 0%, #3d1020 100%);
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 32px;
        height: 62px;
        position: sticky;
        top: 0;
        z-index: 100;
        box-shadow: 0 2px 12px rgba(0,0,0,.35);
    }
    .adm-nav__brand {
        font-size: 1.2rem;
        font-weight: 800;
        color: #fff;
        text-decoration: none;
        letter-spacing: .5px;
    }
    .adm-nav__brand span { color: #e8a0b0; }
    .adm-nav__badge {
        background: #c0394b;
        color: #fff;
        font-size: 9px;
        font-weight: 700;
        padding: 2px 7px;
        border-radius: 50px;
        margin-left: 8px;
        letter-spacing: 1px;
        vertical-align: middle;
        text-transform: uppercase;
    }
    .adm-nav__links { display: flex; gap: 4px; list-style: none; margin: 0; padding: 0; }
    .adm-nav__link {
        color: rgba(255,255,255,.7);
        text-decoration: none;
        padding: 8px 16px;
        border-radius: 8px;
        font-size: .88rem;
        font-weight: 500;
        transition: background .2s, color .2s;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .adm-nav__link:hover,
    .adm-nav__link--active { background: rgba(255,255,255,.12); color: #fff; }
    .adm-nav__right { display: flex; align-items: center; gap: 14px; }
    .adm-nav__user { font-size: .83rem; opacity: .75; }
    .adm-nav__logout {
        background: rgba(255,255,255,.12);
        color: #fff;
        border: 1px solid rgba(255,255,255,.2);
        border-radius: 8px;
        padding: 6px 14px;
        font-size: .82rem;
        text-decoration: none;
        transition: background .2s;
    }
    .adm-nav__logout:hover { background: rgba(255,255,255,.22); }
</style>

<nav class="adm-nav">
    <a class="adm-nav__brand" href="${pageContext.request.contextPath}/AdminOrdersServlet">
        ✦ Aura<span>Luxe</span>
        <span class="adm-nav__badge">Admin</span>
    </a>

    <ul class="adm-nav__links">
        <li>
            <a href="${pageContext.request.contextPath}/AdminOrdersServlet"
               class="adm-nav__link <%= currentUri.contains("AdminOrders") || currentUri.contains("admin-orders") ? "adm-nav__link--active" : "" %>">
                📋 Orders
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/AdminProductsServlet"
               class="adm-nav__link <%= currentUri.contains("AdminProducts") || currentUri.contains("admin-products") ? "adm-nav__link--active" : "" %>">
                💄 Products
            </a>
        </li>
    </ul>

    <div class="adm-nav__right">
        <span class="adm-nav__user">👤 <%= adminName %></span>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-nav__logout">Sign Out</a>
    </div>
</nav>
