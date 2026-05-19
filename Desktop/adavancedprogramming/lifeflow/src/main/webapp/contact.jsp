<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdmin = currentUser != null && "admin".equals(currentUser.getRole());
    boolean isUser  = currentUser != null && !isAdmin;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | LifeFlow Blood Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #c0392b;
            --red-dark: #a93226;
            --red-light: #f9ebea;
            --bg: #f0f2f5;
            --white: #ffffff;
            --text: #2c3e50;
            --text-muted: #7f8c8d;
            --border: #e8ecef;
            --shadow: 0 2px 12px rgba(0,0,0,0.08);
            --green: #27ae60;
            --radius-sm: 8px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Nunito', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; line-height: 1.6; }

        /* ── SIDEBAR (admin only) ── */
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
        .main { flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .main.with-sidebar { margin-left: 240px; }

        /* ── ADMIN TOPBAR ── */
        .admin-topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .admin-topbar h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* ── USER NAVBAR (red, matches userDashboard.jsp) ── */
        .user-navbar { background: #C0392B; padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 200; box-shadow: 0 2px 12px rgba(192,57,43,0.25); font-family: 'Plus Jakarta Sans', Arial, sans-serif; }
        .user-navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .user-navbar-links { display: flex; align-items: center; gap: 2px; }
        .user-navbar-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; }
        .user-navbar-links a:hover { background: rgba(255,255,255,0.15); color: #fff; }
        .user-navbar-links a.active { background: rgba(255,255,255,0.2); color: #fff; font-weight: 600; }
        .btn-user-logout { background: rgba(255,255,255,0.15) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.35) !important; margin-left: 8px; font-weight: 500; border-radius: var(--radius-sm); padding: 6px 12px; text-decoration: none; font-size: 13px; }
        .btn-user-logout:hover { background: rgba(255,255,255,0.28) !important; }

        /* ── GUEST NAVBAR (white, matches index.jsp) ── */
        .guest-navbar { background-color: #ffffff; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 200; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .guest-navbar .logo { color: #C0392B; font-size: 26px; font-weight: 800; text-decoration: none; }
        .guest-navbar .nav-links { display: flex; align-items: center; }
        .guest-navbar .nav-links a { color: #2C3E50; text-decoration: none; margin-left: 20px; font-size: 15px; font-weight: normal; transition: color 0.2s; }
        .guest-navbar .nav-links a:hover { color: #C0392B; }
        .guest-navbar .nav-links a.active { color: #C0392B; font-weight: normal; }
        .btn-nav-login { background-color: #C0392B !important; color: white !important; padding: 8px 20px; border-radius: 25px; font-weight: 800 !important; }
        .btn-nav-login:hover { background-color: black !important; }
        .btn-nav-register { background-color: transparent !important; color: #C0392B !important; padding: 8px 20px; border-radius: 25px; border: 2px solid #C0392B; font-weight: 800 !important; }
        .btn-nav-register:hover { background-color: black !important; color: white !important; border-color: black !important; }
        .hamburger { display: none; flex-direction: column; cursor: pointer; gap: 5px; background: none; border: none; padding: 5px; }
        .hamburger span { width: 25px; height: 3px; background: #C0392B; border-radius: 3px; display: block; }

        /* ── EMERGENCY BANNER ── */
        .emergency-banner { background: var(--red); color: white; text-align: center; padding: 10px 2rem; font-size: 13px; font-weight: 600; }

        /* ── PAGE HEADER ── */
        .page-header { background: linear-gradient(135deg, var(--red-dark), var(--red)); color: white; padding: 3rem 2rem; text-align: center; position: relative; overflow: hidden; }
        .page-header::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E"); }
        .page-header-inner { position: relative; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 0.4rem; }
        .page-header p { font-size: 0.95rem; opacity: 0.85; }

        /* ── CONTENT ── */
        .main-wrapper { max-width: 1100px; margin: 0 auto; padding: 3rem 2rem; }
        .contact-layout { display: grid; grid-template-columns: 1fr 1.6fr; gap: 2.5rem; align-items: start; }

        /* ── INFO CARDS ── */
        .contact-info { display: flex; flex-direction: column; gap: 1.25rem; }
        .info-card { background: var(--white); border-radius: 14px; padding: 1.5rem; box-shadow: var(--shadow); display: flex; gap: 1rem; align-items: flex-start; transition: all 0.2s; border-left: 4px solid transparent; }
        .info-card:hover { transform: translateY(-2px); border-left-color: var(--red); }
        .card-icon { font-size: 1.5rem; width: 46px; height: 46px; background: var(--red-light); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .info-card h3 { font-size: 13px; font-weight: 800; color: var(--text); margin-bottom: 5px; }
        .info-card p { font-size: 13px; color: var(--text-muted); font-weight: 600; }
        .info-card a { color: var(--text-muted); text-decoration: none; font-weight: 600; font-size: 13px; }
        .info-card a:hover { color: var(--red); }
        .map-placeholder { background: linear-gradient(135deg, var(--red-light), #fde8e8); border-radius: 14px; height: 160px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.5rem; border: 2px dashed #e0b0b0; margin-top: 1.25rem; }
        .map-placeholder p { font-size: 0.85rem; color: var(--text-muted); font-weight: 600; }

        /* ── FORM ── */
        .form-card { background: var(--white); border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; }
        .form-card-header { background: #fdecea; padding: 18px 24px; border-bottom: 1px solid var(--border); }
        .form-card-header h2 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .form-card-header p { font-size: 12px; color: var(--text-muted); margin-top: 3px; font-weight: 600; }
        .form-card-body { padding: 24px; }
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { font-size: 12px; font-weight: 700; color: var(--text); text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group label .req { color: var(--red); margin-left: 2px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-family: 'Nunito', sans-serif; font-weight: 600; color: var(--text); background: var(--bg); transition: border 0.2s; outline: none; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .form-group input::placeholder, .form-group textarea::placeholder { color: #bbb; }
        .form-group textarea { resize: vertical; min-height: 130px; }
        .form-group select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 0.9rem center; padding-right: 2.2rem; cursor: pointer; background-color: var(--bg); }
        .field-error { font-size: 11px; color: var(--red); display: none; font-weight: 600; }
        .alert { padding: 12px 16px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .alert.success { background: #eafaf1; border-left: 4px solid var(--green); color: #1e8449; }
        .alert.error { background: #fdecea; border-left: 4px solid var(--red); color: var(--red-dark); display: none; }
        .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 8px; grid-column: 1 / -1; }
        .btn-submit { padding: 10px 28px; background: var(--red); color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { background: var(--red-dark); transform: translateY(-1px); }
        .btn-clear { padding: 10px 22px; background: var(--bg); color: var(--text-muted); border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; }
        .btn-clear:hover { background: var(--border); }

        /* ── FOOTER ── */
        footer { background: #1a252f; color: rgba(255,255,255,0.65); text-align: center; padding: 1.5rem; font-size: 0.85rem; font-weight: 600; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }

        /* ── RESPONSIVE ── */
        @media(max-width: 900px) { .contact-layout { grid-template-columns: 1fr; } }
        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main.with-sidebar { margin-left: 0; }
            .user-navbar { padding: 0 1rem; }
            .user-navbar-links { display: none; }
            .guest-navbar { padding: 15px 20px; }
            .hamburger { display: flex; }
            .guest-navbar .nav-links { display: none; flex-direction: column; position: absolute; top: 64px; left: 0; right: 0; background: white; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); gap: 10px; z-index: 99; }
            .guest-navbar .nav-links.open { display: flex; }
            .guest-navbar .nav-links a { margin-left: 0; padding: 8px 0; border-bottom: 1px solid #f0f0f0; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .form-actions { flex-direction: column-reverse; }
            .main-wrapper { padding: 2rem 1rem; }
        }
    </style>
</head>
<body>

<!-- ── ADMIN SIDEBAR ── -->
<% if(isAdmin) { %>
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">🩸</div>
        <span>LifeFlow</span>
    </div>
    <div class="sidebar-section">Admin Panel</div>
    <nav class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="icon">🏠</span> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers"><span class="icon">👥</span> Manage Users</a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp"><span class="icon">⛺</span> Manage Camps</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp"><span class="icon">🩸</span> Blood Stock</a>
        <a href="${pageContext.request.contextPath}/bloodRequest"><span class="icon">🔍</span> Search Blood</a>
        <a href="${pageContext.request.contextPath}/reports.jsp"><span class="icon">📊</span> Reports</a>
        <a href="${pageContext.request.contextPath}/about.jsp"><span class="icon">ℹ️</span> About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp" class="active"><span class="icon">📞</span> Contact</a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout"><span class="icon">🚪</span> Logout</a>
    </div>
</aside>
<% } %>

<!-- ── MAIN ── -->
<div class="main <%= isAdmin ? "with-sidebar" : "" %>">

    <!-- ══ ADMIN TOPBAR ══ -->
    <% if(isAdmin) { %>
    <header class="admin-topbar">
        <h2>📞 Contact</h2>
        <div class="topbar-admin">
            <div class="admin-avatar">A</div>
            <span class="admin-name">Admin</span>
        </div>
    </header>

    <!-- ══ USER NAVBAR (red, matches userDashboard.jsp) ══ -->
    <% } else if(isUser) { %>
    <nav class="user-navbar">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="user-navbar-brand">&#10084; LifeFlow</a>
        <div class="user-navbar-links">
            <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
            <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
            <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
            <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp" class="active">Contact</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn-user-logout">Logout</a>
        </div>
    </nav>

    <!-- ══ GUEST NAVBAR (white, matches index.jsp) ══ -->
    <% } else { %>
    <nav class="guest-navbar">
        <a href="index.jsp" class="logo">🩸 LifeFlow</a>
        <button class="hamburger" onclick="toggleMenu()">
            <span></span><span></span><span></span>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="index.jsp#features">Features</a>
            <a href="index.jsp#how-it-works">How it Works</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp" class="active">Contact</a>
            <a href="<%=request.getContextPath()%>/login" class="btn-nav-login">Login</a>
            <a href="<%=request.getContextPath()%>/register" class="btn-nav-register">Register</a>
        </div>
    </nav>
    <% } %>

    <!-- EMERGENCY BANNER -->
    <div class="emergency-banner">
        🚨 For life-threatening emergencies, call <strong>102</strong> immediately. Blood Bank Helpline: <strong>01 422 1234</strong>
    </div>

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div class="page-header-inner">
            <h1>📞 Contact Us</h1>
            <p>Get in touch with our team for enquiries, support, or to learn more about donating blood</p>
        </div>
    </div>

    <main class="main-wrapper">
        <%
            String successMsg = (String) request.getAttribute("contactSuccess");
            String errorMsg   = (String) request.getAttribute("contactError");
        %>
        <% if(successMsg != null) { %>
        <div class="alert success">✅ <%= successMsg %></div>
        <% } %>
        <% if(errorMsg != null) { %>
        <div class="alert error" style="display:block;">⚠️ <%= errorMsg %></div>
        <% } %>

        <div class="contact-layout">
            <aside>
                <div class="contact-info">
                    <article class="info-card">
                        <div class="card-icon">📍</div>
                        <div><h3>Our Address</h3><p>LifeFlow Blood Bank<br>Bagbazar, Kathmandu 44600<br>Nepal</p></div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">📞</div>
                        <div><h3>Phone Numbers</h3><p>General: <a href="tel:014221234">01 422 1234</a></p><p style="margin-top:4px;">Emergency (24/7): <a href="tel:014229999">01 422 9999</a></p></div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">📧</div>
                        <div><h3>Email</h3><p>General: <a href="mailto:info@lifeflow.org.np">info@lifeflow.org.np</a></p><p style="margin-top:4px;">Donations: <a href="mailto:donate@lifeflow.org.np">donate@lifeflow.org.np</a></p></div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">🕐</div>
                        <div><h3>Opening Hours</h3><p>Mon – Fri: 8:00am – 8:00pm</p><p>Saturday: 9:00am – 5:00pm</p><p>Sunday: 10:00am – 3:00pm</p><p style="margin-top:6px; color:var(--red); font-weight:800;">Emergency: 24/7</p></div>
                    </article>
                </div>
                <div class="map-placeholder">
                    <div style="font-size:2.5rem;">🗺️</div>
                    <p>Bagbazar, Kathmandu 44600</p>
                </div>
            </aside>

            <section>
                <div class="form-card">
                    <div class="form-card-header">
                        <h2>✉️ Send Us a Message</h2>
                        <p>We'll get back to you within 24 hours</p>
                    </div>
                    <div class="form-card-body">
                        <div class="alert error" id="validationError"></div>
                        <form id="contactForm" action="ContactServlet" method="post" novalidate>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="fullName">Full Name <span class="req">*</span></label>
                                    <input type="text" id="fullName" name="fullName" placeholder="e.g. Sita Thapa" maxlength="100" value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                                    <span class="field-error" id="fullNameError">Please enter your full name.</span>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email Address <span class="req">*</span></label>
                                    <input type="email" id="email" name="email" placeholder="e.g. sita@example.com" maxlength="150" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                                    <span class="field-error" id="emailError">Please enter a valid email.</span>
                                </div>
                                <div class="form-group full">
                                    <label for="subject">Subject <span class="req">*</span></label>
                                    <select id="subject" name="subject">
                                        <option value="">— Select a Subject —</option>
                                        <option value="Blood Request Enquiry">Blood Request Enquiry</option>
                                        <option value="Donation Information">Donation Information</option>
                                        <option value="Stock Availability">Stock Availability</option>
                                        <option value="Partnership / Hospital">Partnership / Hospital</option>
                                        <option value="Complaint or Feedback">Complaint or Feedback</option>
                                        <option value="Other">Other</option>
                                    </select>
                                    <span class="field-error" id="subjectError">Please select a subject.</span>
                                </div>
                                <div class="form-group full">
                                    <label for="message">Message <span class="req">*</span></label>
                                    <textarea id="message" name="message" placeholder="Please describe your enquiry in detail..." maxlength="1000"></textarea>
                                    <span class="field-error" id="messageError">Message must be at least 10 characters.</span>
                                </div>
                                <div class="form-actions">
                                    <button type="reset" class="btn-clear" onclick="clearValidation()">Clear</button>
                                    <button type="submit" class="btn-submit">📨 Send Message</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <footer>
        <p>&copy; 2026 LifeFlow Blood Bank &mdash; <a href="about.jsp">About Us</a></p>
    </footer>
</div>

<script>
    function toggleMenu() {
        const n = document.getElementById('navLinks');
        if(n) n.classList.toggle('open');
    }
    const guestLinks = document.querySelectorAll('#navLinks a');
    if(guestLinks) guestLinks.forEach(l => l.addEventListener('click', () => {
        const n = document.getElementById('navLinks');
        if(n) n.classList.remove('open');
    }));
    function clearValidation() {
        document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, select, textarea').forEach(el => el.style.borderColor = '');
        document.getElementById('validationError').style.display = 'none';
    }
    document.getElementById('contactForm').addEventListener('submit', function(e) {
        clearValidation();
        let valid = true; const errors = [];
        const name = document.getElementById('fullName').value.trim();
        if(name.length < 2) { document.getElementById('fullName').style.borderColor='#c0392b'; document.getElementById('fullNameError').style.display='block'; errors.push('Full name is required.'); valid = false; }
        const email = document.getElementById('email').value.trim();
        if(!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { document.getElementById('email').style.borderColor='#c0392b'; document.getElementById('emailError').style.display='block'; errors.push('A valid email is required.'); valid = false; }
        const subject = document.getElementById('subject').value;
        if(!subject) { document.getElementById('subject').style.borderColor='#c0392b'; document.getElementById('subjectError').style.display='block'; errors.push('Please select a subject.'); valid = false; }
        const msg = document.getElementById('message').value.trim();
        if(msg.length < 10) { document.getElementById('message').style.borderColor='#c0392b'; document.getElementById('messageError').style.display='block'; errors.push('Message must be at least 10 characters.'); valid = false; }
        if(!valid) {
            e.preventDefault();
            const box = document.getElementById('validationError');
            box.innerHTML = '⚠️ Please fix the following:<ul style="margin-top:6px;padding-left:18px;">' + errors.map(e => `<li>${e}</li>`).join('') + '</ul>';
            box.style.display = 'block';
            box.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    });
    document.querySelectorAll('input, select, textarea').forEach(el => {
        el.addEventListener('input', function() {
            this.style.borderColor = '';
            const err = document.getElementById(this.id + 'Error');
            if(err) err.style.display = 'none';
        });
    });
</script>
</body>
</html>
