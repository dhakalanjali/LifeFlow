<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if(loggedUser == null || !loggedUser.getRole().equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
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

        /* SIDEBAR */
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

        /* MAIN */
        .main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .topbar-left h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-left span { font-size: 12px; color: var(--text-muted); }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* CONTENT */
        .content { padding: 28px; flex: 1; }

        /* STAT CARDS */
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--white); border-radius: 14px; padding: 22px; box-shadow: var(--shadow); display: flex; align-items: center; gap: 16px; transition: transform 0.2s; border-top: 4px solid var(--red); text-decoration: none; color: var(--text); }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .stat-icon.red { background: #fdecea; }
        .stat-icon.green { background: #eafaf1; }
        .stat-icon.orange { background: #fef9e7; }
        .stat-icon.blue { background: #eaf4fb; }
        .stat-info .num { font-size: 30px; font-weight: 800; color: var(--red); line-height: 1; }
        .stat-info .lbl { font-size: 12px; color: var(--text-muted); margin-top: 4px; font-weight: 600; }

        /* SECTION TITLE */
        .section-title { font-size: 15px; font-weight: 800; color: var(--text); margin-bottom: 14px; display: flex; align-items: center; gap: 8px; }

        /* ACTIONS */
        .actions-grid { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 28px; }
        .action-btn { display: inline-flex; align-items: center; gap: 8px; padding: 11px 20px; border-radius: 10px; font-size: 13px; font-weight: 700; text-decoration: none; transition: all 0.2s; cursor: pointer; border: none; }
        .action-btn.primary { background: var(--red); color: white; box-shadow: 0 4px 12px rgba(192,57,43,0.3); }
        .action-btn.primary:hover { background: var(--red-dark); transform: translateY(-2px); }
        .action-btn.outline { background: white; color: var(--red); border: 2px solid var(--red); }
        .action-btn.outline:hover { background: #fdf0ef; transform: translateY(-2px); }
        .action-btn.green { background: var(--green); color: white; }
        .action-btn.green:hover { background: #219150; transform: translateY(-2px); }
        .action-btn.blue { background: var(--blue); color: white; }
        .action-btn.blue:hover { background: #2471a3; transform: translateY(-2px); }

        /* CHARTS - SMALLER SIZE */
        .charts-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 28px; }
        .chart-card { background: white; border-radius: 14px; padding: 16px; box-shadow: var(--shadow); }
        .chart-card h3 { font-size: 13px; font-weight: 800; color: var(--text); margin-bottom: 10px; padding-bottom: 8px; border-bottom: 2px solid #fdecea; }
        .chart-card .chart-wrap { position: relative; height: 180px; }
        .chart-full { background: white; border-radius: 14px; padding: 16px; box-shadow: var(--shadow); margin-bottom: 28px; }
        .chart-full h3 { font-size: 13px; font-weight: 800; color: var(--text); margin-bottom: 10px; padding-bottom: 8px; border-bottom: 2px solid #fdecea; }
        .chart-full .chart-wrap { position: relative; height: 160px; }

        /* TWO COL */
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 28px; }

        /* BLOOD CARDS */
        .blood-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
        .bcard { background: white; border-radius: 12px; padding: 16px; text-align: center; box-shadow: var(--shadow); border-bottom: 3px solid var(--red); transition: transform 0.2s; }
        .bcard:hover { transform: translateY(-3px); }
        .bcard .bg { font-size: 18px; font-weight: 800; color: var(--red); }
        .bcard .bc { font-size: 24px; font-weight: 800; color: var(--text); margin: 4px 0; }
        .bcard .bl { font-size: 10px; color: var(--text-muted); font-weight: 600; }

        /* PANEL */
        .panel { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; }
        .panel-body { padding: 20px; }

        /* TABLE */
        .table-wrap { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .table-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fdecea; }
        .table-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        table { width: 100%; border-collapse: collapse; }
        thead th { background: var(--red); color: white; padding: 12px 18px; text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; }
        tbody td { padding: 13px 18px; font-size: 13px; border-bottom: 1px solid var(--border); font-weight: 600; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fdf8f8; }

        /* BADGES */
        .badge { display: inline-block; padding: 4px 10px; border-radius: 50px; font-size: 11px; font-weight: 700; }
        .badge.pending { background: #fef9e7; color: #d68910; }
        .badge.approved { background: #eafaf1; color: #1e8449; }
        .badge.rejected { background: #fdecea; color: #c0392b; }

        /* TABLE BUTTONS */
        .tbl-btn { display: inline-flex; align-items: center; gap: 4px; padding: 5px 12px; border-radius: 6px; color: white; font-size: 11px; font-weight: 700; text-decoration: none; transition: opacity 0.2s; cursor: pointer; border: none; }
        .tbl-btn:hover { opacity: 0.85; }
        .tbl-btn.approve { background: var(--green); }
        .tbl-btn.reject { background: var(--red); }
        .tbl-btn.edit { background: var(--orange); }
        .tbl-btn.delete { background: #95a5a6; }
        .tbl-btn.view { background: var(--blue); }

        /* MESSAGES */
        .msg-s { background: #d4edda; color: #155724; padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #28a745; font-size: 13px; font-weight: 600; }
        .msg-e { background: #f8d7da; color: #721c24; padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #dc3545; font-size: 13px; font-weight: 600; }
        .empty { text-align: center; padding: 40px; color: var(--text-muted); font-size: 13px; font-weight: 600; }

        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
            .stat-grid { grid-template-columns: repeat(2, 1fr); }
            .two-col, .charts-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">🩸</div>
        <span>LifeFlow</span>
    </div>
    <div class="sidebar-section">Admin Panel</div>
    <nav class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
            <span class="icon">🏠</span> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">
            <span class="icon">👥</span> Manage Users
        </a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp">
            <span class="icon">⛺</span> Manage Camps
        </a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp">
            <span class="icon">🩸</span> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/bloodRequest">
            <span class="icon">🔍</span> Search Blood
        </a>
        <a href="${pageContext.request.contextPath}/reports">
            <span class="icon">📊</span> Reports
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout">
            <span class="icon">🚪</span> Logout
        </a>
    </div>
</aside>

<!-- MAIN -->
<div class="main">
    <header class="topbar">
        <div class="topbar-left">
            <h2>Dashboard</h2>
            <span>Welcome back, Admin 👋</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <!-- MESSAGES -->
        <%
            String sm = (String) session.getAttribute("successMessage");
            String em = (String) session.getAttribute("errorMessage");
            if (sm != null) { session.removeAttribute("successMessage"); %>
        <div class="msg-s">✅ <%=sm%></div>
        <% } if (em != null) { session.removeAttribute("errorMessage"); %>
        <div class="msg-e">❌ <%=em%></div>
        <% } %>

        <!-- STAT CARDS - CLICKABLE -->
        <div class="stat-grid">
            <a href="${pageContext.request.contextPath}/admin/manageUsers" class="stat-card">
                <div class="stat-icon red">👥</div>
                <div class="stat-info"><div class="num">${totalUsers}</div><div class="lbl">Total Users</div></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manageUsers?filter=pending" class="stat-card">
                <div class="stat-icon orange">⏳</div>
                <div class="stat-info"><div class="num">${pendingUsers}</div><div class="lbl">Pending Approvals</div></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manageUsers?filter=approved" class="stat-card">
                <div class="stat-icon green">✅</div>
                <div class="stat-info"><div class="num">${approvedUsers}</div><div class="lbl">Approved Users</div></div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/manageUsers" class="stat-card">
                <div class="stat-icon blue">🩸</div>
                <div class="stat-info"><div class="num">${totalDonors}</div><div class="lbl">Total Donors</div></div>
            </a>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="section-title">⚡ Quick Actions</div>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/admin/manageUsers" class="action-btn primary">👥 Manage Users</a>
            <a href="${pageContext.request.contextPath}/admin/manageUsers?filter=pending" class="action-btn outline">⏳ Pending (${pendingUsers})</a>
            <a href="${pageContext.request.contextPath}/manageBloodStock.jsp" class="action-btn green">🩸 Blood Stock</a>
            <a href="${pageContext.request.contextPath}/manageCamps.jsp" class="action-btn blue">⛺ Manage Camps</a>
        </div>

        <!-- CHARTS - SMALLER -->
        <div class="section-title">📊 Analytics</div>
        <div class="charts-grid">
            <div class="chart-card">
                <h3>🩸 Users Overview</h3>
                <div class="chart-wrap">
                    <canvas id="donutChart"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h3>📊 Donors by Blood Type</h3>
                <div class="chart-wrap">
                    <canvas id="bloodChart"></canvas>
                </div>
            </div>
        </div>

        <div class="chart-full">
            <h3>📈 Monthly User Registrations</h3>
            <div class="chart-wrap">
                <canvas id="lineChart"></canvas>
            </div>
        </div>

        <!-- TWO COLUMN -->
        <div class="two-col">
            <div>
                <div class="section-title">🩸 Donors by Blood Type</div>
                <div class="blood-grid">
                    <div class="bcard"><div class="bg">A+</div><div class="bc">${countAPos}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">A-</div><div class="bc">${countANeg}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">B+</div><div class="bc">${countBPos}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">B-</div><div class="bc">${countBNeg}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">O+</div><div class="bc">${countOPos}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">O-</div><div class="bc">${countONeg}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">AB+</div><div class="bc">${countABPos}</div><div class="bl">donors</div></div>
                    <div class="bcard"><div class="bg">AB-</div><div class="bc">${countABNeg}</div><div class="bl">donors</div></div>
                </div>
            </div>
            <div>
                <div class="section-title">📋 Summary</div>
                <div class="panel">
                    <div class="panel-body">
                        <table>
                            <tbody>
                            <tr><td style="color:var(--text-muted);font-size:13px;">Total Users</td><td style="font-weight:800;text-align:right;">${totalUsers}</td></tr>
                            <tr><td style="color:var(--text-muted);font-size:13px;">Approved Users</td><td style="font-weight:800;text-align:right;color:var(--green);">${approvedUsers}</td></tr>
                            <tr><td style="color:var(--text-muted);font-size:13px;">Pending Approvals</td><td style="font-weight:800;text-align:right;color:var(--orange);">${pendingUsers}</td></tr>
                            <tr><td style="color:var(--text-muted);font-size:13px;">Total Donors</td><td style="font-weight:800;text-align:right;color:var(--red);">${totalDonors}</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- PENDING APPROVALS -->
        <div class="section-title">⏳ Pending Approvals</div>
        <%
            java.util.List pl = (java.util.List) request.getAttribute("pendingList");
            if (pl == null || pl.isEmpty()) {
        %>
        <div class="panel" style="margin-bottom:28px;">
            <div class="empty">🎉 No pending users! Everyone is approved.</div>
        </div>
        <%
        } else {
        %>
        <div class="table-wrap">
            <div class="table-header"><h3>⏳ Pending Users</h3></div>
            <table>
                <thead>
                <tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Blood Type</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <%
                    for (Object o : pl) {
                        com.lifeflow.lifeflow.model.User u = (com.lifeflow.lifeflow.model.User) o;
                %>
                <tr>
                    <td>#<%=u.getUserId()%></td>
                    <td><strong><%=u.getFullName()%></strong></td>
                    <td><%=u.getEmail()%></td>
                    <td><%=u.getPhone()%></td>
                    <td><span class="badge approved"><%=u.getBloodType()%></span></td>
                    <td><span class="badge pending">Pending</span></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/admin/approve?userId=<%=u.getUserId()%>" class="tbl-btn approve">✅ Approve</a>
                        &nbsp;
                        <a href="<%=request.getContextPath()%>/admin/editUser?userId=<%=u.getUserId()%>" class="tbl-btn edit">✏️ Edit</a>
                        &nbsp;
                        <a href="<%=request.getContextPath()%>/admin/reject?userId=<%=u.getUserId()%>" class="tbl-btn reject" onclick="return confirm('Reject this user?')">❌ Reject</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

        <!-- ALL USERS -->
        <div class="section-title">👥 All Users</div>
        <%
            java.util.List allUsers = (java.util.List) request.getAttribute("allUsers");
            if (allUsers == null || allUsers.isEmpty()) {
        %>
        <div class="panel" style="margin-bottom:28px;">
            <div class="empty">No users found.</div>
        </div>
        <%
        } else {
        %>
        <div class="table-wrap">
            <div class="table-header">
                <h3>👥 All Registered Users</h3>
                <a href="${pageContext.request.contextPath}/admin/manageUsers" class="action-btn primary" style="padding:8px 16px;font-size:12px;">View All</a>
            </div>
            <table>
                <thead>
                <tr><th>ID</th><th>Name</th><th>Email</th><th>Blood Type</th><th>Role</th><th>Status</th><th>Actions</th></tr>
                </thead>
                <tbody>
                <%
                    for (Object o : allUsers) {
                        com.lifeflow.lifeflow.model.User u = (com.lifeflow.lifeflow.model.User) o;
                        String status = "approved".equals(u.getIsApproved()) ? "approved" : "pending";
                %>
                <tr>
                    <td>#<%=u.getUserId()%></td>
                    <td><strong><%=u.getFullName()%></strong></td>
                    <td><%=u.getEmail()%></td>
                    <td><span class="badge approved"><%=u.getBloodType()%></span></td>
                    <td><%=u.getRole()%></td>
                    <td><span class="badge <%=status%>"><%=status%></span></td>
                    <td>
                        <a href="<%=request.getContextPath()%>/admin/viewUser?userId=<%=u.getUserId()%>" class="tbl-btn view">👁 View</a>
                        &nbsp;
                        <a href="<%=request.getContextPath()%>/admin/editUser?userId=<%=u.getUserId()%>" class="tbl-btn edit">✏️ Edit</a>
                        &nbsp;
                        <a href="<%=request.getContextPath()%>/admin/deleteUser?userId=<%=u.getUserId()%>" class="tbl-btn delete" onclick="return confirm('Delete this user?')">🗑 Delete</a>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

    </div>
</div>

<!-- CHARTS JS -->
<script>
    // DONUT CHART
    new Chart(document.getElementById('donutChart'), {
        type: 'doughnut',
        data: {
            labels: ['Approved', 'Pending', 'Donors'],
            datasets: [{
                data: [${approvedUsers}, ${pendingUsers}, ${totalDonors}],
                backgroundColor: ['#27ae60', '#e67e22', '#c0392b'],
                borderWidth: 0,
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'bottom', labels: { font: { family: 'Nunito', weight: '700', size: 11 }, padding: 10 } }
            },
            cutout: '68%'
        }
    });

    // BAR CHART
    new Chart(document.getElementById('bloodChart'), {
        type: 'bar',
        data: {
            labels: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
            datasets: [{
                label: 'Donors',
                data: [${countAPos}, ${countANeg}, ${countBPos}, ${countBNeg}, ${countOPos}, ${countONeg}, ${countABPos}, ${countABNeg}],
                backgroundColor: 'rgba(192,57,43,0.8)',
                borderRadius: 6,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f0f0' }, ticks: { font: { family: 'Nunito', size: 10 } } },
                x: { grid: { display: false }, ticks: { font: { family: 'Nunito', size: 10 } } }
            }
        }
    });

    // LINE CHART
    new Chart(document.getElementById('lineChart'), {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                label: 'New Users',
                data: [3, 5, 4, 8, 6, 10, 12, 9, 7, 11, 8, ${totalUsers}],
                borderColor: '#c0392b',
                backgroundColor: 'rgba(192,57,43,0.08)',
                borderWidth: 2,
                tension: 0.4,
                fill: true,
                pointBackgroundColor: '#c0392b',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f0f0f0' }, ticks: { font: { family: 'Nunito', size: 10 } } },
                x: { grid: { display: false }, ticks: { font: { family: 'Nunito', size: 10 } } }
            }
        }
    });
</script>

</body>
</html>