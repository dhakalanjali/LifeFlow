<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.Donor" %>
<%@ page import="com.lifeflow.lifeflow.model.DonationCamp" %>
<%@ page import="java.util.List" %>
<%
  User currentUser = (User) session.getAttribute("user");
  if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
  Donor donor = (Donor) request.getAttribute("donor");
  boolean isDonor = donor != null;
  List<DonationCamp> camps = (List<DonationCamp>) request.getAttribute("camps");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Donate Blood – LifeFlow</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --red: #C0392B; --red-dark: #96281B; --red-light: #FADBD8;
      --bg: #f4f4f0; --card: #FFFFFF; --text: #1a1a1a;
      --muted: #6b7280; --border: #e5e7eb;
      --green: #16a34a; --green-bg: #dcfce7;
      --radius: 14px; --radius-sm: 8px; --shadow: 0 4px 24px rgba(0,0,0,.08);
    }
    body { font-family: 'Plus Jakarta Sans', Arial, sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }


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
      font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s;
    }
    .navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
    .btn-logout {
      background: rgba(255,255,255,0.15) !important; color: #fff !important;
      border: 1px solid rgba(255,255,255,0.35); margin-left: 8px; font-weight: 500;
      border-radius: var(--radius-sm);
    }

    .page-wrapper { max-width: 760px; margin: 40px auto; padding: 0 16px; }

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
    .page-heading p  { color: var(--muted); margin-top: 8px; font-size: .95rem; }

    .card { background: var(--card); border-radius: var(--radius); box-shadow: var(--shadow); padding: 32px 36px; margin-bottom: 24px; }

    .section-title {
      font-size: .8rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .07em; color: var(--muted); margin-bottom: 16px;
    }

    /* Not a donor banner */
    .not-donor-banner { text-align: center; padding: 40px 24px; }
    .not-donor-banner .big-icon { font-size: 3.5rem; color: var(--muted); margin-bottom: 16px; }
    .not-donor-banner h2 { font-size: 1.4rem; font-weight: 700; margin-bottom: 10px; }
    .not-donor-banner p  { color: var(--muted); font-size: .93rem; margin-bottom: 24px; line-height: 1.6; }
    .btn-become {
      display: inline-flex; align-items: center; gap: 10px;
      padding: 13px 28px; background: var(--red); color: #fff;
      border-radius: 8px; font-weight: 700; font-size: 1rem;
      text-decoration: none; transition: background .2s;
    }
    .btn-become:hover { background: var(--red-dark); }

    /* Donor status grid */
    .donor-info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
    .info-item { background: #f8f8f8; border: 1.5px solid var(--border); border-radius: 8px; padding: 14px 16px; }
    .info-item .info-label {
      font-size: .75rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .06em; color: var(--muted); margin-bottom: 6px;
    }
    .info-item .info-value { font-size: .95rem; font-weight: 600; color: var(--text); }
    .badge { display: inline-block; font-weight: 700; padding: 3px 12px; border-radius: 20px; font-size: .85rem; }
    .badge-green { background: var(--green-bg); color: var(--green); }
    .badge-red   { background: var(--red-light); color: var(--red); }

    .divider { border: none; border-top: 1.5px dashed var(--border); margin: 24px 0; }

    /* Info box */
    .info-box {
      background: var(--red-light); border-left: 4px solid var(--red);
      border-radius: 8px; padding: 14px 18px; margin-bottom: 24px;
      font-size: .88rem; color: #7b241c; line-height: 1.7;
    }

    /* Camps list */
    .camp-list { display: flex; flex-direction: column; gap: 14px; }
    .camp-card {
      display: flex; align-items: center; justify-content: space-between;
      padding: 16px 20px; border: 1.5px solid var(--border);
      border-radius: 10px; background: #fafafa; transition: border-color .2s;
    }
    .camp-card:hover { border-color: var(--red); }
    .camp-name { font-size: 1rem; font-weight: 700; margin-bottom: 4px; }
    .camp-meta { font-size: .85rem; color: var(--muted); display: flex; gap: 16px; }
    .camp-meta span { display: flex; align-items: center; gap: 5px; }
    .btn-wishlist {
      display: inline-flex; align-items: center; gap: 7px;
      padding: 8px 18px; border: 2px solid var(--red); color: var(--red);
      border-radius: 8px; font-weight: 600; font-size: .88rem;
      text-decoration: none; transition: all .2s; white-space: nowrap;
    }
    .btn-wishlist:hover { background: var(--red); color: #fff; }

    .no-camps { text-align: center; padding: 32px; color: var(--muted); font-size: .95rem; }
    .no-camps i { font-size: 2rem; margin-bottom: 10px; display: block; }

    @media (max-width: 768px) {
      .navbar { padding: 0 1rem; }
      .navbar-links { display: none; }
      .donor-info-grid { grid-template-columns: 1fr 1fr; }
      .camp-card { flex-direction: column; align-items: flex-start; gap: 12px; }
      .card { padding: 20px 16px; }
    }
  </style>
</head>
<body>

<nav class="navbar">
  <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
  <div class="navbar-links">
    <a href="<%= request.getContextPath() %>/userDashboard.jsp">Home</a>
    <a href="<%= request.getContextPath() %>/searchBlood.jsp">Search Blood</a>
    <a href="<%= request.getContextPath() %>/requestBlood.jsp">Request Blood</a>
    <a href="<%= request.getContextPath() %>/donationHistory.jsp">Donation History</a>
    <a href="<%= request.getContextPath() %>/wishlist.jsp">My Wishlist</a>
    <a href="<%= request.getContextPath() %>/profile.jsp">My Profile</a>
    <a href="<%= request.getContextPath() %>/about.jsp">About</a>
    <a href="<%= request.getContextPath() %>/contact.jsp">Contact</a>
    <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Logout</a>
  </div>
</nav>

<div class="page-wrapper">

  <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="back-link">
    <i class="fa-solid fa-arrow-left"></i> Back to Dashboard
  </a>

  <div class="page-heading">
    <div class="icon-circle"><i class="fa-solid fa-droplet"></i></div>
    <h1>Donate Blood</h1>
    <p><%= isDonor ? "You are a registered donor. Find a camp and show up to donate." : "Register as a donor first, then find a camp near you." %></p>
  </div>

  <% if (!isDonor) { %>
  <div class="card">
    <div class="not-donor-banner">
      <div class="big-icon"><i class="fa-solid fa-hand-holding-droplet"></i></div>
      <h2>You are not registered as a donor yet</h2>
      <p>
        To donate blood, you first need to register as a donor.<br/>
        It only takes a few seconds — just confirm you meet the basic requirements.
      </p>
      <a href="<%= request.getContextPath() %>/become-donor" class="btn-become">
        <i class="fa-solid fa-heart-pulse"></i> Become a Donor
      </a>
    </div>
  </div>

  <% } else { %>

  <div class="card">
    <p class="section-title">Your Donor Status</p>
    <div class="donor-info-grid">
      <div class="info-item">
        <div class="info-label">Name</div>
        <div class="info-value"><%= currentUser.getFullName() %></div>
      </div>
      <div class="info-item">
        <div class="info-label">Blood Type</div>
        <div class="info-value"><%= currentUser.getBloodType() != null ? currentUser.getBloodType() : "N/A" %></div>
      </div>
      <div class="info-item">
        <div class="info-label">Eligibility</div>
        <div class="info-value">
          <% if ("yes".equalsIgnoreCase(donor.getIsEligible())) { %>
          <span class="badge badge-green"><i class="fa-solid fa-check"></i> Eligible</span>
          <% } else { %>
          <span class="badge badge-red"><i class="fa-solid fa-xmark"></i> Not Eligible</span>
          <% } %>
        </div>
      </div>
      <div class="info-item">
        <div class="info-label">Last Donation</div>
        <div class="info-value">
          <%= donor.getLastDonationDate() != null ? donor.getLastDonationDate() : "No donation yet" %>
        </div>
      </div>
    </div>
  </div>

  <div class="info-box">
    <strong><i class="fa-solid fa-circle-info"></i> How donating works:</strong><br/>
    Wishlist a camp below → Attend physically on the camp day →
    Admin records your donation → It appears in your Donation History.
  </div>

  <div class="card">
    <p class="section-title">Upcoming Donation Camps</p>
    <% if (camps == null || camps.isEmpty()) { %>
    <div class="no-camps">
      <i class="fa-solid fa-calendar-xmark"></i>
      No upcoming camps right now. Check back soon!
    </div>
    <% } else { %>
    <div class="camp-list">
      <% for (DonationCamp camp : camps) { %>
      <div class="camp-card">
        <div>
          <div class="camp-name"><%= camp.getName() %></div>
          <div class="camp-meta">
            <span><i class="fa-solid fa-location-dot"></i> <%= camp.getLocation() %></span>
            <span><i class="fa-solid fa-calendar"></i> <%= camp.getDate() %></span>
          </div>
        </div>
        <a href="<%= request.getContextPath() %>/wishlist?campId=<%= camp.getId() %>" class="btn-wishlist">
          <i class="fa-solid fa-bookmark"></i> Wishlist
        </a>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>

  <% } %>

</div>
</body>
</html>
