<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    contact.jsp
    Author: Pritam Rai
    Module: Contact Page
    Description: Contact form and organisation contact details.
    Tribhuvan University - Blood Bank Management System
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Contact LifeFlow Blood Bank - send us a message, find our address, phone numbers, and opening hours in Kathmandu.">
    <title>Contact Us | LifeFlow Blood Bank</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #c0392b; --dark-red: #96281b; --light-red: #f9ebea;
            --accent-red: #e74c3c; --white: #ffffff; --light-gray: #f4f6f7;
            --mid-gray: #bdc3c7; --dark-gray: #2c3e50; --text-muted: #7f8c8d;
            --success-green: #27ae60; --border-radius: 8px;
            --shadow: 0 2px 12px rgba(0,0,0,0.1); --transition: all 0.3s ease;
        }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--light-gray); color: var(--dark-gray); line-height: 1.6; }

        /* NAV */
        nav { background-color: var(--primary-red); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 100; }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-brand span { color: var(--white); font-size: 1.3rem; font-weight: 700; }
        .nav-links { display: flex; list-style: none; gap: 0.5rem; align-items: center; }
        .nav-links a { color: rgba(255,255,255,0.88); text-decoration: none; padding: 0.5rem 1rem; border-radius: var(--border-radius); font-size: 0.95rem; transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { background-color: rgba(255,255,255,0.2); color: var(--white); }
        .hamburger { display: none; flex-direction: column; cursor: pointer; gap: 5px; }
        .hamburger span { width: 25px; height: 3px; background: var(--white); border-radius: 3px; }

        /* PAGE HEADER */
        .page-header { background: linear-gradient(135deg, var(--dark-red), var(--primary-red)); color: var(--white); padding: 3rem 2rem; text-align: center; }
        .page-header h1 { font-size: 2rem; font-weight: 700; margin-bottom: 0.4rem; }
        .page-header p { font-size: 1rem; opacity: 0.88; }

        /* MAIN LAYOUT */
        .main-wrapper { max-width: 1100px; margin: 0 auto; padding: 3rem 2rem; }
        .contact-layout { display: grid; grid-template-columns: 1fr 1.6fr; gap: 2.5rem; align-items: start; }

        /* CONTACT INFO CARDS */
        .contact-info { display: flex; flex-direction: column; gap: 1.25rem; }
        .info-card { background: var(--white); border-radius: 12px; padding: 1.5rem; box-shadow: var(--shadow); display: flex; gap: 1rem; align-items: flex-start; transition: var(--transition); }
        .info-card:hover { transform: translateY(-2px); }
        .info-card .card-icon { font-size: 1.6rem; width: 48px; height: 48px; background: var(--light-red); border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .info-card h3 { font-size: 0.95rem; color: var(--dark-gray); margin-bottom: 0.3rem; }
        .info-card p, .info-card a { font-size: 0.9rem; color: var(--text-muted); text-decoration: none; }
        .info-card a:hover { color: var(--primary-red); }

        /* MAP PLACEHOLDER */
        .map-placeholder { background: linear-gradient(135deg, var(--light-red), #fde8e8); border-radius: 12px; height: 180px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 0.5rem; border: 2px dashed var(--mid-gray); margin-top: 1.25rem; }
        .map-placeholder .map-icon { font-size: 2.5rem; }
        .map-placeholder p { font-size: 0.85rem; color: var(--text-muted); }

        /* CONTACT FORM CARD */
        .form-card { background: var(--white); border-radius: 12px; box-shadow: var(--shadow); padding: 2.5rem; }
        .form-card h2 { font-size: 1.3rem; color: var(--primary-red); margin-bottom: 1.5rem; padding-bottom: 0.75rem; border-bottom: 2px solid var(--light-red); }

        /* FORM ELEMENTS */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.25rem; }
        .form-group { display: flex; flex-direction: column; gap: 0.4rem; }
        .form-group.full-width { grid-column: 1 / -1; }
        label { font-size: 0.88rem; font-weight: 600; color: var(--dark-gray); }
        label .required { color: var(--accent-red); margin-left: 2px; }
        input[type="text"], input[type="email"], select, textarea {
            width: 100%; padding: 0.65rem 0.9rem; border: 1.5px solid var(--mid-gray);
            border-radius: var(--border-radius); font-size: 0.95rem; font-family: inherit;
            color: var(--dark-gray); background: #fdfdfd; transition: var(--transition); outline: none;
        }
        input:focus, select:focus, textarea:focus { border-color: var(--primary-red); box-shadow: 0 0 0 3px rgba(192,57,43,0.12); }
        input::placeholder, textarea::placeholder { color: var(--mid-gray); font-size: 0.9rem; }
        textarea { resize: vertical; min-height: 130px; }
        /* Custom select arrow - consistent with other pages */
        select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.9rem center;
            padding-right: 2.2rem;
            cursor: pointer;
        }
        .field-error { font-size: 0.8rem; color: var(--accent-red); display: none; }

        /* VALIDATION MESSAGES */
        .validation-msg { display: none; padding: 0.75rem 1rem; border-radius: var(--border-radius); font-size: 0.9rem; margin-bottom: 1rem; }
        .validation-msg.error { background: #fdecea; border-left: 4px solid var(--accent-red); color: var(--dark-red); }
        .validation-msg.success { background: #eafaf1; border-left: 4px solid var(--success-green); color: #1e8449; }
        .server-msg { padding: 0.75rem 1rem; border-radius: var(--border-radius); font-size: 0.9rem; margin-bottom: 1rem; }
        .server-msg.success { background: #eafaf1; border-left: 4px solid var(--success-green); color: #1e8449; }
        .server-msg.error { background: #fdecea; border-left: 4px solid var(--accent-red); color: var(--dark-red); }

        /* BUTTONS */
        .form-actions { display: flex; gap: 1rem; justify-content: flex-end; margin-top: 1.5rem; grid-column: 1 / -1; }
        .btn { padding: 0.7rem 2rem; border: none; border-radius: var(--border-radius); font-size: 0.95rem; font-weight: 600; cursor: pointer; transition: var(--transition); font-family: inherit; }
        .btn-primary { background: var(--primary-red); color: var(--white); }
        .btn-primary:hover { background: var(--dark-red); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(192,57,43,0.3); }
        .btn-secondary { background: var(--light-gray); color: var(--dark-gray); border: 1.5px solid var(--mid-gray); }
        .btn-secondary:hover { background: var(--mid-gray); }

        /* EMERGENCY BANNER */
        .emergency-banner { background: var(--primary-red); color: var(--white); text-align: center; padding: 1.25rem 2rem; }
        .emergency-banner p { font-size: 0.95rem; }
        .emergency-banner strong { font-size: 1.1rem; }

        /* FOOTER */
        footer { background-color: var(--dark-gray); color: rgba(255,255,255,0.7); text-align: center; padding: 1.25rem; font-size: 0.85rem; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }

        /* RESPONSIVE */
        @media (max-width: 900px) {
            .contact-layout { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            nav { padding: 0 1rem; }
            .nav-links { display: none; flex-direction: column; position: absolute; top: 64px; left: 0; right: 0; background-color: var(--dark-red); padding: 1rem; gap: 0.25rem; }
            .nav-links.open { display: flex; }
            .hamburger { display: flex; }
            .form-grid { grid-template-columns: 1fr; }
            .form-group.full-width { grid-column: 1; }
            .form-actions { flex-direction: column-reverse; }
            .btn { width: 100%; text-align: center; }
            .main-wrapper { padding: 2rem 1rem; }
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
        <li><a href="requestBlood.jsp">Request Blood</a></li>
        <li><a href="reports.jsp">Reports</a></li>
        <li><a href="about.jsp">About</a></li>
        <li><a href="contact.jsp" class="active" aria-current="page">Contact</a></li>
    </ul>
</nav>

<!-- EMERGENCY BANNER -->
<div class="emergency-banner" role="alert">
    <p>&#128680; For life-threatening emergencies, call <strong>102</strong> immediately. Blood Bank Helpline: <strong>01 422 1234</strong></p>
</div>

<!-- PAGE HEADER -->
<header class="page-header" role="banner">
    <h1>&#128222; Contact Us</h1>
    <p>Get in touch with our team for enquiries, support, or to learn more about donating blood</p>
</header>

<!-- MAIN CONTENT -->
<main class="main-wrapper" role="main">

    <%-- Server-side feedback after form submission --%>
    <%
        String successMsg = (String) request.getAttribute("contactSuccess");
        String errorMsg   = (String) request.getAttribute("contactError");
    %>
    <% if (successMsg != null) { %>
        <div class="server-msg success" role="alert">&#10003; <%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="server-msg error" role="alert">&#9888; <%= errorMsg %></div>
    <% } %>

    <div class="contact-layout">

        <!-- LEFT: CONTACT INFO CARDS + MAP -->
        <aside aria-label="Contact information">
            <div class="contact-info">

                <article class="info-card">
                    <div class="card-icon">&#128205;</div>
                    <div>
                        <h3>Our Address</h3>
                        <p>LifeFlow Blood Bank<br>
                           Bagbazar<br>
                           Kathmandu 44600<br>
                           Nepal</p>
                    </div>
                </article>

                <article class="info-card">
                    <div class="card-icon">&#128222;</div>
                    <div>
                        <h3>Phone Numbers</h3>
                        <p>General Enquiries:<br>
                           <a href="tel:014221234">01 422 1234</a></p>
                        <p style="margin-top:6px;">Emergency Line (24/7):<br>
                           <a href="tel:014229999">01 422 9999</a></p>
                    </div>
                </article>

                <article class="info-card">
                    <div class="card-icon">&#128140;</div>
                    <div>
                        <h3>Email</h3>
                        <p>General: <a href="mailto:info@lifeflow.org.np">info@lifeflow.org.np</a></p>
                        <p style="margin-top:4px;">Donations: <a href="mailto:donate@lifeflow.org.np">donate@lifeflow.org.np</a></p>
                    </div>
                </article>

                <article class="info-card">
                    <div class="card-icon">&#128336;</div>
                    <div>
                        <h3>Opening Hours</h3>
                        <p>Monday - Friday: 8:00am - 8:00pm</p>
                        <p>Saturday: 9:00am - 5:00pm</p>
                        <p>Sunday: 10:00am - 3:00pm</p>
                        <p style="margin-top:4px; color: var(--primary-red); font-weight:600;">Emergency: 24/7</p>
                    </div>
                </article>

            </div>

            <!-- MAP PLACEHOLDER -->
            <div class="map-placeholder" role="img" aria-label="Map showing LifeFlow Blood Bank location at Bagbazar, Kathmandu">
                <div class="map-icon">&#128506;</div>
                <p>Bagbazar, Kathmandu 44600</p>
                <p style="font-size:0.78rem;">[Map integration placeholder]</p>
            </div>
        </aside>

        <!-- RIGHT: CONTACT FORM -->
        <section aria-labelledby="formHeading">
            <div class="form-card">
                <h2 id="formHeading">&#9993; Send Us a Message</h2>

                <!-- Client-side validation error summary -->
                <div class="validation-msg error" id="validationError" role="alert" aria-live="assertive"></div>

                <%-- Form posts to ContactServlet --%>
                <form id="contactForm"
                      action="ContactServlet"
                      method="post"
                      novalidate
                      aria-label="Contact form">

                    <div class="form-grid">

                        <!-- Full Name -->
                        <div class="form-group">
                            <label for="fullName">
                                Full Name <span class="required" aria-label="required">*</span>
                            </label>
                            <input type="text"
                                   id="fullName"
                                   name="fullName"
                                   placeholder="e.g. Sita Thapa"
                                   maxlength="100"
                                   autocomplete="name"
                                   aria-required="true"
                                   value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                            <span class="field-error" id="fullNameError">Please enter your full name.</span>
                        </div>

                        <!-- Email Address -->
                        <div class="form-group">
                            <label for="email">
                                Email Address <span class="required" aria-label="required">*</span>
                            </label>
                            <input type="email"
                                   id="email"
                                   name="email"
                                   placeholder="e.g. sita@example.com"
                                   maxlength="150"
                                   autocomplete="email"
                                   aria-required="true"
                                   value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            <span class="field-error" id="emailError">Please enter a valid email address.</span>
                        </div>

                        <!-- Subject -->
                        <div class="form-group full-width">
                            <label for="subject">
                                Subject <span class="required" aria-label="required">*</span>
                            </label>
                            <select id="subject" name="subject" aria-required="true">
                                <option value="">-- Select a Subject --</option>
                                <option value="Blood Request Enquiry">Blood Request Enquiry</option>
                                <option value="Donation Information">Donation Information</option>
                                <option value="Stock Availability">Stock Availability</option>
                                <option value="Partnership / Hospital">Partnership / Hospital</option>
                                <option value="Complaint or Feedback">Complaint or Feedback</option>
                                <option value="Other">Other</option>
                            </select>
                            <span class="field-error" id="subjectError">Please select a subject.</span>
                        </div>

                        <!-- Message -->
                        <div class="form-group full-width">
                            <label for="message">
                                Message <span class="required" aria-label="required">*</span>
                            </label>
                            <textarea id="message"
                                      name="message"
                                      placeholder="Please describe your enquiry in detail. Include any relevant reference numbers or patient information if applicable..."
                                      maxlength="1000"
                                      aria-required="true"></textarea>
                            <span class="field-error" id="messageError">Please enter your message (minimum 10 characters).</span>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="reset"
                                    class="btn btn-secondary"
                                    onclick="clearValidation()"
                                    aria-label="Clear form">
                                Clear
                            </button>
                            <button type="submit"
                                    class="btn btn-primary"
                                    aria-label="Send message">
                                Send Message
                            </button>
                        </div>

                    </div>
                </form>
            </div>
        </section>

    </div>
</main>

<footer role="contentinfo">
    <p>&copy; 2024 LifeFlow Blood Bank Management System &mdash; Tribhuvan University |
        <a href="about.jsp">About Us</a>
    </p>
</footer>

<script>
    // Mobile nav toggle
    document.getElementById('hamburger').addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('open');
    });

    function clearValidation() {
        document.querySelectorAll('.field-error').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, select, textarea').forEach(el => el.style.borderColor = '');
        document.getElementById('validationError').style.display = 'none';
    }

    function showFieldError(fieldId, errorId) {
        document.getElementById(fieldId).style.borderColor = '#e74c3c';
        document.getElementById(errorId).style.display = 'block';
    }

    /**
     * Validates the contact form before submission.
     * Checks name, email format, subject selection, and message length.
     */
    function validateContactForm() {
        clearValidation();
        let isValid = true;
        const errors = [];

        // Validate full name
        const fullName = document.getElementById('fullName').value.trim();
        if (fullName.length < 2) {
            showFieldError('fullName', 'fullNameError');
            errors.push('Full name is required.');
            isValid = false;
        }

        // Validate email using regex
        const email = document.getElementById('email').value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showFieldError('email', 'emailError');
            errors.push('A valid email address is required.');
            isValid = false;
        }

        // Validate subject
        const subject = document.getElementById('subject').value;
        if (!subject) {
            showFieldError('subject', 'subjectError');
            errors.push('Please select a subject.');
            isValid = false;
        }

        // Validate message length
        const message = document.getElementById('message').value.trim();
        if (message.length < 10) {
            showFieldError('message', 'messageError');
            errors.push('Message must be at least 10 characters.');
            isValid = false;
        }

        if (!isValid) {
            const errorBox = document.getElementById('validationError');
            errorBox.innerHTML = '&#9888; Please fix the following issues:<ul style="margin-top:6px;padding-left:18px;">'
                + errors.map(e => `<li>${e}</li>`).join('') + '</ul>';
            errorBox.style.display = 'block';
            errorBox.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        return isValid;
    }

    document.getElementById('contactForm').addEventListener('submit', function(e) {
        if (!validateContactForm()) {
            e.preventDefault();
        }
    });

    // Clear individual field errors on input
    document.querySelectorAll('input, select, textarea').forEach(el => {
        el.addEventListener('input', function() {
            this.style.borderColor = '';
            const errorEl = document.getElementById(this.id + 'Error');
            if (errorEl) errorEl.style.display = 'none';
        });
    });
</script>
</body>
</html>
