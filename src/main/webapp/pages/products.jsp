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

<%
    List<ProductModel> productList = (List<ProductModel>) request.getAttribute("products");
    String searchQuery  = (String) request.getAttribute("searchQuery");
    int totalProducts   = (productList != null) ? productList.size() : 0;
    if (searchQuery  == null) searchQuery  = "";
%>

<div class="shop-controls">
    <div class="shop-controls__inner">
        <form class="shop-search" action="${pageContext.request.contextPath}/FetchProductsServlet" method="get">
            <span class="shop-search__icon">
                <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/>
                </svg>
            </span>
            <input type="text" name="search" class="shop-search__input" placeholder="Search products..." value="<%= searchQuery %>" />
        </form>
        <span class="shop-count"><%= totalProducts %> product<%= totalProducts != 1 ? "s" : "" %></span>
    </div>
</div>

<div class="shop-main">
    <% if (productList == null || productList.isEmpty()) { %>
        <div class="shop-empty">
            <div class="shop-empty__icon">&#128200;</div>
            <div class="shop-empty__title">No products found</div>
        </div>
    <% } else { %>
        <div class="shop-grid">
            <% for (ProductModel p : productList) { %>
            <div class="prod-card">
                <div class="prod-card__img-wrap">
                    <!-- FIXED IMAGE PATH: Added Context Path and Images Folder -->
                    <img
                        src="${pageContext.request.contextPath}/images/<%= p.getImage() %>"
                        alt="<%= p.getProductName() %>"
                        class="prod-card__img"
                        onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'"
                    />

                    <div class="prod-card__overlay">
                        <!-- Use the JS function instead of a direct URL redirect for better UX -->
                        <button class="prod-card__overlay-btn" onclick="showDetails('<%= p.getProductId() %>')">
                            Details
                        </button>
                    </div>
                </div>

                <div class="prod-card__body">
                    <div class="prod-card__cat"><%= p.getCategory() %></div>
                    <div class="prod-card__name"><%= p.getProductName() %></div>
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

<!-- Modal Structure (Remains the same as your draft) -->
<div id="productModal" style="display:none; position:fixed; inset:0; z-index:2000; background:rgba(26,10,15,0.7); backdrop-filter:blur(6px); align-items:center; justify-content:center; padding:20px;">
    <div style="background:#fff; border-radius:24px; max-width:760px; width:100%; max-height:90vh; overflow-y:auto; box-shadow:0 30px 80px rgba(0,0,0,0.4);">
        <div id="modalContent" style="padding:40px;"></div>
    </div>
</div>

<jsp:include page="/components/footer.jsp" />

<script>
var productData = {};

<%
if (productList != null) {
    for (ProductModel p : productList) {
        String features = p.getFeatures() != null ? p.getFeatures().replace("'", "\\'").replace("\n", " ") : "";
%>
productData['<%= p.getProductId() %>'] = {
    id:       '<%= p.getProductId() %>',
    name:     '<%= p.getProductName().replace("'", "\\'") %>',
    category: '<%= p.getCategory() %>',
    price:    '<%= String.format("%.0f", p.getPrice()) %>',
    features: '<%= features %>',
    // FIXED JS IMAGE PATH
    image:    '${pageContext.request.contextPath}/images/<%= p.getImage() %>'
};
<% } } %>

function showDetails(productId) {
    var p = productData[productId];
    if (!p) return;

    var html = '<div style="display:grid;grid-template-columns:1fr 1fr;gap:32px;align-items:start;">'
        + '<div><img src="' + p.image + '" style="width:100%;border-radius:16px;" onerror="this.src=\'${pageContext.request.contextPath}/images/placeholder.jpg\'"></div>'
        + '<div>'
        + '<h2>' + p.name + '</h2>'
        + '<p style="font-size:24px; color:#8b2442;">Rs ' + parseInt(p.price).toLocaleString() + '</p>'
        + '<p>' + p.features + '</p>'
        + '<button onclick="closeModal()" style="padding:10px 20px; cursor:pointer;">Close</button>'
        + '</div></div>';

    document.getElementById('modalContent').innerHTML = html;
    document.getElementById('productModal').style.display = 'flex';
}

function closeModal() {
    document.getElementById('productModal').style.display = 'none';
}
</script>
</body>
</html>