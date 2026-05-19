<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    User loggedUser = (User) session.getAttribute("user");
    if(loggedUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    boolean isAdmin = "admin".equals(loggedUser.getRole());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Blood | LifeFlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --red: #C0392B; --red-dark:#a93226;; --red-light: #fde8e8;
            --red-border: #f5b7b1; --bg: #f4f4f0; --card: #ffffff;
            --text: #1a1a1a; --muted: #6b7280; --border: rgba(0,0,0,0.08);
            --green: #16a34a; --green-light: #dcfce7;
            --radius: 14px; --radius-sm: 8px;
            --shadow: 0 2px 12px rgba(0,0,0,0.07);
        }
        html, body { width: 100%; min-height: 100vh; font-family: 'Plus Jakarta Sans', Arial, sans-serif; background: var(--bg); color: var(--text); }

        /* ── USER NAVBAR ── */
        .navbar { background: var(--red); padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 12px rgba(192,57,43,0.25); }
        .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar-links { display: flex; align-items: center; gap: 2px; }
        .navbar-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; }
        .navbar-links a:hover  { background: rgba(255,255,255,0.15); color: #fff; }
        .navbar-links a.active { background: rgba(255,255,255,0.22); color: #fff; font-weight: 600; }
        .btn-logout { background: rgba(255,255,255,0.15) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.35); margin-left: 8px; font-weight: 500; border-radius: var(--radius-sm); }
        .btn-logout:hover { background: rgba(255,255,255,0.28) !important; }

        /* hamburger */
        .hamburger { display: none; flex-direction: column; gap: 5px; cursor: pointer; padding: 4px; background: none; border: none; }
        .hamburger span { display: block; width: 22px; height: 2px; background: #fff; border-radius: 2px; transition: all 0.3s; }
        .hamburger.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .hamburger.open span:nth-child(2) { opacity: 0; }
        .hamburger.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
        .mobile-menu { display: none; flex-direction: column; background: var(--red-dark); padding: 10px 1.5rem; gap: 2px; position: sticky; top: 60px; z-index: 99; }
        .mobile-menu.open { display: flex; }
        .mobile-menu a { color: rgba(255,255,255,0.9); text-decoration: none; font-size: 14px; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .mobile-menu a:last-child { border-bottom: none; }

        /* ── ADMIN SIDEBAR ── */
        .sidebar { width: 240px; background: var(--red-dark); min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; font-family: 'Nunito', sans-serif; }
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

        /* Admin topbar */
        .admin-topbar { background: var(--card); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); font-family: 'Nunito', sans-serif; }
        .admin-topbar h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .admin-topbar span.sub { font-size: 12px; color: var(--muted); }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); font-family: 'Nunito', sans-serif; }

        /* ── ADMIN LAYOUT WRAPPER ── */
        .admin-layout { display: flex; min-height: 100vh; }
        .admin-main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }

        /* ── HERO ── */
        .hero { background: var(--red); padding: 2rem 2.5rem 1.75rem; color: #fff; position: relative; overflow: hidden; }
        .hero::after { content: '🔍'; position: absolute; right: 2.5rem; top: 50%; transform: translateY(-50%); font-size: 72px; opacity: 0.1; pointer-events: none; }
        .hero h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
        .hero p  { font-size: 13px; opacity: 0.82; }

        /* ── CONTAINER ── */
        .container { max-width: 800px; margin: 0 auto; padding: 2rem 2.5rem; }

        /* ── SECTION TITLE ── */
        .section-title { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 1rem; display: flex; align-items: center; gap: 8px; }
        .section-title::before { content: ''; display: block; width: 3px; height: 16px; background: var(--red); border-radius: 2px; }

        /* ── ALERT ── */
        .alert { padding: 12px 16px; border-radius: var(--radius-sm); font-size: 13px; font-weight: 500; margin-bottom: 1.5rem; }
        .alert-error { background: var(--red-light); border-left: 4px solid var(--red); color: var(--red-dark); }

        /* ── SEARCH CARD ── */
        .search-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); overflow: hidden; margin-bottom: 2rem; box-shadow: var(--shadow); }
        .search-card-header { background: var(--red-light); padding: 18px 24px; border-bottom: 1px solid var(--red-border); }
        .search-card-header h3 { font-size: 15px; font-weight: 600; color: var(--red-dark); margin-bottom: 3px; }
        .search-card-header p  { font-size: 12px; color: var(--muted); }
        .search-card-body { padding: 24px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 18px; }
        .form-group label { display: block; font-size: 11px; font-weight: 600; color: var(--muted); margin-bottom: 7px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group select,
        .form-group input[type="text"] { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: var(--radius-sm); font-size: 13px; font-family: inherit; font-weight: 500; color: var(--text); background: var(--bg); transition: border 0.2s; appearance: none; }
        .form-group select:focus,
        .form-group input[type="text"]:focus { outline: none; border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .btn-search { width: 100%; padding: 11px; background: var(--red); color: white; border: none; border-radius: var(--radius-sm); font-size: 14px; font-weight: 600; font-family: inherit; cursor: pointer; transition: all 0.15s; }
        .btn-search:hover { background: var(--red-dark); transform: translateY(-1px); }

        /* ── RESULTS ── */
        .results-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); overflow: hidden; box-shadow: var(--shadow); }
        .results-header { background: var(--red-light); padding: 14px 24px; border-bottom: 1px solid var(--red-border); font-size: 13px; font-weight: 600; color: var(--red-dark); }
        .result-row { display: flex; align-items: center; padding: 20px 24px; border-bottom: 1px solid var(--border); transition: background 0.15s; }
        .result-row:last-child { border-bottom: none; }
        .result-row:hover { background: #fafafa; }
        .blood-circle { width: 52px; height: 52px; border-radius: 50%; background: var(--red); color: white; font-weight: 700; font-size: 14px; display: flex; align-items: center; justify-content: center; box-shadow: 0 3px 8px rgba(192,57,43,0.3); flex-shrink: 0; }
        .result-info { flex: 1; margin-left: 16px; }
        .result-units { font-size: 26px; font-weight: 700; color: var(--text); line-height: 1; }
        .result-units span { font-size: 13px; color: var(--muted); font-weight: 500; }
        .result-location { font-size: 12px; color: var(--muted); margin-top: 4px; font-weight: 500; }
        .result-updated { font-size: 11px; color: var(--muted); margin-top: 3px; }
        .status-pill { padding: 5px 14px; border-radius: 20px; font-size: 11px; font-weight: 700; flex-shrink: 0; }
        .status-pill.available   { background: var(--green-light); color: var(--green); }
        .status-pill.unavailable { background: var(--red-light); color: var(--red); }
        .no-results { padding: 48px 24px; text-align: center; color: var(--muted); }
        .no-results .no-icon { font-size: 42px; margin-bottom: 12px; }
        .no-results p { font-size: 13px; font-weight: 500; }

        footer { background: #1a1a1a; color: rgba(255,255,255,0.45); text-align: center; padding: 1.25rem; font-size: 12px; margin-top: 3rem; }
        footer a { color: rgba(255,255,255,0.65); text-decoration: none; }

        @media (max-width: 768px) {
            .navbar { padding: 0 1rem; }
            .navbar-links { display: none; }
            .hamburger { display: flex; }
            .hero { padding: 1.5rem 1.25rem; }
            .hero::after { display: none; }
            .container { padding: 1.25rem; }
            .form-row { grid-template-columns: 1fr; }
            .sidebar { width: 0; overflow: hidden; }
            .admin-main { margin-left: 0; }
        }
    </style>
</head>
<body>

<% if (isAdmin) { %>

<!-- ══════════════ ADMIN LAYOUT ══════════════ -->
<div class="admin-layout">

    <!-- ADMIN SIDEBAR -->
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
            <a href="${pageContext.request.contextPath}/admin/manageCamps">
                <span class="icon">⛺</span> Manage Camps
            </a>
            <a href="${pageContext.request.contextPath}/admin/bloodStock">
                <span class="icon">🩸</span> Blood Stock
            </a>
            <a href="${pageContext.request.contextPath}/bloodRequest" class="active">
                <span class="icon">🔍</span> Search Blood
            </a>
            <a href="${pageContext.request.contextPath}/admin/reports">
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

    <!-- ADMIN MAIN -->
    <div class="admin-main">

        <!-- ADMIN TOPBAR -->
        <header class="admin-topbar">
            <div>
                <h2>Search Blood</h2>
                <span class="sub">Find available blood by group and location</span>
            </div>
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </header>

        <% } else { %>

        <!-- ══════════════ USER NAVBAR ══════════════ -->
        <nav class="navbar">
            <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">&#10084; LifeFlow</a>
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
            <button class="hamburger" id="hamburger" onclick="toggleMenu()" aria-label="Menu">
                <span></span><span></span><span></span>
            </button>
        </nav>

        <!-- MOBILE MENU -->
        <div class="mobile-menu" id="mobileMenu">
            <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
            <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
            <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>

        <% } %>

        <!-- ══════════════ SHARED CONTENT ══════════════ -->

        <% if (!isAdmin) { %>
        <!-- HERO (user only — admin has topbar instead) -->
        <div class="hero">
            <h1>Search Blood</h1>
            <p>Find available blood by blood group and location</p>
        </div>
        <% } %>

        <div class="container">

            <% String errorMsg = (String) request.getAttribute("errorMessage");
                if(errorMsg != null) { %>
            <div class="alert alert-error">&#10060; <%= errorMsg %></div>
            <% } %>

            <div class="section-title">Find Available Blood</div>
            <div class="search-card">
                <div class="search-card-header">
                    <h3>&#128269; Blood Search</h3>
                    <p>Select a blood group and enter your location to check availability</p>
                </div>
                <div class="search-card-body">
                    <form action="${pageContext.request.contextPath}/bloodRequest" method="POST">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="bloodGroup">Blood Group</label>
                                <select id="bloodGroup" name="bloodGroup" required>
                                    <option value="">— Select Blood Group —</option>
                                    <option value="A+"  <%= "A+".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>A+</option>
                                    <option value="A-"  <%= "A-".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>A-</option>
                                    <option value="B+"  <%= "B+".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>B+</option>
                                    <option value="B-"  <%= "B-".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>B-</option>
                                    <option value="AB+" <%= "AB+".equals(request.getAttribute("searchBloodGroup")) ? "selected" : "" %>>AB+</option>
                                    <option value="AB-" <%= "AB-".equals(request.getAttribute("searchBloodGroup")) ? "selected" : "" %>>AB-</option>
                                    <option value="O+"  <%= "O+".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>O+</option>
                                    <option value="O-"  <%= "O-".equals(request.getAttribute("searchBloodGroup"))  ? "selected" : "" %>>O-</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="location">Location</label>
                                <input type="text" id="location" name="location"
                                       placeholder="Enter city or area"
                                       value="<%= request.getAttribute("searchLocation") != null ? request.getAttribute("searchLocation") : "" %>"
                                       required>
                            </div>
                        </div>
                        <button type="submit" class="btn-search">&#128269; Search Blood</button>
                    </form>
                </div>
            </div>

            <%
                List<Map<String, String>> results = (List<Map<String, String>>) request.getAttribute("searchResults");
                String searchMsg = (String) request.getAttribute("searchMessage");
                if (results != null) {
            %>
            <div class="section-title">Search Results</div>
            <div class="results-card">
                <div class="results-header">&#128203; <%= searchMsg != null ? searchMsg : "Results" %></div>
                <% if (results.isEmpty()) { %>
                <div class="no-results">
                    <div class="no-icon">&#128534;</div>
                    <p>No blood stock found for this blood group. Please try another group.</p>
                </div>
                <% } else {
                    for (Map<String, String> r : results) { %>
                <div class="result-row">
                    <div class="blood-circle"><%= r.get("blood_type") %></div>
                    <div class="result-info">
                        <div class="result-units"><%= r.get("units_available") %> <span>units available</span></div>
                        <div class="result-location">&#128205; <%= request.getAttribute("searchLocation") %></div>
                        <div class="result-updated">Last updated: <%= r.get("last_updated") %></div>
                    </div>
                    <span class="status-pill <%= r.get("status_class") %>"><%= r.get("status") %></span>
                </div>
                <% } } %>
            </div>
            <% } %>

        </div>

        <footer>
            &copy; 2026 LifeFlow Blood Bank &mdash; <a href="contact.jsp">Contact Us</a>
        </footer>

        <% if (isAdmin) { %>
    </div><!-- /admin-main -->
</div><!-- /admin-layout -->
<% } %>

<script>
    function toggleMenu() {
        document.getElementById('mobileMenu').classList.toggle('open');
        document.getElementById('hamburger').classList.toggle('open');
    }
</script>

</body>
</html>
