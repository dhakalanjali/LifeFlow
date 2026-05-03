<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.lifeflow.lifeflow.db.DBConnection" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    // Check if admin is logged in
    User loggedUser = (User) session.getAttribute("user");
    if(loggedUser == null || !loggedUser.getRole().equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
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

        body { background-color: #f4f6f9; }

        /* NAV */
        nav {
            background:#c0392b;
            padding:15px 30px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            box-shadow:0 2px 8px rgba(0,0,0,0.2);
        }
        nav h1 { color:white; font-size:22px; letter-spacing:1px; }
        .nav-links a {
            color:white;
            text-decoration:none;
            margin-left:20px;
            font-size:14px;
            padding:8px 14px;
            border-radius:5px;
            transition:background 0.2s;
        }
        .nav-links a:hover { background:rgba(255,255,255,0.2); }
        .nav-links a.active { background:rgba(255,255,255,0.25); }

        .container {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .page-title {
            color: #2C3E50;
            font-size: 24px;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #28a745;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 4px solid #dc3545;
        }

        /* SUMMARY CARDS */
        .summary {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }
        .sum-card {
            flex: 1;
            min-width: 150px;
            background: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            border-top: 4px solid #c0392b;
        }
        .sum-card .num { font-size: 32px; font-weight: bold; color: #c0392b; }
        .sum-card .lbl { font-size: 12px; color: #888; margin-top: 5px; }

        /* TABLE */
        .table-wrap {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.07);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th {
            background-color: #C0392B;
            color: white;
            padding: 14px 16px;
            text-align: left;
            font-size: 13px;
        }

        table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f0f0f0;
            color: #2C3E50;
            font-size: 13px;
        }

        table tr:last-child td { border-bottom: none; }
        table tr:hover td { background-color: #fdf5f5; }

        .units-input {
            width: 80px;
            padding: 7px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-align: center;
            font-size: 14px;
        }

        .units-input:focus {
            outline: none;
            border-color: #c0392b;
        }

        .btn-update {
            padding: 7px 16px;
            background-color: #C0392B;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            font-weight: bold;
            transition: background 0.2s;
        }

        .btn-update:hover { background-color: #a93226; }

        .blood-badge {
            background-color: #C0392B;
            color: white;
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }

        .units-low { color: #E74C3C; font-weight: bold; }
        .units-ok { color: #27AE60; font-weight: bold; }

        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
        }
        .back-btn:hover { background: #5a6268; }

        @media(max-width:768px) {
            nav { flex-direction:column; gap:12px; }
            .nav-links { display:flex; flex-wrap:wrap; gap:5px; }
            .nav-links a { margin-left:0; }
            .summary { flex-direction:column; }
        }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <h1>🩸 LifeFlow Admin</h1>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">👥 Users</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp" class="active">🩸 Blood Stock</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
    </div>
</nav>

<div class="container">
    <h2 class="page-title">🩸 Manage Blood Stock</h2>

    <%-- Show messages --%>
    <% if (request.getAttribute("success") != null) { %>
    <div class="success-message">✅ <%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">❌ <%= request.getAttribute("error") %></div>
    <% } %>

    <%
        Connection conn = null;
        int totalUnits = 0;
        int lowCount = 0;
        int availableCount = 0;
        try {
            conn = DBConnection.getConnection();
            String countSql = "SELECT SUM(units_available), COUNT(CASE WHEN units_available < 5 THEN 1 END), COUNT(CASE WHEN units_available >= 5 THEN 1 END) FROM blood_stock";
            PreparedStatement countPs = conn.prepareStatement(countSql);
            ResultSet countRs = countPs.executeQuery();
            if(countRs.next()) {
                totalUnits = countRs.getInt(1);
                lowCount = countRs.getInt(2);
                availableCount = countRs.getInt(3);
            }
            countRs.close();
            countPs.close();
        } catch(Exception e) {}
    %>

    <!-- SUMMARY CARDS -->
    <div class="summary">
        <div class="sum-card">
            <div class="num"><%=totalUnits%></div>
            <div class="lbl">Total Units</div>
        </div>
        <div class="sum-card">
            <div class="num" style="color:#27ae60"><%=availableCount%></div>
            <div class="lbl">Blood Types Available</div>
        </div>
        <div class="sum-card">
            <div class="num" style="color:#e74c3c"><%=lowCount%></div>
            <div class="lbl">Low Stock Types</div>
        </div>
    </div>

    <!-- BLOOD STOCK TABLE -->
    <div class="table-wrap">
        <table>
            <tr>
                <th>Blood Type</th>
                <th>Units Available</th>
                <th>Status</th>
                <th>Update Units</th>
                <th>Indicator</th>
            </tr>

            <%
                try {
                    String sql = "SELECT * FROM blood_stock ORDER BY blood_type";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int units = rs.getInt("units_available");
                        String status = units < 5 ? "Low Stock" : "Available";
                        String statusClass = units < 5 ? "units-low" : "units-ok";
            %>
            <tr>
                <td><span class="blood-badge"><%= rs.getString("blood_type") %></span></td>
                <td class="<%= statusClass %>"><%= units %> units</td>
                <td class="<%= statusClass %>"><%= status %></td>
                <td>
                    <form action="<%=request.getContextPath()%>/updateBloodStock" method="post" style="display:inline;">
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
                } catch(Exception e) {
                    out.println("<tr><td colspan='5'>Error loading blood stock!</td></tr>");
                } finally {
                    DBConnection.closeConnection(conn);
                }
            %>
        </table>
    </div>

    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">← Back to Dashboard</a>

</div>
</body>
</html>