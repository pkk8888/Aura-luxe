<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // If logged in → go to home, otherwise → go to login
    String loggedInUser = (String) session.getAttribute("userID");
    if (loggedInUser != null) {
        response.sendRedirect(request.getContextPath() + "/pages/home.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    }
%>
