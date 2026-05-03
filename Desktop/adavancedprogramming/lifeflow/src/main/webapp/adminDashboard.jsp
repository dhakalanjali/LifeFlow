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
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:Arial,sans-serif; background:#f4f6f9; }

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

        /* WRAP */
        .wrap { max-width:1200px; margin:30px auto; padding:0 20px; }

        /* WELCOME */
        .welcome {
            background:white;
            padding:20px 25px;
            border-radius:10px;
            margin-bottom:25px;
            box-shadow:0 2px 8px rgba(0,0,0,0.06);
            display:flex;
            justify-content:space-between;
            align-items:center;
        }
        .welcome h2 { font-size:22px; color:#2c3e50; }
        .welcome p { font-size:13px; color:#888; margin-top:4px; }

        /* MESSAGES */
        .msg-s {
            background:#d4edda; color:#155724;
            padding:12px 16px; border-radius:8px;
            margin-bottom:16px; border-left:4px solid #28a745;
            font-size:14px;
        }
        .msg-e {
            background:#f8d7da; color:#721c24;
            padding:12px 16px; border-radius:8px;
            margin-bottom:16px; border-left:4px solid #dc3545;
            font-size:14px;
        }

        /* STAT CARDS */
        .cards {
            display:flex; gap:20px;
            flex-wrap:wrap; margin-bottom:28px;
        }
        .card {
            flex:1; min-width:180px;
            background:white; border-radius:12px;
            padding:24px; text-align:center;
            box-shadow:0 2px 10px rgba(0,0,0,0.07);
            border-top:4px solid #c0392b;
            transition:transform 0.2s;
        }
        .card:hover { transform:translateY(-3px); }
        .card .num { font-size:42px; font-weight:bold; color:#c0392b; }
        .card .lbl { font-size:13px; color:#777; margin-top:6px; }
        .card .icon { font-size:24px; margin-bottom:8px; }

        /* SECTION TITLE */
        .section {
            font-size:17px; font-weight:bold;
            color:#2c3e50; margin:25px 0 14px;
            padding-bottom:8px;
            border-bottom:2px solid #eee;
            display:flex; align-items:center; gap:8px;
        }

        /* QUICK ACTIONS */
        .links { display:flex; gap:12px; flex-wrap:wrap; margin-bottom:28px; }
        .lbtn {
            display:inline-block; padding:12px 24px;
            background:#c0392b; color:white;
            border-radius:8px; text-decoration:none;
            font-size:13px; font-weight:bold;
            transition:background 0.2s, transform 0.2s;
            box-shadow:0 2px 6px rgba(192,57,43,0.3);
        }
        .lbtn:hover { background:#a93226; transform:translateY(-2px); }
        .lbtn-o {
            background:white; color:#c0392b;
            border:2px solid #c0392b;
            box-shadow:none;
        }
        .lbtn-o:hover { background:#fdf0ef; transform:translateY(-2px); }
        .lbtn-g {
            background:#27ae60;
            box-shadow:0 2px 6px rgba(39,174,96,0.3);
        }
        .lbtn-g:hover { background:#219150; }

        /* BLOOD TYPE CARDS */
        .blood { display:flex; flex-wrap:wrap; gap:12px; margin-bottom:28px; }
        .bcard {
            background:white; border-radius:10px;
            padding:16px 20px; text-align:center;
            box-shadow:0 2px 8px rgba(0,0,0,0.07);
            min-width:95px; transition:transform 0.2s;
            border-bottom:3px solid #c0392b;
        }
        .bcard:hover { transform:translateY(-3px); }
        .bcard .bg { font-size:20px; font-weight:bold; color:#c0392b; }
        .bcard .bc { font-size:26px; font-weight:bold; color:#2c3e50; margin:4px 0; }
        .bcard .bl { font-size:11px; color:#aaa; }

        /* TABLE */
        .table-wrap {
            background:white; border-radius:12px;
            overflow:hidden; box-shadow:0 2px 10px rgba(0,0,0,0.07);
            margin-bottom:20px;
        }
        table { width:100%; border-collapse:collapse; }
        th {
            background:#c0392b; color:white;
            padding:13px 16px; text-align:left; font-size:13px;
        }
        td { padding:12px 16px; font-size:13px; border-bottom:1px solid #f0f0f0; }
        tr:last-child td { border-bottom:none; }
        tr:hover td { background:#fdf8f8; }

        /* BUTTONS */
        .btn {
            display:inline-block; padding:6px 14px;
            border-radius:6px; color:white; font-size:12px;
            font-weight:bold; text-decoration:none; cursor:pointer;
            transition:opacity 0.2s;
        }
        .btn:hover { opacity:0.85; }
        .gr { background:#27ae60; }
        .rd { background:#c0392b; }

        /* EMPTY */
        .empty {
            text-align:center; padding:40px;
            color:#aaa; font-size:14px;
        }

        /* RESPONSIVE */
        @media(max-width:768px) {
            .cards, .blood { flex-direction:column; }
            nav { flex-direction:column; gap:12px; }
            .nav-links { display:flex; flex-wrap:wrap; gap:5px; }
            .nav-links a { margin-left:0; }
            .links { flex-direction:column; }
        }
    </style>
</head>
<body>

<nav>
    <h1>🩸 LifeFlow Admin</h1>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">🏠 Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">👥 Users</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp">🩸 Blood Stock</a>
        <a href="${pageContext.request.contextPath}/logout">🚪 Logout</a>
    </div>
</nav>

<div class="wrap">

    <!-- WELCOME -->
    <div class="welcome">
        <div>
            <h2>Welcome back, Admin 👋</h2>
            <p>Here's what's happening with LifeFlow today.</p>
        </div>
    </div>

    <!-- MESSAGES -->
    <%
        String sm = (String) session.getAttribute("successMessage");
        String em = (String) session.getAttribute("errorMessage");
        if (sm != null) { session.removeAttribute("successMessage"); %>
    <div class="msg-s">✅ <%=sm%></div>
    <% } if (em != null) { session.removeAttribute("errorMessage"); %>
    <div class="msg-e">❌ <%=em%></div>
    <% } %>

    <!-- STAT CARDS -->
    <div class="cards">
        <div class="card">
            <div class="icon">👥</div>
            <div class="num">${totalUsers}</div>
            <div class="lbl">Total Users</div>
        </div>
        <div class="card">
            <div class="icon">⏳</div>
            <div class="num">${pendingUsers}</div>
            <div class="lbl">Pending Approvals</div>
        </div>
        <div class="card">
            <div class="icon">✅</div>
            <div class="num">${approvedUsers}</div>
            <div class="lbl">Approved Users</div>
        </div>
        <div class="card">
            <div class="icon">🩸</div>
            <div class="num">${totalDonors}</div>
            <div class="lbl">Total Donors</div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="section">⚡ Quick Actions</div>
    <div class="links">
        <a href="${pageContext.request.contextPath}/admin/manageUsers" class="lbtn">👥 Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers" class="lbtn lbtn-o">⏳ Pending (${pendingUsers})</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp" class="lbtn lbtn-g">🩸 Manage Blood Stock</a>
    </div>

    <!-- BLOOD TYPE DONORS -->
    <div class="section">🩸 Donors by Blood Type</div>
    <div class="blood">
        <div class="bcard"><div class="bg">A+</div><div class="bc">${countAPos}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">A-</div><div class="bc">${countANeg}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">B+</div><div class="bc">${countBPos}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">B-</div><div class="bc">${countBNeg}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">O+</div><div class="bc">${countOPos}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">O-</div><div class="bc">${countONeg}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">AB+</div><div class="bc">${countABPos}</div><div class="bl">donors</div></div>
        <div class="bcard"><div class="bg">AB-</div><div class="bc">${countABNeg}</div><div class="bl">donors</div></div>
    </div>

    <!-- PENDING APPROVALS TABLE -->
    <div class="section">⏳ Pending Approvals</div>
    <%
        java.util.List pl = (java.util.List) request.getAttribute("pendingList");
        if (pl == null || pl.isEmpty()) {
    %>
    <div class="empty">🎉 No pending users! Everyone is approved.</div>
    <%
    } else {
    %>
    <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Blood Type</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                for (Object o : pl) {
                    com.lifeflow.lifeflow.model.User u =
                            (com.lifeflow.lifeflow.model.User) o;
            %>
            <tr>
                <td><%=u.getUserId()%></td>
                <td><%=u.getFullName()%></td>
                <td><%=u.getEmail()%></td>
                <td><%=u.getPhone()%></td>
                <td><%=u.getBloodType()%></td>
                <td>
                    <a href="<%=request.getContextPath()%>/admin/approve?userId=<%=u.getUserId()%>" class="btn gr">✅ Approve</a>
                    &nbsp;
                    <a href="<%=request.getContextPath()%>/admin/reject?userId=<%=u.getUserId()%>" class="btn rd" onclick="return confirm('Reject this user?')">❌ Reject</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

</div>
</body>
</html>