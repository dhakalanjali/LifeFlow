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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | LifeFlow Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #c0392b;
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
        .msg-s { background: #d4edda; color: #155724; padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #28a745; font-size: 13px; font-weight: 600; }
        .msg-e { background: #f8d7da; color: #721c24; padding: 12px 16px; border-radius: 10px; margin-bottom: 20px; border-left: 4px solid #dc3545; font-size: 13px; font-weight: 600; }

        /* ── TABLE ── */
        .table-wrap { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .table-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fdecea; }
        .table-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        table { width: 100%; border-collapse: collapse; }
        thead th { background: var(--red); color: white; padding: 12px 18px; text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; white-space: nowrap; }
        tbody td { padding: 13px 18px; font-size: 13px; border-bottom: 1px solid var(--border); font-weight: 600; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fdf8f8; }
        .empty { text-align: center; padding: 40px; color: var(--text-muted); font-size: 13px; font-weight: 600; }

        /* ── BADGES ── */
        .badge { display: inline-block; padding: 4px 10px; border-radius: 50px; font-size: 11px; font-weight: 700; }
        .badge.pending  { background: #fef9e7; color: #d68910; }
        .badge.approved { background: #eafaf1; color: #1e8449; }
        .badge.rejected { background: #fdecea; color: var(--red); }

        /* ── ACTION BUTTONS ── */
        .tbl-btn { display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; border-radius: 6px; color: white; font-size: 11px; font-weight: 700; font-family: 'Nunito', sans-serif; text-decoration: none; border: none; cursor: pointer; transition: opacity 0.2s; }
        .tbl-btn:hover { opacity: 0.85; }
        .tbl-btn.approve { background: var(--green); }
        .tbl-btn.reject  { background: var(--red); }
        .tbl-btn.view    { background: var(--blue); }
        .tbl-btn.edit    { background: var(--orange); }
        .tbl-btn.delete  { background: #95a5a6; }
        .done-label { color: #bbb; font-size: 12px; font-weight: 600; }

        /* Responsive */
        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
            thead th:nth-child(3), tbody td:nth-child(3),
            thead th:nth-child(4), tbody td:nth-child(4) { display: none; }
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
        <a href="${pageContext.request.contextPath}/admin/manageUsers" class="active">
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
        <a href="${pageContext.request.contextPath}/reports.jsp">
            <span class="icon">📊</span> Reports
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

    <header class="topbar">
        <div class="topbar-left">
            <h2>👥 Manage Users</h2>
            <span>Approve, reject and manage all registered users</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <%
            String sm = (String) session.getAttribute("successMessage");
            String em = (String) session.getAttribute("errorMessage");
            if(sm != null) { session.removeAttribute("successMessage"); %>
        <div class="msg-s">✅ <%=sm%></div>
        <% } if(em != null) { session.removeAttribute("errorMessage"); %>
        <div class="msg-e">❌ <%=em%></div>
        <% } %>

        <div class="section-title">👥 All Registered Users</div>

        <%
            java.util.List users = (java.util.List) request.getAttribute("users");
            if(users == null || users.isEmpty()) {
        %>
        <div class="table-wrap">
            <div class="empty">No users found.</div>
        </div>
        <% } else { %>
        <div class="table-wrap">
            <div class="table-header">
                <h3>👥 User List</h3>
            </div>
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Blood Type</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for(Object o : users) {
                        com.lifeflow.lifeflow.model.User u = (com.lifeflow.lifeflow.model.User) o;
                        String st = u.getIsApproved();
                        if(st == null) st = "pending";
                %>
                <tr>
                    <td>#<%=u.getUserId()%></td>
                    <td><strong><%=u.getFullName()%></strong></td>
                    <td><%=u.getEmail()%></td>
                    <td><%=u.getPhone()%></td>
                    <td><span class="badge approved"><%=u.getBloodType()%></span></td>
                    <td><%=u.getRole()%></td>
                    <td>
                        <% if("approved".equals(st)) { %>
                        <span class="badge approved">✅ Approved</span>
                        <% } else if("rejected".equals(st)) { %>
                        <span class="badge rejected">❌ Rejected</span>
                        <% } else { %>
                        <span class="badge pending">⏳ Pending</span>
                        <% } %>
                    </td>
                    <td>
                        <% if("pending".equals(st)) { %>
                        <a href="<%=request.getContextPath()%>/admin/approve?userId=<%=u.getUserId()%>" class="tbl-btn approve">✅ Approve</a>
                        &nbsp;
                        <a href="<%=request.getContextPath()%>/admin/reject?userId=<%=u.getUserId()%>" class="tbl-btn reject" onclick="return confirm('Reject this user?')">❌ Reject</a>
                        <% } else { %>
                        <span class="done-label">Done</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>

    </div>
</div>

</body>
</html>
