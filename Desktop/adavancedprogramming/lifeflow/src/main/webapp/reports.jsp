<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.lifeflow.lifeflow.dao.BloodRequestDAO" %>
<%@ page import="com.lifeflow.lifeflow.dao.BloodStockDAO" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodRequest" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodStock" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if(loggedUser == null || !loggedUser.getRole().equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // ── Load blood stock from DB ──
    BloodStockDAO stockDAO = new BloodStockDAO();
    List<BloodStock> stockList = stockDAO.getAllBloodStock();
    int totalUnits = 0;
    for (BloodStock bs : stockList) totalUnits += bs.getUnitsAvailable();

    // ── Load requests from DB ──
    BloodRequestDAO reqDAO = new BloodRequestDAO();
    List<BloodRequest> requests = new ArrayList<>();
    String loadError = null;
    int approvedCount = 0, pendingCount = 0, cancelledCount = 0;

    // ── Handle approve/reject action FIRST (before loading counts) ──
    String actionMsg = null;
    String actionType = request.getParameter("actionType");
    String actionIdStr = request.getParameter("actionId");
    if (actionType != null && actionIdStr != null) {
        try {
            int actionId = Integer.parseInt(actionIdStr.trim());
            // ✅ FIXED: use "approved" to match DB, not "fulfilled"
            String newStatus = actionType.equals("approve") ? "approved" : "cancelled";
            boolean updated = reqDAO.updateRequestStatus(actionId, newStatus);
            actionMsg = updated
                    ? "✅ Request #" + String.format("%03d", actionId) + " marked as " + newStatus + "."
                    : "⚠️ Could not update request.";
        } catch(Exception e) {
            actionMsg = "⚠️ Error: " + e.getMessage();
        }
    }

    // ── Load requests (after action so counts are fresh) ──
    try {
        requests = reqDAO.getAllRequests();
        for (BloodRequest br : requests) {
            if (br.getPatientName() == null || br.getPatientName().trim().isEmpty()) continue;
            String s = br.getStatus() != null ? br.getStatus().toLowerCase() : "";
            // ✅ FIXED: check "approved" not "fulfilled"
            if (s.equals("approved"))        approvedCount++;
            else if (s.equals("cancelled"))  cancelledCount++;
            else                             pendingCount++;
        }
    } catch(Exception e) {
        loadError = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | LifeFlow Admin</title>
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

        /* ── ACTION MESSAGE ── */
        .action-msg { padding: 12px 18px; border-radius: 10px; margin-bottom: 20px; font-size: 13px; font-weight: 700; background: #eafaf1; color: #1e8449; border-left: 5px solid var(--green); }
        .action-msg.error { background: #fdecea; color: var(--red); border-color: var(--red); }

        /* ── STAT CARDS ── */
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 18px; margin-bottom: 28px; }
        .stat-card { background: var(--white); border-radius: 14px; padding: 22px; box-shadow: var(--shadow); display: flex; align-items: center; gap: 16px; transition: transform 0.2s; border-top: 4px solid var(--red); }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .stat-icon.red    { background: #fdecea; }
        .stat-icon.green  { background: #eafaf1; }
        .stat-icon.orange { background: #fef9e7; }
        .stat-icon.blue   { background: #eaf4fb; }
        .stat-info .num { font-size: 30px; font-weight: 800; color: var(--red); line-height: 1; }
        .stat-info .num.green  { color: var(--green); }
        .stat-info .num.orange { color: var(--orange); }
        .stat-info .num.blue   { color: var(--blue); }
        .stat-info .lbl { font-size: 12px; color: var(--text-muted); margin-top: 4px; font-weight: 600; }

        /* ── BLOOD STOCK GRID ── */
        .blood-grid { display: grid; grid-template-columns: repeat(8, 1fr); gap: 10px; margin-bottom: 28px; }
        .bcard { background: white; border-radius: 12px; padding: 16px 8px; text-align: center; box-shadow: var(--shadow); border-bottom: 3px solid var(--red); transition: transform 0.2s; }
        .bcard:hover { transform: translateY(-3px); }
        .bcard .bg { font-size: 16px; font-weight: 800; color: var(--red); }
        .bcard .bc { font-size: 22px; font-weight: 800; color: var(--text); margin: 4px 0; }
        .bcard .bl { font-size: 10px; color: var(--text-muted); font-weight: 600; }
        .bcard .bar { height: 5px; background: #f0f0f0; border-radius: 3px; margin-top: 8px; overflow: hidden; }
        .bcard .bar-fill { height: 100%; border-radius: 3px; }
        .bar-high   { background: var(--green); }
        .bar-medium { background: var(--orange); }
        .bar-low    { background: var(--red); }

        /* ── SUMMARY ROW ── */
        .summary-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px; margin-bottom: 28px; }
        .summary-card { background: white; border-radius: 14px; padding: 20px 22px; box-shadow: var(--shadow); display: flex; align-items: center; gap: 14px; border-left: 5px solid; }
        .summary-card.approved  { border-color: var(--green); }
        .summary-card.pending   { border-color: var(--orange); }
        .summary-card.cancelled { border-color: var(--text-muted); }
        .summary-icon { font-size: 26px; }
        .summary-num { font-size: 26px; font-weight: 800; }
        .summary-card.approved  .summary-num { color: var(--green); }
        .summary-card.pending   .summary-num { color: var(--orange); }
        .summary-card.cancelled .summary-num { color: var(--text-muted); }
        .summary-lbl { font-size: 12px; color: var(--text-muted); font-weight: 600; margin-top: 2px; }

        /* ── TABLE ── */
        .table-wrap { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .table-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fdecea; }
        .table-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .filter-bar { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; padding: 14px 22px; border-bottom: 1px solid var(--border); background: #fafafa; }
        .filter-bar input, .filter-bar select { padding: 8px 12px; border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-family: 'Nunito', sans-serif; font-weight: 600; outline: none; transition: border 0.2s; }
        .filter-bar input { flex: 1; min-width: 180px; }
        .filter-bar input:focus, .filter-bar select:focus { border-color: var(--red); }
        .btn-reset { padding: 8px 16px; background: var(--red); color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; transition: background 0.2s; }
        .btn-reset:hover { background: var(--red-dark); }

        /* ── TABLE SCROLL ── */
        .table-scroll { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 1000px; }
        thead th { background: var(--red); color: white; padding: 12px 14px; text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; white-space: nowrap; }
        tbody td { padding: 12px 14px; font-size: 13px; border-bottom: 1px solid var(--border); font-weight: 600; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fdf8f8; }

        /* ── BADGES ── */
        .badge { display: inline-block; padding: 4px 10px; border-radius: 50px; font-size: 11px; font-weight: 700; }
        .badge.pending   { background: #fef9e7; color: #d68910; }
        /* ✅ approved uses green style */
        .badge.approved  { background: #eafaf1; color: #1e8449; }
        .badge.cancelled { background: #f2f3f4; color: #7f8c8d; }
        .badge.critical  { background: #fdecea; color: var(--red); }
        .badge.urgent    { background: #fef9e7; color: #d68910; }
        .badge.normal    { background: #eafaf1; color: #1e8449; }
        .badge.blood     { background: #fdecea; color: var(--red); border: 1px solid #f5b7b1; }

        /* ── CONTACT NUMBER ── */
        .contact-num { font-size: 12px; color: var(--blue); font-weight: 700; white-space: nowrap; }

        /* ── NOTES CELL ── */
        .notes-cell { max-width: 140px; font-size: 12px; color: var(--text-muted); font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .notes-cell.empty-note { font-style: italic; color: #bdc3c7; }

        /* ── ACTION BUTTONS ── */
        .action-btns { display: flex; gap: 6px; white-space: nowrap; }
        .btn-approve, .btn-reject { padding: 5px 12px; border: none; border-radius: 6px; font-size: 11px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-block; }
        .btn-approve { background: #eafaf1; color: #1e8449; border: 1.5px solid #a9dfbf; }
        .btn-approve:hover { background: var(--green); color: white; }
        .btn-reject  { background: #fdecea; color: var(--red); border: 1.5px solid #f5b7b1; }
        .btn-reject:hover  { background: var(--red); color: white; }
        .btn-disabled { padding: 5px 12px; border-radius: 6px; font-size: 11px; font-weight: 700; background: #f2f3f4; color: #bdc3c7; cursor: default; border: 1.5px solid #e5e8e8; }

        .empty { text-align: center; padding: 40px; color: var(--text-muted); font-size: 13px; font-weight: 600; }

        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
            .stat-grid { grid-template-columns: repeat(2, 1fr); }
            .blood-grid { grid-template-columns: repeat(4, 1fr); }
            .summary-grid { grid-template-columns: 1fr; }
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
        <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="icon">🏠</span> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers"><span class="icon">👥</span> Manage Users</a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp"><span class="icon">⛺</span> Manage Camps</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp"><span class="icon">🩸</span> Blood Stock</a>
        <a href="${pageContext.request.contextPath}/bloodRequest"><span class="icon">🔍</span> Search Blood</a>
        <a href="${pageContext.request.contextPath}/reports.jsp" class="active"><span class="icon">📊</span> Reports</a>
        <a href="${pageContext.request.contextPath}/about.jsp"><span class="icon">ℹ️</span> About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp"><span class="icon">📞</span> Contact</a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout"><span class="icon">🚪</span> Logout</a>
    </div>
</aside>

<!-- ── MAIN ── -->
<div class="main">

    <!-- TOPBAR -->
    <header class="topbar">
        <div class="topbar-left">
            <h2>📊 Reports</h2>
            <span>Blood bank activity, stock levels and request history</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <!-- ── ACTION FEEDBACK MESSAGE ── -->
        <% if (actionMsg != null) { %>
        <div class="action-msg <%= actionMsg.startsWith("⚠️") ? "error" : "" %>">
            <%= actionMsg %>
        </div>
        <% } %>

        <!-- ── STAT CARDS ── -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon red">🩸</div>
                <div class="stat-info">
                    <div class="num"><%= totalUnits %></div>
                    <div class="lbl">Total Blood Units</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">✅</div>
                <div class="stat-info">
                    <!-- ✅ FIXED: approvedCount instead of fulfilledCount -->
                    <div class="num green"><%= approvedCount %></div>
                    <div class="lbl">Requests Approved</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">⏳</div>
                <div class="stat-info">
                    <div class="num orange"><%= pendingCount %></div>
                    <div class="lbl">Pending Requests</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue">📋</div>
                <div class="stat-info">
                    <div class="num blue"><%= requests.size() %></div>
                    <div class="lbl">Total Requests</div>
                </div>
            </div>
        </div>

        <!-- ── BLOOD STOCK ── -->
        <div class="section-title">🩸 Current Blood Stock Levels</div>
        <div class="blood-grid">
            <%
                int maxUnits = 50;
                for (BloodStock bs : stockList) {
                    int units = bs.getUnitsAvailable();
                    int pct = Math.min((units * 100) / maxUnits, 100);
                    String barClass = pct >= 60 ? "bar-high" : (pct >= 30 ? "bar-medium" : "bar-low");
            %>
            <div class="bcard">
                <div class="bg"><%= bs.getBloodGroup() %></div>
                <div class="bc"><%= units %></div>
                <div class="bl">units</div>
                <div class="bar"><div class="bar-fill <%= barClass %>" style="width:<%= pct %>%"></div></div>
            </div>
            <% } %>
        </div>

        <!-- ── REQUEST SUMMARY ── -->
        <div class="section-title">📈 Request Summary</div>
        <div class="summary-grid">
            <!-- ✅ FIXED: class "approved" and approvedCount -->
            <div class="summary-card approved">
                <div class="summary-icon">✅</div>
                <div>
                    <div class="summary-num"><%= approvedCount %></div>
                    <div class="summary-lbl">Approved Requests</div>
                </div>
            </div>
            <div class="summary-card pending">
                <div class="summary-icon">⏳</div>
                <div>
                    <div class="summary-num"><%= pendingCount %></div>
                    <div class="summary-lbl">Pending Requests</div>
                </div>
            </div>
            <div class="summary-card cancelled">
                <div class="summary-icon">❌</div>
                <div>
                    <div class="summary-num"><%= cancelledCount %></div>
                    <div class="summary-lbl">Cancelled Requests</div>
                </div>
            </div>
        </div>

        <!-- ── REQUESTS TABLE ── -->
        <div class="section-title">📋 Blood Request Records</div>
        <div class="table-wrap">
            <div class="table-header">
                <h3>📋 All Requests</h3>
            </div>
            <div class="filter-bar">
                <input type="text" id="searchInput" placeholder="Search by patient, hospital, or contact..." oninput="filterTable()">
                <select id="filterBloodGroup" onchange="filterTable()">
                    <option value="">All Blood Groups</option>
                    <option value="A+">A+</option><option value="A-">A-</option>
                    <option value="B+">B+</option><option value="B-">B-</option>
                    <option value="AB+">AB+</option><option value="AB-">AB-</option>
                    <option value="O+">O+</option><option value="O-">O-</option>
                </select>
                <select id="filterUrgency" onchange="filterTable()">
                    <option value="">All Urgency</option>
                    <option value="critical">Critical</option>
                    <option value="urgent">Urgent</option>
                    <option value="normal">Normal</option>
                </select>
                <select id="filterStatus" onchange="filterTable()">
                    <option value="">All Statuses</option>
                    <option value="pending">Pending</option>
                    <!-- ✅ FIXED: "approved" instead of "fulfilled" -->
                    <option value="approved">Approved</option>
                    <option value="cancelled">Cancelled</option>
                </select>
                <button class="btn-reset" onclick="resetFilters()">Reset</button>
            </div>
            <div class="table-scroll">
                <table>
                    <thead>
                    <tr>
                        <th>Request ID</th>
                        <th>Patient Name</th>
                        <th>Blood Group</th>
                        <th>Hospital</th>
                        <th>Contact Number</th>
                        <th>Urgency</th>
                        <th>Notes</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody id="tableBody">
                    <%
                        if (loadError != null) {
                    %>
                    <tr><td colspan="10" class="empty">⚠️ Error loading requests: <%= loadError %></td></tr>
                    <%
                    } else if (requests.isEmpty()) {
                    %>
                    <tr><td colspan="10" class="empty">📭 No blood requests found.</td></tr>
                    <%
                    } else {
                        boolean anyVisible = false;
                        for (BloodRequest br : requests) {

                            if (br.getPatientName() == null || br.getPatientName().trim().isEmpty()) continue;
                            anyVisible = true;

                            // Urgency
                            String urgency = br.getUrgencyLevel();
                            if (urgency == null || urgency.trim().isEmpty()) urgency = "Normal";
                            String uClass;
                            if (urgency.equalsIgnoreCase("Critical"))    uClass = "critical";
                            else if (urgency.equalsIgnoreCase("Urgent")) uClass = "urgent";
                            else                                          uClass = "normal";

                            // ✅ FIXED: status badge class uses "approved" not "fulfilled"
                            String status = br.getStatus() != null ? br.getStatus() : "pending";
                            String sClass;
                            if (status.equalsIgnoreCase("approved"))       sClass = "approved";
                            else if (status.equalsIgnoreCase("cancelled")) sClass = "cancelled";
                            else                                            sClass = "pending";

                            // Contact number
                            String contact = br.getContactNumber();
                            if (contact == null || contact.trim().isEmpty()) contact = "—";

                            // Notes
                            String notes = br.getAdditionalNotes();
                            boolean hasNotes = (notes != null && !notes.trim().isEmpty());

                            // ✅ FIXED: isPending checks "pending" (matches DB lowercase)
                            boolean isPending = status.equalsIgnoreCase("pending");
                    %>
                    <tr>
                        <td>#REQ-<%= String.format("%03d", br.getRequestId()) %></td>
                        <td><strong><%= br.getPatientName() %></strong></td>
                        <td><span class="badge blood"><%= br.getBloodGroup() %></span></td>
                        <td><%= br.getHospitalName() %></td>
                        <td><span class="contact-num"><%= contact %></span></td>
                        <td><span class="badge <%= uClass %>"><%= urgency %></span></td>
                        <td>
                            <% if (hasNotes) { %>
                            <span class="notes-cell" title="<%= notes %>"><%= notes %></span>
                            <% } else { %>
                            <span class="notes-cell empty-note">No notes</span>
                            <% } %>
                        </td>
                        <td><%= br.getRequestDate() %></td>
                        <!-- ✅ FIXED: displays actual status from DB (approved/pending/cancelled) -->
                        <td><span class="badge <%= sClass %>"><%= status %></span></td>
                        <td>
                            <% if (isPending) { %>
                            <div class="action-btns">
                                <a href="?actionType=approve&actionId=<%= br.getRequestId() %>"
                                   class="btn-approve"
                                   onclick="return confirm('Approve this request?')">✅ Approve</a>
                                <a href="?actionType=reject&actionId=<%= br.getRequestId() %>"
                                   class="btn-reject"
                                   onclick="return confirm('Reject this request?')">❌ Reject</a>
                            </div>
                            <% } else { %>
                            <span class="btn-disabled">— Done —</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                        if (!anyVisible) {
                    %>
                    <tr><td colspan="10" class="empty">📭 No valid blood requests found.</td></tr>
                    <%  } %>
                    <%  } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div><!-- /content -->
</div><!-- /main -->

<script>
    function filterTable() {
        const search    = document.getElementById('searchInput').value.toLowerCase();
        const bloodGrp  = document.getElementById('filterBloodGroup').value.toLowerCase();
        const urgency   = document.getElementById('filterUrgency').value.toLowerCase();
        const status    = document.getElementById('filterStatus').value.toLowerCase();

        document.querySelectorAll('#tableBody tr').forEach(row => {
            const text = row.innerText.toLowerCase();
            const matchSearch  = text.includes(search);
            const matchBlood   = bloodGrp === '' || text.includes(bloodGrp);
            const matchUrgency = urgency  === '' || text.includes(urgency);
            const matchStatus  = status   === '' || text.includes(status);
            row.style.display  = (matchSearch && matchBlood && matchUrgency && matchStatus) ? '' : 'none';
        });
    }

    function resetFilters() {
        document.getElementById('searchInput').value      = '';
        document.getElementById('filterBloodGroup').value = '';
        document.getElementById('filterUrgency').value    = '';
        document.getElementById('filterStatus').value     = '';
        filterTable();
    }
</script>
</body>
</html>