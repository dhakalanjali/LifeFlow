<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodStock" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodRequest" %>
<%@ page import="com.lifeflow.lifeflow.service.BloodService" %>
<%@ page import="com.lifeflow.lifeflow.dao.BloodRequestDAO" %>
<%@ page import="com.lifeflow.lifeflow.dao.DonorDAO" %>
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
    String userBloodType = (String) session.getAttribute("userBloodType");

    BloodService bloodService = new BloodService();
    List<BloodStock> stockList = bloodService.getAllBloodStock();

    // My requests
    BloodRequestDAO reqDAO = new BloodRequestDAO();
    List<BloodRequest> allReqs = reqDAO.getAllRequests();
    List<BloodRequest> myReqs = new ArrayList<>();
    for (BloodRequest r : allReqs) {
        if (r.getUserId() == currentUser.getUserId()) myReqs.add(r);
    }
    int myPending = 0, myApproved = 0, myRejected = 0;
    for (BloodRequest r : myReqs) {
        String s = r.getStatus() != null ? r.getStatus().toLowerCase() : "";
        if (s.equals("pending")) myPending++;
        else if (s.equals("approved")) myApproved++;
        else if (s.equals("rejected")) myRejected++;
    }

    // Donor status
    DonorDAO donorDAO = new DonorDAO();
    com.lifeflow.lifeflow.model.Donor myDonor = donorDAO.getDonorByUserId(currentUser.getUserId());
    boolean isDonor = myDonor != null;

    // Avatar initials
    String initials = "U";
    if (userName != null && !userName.trim().isEmpty()) {
        String[] parts = userName.trim().split("\\s+");
        initials = "";
        for (String p : parts) {
            if (!p.isEmpty()) initials += p.charAt(0);
        }
        initials = initials.toUpperCase();
        if (initials.length() > 2) initials = initials.substring(0, 2);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - LifeFlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --red: #C0392B; --red-dark: #96281B; --red-light: #fde8e8;
            --red-border: #f5b7b1; --bg: #f4f4f0; --card: #ffffff;
            --text: #1a1a1a; --muted: #6b7280; --border: rgba(0,0,0,0.08);
            --radius: 14px; --radius-sm: 8px;
        }
        html, body { width: 100%; min-height: 100vh; font-family: 'Plus Jakarta Sans', Arial, sans-serif; background: var(--bg); color: var(--text); }

        /* NAVBAR */
        .navbar { background: var(--red); padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 12px rgba(192,57,43,0.25); }
        .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar-links { display: flex; align-items: center; gap: 2px; }
        .navbar-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; }
        .navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
        .btn-logout { background: rgba(255,255,255,0.15) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.35); margin-left: 8px; font-weight: 500; border-radius: var(--radius-sm); }

        .container { width: 100%; padding: 1.5rem 2.5rem; }

        /* WELCOME CARD */
        .welcome-box { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.4rem 1.75rem; margin-bottom: 1.25rem; display: flex; align-items: center; justify-content: space-between; gap: 1rem; }
        .welcome-left { display: flex; align-items: center; gap: 1rem; }
        .avatar { width: 54px; height: 54px; border-radius: 50%; background: var(--red-light); border: 2px solid var(--red-border); display: flex; align-items: center; justify-content: center; font-size: 18px; font-weight: 600; color: var(--red); flex-shrink: 0; }
        .welcome-info h2 { font-size: 17px; font-weight: 600; }
        .welcome-info p  { font-size: 13px; color: var(--muted); margin-top: 3px; }
        .blood-badge { display: inline-flex; align-items: center; gap: 4px; background: var(--red-light); color: var(--red-dark); font-size: 11px; font-weight: 500; padding: 3px 10px; border-radius: 20px; border: 0.5px solid var(--red-border); margin-top: 6px; }
        .welcome-btns { display: flex; gap: 8px; flex-shrink: 0; }
        .btn { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 500; cursor: pointer; text-decoration: none; border: none; transition: all 0.15s; font-family: inherit; }
        .btn-red { background: var(--red); color: #fff; }
        .btn-red:hover { background: var(--red-dark); }
        .btn-outline { background: transparent; color: var(--red); border: 1px solid var(--red); }
        .btn-outline:hover { background: var(--red-light); }

        /* QUICK ACTIONS */
        .quick-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 10px; margin-bottom: 1.25rem; }
        .quick-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.25rem 1rem; display: flex; flex-direction: column; align-items: center; gap: 9px; text-decoration: none; color: inherit; transition: border-color 0.15s, transform 0.15s, box-shadow 0.15s; }
        .quick-card:hover { border-color: var(--red); transform: translateY(-2px); box-shadow: 0 4px 16px rgba(192,57,43,0.1); }
        .quick-icon { width: 46px; height: 46px; border-radius: 12px; background: var(--red-light); display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .quick-label { font-size: 12px; color: var(--muted); text-align: center; font-weight: 500; }

        /* SECTION TITLE */
        .section-title { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 0.85rem; display: flex; align-items: center; gap: 8px; }
        .section-title::before { content: ''; display: block; width: 3px; height: 16px; background: var(--red); border-radius: 2px; }

        /* ANALYTICS ROW */
        .analytics-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; margin-bottom: 1.25rem; }
        .analytics-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.25rem 1.5rem; display: flex; align-items: center; gap: 1rem; }
        .analytics-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
        .icon-red    { background: var(--red-light); }
        .icon-green  { background: #e8f5e9; }
        .icon-orange { background: #fff8e1; }
        .analytics-info .num { font-size: 28px; font-weight: 600; color: var(--red); line-height: 1; }
        .analytics-info .lbl { font-size: 12px; color: var(--muted); margin-top: 4px; }

        /* BLOOD GRID */
        .blood-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 1.25rem; }
        .blood-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1rem; display: flex; flex-direction: column; align-items: center; gap: 3px; transition: border-color 0.15s, transform 0.15s; }
        .blood-card:hover { transform: translateY(-2px); border-color: var(--red-border); }
        .blood-card.low  { border-color: #f39c12; background: #fffbf0; }
        .blood-card.out  { border-color: var(--red-border); background: var(--red-light); }
        .blood-type      { font-size: 20px; font-weight: 600; color: var(--red); }
        .blood-type.empty { color: #bdc3c7; }
        .blood-units     { font-size: 22px; font-weight: 600; color: var(--text); }
        .blood-units.empty { color: var(--muted); }
        .blood-sub       { font-size: 10px; color: var(--muted); }
        .tag-out  { font-size: 10px; color: var(--red); font-weight: 600; margin-top: 2px; }
        .tag-low  { font-size: 10px; color: #d35400; font-weight: 600; margin-top: 2px; }
        .blood-bar { width: 100%; height: 4px; background: #efefef; border-radius: 4px; margin-top: 7px; overflow: hidden; }
        .blood-fill { height: 100%; border-radius: 4px; background: var(--red); }
        .blood-fill.low-fill   { background: #f39c12; }
        .blood-fill.empty-fill { background: #ddd; width: 0 !important; }

        /* BOTTOM ROW */
        .bottom-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .chart-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.25rem; }
        .chart-card h4 { font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 1rem; }
        .chart-wrap { position: relative; height: 200px; }

        /* DONOR STATUS CARD */
        .donor-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.25rem; }
        .donor-card h4 { font-size: 13px; font-weight: 600; color: var(--text); margin-bottom: 1rem; }
        .donor-status { padding: 12px; border-radius: var(--radius-sm); text-align: center; font-size: 13px; font-weight: 500; margin-bottom: 12px; }
        .status-yes { background: #e8f5e9; color: #2e7d32; border: 0.5px solid #a5d6a7; }
        .status-no  { background: var(--red-light); color: var(--red-dark); border: 0.5px solid var(--red-border); }
        .status-new { background: #e3f2fd; color: #1565c0; border: 0.5px solid #90caf9; }
        .req-row { display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 0.5px solid var(--border); font-size: 13px; }
        .req-row:last-child { border-bottom: none; }
        .badge-sm { padding: 3px 8px; border-radius: 12px; font-size: 11px; font-weight: 600; }
        .badge-pending  { background: #fff8e1; color: #f57f17; }
        .badge-approved { background: #e8f5e9; color: #2e7d32; }
        .badge-rejected { background: var(--red-light); color: var(--red-dark); }

        @media (max-width: 768px) {
            .navbar { padding: 0 1rem; }
            .navbar-links { display: none; }
            .container { padding: 1rem; }
            .welcome-box { flex-direction: column; align-items: flex-start; }
            .welcome-btns { flex-wrap: wrap; }
            .quick-grid  { grid-template-columns: repeat(3, 1fr); }
            .blood-grid  { grid-template-columns: repeat(2, 1fr); }
            .analytics-row { grid-template-columns: 1fr; }
            .bottom-row  { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">&#10084; LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">

    <!-- WELCOME -->
    <div class="welcome-box">
        <div class="welcome-left">
            <div class="avatar"><%= initials %></div>
            <div class="welcome-info">
                <h2>Welcome, <%= userName != null ? userName : "Donor" %>! &#128075;</h2>
                <p>Thank you for being a life-saver.</p>
                <span class="blood-badge">&#9679; Blood type: <strong><%= userBloodType != null ? userBloodType : "N/A" %></strong></span>
            </div>
        </div>
        <div class="welcome-btns">
            <a href="${pageContext.request.contextPath}/profile.jsp" class="btn btn-outline">&#128100; My Profile</a>
            <a href="${pageContext.request.contextPath}/donationHistory.jsp" class="btn btn-outline">&#128203; History</a>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="btn btn-red">&#128137; Request Blood</a>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <div class="quick-grid">
        <a href="${pageContext.request.contextPath}/donateBlood.jsp" class="quick-card">
            <div class="quick-icon">&#128137;</div>
            <span class="quick-label">Donate Blood</span>
        </a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp" class="quick-card">
            <div class="quick-icon">&#128269;</div>
            <span class="quick-label">Search Blood</span>
        </a>
        <a href="${pageContext.request.contextPath}/myRequests.jsp" class="quick-card">
            <div class="quick-icon">&#128203;</div>
            <span class="quick-label">My Requests</span>
        </a>
        <a href="${pageContext.request.contextPath}/donationCamp.jsp" class="quick-card">
            <div class="quick-icon">&#127371;</div>
            <span class="quick-label">Donation Camps</span>
        </a>
        <a href="${pageContext.request.contextPath}/wishlist.jsp" class="quick-card">
            <div class="quick-icon">&#11088;</div>
            <span class="quick-label">My Wishlist</span>
        </a>
    </div>

    <!-- ANALYTICS -->
    <div class="section-title">My Activity</div>
    <div class="analytics-row">
        <div class="analytics-card">
            <div class="analytics-icon icon-red">&#128203;</div>
            <div class="analytics-info">
                <div class="num"><%= myReqs.size() %></div>
                <div class="lbl">Total Requests</div>
            </div>
        </div>
        <div class="analytics-card">
            <div class="analytics-icon icon-green">&#10004;</div>
            <div class="analytics-info">
                <div class="num" style="color:#2e7d32"><%= myApproved %></div>
                <div class="lbl">Approved Requests</div>
            </div>
        </div>
        <div class="analytics-card">
            <div class="analytics-icon icon-orange">&#128137;</div>
            <div class="analytics-info">
                <div class="num" style="color:<%= isDonor && "yes".equals(myDonor.getIsEligible()) ? "#2e7d32" : "#c0392b" %>">
                    <%= isDonor ? ("yes".equals(myDonor.getIsEligible()) ? "Eligible" : "Not Eligible") : "Not Registered" %>
                </div>
                <div class="lbl">Donor Status</div>
            </div>
        </div>
    </div>

    <!-- BLOOD AVAILABILITY -->
    <div class="section-title">Current Blood Availability</div>
    <div class="blood-grid">
        <%
            if (stockList != null && !stockList.isEmpty()) {
                for (BloodStock bs : stockList) {
                    int units = bs.getUnitsAvailable();
                    boolean isOut = units == 0;
                    boolean isLow = !isOut && units < 5;
                    String cardClass = isOut ? "out" : isLow ? "low" : "";
                    int pct = Math.min(100, (int)((units / 40.0) * 100));
        %>
        <div class="blood-card <%= cardClass %>">
            <div class="blood-type <%= isOut ? "empty" : "" %>"><%= bs.getBloodGroup() %></div>
            <div class="blood-units <%= isOut ? "empty" : "" %>"><%= units %></div>
            <% if (isOut) { %><div class="tag-out">Not Available</div>
            <% } else if (isLow) { %><div class="blood-sub">unit<%= units != 1 ? "s" : "" %> available</div><div class="tag-low">Low Stock</div>
            <% } else { %><div class="blood-sub">unit<%= units != 1 ? "s" : "" %> available</div><% } %>
            <div class="blood-bar">
                <div class="blood-fill <%= isOut ? "empty-fill" : isLow ? "low-fill" : "" %>" style="width:<%= pct %>%"></div>
            </div>
        </div>
        <% } } %>
    </div>

    <!-- BOTTOM ROW: Chart + My Requests Summary -->
    <div class="bottom-row">
        <div class="chart-card">
            <h4>&#128137; Blood Availability Overview</h4>
            <div class="chart-wrap">
                <canvas id="bloodChart"></canvas>
            </div>
        </div>

        <div class="donor-card">
            <h4>&#128203; My Requests Summary</h4>
            <% if (myReqs.isEmpty()) { %>
            <div class="donor-status status-new">No requests yet — make your first request!</div>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="btn btn-red" style="width:100%;justify-content:center;">&#43; New Request</a>
            <% } else { %>
            <div class="req-row"><span>Total Requests</span><span class="badge-sm" style="background:#f0f0f0;color:#333"><%= myReqs.size() %></span></div>
            <div class="req-row"><span>Pending</span><span class="badge-sm badge-pending"><%= myPending %></span></div>
            <div class="req-row"><span>Approved</span><span class="badge-sm badge-approved"><%= myApproved %></span></div>
            <div class="req-row"><span>Rejected</span><span class="badge-sm badge-rejected"><%= myRejected %></span></div>
            <div style="margin-top:1rem">
                <a href="${pageContext.request.contextPath}/myRequests.jsp" class="btn btn-outline" style="width:100%;justify-content:center;">View All Requests</a>
            </div>
            <% } %>
        </div>
    </div>

</div>

<script>
    <%
        StringBuilder labels = new StringBuilder();
        StringBuilder dataVals = new StringBuilder();
        StringBuilder colors = new StringBuilder();
        if (stockList != null) {
            for (int i = 0; i < stockList.size(); i++) {
                BloodStock bs = stockList.get(i);
                if (i > 0) { labels.append(","); dataVals.append(","); colors.append(","); }
                labels.append("'").append(bs.getBloodGroup()).append("'");
                dataVals.append(bs.getUnitsAvailable());
                int u = bs.getUnitsAvailable();
                colors.append(u == 0 ? "'#e0e0e0'" : u < 5 ? "'#f39c12'" : "'#C0392B'");
            }
        }
    %>
    const ctx = document.getElementById('bloodChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [<%= labels %>],
            datasets: [{
                label: 'Units Available',
                data: [<%= dataVals %>],
                backgroundColor: [<%= colors %>],
                borderRadius: 6,
                borderSkipped: false,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });
</script>

</body>
</html>