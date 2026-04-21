<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ page import="model.ProductModel" %>
<%
    // 1. Retrieve the product object from the request attribute (set by your Servlet)
    ProductModel p = (ProductModel) request.getAttribute("product");
    
    // 2. Redirect safety: If a user tries to access this page directly without a product ID
    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | <%= p.getProductName() %></title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/product-detail.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css" />
</head>
<body>

    <jsp:include page="/components/navbar.jsp" />


    <div class="breadcrumb">
        <div class="breadcrumb-inner">
            <a href="${pageContext.request.contextPath}/pages/home.jsp">Home</a>
            <span>&#8250;</span>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet">Shop</a>
            <span>&#8250;</span>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=<%= p.getCategory() %>">
                <%= p.getCategory() %>
            </a>
            <span>&#8250;</span>
            <strong><%= p.getProductName() %></strong>
        </div>
    </div>


    <main class="detail-main">

        <div class="detail-img-wrap">
            <img src="<%= p.getImage() %>"
                 alt="<%= p.getProductName() %>"
                 onerror="this.src='${pageContext.request.contextPath}/images/placeholder.jpg'" />
        </div>

        <div class="detail-info">

            <div class="detail-category"><%= p.getCategory() %></div>

            <h1 class="detail-name"><%= p.getProductName() %></h1>

            <% if (p.getBrand() != null && !p.getBrand().isEmpty()) { %>
                <p class="detail-brand">by <strong><%= p.getBrand() %></strong></p>
            <% } %>

            <div class="detail-price">Rs <%= String.format("%,.0f", p.getPrice()) %></div>

            <div class="detail-divider"></div>

            <% if (p.getShade() != null && !p.getShade().isEmpty()) { %>
                <div class="detail-shade">
                    <div class="shade-dot"></div>
                    <div>
                        <div class="shade-label">Shade</div>
                        <div class="shade-name"><%= p.getShade() %></div>
                    </div>
                </div>
                <div class="detail-divider"></div>
            <% } %>

            <div class="detail-specs">
                <% if (p.getNetWeight() != null && !p.getNetWeight().isEmpty()) { %>
                    <div class="spec-box">
                        <div class="spec-label">Net Weight</div>
                        <div class="spec-value"><%= p.getNetWeight() %></div>
                    </div>
                <% } %>
                
                <% if (p.getShelfLife() != null && !p.getShelfLife().isEmpty()) { %>
                    <div class="spec-box">
                        <div class="spec-label">Shelf Life</div>
                        <div class="spec-value"><%= p.getShelfLife() %></div>
                    </div>
                <% } %>
                
                <div class="spec-box">
                    <div class="spec-label">Category</div>
                    <div class="spec-value"><%= p.getCategory() %></div>
                </div>
                
                <div class="spec-box">
                    <div class="spec-label">Product ID</div>
                    <div class="spec-value">#<%= p.getProductId() %></div>
                </div>
            </div>

            <% if (p.getFeatures() != null && !p.getFeatures().isEmpty()) { %>
                <div class="detail-desc">
                    <h3>About this Product</h3>
                    <p><%= p.getFeatures() %></p>
                </div>
            <% } %>

            <div class="detail-actions">
                <form action="${pageContext.request.contextPath}/AddToCartServlet" method="post" style="flex:1;">
                    <input type="hidden" name="productId" value="<%= p.getProductId() %>" />
                    <button type="submit" class="btn-add-cart" style="width:100%;">Add to Cart</button>
                </form>
                <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="btn-back">
                    &#8592; Back to Shop
                </a>
            </div>

        </div>
    </main>


    <jsp:include page="/components/footer.jsp" />

</body>
</html>