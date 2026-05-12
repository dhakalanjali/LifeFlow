<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userBloodType = (String) session.getAttribute("userBloodType");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - LifeFlow</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }

        .navbar {
            background: #C0392B;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .navbar-brand { font-size: 1.4rem; font-weight: bold; color: white; text-decoration: none; }
        .navbar-links { display: flex; gap: 15px; flex-wrap: wrap; align-items: center; }
        .navbar-links a { color: white; text-decoration: none; font-size: 0.9rem; }
        .navbar-links a:hover { text-decoration: underline; }
        .btn-logout { background: white; color: #C0392B; padding: 6px 14px; border-radius: 20px; font-weight: bold; font-size: 0.85rem; }

        .container { padding: 30px 20px; max-width: 650px; margin: 0 auto; }
        h2 { color: #C0392B; margin-bottom: 20px; }

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 15px; font-weight: bold; }
        .alert-success { background: #d4edda; color: #155724; }
        .alert-error { background: #f8d7da; color: #721c24; }

        .profile-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-weight: bold; color: #555; margin-bottom: 6px; font-size: 0.9rem; }
        .form-group input, .form-group select {
            width: 100%; padding: 10px 12px;
            border: 1.5px solid #ddd; border-radius: 6px;
            font-size: 0.95rem; font-family: Arial, sans-serif;
            transition: border-color 0.2s;
        }
        .form-group input:focus, .form-group select:focus {
            outline: none; border-color: #C0392B;
        }
        .form-error { color: #C0392B; font-size: 0.8rem; margin-top: 4px; display: none; }
        .btn-submit {
            width: 100%; padding: 12px;
            background: #C0392B; color: white;
            border: none; border-radius: 6px;
            font-size: 1rem; font-weight: bold;
            cursor: pointer; margin-top: 10px;
        }
        .btn-submit:hover { background: #a93226; }

        @media (max-width: 768px) {
            .navbar { padding: 12px 15px; }
            .navbar-links { gap: 8px; }
            .navbar-links a { font-size: 0.8rem; }
            .container { padding: 15px; }
        }
        @media (max-width: 480px) {
            .navbar-links { display: none; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">❤️ LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>👤 My Profile</h2>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (session.getAttribute("success") != null) { %>
    <div class="alert alert-success"><%= session.getAttribute("success") %></div>
    <% session.removeAttribute("success"); %>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="profile-card">
        <form action="${pageContext.request.contextPath}/updateProfile" method="post"
              onsubmit="return validateProfile()">
            <input type="hidden" name="userId" value="<%= userId != null ? userId : "" %>">

            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" id="fullName"
                       value="<%= userName != null ? userName : "" %>" required>
                <div class="form-error" id="nameError">Name must contain letters only!</div>
            </div>

            <div class="form-group">
                <label>Email Address *</label>
                <input type="email" name="email"
                       value="<%= userEmail != null ? userEmail : "" %>" required>
            </div>

            <div class="form-group">
                <label>Phone Number *</label>
                <input type="text" name="phone" id="phone"
                       value="<%= userPhone != null ? userPhone : "" %>" required>
                <div class="form-error" id="phoneError">Phone must be 10 digits!</div>
            </div>

            <div class="form-group">
                <label>Blood Type</label>
                <select name="bloodType">
                    <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                        for (String g : groups) { %>
                    <option value="<%= g %>"
                            <%= g.equals(userBloodType) ? "selected" : "" %>><%= g %>
                    </option>
                    <% } %>
                </select>
            </div>

            <div class="form-group">
                <label>New Password (leave blank to keep current)</label>
                <input type="password" name="newPassword" id="newPassword"
                       placeholder="Min 8 chars, uppercase, lowercase, number, special char">
                <div class="form-error" id="passError">Password must be at least 8 characters with uppercase, lowercase, number and special character!</div>
            </div>

            <button type="submit" class="btn-submit">💾 Update Profile</button>
        </form>
    </div>
</div>

<script>
    function validateProfile() {
        let valid = true;

        // Name validation - letters only
        const name = document.getElementById('fullName').value.trim();
        const nameError = document.getElementById('nameError');
        if (!/^[A-Za-z ]+$/.test(name)) {
            nameError.style.display = 'block';
            valid = false;
        } else {
            nameError.style.display = 'none';
        }

        // Phone validation - 10 digits
        const phone = document.getElementById('phone').value.trim();
        const phoneError = document.getElementById('phoneError');
        if (!/^\d{10}$/.test(phone)) {
            phoneError.style.display = 'block';
            valid = false;
        } else {
            phoneError.style.display = 'none';
        }

        // Password validation (only if filled)
        const pass = document.getElementById('newPassword').value;
        const passError = document.getElementById('passError');
        if (pass.length > 0) {
            if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$/.test(pass)) {
                passError.style.display = 'block';
                valid = false;
            } else {
                passError.style.display = 'none';
            }
        } else {
            passError.style.display = 'none';
        }

        return valid;
    }
</script>

</body>
</html>