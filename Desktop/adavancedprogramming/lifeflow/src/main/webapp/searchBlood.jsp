<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.BloodStock" %>
<%@ page import="com.lifeflow.lifeflow.service.BloodService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // If admin, redirect to admin search page
    if ("admin".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/bloodRequest");
        return;
    }

    String userName = (String) session.getAttribute("userName");

    // Search logic
    String searchGroup = request.getParameter("bloodGroup");
    BloodService bloodService = new BloodService();
    List<BloodStock> allStock = bloodService.getAllBloodStock();
    List<BloodStock> results = new ArrayList<>();

    if (searchGroup != null && !searchGroup.isEmpty()) {
        for (BloodStock bs : allStock) {
            if (bs.getBloodGroup().equals(searchGroup)) {
                results.add(bs);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Blood - LifeFlow</title>
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

        .page-title { font-size: 20px; font-weight: 600; display: flex; align-items: center; gap: 8px; margin-bottom: 1.5rem; }
        .page-title::before { content: ''; display: block; width: 4px; height: 22px; background: var(--red); border-radius: 2px; }

        .layout { display: grid; grid-template-columns: 340px 1fr; gap: 1.5rem; }

        /* SEARCH FORM */
        .search-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1.5rem; }
        .search-card h3 { font-size: 15px; font-weight: 600; margin-bottom: 1.25rem; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 6px; }
        .form-group select { width: 100%; padding: 10px 14px; border: 0.5px solid var(--border); border-radius: var(--radius-sm); font-size: 13px; color: var(--text); background: #fafafa; font-family: inherit; outline: none; transition: border-color 0.15s; }
        .form-group select:focus { border-color: var(--red); background: #fff; }
        .btn-search { width: 100%; background: var(--red); color: #fff; border: none; padding: 11px; border-radius: var(--radius-sm); font-size: 14px; font-weight: 600; cursor: pointer; font-family: inherit; transition: background 0.15s; }
        .btn-search:hover { background: var(--red-dark); }

        /* ALL BLOOD STOCK */
        .stock-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 1.25rem; }
        .blood-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 1rem; display: flex; flex-direction: column; align-items: center; gap: 3px; transition: border-color 0.15s; }
        .blood-card:hover { border-color: var(--red-border); }
        .blood-card.out { border-color: var(--red-border); background: var(--red-light); }
        .blood-card.low { border-color: #f39c12; background: #fffbf0; }
        .blood-type { font-size: 20px; font-weight: 600; color: var(--red); }
        .blood-type.empty { color: #bdc3c7; }
        .blood-units { font-size: 22px; font-weight: 600; }
        .blood-sub { font-size: 10px; color: var(--muted); }
        .tag-out { font-size: 10px; color: var(--red); font-weight: 600; }
        .tag-low { font-size: 10px; color: #d35400; font-weight: 600; }
        .blood-bar { width: 100%; height: 4px; background: #efefef; border-radius: 4px; margin-top: 6px; overflow: hidden; }
        .blood-fill { height: 100%; border-radius: 4px; background: var(--red); }
        .blood-fill.low-fill { background: #f39c12; }
        .blood-fill.empty-fill { background: #ddd; width: 0 !important; }

        /* RESULTS */
        .results-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); overflow: hidden; }
        .results-header { padding: 1rem 1.5rem; border-bottom: 0.5px solid var(--border); font-size: 14px; font-weight: 600; }
        .result-row { display: flex; align-items: center; gap: 1rem; padding: 1.25rem 1.5rem; border-bottom: 0.5px solid var(--border); }
        .result-row:last-child { border-bottom: none; }
        .result-badge { width: 54px; height: 54px; border-radius: 50%; background: var(--red); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 600; flex-shrink: 0; }
        .result-info .units { font-size: 24px; font-weight: 600; }
        .result-info .sub { font-size: 12px; color: var(--muted); }
        .avail-badge { padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; margin-left: auto; }
        .avail-yes { background: #e8f5e9; color: #2e7d32; border: 0.5px solid #a5d6a7; }
        .avail-no  { background: var(--red-light); color: var(--red-dark); border: 0.5px solid var(--red-border); }

        .section-title { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 0.85rem; display: flex; align-items: center; gap: 8px; }
        .section-title::before { content: ''; display: block; width: 3px; height: 16px; background: var(--red); border-radius: 2px; }

        .empty-state { text-align: center; padding: 3rem; color: var(--muted); }
        .empty-icon { font-size: 40px; margin-bottom: 0.75rem; opacity: 0.4; }

        @media (max-width: 768px) {
            .navbar { padding: 0 1rem; }
            .navbar-links { display: none; }
            .container { padding: 1rem; }
            .layout { grid-template-columns: 1fr; }
            .stock-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp" class="active">Search Blood</a>
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
    <div class="page-title">&#128269; Search Blood</div>

    <div class="layout">
        <!-- SEARCH FORM -->
        <div>
            <div class="search-card">
                <h3>&#128137; Find Blood by Group</h3>
                <form action="${pageContext.request.contextPath}/searchBlood.jsp" method="get">
                    <div class="form-group">
                        <label>Blood Group</label>
                        <select name="bloodGroup" required>
                            <option value="">-- Select Blood Group --</option>
                            <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                                for (String g : groups) { %>
                            <option value="<%= g %>" <%= g.equals(searchGroup) ? "selected" : "" %>><%= g %></option>
                            <% } %>
                        </select>
                    </div>
                    <button type="submit" class="btn-search">&#128269; Search Blood</button>
                </form>
            </div>

            <% if (searchGroup != null && !searchGroup.isEmpty()) { %>
            <div style="margin-top:1rem">
                <div class="results-card">
                    <div class="results-header">Results for: <strong style="color:var(--red)"><%= searchGroup %></strong></div>
                    <% if (results.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon">&#128137;</div>
                        <p>No stock found for <%= searchGroup %></p>
                    </div>
                    <% } else {
                        for (BloodStock bs : results) {
                            boolean isAvail = bs.getUnitsAvailable() > 0;
                    %>
                    <div class="result-row">
                        <div class="result-badge"><%= bs.getBloodGroup() %></div>
                        <div class="result-info">
                            <div class="units"><%= bs.getUnitsAvailable() %></div>
                            <div class="sub">units available</div>
                        </div>
                        <span class="avail-badge <%= isAvail ? "avail-yes" : "avail-no" %>">
                            <%= isAvail ? "&#10004; Available" : "&#10006; Not Available" %>
                        </span>
                    </div>
                    <% } } %>
                </div>
            </div>
            <% } %>
        </div>

        <!-- ALL BLOOD AVAILABILITY -->
        <div>
            <div class="section-title">Current Blood Availability</div>
            <div class="stock-grid">
                <%
                    for (BloodStock bs : allStock) {
                        int units = bs.getUnitsAvailable();
                        boolean isOut = units == 0;
                        boolean isLow = !isOut && units < 5;
                        String cardClass = isOut ? "out" : isLow ? "low" : "";
                        int pct = Math.min(100, (int)((units / 40.0) * 100));
                %>
                <div class="blood-card <%= cardClass %>">
                    <div class="blood-type <%= isOut ? "empty" : "" %>"><%= bs.getBloodGroup() %></div>
                    <div class="blood-units <%= isOut ? "empty" : "" %>"><%= units %></div>
                    <% if (isOut) { %>
                    <div class="tag-out">Not Available</div>
                    <% } else if (isLow) { %>
                    <div class="blood-sub">unit<%= units != 1 ? "s" : "" %> available</div>
                    <div class="tag-low">Low Stock</div>
                    <% } else { %>
                    <div class="blood-sub">unit<%= units != 1 ? "s" : "" %> available</div>
                    <% } %>
                    <div class="blood-bar">
                        <div class="blood-fill <%= isOut ? "empty-fill" : isLow ? "low-fill" : "" %>" style="width:<%= pct %>%"></div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

</body>
</html>
