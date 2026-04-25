<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ page import="java.util.List, model.ProductModel" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Shop All Products</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/products.css" />
</head>
<body>

 <jsp:include page="/components/navbar.jsp" />
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


<!-- ============================================================
     PAGE HEADER
     ============================================================ -->
<div class="shop-header">
    <span class="shop-header__label">AuraLuxe Collection</span>
    <h1 class="shop-header__title">Shop All Products</h1>
    <p class="shop-header__sub">Discover premium makeup crafted to bring out your natural beauty</p>
</div>


<!-- ============================================================
     CONTROLS BAR (search + category filters)
     ============================================================ -->
<%
    List<ProductModel> productList = (List<ProductModel>) request.getAttribute("products");
    String selectedCat  = (String) request.getAttribute("selectedCategory");
    String searchQuery  = (String) request.getAttribute("searchQuery");
    int totalProducts   = (productList != null) ? productList.size() : 0;
    if (selectedCat  == null) selectedCat  = "";
    if (searchQuery  == null) searchQuery  = "";
%>

<div class="shop-controls">
    <div class="shop-controls__inner">

        <!-- Search form -->
        <form class="shop-search" action="${pageContext.request.contextPath}/FetchProductsServlet" method="get">
            <span class="shop-search__icon">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/>
                </svg>
            </span>
            <input
                type="text"
                name="search"
                class="shop-search__input"
                placeholder="Search products..."
                value="<%= searchQuery %>"
            />
        </form>

        <!-- Category filters -->
        <div class="shop-filters">
            <a href="${pageContext.request.contextPath}/FetchProductsServlet"
               class="shop-filter-btn <%= selectedCat.isEmpty() && searchQuery.isEmpty() ? "active" : "" %>">
                All
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=lipstick"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("lipstick") ? "active" : "" %>">
                Lips
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=foundation"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("foundation") ? "active" : "" %>">
                Foundation
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=eyeshadow"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("eyeshadow") ? "active" : "" %>">
                Eyes
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=blush"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("blush") ? "active" : "" %>">
                Blush
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=highlighter"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("highlighter") ? "active" : "" %>">
                Highlighter
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=mascara"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("mascara") ? "active" : "" %>">
                Mascara
            </a>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=primer"
               class="shop-filter-btn <%= selectedCat.equalsIgnoreCase("primer") ? "active" : "" %>">
                Primer
            </a>
        </div>

        <!-- Count -->
        <span class="shop-count"><%= totalProducts %> product<%= totalProducts != 1 ? "s" : "" %></span>
    </div>
</div>


<!-- ============================================================
     PRODUCTS GRID
     ============================================================ -->
<div class="shop-main">
    <% if (productList == null || productList.isEmpty()) { %>
        <div class="shop-empty">
            <div class="shop-empty__icon">&#128200;</div>
            <div class="shop-empty__title">No products found</div>
            <p class="shop-empty__sub">
                Try a different search or
                <a href="${pageContext.request.contextPath}/FetchProductsServlet" style="color:#8b2442;">browse all products</a>.
            </p>
        </div>
    <% } else { %>
        <div class="shop-grid">
            <% for (ProductModel p : productList) { %>
            <div class="prod-card">

                <!-- Image -->
                <div class="prod-card__img-wrap">
                    <img
                        src="<%= p.getImage() %>"
                        alt="<%= p.getProductName() %>"
                        class="prod-card__img"
                        onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'"
                    />

                    <!-- Badge based on category -->
                    <%
                        String cat = p.getCategory() != null ? p.getCategory().toLowerCase() : "";
                        String badgeClass = "prod-card__badge";
                        String badgeText  = "";
                        if (cat.contains("lipstick") || cat.contains("lip")) {
                            badgeText = "Lips"; badgeClass += "";
                        } else if (cat.contains("new")) {
                            badgeText = "New"; badgeClass += " prod-card__badge--new";
                        }
                        // Show price-based badge
                        if (p.getPrice() >= 3000) { badgeText = "Premium"; }
                        else if (p.getPrice() <= 1000) { badgeText = "Best Value"; badgeClass += " prod-card__badge--new"; }
                    %>
                    <% if (!badgeText.isEmpty()) { %>
                        <span class="<%= badgeClass %>"><%= badgeText %></span>
                    <% } %>

                    <!-- Hover overlay -->
                    <div class="prod-card__overlay">
                        <button class="prod-card__overlay-btn"
                                onclick="window.location.href='${pageContext.request.contextPath}/ProductDetailServlet?id=<%= p.getProductId() %>'">
                            Details
                        </button>
                    </div>
                </div>

                <!-- Body -->
                <div class="prod-card__body">
                    <div class="prod-card__cat"><%= p.getCategory() %></div>
                    <div class="prod-card__name"><%= p.getProductName() %></div>
                    <div class="prod-card__brand">
                        <% if (p.getBrand() != null && !p.getBrand().isEmpty()) { %>
                            by <%= p.getBrand() %>
                        <% } %>
                    </div>

                    <% if (p.getShade() != null && !p.getShade().isEmpty()) { %>
                    <div class="prod-card__shade">
                        <span class="prod-card__shade-dot"></span>
                        <%= p.getShade() %>
                    </div>
                    <% } %>

                    <!-- Meta: weight + shelf life -->
                    <div class="prod-card__meta">
                        <% if (p.getNetWeight() != null && !p.getNetWeight().isEmpty()) { %>
                        <span class="prod-card__meta-item">
                            <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/>
                            </svg>
                            <%= p.getNetWeight() %>
                        </span>
                        <% } %>
                        <% if (p.getShelfLife() != null && !p.getShelfLife().isEmpty()) { %>
                        <span class="prod-card__meta-item">
                            <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                                <rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/>
                            </svg>
                            <%= p.getShelfLife() %>
                        </span>
                        <% } %>
                    </div>

                    <div class="prod-card__footer">
                        <span class="prod-card__price">Rs <%= String.format("%,.0f", p.getPrice()) %></span>
                        <form action="${pageContext.request.contextPath}/AddToCartServlet" method="post">
                          <input type="hidden" name="productId" value="<%= p.getProductId() %>" />
                          <button type="submit" class="prod-card__add">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>


<!-- ============================================================
     PRODUCT DETAIL MODAL
     ============================================================ -->
<div id="productModal" style="
    display:none; position:fixed; inset:0; z-index:2000;
    background:rgba(26,10,15,0.7); backdrop-filter:blur(6px);
    align-items:center; justify-content:center; padding:20px;">
    <div style="
        background:#fff; border-radius:24px; max-width:760px; width:100%;
        max-height:90vh; overflow-y:auto;
        box-shadow:0 30px 80px rgba(0,0,0,0.4);
        animation: alFadeUp 0.35s ease both;">
        <div id="modalContent" style="padding:40px;"></div>
    </div>
</div>

<style>
@keyframes alFadeUp {
    from { opacity:0; transform:translateY(30px); }
    to   { opacity:1; transform:translateY(0); }
}
</style>


<!-- ============================================================
     FOOTER
     ============================================================ -->
<jsp:include page="/components/footer.jsp" />

<!-- Toast -->
<div class="al-toast" id="alToast"></div>


<!-- ============================================================
     JAVASCRIPT
     ============================================================ -->
<script>
// ── Toast ──────────────────────────────────────────────────────
function showToast(msg) {
    var t = document.getElementById('alToast');
    t.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 3000);
}

// ── Add to cart ────────────────────────────────────────────────
function addToCart(productId, productName) {
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/AddToCartServlet';

    var input = document.createElement('input');
    input.type = 'hidden'; input.name = 'productId'; input.value = productId;
    form.appendChild(input);

    document.body.appendChild(form);
    form.submit();
}

// ── Product detail modal ───────────────────────────────────────
// Store all product data from server for use in modal
var productData = {};

<%
if (productList != null) {
    for (ProductModel p : productList) {
        String features = p.getFeatures() != null ? p.getFeatures().replace("'", "\\'").replace("\n", " ") : "";
        String shade     = p.getShade()     != null ? p.getShade()     : "";
        String brand     = p.getBrand()     != null ? p.getBrand()     : "";
        String weight    = p.getNetWeight() != null ? p.getNetWeight() : "";
        String shelf     = p.getShelfLife() != null ? p.getShelfLife() : "";
%>
productData['<%= p.getProductId() %>'] = {
    id:       '<%= p.getProductId() %>',
    name:     '<%= p.getProductName().replace("'", "\\'") %>',
    category: '<%= p.getCategory() %>',
    brand:    '<%= brand %>',
    shade:    '<%= shade %>',
    features: '<%= features %>',
    weight:   '<%= weight %>',
    shelf:    '<%= shelf %>',
    price:    '<%= String.format("%.0f", p.getPrice()) %>',
    image:    '<%= p.getImage() %>'
};
<% } } %>

function showDetails(productId) {
    var p = productData[productId];
    if (!p) return;

    var html = '<div style="display:grid;grid-template-columns:1fr 1fr;gap:32px;align-items:start;">'
        + '<div style="border-radius:16px;overflow:hidden;background:#fde8ec;">'
        + '<img src="' + p.image + '" alt="' + p.name + '" style="width:100%;height:320px;object-fit:cover;" onerror="this.src=\'${pageContext.request.contextPath}/images/placeholder.jpg\'">'
        + '</div>'
        + '<div>'
        + '<p style="font-size:10px;letter-spacing:3px;text-transform:uppercase;color:#c4687d;margin-bottom:8px;">' + p.category + '</p>'
        + '<h2 style="font-family:\'Playfair Display\',serif;font-size:26px;font-weight:700;color:#2a0a12;margin-bottom:6px;line-height:1.2;">' + p.name + '</h2>'
        + (p.brand ? '<p style="font-size:13px;color:#906070;margin-bottom:16px;">by ' + p.brand + '</p>' : '')
        + '<p style="font-family:\'Playfair Display\',serif;font-size:30px;font-weight:700;color:#8b2442;margin-bottom:20px;">Rs ' + parseInt(p.price).toLocaleString() + '</p>'
        + (p.shade ? '<div style="display:flex;align-items:center;gap:8px;margin-bottom:16px;"><div style="width:14px;height:14px;border-radius:50%;background:#c4687d;border:2px solid #ddd;"></div><span style="font-size:13px;color:#906070;">' + p.shade + '</span></div>' : '')
        + (p.features ? '<p style="font-size:13px;line-height:1.8;color:#6b3040;margin-bottom:20px;">' + p.features + '</p>' : '')
        + '<div style="display:flex;gap:16px;margin-bottom:24px;">'
        + (p.weight ? '<div style="background:#fdf8f9;border-radius:10px;padding:10px 16px;text-align:center;"><div style="font-size:11px;color:#906070;letter-spacing:1px;text-transform:uppercase;">Net Weight</div><div style="font-weight:600;color:#2a0a12;margin-top:4px;">' + p.weight + '</div></div>' : '')
        + (p.shelf  ? '<div style="background:#fdf8f9;border-radius:10px;padding:10px 16px;text-align:center;"><div style="font-size:11px;color:#906070;letter-spacing:1px;text-transform:uppercase;">Shelf Life</div><div style="font-weight:600;color:#2a0a12;margin-top:4px;">' + p.shelf + '</div></div>' : '')
        + '</div>'
        + '<div style="display:flex;gap:12px;">'
        + '<button onclick="addToCart(\'' + p.id + '\',\'' + p.name.replace(/'/g, "\\'") + '\');closeModal();" style="flex:1;background:linear-gradient(135deg,#8b2442,#c4687d);color:#fff;border:none;border-radius:12px;padding:14px;font-family:Raleway,sans-serif;font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;cursor:pointer;">Add to Cart</button>'
        + '<button onclick="closeModal();" style="padding:14px 20px;border:2px solid #8b2442;background:transparent;color:#8b2442;border-radius:12px;font-family:Raleway,sans-serif;font-size:12px;font-weight:600;cursor:pointer;">Close</button>'
        + '</div>'
        + '</div></div>';

    document.getElementById('modalContent').innerHTML = html;
    var modal = document.getElementById('productModal');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    document.getElementById('productModal').style.display = 'none';
    document.body.style.overflow = '';
}

// Close modal on backdrop click
document.getElementById('productModal').addEventListener('click', function(e) {
    if (e.target === this) closeModal();
});

// Close on Escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeModal();
});
</script>

</body>
</html>
