<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.lifeflow.lifeflow.db.DBConnection" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if(loggedUser == null || !loggedUser.getRole().equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Blood Stock | LifeFlow Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #c0392b;
            --red-light: #e74c3c;
            --red-dark: #a93226;
            --bg: #f0f2f5;
            --white: #ffffff;
            --text: #2c3e50;
            --text-muted: #7f8c8d;
            --border: #e8ecef;
            --shadow: 0 2px 12px rgba(0,0,0,0.08);
            --green: #27ae60;
            --orange: #e67e22;
            --blue: #2980b9;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Nunito', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

        /* ── SIDEBAR ── */
        .sidebar { width: 240px; background: var(--red-dark); min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; }
        .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.15); display: flex; align-items: center; gap: 10px; }
        .sidebar-logo .logo-icon { width: 38px; height: 38px; background: white; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .sidebar-logo span { color: white; font-size: 18px; font-weight: 800; }
        .sidebar-section { padding: 16px 14px 6px; font-size: 10px; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 1.5px; font-weight: 700; }
        .sidebar-menu { padding: 0 10px; flex: 1; }
        .sidebar-menu a { display: flex; align-items: center; gap: 10px; padding: 10px 14px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 8px; font-size: 13.5px; font-weight: 600; margin-bottom: 2px; transition: all 0.2s; }
        .sidebar-menu a:hover { background: rgba(255,255,255,0.15); color: white; }
        .sidebar-menu a.active { background: white; color: var(--red-dark); font-weight: 800; }
        .sidebar-menu a .icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-footer { padding: 16px 10px; border-top: 1px solid rgba(255,255,255,0.15); }
        .sidebar-footer a { display: flex; align-items: center; gap: 10px; padding: 10px 14px; color: rgba(255,255,255,0.6); text-decoration: none; border-radius: 8px; font-size: 13px; font-weight: 600; transition: all 0.2s; }
        .sidebar-footer a:hover { background: rgba(255,255,255,0.15); color: white; }

        /* ── MAIN ── */
        .main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }

        /* ── TOPBAR ── */
        .topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .topbar-left h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-left span { font-size: 12px; color: var(--text-muted); }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* ── CONTENT ── */
        .content { padding: 28px; flex: 1; }
        .section-title { font-size: 15px; font-weight: 800; color: var(--text); margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }

        /* ── ALERTS ── */
        .alert { display: flex; align-items: center; gap: 12px; padding: 14px 18px; border-radius: 10px; font-size: 14px; font-weight: 600; margin-bottom: 24px; }
        .alert-success { background: #d4edda; color: #155724; border-left: 4px solid #28a745; }
        .alert-error   { background: #f8d7da; color: #721c24; border-left: 4px solid #dc3545; }

        /* ── STAT CARDS ── */
        .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--white); border-radius: 14px; padding: 22px; box-shadow: var(--shadow); display: flex; align-items: center; gap: 16px; transition: transform 0.2s; border-top: 4px solid var(--red); }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .stat-icon.red   { background: #fdecea; }
        .stat-icon.green { background: #eafaf1; }
        .stat-icon.amber { background: #fef9e7; }
        .stat-info .num { font-size: 30px; font-weight: 800; line-height: 1; }
        .stat-info .num.red   { color: var(--red); }
        .stat-info .num.green { color: var(--green); }
        .stat-info .num.amber { color: var(--orange); }
        .stat-info .lbl { font-size: 12px; color: var(--text-muted); margin-top: 4px; font-weight: 600; }

        /* ── TABLE PANEL ── */
        .table-wrap { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .table-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fdecea; }
        .table-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .table-header span { font-size: 12px; color: var(--text-muted); font-weight: 600; }
        table { width: 100%; border-collapse: collapse; }
        thead th { background: var(--red); color: white; padding: 12px 18px; text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; }
        tbody td { padding: 14px 18px; font-size: 13px; border-bottom: 1px solid var(--border); font-weight: 600; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fdf8f8; }

        /* Blood badge */
        .blood-badge { display: inline-flex; align-items: center; justify-content: center; width: 42px; height: 42px; border-radius: 50%; background: var(--red); color: white; font-weight: 800; font-size: 12px; box-shadow: 0 3px 8px rgba(192,57,43,0.3); }

        /* Units */
        .units-num { font-size: 20px; font-weight: 800; }
        .units-num.low { color: var(--red); }
        .units-num.ok  { color: var(--green); }
        .units-sub { font-size: 11px; color: var(--text-muted); font-weight: 600; }

        /* Bar */
        .bar-wrap { width: 100px; height: 6px; background: var(--border); border-radius: 99px; overflow: hidden; }
        .bar-fill { height: 100%; border-radius: 99px; }
        .bar-fill.low { background: var(--red); }
        .bar-fill.ok  { background: var(--green); }

        /* Status pill */
        .pill { display: inline-flex; align-items: center; gap: 5px; padding: 4px 12px; border-radius: 50px; font-size: 11px; font-weight: 700; }
        .pill.low { background: #fdecea; color: var(--red); }
        .pill.ok  { background: #eafaf1; color: #1e8449; }
        .pill-dot { width: 6px; height: 6px; border-radius: 50%; background: currentColor; }

        /* Update form */
        .update-form { display: flex; align-items: center; gap: 8px; }
        .units-input { width: 76px; padding: 8px 10px; border: 1.5px solid var(--border); border-radius: 8px; font-size: 14px; font-family: 'Nunito', sans-serif; font-weight: 700; text-align: center; color: var(--text); transition: border 0.2s; background: var(--bg); }
        .units-input:focus { outline: none; border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .btn-update { padding: 8px 16px; background: var(--red); color: white; border: none; border-radius: 8px; cursor: pointer; font-size: 12px; font-weight: 800; font-family: 'Nunito', sans-serif; transition: all 0.2s; white-space: nowrap; }
        .btn-update:hover { background: var(--red-dark); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }

        /* Responsive */
        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
            .stat-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- ── SIDEBAR ── -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">🩸</div>
        <span>LifeFlow</span>
    </div>
    <div class="sidebar-section">Admin Panel</div>
    <nav class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard">
            <span class="icon">🏠</span> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">
            <span class="icon">👥</span> Manage Users
        </a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp">
            <span class="icon">⛺</span> Manage Camps
        </a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp" class="active">
            <span class="icon">🩸</span> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/bloodRequest">
            <span class="icon">🔍</span> Search Blood
        </a>
        <a href="${pageContext.request.contextPath}/reports.jsp">
            <span class="icon">📊</span> Reports
        </a>
        <a href="${pageContext.request.contextPath}/admin/recorddonation">
            <span class="icon">🩸</span> Record Donation
        </a>
        <a href="${pageContext.request.contextPath}/about.jsp">
            <span class="icon">ℹ️</span> About
        </a>
        <a href="${pageContext.request.contextPath}/contact.jsp">
            <span class="icon">📞</span> Contact
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout">
            <span class="icon">🚪</span> Logout
        </a>
    </div>
</aside>

<!-- ── MAIN ── -->
<div class="main">

    <!-- TOPBAR -->
    <header class="topbar">
        <div class="topbar-left">
            <h2>🩸 Blood Stock</h2>
            <span>Monitor and update blood unit inventory</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <%-- Alerts --%>
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">✅ <%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">❌ <%= request.getAttribute("error") %></div>
        <% } %>

        <%
            Connection conn = null;
            int totalUnits = 0, lowCount = 0, availableCount = 0;
            try {
                conn = DBConnection.getConnection();
                String countSql = "SELECT SUM(units_available), COUNT(CASE WHEN units_available < 5 THEN 1 END), COUNT(CASE WHEN units_available >= 5 THEN 1 END) FROM blood_stock";
                PreparedStatement countPs = conn.prepareStatement(countSql);
                ResultSet countRs = countPs.executeQuery();
                if(countRs.next()) {
                    totalUnits     = countRs.getInt(1);
                    lowCount       = countRs.getInt(2);
                    availableCount = countRs.getInt(3);
                }
                countRs.close(); countPs.close();
            } catch(Exception e) {}
        %>

        <!-- STAT CARDS -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon red">🩸</div>
                <div class="stat-info">
                    <div class="num red"><%=totalUnits%></div>
                    <div class="lbl">Total Units in Stock</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">✅</div>
                <div class="stat-info">
                    <div class="num green"><%=availableCount%></div>
                    <div class="lbl">Blood Types Available</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon amber">⚠️</div>
                <div class="stat-info">
                    <div class="num amber"><%=lowCount%></div>
                    <div class="lbl">Low Stock Alerts</div>
                </div>
            </div>
        </div>

        <!-- TABLE -->
        <div class="section-title">📋 Inventory Overview</div>
        <div class="table-wrap">
            <div class="table-header">
                <h3>📋 Blood Stock Inventory</h3>
                <span>Enter a new value and click Save to update</span>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Blood Type</th>
                    <th>Units</th>
                    <th>Level</th>
                    <th>Status</th>
                    <th>Update Stock</th>
                </tr>
                </thead>
                <tbody>
                <%
                    try {
                        String sql = "SELECT * FROM blood_stock ORDER BY blood_type";
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                            int units = rs.getInt("units_available");
                            boolean low = units < 5;
                            String cls = low ? "low" : "ok";
                            int barPct = Math.min(100, (int)((units / 20.0) * 100));
                %>
                <tr>
                    <td><span class="blood-badge"><%= rs.getString("blood_type") %></span></td>
                    <td>
                        <div class="units-num <%=cls%>"><%=units%></div>
                        <div class="units-sub">units</div>
                    </td>
                    <td>
                        <div class="bar-wrap">
                            <div class="bar-fill <%=cls%>" style="width:<%=barPct%>%"></div>
                        </div>
                    </td>
                    <td>
                        <span class="pill <%=cls%>">
                            <span class="pill-dot"></span>
                            <%= low ? "Low Stock" : "Available" %>
                        </span>
                    </td>
                    <td>
                        <form action="<%=request.getContextPath()%>/updateBloodStock" method="post">
                            <div class="update-form">
                                <input type="hidden" name="stockId" value="<%= rs.getInt("stock_id") %>"/>
                                <input type="number" name="units" class="units-input" value="<%= units %>" min="0" required/>
                                <button type="submit" class="btn-update">Save</button>
                            </div>
                        </form>
                    </td>
                </tr>
                <%
                        }
                        rs.close(); ps.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='5' style='padding:20px;color:#999;text-align:center;font-weight:600;'>⚠️ Unable to load blood stock data.</td></tr>");
                    } finally {
                        DBConnection.closeConnection(conn);
                    }
                %>
                </tbody>
            </table>
        </div>

    </div>
</div>

</body>
</html>
