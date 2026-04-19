<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Redirect the root URL straight to the login page
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
%>
