<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.DonationCamp" %>
<%@ page import="com.lifeflow.lifeflow.dao.DonationCampDAO" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    DonationCampDAO campDAO = new DonationCampDAO();
    List<DonationCamp> camps = campDAO.getAllCamps();
    String errorMsg = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Donate Blood – LifeFlow</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --red:       #C0392B;
            --red-dark:  #96281B;
            --red-light: #FADBD8;
            --bg:        #f4f4f0;
            --card:      #FFFFFF;
            --text:      #1a1a1a;
            --muted:     #6b7280;
            --border:    #e5e7eb;
            --radius:    14px;
            --shadow:    0 4px 24px rgba(0,0,0,.08);
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Segoe UI', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── Navbar (matches your app style) ── */
        .navbar {
            background: var(--red);
            padding: 0 2.5rem;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 12px rgba(192,57,43,0.25);
        }
        .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar-links { display: flex; align-items: center; gap: 2px; }
        .navbar-links a {
            color: rgba(255,255,255,0.88);
            text-decoration: none;
            font-size: 13px;
            padding: 6px 12px;
            border-radius: 8px;
            transition: background 0.15s;
        }
        .navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
        .btn-logout {
            background: rgba(255,255,255,0.15) !important;
            color: #fff !important;
            border: 1px solid rgba(255,255,255,0.35);
            margin-left: 8px;
            font-weight: 500;
        }

        /* ── Page wrapper ── */
        .page-wrapper {
            max-width: 760px;
            margin: 40px auto;
            padding: 0 16px;
        }

        /* ── Back link ── */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 24px;
            color: var(--muted);
            font-size: .9rem;
            text-decoration: none;
        }
        .back-link:hover { color: var(--red); }

        /* ── Page heading ── */
        .page-heading {
            text-align: center;
            margin-bottom: 32px;
        }
        .page-heading .icon-circle {
            width: 72px; height: 72px;
            background: var(--red-light);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 16px;
            font-size: 2rem;
            color: var(--red);
        }
        .page-heading h1 { font-size: 1.8rem; font-weight: 700; }
        .page-heading p  { color: var(--muted); margin-top: 6px; }

        /* ── Alert ── */
        .alert {
            padding: 14px 18px;
            border-radius: var(--radius);
            margin-bottom: 24px;
            font-size: .92rem;
            display: flex;
            align-items: center;
            gap: 10px;
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        /* ── Info box ── */
        .info-box {
            background: var(--red-light);
            border-left: 4px solid var(--red);
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 28px;
            font-size: .88rem;
            color: #7b241c;
        }
        .info-box ul { margin-left: 18px; margin-top: 6px; line-height: 1.9; }

        /* ── Card ── */
        .card {
            background: var(--card);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 36px 40px;
        }

        /* ── Form grid ── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px 28px;
        }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .full { grid-column: 1 / -1; }

        label { font-size: .85rem; font-weight: 600; }
        label .req { color: var(--red); }

        input, select {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border);
            border-radius: 8px;
            font-size: .95rem;
            background: #fafafa;
            color: var(--text);
            outline: none;
            transition: border-color .2s;
            font-family: inherit;
        }
        input:focus, select:focus { border-color: var(--red); background: #fff; }
        input[readonly] { background: #f3f4f6; cursor: not-allowed; color: var(--muted); }

        .section-label {
            grid-column: 1 / -1;
            font-size: .75rem;
            font-weight: 700;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--muted);
        }
        .divider {
            grid-column: 1 / -1;
            border: none;
            border-top: 1.5px dashed var(--border);
        }

        /* ── Submit button ── */
        .btn-submit {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 14px;
            margin-top: 28px;
            background: var(--red);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s;
            font-family: inherit;
        }
        .btn-submit:hover { background: var(--red-dark); }

        @media (max-width: 560px) {
            .form-grid { grid-template-columns: 1fr; }
            .card { padding: 24px 18px; }
            .navbar { padding: 0 1rem; }
        }
    </style>
</head>
<body>

<!-- ══ Navbar (same style as your app) ══ -->
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
    <div class="navbar-links">
        <a href="<%= request.getContextPath() %>/userDashboard.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/searchBlood.jsp">Search Blood</a>
        <a href="<%= request.getContextPath() %>/donationHistory.jsp">Donation History</a>
        <a href="<%= request.getContextPath() %>/profile.jsp">My Profile</a>
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="page-wrapper">

    <!-- Back link -->
    <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="back-link">
        <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
    </a>

    <!-- Heading -->
    <div class="page-heading">
        <div class="icon-circle"><i class="fa-solid fa-hand-holding-droplet"></i></div>
        <h1>Donate Blood</h1>
        <p>Fill in the details below to register your blood donation.</p>
    </div>

    <!-- Error message (shown when POST fails) -->
    <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert">
        <i class="fa-solid fa-circle-exclamation"></i> <%= errorMsg %>
    </div>
    <% } %>

    <!-- Info tips -->
    <div class="info-box">
        <strong><i class="fa-solid fa-circle-info"></i> Before you donate, make sure:</strong>
        <ul>
            <li>You are at least 18 years old and weigh above 50 kg.</li>
            <li>It has been at least 3 months since your last donation.</li>
            <li>You are in good health and not on antibiotics.</li>
        </ul>
    </div>

    <!-- Form card -->
    <div class="card">
        <form action="<%= request.getContextPath() %>/donate-blood"
              method="post" id="donateForm" novalidate>

            <div class="form-grid">

                <!-- YOUR INFO section -->
                <p class="section-label">Your Information</p>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" value="<%= currentUser.getFullName() %>" readonly/>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" value="<%= currentUser.getEmail() %>" readonly/>
                </div>

                <hr class="divider"/>

                <!-- DONATION DETAILS section -->
                <p class="section-label">Donation Details</p>

                <!-- Blood Group -->
                <div class="form-group">
                    <label for="bloodType">Blood Group <span class="req">*</span></label>
                    <select id="bloodType" name="bloodType" required>
                        <option value="" disabled selected>-- Select Blood Group --</option>
                        <%
                            String[] bloodGroups = {"A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"};
                            String userBlood = currentUser.getBloodType();
                            for (String bg : bloodGroups) {
                                String selected = bg.equals(userBlood) ? "selected" : "";
                        %>
                        <option value="<%= bg %>" <%= selected %>><%= bg %></option>
                        <% } %>
                    </select>
                </div>

                <!-- Units -->
                <div class="form-group">
                    <label for="unitsDonated">Units to Donate (1–5) <span class="req">*</span></label>
                    <input type="number" id="unitsDonated" name="unitsDonated"
                           min="1" max="5" value="1" required/>
                </div>

                <!-- Donation Date -->
                <div class="form-group">
                    <label for="donationDate">Donation Date <span class="req">*</span></label>
                    <input type="date" id="donationDate" name="donationDate" required/>
                </div>

                <!-- Camp (optional) -->
                <div class="form-group">
                    <label for="campId">Donation Camp <small style="color:var(--muted);font-weight:400">(optional)</small></label>
                    <select id="campId" name="campId">
                        <option value="0">-- Walk-in / No Camp --</option>
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

            </div><!-- /form-grid -->

            <button type="submit" class="btn-submit" id="submitBtn">
                <i class="fa-solid fa-heart-pulse"></i> Submit Donation
            </button>

        </form>
    </div>

</div><!-- /page-wrapper -->

<script>
    // Set max date = today
    const dateInput = document.getElementById('donationDate');
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('max', today);
    dateInput.value = today;

    // Client-side validation
    document.getElementById('donateForm').addEventListener('submit', function(e) {
        const blood = document.getElementById('bloodType').value;
        const units = parseInt(document.getElementById('unitsDonated').value);
        const date  = document.getElementById('donationDate').value;

        if (!blood) {
            e.preventDefault();
            alert('Please select your blood group.');
            return;
        }
        if (isNaN(units) || units < 1 || units > 5) {
            e.preventDefault();
            alert('Units donated must be between 1 and 5.');
            return;
        }
        if (!date) {
            e.preventDefault();
            alert('Please select a donation date.');
            return;
        }

        document.getElementById('submitBtn').disabled = true;
        document.getElementById('submitBtn').innerHTML =
            '<i class="fa-solid fa-spinner fa-spin"></i> Submitting…';
    });
</script>
</body>
</html>
