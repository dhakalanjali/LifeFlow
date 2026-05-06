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
    <title>LifeFlow — Blood Stock</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
    <style>
        :root {
            --crimson:   #B91C1C;
            --crimson-d: #7F1D1D;
            --crimson-l: #FEE2E2;
            --rose:      #F43F5E;
            --gold:      #F59E0B;
            --green:     #10B981;
            --slate:     #1E293B;
            --slate-m:   #334155;
            --muted:     #94A3B8;
            --surface:   #FFFFFF;
            --bg:        #F8FAFC;
            --border:    #E2E8F0;
            --shadow:    0 4px 24px rgba(0,0,0,0.06);
            --shadow-lg: 0 12px 40px rgba(185,28,28,0.12);
        }

        *, *::before, *::after { margin:0; padding:0; box-sizing:border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--slate);
            min-height: 100vh;
        }

        /* ── NAV ── */
        nav {
            background: #FFFFFF;
            padding: 0 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 64px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 0 var(--border);
        }

        .nav-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }
        .nav-brand .drop {
            width: 32px; height: 32px;
            background: var(--crimson);
            border-radius: 50% 50% 50% 0;
            transform: rotate(-45deg);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .nav-brand .drop::after {
            content:'';
            width:12px; height:12px;
            background: rgba(255,255,255,0.4);
            border-radius: 50%;
        }
        .nav-brand span {
            color: var(--slate);
            font-family: 'Playfair Display', serif;
            font-size: 20px;
            letter-spacing: 0.5px;
        }
        .nav-brand em { color: var(--rose); font-style: normal; }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .nav-links a {
            color: var(--muted);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            padding: 7px 14px;
            border-radius: 8px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .nav-links a:hover { color: var(--slate); background: var(--bg); }
        .nav-links a.active { color: white; background: var(--crimson); }
        .nav-links a.logout { color: #E57373; }
        .nav-links a.logout:hover { background: var(--crimson-l); color: var(--crimson); }

        /* ── HERO HEADER ── */
        .hero {
            background: linear-gradient(135deg, var(--crimson-d) 0%, var(--crimson) 60%, #DC2626 100%);
            padding: 48px 36px 52px;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute; inset: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
        }
        .hero-inner { max-width: 1060px; margin: 0 auto; position: relative; }
        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.2);
            color: #FCA5A5;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 5px 12px;
            border-radius: 20px;
            margin-bottom: 14px;
        }
        .hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: 36px;
            color: white;
            margin-bottom: 6px;
        }
        .hero p { color: rgba(255,255,255,0.65); font-size: 14px; }

        /* ── LAYOUT ── */
        .page {
            max-width: 1060px;
            margin: 0 auto;
            padding: 36px 36px 60px;
        }

        /* ── ALERTS ── */
        .alert {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 18px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 24px;
            animation: slideIn 0.3s ease;
        }
        .alert-success { background:#ECFDF5; color:#065F46; border:1px solid #6EE7B7; }
        .alert-error   { background:#FEF2F2; color:#991B1B; border:1px solid #FCA5A5; }
        .alert-icon { font-size: 18px; }
        @keyframes slideIn { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }

        /* ── STAT CARDS ── */
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: var(--shadow);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-lg); }
        .stat-icon {
            width: 52px; height: 52px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }
        .stat-icon.red   { background: var(--crimson-l); }
        .stat-icon.green { background: #D1FAE5; }
        .stat-icon.amber { background: #FEF3C7; }
        .stat-info .val {
            font-size: 32px;
            font-weight: 700;
            line-height: 1;
        }
        .stat-info .val.red   { color: var(--crimson); }
        .stat-info .val.green { color: var(--green); }
        .stat-info .val.amber { color: var(--gold); }
        .stat-info .lbl {
            font-size: 12px;
            color: var(--muted);
            margin-top: 4px;
            font-weight: 500;
        }

        /* ── PANEL ── */
        .panel {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
        }
        .panel-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .panel-title {
            font-size: 15px;
            font-weight: 600;
            color: var(--slate);
        }
        .panel-sub { font-size: 12px; color: var(--muted); margin-top: 2px; }

        /* ── TABLE ── */
        table { width: 100%; border-collapse: collapse; }
        thead th {
            background: #F8FAFC;
            color: var(--muted);
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            padding: 12px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border);
        }
        tbody td {
            padding: 14px 20px;
            border-bottom: 1px solid #F1F5F9;
            font-size: 13.5px;
            color: var(--slate-m);
            vertical-align: middle;
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr { transition: background 0.15s; }
        tbody tr:hover td { background: #FAFAFA; }

        /* Blood type badge */
        .blood-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 44px; height: 44px;
            border-radius: 50%;
            background: var(--crimson);
            color: white;
            font-weight: 700;
            font-size: 13px;
            letter-spacing: 0.3px;
            box-shadow: 0 3px 8px rgba(185,28,28,0.3);
        }

        /* Units display */
        .units-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .units-num {
            font-size: 20px;
            font-weight: 700;
        }
        .units-num.low    { color: var(--crimson); }
        .units-num.ok     { color: var(--green); }
        .units-label { font-size: 11px; color: var(--muted); }

        /* Progress bar */
        .bar-wrap {
            width: 100px;
            height: 5px;
            background: var(--border);
            border-radius: 99px;
            overflow: hidden;
        }
        .bar-fill {
            height: 100%;
            border-radius: 99px;
            transition: width 0.4s ease;
        }
        .bar-fill.low { background: var(--crimson); }
        .bar-fill.ok  { background: var(--green); }

        /* Status pill */
        .pill {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .pill.low  { background: var(--crimson-l); color: var(--crimson); }
        .pill.ok   { background: #D1FAE5; color: #065F46; }
        .pill-dot { width:6px; height:6px; border-radius:50%; background:currentColor; }

        /* Update form */
        .update-form {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .units-input {
            width: 76px;
            padding: 8px 10px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            text-align: center;
            color: var(--slate);
            transition: border-color 0.2s, box-shadow 0.2s;
            background: var(--bg);
        }
        .units-input:focus {
            outline: none;
            border-color: var(--crimson);
            box-shadow: 0 0 0 3px rgba(185,28,28,0.1);
            background: white;
        }
        .btn-update {
            padding: 8px 16px;
            background: var(--crimson);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            letter-spacing: 0.3px;
            transition: all 0.2s;
            white-space: nowrap;
        }
        .btn-update:hover {
            background: var(--crimson-d);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(185,28,28,0.3);
        }
        .btn-update:active { transform: translateY(0); }

        /* Back link */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-top: 24px;
            color: var(--muted);
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--slate); }
        .back-link svg { transition: transform 0.2s; }
        .back-link:hover svg { transform: translateX(-3px); }

        /* Responsive */
        @media(max-width: 768px) {
            nav { padding: 0 16px; }
            .hero { padding: 32px 16px 36px; }
            .hero h1 { font-size: 26px; }
            .page { padding: 24px 16px 48px; }
            .stats { grid-template-columns: 1fr; gap: 12px; }
            .nav-links a span { display: none; }
            .bar-wrap { display: none; }
            thead th:nth-child(3),
            tbody td:nth-child(3) { display: none; }
        }
    </style>
</head>
<body>

<!-- NAV -->
<nav>
    <a class="nav-brand" href="${pageContext.request.contextPath}/admin/dashboard">
        <div class="drop"></div>
        <span>Life<em>Flow</em></span>
    </a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin/dashboard">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></svg>
            <span>Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            <span>Users</span>
        </a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp" class="active">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C9 7 5 10.5 5 14a7 7 0 0 0 14 0c0-3.5-4-7-7-12z"/></svg>
            <span>Blood Stock</span>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="logout">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
            <span>Logout</span>
        </a>
    </div>
</nav>

<!-- HERO -->
<div class="hero">
    <div class="hero-inner">
        <div class="hero-tag">
            <svg width="10" height="10" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C9 7 5 10.5 5 14a7 7 0 0 0 14 0c0-3.5-4-7-7-12z"/></svg>
            Admin Panel
        </div>
        <h1>Blood Stock Management</h1>
        <p>Monitor inventory levels and update blood unit counts across all types.</p>
    </div>
</div>

<div class="page">

    <%-- Alerts --%>
    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success">
        <span class="alert-icon">✓</span>
        <span><%= request.getAttribute("success") %></span>
    </div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <span class="alert-icon">!</span>
        <span><%= request.getAttribute("error") %></span>
    </div>
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

    <!-- STATS -->
    <div class="stats">
        <div class="stat-card">
            <div class="stat-icon red">🩸</div>
            <div class="stat-info">
                <div class="val red"><%=totalUnits%></div>
                <div class="lbl">Total Units in Stock</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon green">✔</div>
            <div class="stat-info">
                <div class="val green"><%=availableCount%></div>
                <div class="lbl">Blood Types Available</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon amber">⚠</div>
            <div class="stat-info">
                <div class="val amber"><%=lowCount%></div>
                <div class="lbl">Low Stock Alerts</div>
            </div>
        </div>
    </div>

    <!-- TABLE PANEL -->
    <div class="panel">
        <div class="panel-header">
            <div>
                <div class="panel-title">Inventory Overview</div>
                <div class="panel-sub">Update units by entering a new value and clicking Save</div>
            </div>
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
                    <div class="units-wrap">
                        <div>
                            <div class="units-num <%=cls%>"><%=units%></div>
                            <div class="units-label">units</div>
                        </div>
                    </div>
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
                            <input type="number" name="units" class="units-input"
                                   value="<%= units %>" min="0" required/>
                            <button type="submit" class="btn-update">Save</button>
                        </div>
                    </form>
                </td>
            </tr>
            <%
                    }
                    rs.close(); ps.close();
                } catch(Exception e) {
                    out.println("<tr><td colspan='5' style='padding:20px;color:#999;text-align:center'>Unable to load blood stock data.</td></tr>");
                } finally {
                    DBConnection.closeConnection(conn);
                }
            %>
            </tbody>
        </table>
    </div>

    <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Back to Dashboard
    </a>

</div>
</body>
</html>
