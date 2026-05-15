<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.db.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donation History - LifeFlow</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }

        .navbar {
            background: #C0392B; color: white;
            padding: 15px 30px;
            display: flex; justify-content: space-between;
            align-items: center; flex-wrap: wrap; gap: 10px;
        }
        .navbar-brand { font-size: 1.4rem; font-weight: bold; color: white; text-decoration: none; }
        .navbar-links { display: flex; gap: 15px; flex-wrap: wrap; align-items: center; }
        .navbar-links a { color: white; text-decoration: none; font-size: 0.9rem; }
        .navbar-links a:hover { text-decoration: underline; }
        .btn-logout { background: white; color: #C0392B; padding: 6px 14px; border-radius: 20px; font-weight: bold; font-size: 0.85rem; }

        .container { padding: 30px 20px; max-width: 1000px; margin: 0 auto; }
        h2 { color: #C0392B; margin-bottom: 20px; }

        .card {
            background: white; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #C0392B; color: white;
            padding: 12px 15px; text-align: left;
            font-size: 0.9rem;
        }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 0.9rem; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #FEF0F0; }

        .badge {
            display: inline-block; padding: 3px 10px;
            border-radius: 20px; font-size: 0.8rem; font-weight: bold;
            background: #C0392B; color: white;
        }
        .no-data {
            text-align: center; padding: 50px;
            color: #888; font-size: 1rem;
        }

        @media (max-width: 768px) {
            .navbar { padding: 12px 15px; }
            .navbar-links { gap: 8px; }
            .navbar-links a { font-size: 0.8rem; }
            .container { padding: 15px; }
        }
        @media (max-width: 480px) {
            .navbar-links { display: none; }
        }
    </style>
</head>
<body>

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
    <h2>🩸 My Donation History</h2>

    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Donation ID</th>
                    <th>Blood Type</th>
                    <th>Units Donated</th>
                    <th>Camp Name</th>
                    <th>Donation Date</th>
                </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;
                    boolean hasData = false;
                    try {
                        conn = DBConnection.getConnection();
                        String sql = "SELECT dr.record_id, dr.blood_type, dr.units_donated, " +
                                "dc.camp_name, dr.donation_date " +
                                "FROM donation_records dr " +
                                "LEFT JOIN donation_camps dc ON dr.camp_id = dc.camp_id " +
                                "WHERE dr.user_id = ? " +
                                "ORDER BY dr.donation_date DESC";
                        ps = conn.prepareStatement(sql);
                        ps.setInt(1, userId != null ? userId : 0);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td>#<%= rs.getInt("record_id") %></td>
                    <td><span class="badge"><%= rs.getString("blood_type") %></span></td>
                    <td><%= rs.getInt("units_donated") %> unit(s)</td>
                    <td><%= rs.getString("camp_name") != null ? rs.getString("camp_name") : "Independent" %></td>
                    <td><%= rs.getDate("donation_date") %></td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) {}
                        if (ps != null) try { ps.close(); } catch (SQLException e) {}
                        if (conn != null) try { conn.close(); } catch (SQLException e) {}
                    }

                    if (!hasData) {
                %>
                <tr>
                    <td colspan="5" class="no-data">
                        🩸 You have not made any donations yet.
                    </td>
                </tr>
                <%  } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>Z