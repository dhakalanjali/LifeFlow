<%@ page contentType="text/html;charset=UTF-8" %>
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
    <title>Manage Users</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:Arial,sans-serif;background:#f4f6f9}
        nav{background:#c0392b;padding:15px 30px;
            display:flex;justify-content:space-between;
            align-items:center}
        nav h1{color:white;font-size:20px}
        nav a{color:white;text-decoration:none;
            margin-left:20px;font-size:14px}
        .wrap{max-width:1100px;margin:30px auto;padding:0 20px}
        h2{font-size:22px;color:#2c3e50;margin-bottom:20px}
        table{width:100%;border-collapse:collapse;
            background:white;border-radius:10px;
            overflow:hidden;
            box-shadow:0 2px 8px rgba(0,0,0,0.08);
            margin-bottom:24px}
        th{background:#c0392b;color:white;
            padding:12px 16px;text-align:left;font-size:13px}
        td{padding:11px 16px;font-size:13px;
            border-bottom:1px solid #f0f0f0}
        tr:hover{background:#fdf8f8}
        .badge{display:inline-block;padding:3px 10px;
            border-radius:20px;font-size:11px;
            font-weight:bold}
        .bp{background:#fff3cd;color:#856404}
        .ba{background:#d4edda;color:#155724}
        .br{background:#f8d7da;color:#721c24}
        .btn{display:inline-block;padding:5px 12px;
            border-radius:5px;color:white;font-size:11px;
            font-weight:bold;text-decoration:none}
        .gr{background:#27ae60}.rd{background:#c0392b}
        .back{display:inline-block;padding:10px 20px;
            background:#6c757d;color:white;
            border-radius:6px;text-decoration:none;
            font-size:13px}
        .msg-s{background:#d4edda;color:#155724;padding:12px;
            border-radius:6px;margin-bottom:14px;
            border-left:4px solid #28a745}
        .msg-e{background:#f8d7da;color:#721c24;padding:12px;
            border-radius:6px;margin-bottom:14px;
            border-left:4px solid #dc3545}
        .empty{text-align:center;padding:30px;color:#aaa}
        @media(max-width:700px){
            th,td{padding:8px 10px;font-size:12px}
            nav{flex-direction:column;gap:10px}}
    </style>
</head>
<body>
<nav>
    <h1>🩸 LifeFlow Admin</h1>
    <div>
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">Manage Users</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</nav>
<div class="wrap">
    <h2>👥 Manage Users</h2>

    <%
        String sm = (String) session.getAttribute("successMessage");
        String em = (String) session.getAttribute("errorMessage");
        if(sm != null) { session.removeAttribute("successMessage"); %>
    <div class="msg-s">✅ <%=sm%></div>
    <% } if(em != null) { session.removeAttribute("errorMessage"); %>
    <div class="msg-e">❌ <%=em%></div>
    <% } %>

    <%
        java.util.List users = (java.util.List) request.getAttribute("users");
        if(users == null || users.isEmpty()) {
    %>
    <div class="empty">No users found.</div>
    <% } else { %>
    <table>
        <thead>
        <tr>
            <th>ID</th><th>Name</th><th>Email</th>
            <th>Phone</th><th>Blood Type</th>
            <th>Role</th><th>Status</th><th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            for(Object o : users) {
                com.lifeflow.lifeflow.model.User u =
                        (com.lifeflow.lifeflow.model.User) o;
                String st = u.getIsApproved();
                if(st == null) st = "pending";
        %>
        <tr>
            <td><%=u.getUserId()%></td>
            <td><%=u.getFullName()%></td>
            <td><%=u.getEmail()%></td>
            <td><%=u.getPhone()%></td>
            <td><%=u.getBloodType()%></td>
            <td><%=u.getRole()%></td>
            <td>
                <% if("approved".equals(st)) { %>
                <span class="badge ba">✅ Approved</span>
                <% } else if("rejected".equals(st)) { %>
                <span class="badge br">❌ Rejected</span>
                <% } else { %>
                <span class="badge bp">⏳ Pending</span>
                <% } %>
            </td>
            <td>
                <% if("pending".equals(st)) { %>
                <a href="<%=request.getContextPath()%>/admin/approve?userId=<%=u.getUserId()%>" class="btn gr">✅ Approve</a>
                &nbsp;
                <a href="<%=request.getContextPath()%>/admin/reject?userId=<%=u.getUserId()%>" class="btn rd" onclick="return confirm('Reject?')">❌ Reject</a>
                <% } else { %>
                <span style="color:#aaa;font-size:12px">Done</span>
                <% } %>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back">← Back to Dashboard</a>
</div>
</body>
</html>