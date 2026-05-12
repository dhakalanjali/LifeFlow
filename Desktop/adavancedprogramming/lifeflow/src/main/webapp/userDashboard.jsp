<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodStock" %>
<%@ page import="com.lifeflow.lifeflow.service.BloodService" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String userBloodType = (String) session.getAttribute("userBloodType");

    BloodService bloodService = new BloodService();
    List<BloodStock> stockList = bloodService.getAllBloodStock();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - LifeFlow</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }

        /* Navbar */
        .navbar {
            background: #C0392B;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .navbar-brand {
            font-size: 1.4rem;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }
        .navbar-links {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: center;
        }
        .navbar-links a {
            color: white;
            text-decoration: none;
            font-size: 0.9rem;
        }
        .navbar-links a:hover { text-decoration: underline; }
        .btn-logout {
            background: white;
            color: #C0392B;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 0.85rem;
        }

        /* Container */
        .container { padding: 30px 20px; max-width: 1100px; margin: 0 auto; }

        /* Welcome */
        .welcome-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            border-left: 5px solid #C0392B;
        }
        .welcome-box h2 { color: #C0392B; font-size: 1.5rem; }
        .welcome-box p { color: #666; margin-top: 5px; }

        /* Quick links */
        .quick-links {
            display: flex;
            gap: 15px;
            margin-top: 15px;
            flex-wrap: wrap;
        }
        .quick-link {
            background: #C0392B;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            font-size: 0.9rem;
        }
        .quick-link:hover { background: #a93226; }

        /* Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            text-align: center;
            border-top: 4px solid #C0392B;
        }
        .stat-card h3 { font-size: 2rem; color: #C0392B; }
        .stat-card p { color: #888; font-size: 0.85rem; margin-top: 5px; }

        /* Blood grid */
        .section-title {
            font-size: 1.2rem;
            color: #C0392B;
            margin-bottom: 15px;
            font-weight: bold;
        }
        .blood-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .blood-card {
            background: white;
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.06);
            transition: transform 0.2s;
        }
        .blood-card:hover { transform: translateY(-3px); }
        .blood-card h3 { color: #C0392B; font-size: 1.6rem; }
        .blood-card p { color: #666; font-size: 0.85rem; margin-top: 5px; }
        .blood-card.low { border-color: orange; background: #FFFBEB; }
        .blood-card.out { border-color: #C0392B; background: #FEF0F0; }

        /* Responsive */
        @media (max-width: 768px) {
            .navbar { padding: 12px 15px; }
            .navbar-links { gap: 8px; }
            .navbar-links a { font-size: 0.8rem; }
            .container { padding: 15px; }
            .blood-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .quick-links { flex-direction: column; }
            .quick-link { text-align: center; }
        }
        @media (max-width: 480px) {
            .navbar-links { display: none; }
            .blood-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">❤️ LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <!-- Welcome -->
    <div class="welcome-box">
        <h2>Welcome, <%= userName != null ? userName : "Donor" %>! 👋</h2>
        <p>Thank you for being a life-saver. Your blood type: <strong><%= userBloodType != null ? userBloodType : "N/A" %></strong></p>
        <div class="quick-links">
            <a href="${pageContext.request.contextPath}/profile.jsp" class="quick-link">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/donationHistory.jsp" class="quick-link">🩸 Donation History</a>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="quick-link">📋 Request Blood</a>
        </div>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-card">
            <h3>🩸</h3>
            <p>Donate Blood</p>
        </div>
        <div class="stat-card">
            <h3>🔍</h3>
            <p>Search Blood</p>
        </div>
        <div class="stat-card">
            <h3>📋</h3>
            <p>My Requests</p>
        </div>
        <div class="stat-card">
            <h3>⛺</h3>
            <p>Donation Camps</p>
        </div>
    </div>

    <!-- Blood Availability -->
    <div class="section-title">🩸 Current Blood Availability</div>
    <div class="blood-grid">
        <%
            if (stockList != null) {
                for (BloodStock bs : stockList) {
                    int units = bs.getUnitsAvailable();
                    String cardClass = units == 0 ? "out" : units < 5 ? "low" : "";
        %>
        <div class="blood-card <%= cardClass %>">
            <h3><%= bs.getBloodGroup() %></h3>
            <p><%= units %> unit<%= units != 1 ? "s" : "" %></p>
            <% if (units == 0) { %><p style="color:#C0392B;font-size:.75rem;">Not Available</p><% } %>
            <% if (units > 0 && units < 5) { %><p style="color:orange;font-size:.75rem;">Low Stock</p><% } %>
        </div>
        <% }} %>
    </div>

</div>
</body>
</html>