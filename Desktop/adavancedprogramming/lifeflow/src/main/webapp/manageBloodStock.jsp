<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.lifeflow.lifeflow.db.DBConnection" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("userRole") == null ||
            !session.getAttribute("userRole").equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Manage Blood Stock</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f5f5f5;
        }

        .navbar {
            background-color: #C0392B;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            color: white;
            font-size: 24px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
            margin-left: 20px;
        }

        .navbar a:hover {
            text-decoration: underline;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-title {
            color: #2C3E50;
            font-size: 24px;
            margin-bottom: 20px;
        }

        .success-message {
            background-color: #e8f8e8;
            color: #27AE60;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }

        .error-message {
            background-color: #fde8e8;
            color: #C0392B;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            text-align: center;
        }

        table {
            width: 100%;
            background-color: white;
            border-radius: 10px;
            border-collapse: collapse;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        table th {
            background-color: #C0392B;
            color: white;
            padding: 15px;
            text-align: left;
        }

        table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #2C3E50;
        }

        table tr:hover {
            background-color: #fdf5f5;
        }

        .units-input {
            width: 80px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
            font-size: 14px;
        }

        .btn-update {
            padding: 6px 15px;
            background-color: #C0392B;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
        }

        .btn-update:hover {
            background-color: #E74C3C;
        }

        .blood-badge {
            background-color: #C0392B;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }

        .units-low {
            color: #E74C3C;
            font-weight: bold;
        }

        .units-ok {
            color: #27AE60;
            font-weight: bold;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <h1>🩸 LifeFlow</h1>
    <div>
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="manageBloodStock.jsp">Blood Stock</a>
        <a href="logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2 class="page-title">Manage Blood Stock</h2>

    <%-- Show messages --%>
    <% if (request.getAttribute("success") != null) { %>
    <div class="success-message"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message"><%= request.getAttribute("error") %></div>
    <% } %>

    <!-- Blood Stock Table -->
    <table>
        <tr>
            <th>Blood Type</th>
            <th>Units Available</th>
            <th>Status</th>
            <th>Update Units</th>
            <th>Action</th>
        </tr>

        <%
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM blood_stock ORDER BY blood_type";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int units = rs.getInt("units_available");
                String status = units < 5 ? "Low" : "Available";
                String statusClass = units < 5 ? "units-low" : "units-ok";
        %>
        <tr>
            <td><span class="blood-badge"><%= rs.getString("blood_type") %></span></td>
            <td class="<%= statusClass %>"><%= units %> units</td>
            <td class="<%= statusClass %>"><%= status %></td>
            <td>
                <form action="updateBloodStock" method="post" style="display:inline;">
                    <input type="hidden" name="stockId" value="<%= rs.getInt("stock_id") %>"/>
                    <input type="number" name="units" class="units-input"
                           value="<%= units %>" min="0"/>
                    <button type="submit" class="btn-update">Update</button>
                </form>
            </td>
            <td class="<%= statusClass %>">
                <%= units < 5 ? "⚠️ Need Donation!" : "✅ Good" %>
            </td>
        </tr>
        <%
            }
            rs.close();
            ps.close();
            DBConnection.closeConnection(conn);
        %>
    </table>
</div>

</body>
</html>