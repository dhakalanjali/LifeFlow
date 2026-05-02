<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Register</title>
    <style>
        /* RESET */
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
            align-items: flex-start;
            min-height: 100vh;
            padding: 30px 20px;
        }

        /* REGISTER BOX */
        .register-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
        }

        /* HEADER */
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h1 {
            color: #cc0000;
            font-size: 28px;
        }

        .register-header h2 {
            color: #333;
            font-size: 20px;
            margin-top: 5px;
        }

        .register-header p {
            color: #888;
            font-size: 13px;
            margin-top: 4px;
        }

        /* FORM GROUPS */
        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
            color: #333;
            font-size: 14px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #cc0000;
        }

        /* BUTTON */
        .btn-register {
            width: 100%;
            padding: 12px;
            background-color: #cc0000;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-register:hover {
            background-color: #aa0000;
        }

        /* MESSAGES */
        .error-message {
            background-color: #ffe0e0;
            color: #cc0000;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
            font-size: 14px;
        }

        .success-message {
            background-color: #e0ffe0;
            color: #007700;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            text-align: center;
            font-size: 14px;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .login-link a {
            color: #cc0000;
            text-decoration: none;
            font-weight: bold;
        }

        /* TWO COLUMN ROW */
        .form-row {
            display: flex;
            gap: 15px;
        }

        .form-row .form-group {
            flex: 1;
        }

        /* RESPONSIVE */
        @media (max-width: 480px) {
            .register-container {
                padding: 25px;
            }
            .form-row {
                flex-direction: column;
                gap: 0;
            }
        }
    </style>
</head>
<body>

<div class="register-container">

    <!-- HEADER -->
    <div class="register-header">
        <h1>🩸 LifeFlow</h1>
        <p>Blood Donation Management System</p>
        <h2>Create Account</h2>
    </div>

    <!-- ERROR MESSAGE -->
    <% String error = (String) request.getAttribute("error");
        if(error != null) { %>
    <div class="error-message"><%= error %></div>
    <% } %>

    <!-- SUCCESS MESSAGE -->
    <% String success = (String) request.getAttribute("success");
        if(success != null) { %>
    <div class="success-message"><%= success %></div>
    <% } %>

    <!-- REGISTER FORM -->
    <form action="register" method="post">

        <!-- Full Name -->
        <div class="form-group">
            <label>Full Name *</label>
            <input type="text" name="fullName"
                   placeholder="Enter your full name"
                   required/>
        </div>

        <!-- Email -->
        <div class="form-group">
            <label>Email Address *</label>
            <input type="email" name="email"
                   placeholder="Enter your email"
                   required/>
        </div>

        <!-- Phone -->
        <div class="form-group">
            <label>Phone Number *</label>
            <input type="text" name="phone"
                   placeholder="Enter 10 digit phone number"
                   maxlength="10"
                   required/>
        </div>

        <!-- DOB and Gender in same row -->
        <div class="form-row">
            <div class="form-group">
                <label>Date of Birth *</label>
                <input type="date" name="dateOfBirth" required/>
            </div>

            <div class="form-group">
                <label>Gender *</label>
                <select name="gender" required>
                    <option value="">-- Select --</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
        </div>

        <!-- Address -->
        <div class="form-group">
            <label>Address *</label>
            <textarea name="address"
                      placeholder="Enter your full address"
                      rows="3"
                      required></textarea>
        </div>

        <!-- Blood Type -->
        <div class="form-group">
            <label>Blood Type *</label>
            <select name="bloodType" required>
                <option value="">-- Select Blood Type --</option>
                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>
            </select>
        </div>

        <!-- Password and Confirm in same row -->
        <div class="form-row">
            <div class="form-group">
                <label>Password *</label>
                <input type="password" name="password"
                       placeholder="Min 6 characters"
                       minlength="6"
                       required/>
            </div>

            <div class="form-group">
                <label>Confirm Password *</label>
                <input type="password" name="confirmPassword"
                       placeholder="Repeat password"
                       required/>
            </div>
        </div>

        <button type="submit" class="btn-register">Register</button>

    </form>

    <p class="login-link">
        Already have an account? <a href="login">Login here</a>
    </p>

</div>

<!-- JAVASCRIPT VALIDATION -->
<script>
    document.querySelector('form').addEventListener('submit', function(e) {

        // Check passwords match
        var password = document.querySelector('input[name="password"]').value;
        var confirmPassword = document.querySelector('input[name="confirmPassword"]').value;
        if(password !== confirmPassword) {
            e.preventDefault();
            alert('Passwords do not match!');
            return;
        }

        // Check phone is 10 digits
        var phone = document.querySelector('input[name="phone"]').value;
        if(phone.length !== 10 || isNaN(phone)) {
            e.preventDefault();
            alert('Phone number must be exactly 10 digits!');
            return;
        }

        // Check name has no numbers
        var fullName = document.querySelector('input[name="fullName"]').value;
        if(/\d/.test(fullName)) {
            e.preventDefault();
            alert('Full name cannot contain numbers!');
            return;
        }

        // Check age is at least 18
        var dob = new Date(document.querySelector('input[name="dateOfBirth"]').value);
        var today = new Date();
        var age = today.getFullYear() - dob.getFullYear();
        if(age < 18) {
            e.preventDefault();
            alert('You must be at least 18 years old to donate blood!');
            return;
        }

    });
</script>

</body>
</html>