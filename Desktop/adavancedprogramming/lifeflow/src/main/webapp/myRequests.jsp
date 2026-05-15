<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodRequest" %>
<%@ page import="com.lifeflow.lifeflow.dao.BloodRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");

    BloodRequestDAO dao = new BloodRequestDAO();
    List<BloodRequest> allRequests = dao.getAllRequests();
    List<BloodRequest> myRequests = new ArrayList<>();
    for (BloodRequest r : allRequests) {
        if (r.getUserId() == currentUser.getUserId()) {
            myRequests.add(r);
        }
    }

    int pending = 0, approved = 0, rejected = 0;
    for (BloodRequest r : myRequests) {
        String s = r.getStatus() != null ? r.getStatus().toLowerCase() : "";
        if (s.equals("pending"))        pending++;
        else if (s.equals("approved"))  approved++;
        else if (s.equals("rejected"))  rejected++;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Requests - LifeFlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --red: #C0392B; --red-dark: #96281B; --red-light: #fde8e8;
            --red-border: #f5b7b1; --bg: #f4f4f0; --card: #ffffff;
            --text: #1a1a1a; --muted: #6b7280; --border: rgba(0,0,0,0.08);
            --radius: 14px; --radius-sm: 8px;
        }
        body { font-family: 'Plus Jakarta Sans', Arial, sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        .navbar { background: var(--red); padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 12px rgba(192,57,43,0.25); }
        .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar-links { display: flex; align-items: center; gap: 2px; }
        .navbar-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; }
        .navbar-links a:hover, .navbar-links a.active { background: rgba(255,255,255,0.15); color: #fff; }
        .btn-logout { background: rgba(255,255,255,0.15) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.35); margin-left: 8px; font-weight: 500; border-radius: var(--radius-sm); }

        .container { width: 100%; padding: 1.5rem 2.5rem; }

        .page-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1.25rem; }
        .page-title { font-size: 20px; font-weight: 600; display: flex; align-items: center; gap: 8px; }
        .page-title::before { content: ''; display: block; width: 4px; height: 22px; background: var(--red); border-radius: 2px; }
        .btn { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; border: none; transition: all 0.15s; font-family: inherit; }
        .btn-red { background: var(--red); color: #fff; }
        .btn-red:hover { background: var(--red-dark); }

        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 1.25rem; }
        .stat-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.25rem; position: relative; overflow: hidden; }
        .stat-num { font-size: 28px; font-weight: 600; color: var(--red); }
        .stat-desc { font-size: 12px; color: var(--muted); margin-top: 4px; }

        .table-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #fafafa; }
        thead th { padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 0.5px solid var(--border); }
        tbody tr { border-bottom: 0.5px solid var(--border); transition: background 0.1s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fafafa; }
        tbody td { padding: 14px 16px; font-size: 13px; color: var(--text); }

        .badge { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
        .badge-pending  { background: #fff8e1; color: #f57f17; border: 0.5px solid #ffe082; }
        .badge-approved { background: #e8f5e9; color: #2e7d32; border: 0.5px solid #a5d6a7; }
        .badge-rejected { background: var(--red-light); color: var(--red-dark); border: 0.5px solid var(--red-border); }

        .urgency-critical { color: var(--red); font-weight: 600; }
        .urgency-high     { color: #e67e22; font-weight: 600; }
        .urgency-normal   { color: var(--muted); }

        .empty-state { text-align: center; padding: 4rem 2rem; }
        .empty-icon { font-size: 48px; margin-bottom: 1rem; opacity: 0.4; }
        .empty-state h3 { font-size: 16px; font-weight: 600; margin-bottom: 8px; }
        .empty-state p { font-size: 13px; color: var(--muted); margin-bottom: 1.5rem; }

        @media (max-width: 768px) {
            .navbar { padding: 0 1rem; }
            .navbar-links { display: none; }
            .container { padding: 1rem; }
            .stats-row { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/myRequests.jsp" class="active">My Requests</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="page-header">
        <div class="page-title">My Blood Requests</div>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="btn btn-red">&#43; New Request</a>
    </div>

    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-num"><%= myRequests.size() %></div>
            <div class="stat-desc">Total Requests</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#f57f17"><%= pending %></div>
            <div class="stat-desc">Pending</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#2e7d32"><%= approved %></div>
            <div class="stat-desc">Approved</div>
        </div>
        <div class="stat-card">
            <div class="stat-num" style="color:#c0392b"><%= rejected %></div>
            <div class="stat-desc">Rejected</div>
        </div>
    </div>

    <div class="table-card">
        <% if (myRequests.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon">&#128203;</div>
            <h3>No requests yet</h3>
            <p>You haven't made any blood requests yet.</p>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="btn btn-red">&#43; Make a Request</a>
        </div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Patient Name</th>
                <th>Blood Type</th>
                <th>Hospital</th>
                <th>Contact</th>
                <th>Urgency</th>
                <th>Date</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <% for (BloodRequest r : myRequests) {
                String status = r.getStatus() != null ? r.getStatus().toLowerCase() : "pending";
                String badgeClass = "badge-pending";
                if (status.equals("approved"))  badgeClass = "badge-approved";
                else if (status.equals("rejected")) badgeClass = "badge-rejected";

                String urgency = r.getUrgencyLevel() != null ? r.getUrgencyLevel() : "Normal";
                String urgencyClass = urgency.equalsIgnoreCase("critical") ? "urgency-critical" :
                        urgency.equalsIgnoreCase("high") ? "urgency-high" : "urgency-normal";
            %>
            <tr>
                <td><%= r.getRequestId() %></td>
                <td><%= r.getPatientName() != null ? r.getPatientName() : "-" %></td>
                <td><strong style="color:var(--red)"><%= r.getBloodGroup() != null ? r.getBloodGroup() : "-" %></strong></td>
                <td><%= r.getHospitalName() != null ? r.getHospitalName() : "-" %></td>
                <td><%= r.getContactNumber() != null ? r.getContactNumber() : "-" %></td>
                <td><span class="<%= urgencyClass %>"><%= urgency %></span></td>
                <td><%= r.getRequestDate() != null ? r.getRequestDate().toString() : "-" %></td>
                <td><span class="badge <%= badgeClass %>"><%= status.substring(0,1).toUpperCase() + status.substring(1) %></span></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>
</body>
</html>