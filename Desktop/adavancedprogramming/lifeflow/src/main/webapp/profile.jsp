<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("email");
    String userPhone = (String) session.getAttribute("phone");
    String bloodGroup = (String) session.getAttribute("bloodGroup");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - LifeFlow</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; background: #f5f5f5; }
        .navbar { background: #8B0000; color: white; padding: 15px 30px;
            display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; margin-left: 20px; }
        .navbar a:hover { text-decoration: underline; }
        .container { padding: 30px; max-width: 600px; margin: 0 auto; }
        h2 { color: #8B0000; }
        .profile-card { background: white; padding: 30px; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .profile-pic { text-align: center; margin-bottom: 20px; }
        .profile-pic span { font-size: 5rem; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold;
            color: #555; margin-bottom: 5px; }
        .form-group input, .form-group select {
            width: 100%; padding: 10px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 0.95rem; box-sizing: border-box; }
        .form-group input:focus { border-color: #8B0000; outline: none; }
        .btn { background: #8B0000; color: white; padding: 12px 30px;
            border: none; border-radius: 6px; cursor: pointer;
            font-size: 1rem; width: 100%; margin-top: 10px; }
        .btn:hover { background: #6B0000; }
        .success { background: #d4edda; color: #155724; padding: 10px;
            border-radius: 6px; margin-bottom: 15px; }
    </style>
</head>
<body>

<div class="navbar">
    <span style="font-size:1.3rem; font-weight:bold;">❤️ LifeFlow</span>
    <div>
        <a href="${pageContext.request.contextPath}/user/dashboard">Dashboard</a>
        <a href="${pageContext.request.contextPath}/user/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/user/donationHistory">Donation History</a>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>

<div class="container">
    <h2>👤 My Profile</h2>

    <% if (session.getAttribute("success") != null) { %>
    <div class="success"><%= session.getAttribute("success") %></div>
    <% session.removeAttribute("success"); %>
    <% } %>

    <div class="profile-card">
        <div class="profile-pic"><span>👤</span></div>

        <form action="${pageContext.request.contextPath}/user/updateProfile" method="post">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName"
                       value="<%= userName != null ? userName : "" %>" required>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email"
                       value="<%= userEmail != null ? userEmail : "" %>" required>
            </div>
            <div class="form-group">
                <label>Phone Number</label>
                <input type="text" name="phone"
                       value="<%= userPhone != null ? userPhone : "" %>" required>
            </div>
            <div class="form-group">
                <label>Blood Group</label>
                <select name="bloodGroup">
                    <% String[] groups = {"A+","A-","B+","B-","AB+","AB-","O+","O-"};
                        for (String g : groups) { %>
                    <option value="<%= g %>"
                            <%= g.equals(bloodGroup) ? "selected" : "" %>><%= g %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>New Password (leave blank to keep current)</label>
                <input type="password" name="newPassword"
                       placeholder="Enter new password">
            </div>
            <button type="submit" class="btn">💾 Update Profile</button>
        </form>
    </div>
</div>

</body>
</html>