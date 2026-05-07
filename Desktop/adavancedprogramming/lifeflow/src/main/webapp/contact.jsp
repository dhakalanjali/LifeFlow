<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdmin = currentUser != null && "admin".equals(currentUser.getRole());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | LifeFlow Blood Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
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

        /* ── TOPBAR ── */
        .topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .topbar-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .topbar-brand .drop { width: 28px; height: 28px; background: var(--red); border-radius: 50% 50% 50% 0; transform: rotate(-45deg); flex-shrink: 0; }
        .topbar-brand span { color: var(--text); font-size: 18px; font-weight: 800; }
        .topbar-brand em { color: var(--red); font-style: normal; }
        .topbar-nav { display: flex; align-items: center; gap: 4px; }
        .topbar-nav a { color: var(--text-muted); text-decoration: none; font-size: 13px; font-weight: 600; padding: 7px 14px; border-radius: 8px; transition: all 0.2s; }
        .topbar-nav a:hover { color: var(--text); background: var(--bg); }
        .topbar-nav a.active { color: white; background: var(--red); }
        .topbar-nav a.logout { color: #e57373; }
        .topbar-nav a.logout:hover { background: var(--red-light); color: var(--red); }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* ── EMERGENCY BANNER ── */
        .emergency-banner { background: var(--red); color: white; text-align: center; padding: 12px 2rem; font-size: 13px; font-weight: 600; }
        .emergency-banner strong { font-size: 14px; }

        /* ── PAGE HEADER ── */
        .page-header { background: linear-gradient(135deg, var(--red-dark), var(--red)); color: white; padding: 3rem 2rem; text-align: center; position: relative; overflow: hidden; }
        .page-header::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E"); }
        .page-header-inner { position: relative; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 0.4rem; }
        .page-header p { font-size: 0.95rem; opacity: 0.88; }

        /* ── CONTENT ── */
        .main-wrapper { max-width: 1100px; margin: 0 auto; padding: 3rem 2rem; }
        .contact-layout { display: grid; grid-template-columns: 1fr 1.6fr; gap: 2.5rem; align-items: start; }

        /* ── SERVER MESSAGES ── */
        .server-msg { padding: 14px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 20px; }
        .server-msg.success { background: #eafaf1; border-left: 4px solid var(--green); color: #1e8449; }
        .server-msg.error   { background: #fdecea; border-left: 4px solid var(--red); color: var(--red-dark); }

        /* ── INFO CARDS ── */
        .contact-info { display: flex; flex-direction: column; gap: 1.25rem; }
        .info-card { background: var(--white); border-radius: 14px; padding: 1.5rem; box-shadow: var(--shadow); display: flex; gap: 1rem; align-items: flex-start; transition: all 0.2s; border-left: 4px solid transparent; }
        .info-card:hover { transform: translateY(-2px); border-left-color: var(--red); }
        .card-icon { font-size: 1.4rem; width: 46px; height: 46px; background: var(--red-light); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .info-card h3 { font-size: 13px; font-weight: 800; color: var(--text); margin-bottom: 5px; }
        .info-card p, .info-card a { font-size: 13px; color: var(--text-muted); text-decoration: none; font-weight: 600; line-height: 1.8; }
        .info-card a:hover { color: var(--red); }
        .info-card .emergency-text { color: var(--red); font-weight: 800; }

        /* ── MAP ── */
        .map-placeholder { background: linear-gradient(135deg, var(--red-light), #fde8e8); border-radius: 12px; height: 160px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.5rem; border: 2px dashed #e0b0b0; margin-top: 1.25rem; }
        .map-placeholder .map-icon { font-size: 2.5rem; }
        .map-placeholder p { font-size: 12px; color: var(--text-muted); font-weight: 600; }

        /* ── FORM CARD ── */
        .form-card { background: var(--white); border-radius: 14px; box-shadow: var(--shadow); overflow: hidden; }
        .form-card-header { background: #fdecea; padding: 18px 24px; border-bottom: 1px solid var(--border); }
        .form-card-header h2 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .form-card-header p { font-size: 12px; color: var(--text-muted); margin-top: 3px; font-weight: 600; }
        .form-card-body { padding: 24px; }

        /* ── FORM FIELDS ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group.full { grid-column: 1 / -1; }
        label { font-size: 12px; font-weight: 700; color: var(--text); text-transform: uppercase; letter-spacing: 0.5px; }
        label .req { color: var(--red); margin-left: 2px; }
        input[type="text"], input[type="email"], select, textarea {
            width: 100%; padding: 10px 14px; border: 1.5px solid var(--border); border-radius: 8px;
            font-size: 13px; font-family: 'Nunito', sans-serif; font-weight: 600; color: var(--text);
            background: var(--bg); transition: border 0.2s, box-shadow 0.2s; outline: none;
        }
        input:focus, select:focus, textarea:focus { border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        input::placeholder, textarea::placeholder { color: #bbb; font-size: 12px; }
        textarea { resize: vertical; min-height: 130px; }
        select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 0.9rem center; padding-right: 2.2rem; cursor: pointer; }
        .field-error { font-size: 11px; color: var(--red); display: none; font-weight: 600; }
        .validation-msg { display: none; padding: 12px 16px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 16px; }
        .validation-msg.error { background: #fdecea; border-left: 4px solid var(--red); color: var(--red-dark); }

        /* ── FORM ACTIONS ── */
        .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 8px; grid-column: 1 / -1; }
        .btn-submit { padding: 10px 28px; background: var(--red); color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { background: var(--red-dark); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }
        .btn-clear { padding: 10px 20px; background: var(--bg); color: var(--text-muted); border: 1.5px solid var(--border); border-radius: 8px; font-size: 13px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-clear:hover { background: var(--border); }

        /* ── FOOTER ── */
        footer { background: #1a252f; color: rgba(255,255,255,0.65); text-align: center; padding: 1.5rem; font-size: 0.85rem; font-weight: 600; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }
        footer a:hover { color: white; }

        /* ── RESPONSIVE ── */
        @media(max-width: 900px) { .contact-layout { grid-template-columns: 1fr; } }
        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main.with-sidebar { margin-left: 0; }
            .topbar-nav { display: none; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .form-actions { flex-direction: column-reverse; }
            .btn-submit, .btn-clear { width: 100%; text-align: center; }
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
        <a href="${pageContext.request.contextPath}/bloodRequest">
            <span class="icon">🔍</span> Search Blood
        </a>
        <a href="${pageContext.request.contextPath}/reports.jsp">
            <span class="icon">📊</span> Reports
        </a>
        <a href="${pageContext.request.contextPath}/about.jsp">
            <span class="icon">ℹ️</span> About
        </a>
        <a href="${pageContext.request.contextPath}/contact.jsp" class="active">
            <span class="icon">📞</span> Contact
        </a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout">
            <span class="icon">🚪</span> Logout
        </a>
    </div>
</aside>
<% } %>

<!-- ── MAIN ── -->
<div class="main <%= isAdmin ? "with-sidebar" : "" %>">

    <!-- TOPBAR -->
    <header class="topbar">
        <a href="index.jsp" class="topbar-brand">
            <div class="drop"></div>
            <span>&nbsp;Life<em>Flow</em></span>
        </a>
        <% if(isAdmin) { %>
        <div class="topbar-admin">
            <div class="admin-avatar">A</div>
            <span class="admin-name">Admin</span>
        </div>
        <% } else { %>
        <nav class="topbar-nav">
            <a href="index.jsp">Home</a>
            <a href="requestBlood.jsp">Request Blood</a>
            <a href="reports.jsp">Reports</a>
            <a href="about.jsp">About</a>
            <a href="contact.jsp" class="active">Contact</a>
            <% if(currentUser != null) { %>
            <a href="<%=request.getContextPath()%>/logout" class="logout">Logout</a>
            <% } else { %>
            <a href="<%=request.getContextPath()%>/login">Login</a>
            <% } %>
        </nav>
        <% } %>
    </header>

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
        <div class="server-msg success">✓ <%= successMsg %></div>
        <% } %>
        <% if(errorMsg != null) { %>
        <div class="server-msg error">⚠ <%= errorMsg %></div>
        <% } %>

        <div class="contact-layout">

            <!-- INFO CARDS -->
            <aside>
                <div class="contact-info">
                    <article class="info-card">
                        <div class="card-icon">📍</div>
                        <div>
                            <h3>Our Address</h3>
                            <p>LifeFlow Blood Bank<br>Bagbazar<br>Kathmandu 44600, Nepal</p>
                        </div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">📞</div>
                        <div>
                            <h3>Phone Numbers</h3>
                            <p>General Enquiries:<br><a href="tel:014221234">01 422 1234</a></p>
                            <p>Emergency Line (24/7):<br><a href="tel:014229999">01 422 9999</a></p>
                        </div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">✉️</div>
                        <div>
                            <h3>Email</h3>
                            <p>General: <a href="mailto:info@lifeflow.org.np">info@lifeflow.org.np</a></p>
                            <p>Donations: <a href="mailto:donate@lifeflow.org.np">donate@lifeflow.org.np</a></p>
                        </div>
                    </article>
                    <article class="info-card">
                        <div class="card-icon">🕐</div>
                        <div>
                            <h3>Opening Hours</h3>
                            <p>Monday – Friday: 8:00am – 8:00pm</p>
                            <p>Saturday: 9:00am – 5:00pm</p>
                            <p>Sunday: 10:00am – 3:00pm</p>
                            <p class="emergency-text">Emergency: 24/7</p>
                        </div>
                    </article>
                </div>
                <div class="map-placeholder">
                    <div class="map-icon">🗺️</div>
                    <p>Bagbazar, Kathmandu 44600</p>
                    <p>[Map integration placeholder]</p>
                </div>
            </aside>

            <!-- CONTACT FORM -->
            <section>
                <div class="form-card">
                    <div class="form-card-header">
                        <h2>✉️ Send Us a Message</h2>
                        <p>We'll get back to you within 24 hours</p>
                    </div>
                    <div class="form-card-body">
                        <div class="validation-msg error" id="validationError"></div>
                        <form id="contactForm" action="ContactServlet" method="post" novalidate>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label for="fullName">Full Name <span class="req">*</span></label>
                                    <input type="text" id="fullName" name="fullName" placeholder="e.g. Sita Thapa" maxlength="100"
                                           value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                                    <span class="field-error" id="fullNameError">Please enter your full name.</span>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email Address <span class="req">*</span></label>
                                    <input type="email" id="email" name="email" placeholder="e.g. sita@example.com" maxlength="150"
                                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
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
        <p>&copy; 2026 LifeFlow Blood Bank Management System &mdash; <a href="about.jsp">About Us</a></p>
    </footer>

</div>

<script>
    function clearValidation() {
        document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, select, textarea').forEach(el => el.style.borderColor = '');
        document.getElementById('validationError').style.display = 'none';
    }
    function showFieldError(fieldId, errorId) {
        document.getElementById(fieldId).style.borderColor = '#c0392b';
        document.getElementById(errorId).style.display = 'block';
    }
    function validateContactForm() {
        clearValidation();
        let isValid = true;
        const errors = [];
        const fullName = document.getElementById('fullName').value.trim();
        if (fullName.length < 2) { showFieldError('fullName', 'fullNameError'); errors.push('Full name is required.'); isValid = false; }
        const email = document.getElementById('email').value.trim();
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { showFieldError('email', 'emailError'); errors.push('A valid email address is required.'); isValid = false; }
        if (!document.getElementById('subject').value) { showFieldError('subject', 'subjectError'); errors.push('Please select a subject.'); isValid = false; }
        if (document.getElementById('message').value.trim().length < 10) { showFieldError('message', 'messageError'); errors.push('Message must be at least 10 characters.'); isValid = false; }
        if (!isValid) {
            const box = document.getElementById('validationError');
            box.innerHTML = '⚠ Please fix the following:<ul style="margin-top:6px;padding-left:18px;">' + errors.map(e => `<li>${e}</li>`).join('') + '</ul>';
            box.style.display = 'block';
            box.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return isValid;
    }
    document.getElementById('contactForm').addEventListener('submit', function(e) {
        if (!validateContactForm()) e.preventDefault();
    });
    document.querySelectorAll('input, select, textarea').forEach(el => {
        el.addEventListener('input', function() {
            this.style.borderColor = '';
            const err = document.getElementById(this.id + 'Error');
            if (err) err.style.display = 'none';
        });
    });
</script>
</body>
</html>
