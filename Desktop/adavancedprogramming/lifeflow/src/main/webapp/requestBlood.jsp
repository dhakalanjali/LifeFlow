<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Blood | LifeFlow Blood Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #C0392B; --red-dark: #96281B; --red-light: #fde8e8;
            --red-border: #f5b7b1; --bg: #f4f4f0; --white: #ffffff;
            --text: #1a1a1a; --text-muted: #6b7280; --border: rgba(0,0,0,0.08);
            --shadow: 0 2px 12px rgba(0,0,0,0.07);
            --green: #27ae60; --orange: #e67e22;
            --radius: 14px; --radius-sm: 8px;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Nunito', sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* ── NAVBAR — matches userDashboard ── */
        .navbar { background: var(--red); padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 200; box-shadow: 0 2px 12px rgba(192,57,43,0.25); }
        .navbar .logo { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar .nav-links { display: flex; align-items: center; gap: 2px; }
        .navbar .nav-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; font-weight: 500; white-space: nowrap; }
        .navbar .nav-links a:hover  { background: rgba(255,255,255,0.15); color: #fff; }
        .navbar .nav-links a.active { background: rgba(255,255,255,0.22); color: #fff; font-weight: 600; }
        .navbar .nav-links a.logout { background: rgba(255,255,255,0.15); color: #fff !important; border: 1px solid rgba(255,255,255,0.35); margin-left: 6px; }
        .navbar .nav-links a.logout:hover { background: rgba(255,255,255,0.28); }

        /* hamburger */
        .hamburger { display: none; flex-direction: column; gap: 5px; cursor: pointer; padding: 4px; background: none; border: none; }
        .hamburger span { display: block; width: 22px; height: 2px; background: #fff; border-radius: 2px; transition: all 0.3s; }
        .hamburger.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .hamburger.open span:nth-child(2) { opacity: 0; }
        .hamburger.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
        .mobile-menu { display: none; flex-direction: column; background: var(--red-dark); padding: 10px 1.5rem; gap: 2px; position: sticky; top: 60px; z-index: 99; }
        .mobile-menu.open { display: flex; }
        .mobile-menu a { color: rgba(255,255,255,0.9); text-decoration: none; font-size: 14px; font-weight: 500; padding: 10px 0; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .mobile-menu a:last-child { border-bottom: none; }

        /* ── PAGE HEADER ── */
        .page-header { background: linear-gradient(135deg, var(--red-dark), var(--red)); color: white; padding: 2.5rem 2rem; text-align: center; position: relative; overflow: hidden; }
        .page-header::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E"); }
        .page-header-inner { position: relative; }
        .page-header h1 { font-size: 2rem; font-weight: 800; margin-bottom: 0.4rem; }
        .page-header p { font-size: 0.95rem; opacity: 0.85; }

        /* ── MAIN WRAPPER ── */
        .main-wrapper { max-width: 820px; margin: 0 auto 3rem auto; padding: 28px 20px; }

        /* ── ALERTS ── */
        .alert { padding: 14px 18px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 20px; }
        .alert.success { background: #eafaf1; border-left: 4px solid var(--green); color: #1e8449; }
        .alert.error   { background: var(--red-light); border-left: 4px solid var(--red); color: var(--red-dark); }

        /* ── SESSION BANNER ── */
        .session-banner { background: var(--red-light); border-left: 4px solid var(--red); padding: 12px 18px; border-radius: 0 10px 10px 0; font-size: 13px; color: var(--red-dark); font-weight: 600; margin-bottom: 20px; }

        /* ── FORM CARD ── */
        .form-card { background: var(--white); border-radius: var(--radius); box-shadow: var(--shadow); overflow: hidden; }
        .form-card-header { background: var(--red-light); padding: 18px 24px; border-bottom: 1px solid var(--red-border); }
        .form-card-header h2 { font-size: 15px; font-weight: 800; color: var(--red-dark); }
        .form-card-body { padding: 24px; }

        /* ── FORM GRID ── */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { font-size: 12px; font-weight: 700; color: var(--text); text-transform: uppercase; letter-spacing: 0.5px; }
        .form-group label .req { color: var(--red); margin-left: 2px; }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%; padding: 10px 14px; border: 1.5px solid var(--border);
            border-radius: var(--radius-sm); font-size: 13px; font-family: 'Nunito', sans-serif;
            font-weight: 600; color: var(--text); background: var(--bg);
            transition: border 0.2s; outline: none;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus { border-color: var(--red); box-shadow: 0 0 0 3px rgba(192,57,43,0.1); background: white; }
        .form-group input::placeholder,
        .form-group textarea::placeholder { color: #bbb; }
        .form-group textarea { resize: vertical; min-height: 100px; }
        .form-group select { appearance: none; background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 0.9rem center; padding-right: 2.2rem; cursor: pointer; background-color: var(--bg); }
        .field-error { font-size: 11px; color: var(--red); display: none; font-weight: 600; }

        /* ── URGENCY ── */
        .urgency-group { display: flex; gap: 1rem; flex-wrap: wrap; margin-top: 4px; }
        .urgency-option { display: flex; align-items: center; gap: 6px; cursor: pointer; }
        .urgency-option input[type="radio"] { width: 16px; height: 16px; accent-color: var(--red); cursor: pointer; }
        .badge { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .badge-critical { background: #fdecea; color: var(--red); border: 1px solid #e74c3c; }
        .badge-urgent   { background: #fef5e7; color: #d35400; border: 1px solid #e67e22; }
        .badge-normal   { background: #eafaf1; color: #1e8449; border: 1px solid #27ae60; }

        /* ── VALIDATION ── */
        .validation-msg { display: none; padding: 12px 16px; border-radius: 10px; font-size: 13px; font-weight: 600; margin-bottom: 16px; background: var(--red-light); border-left: 4px solid var(--red); color: var(--red-dark); }

        /* ── FORM ACTIONS ── */
        .form-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 8px; grid-column: 1 / -1; }
        .btn-submit { padding: 10px 28px; background: var(--red); color: white; border: none; border-radius: var(--radius-sm); font-size: 13px; font-weight: 800; font-family: 'Nunito', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { background: var(--red-dark); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }
        .btn-reset { padding: 10px 22px; background: var(--bg); color: var(--text-muted); border: 1.5px solid var(--border); border-radius: var(--radius-sm); font-size: 13px; font-weight: 700; font-family: 'Nunito', sans-serif; cursor: pointer; }
        .btn-reset:hover { background: var(--border); }

        /* ── INFO NOTE ── */
        .info-note { background: var(--red-light); border-radius: 10px; padding: 14px 18px; margin-top: 20px; font-size: 13px; color: var(--red-dark); font-weight: 600; display: flex; gap: 10px; }

        /* ── FOOTER ── */
        footer { background: #1a1a1a; color: rgba(255,255,255,0.45); text-align: center; padding: 1.25rem; font-size: 12px; font-weight: 500; margin-top: 2rem; }
        footer a { color: rgba(255,255,255,0.65); text-decoration: none; }

        /* ── RESPONSIVE ── */
        @media(max-width: 768px) {
            .navbar { padding: 0 1.25rem; }
            .navbar .nav-links { display: none; }
            .hamburger { display: flex; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full { grid-column: 1; }
            .form-actions { flex-direction: column-reverse; }
            .btn-submit, .btn-reset { width: 100%; text-align: center; }
        }
    </style>
</head>
<body>

<!-- NAVBAR — matches userDashboard -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="logo">&#10084; LifeFlow</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp" class="active">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="logout">Logout</a>
    </div>
    <button class="hamburger" id="hamburger" onclick="toggleMenu()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
</nav>

<!-- MOBILE MENU -->
<div class="mobile-menu" id="mobileMenu">
    <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
    <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
    <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
    <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
    <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
    <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
    <a href="${pageContext.request.contextPath}/about.jsp">About</a>
    <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<!-- PAGE HEADER -->
<div class="page-header">
    <div class="page-header-inner">
        <h1>&#128137; Request Blood</h1>
        <p>Fill in the details below to submit an urgent blood request</p>
    </div>
</div>

<main class="main-wrapper">

    <div class="session-banner">
        &#128075; Welcome, <strong><%= currentUser.getFullName() %></strong>. Please fill in the blood request form below.
    </div>

    <%
        String successMsg = (String) request.getAttribute("successMessage");
        String errorMsg   = (String) request.getAttribute("errorMessage");
    %>
    <% if(successMsg != null) { %>
    <div class="alert success">&#9989; <%= successMsg %></div>
    <% } %>
    <% if(errorMsg != null) { %>
    <div class="alert error">&#9888;&#65039; <%= errorMsg %></div>
    <% } %>

    <div class="form-card">
        <div class="form-card-header">
            <h2>&#128203; Patient Blood Request Form</h2>
        </div>
        <div class="form-card-body">

            <div class="validation-msg" id="validationError"></div>

            <form id="bloodRequestForm" action="<%=request.getContextPath()%>/BloodRequestServlet" method="post" novalidate>

                <input type="hidden" name="userId" value="<%= currentUser.getUserId() %>">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="patientName">Patient Name <span class="req">*</span></label>
                        <input type="text" id="patientName" name="patientName" placeholder="e.g. Hari Prasad" maxlength="100"
                               value="<%= request.getParameter("patientName") != null ? request.getParameter("patientName") : "" %>">
                        <span class="field-error" id="patientNameError">Please enter the patient's full name.</span>
                    </div>

                    <div class="form-group">
                        <label for="bloodGroup">Blood Group <span class="req">*</span></label>
                        <select id="bloodGroup" name="bloodGroup">
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
                        <span class="field-error" id="bloodGroupError">Please select a blood group.</span>
                    </div>

                    <div class="form-group">
                        <label for="hospitalName">Hospital / Clinic Name <span class="req">*</span></label>
                        <input type="text" id="hospitalName" name="hospitalName" placeholder="e.g. Durga Mata Hospital" maxlength="150"
                               value="<%= request.getParameter("hospitalName") != null ? request.getParameter("hospitalName") : "" %>">
                        <span class="field-error" id="hospitalNameError">Please enter the hospital name.</span>
                    </div>

                    <div class="form-group">
                        <label for="contactNumber">Contact Number <span class="req">*</span></label>
                        <input type="tel" id="contactNumber" name="contactNumber" placeholder="e.g. 9841 000123" maxlength="15"
                               value="<%= request.getParameter("contactNumber") != null ? request.getParameter("contactNumber") : "" %>">
                        <span class="field-error" id="contactNumberError">Please enter a valid phone number.</span>
                    </div>

                    <div class="form-group">
                        <label for="requestDate">Required By Date <span class="req">*</span></label>
                        <input type="date" id="requestDate" name="requestDate">
                        <span class="field-error" id="requestDateError">Please select a valid future date.</span>
                    </div>

                    <div class="form-group">
                        <label>Urgency Level <span class="req">*</span></label>
                        <div class="urgency-group">
                            <label class="urgency-option">
                                <input type="radio" name="urgencyLevel" value="Critical">
                                <span class="badge badge-critical">&#128308; Critical</span>
                            </label>
                            <label class="urgency-option">
                                <input type="radio" name="urgencyLevel" value="Urgent">
                                <span class="badge badge-urgent">&#128992; Urgent</span>
                            </label>
                            <label class="urgency-option">
                                <input type="radio" name="urgencyLevel" value="Normal" checked>
                                <span class="badge badge-normal">&#128994; Normal</span>
                            </label>
                        </div>
                        <span class="field-error" id="urgencyError">Please select an urgency level.</span>
                    </div>

                    <div class="form-group full">
                        <label for="additionalNotes">Additional Notes</label>
                        <textarea id="additionalNotes" name="additionalNotes"
                                  placeholder="Any additional information about the patient's condition..." maxlength="500"></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="reset" class="btn-reset" onclick="clearValidation()">Reset</button>
                        <button type="submit" class="btn-submit">&#128137; Submit Request</button>
                    </div>

                </div>
            </form>
        </div>
    </div>

    <div class="info-note">
        <span>&#8505;&#65039;</span>
        <span>All blood requests are reviewed by our medical team within <strong>30 minutes</strong>.
        For life-threatening emergencies, please call <strong>102</strong> immediately.</span>
    </div>

</main>

<footer>
    &copy; 2026 LifeFlow Blood Bank &mdash; <a href="contact.jsp">Contact Us</a>
</footer>

<script>
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('requestDate').setAttribute('min', today);

    function toggleMenu() {
        document.getElementById('mobileMenu').classList.toggle('open');
        document.getElementById('hamburger').classList.toggle('open');
    }

    function clearValidation() {
        document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, select, textarea').forEach(el => el.style.borderColor = '');
        document.getElementById('validationError').style.display = 'none';
    }

    document.getElementById('bloodRequestForm').addEventListener('submit', function(e) {
        clearValidation();
        let valid = true; const errors = [];

        const name = document.getElementById('patientName').value.trim();
        if(name.length < 2) { document.getElementById('patientName').style.borderColor='#c0392b'; document.getElementById('patientNameError').style.display='block'; errors.push('Patient name is required.'); valid = false; }

        const blood = document.getElementById('bloodGroup').value;
        if(!blood) { document.getElementById('bloodGroup').style.borderColor='#c0392b'; document.getElementById('bloodGroupError').style.display='block'; errors.push('Blood group must be selected.'); valid = false; }

        const hospital = document.getElementById('hospitalName').value.trim();
        if(hospital.length < 2) { document.getElementById('hospitalName').style.borderColor='#c0392b'; document.getElementById('hospitalNameError').style.display='block'; errors.push('Hospital name is required.'); valid = false; }

        const contact = document.getElementById('contactNumber').value.trim();
        if(!/^[\d\s\+\-\(\)]{7,15}$/.test(contact)) { document.getElementById('contactNumber').style.borderColor='#c0392b'; document.getElementById('contactNumberError').style.display='block'; errors.push('A valid contact number is required.'); valid = false; }

        const date = document.getElementById('requestDate').value;
        if(!date || date < today) { document.getElementById('requestDate').style.borderColor='#c0392b'; document.getElementById('requestDateError').style.display='block'; errors.push('A valid future date is required.'); valid = false; }

        if(!valid) {
            e.preventDefault();
            const box = document.getElementById('validationError');
            box.innerHTML = '&#9888;&#65039; Please fix the following:<ul style="margin-top:6px;padding-left:18px;">' + errors.map(e => `<li>${e}</li>`).join('') + '</ul>';
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
