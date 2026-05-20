<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String adminName = (String) session.getAttribute("fullName");
    String adminId   = (String) session.getAttribute("userID");
    if (adminName == null) adminName = (adminId != null ? adminId : "Admin");
    String currentUri = request.getRequestURI();
    boolean onOrders  = currentUri.contains("AdminOrders")  || currentUri.contains("admin-orders");
    boolean onProducts= currentUri.contains("AdminProducts") || currentUri.contains("admin-products");
%>
<nav class="adm-nav">
    <a class="adm-nav__brand" href="${pageContext.request.contextPath}/AdminOrdersServlet">
        ✦ Aura<span class="adm-nav__brand-accent">Luxe</span>
        <span class="adm-nav__badge">Admin</span>
    </a>

    <ul class="adm-nav__links">
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"
               class="adm-nav__link <%= onOrders ? "adm-nav__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet"
               class="adm-nav__link <%= onProducts ? "adm-nav__link--active" : "" %>">💄 Products</a></li>
    </ul>

    <div class="adm-nav__right">
        <span class="adm-nav__user">👤 <%= adminName %></span>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-nav__logout">Sign Out</a>
    </div>

    <button class="adm-nav__hamburger" id="admHamburger" aria-label="Toggle menu" aria-expanded="false">
        <span></span><span></span><span></span>
    </button>
</nav>

<div class="adm-nav__drawer" id="admDrawer">
    <ul class="adm-drawer__list">
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"
               class="adm-drawer__link <%= onOrders ? "adm-drawer__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet"
               class="adm-drawer__link <%= onProducts ? "adm-drawer__link--active" : "" %>">💄 Products</a></li>
    </ul>
    <hr class="adm-drawer__divider">
    <div class="adm-drawer__user">👤 <%= adminName %></div>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-drawer__logout">Sign Out</a>
</div>

<script>
(function(){
    var btn=document.getElementById('admHamburger'),
        drw=document.getElementById('admDrawer');
    if(!btn||!drw)return;
    function open(v){drw.classList.toggle('is-open',v);btn.classList.toggle('is-open',v);btn.setAttribute('aria-expanded',v);}
    btn.addEventListener('click',function(e){e.stopPropagation();open(!drw.classList.contains('is-open'));});
    drw.querySelectorAll('a').forEach(function(a){a.addEventListener('click',function(){open(false);});});
    document.addEventListener('click',function(e){if(!drw.contains(e.target)&&e.target!==btn)open(false);});
})();
</script>
