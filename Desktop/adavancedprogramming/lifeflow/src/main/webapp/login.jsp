<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Login</title>
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

        .login-container {
            background-color: #ffffff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 400px;
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
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2C3E50;
            font-size: 14px;
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            color: #2C3E50;
        }

        .form-group input:focus {
            outline: none;
            border-color: #C0392B;
        }

        .btn-login {
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

        .btn-login:hover {
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

        .register-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #888;
        }

        .register-link a {
            color: #C0392B;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .welcome-text {
            text-align: center;
            color: #2C3E50;
            margin-bottom: 25px;
            font-size: 14px;
        }
    </style>
</head>
<body>

<div class="login-container">
    <div class="logo">
        <h1>🩸 LifeFlow</h1>
        <p>Blood Donation Management System</p>
    </div>

    <p class="welcome-text">Welcome back! Please login to continue.</p>

    <%-- Show error message --%>
    <% if (request.getAttribute("error") != null) { %>
    <div class="error-message">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="login" method="post">

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter your email" required/>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required/>
        </div>

        <button type="submit" class="btn-login">Login</button>

    </form>

    <div class="register-link">
        Don't have an account? <a href="register">Register here</a>
    </div>
</div>

</body>
</html>