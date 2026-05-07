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
    <title>Manage Camps | LifeFlow Admin</title>
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

        /* ── TABLE ── */
        .table-wrap { background: white; border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; margin-bottom: 28px; }
        .table-header { padding: 18px 22px; border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; background: #fdecea; }
        .table-header h3 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        table { width: 100%; border-collapse: collapse; }
        thead th { background: var(--red); color: white; padding: 12px 18px; text-align: left; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.8px; }
        tbody td { padding: 13px 18px; font-size: 13px; border-bottom: 1px solid var(--border); font-weight: 600; vertical-align: middle; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover td { background: #fdf8f8; }

        /* ── BUTTONS ── */
        .btn-add { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; background: var(--green); color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; text-decoration: none; transition: all 0.2s; }
        .btn-add:hover { background: #219150; transform: translateY(-1px); box-shadow: 0 4px 12px rgba(39,174,96,0.3); }
        .tbl-btn { display: inline-flex; align-items: center; gap: 4px; padding: 6px 12px; border-radius: 6px; color: white; font-size: 11px; font-weight: 700; font-family: 'Nunito', sans-serif; text-decoration: none; border: none; cursor: pointer; transition: opacity 0.2s; }
        .tbl-btn:hover { opacity: 0.85; }
        .tbl-btn.edit   { background: var(--orange); }
        .tbl-btn.delete { background: var(--red); }

        /* ── MODAL ── */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 200; align-items: center; justify-content: center; }
        .modal-overlay.open { display: flex; }
        .modal { background: white; border-radius: 16px; padding: 28px; width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); }
        .modal h3 { font-size: 16px; font-weight: 800; color: var(--text); margin-bottom: 20px; padding-bottom: 12px; border-bottom: 2px solid #fdecea; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 12px; font-weight: 700; color: var(--text); margin-bottom: 6px; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group input { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-family: 'Nunito', sans-serif; font-weight: 600; color: var(--text); background: var(--bg); transition: border 0.2s; }
        .form-group input:focus { outline: none; border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .modal-footer { display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px; }
        .btn-save   { padding: 10px 22px; background: var(--red); color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-save:hover { background: var(--red-dark); }
        .btn-cancel { padding: 10px 22px; background: var(--bg); color: var(--text-muted); border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-cancel:hover { background: var(--border); }

        /* Responsive */
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
        <a href="${pageContext.request.contextPath}/manageCamps.jsp" class="active">
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
            <h2>⛺ Manage Camps</h2>
            <span>Create and manage blood donation camps</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <div class="section-title">⛺ Donation Camps</div>

        <div class="table-wrap">
            <div class="table-header">
                <h3>⛺ All Donation Camps</h3>
                <button class="btn-add" onclick="openModal()">＋ Add New Camp</button>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Camp ID</th>
                    <th>Name</th>
                    <th>Location</th>
                    <th>Date</th>
                    <th>Organizer</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <%-- Replace with dynamic data from your servlet/DAO --%>
                <tr>
                    <td>#101</td>
                    <td><strong>City Hospital Drive</strong></td>
                    <td>Central Park Plaza</td>
                    <td>2024-05-15</td>
                    <td>Red Cross Society</td>
                    <td>
                        <button class="tbl-btn edit" onclick="openModal()">✏️ Edit</button>
                        &nbsp;
                        <button class="tbl-btn delete" onclick="return confirm('Delete this camp?')">🗑 Delete</button>
                    </td>
                </tr>
                <tr>
                    <td>#102</td>
                    <td><strong>University Blood Camp</strong></td>
                    <td>Main Campus Gym</td>
                    <td>2024-06-02</td>
                    <td>Student Union</td>
                    <td>
                        <button class="tbl-btn edit" onclick="openModal()">✏️ Edit</button>
                        &nbsp;
                        <button class="tbl-btn delete" onclick="return confirm('Delete this camp?')">🗑 Delete</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </div>

    </div>
</div>

<!-- ── ADD/EDIT MODAL ── -->
<div class="modal-overlay" id="campModal">
    <div class="modal">
        <h3>⛺ Add / Edit Camp</h3>
        <div class="form-group">
            <label>Camp Name</label>
            <input type="text" placeholder="e.g. City Hospital Drive">
        </div>
        <div class="form-group">
            <label>Location</label>
            <input type="text" placeholder="e.g. Central Park Plaza">
        </div>
        <div class="form-group">
            <label>Date</label>
            <input type="date">
        </div>
        <div class="form-group">
            <label>Organizer</label>
            <input type="text" placeholder="e.g. Red Cross Society">
        </div>
        <div class="modal-footer">
            <button class="btn-cancel" onclick="closeModal()">Cancel</button>
            <button class="btn-save">💾 Save Camp</button>
        </div>
    </div>
</div>

<script>
    function openModal()  { document.getElementById('campModal').classList.add('open'); }
    function closeModal() { document.getElementById('campModal').classList.remove('open'); }
    window.addEventListener('click', e => {
        if (e.target === document.getElementById('campModal')) closeModal();
    });
</script>

</body>
</html>
