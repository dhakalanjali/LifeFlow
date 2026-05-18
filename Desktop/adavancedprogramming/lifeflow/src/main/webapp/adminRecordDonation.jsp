<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.Donor" %>
<%@ page import="com.lifeflow.lifeflow.model.DonationCamp" %>
<%@ page import="java.util.List" %>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    List<DonationCamp> camps    = (List<DonationCamp>) request.getAttribute("camps");
    List<Donor>        donors   = (List<Donor>)        request.getAttribute("donors");
    List<User>         allUsers = (List<User>)         request.getAttribute("allUsers");

    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg   = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Record Donation – LifeFlow Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red:       #c0392b;
            --red-dark:  #a93226;
            --red-light: #fde8e8;
            --bg:        #f0f2f5;
            --white:     #ffffff;
            --text:      #2c3e50;
            --text-muted:#7f8c8d;
            --border:    #e8ecef;
            --green:     #27ae60;
            --green-bg:  #dcfce7;
            --orange:    #e67e22;
            --blue:      #2980b9;
            --shadow:    0 2px 12px rgba(0,0,0,0.08);
            --radius:    12px;
        }

        body { font-family: 'Nunito', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; }

        /* SIDEBAR */
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

        /* MAIN */
        .main { margin-left: 240px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .topbar-left h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-left span { font-size: 12px; color: var(--text-muted); }
        .topbar-right { display: flex; align-items: center; gap: 12px; }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* CONTENT */
        .content { padding: 28px; flex: 1; }

        /* ALERTS */
        .alert { padding: 14px 18px; border-radius: var(--radius); margin-bottom: 24px; display: flex; align-items: center; gap: 10px; font-size: .92rem; }
        .alert-success { background: var(--green-bg); color: var(--green); border: 1px solid #86efac; }
        .alert-error   { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

        /* CARD */
        .card { background: var(--white); border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 32px; margin-bottom: 24px; }
        .card-title { font-size: 1rem; font-weight: 800; margin-bottom: 20px; display: flex; align-items: center; gap: 8px; color: var(--text); }
        .card-title i { color: var(--red); }

        /* FORM */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px 28px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .full { grid-column: 1 / -1; }
        label { font-size: .83rem; font-weight: 700; color: var(--text); }
        label .req { color: var(--red); }
        select, input { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 8px; font-size: .92rem; color: var(--text); background: #fafafa; outline: none; transition: border-color .2s; font-family: 'Nunito', sans-serif; }
        select:focus, input:focus { border-color: var(--red); background: #fff; }

        /* Preview box */
        .preview-box { background: var(--red-light); border: 1px solid #f5b7b1; border-radius: 8px; padding: 14px 18px; font-size: .88rem; color: #7b241c; display: none; margin-top: 8px; }
        .preview-box.show { display: block; }
        .preview-box strong { display: block; margin-bottom: 4px; }

        /* Submit */
        .btn-submit { display: flex; align-items: center; justify-content: center; gap: 10px; width: 100%; padding: 13px; margin-top: 24px; background: var(--red); color: #fff; border: none; border-radius: 8px; font-size: .98rem; font-weight: 700; cursor: pointer; transition: background .2s; font-family: 'Nunito', sans-serif; }
        .btn-submit:hover { background: var(--red-dark); }

        /* Table */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: .88rem; }
        thead th { background: var(--red); color: white; padding: 12px 14px; text-align: left; font-size: .75rem; font-weight: 800; text-transform: uppercase; letter-spacing: .05em; }
        tbody td { padding: 12px 14px; border-bottom: 1px solid var(--border); color: var(--text); font-weight: 600; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: #fdf8f8; }
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: .78rem; font-weight: 700; }
        .badge-blood { background: var(--red-light); color: var(--red); }

        @media(max-width: 768px) {
            .sidebar { width: 0; overflow: hidden; }
            .main { margin-left: 0; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- SIDEBAR -->
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
        <a href="${pageContext.request.contextPath}/bloodRequest">
            <span class="icon">🔍</span> Search Blood
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports">
            <span class="icon">📊</span> Reports
        </a>
        <a href="${pageContext.request.contextPath}/admin/recorddonation" class="active">
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

<!-- MAIN -->
<div class="main">

    <!-- TOPBAR -->
    <header class="topbar">
        <div class="topbar-left">
            <h2>🩸 Record Donation</h2>
            <span>Record a completed blood donation from a donor</span>
        </div>
        <div class="topbar-right">
            <div class="topbar-admin">
                <div class="admin-avatar">A</div>
                <span class="admin-name">Admin</span>
            </div>
        </div>
    </header>

    <div class="content">

        <% if (successMsg != null) { %>
        <div class="alert alert-success">
            <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
        </div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">
            <i class="fa-solid fa-circle-exclamation"></i> <%= errorMsg %>
        </div>
        <% } %>

        <div class="card">
            <div class="card-title">
                <i class="fa-solid fa-droplet"></i> Enter Donation Details
            </div>

            <form action="${pageContext.request.contextPath}/admin/recorddonation"
                  method="post" id="recordForm" novalidate>

                <div class="form-grid">

                    <div class="form-group">
                        <label for="userId">Select Donor <span class="req">*</span></label>
                        <select id="userId" name="userId" required onchange="updateDonorInfo(this)">
                            <option value="" disabled selected>-- Select Donor --</option>
                            <%
                                if (donors != null && allUsers != null) {
                                    for (Donor d : donors) {
                                        User matchedUser = null;
                                        for (User u : allUsers) {
                                            if (u.getUserId() == d.getUserId()) {
                                                matchedUser = u;
                                                break;
                                            }
                                        }
                                        if (matchedUser != null) {
                            %>
                            <option value="<%= d.getUserId() %>"
                                    data-blood="<%= matchedUser.getBloodType() != null ? matchedUser.getBloodType() : "N/A" %>"
                                    data-name="<%= matchedUser.getFullName() %>"
                                    data-eligible="<%= d.getIsEligible() %>">
                                <%= matchedUser.getFullName() %> — <%= matchedUser.getBloodType() %>
                            </option>
                            <%      }
                            }
                            }
                            %>
                        </select>
                        <div class="preview-box" id="donorPreview"></div>
                    </div>

                    <div class="form-group">
                        <label for="campId">Select Camp <span class="req">*</span></label>
                        <select id="campId" name="campId" required>
                            <option value="" disabled selected>-- Select Camp --</option>
                            <%
                                if (camps != null) {
                                    for (DonationCamp camp : camps) {
                            %>
                            <option value="<%= camp.getId() %>">
                                <%= camp.getName() %> — <%= camp.getLocation() %> (<%= camp.getDate() %>)
                            </option>
                            <%      }
                            }
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="bloodType">Blood Type <span class="req">*</span></label>
                        <select id="bloodType" name="bloodType" required>
                            <option value="" disabled selected>-- Select --</option>
                            <%
                                String[] groups = {"A+","A-","B+","B-","O+","O-","AB+","AB-"};
                                for (String bg : groups) {
                            %>
                            <option value="<%= bg %>"><%= bg %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="unitsDonated">Units Donated (1–5) <span class="req">*</span></label>
                        <input type="number" id="unitsDonated" name="unitsDonated"
                               min="1" max="5" value="1" required/>
                    </div>

                    <div class="form-group">
                        <label for="donationDate">Donation Date <span class="req">*</span></label>
                        <input type="date" id="donationDate" name="donationDate" required/>
                    </div>

                </div>

                <button type="submit" class="btn-submit" id="submitBtn">
                    <i class="fa-solid fa-floppy-disk"></i> Save Donation Record
                </button>

            </form>
        </div>

    </div>
</div>

<script>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('donationDate').value = today;
    document.getElementById('donationDate').setAttribute('max', today);

    function updateDonorInfo(select) {
        const opt      = select.options[select.selectedIndex];
        const blood    = opt.getAttribute('data-blood');
        const name     = opt.getAttribute('data-name');
        const eligible = opt.getAttribute('data-eligible');
        const preview  = document.getElementById('donorPreview');
        const btSelect = document.getElementById('bloodType');

        for (let i = 0; i < btSelect.options.length; i++) {
            if (btSelect.options[i].value === blood) {
                btSelect.selectedIndex = i;
                break;
            }
        }

        const eligibleText = eligible === 'yes'
            ? '<span style="color:#16a34a">✅ Eligible</span>'
            : '<span style="color:#C0392B">⚠️ Not eligible (donated recently)</span>';

        preview.innerHTML = '<strong>' + name + '</strong>Blood Type: ' + blood + ' &nbsp;|&nbsp; ' + eligibleText;
        preview.classList.add('show');

        if (eligible !== 'yes') {
            if (!confirm('⚠️ This donor is currently NOT eligible (donated recently). Record anyway?')) {
                select.selectedIndex = 0;
                preview.classList.remove('show');
            }
        }
    }

    document.getElementById('recordForm').addEventListener('submit', function(e) {
        const userId = document.getElementById('userId').value;
        const campId = document.getElementById('campId').value;
        const blood  = document.getElementById('bloodType').value;
        const units  = parseInt(document.getElementById('unitsDonated').value);
        const date   = document.getElementById('donationDate').value;

        if (!userId || !campId || !blood || !date || isNaN(units) || units < 1 || units > 5) {
            e.preventDefault();
            alert('Please fill in all required fields correctly.');
            return;
        }

        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').innerHTML =
            '<i class="fa-solid fa-spinner fa-spin"></i> Saving…';
    });
</script>
</body>
</html>
