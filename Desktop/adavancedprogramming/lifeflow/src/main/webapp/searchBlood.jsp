<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Search Blood | LifeFlow Admin</title>
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

        /* ── SEARCH CARD ── */
        .search-card { background: var(--white); border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; max-width: 600px; }
        .search-card-header { background: #fdecea; padding: 18px 24px; border-bottom: 1px solid var(--border); }
        .search-card-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .search-card-header p { font-size: 12px; color: var(--text-muted); margin-top: 3px; font-weight: 600; }
        .search-card-body { padding: 24px; }

        /* ── FORM ── */
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 7px; }
        .form-group select,
        .form-group input[type="text"] {
            width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 8px;
            font-size: 13px; font-family: 'Nunito', sans-serif; font-weight: 600; color: var(--text);
            background: var(--bg); transition: border 0.2s, box-shadow 0.2s; appearance: none;
        }
        .form-group select:focus,
        .form-group input[type="text"]:focus { outline: none; border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .btn-search { width: 100%; padding: 12px; background: var(--red); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; margin-top: 4px; }
        .btn-search:hover { background: var(--red-dark); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }

        /* ── RESULT ── */
        .result-box { margin-top: 20px; padding: 16px 20px; border-radius: 10px; font-size: 13px; font-weight: 600; }
        .result-box.success { background: #eafaf1; color: #1e8449; border-left: 4px solid var(--green); }
        .result-box h4 { font-size: 14px; font-weight: 800; margin-bottom: 6px; }
        .result-box p { margin-bottom: 4px; line-height: 1.6; }
        .result-note { font-size: 12px; color: var(--text-muted); margin-top: 8px; font-style: italic; }

        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
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
        <a href="${pageContext.request.contextPath}/admin/manageUsers">
            <span class="icon">👥</span> Manage Users
        </a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp">
            <span class="icon">⛺</span> Manage Camps
        </a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp">
            <span class="icon">🩸</span> Blood Stock
        </a>
        <a href="${pageContext.request.contextPath}/bloodRequest" class="active">
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
            <h2>🔍 Search Blood</h2>
            <span>Find available blood by group and location</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">
        <div class="section-title">🔍 Search Available Blood</div>

        <div class="search-card">
            <div class="search-card-header">
                <h3>🩸 Blood Search</h3>
                <p>Select a blood group and enter a location to find availability</p>
            </div>
            <div class="search-card-body">
                <form action="${pageContext.request.contextPath}/bloodRequest" method="POST">
                    <div class="form-group">
                        <label for="bloodGroup">Blood Group</label>
                        <select id="bloodGroup" name="bloodGroup" required>
                            <option value="">— Select Blood Group —</option>
                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="location">Location</label>
                        <input type="text" id="location" name="location" placeholder="Enter city or area" required>
                    </div>
                    <button type="submit" class="btn-search">🔍 Search Blood</button>
                </form>

                <%
                    String successMessage = (String) request.getAttribute("successMessage");
                    if (successMessage != null) {
                %>
                <div class="result-box success">
                    <h4>✅ Results Found</h4>
                    <p><%= successMessage %></p>
                    <p class="result-note">In a real system, available donors and blood banks would be listed here.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

</body>
</html>
