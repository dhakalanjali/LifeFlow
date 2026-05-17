<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.Donor" %>
<%@ page import="com.lifeflow.lifeflow.model.DonationCamp" %>
<%@ page import="java.util.List" %>
<%
    // ── Admin session check ───────────────────────────────
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // ── Data from servlet ─────────────────────────────────
    List<DonationCamp> camps    = (List<DonationCamp>) request.getAttribute("camps");
    List<Donor>        donors   = (List<Donor>)        request.getAttribute("donors");
    List<User>         allUsers = (List<User>)         request.getAttribute("allUsers");

    // ── Flash messages ────────────────────────────────────
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
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red:       #C0392B;
            --red-dark:  #a93226;
            --red-light: #fde8e8;
            --sidebar-w: 260px;
            --bg:        #f4f5f7;
            --card:      #ffffff;
            --text:      #1a1a1a;
            --muted:     #6b7280;
            --border:    #e5e7eb;
            --green:     #16a34a;
            --green-bg:  #dcfce7;
            --radius:    12px;
            --shadow:    0 2px 16px rgba(0,0,0,.08);
        }

        body { font-family: 'Segoe UI', sans-serif; background: var(--bg); display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: var(--sidebar-w);
            background: var(--red-dark);
            min-height: 100vh;
            position: fixed;
            top: 0; left: 0;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }
        .sidebar-brand {
            padding: 24px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            font-size: 1.2rem;
            font-weight: 700;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }
        .sidebar-brand .dot {
            width: 36px; height: 36px;
            background: #fff;
            border-radius: 10px;
            display: flex; align-items:center; justify-content:center;
            font-size: 1.1rem;
        }
        .sidebar-section {
            padding: 16px 14px 4px;
            font-size: .7rem;
            font-weight: 700;
            letter-spacing: .1em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.5);
        }
        .sidebar nav a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            margin: 2px 8px;
            border-radius: 8px;
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            font-size: .92rem;
            transition: background .15s;
        }
        .sidebar nav a:hover { background: rgba(255,255,255,0.15); color: #fff; }
        .sidebar nav a.active { background: rgba(255,255,255,0.22); color: #fff; font-weight: 600; }
        .sidebar nav a .icon { font-size: 1rem; width: 20px; text-align: center; }
        .sidebar-footer {
            margin-top: auto;
            padding: 16px;
            border-top: 1px solid rgba(255,255,255,0.15);
        }
        .sidebar-footer a {
            display: flex; align-items:center; gap:8px;
            color: rgba(255,255,255,0.75); text-decoration:none; font-size:.88rem;
        }
        .sidebar-footer a:hover { color:#fff; }

        /* ── Main content ── */
        .main {
            margin-left: var(--sidebar-w);
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* ── Top bar ── */
        .topbar {
            background: var(--card);
            border-bottom: 1px solid var(--border);
            padding: 14px 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .topbar h1 { font-size: 1.1rem; font-weight: 700; }
        .topbar .breadcrumb { font-size: .82rem; color: var(--muted); margin-top: 2px; }
        .admin-chip {
            display: flex; align-items:center; gap:8px;
            background: var(--red-light);
            color: var(--red);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: .85rem;
            font-weight: 600;
        }
        .admin-avatar {
            width: 28px; height: 28px;
            background: var(--red);
            color: #fff;
            border-radius: 50%;
            display: flex; align-items:center; justify-content:center;
            font-size: .8rem; font-weight: 700;
        }

        /* ── Page body ── */
        .page-body { padding: 28px; flex: 1; }

        /* ── Alerts ── */
        .alert {
            padding: 14px 18px;
            border-radius: var(--radius);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: .92rem;
        }
        .alert-success { background: var(--green-bg); color: var(--green); border: 1px solid #86efac; }
        .alert-error   { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

        /* ── Cards ── */
        .card {
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 28px 32px;
            margin-bottom: 24px;
        }
        .card-title {
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text);
        }
        .card-title i { color: var(--red); }

        /* ── Form grid ── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px 28px;
        }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .full { grid-column: 1 / -1; }

        label { font-size: .83rem; font-weight: 600; color: var(--text); }
        label .req { color: var(--red); }

        select, input {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: .92rem;
            color: var(--text);
            background: #fafafa;
            outline: none;
            transition: border-color .2s;
            font-family: inherit;
        }
        select:focus, input:focus { border-color: var(--red); background: #fff; }

        /* ── Info preview box ── */
        .preview-box {
            background: var(--red-light);
            border: 1px solid #f5b7b1;
            border-radius: 8px;
            padding: 14px 18px;
            font-size: .88rem;
            color: #7b241c;
            display: none;
            margin-top: 8px;
        }
        .preview-box.show { display: block; }
        .preview-box strong { display: block; margin-bottom: 4px; }

        /* ── Submit button ── */
        .btn-submit {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 13px;
            margin-top: 24px;
            background: var(--red);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: .98rem;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s;
            font-family: inherit;
        }
        .btn-submit:hover { background: var(--red-dark); }

        /* ── Recent donations table ── */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: .88rem; }
        thead th {
            background: #f8f8f8;
            padding: 10px 14px;
            text-align: left;
            font-size: .75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .05em;
            color: var(--muted);
            border-bottom: 1px solid var(--border);
        }
        tbody td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border);
            color: var(--text);
        }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: #fafafa; }
        .badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: .78rem;
            font-weight: 600;
        }
        .badge-blood { background: var(--red-light); color: var(--red); }
    </style>
</head>
<body>

<!-- ══ Sidebar ══ -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="dot">💧</div>
        LifeFlow
    </div>

    <div class="sidebar-section">Admin Panel</div>
    <nav>
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
        <a href="${pageContext.request.contextPath}/admin/recorddonation" class="active">
            <span class="icon">🩸</span> Record Donation
        </a>
        <a href="${pageContext.request.contextPath}/admin/reports">
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
            <i class="fa-solid fa-right-from-bracket"></i> Logout
        </a>
    </div>
</aside>

<!-- ══ Main ══ -->
<div class="main">

    <!-- Topbar -->
    <div class="topbar">
        <div>
            <h1>Record Donation</h1>
            <div class="breadcrumb">Record a completed blood donation from a donor</div>
        </div>
        <div class="admin-chip">
            <div class="admin-avatar">A</div>
            Admin
        </div>
    </div>

    <div class="page-body">

        <!-- Flash messages -->
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

        <!-- Form card -->
        <div class="card">
            <div class="card-title">
                <i class="fa-solid fa-droplet"></i> Enter Donation Details
            </div>

            <form action="${pageContext.request.contextPath}/admin/recorddonation"
                  method="post" id="recordForm" novalidate>

                <div class="form-grid">

                    <!-- Select Donor -->
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
                        <!-- Donor info preview -->
                        <div class="preview-box" id="donorPreview"></div>
                    </div>

                    <!-- Select Camp -->
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

                    <!-- Blood Type -->
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

                    <!-- Units Donated -->
                    <div class="form-group">
                        <label for="unitsDonated">Units Donated (1–5) <span class="req">*</span></label>
                        <input type="number" id="unitsDonated" name="unitsDonated"
                               min="1" max="5" value="1" required/>
                    </div>

                    <!-- Donation Date -->
                    <div class="form-group">
                        <label for="donationDate">Donation Date <span class="req">*</span></label>
                        <input type="date" id="donationDate" name="donationDate" required/>
                    </div>

                </div><!-- /form-grid -->

                <button type="submit" class="btn-submit" id="submitBtn">
                    <i class="fa-solid fa-floppy-disk"></i> Save Donation Record
                </button>

            </form>
        </div><!-- /card -->

    </div><!-- /page-body -->
</div><!-- /main -->

<script>
    // Set today as default and max date
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('donationDate').value = today;
    document.getElementById('donationDate').setAttribute('max', today);

    // Auto-fill blood type when donor is selected
    function updateDonorInfo(select) {
        const opt      = select.options[select.selectedIndex];
        const blood    = opt.getAttribute('data-blood');
        const name     = opt.getAttribute('data-name');
        const eligible = opt.getAttribute('data-eligible');
        const preview  = document.getElementById('donorPreview');
        const btSelect = document.getElementById('bloodType');

        // Auto-select blood type
        for (let i = 0; i < btSelect.options.length; i++) {
            if (btSelect.options[i].value === blood) {
                btSelect.selectedIndex = i;
                break;
            }
        }

        // Show donor info preview
        const eligibleText = eligible === 'yes'
            ? '<span style="color:#16a34a">✅ Eligible</span>'
            : '<span style="color:#C0392B">⚠️ Not eligible (donated recently)</span>';

        preview.innerHTML = '<strong>' + name + '</strong>Blood Type: ' + blood + ' &nbsp;|&nbsp; ' + eligibleText;
        preview.classList.add('show');

        // Warn if not eligible
        if (eligible !== 'yes') {
            if (!confirm('⚠️ This donor is currently NOT eligible (donated recently). Record anyway?')) {
                select.selectedIndex = 0;
                preview.classList.remove('show');
            }
        }
    }

    // Validation on submit
    document.getElementById('recordForm').addEventListener('submit', function(e) {
        const userId  = document.getElementById('userId').value;
        const campId  = document.getElementById('campId').value;
        const blood   = document.getElementById('bloodType').value;
        const units   = parseInt(document.getElementById('unitsDonated').value);
        const date    = document.getElementById('donationDate').value;

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
