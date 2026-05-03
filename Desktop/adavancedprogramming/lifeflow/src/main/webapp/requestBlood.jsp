<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%--
    requestBlood.jsp
    Author: Pritam Rai
    Module: Blood Request Form
    Description: Allows patients or users to submit a blood request.
    Tribhuvan University - Blood Bank Management System
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Submit an urgent blood request at LifeFlow Blood Bank. Fill in patient details, blood group, hospital, and urgency level.">
    <title>Request Blood | LifeFlow Blood Bank</title>
    <style>
        /* =============================================
           GLOBAL RESET & BASE STYLES
        ============================================= */
        * { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --primary-red: #c0392b;
            --dark-red: #96281b;
            --light-red: #f9ebea;
            --accent-red: #e74c3c;
            --white: #ffffff;
            --light-gray: #f4f6f7;
            --mid-gray: #bdc3c7;
            --dark-gray: #2c3e50;
            --text-muted: #7f8c8d;
            --success-green: #27ae60;
            --border-radius: 8px;
            --shadow: 0 2px 12px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-gray);
            color: var(--dark-gray);
            line-height: 1.6;
        }

        /* NAV */
        nav {
            background-color: var(--primary-red);
            padding: 0 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            height: 64px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-brand span { color: var(--white); font-size: 1.3rem; font-weight: 700; }
        .nav-links { display: flex; list-style: none; gap: 0.5rem; align-items: center; }
        .nav-links a { color: rgba(255,255,255,0.88); text-decoration: none; padding: 0.5rem 1rem; border-radius: var(--border-radius); font-size: 0.95rem; transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { background-color: rgba(255,255,255,0.2); color: var(--white); }
        .hamburger { display: none; flex-direction: column; cursor: pointer; gap: 5px; }
        .hamburger span { width: 25px; height: 3px; background: var(--white); border-radius: 3px; transition: var(--transition); }

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--dark-red) 0%, var(--primary-red) 100%);
            color: var(--white);
            padding: 2.5rem 2rem;
            text-align: center;
        }
        .page-header h1 { font-size: 2rem; font-weight: 700; margin-bottom: 0.4rem; }
        .page-header p { font-size: 1rem; opacity: 0.88; }

        /* SESSION BANNER */
        .session-banner {
            background-color: var(--light-red);
            border-left: 4px solid var(--primary-red);
            padding: 0.75rem 1.5rem;
            margin: 1.5rem auto;
            max-width: 820px;
            border-radius: 0 var(--border-radius) var(--border-radius) 0;
            font-size: 0.95rem;
            color: var(--dark-red);
        }

        /* MAIN WRAPPER */
        .main-wrapper { max-width: 820px; margin: 0 auto 3rem auto; padding: 0 1.5rem; }

        /* FORM CARD */
        .form-card {
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            padding: 2.5rem;
            margin-top: 1.5rem;
        }
        .form-card h2 {
            font-size: 1.3rem;
            color: var(--primary-red);
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--light-red);
        }

        /* FORM GRID */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
        .form-group { display: flex; flex-direction: column; gap: 0.4rem; }
        .form-group.full-width { grid-column: 1 / -1; }

        label { font-size: 0.88rem; font-weight: 600; color: var(--dark-gray); }
        label .required { color: var(--accent-red); margin-left: 2px; }

        /* INPUTS */
        input[type="text"], input[type="tel"], input[type="date"], select, textarea {
            width: 100%; padding: 0.65rem 0.9rem;
            border: 1.5px solid var(--mid-gray);
            border-radius: var(--border-radius);
            font-size: 0.95rem; font-family: inherit;
            color: var(--dark-gray); background-color: #fdfdfd;
            transition: var(--transition); outline: none;
        }
        input:focus, select:focus, textarea:focus {
            border-color: var(--primary-red);
            box-shadow: 0 0 0 3px rgba(192,57,43,0.12);
        }
        input::placeholder, textarea::placeholder { color: var(--mid-gray); font-size: 0.9rem; }
        textarea { resize: vertical; min-height: 100px; }
        select {
            cursor: pointer; appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat; background-position: right 0.9rem center; padding-right: 2.2rem;
        }

        /* URGENCY RADIO */
        .urgency-group { display: flex; gap: 1rem; flex-wrap: wrap; margin-top: 0.2rem; }
        .urgency-option { display: flex; align-items: center; gap: 6px; cursor: pointer; }
        .urgency-option input[type="radio"] { width: 16px; height: 16px; accent-color: var(--primary-red); cursor: pointer; }
        .badge { padding: 3px 10px; border-radius: 20px; font-size: 0.82rem; font-weight: 600; }
        .badge-critical { background: #fdecea; color: #c0392b; border: 1px solid #e74c3c; }
        .badge-urgent   { background: #fef5e7; color: #d35400; border: 1px solid #e67e22; }
        .badge-normal   { background: #eafaf1; color: #1e8449; border: 1px solid #27ae60; }

        /* VALIDATION */
        /* validation-msg sits ABOVE the grid, not inside it */
        .validation-msg { display: none; padding: 0.75rem 1rem; border-radius: var(--border-radius); font-size: 0.9rem; margin-bottom: 1rem; }
        .validation-msg.error { background-color: #fdecea; border-left: 4px solid var(--accent-red); color: var(--dark-red); }
        .server-msg { padding: 0.75rem 1rem; border-radius: var(--border-radius); font-size: 0.9rem; margin-bottom: 1rem; }
        .server-msg.success { background-color: #eafaf1; border-left: 4px solid var(--success-green); color: #1e8449; }
        .server-msg.error { background-color: #fdecea; border-left: 4px solid var(--accent-red); color: var(--dark-red); }
        .field-error { font-size: 0.8rem; color: var(--accent-red); display: none; }

        /* BUTTONS */
        /* form-actions is inside the grid so needs full-width span */
        .form-actions { display: flex; gap: 1rem; justify-content: flex-end; margin-top: 1.5rem; grid-column: 1 / -1; }
        .btn { padding: 0.7rem 2rem; border: none; border-radius: var(--border-radius); font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: var(--transition); font-family: inherit; }
        .btn-primary { background-color: var(--primary-red); color: var(--white); }
        .btn-primary:hover { background-color: var(--dark-red); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }
        .btn-secondary { background-color: var(--light-gray); color: var(--dark-gray); border: 1.5px solid var(--mid-gray); }
        .btn-secondary:hover { background-color: var(--mid-gray); }

        /* INFO NOTE */
        .info-note { background-color: var(--light-red); border-radius: var(--border-radius); padding: 1rem 1.25rem; margin-top: 1.5rem; font-size: 0.88rem; color: var(--dark-red); display: flex; gap: 10px; align-items: flex-start; }

        /* FOOTER */
        footer { background-color: var(--dark-gray); color: rgba(255,255,255,0.7); text-align: center; padding: 1.25rem; font-size: 0.85rem; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            nav { padding: 0 1rem; }
            .nav-links { display: none; flex-direction: column; position: absolute; top: 64px; left: 0; right: 0; background-color: var(--dark-red); padding: 1rem; gap: 0.25rem; }
            .nav-links.open { display: flex; }
            .hamburger { display: flex; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: 1; }
            .form-actions { flex-direction: column-reverse; }
            .btn { width: 100%; text-align: center; }
            .page-header h1 { font-size: 1.5rem; }
        }
        @media (max-width: 480px) {
            .form-card { padding: 1.5rem 1rem; }
            .urgency-group { flex-direction: column; gap: 0.5rem; }
        }
    </style>
</head>
<body>

<nav role="navigation" aria-label="Main navigation">
    <a href="index.jsp" class="nav-brand">
        <span>&#129656; LifeFlow Blood Bank</span>
    </a>
    <div class="hamburger" id="hamburger" role="button" tabindex="0" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </div>
    <ul class="nav-links" id="navLinks">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="requestBlood.jsp" class="active" aria-current="page">Request Blood</a></li>
        <li><a href="reports.jsp">Reports</a></li>
        <li><a href="about.jsp">About</a></li>
        <li><a href="contact.jsp">Contact</a></li>
    </ul>
</nav>

<header class="page-header" role="banner">
    <h1>&#129656; Request Blood</h1>
    <p>Fill in the details below to submit an urgent blood request</p>
</header>

<main class="main-wrapper" role="main">

    <%-- Session greeting --%>
    <%
        String sessionUser = (String) session.getAttribute("username");
        if (sessionUser != null && !sessionUser.isEmpty()) {
    %>
    <div class="session-banner" role="status">
        &#128075; Welcome back, <strong><%= sessionUser %></strong>. Please fill in the blood request form below.
    </div>
    <% } %>

    <%-- Server-side feedback --%>
    <%
        String successMsg = (String) request.getAttribute("successMessage");
        String errorMsg   = (String) request.getAttribute("errorMessage");
    %>
    <% if (successMsg != null) { %>
        <div class="server-msg success" role="alert">&#10003; <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="server-msg error" role="alert">&#9888; <%= errorMsg %></div>
    <% } %>

    <section class="form-card" aria-labelledby="formTitle">
        <h2 id="formTitle">&#128203; Patient Blood Request Form</h2>

        <form id="bloodRequestForm" action="BloodRequestServlet" method="post" novalidate>

            <%-- Client-side validation summary - placed OUTSIDE the grid so it spans full width --%>
            <div class="validation-msg error" id="validationError" role="alert" aria-live="assertive"></div>

            <div class="form-grid">

                <!-- Patient Name -->
                <div class="form-group">
                    <label for="patientName">Patient Name <span class="required">*</span></label>
                    <input type="text" id="patientName" name="patientName"
                           placeholder="e.g. Hari Prasad" maxlength="100" autocomplete="name"
                           value="<%= request.getParameter("patientName") != null ? request.getParameter("patientName") : "" %>">
                    <span class="field-error" id="patientNameError">Please enter the patient's full name.</span>
                </div>

                <!-- Blood Group -->
                <div class="form-group">
                    <label for="bloodGroup">Blood Group <span class="required">*</span></label>
                    <select id="bloodGroup" name="bloodGroup">
                        <option value="">-- Select Blood Group --</option>
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

                <!-- Hospital Name -->
                <div class="form-group">
                    <label for="hospitalName">Hospital / Clinic Name <span class="required">*</span></label>
                    <input type="text" id="hospitalName" name="hospitalName"
                           placeholder="e.g. Durga Mata Hospital" maxlength="150"
                           value="<%= request.getParameter("hospitalName") != null ? request.getParameter("hospitalName") : "" %>">
                    <span class="field-error" id="hospitalNameError">Please enter the hospital or clinic name.</span>
                </div>

                <!-- Contact Number -->
                <div class="form-group">
                    <label for="contactNumber">Contact Number <span class="required">*</span></label>
                    <input type="tel" id="contactNumber" name="contactNumber"
                           placeholder="e.g. 9841 000123" maxlength="15" autocomplete="tel"
                           value="<%= request.getParameter("contactNumber") != null ? request.getParameter("contactNumber") : "" %>">
                    <span class="field-error" id="contactNumberError">Please enter a valid phone number.</span>
                </div>

                <!-- Required Date -->
                <div class="form-group">
                    <label for="requestDate">Required By Date <span class="required">*</span></label>
                    <input type="date" id="requestDate" name="requestDate">
                    <span class="field-error" id="requestDateError">Please select a valid future date.</span>
                </div>

                <!-- Urgency Level -->
                <div class="form-group">
                    <label id="urgencyLabel">Urgency Level <span class="required">*</span></label>
                    <div class="urgency-group" role="radiogroup" aria-labelledby="urgencyLabel" aria-required="true">
                        <label class="urgency-option">
                            <input type="radio" name="urgencyLevel" value="Critical" aria-label="Critical urgency">
                            <span class="badge badge-critical">&#128308; Critical</span>
                        </label>
                        <label class="urgency-option">
                            <input type="radio" name="urgencyLevel" value="Urgent" aria-label="Urgent">
                            <span class="badge badge-urgent">&#128992; Urgent</span>
                        </label>
                        <label class="urgency-option">
                            <input type="radio" name="urgencyLevel" value="Normal" checked aria-label="Normal urgency">
                            <span class="badge badge-normal">&#128994; Normal</span>
                        </label>
                    </div>
                    <span class="field-error" id="urgencyError">Please select an urgency level.</span>
                </div>

                <!-- Additional Notes -->
                <div class="form-group full-width">
                    <label for="additionalNotes">Additional Notes</label>
                    <textarea id="additionalNotes" name="additionalNotes"
                              placeholder="Any additional information about the patient's condition or special requirements..."
                              maxlength="500"></textarea>
                </div>

                <!-- Buttons -->
                <div class="form-actions">
                    <button type="reset" class="btn btn-secondary" onclick="clearValidation()">Reset</button>
                    <button type="submit" class="btn btn-primary">Submit Request</button>
                </div>

            </div>
        </form>
    </section>

    <div class="info-note" role="note">
        <span>&#8505;&#65039;</span>
        <span>All blood requests are reviewed by our medical team within <strong>30 minutes</strong>.
        For life-threatening emergencies, please call <strong>999</strong> immediately.</span>
    </div>

</main>

<footer role="contentinfo">
    <p>&copy; 2024 LifeFlow Blood Bank Management System &mdash; Tribhuvan University |
        <a href="contact.jsp">Contact Us</a></p>
</footer>

<script>
    const hamburger = document.getElementById('hamburger');
    const navLinks  = document.getElementById('navLinks');
    hamburger.addEventListener('click', () => navLinks.classList.toggle('open'));

    // Set min date to today
    const dateInput = document.getElementById('requestDate');
    const today = new Date().toISOString().split('T')[0];
    dateInput.setAttribute('min', today);

    function clearValidation() {
        document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, select, textarea').forEach(el => el.style.borderColor = '');
        document.getElementById('validationError').style.display = 'none';
    }

    function showFieldError(fieldId, errorId) {
        document.getElementById(fieldId).style.borderColor = '#e74c3c';
        document.getElementById(errorId).style.display = 'block';
    }

    function validateForm() {
        clearValidation();
        let isValid = true;
        const errors = [];

        const patientName = document.getElementById('patientName').value.trim();
        if (patientName.length < 2) {
            showFieldError('patientName', 'patientNameError');
            errors.push('Patient name is required.');
            isValid = false;
        }

        const bloodGroup = document.getElementById('bloodGroup').value;
        if (!bloodGroup) {
            showFieldError('bloodGroup', 'bloodGroupError');
            errors.push('Blood group must be selected.');
            isValid = false;
        }

        const hospitalName = document.getElementById('hospitalName').value.trim();
        if (hospitalName.length < 2) {
            showFieldError('hospitalName', 'hospitalNameError');
            errors.push('Hospital name is required.');
            isValid = false;
        }

        const contactNumber = document.getElementById('contactNumber').value.trim();
        if (!/^[\d\s\+\-\(\)]{7,15}$/.test(contactNumber)) {
            showFieldError('contactNumber', 'contactNumberError');
            errors.push('A valid contact number is required.');
            isValid = false;
        }

        const requestDate = document.getElementById('requestDate').value;
        if (!requestDate || requestDate < today) {
            showFieldError('requestDate', 'requestDateError');
            errors.push('A valid future date is required.');
            isValid = false;
        }

        if (!isValid) {
            const errorBox = document.getElementById('validationError');
            errorBox.innerHTML = '&#9888; Please fix the following: <ul style="margin-top:6px;padding-left:18px;">'
                + errors.map(e => '<li>' + e + '</li>').join('') + '</ul>';
            errorBox.style.display = 'block';
            errorBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return isValid;
    }

    document.getElementById('bloodRequestForm').addEventListener('submit', function(e) {
        if (!validateForm()) e.preventDefault();
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
