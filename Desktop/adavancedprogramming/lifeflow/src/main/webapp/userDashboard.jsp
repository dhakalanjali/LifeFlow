<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodStock" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
    List<BloodStock> stockList = (List<BloodStock>) request.getAttribute("stockList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - LifeFlow</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f5f5; }
        .navbar { background: #8B0000; color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { padding: 30px; }
        h2 { color: #8B0000; }
        .blood-grid { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 20px; }
        .blood-card { background: white; border: 2px solid #8B0000; border-radius: 10px;
            padding: 20px; text-align: center; width: 120px; }
        .blood-card h3 { color: #8B0000; font-size: 1.5rem; margin: 0; }
        .blood-card p { margin: 5px 0 0; color: #555; font-size: 0.9rem; }
        .low { border-color: orange; }
        .out { border-color: red; background: #fff0f0; }
        .welcome-box { background: white; padding: 20px; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .quick-links { display: flex; gap: 15px; margin-top: 20px; flex-wrap: wrap; }
        .quick-link { background: #8B0000; color: white; padding: 12px 24px;
            border-radius: 8px; text-decoration: none; font-weight: bold; }
        .quick-link:hover { background: #6B0000; }
    </style>
</head>
<body>

<div class="navbar">
    <span style="font-size:1.3rem; font-weight:bold;">❤️ LifeFlow</span>
    <div>
        <a href="${pageContext.request.contextPath}/user/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/user/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/user/donationHistory">Donation History</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>

<div class="container">
    <div class="welcome-box">
        <h2>Welcome, <%= userName != null ? userName : "Donor" %>! 👋</h2>
        <p>Thank you for being a life-saver. Here is your donor dashboard.</p>
        <div class="quick-links">
            <a href="${pageContext.request.contextPath}/user/profile" class="quick-link">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/user/donationHistory" class="quick-link">🩸 Donation History</a>
        </div>
    </div>

    <h2>🩸 Current Blood Availability</h2>
    <div class="blood-grid">
        <% if (stockList != null) {
            for (BloodStock bs : stockList) {
                int units = bs.getUnitsAvailable();
                String cardClass = units == 0 ? "out" : units < 5 ? "low" : "";
        %>
        <div class="blood-card <%= cardClass %>">
            <h3><%= bs.getBloodGroup() %></h3>
            <p><%= units %> unit<%= units != 1 ? "s" : "" %></p>
            <% if (units == 0) { %><p style="color:red;">Not Available</p><% } %>
            <% if (units > 0 && units < 5) { %><p style="color:orange;">Low Stock</p><% } %>
        </div>
        <% }} %>
    </div>
</div>

</body>
</html>