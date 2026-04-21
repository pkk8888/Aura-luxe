<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<%-- Redirect away if already logged in --%>
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
    <title>AuraLuxe | Register</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register.css" />
</head>
<body>

<div class="register-card">

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

    <%-- Error message from RegisterServlet --%>
    <c:if test="${not empty requestScope.errorMessage}">
        <div class="error-box">
            <c:out value="${requestScope.errorMessage}" />
        </div>
    </c:if>

    <h2 class="register-heading">Create Your Account</h2>

    <form action="<%= request.getContextPath() %>/RegisterServlet" method="post">

        <div class="form-grid">

            <%-- Full Name --%>
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input
                    type="text"
                    id="fullName"
                    name="fullName"
                    placeholder="Your full name"
                    required
                />
            </div>

            <%-- User ID --%>
            <div class="form-group">
                <label for="userID">User ID</label>
                <input
                    type="text"
                    id="userID"
                    name="userID"
                    placeholder="Min. 6 characters"
                    required
                    
                />
            </div>

            <%-- Email --%>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="your@email.com"
                    required
                />
            </div>

            <%-- Phone Number --%>
            <div class="form-group">
                <label for="phoneNumber">Phone Number</label>
                <input
                    type="tel"
                    id="phoneNumber"
                    name="phoneNumber"
                    placeholder="10-digit number"
                    required
                    maxlength="10"
                />
            </div>

            <%-- Password --%>
            <div class="form-group">
                <label for="password">Password</label>
                <input
                    type="password"
                    id="password"
                    name="password"
                    placeholder="Upper, lower, number, symbol"
                    required
                />
            </div>

            <%-- Confirm Password --%>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input
                    type="password"
                    id="confirmPassword"
                    name="confirmPassword"
                    placeholder="Repeat your password"
                    required
                />
            </div>

            <%-- Role --%>
            <div class="form-group full-width">
                <label for="role">Account Type</label>
                <select id="role" name="role" required>
                    <option value="" disabled selected>Select account type</option>
                    <option value="user">Customer</option>
                    <option value="admin">Admin</option>
                </select>
            </div>

        </div>

        <button type="submit" class="btn-register">Create Account</button>

    </form>

    <p class="login-text">
        Already have an account?
        <a href="${pageContext.request.contextPath}/pages/login.jsp">Sign in</a>
    </p>

</div>

</body>
</html>
