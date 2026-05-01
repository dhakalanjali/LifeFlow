<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Blood Donation Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        /* NAVBAR */
        .navbar {
            background-color: #ffffff;
            padding: 15px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }

        .navbar .logo {
            color: #C0392B;
            font-size: 26px;
            font-weight: bold;
            text-decoration: none;
        }

        .navbar .nav-links a {
            color: #2C3E50;
            text-decoration: none;
            margin-left: 20px;
            font-size: 15px;
        }

        .navbar .nav-links a:hover {
            color: #C0392B;
        }

        .btn-nav-login {
            background-color: #C0392B !important;
            color: white !important;
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: bold;
        }

        .btn-nav-login:hover {
            background-color: black !important;
            color: white !important;
        }

        .btn-nav-register {
            background-color: transparent !important;
            color: #C0392B !important;
            padding: 8px 20px;
            border-radius: 25px;
            border: 2px solid #C0392B;
            font-weight: bold;
        }

        .btn-nav-register:hover {
            background-color: black !important;
            color: white !important;
            border-color: black !important;
        }

        /* HERO SECTION */
        .hero {
            background:
                    linear-gradient(135deg, rgba(192,57,43,0.00) 0%, rgba(146,43,33,0.92) 100%),
                    url('images/blood_donation.webp');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            min-height: 90vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 60px 20px;
        }

        .hero-content h1 {
            color: white;
            font-size: 52px;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .hero-content h1 span {
            color: #FFD700;
        }

        .hero-content p {
            color: #f5f5f5;
            font-size: 20px;
            margin-bottom: 40px;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .hero-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-donate {
            background-color: white;
            color: #C0392B;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-donate:hover {
            background-color: black;
            color: white;
        }

        .btn-request {
            background-color: transparent;
            color: white;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            border: 2px solid white;
            transition: all 0.3s;
        }

        .btn-request:hover {
            background-color: black;
            color: white;
            border-color: black;
        }

        /* STATISTICS SECTION */
        .stats {
            background-color: #C0392B;
            padding: 60px 50px;
            display: flex;
            justify-content: center;
            gap: 60px;
            flex-wrap: wrap;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item h2 {
            color: white;
            font-size: 48px;
            font-weight: bold;
        }

        .stat-item p {
            color: #f5f5f5;
            font-size: 16px;
            margin-top: 5px;
        }

        /* FEATURES SECTION */
        .features {
            background-color: #ffffff;
            padding: 80px 50px;
            text-align: center;
        }

        .features h2 {
            color: #C0392B;
            font-size: 36px;
            margin-bottom: 10px;
        }

        .features .section-sub {
            color: #777;
            font-size: 16px;
            margin-bottom: 50px;
        }

        .features-grid {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }

        .feature-card {
            background-color: #fff5f5;
            padding: 40px 30px;
            border-radius: 15px;
            width: 250px;
            box-shadow: 0 4px 15px rgba(192,57,43,0.1);
            transition: all 0.3s;
            border-top: 4px solid #C0392B;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(192,57,43,0.2);
        }

        .feature-card .icon {
            font-size: 50px;
            margin-bottom: 20px;
        }

        .feature-card h3 {
            color: #C0392B;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .feature-card p {
            color: #777;
            font-size: 14px;
            margin-bottom: 0;
        }

        /* HOW IT WORKS */
        .how-it-works {
            background-color: #fff5f5;
            padding: 80px 50px;
            text-align: center;
        }

        .how-it-works h2 {
            color: #C0392B;
            font-size: 36px;
            margin-bottom: 10px;
        }

        .how-it-works .section-sub {
            color: #777;
            font-size: 16px;
            margin-bottom: 50px;
        }

        .steps {
            display: flex;
            justify-content: center;
            gap: 40px;
            flex-wrap: wrap;
        }

        .step {
            width: 220px;
            text-align: center;
            background-color: white;
            padding: 30px 20px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(192,57,43,0.1);
        }

        .step-number {
            background-color: #C0392B;
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
            margin: 0 auto 20px;
        }

        .step h3 {
            color: #C0392B;
            margin-bottom: 10px;
        }

        .step p {
            color: #777;
            font-size: 14px;
        }

        /* WHY LIFEFLOW */
        .why-us {
            background-color: #C0392B;
            padding: 80px 50px;
            text-align: center;
        }

        .why-us h2 {
            color: white;
            font-size: 36px;
            margin-bottom: 10px;
        }

        .why-us .section-sub {
            color: #f5f5f5;
            font-size: 16px;
            margin-bottom: 50px;
        }

        .why-grid {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }

        .why-card {
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            width: 220px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }

        .why-card:hover {
            transform: translateY(-5px);
        }

        .why-card .icon {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .why-card h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #C0392B;
        }

        .why-card p {
            font-size: 14px;
            color: #777;
            margin-bottom: 0;
        }

        /* CTA SECTION */
        .cta {
            background-color: #ffffff;
            padding: 80px 50px;
            text-align: center;
            border-top: 4px solid #C0392B;
        }

        .cta h2 {
            color: #C0392B;
            font-size: 36px;
            margin-bottom: 15px;
        }

        .cta p {
            color: #777;
            font-size: 18px;
            margin-bottom: 40px;
        }

        .cta-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-cta-primary {
            background-color: #C0392B;
            color: white;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .btn-cta-primary:hover {
            background-color: black;
        }

        .btn-cta-secondary {
            background-color: transparent;
            color: #C0392B;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            border: 2px solid #C0392B;
            transition: all 0.3s;
        }

        .btn-cta-secondary:hover {
            background-color: black;
            color: white;
            border-color: black;
        }

        /* FOOTER */
        .footer {
            background-color: #C0392B;
            padding: 40px 50px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 30px;
        }

        .footer-logo {
            color: white;
            font-size: 24px;
            font-weight: bold;
        }

        .footer-logo p {
            color: #f5f5f5;
            font-size: 14px;
            margin-top: 10px;
            font-weight: normal;
        }

        .footer-links h4 {
            color: white;
            margin-bottom: 15px;
        }

        .footer-links a {
            display: block;
            color: #f5f5f5;
            text-decoration: none;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .footer-links a:hover {
            color: black;
        }

        .footer-bottom {
            background-color: #922B21;
            padding: 15px 50px;
            text-align: center;
            color: #f5f5f5;
            font-size: 13px;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="index.jsp" class="logo">🩸 LifeFlow</a>
    <div class="nav-links">
        <a href="#features">Features</a>
        <a href="#how-it-works">How it Works</a>
        <a href="login" class="btn-nav-login">Login</a>
        <a href="register" class="btn-nav-register">Register</a>
    </div>
</nav>

<!-- HERO SECTION -->
<section class="hero">
    <div class="hero-content">
        <h1>Your Blood Can <span>Save</span><br>A Life Today</h1>
        <p>Join LifeFlow — Nepal's trusted blood donation management system. Connect donors with those in need, fast and safely.</p>
        <div class="hero-buttons">
            <a href="register" class="btn-donate">🩸 Donate Blood</a>
            <a href="login" class="btn-request">🏥 Request Blood</a>
        </div>
    </div>
</section>

<!-- STATISTICS -->
<section class="stats">
    <div class="stat-item">
        <h2>500+</h2>
        <p>Registered Donors</p>
    </div>
    <div class="stat-item">
        <h2>8</h2>
        <p>Blood Types Available</p>
    </div>
    <div class="stat-item">
        <h2>100+</h2>
        <p>Lives Saved</p>
    </div>
    <div class="stat-item">
        <h2>24/7</h2>
        <p>System Available</p>
    </div>
</section>

<!-- FEATURES -->
<section class="features" id="features">
    <h2>What LifeFlow Offers</h2>
    <p class="section-sub">Everything you need for blood donation management in one place</p>
    <div class="features-grid">
        <div class="feature-card">
            <div class="icon">🔍</div>
            <h3>Search Blood</h3>
            <p>Find available blood by blood group quickly and easily</p>
        </div>
        <div class="feature-card">
            <div class="icon">🩸</div>
            <h3>Donate Blood</h3>
            <p>Register as a donor and save lives in your community</p>
        </div>
        <div class="feature-card">
            <div class="icon">🏥</div>
            <h3>Request Blood</h3>
            <p>Submit blood requests and get help when you need it most</p>
        </div>
        <div class="feature-card">
            <div class="icon">📅</div>
            <h3>Donation Camps</h3>
            <p>Find and join blood donation camps near you</p>
        </div>
    </div>
</section>

<!-- HOW IT WORKS -->
<section class="how-it-works" id="how-it-works">
    <h2>How It Works</h2>
    <p class="section-sub">Simple steps to save a life</p>
    <div class="steps">
        <div class="step">
            <div class="step-number">1</div>
            <h3>Register</h3>
            <p>Create your account with your blood type and personal details</p>
        </div>
        <div class="step">
            <div class="step-number">2</div>
            <h3>Get Approved</h3>
            <p>Admin reviews and approves your registration</p>
        </div>
        <div class="step">
            <div class="step-number">3</div>
            <h3>Donate or Request</h3>
            <p>Search for blood or register as a donor to help others</p>
        </div>
        <div class="step">
            <div class="step-number">4</div>
            <h3>Save Lives</h3>
            <p>Together we make a difference in our community</p>
        </div>
    </div>
</section>

<!-- WHY LIFEFLOW -->
<section class="why-us">
    <h2>Why Choose LifeFlow?</h2>
    <p class="section-sub">We make blood donation simple, safe and effective</p>
    <div class="why-grid">
        <div class="why-card">
            <div class="icon">⚡</div>
            <h3>Fast</h3>
            <p>Find and request blood quickly in emergency situations</p>
        </div>
        <div class="why-card">
            <div class="icon">🔒</div>
            <h3>Secure</h3>
            <p>Your data is encrypted and protected at all times</p>
        </div>
        <div class="why-card">
            <div class="icon">✅</div>
            <h3>Reliable</h3>
            <p>Verified donors and accurate blood stock information</p>
        </div>
        <div class="why-card">
            <div class="icon">❤️</div>
            <h3>Caring</h3>
            <p>Built with love to serve our community in Nepal</p>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta">
    <h2>Ready to Save a Life?</h2>
    <p>Join thousands of donors who are making a difference every day</p>
    <div class="cta-buttons">
        <a href="register" class="btn-cta-primary">🩸 Register Now</a>
        <a href="login" class="btn-cta-secondary">Login</a>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer">
    <div class="footer-logo">
        🩸 LifeFlow
        <p>Blood Donation Management System<br>Saving lives one drop at a time</p>
    </div>
    <div class="footer-links">
        <h4>Quick Links</h4>
        <a href="login">Login</a>
        <a href="register">Register</a>
        <a href="#features">Features</a>
        <a href="#how-it-works">How it Works</a>
    </div>
    <div class="footer-links">
        <h4>Contact</h4>
        <a href="#">📧 lifeflow@email.com</a>
        <a href="#">📞 +977 9800000000</a>
        <a href="#">📍 Itahari, Nepal</a>
    </div>
</footer>
<div class="footer-bottom">
    <p>© 2026 LifeFlow Blood Donation Management System. All rights reserved.</p>
</div>

</body>
</html>