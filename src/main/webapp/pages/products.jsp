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
                        <a href="${pageContext.request.contextPath}/ProductDetailServlet?id=<%= p.getProductId() %>"
                           class="prod-card__overlay-btn">
                            View Details
                        </a>
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

<jsp:include page="/components/footer.jsp" />

</body>
</html>