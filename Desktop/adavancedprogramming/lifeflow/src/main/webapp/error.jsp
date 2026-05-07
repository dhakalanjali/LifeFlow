<%--
  Created by IntelliJ IDEA.
  User: Anjali
  Date: 7/05/2026
  Time: 9:45 am

--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    String dashboardLink = request.getContextPath() + "/login";
    if(currentUser != null) {
        if("admin".equals(currentUser.getRole())) {
            dashboardLink = request.getContextPath() + "/admin/dashboard";
        } else {
            dashboardLink = request.getContextPath() + "/userDashboard.jsp";
        }
    }

    // Get error code
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMessage = (String) request.getAttribute("javax.servlet.error.message");

    String errorTitle = "Something Went Wrong!";
    String errorDesc = "An unexpected error occurred.";
    String errorIcon = "⚠️";

    if(statusCode != null) {
        if(statusCode == 404) {
            errorTitle = "Page Not Found!";
            errorDesc = "The page you are looking for does not exist.";
            errorIcon = "🔍";
        } else if(statusCode == 500) {
            errorTitle = "Server Error!";
            errorDesc = "Something went wrong on our end. Please try again.";
            errorIcon = "🔧";
        } else if(statusCode == 403) {
            errorTitle = "Access Denied!";
            errorDesc = "You do not have permission to access this page.";
            errorIcon = "🚫";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Error</title>
    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:Arial,sans-serif; }
        body { background:#f4f6f9; display:flex; justify-content:center; align-items:center; min-height:100vh; }
        .error-container {
            background:white; border-radius:16px;
            padding:50px 40px; text-align:center;
            box-shadow:0 4px 20px rgba(0,0,0,0.1);
            max-width:500px; width:90%;
        }
        .error-icon { font-size:80px; margin-bottom:20px; }
        .error-code {
            font-size:80px; font-weight:900;
            color:#c0392b; line-height:1;
            margin-bottom:10px;
        }
        .error-title {
            font-size:24px; font-weight:bold;
            color:#2c3e50; margin-bottom:12px;
        }
        .error-desc {
            font-size:15px; color:#7f8c8d;
            margin-bottom:30px; line-height:1.6;
        }
        .btn-home {
            display:inline-block; padding:12px 30px;
            background:#c0392b; color:white;
            border-radius:8px; text-decoration:none;
            font-size:15px; font-weight:bold;
            transition:background 0.2s;
            margin:5px;
        }
        .btn-home:hover { background:#a93226; }
        .btn-back {
            display:inline-block; padding:12px 30px;
            background:white; color:#c0392b;
            border:2px solid #c0392b;
            border-radius:8px; text-decoration:none;
            font-size:15px; font-weight:bold;
            transition:all 0.2s;
            margin:5px;
        }
        .btn-back:hover { background:#fdf0ef; }
        .divider {
            width:60px; height:4px;
            background:#c0392b; border-radius:2px;
            margin:0 auto 20px;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-icon"><%=errorIcon%></div>
    <% if(statusCode != null) { %>
    <div class="error-code"><%=statusCode%></div>
    <% } %>
    <div class="divider"></div>
    <div class="error-title"><%=errorTitle%></div>
    <div class="error-desc"><%=errorDesc%></div>
    <a href="<%=dashboardLink%>" class="btn-home">🏠 Go to Dashboard</a>
    <a href="javascript:history.back()" class="btn-back">← Go Back</a>
</div>
</body>
</html>
