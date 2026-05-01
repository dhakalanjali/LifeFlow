<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Register</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .register-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 450px;
        }

        .logo {
            text-align: center;
            margin-bottom: 30px;
        }

        .logo h1 {
            color: #C0392B;
            font-size: 32px;
        }

        .logo p {
            color: #888;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2C3E50;
            font-size: 14px;
            font-weight: bold;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            color: #2C3E50;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #C0392B;
        }

        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: #C0392B;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-register:hover {
            background-color: #E74C3C;
        }

        .error-message {
            background-color: #fde8e8;
            color: #C0392B;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 14px;
            text-align: center;
        }

        .success-message {
            background-color: #e8f8e8;
            color: #27AE60;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 14px;
            text-align: center;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #888;
        }

        .login-link a {
            color: #C0392B;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="register-container">
    <div class="logo">
        <h1>🩸 LifeFlow</h1>
        <p>Blood Donation Management System</p>
    </div>

    <%-- Show error message --%>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <%-- Show success message --%>
    <% if (request.getAttribute("success") != null) { %>
    <div class="success-message">
        <%= request.getAttribute("success") %>
    </div>
    <% } %>

    <form action="register" method="post">

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" placeholder="Enter your full name" required/>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter your email" required/>
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone" placeholder="Enter 10 digit phone number" required/>
        </div>

        <div class="form-group">
            <label>Blood Type</label>
            <select name="bloodType" required>
                <option value="">-- Select Blood Type --</option>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
            </select>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Minimum 6 characters" required/>
        </div>

        <div class="form-group">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" placeholder="Repeat your password" required/>
        </div>

        <button type="submit" class="btn-register">Register</button>

    </form>

    <div class="login-link">
        Already have an account? <a href="login">Login here</a>
    </div>
</div>

</body>
</html>