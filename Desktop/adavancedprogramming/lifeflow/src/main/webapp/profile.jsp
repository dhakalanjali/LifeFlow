<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName      = (String) session.getAttribute("userName");
    String userEmail     = (String) session.getAttribute("userEmail");
    String userPhone     = (String) session.getAttribute("userPhone");
    String userBloodType = (String) session.getAttribute("userBloodType");

    String successMsg = (String) session.getAttribute("success");
    String errorMsg   = (String) session.getAttribute("error");
    if (successMsg != null) session.removeAttribute("success");
    if (errorMsg != null)   session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - LifeFlow</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --red: #C0392B; --red-dark: #96281B; --red-light: #fde8e8;
            --red-border: #f5b7b1; --bg: #f4f4f0; --card: #ffffff;
            --text: #1a1a1a; --muted: #6b7280; --border: rgba(0,0,0,0.08);
            --radius: 14px; --radius-sm: 8px;
        }
        body { font-family: 'Plus Jakarta Sans', Arial, sans-serif; background: var(--bg); color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar { background: var(--red); padding: 0 2.5rem; height: 60px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 12px rgba(192,57,43,0.25); }
        .navbar-brand { color: #fff; font-size: 18px; font-weight: 600; text-decoration: none; }
        .navbar-links { display: flex; align-items: center; gap: 2px; }
        .navbar-links a { color: rgba(255,255,255,0.88); text-decoration: none; font-size: 13px; padding: 6px 12px; border-radius: var(--radius-sm); transition: background 0.15s; }
        .navbar-links a:hover, .navbar-links a.active { background: rgba(255,255,255,0.15); color: #fff; }
        .btn-logout { background: rgba(255,255,255,0.15) !important; color: #fff !important; border: 1px solid rgba(255,255,255,0.35) !important; margin-left: 8px; font-weight: 500; border-radius: var(--radius-sm); }
        .btn-logout:hover { background: rgba(255,255,255,0.28) !important; }

        /* CONTAINER */
        .container { width: 100%; padding: 2rem 2.5rem; display: flex; justify-content: center; }

        /* PROFILE CARD */
        .profile-card { background: var(--card); border: 0.5px solid var(--border); border-radius: var(--radius); padding: 2rem; width: 100%; max-width: 600px; }

        .profile-header { display: flex; align-items: center; gap: 1rem; margin-bottom: 1.75rem; padding-bottom: 1.25rem; border-bottom: 0.5px solid var(--border); }
        .avatar { width: 60px; height: 60px; border-radius: 50%; background: var(--red-light); border: 2px solid var(--red-border); display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 600; color: var(--red); flex-shrink: 0; }
        .profile-header-info h2 { font-size: 18px; font-weight: 600; }
        .profile-header-info p { font-size: 13px; color: var(--muted); margin-top: 3px; }
        .blood-badge { display: inline-flex; align-items: center; background: var(--red-light); color: var(--red-dark); font-size: 11px; font-weight: 500; padding: 3px 10px; border-radius: 20px; border: 0.5px solid var(--red-border); margin-top: 5px; }

        /* FORM */
        .form-group { margin-bottom: 1.1rem; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: var(--muted); text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 6px; }
        .form-group input, .form-group select { width: 100%; padding: 10px 14px; border: 0.5px solid var(--border); border-radius: var(--radius-sm); font-size: 13px; color: var(--text); background: #fafafa; font-family: inherit; outline: none; transition: border-color 0.15s; }
        .form-group input:focus, .form-group select:focus { border-color: var(--red); background: #fff; }
        .readonly-field { background: #f0f0f0 !important; color: var(--muted) !important; cursor: not-allowed; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .form-error { color: var(--red); font-size: 11px; margin-top: 4px; display: none; }
        .btn-submit { width: 100%; background: var(--red); color: #fff; border: none; padding: 12px; border-radius: var(--radius-sm); font-size: 14px; font-weight: 600; cursor: pointer; font-family: inherit; transition: background 0.15s; margin-top: 0.5rem; }
        .btn-submit:hover { background: var(--red-dark); }

        /* ALERTS */
        .alert { padding: 12px 16px; border-radius: var(--radius-sm); font-size: 13px; margin-bottom: 1.25rem; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border: 0.5px solid #a5d6a7; }
        .alert-error   { background: var(--red-light); color: var(--red-dark); border: 0.5px solid var(--red-border); }

        @media (max-width: 768px) {
            .navbar { padding: 0 1rem; }
            .navbar-links { display: none; }
            .container { padding: 1rem; }
            .form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/userDashboard.jsp" class="navbar-brand">&#10084; LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/userDashboard.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
        <a href="${pageContext.request.contextPath}/profile.jsp" class="active">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="profile-card">

        <!-- HEADER -->
        <div class="profile-header">
            <%
                String initials = "U";
                if (userName != null && !userName.trim().isEmpty()) {
                    String[] parts = userName.trim().split("\\s+");
                    initials = "";
                    for (String p : parts) if (!p.isEmpty()) initials += p.charAt(0);
                    initials = initials.toUpperCase();
                    if (initials.length() > 2) initials = initials.substring(0, 2);
                }
            %>
            <div class="avatar"><%= initials %></div>
            <div class="profile-header-info">
                <h2><%= userName != null ? userName : "User" %></h2>
                <p><%= userEmail != null ? userEmail : "" %></p>
                <span class="blood-badge">&#9679; Blood type: <strong><%= userBloodType != null ? userBloodType : "N/A" %></strong></span>
            </div>
        </div>

        <!-- ALERTS -->
        <% if (successMsg != null) { %>
        <div class="alert alert-success">&#10004; <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert alert-error">&#9888; <%= errorMsg %></div>
        <% } %>

        <!-- FORM -->
        <form action="${pageContext.request.contextPath}/updateProfile" method="post" onsubmit="return validateProfile()">

            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" id="fullName"
                       value="<%= userName != null ? userName : "" %>" required />
                <div class="form-error" id="nameError">Name must contain letters only!</div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" value="<%= userEmail != null ? userEmail : "" %>"
                           class="readonly-field" readonly />
                </div>
                <div class="form-group">
                    <label>Phone Number *</label>
                    <input type="text" name="phone" id="phone"
                           value="<%= userPhone != null ? userPhone : "" %>" required />
                    <div class="form-error" id="phoneError">Phone must be 10 digits!</div>
                </div>
            </div>

            <div class="form-group">
                <label>Blood Type</label>
                <select name="bloodType">
                    <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                        for (String g : groups) { %>
                    <option value="<%= g %>" <%= g.equals(userBloodType) ? "selected" : "" %>><%= g %></option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>New Password (leave blank to keep current)</label>
                <input type="password" name="newPassword" id="newPassword"
                       placeholder="Min 8 chars, uppercase, lowercase, number, special char" />
                <div class="form-error" id="passError">Password must be 8+ chars with uppercase, lowercase, number & special character!</div>
            </div>

            <button type="submit" class="btn-submit">&#128190; Update Profile</button>
        </form>
    </div>
</div>

<script>
    function validateProfile() {
        let valid = true;

        const name = document.getElementById('fullName').value.trim();
        const nameError = document.getElementById('nameError');
        if (!/^[A-Za-z ]+$/.test(name)) {
            nameError.style.display = 'block'; valid = false;
        } else { nameError.style.display = 'none'; }

        const phone = document.getElementById('phone').value.trim();
        const phoneError = document.getElementById('phoneError');
        if (!/^\d{10}$/.test(phone)) {
            phoneError.style.display = 'block'; valid = false;
        } else { phoneError.style.display = 'none'; }

        const pass = document.getElementById('newPassword').value;
        const passError = document.getElementById('passError');
        if (pass.length > 0) {
            if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$/.test(pass)) {
                passError.style.display = 'block'; valid = false;
            } else { passError.style.display = 'none'; }
        } else { passError.style.display = 'none'; }

        return valid;
    }
</script>

</body>
</html>