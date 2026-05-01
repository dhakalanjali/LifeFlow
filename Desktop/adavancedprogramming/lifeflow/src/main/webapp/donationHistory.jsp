<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation History - LifeFlow</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f5f5; }
        .navbar { background: #8B0000; color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { padding: 30px; }
        h2 { color: #8B0000; }
        .card { background: white; padding: 20px; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #8B0000; color: white; padding: 12px;
            text-align: left; font-size: 0.9rem; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 0.9rem; }
        tr:hover td { background: #fff5f5; }
        .badge { padding: 4px 12px; border-radius: 20px;
            font-size: 0.8rem; font-weight: bold; }
        .badge-completed { background: #d4edda; color: #155724; }
        .no-data { text-align: center; padding: 40px;
            color: #888; font-size: 1rem; }
        .stats { display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 20px; }
        .stat-box { background: white; padding: 20px; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-top: 4px solid #8B0000; flex: 1; min-width: 150px; }
        .stat-box h3 { margin: 0; font-size: 2rem; color: #8B0000; }
        .stat-box p { margin: 5px 0 0; color: #888; font-size: 0.85rem; }
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
    <h2>🩸 My Donation History</h2>

    <%-- Stats --%>
    <div class="stats">
        <div class="stat-box">
            <h3>0</h3>
            <p>Total Donations</p>
        </div>
        <div class="stat-box">
            <h3>0</h3>
            <p>Units Donated</p>
        </div>
        <div class="stat-box">
            <h3>--</h3>
            <p>Last Donation</p>
        </div>
    </div>

    <%-- History Table --%>
    <div class="card">
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Date</th>
                <th>Blood Group</th>
                <th>Units</th>
                <th>Camp</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <%-- Data will come from database via servlet --%>
            <tr>
                <td colspan="6" class="no-data">
                    🩸 No donation records found yet.<br>
                    <small>Your donation history will appear here.</small>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>