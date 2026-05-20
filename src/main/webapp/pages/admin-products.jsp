<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ProductModel" %>
<%
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (!Boolean.TRUE.equals(isAdmin)) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    ArrayList<ProductModel> products = (ArrayList<ProductModel>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
    ProductModel editProduct = (ProductModel) request.getAttribute("editProduct");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <title>AuraLuxe Admin | Products</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f0f2; color: #1a0a10; min-height: 100vh; -webkit-text-size-adjust: 100%; }

        /* ════ Admin Navbar ════ */
        .adm-nav { background: linear-gradient(135deg, #1a0a10 0%, #3d1020 100%); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; height: 62px; position: sticky; top: 0; z-index: 200; box-shadow: 0 2px 12px rgba(0,0,0,.35); }
        .adm-nav__brand { font-size: 1.2rem; font-weight: 800; color: #fff; text-decoration: none; letter-spacing: .5px; flex-shrink: 0; display: flex; align-items: center; }
        .adm-nav__brand-accent { color: #e8a0b0; }
        .adm-nav__badge { background: #c0394b; color: #fff; font-size: 9px; font-weight: 700; padding: 2px 7px; border-radius: 50px; margin-left: 8px; letter-spacing: 1px; text-transform: uppercase; }
        .adm-nav__links { display: flex; gap: 4px; list-style: none; margin: 0; padding: 0; }
        .adm-nav__link { color: rgba(255,255,255,.7); text-decoration: none; padding: 8px 16px; border-radius: 8px; font-size: .88rem; font-weight: 500; display: flex; align-items: center; gap: 6px; white-space: nowrap; transition: background .2s, color .2s; }
        .adm-nav__link:hover, .adm-nav__link--active { background: rgba(255,255,255,.12); color: #fff; }
        .adm-nav__right { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
        .adm-nav__user { font-size: .83rem; opacity: .75; white-space: nowrap; max-width: 120px; overflow: hidden; text-overflow: ellipsis; }
        .adm-nav__logout { background: rgba(255,255,255,.12); color: #fff; border: 1px solid rgba(255,255,255,.2); border-radius: 8px; padding: 6px 14px; font-size: .82rem; text-decoration: none; white-space: nowrap; transition: background .2s; }
        .adm-nav__logout:hover { background: rgba(255,255,255,.22); }
        .adm-nav__hamburger { display: none; flex-direction: column; justify-content: center; align-items: center; gap: 5px; background: rgba(255,255,255,.1); border: 1px solid rgba(255,255,255,.2); border-radius: 8px; cursor: pointer; width: 42px; height: 38px; padding: 0; }
        .adm-nav__hamburger span { display: block; width: 20px; height: 2px; background: #fff; border-radius: 2px; transition: transform .25s, opacity .25s; }
        .adm-nav__hamburger.is-open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .adm-nav__hamburger.is-open span:nth-child(2) { opacity: 0; }
        .adm-nav__hamburger.is-open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
        .adm-nav__drawer { display: none; position: fixed; top: 62px; left: 0; right: 0; background: #2a0d17; border-top: 1px solid rgba(255,255,255,.08); box-shadow: 0 8px 24px rgba(0,0,0,.5); z-index: 199; padding: 8px 16px 20px; }
        .adm-nav__drawer.is-open { display: block; animation: admSlide .2s ease; }
        @keyframes admSlide { from{opacity:0;transform:translateY(-6px)} to{opacity:1;transform:translateY(0)} }
        .adm-drawer__list { list-style: none; margin: 0; padding: 0; }
        .adm-drawer__list li { border-bottom: 1px solid rgba(255,255,255,.07); }
        .adm-drawer__list li:last-child { border-bottom: none; }
        .adm-drawer__link { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,.85); text-decoration: none; padding: 14px 8px; font-size: .95rem; font-weight: 500; border-radius: 6px; transition: background .15s; }
        .adm-drawer__link:hover, .adm-drawer__link--active { background: rgba(255,255,255,.1); color: #fff; }
        .adm-drawer__divider { border: none; border-top: 1px solid rgba(255,255,255,.1); margin: 8px 0; }
        .adm-drawer__user { color: rgba(255,255,255,.55); font-size: .82rem; padding: 10px 8px 4px; }
        .adm-drawer__logout { display: block; text-align: center; margin-top: 8px; background: rgba(192,57,75,.3); border: 1px solid rgba(192,57,75,.55); color: #fff; padding: 11px; border-radius: 8px; font-size: .9rem; font-weight: 600; text-decoration: none; }
        .adm-drawer__logout:hover { background: rgba(192,57,75,.5); }
        @media (max-width: 640px) {
            .adm-nav { padding: 0 16px; }
            .adm-nav__links  { display: none !important; }
            .adm-nav__right  { display: none !important; }
            .adm-nav__hamburger { display: flex !important; }
        }

        /* ════ Page ════ */
        .adm-page { max-width: 1200px; margin: 36px auto; padding: 0 24px 60px; }
        .adm-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 28px; flex-wrap: wrap; gap: 12px; }
        .adm-head__title { font-size: 1.6rem; font-weight: 800; }
        .adm-head__count { background: #c0394b; color: #fff; border-radius: 50px; padding: 3px 12px; font-size: .8rem; font-weight: 700; margin-left: 10px; }
        .btn-add { background: linear-gradient(135deg,#7b1d36,#c0394b); color: #fff; border: none; border-radius: 10px; padding: 10px 22px; font-size: .9rem; font-weight: 600; cursor: pointer; text-decoration: none; transition: opacity .2s; display: inline-block; }
        .btn-add:hover { opacity: .85; }
        .adm-toast { border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: .9rem; font-weight: 600; }
        .adm-toast--success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .adm-toast--delete  { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* Form */
        .adm-form-card { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(26,10,16,.08); padding: 28px 32px; margin-bottom: 32px; }
        .adm-form-card__title { font-size: 1.1rem; font-weight: 800; margin-bottom: 22px; padding-bottom: 12px; border-bottom: 1.5px solid #f0e8eb; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group--full { grid-column: 1 / -1; }
        label { font-size: .82rem; font-weight: 600; color: #5c1a2e; }
        input[type=text], input[type=number], input[type=file], textarea, select { border: 1.5px solid #e0cdd2; border-radius: 8px; padding: 9px 13px; font-size: .88rem; color: #1a0a10; background: #fff; width: 100%; transition: border-color .2s; font-family: inherit; }
        input:focus, textarea:focus, select:focus { outline: none; border-color: #c0394b; }
        textarea { resize: vertical; min-height: 80px; }
        .form-actions { display: flex; gap: 12px; margin-top: 20px; flex-wrap: wrap; }
        .btn-submit { background: linear-gradient(135deg,#7b1d36,#c0394b); color: #fff; border: none; border-radius: 10px; padding: 10px 28px; font-size: .9rem; font-weight: 600; cursor: pointer; transition: opacity .2s; }
        .btn-submit:hover { opacity: .85; }
        .btn-cancel { background: #f0e8eb; color: #5c1a2e; border: none; border-radius: 10px; padding: 10px 22px; font-size: .9rem; font-weight: 600; cursor: pointer; text-decoration: none; transition: background .2s; display: inline-block; }
        .btn-cancel:hover { background: #e0cdd2; }

        /* Desktop table */
        .adm-table-wrap { background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(26,10,16,.08); overflow-x: auto; -webkit-overflow-scrolling: touch; }
        table { width: 100%; border-collapse: collapse; min-width: 560px; }
        thead { background: linear-gradient(135deg, #2a0d17, #5c1a2e); color: #fff; }
        thead th { padding: 14px 16px; font-size: .82rem; font-weight: 600; text-align: left; letter-spacing: .4px; text-transform: uppercase; white-space: nowrap; }
        tbody tr { border-bottom: 1px solid #f0e8eb; transition: background .15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fdf6f8; }
        tbody td { padding: 12px 16px; font-size: .87rem; vertical-align: middle; }
        .prod-img { width: 52px; height: 52px; border-radius: 10px; object-fit: cover; border: 1px solid #f0dce3; }
        .prod-name { font-weight: 700; margin-bottom: 2px; }
        .prod-brand { font-size: .78rem; color: #8a5060; }
        .prod-price { font-weight: 700; color: #2a0d17; white-space: nowrap; }
        .btn-edit { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; border-radius: 7px; padding: 5px 13px; font-size: .78rem; font-weight: 600; cursor: pointer; text-decoration: none; transition: background .2s; display: inline-block; }
        .btn-edit:hover { background: #ffeeba; }
        .btn-delete { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 7px; padding: 5px 13px; font-size: .78rem; font-weight: 600; cursor: pointer; text-decoration: none; transition: background .2s; display: inline-block; margin-left: 6px; }
        .btn-delete:hover { background: #f5c6cb; }

        /* Mobile product cards */
        .adm-prod-cards { display: none; flex-direction: column; gap: 12px; }
        .adm-prod-card { background: #fff; border-radius: 14px; box-shadow: 0 2px 12px rgba(26,10,16,.08); padding: 14px; display: flex; gap: 14px; align-items: flex-start; }
        .adm-prod-card__img { width: 64px; height: 64px; border-radius: 10px; object-fit: cover; border: 1px solid #f0dce3; flex-shrink: 0; }
        .adm-prod-card__body { flex: 1; min-width: 0; }
        .adm-prod-card__name { font-weight: 700; font-size: .93rem; margin-bottom: 2px; }
        .adm-prod-card__meta { font-size: .78rem; color: #8a5060; margin-bottom: 6px; }
        .adm-prod-card__row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .adm-prod-card__price { font-weight: 700; color: #2a0d17; font-size: .95rem; }
        .adm-prod-card__cat { background: #f0e8eb; color: #5c1a2e; font-size: .72rem; font-weight: 700; padding: 3px 10px; border-radius: 50px; text-transform: uppercase; letter-spacing: .3px; }
        .adm-prod-card__actions { display: flex; gap: 8px; }
        .adm-prod-card__actions .btn-edit, .adm-prod-card__actions .btn-delete { margin: 0; flex: 1; text-align: center; padding: 8px 6px; font-size: .82rem; }

        .adm-empty { text-align: center; padding: 60px 20px; color: #8a5060; }
        .adm-empty__icon { font-size: 3rem; margin-bottom: 12px; }

        @media (max-width: 640px) {
            .adm-page { margin: 16px auto; padding: 0 12px 40px; }
            .adm-head__title { font-size: 1.25rem; }
            .adm-head { margin-bottom: 16px; }
            .adm-form-card { padding: 16px 14px; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group--full { grid-column: 1; }
            .btn-submit, .btn-cancel { flex: 1; text-align: center; padding: 12px 10px; }
            .adm-table-wrap { display: none; }
            .adm-prod-cards { display: flex; }
        }
        @media (max-width: 900px) and (min-width: 641px) {
            .adm-page { margin: 20px auto; padding: 0 16px 40px; }
            .adm-head__title { font-size: 1.3rem; }
            .adm-form-card { padding: 20px 18px; }
        }
    </style>
</head>
<body>

<%
    String adminName = (String) session.getAttribute("fullName");
    String adminId   = (String) session.getAttribute("userID");
    if (adminName == null) adminName = (adminId != null ? adminId : "Admin");
    String currentUri = request.getRequestURI();
    boolean onOrders   = currentUri.contains("AdminOrders")  || currentUri.contains("admin-orders");
    boolean onProducts = currentUri.contains("AdminProducts") || currentUri.contains("admin-products");
%>
<nav class="adm-nav">
    <a class="adm-nav__brand" href="${pageContext.request.contextPath}/AdminOrdersServlet">
        ✦ Aura<span class="adm-nav__brand-accent">Luxe</span>
        <span class="adm-nav__badge">Admin</span>
    </a>
    <ul class="adm-nav__links">
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"   class="adm-nav__link <%= onOrders   ? "adm-nav__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet" class="adm-nav__link <%= onProducts ? "adm-nav__link--active" : "" %>">💄 Products</a></li>
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
        <li><a href="${pageContext.request.contextPath}/AdminOrdersServlet"   class="adm-drawer__link <%= onOrders   ? "adm-drawer__link--active" : "" %>">📋 Orders</a></li>
        <li><a href="${pageContext.request.contextPath}/AdminProductsServlet" class="adm-drawer__link <%= onProducts ? "adm-drawer__link--active" : "" %>">💄 Products</a></li>
    </ul>
    <hr class="adm-drawer__divider">
    <div class="adm-drawer__user">👤 <%= adminName %></div>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="adm-drawer__logout">Sign Out</a>
</div>
<script>
(function(){var b=document.getElementById('admHamburger'),d=document.getElementById('admDrawer');if(!b||!d)return;function s(v){d.classList.toggle('is-open',v);b.classList.toggle('is-open',v);b.setAttribute('aria-expanded',v);}b.addEventListener('click',function(e){e.stopPropagation();s(!d.classList.contains('is-open'));});d.querySelectorAll('a').forEach(function(a){a.addEventListener('click',function(){s(false);});});document.addEventListener('click',function(e){if(!d.contains(e.target)&&e.target!==b)s(false);});})();
</script>

<div class="adm-page">
    <div class="adm-head">
        <div>
            <span class="adm-head__title">Products</span>
            <span class="adm-head__count"><%= products.size() %></span>
        </div>
        <% if (editProduct == null) { %><a href="#adm-form" class="btn-add">+ Add Product</a><% } %>
    </div>

    <% if ("added".equals(msg)) { %>   <div class="adm-toast adm-toast--success">✅ Product added successfully.</div>
    <% } else if ("updated".equals(msg)) { %> <div class="adm-toast adm-toast--success">✅ Product updated successfully.</div>
    <% } else if ("deleted".equals(msg)) { %> <div class="adm-toast adm-toast--delete">🗑️ Product deleted successfully.</div>
    <% } %>

    <div class="adm-form-card" id="adm-form">
        <div class="adm-form-card__title"><%= editProduct != null ? "✏️ Edit Product" : "➕ Add New Product" %></div>
        <form action="<%= request.getContextPath() %>/AdminProductsServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= editProduct != null ? "update" : "add" %>"/>
            <% if (editProduct != null) { %>
                <input type="hidden" name="productId" value="<%= editProduct.getProductId() %>"/>
                <input type="hidden" name="existingImage" value="<%= editProduct.getImage() %>"/>
            <% } %>
            <div class="form-grid">
                <div class="form-group"><label>Product Name *</label><input type="text" name="productName" required value="<%= editProduct!=null?editProduct.getProductName():"" %>"/></div>
                <div class="form-group"><label>Category *</label><select name="category" required><option value="">Select category</option><% String[] cats={"Lips","Eyes","Face","Skincare","Nails","Tools"};for(String cat:cats){boolean sel=editProduct!=null&&cat.equalsIgnoreCase(editProduct.getCategory()); %><option value="<%= cat %>" <%= sel?"selected":"" %>><%= cat %></option><% } %></select></div>
                <div class="form-group"><label>Brand *</label><input type="text" name="brand" required value="<%= editProduct!=null?editProduct.getBrand():"" %>"/></div>
                <div class="form-group"><label>Shade</label><input type="text" name="shade" value="<%= editProduct!=null&&editProduct.getShade()!=null?editProduct.getShade():"" %>"/></div>
                <div class="form-group"><label>Price (Rs) *</label><input type="number" name="price" step="0.01" min="0" required value="<%= editProduct!=null?editProduct.getPrice():"" %>"/></div>
                <div class="form-group"><label>Net Weight</label><input type="text" name="netWeight" value="<%= editProduct!=null&&editProduct.getNetWeight()!=null?editProduct.getNetWeight():"" %>"/></div>
                <div class="form-group"><label>Shelf Life</label><input type="text" name="shelfLife" value="<%= editProduct!=null&&editProduct.getShelfLife()!=null?editProduct.getShelfLife():"" %>"/></div>
                <div class="form-group"><label>Product Image <%= editProduct!=null?"(leave blank to keep current)":"*" %></label><input type="file" name="image" accept="image/*" <%= editProduct==null?"required":"" %>/></div>
                <div class="form-group form-group--full"><label>Features / Description</label><textarea name="features"><%= editProduct!=null&&editProduct.getFeatures()!=null?editProduct.getFeatures():"" %></textarea></div>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-submit"><%= editProduct!=null?"Save Changes":"Add Product" %></button>
                <% if (editProduct != null) { %><a href="${pageContext.request.contextPath}/AdminProductsServlet" class="btn-cancel">Cancel</a><% } %>
            </div>
        </form>
    </div>

    <%-- Desktop Table --%>
    <div class="adm-table-wrap">
    <% if (products.isEmpty()) { %>
        <div class="adm-empty"><div class="adm-empty__icon">💄</div><div>No products yet. Add your first product above.</div></div>
    <% } else { %>
        <table>
            <thead><tr><th>Image</th><th>Product</th><th>Category</th><th>Brand</th><th>Price</th><th>Actions</th></tr></thead>
            <tbody>
            <% for (ProductModel p : products) { %>
                <tr>
                    <td><img class="prod-img" src="${pageContext.request.contextPath}/images/<%= p.getImage() %>" alt="<%= p.getProductName() %>" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'"/></td>
                    <td><div class="prod-name"><%= p.getProductName() %></div><div class="prod-brand"><%= p.getShade()!=null?p.getShade():"" %></div></td>
                    <td><%= p.getCategory() %></td>
                    <td><%= p.getBrand() %></td>
                    <td><span class="prod-price">Rs <%= String.format("%,.0f",p.getPrice()) %></span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=edit&id=<%= p.getProductId() %>#adm-form" class="btn-edit">✏️ Edit</a>
                        <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=delete&id=<%= p.getProductId() %>" class="btn-delete" onclick="return confirm('Delete <%= p.getProductName().replace("'","") %>? This cannot be undone.')">🗑️ Delete</a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
    </div>

    <%-- Mobile Cards --%>
    <% if (!products.isEmpty()) { %>
    <div class="adm-prod-cards">
    <% for (ProductModel p : products) { %>
        <div class="adm-prod-card">
            <img class="adm-prod-card__img" src="${pageContext.request.contextPath}/images/<%= p.getImage() %>" alt="<%= p.getProductName() %>" onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'"/>
            <div class="adm-prod-card__body">
                <div class="adm-prod-card__name"><%= p.getProductName() %></div>
                <div class="adm-prod-card__meta"><%= p.getBrand() %><%= p.getShade()!=null&&!p.getShade().isEmpty()?" · "+p.getShade():"" %></div>
                <div class="adm-prod-card__row">
                    <span class="adm-prod-card__price">Rs <%= String.format("%,.0f",p.getPrice()) %></span>
                    <span class="adm-prod-card__cat"><%= p.getCategory() %></span>
                </div>
                <div class="adm-prod-card__actions">
                    <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=edit&id=<%= p.getProductId() %>#adm-form" class="btn-edit">✏️ Edit</a>
                    <a href="${pageContext.request.contextPath}/AdminProductsServlet?action=delete&id=<%= p.getProductId() %>" class="btn-delete" onclick="return confirm('Delete <%= p.getProductName().replace("'","") %>?')">🗑️ Delete</a>
                </div>
            </div>
        </div>
    <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
