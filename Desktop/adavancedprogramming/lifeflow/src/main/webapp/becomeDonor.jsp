<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.dao.DonorDAO" %>
<%
  User currentUser = (User) session.getAttribute("user");
  if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  DonorDAO donorDAO = new DonorDAO();
  boolean isAlreadyDonor = donorDAO.getDonorByUserId(currentUser.getUserId()) != null;

  String successMsg = (String) request.getAttribute("success");
  String errorMsg   = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Become a Donor – LifeFlow</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --red: #C0392B; --red-dark: #96281B; --red-light: #FADBD8;
      --bg: #f4f4f0; --card: #FFFFFF; --text: #1a1a1a;
      --muted: #6b7280; --border: #e5e7eb;
      --green: #16a34a; --green-bg: #dcfce7;
      --radius: 14px; --shadow: 0 4px 24px rgba(0,0,0,.08);
    }
    body { font-family: 'Segoe UI', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

    .navbar {
      background: var(--red); padding: 0 2.5rem; height: 60px;
      display: flex; align-items: center; justify-content: space-between;
      position: sticky; top: 0; z-index: 100;
      box-shadow: 0 2px 12px rgba(192,57,43,0.25);
    }
    .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
    .navbar-links { display: flex; align-items: center; gap: 2px; }
    .navbar-links a {
      color: rgba(255,255,255,0.88); text-decoration: none;
      font-size: 13px; padding: 6px 12px; border-radius: 8px; transition: background 0.15s;
    }
    .navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
    .btn-logout {
      background: rgba(255,255,255,0.15) !important; color: #fff !important;
      border: 1px solid rgba(255,255,255,0.35); margin-left: 8px; font-weight: 500;
    }

    .page-wrapper { max-width: 640px; margin: 40px auto; padding: 0 16px; }

    .back-link {
      display: inline-flex; align-items: center; gap: 6px;
      margin-bottom: 24px; color: var(--muted); font-size: .9rem; text-decoration: none;
    }
    .back-link:hover { color: var(--red); }

    .page-heading { text-align: center; margin-bottom: 32px; }
    .page-heading .icon-circle {
      width: 80px; height: 80px; background: var(--red-light); border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 16px; font-size: 2.2rem; color: var(--red);
    }
    .page-heading h1 { font-size: 1.9rem; font-weight: 700; }
    .page-heading p  { color: var(--muted); margin-top: 8px; font-size: .95rem; line-height: 1.6; }

    .alert {
      padding: 14px 18px; border-radius: var(--radius); margin-bottom: 24px;
      font-size: .92rem; display: flex; align-items: center; gap: 10px;
    }
    .alert-error   { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
    .alert-success { background: var(--green-bg); color: var(--green); border: 1px solid #86efac; }

    .card { background: var(--card); border-radius: var(--radius); box-shadow: var(--shadow); padding: 36px 40px; }

    .user-info { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 28px; }
    .info-item { background: #f8f8f8; border: 1.5px solid var(--border); border-radius: 8px; padding: 12px 16px; }
    .info-item .info-label {
      font-size: .75rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .06em; color: var(--muted); margin-bottom: 4px;
    }
    .info-item .info-value { font-size: .95rem; font-weight: 600; color: var(--text); }
    .blood-badge {
      display: inline-block; background: var(--red-light); color: var(--red);
      font-weight: 700; padding: 2px 10px; border-radius: 20px; font-size: .9rem;
    }

    .section-title {
      font-size: .8rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .07em; color: var(--muted); margin-bottom: 14px;
    }
    .checklist { list-style: none; display: flex; flex-direction: column; gap: 10px; margin-bottom: 28px; }
    .checklist li { display: flex; align-items: flex-start; gap: 10px; font-size: .93rem; line-height: 1.5; }
    .checklist li .check-icon { color: var(--red); font-size: 1rem; margin-top: 2px; flex-shrink: 0; }

    .divider { border: none; border-top: 1.5px dashed var(--border); margin: 24px 0; }

    .confirm-section {
      display: flex; align-items: flex-start; gap: 12px; margin-bottom: 24px;
      padding: 14px 16px; background: #fffbf0;
      border: 1.5px solid #fcd34d; border-radius: 8px;
    }
    .confirm-section input[type="checkbox"] {
      width: 18px; height: 18px; margin-top: 2px;
      accent-color: var(--red); flex-shrink: 0; cursor: pointer;
    }
    .confirm-section label { font-size: .9rem; color: #78350f; line-height: 1.5; cursor: pointer; }

    .btn-submit {
      display: flex; align-items: center; justify-content: center; gap: 10px;
      width: 100%; padding: 14px; background: var(--red); color: #fff;
      border: none; border-radius: 8px; font-size: 1rem; font-weight: 700;
      cursor: pointer; transition: background .2s, opacity .2s; font-family: inherit;
    }
    .btn-submit:hover:not(:disabled) { background: var(--red-dark); }
    .btn-submit:disabled { opacity: 0.5; cursor: not-allowed; }

    .already-donor-card { text-align: center; padding: 40px 20px; }
    .already-donor-card .big-icon { font-size: 3.5rem; color: var(--green); margin-bottom: 16px; }
    .already-donor-card h2 { font-size: 1.4rem; font-weight: 700; margin-bottom: 8px; }
    .already-donor-card p  { color: var(--muted); font-size: .93rem; margin-bottom: 24px; }
    .btn-outline {
      display: inline-flex; align-items: center; gap: 8px; padding: 10px 22px;
      border: 2px solid var(--red); color: var(--red); border-radius: 8px;
      font-weight: 600; font-size: .93rem; text-decoration: none; transition: all .2s;
    }
    .btn-outline:hover { background: var(--red); color: #fff; }

    @media (max-width: 560px) {
      .user-info { grid-template-columns: 1fr; }
      .card { padding: 24px 18px; }
      .navbar { padding: 0 1rem; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
  <div class="navbar-links">
    <a href="<%= request.getContextPath() %>/userDashboard.jsp">Home</a>
    <a href="<%= request.getContextPath() %>/searchBlood.jsp">Search Blood</a>
    <a href="<%= request.getContextPath() %>/donationCamp.jsp">Donation Camps</a>
    <a href="<%= request.getContextPath() %>/donationHistory.jsp">Donation History</a>
    <a href="<%= request.getContextPath() %>/profile.jsp">My Profile</a>
    <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="page-wrapper">

  <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="back-link">
    <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
  </a>

  <div class="page-heading">
    <div class="icon-circle"><i class="fa-solid fa-hand-holding-droplet"></i></div>
    <h1>Become a Donor</h1>
    <p>Register as a blood donor and help save lives.<br/>Actual donations are recorded by admin after you attend a camp.</p>
  </div>

  <% if (successMsg != null && !successMsg.isEmpty()) { %>
  <div class="alert alert-success">
    <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
  </div>
  <% } %>

  <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
  <div class="alert alert-error">
    <i class="fa-solid fa-circle-exclamation"></i> <%= errorMsg %>
  </div>
  <% } %>

  <div class="card">

    <% if (isAlreadyDonor) { %>

    <div class="already-donor-card">
      <div class="big-icon"><i class="fa-solid fa-circle-check"></i></div>
      <h2>You're already a registered donor!</h2>
      <p>Browse upcoming camps, attend one, and the admin will record your donation after the camp day.</p>
      <a href="<%= request.getContextPath() %>/donationCamp.jsp" class="btn-outline">
        <i class="fa-solid fa-calendar-days"></i> View Donation Camps
      </a>
    </div>

    <% } else { %>

    <p class="section-title">Your Account Details</p>
    <div class="user-info">
      <div class="info-item">
        <div class="info-label">Full Name</div>
        <div class="info-value"><%= currentUser.getFullName() %></div>
      </div>
      <div class="info-item">
        <div class="info-label">Email</div>
        <div class="info-value"><%= currentUser.getEmail() %></div>
      </div>
      <div class="info-item">
        <div class="info-label">Blood Type</div>
        <div class="info-value">
          <span class="blood-badge"><%= currentUser.getBloodType() != null ? currentUser.getBloodType() : "Not set" %></span>
        </div>
      </div>
      <div class="info-item">
        <div class="info-label">Eligibility Status</div>
        <div class="info-value" style="color: var(--green);">
          <i class="fa-solid fa-check"></i> Will be set to Eligible
        </div>
      </div>
    </div>

    <hr class="divider"/>

    <p class="section-title">Donor Requirements</p>
    <ul class="checklist">
      <li>
        <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
        You are at least <strong>18 years old</strong> and weigh above <strong>50 kg</strong>.
      </li>
      <li>
        <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
        You are in <strong>good health</strong> and not currently on antibiotics.
      </li>
      <li>
        <span class="check-icon"><i class="fa-solid fa-circle-check"></i></span>
        At least <strong>3 months</strong> must pass between donations.
      </li>
    </ul>

    <hr class="divider"/>

    <form action="<%= request.getContextPath() %>/become-donor" method="post" id="donorForm">
      <div class="confirm-section">
        <input type="checkbox" id="confirmCheck"/>
        <label for="confirmCheck">
          I confirm that I meet all the requirements above and I voluntarily register as a blood donor on LifeFlow.
        </label>
      </div>
      <button type="submit" class="btn-submit" id="submitBtn" disabled>
        <i class="fa-solid fa-heart-pulse"></i> Confirm — Register as Donor
      </button>
    </form>

    <% } %>
  </div>
</div>

<script>
  const checkbox  = document.getElementById('confirmCheck');
  const submitBtn = document.getElementById('submitBtn');
  if (checkbox && submitBtn) {
    checkbox.addEventListener('change', function () {
      submitBtn.disabled = !this.checked;
    });
    document.getElementById('donorForm').addEventListener('submit', function () {
      submitBtn.disabled = true;
      submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Registering…';
    });
  }
</script>
</body>
</html>