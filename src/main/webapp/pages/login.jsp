<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%
    String loggedInUser = (String) session.getAttribute("userID");
    if (loggedInUser != null) {
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (Boolean.TRUE.equals(isAdmin)) {
            response.sendRedirect(request.getContextPath() + "/pages/order_list.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/FetchProductsServlet");
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css" />
</head>
<body>

<div class="login-card">

    <%-- Brand --%>
    <div class="brand-section">
        <div class="brand-name">
            <span class="brand-star">✦</span>
            Aura<span class="luxe">Luxe</span>
            <span class="brand-star">✦</span>
        </div>
        <p class="brand-tagline">Premium Makeup Collection</p>
        <div class="brand-divider"></div>
    </div>

    <%-- Success message shown after successful registration --%>
    <% if ("true".equals(request.getParameter("registered"))) { %>
        <div class="success-box">
            Account created successfully! You can now sign in.
        </div>
    <% } %>

    <%-- Error message from LoginServlet --%>
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="error-box">
            <c:out value="${requestScope.errorMessage}" />
        </div>
    </c:if>

    <h2 class="login-heading">Welcome Back</h2>

    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">

        <div class="form-group">
            <label for="userID">User ID</label>
            <input
                type="text"
                id="userID"
                name="userID"
                placeholder="Enter your User ID"
                required
                autocomplete="username"
            />
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your Password"
                required
                autocomplete="current-password"
            />
        </div>

        <button type="submit" class="btn-login">Sign In</button>

    </form>

    <p class="register-text">
        New to AuraLuxe?
        <a href="${pageContext.request.contextPath}/pages/register.jsp">Create an account</a>
    </p>

</div>

</body>
</html>
