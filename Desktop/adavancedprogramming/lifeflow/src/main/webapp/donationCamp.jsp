<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.model.DonationCamp" %>
<%@ page import="com.lifeflow.lifeflow.dao.DonationCampDAO" %>
<%@ page import="java.util.List" %>
<%
  User currentUser = (User) session.getAttribute("user");
  if(currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  DonationCampDAO campDAO = new DonationCampDAO();
  List<DonationCamp> camps = campDAO.getAllCamps();

  String successMsg = (String) session.getAttribute("successMessage");
  String errorMsg   = (String) session.getAttribute("errorMessage");
  if(successMsg != null) session.removeAttribute("successMessage");
  if(errorMsg   != null) session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Donation Camps - LifeFlow</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
      --red:        #C0392B;
      --red-dark:   #96281B;
      --red-light:  #fde8e8;
      --red-border: #f5b7b1;
      --bg:         #f4f4f0;
      --card:       #ffffff;
      --text:       #1a1a1a;
      --muted:      #6b7280;
      --border:     rgba(0,0,0,0.08);
      --radius:     14px;
      --radius-sm:  8px;
      --green:      #27ae60;
    }

    html, body {
      width: 100%;
      min-height: 100vh;
      font-family: 'Plus Jakarta Sans', Arial, sans-serif;
      background: var(--bg);
      color: var(--text);
    }

    /* NAVBAR */
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
    .navbar-brand {
      color: #fff;
      font-size: 18px;
      font-weight: 600;
      text-decoration: none;
    }
    .navbar-links {
      display: flex;
      align-items: center;
      gap: 2px;
    }
    .navbar-links a {
      color: rgba(255,255,255,0.88);
      text-decoration: none;
      font-size: 13px;
      padding: 6px 12px;
      border-radius: var(--radius-sm);
      transition: background 0.15s;
    }
    .navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
    .navbar-links a.active {
      background: rgba(255,255,255,0.2);
      color: #fff;
      font-weight: 600;
    }
    .btn-logout {
      background: rgba(255,255,255,0.15) !important;
      color: #fff !important;
      border: 1px solid rgba(255,255,255,0.35);
      margin-left: 8px;
      font-weight: 500;
      border-radius: var(--radius-sm);
    }
    .btn-logout:hover { background: rgba(255,255,255,0.28) !important; }

    /* PAGE HEADER */
    .page-header {
      background: linear-gradient(135deg, var(--red-dark), var(--red));
      color: #fff;
      padding: 2.5rem 2.5rem 2rem;
      display: flex;
      align-items: flex-end;
      justify-content: space-between;
      gap: 1rem;
    }
    .page-header-left h1 { font-size: 22px; font-weight: 600; margin-bottom: 4px; }
    .page-header-left p  { font-size: 13px; opacity: 0.82; }
    .page-header-right   { display: flex; gap: 10px; flex-shrink: 0; }

    /* BUTTONS */
    .btn {
      display: inline-flex; align-items: center; gap: 6px;
      padding: 9px 18px; border-radius: var(--radius-sm);
      font-size: 13px; font-weight: 500; cursor: pointer;
      text-decoration: none; border: none; transition: all 0.15s;
      font-family: inherit;
    }
    .btn-white { background: #fff; color: var(--red); }
    .btn-white:hover { background: var(--red-light); }
    .btn-outline-white {
      background: rgba(255,255,255,0.15);
      color: #fff;
      border: 1px solid rgba(255,255,255,0.4);
    }
    .btn-outline-white:hover { background: rgba(255,255,255,0.25); }

    /* CONTAINER */
    .container { width: 100%; padding: 1.5rem 2.5rem; }

    /* ALERTS */
    .alert {
      padding: 12px 16px;
      border-radius: var(--radius-sm);
      font-size: 13px;
      font-weight: 500;
      margin-bottom: 1.25rem;
      border-left: 3px solid;
    }
    .alert.success { background: #f0faf5; border-color: var(--green); color: #1a6e40; }
    .alert.error   { background: var(--red-light); border-color: var(--red); color: var(--red-dark); }

    /* SECTION TITLE */
    .section-title {
      font-size: 15px; font-weight: 600; color: var(--text);
      margin-bottom: 1rem;
      display: flex; align-items: center; gap: 8px;
    }
    .section-title::before {
      content: ''; display: block;
      width: 3px; height: 17px;
      background: var(--red); border-radius: 2px;
    }

    /* CAMPS GRID */
    .camps-grid {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 16px;
    }

    /* CAMP CARD */
    .camp-card {
      background: var(--card);
      border: 0.5px solid var(--border);
      border-radius: var(--radius);
      overflow: hidden;
      transition: border-color 0.15s, transform 0.15s, box-shadow 0.15s;
      border-top: 3px solid var(--red);
    }
    .camp-card:hover {
      transform: translateY(-3px);
      box-shadow: 0 6px 20px rgba(192,57,43,0.12);
      border-color: var(--red-border);
    }
    .camp-card-body  { padding: 1.25rem 1.25rem 1rem; }
    .camp-name { font-size: 15px; font-weight: 600; color: var(--text); margin-bottom: 12px; }
    .camp-detail {
      display: flex; align-items: center; gap: 8px;
      font-size: 12.5px; color: var(--muted); font-weight: 500;
      margin-bottom: 7px;
    }
    .detail-icon { font-size: 14px; width: 20px; text-align: center; flex-shrink: 0; }
    .camp-card-footer {
      padding: 12px 1.25rem;
      border-top: 0.5px solid var(--border);
      display: flex; justify-content: space-between; align-items: center;
      background: #fafafa;
    }
    .camp-date-badge {
      background: var(--red-light); color: var(--red-dark);
      font-size: 11px; font-weight: 600;
      padding: 4px 10px; border-radius: 20px;
      border: 0.5px solid var(--red-border);
    }
    .btn-wishlist {
      display: inline-flex; align-items: center; gap: 5px;
      padding: 7px 14px;
      background: var(--red); color: #fff;
      border: none; border-radius: var(--radius-sm);
      font-size: 12px; font-weight: 600;
      cursor: pointer; text-decoration: none;
      transition: all 0.15s; font-family: inherit;
    }
    .btn-wishlist:hover { background: var(--red-dark); transform: translateY(-1px); }

    /* EMPTY STATE */
    .empty {
      background: var(--card);
      border: 0.5px solid var(--border);
      border-radius: var(--radius);
      padding: 60px 20px;
      text-align: center;
    }
    .empty-icon { font-size: 52px; margin-bottom: 16px; }
    .empty h3   { font-size: 17px; font-weight: 600; margin-bottom: 6px; }
    .empty p    { font-size: 13px; color: var(--muted); }

    /* FOOTER */
    footer {
      background: #1a252f;
      color: rgba(255,255,255,0.6);
      text-align: center;
      padding: 1.25rem;
      font-size: 13px;
      margin-top: 2rem;
    }
    footer a { color: rgba(255,255,255,0.8); }

    /* RESPONSIVE */
    @media (max-width: 900px) { .camps-grid { grid-template-columns: repeat(2, 1fr); } }
    @media (max-width: 768px) {
      .navbar { padding: 0 1rem; }
      .navbar-links { display: none; }
      .container { padding: 1rem; }
      .page-header { flex-direction: column; align-items: flex-start; padding: 1.5rem 1rem; }
      .camps-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">&#10084; LifeFlow</a>
  <div class="navbar-links">
    <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
    <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
    <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
    <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
    <a href="${pageContext.request.contextPath}/donationCamp.jsp" class="active">Donation Camps</a>
    <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
    <a href="${pageContext.request.contextPath}/about.jsp">About</a>
    <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
  </div>
</nav>

<!-- PAGE HEADER -->
<div class="page-header">
  <div class="page-header-left">
    <h1>&#9978; Donation Camps</h1>
    <p>Browse upcoming blood donation camps and wishlist the ones you plan to attend</p>
  </div>
  <div class="page-header-right">
    <a href="${pageContext.request.contextPath}/wishlist.jsp" class="btn btn-outline-white">&#10084; My Wishlist</a>
    <a href="${pageContext.request.contextPath}/donationHistory.jsp" class="btn btn-white">&#128203; My Donations</a>
  </div>
</div>

<div class="container">

  <% if(successMsg != null) { %>
  <div class="alert success">&#9989; <%= successMsg %></div>
  <% } %>
  <% if(errorMsg != null) { %>
  <div class="alert error">&#10060; <%= errorMsg %></div>
  <% } %>

  <div class="section-title">Upcoming Camps (<%= camps != null ? camps.size() : 0 %> available)</div>

  <% if(camps == null || camps.isEmpty()) { %>
  <div class="empty">
    <div class="empty-icon">&#9978;</div>
    <h3>No Camps Available</h3>
    <p>There are no upcoming donation camps at the moment. Check back later!</p>
  </div>
  <% } else { %>
  <div class="camps-grid">
    <% for(DonationCamp camp : camps) { %>
    <div class="camp-card">
      <div class="camp-card-body">
        <div class="camp-name">&#9978; <%= camp.getName() %></div>
        <div class="camp-detail">
          <span class="detail-icon">&#128205;</span>
          <span><%= camp.getLocation() %></span>
        </div>
        <div class="camp-detail">
          <span class="detail-icon">&#128197;</span>
          <span><%= camp.getDate() %></span>
        </div>
        <div class="camp-detail">
          <span class="detail-icon">&#128100;</span>
          <span>Organised by <%= camp.getOrganizer() %></span>
        </div>
      </div>
      <div class="camp-card-footer">
        <span class="camp-date-badge"><%= camp.getDate() %></span>
        <%-- FIX: Use POST form to /addWishlist instead of broken GET link to /wishlist --%>
        <form action="<%=request.getContextPath()%>/addWishlist" method="post" style="display:inline;">
          <input type="hidden" name="campId" value="<%= camp.getId() %>"/>
          <button type="submit" class="btn-wishlist">&#10084; Wishlist</button>
        </form>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>

</div>

<footer>
  <p>&copy; 2026 LifeFlow Blood Bank &mdash; <a href="contact.jsp">Contact Us</a></p>
</footer>

</body>
</html>
