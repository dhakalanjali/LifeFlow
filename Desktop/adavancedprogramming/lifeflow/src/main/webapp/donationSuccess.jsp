<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    com.lifeflow.lifeflow.model.User currentUser =
            (com.lifeflow.lifeflow.model.User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Donation Successful – LifeFlow</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --red:  #C0392B;
            --green:#16a34a;
            --bg:   #F7F8FA;
        }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background: var(--red);
            color: #fff;
            padding: 14px 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .navbar .brand { font-size: 1.3rem; font-weight: 700; }
        .navbar .brand i { margin-right: 8px; }
        .navbar a { color:#fff; text-decoration:none; font-size:.9rem; }

        .content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 16px;
        }
        .card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 32px rgba(0,0,0,.10);
            padding: 56px 48px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            animation: fadeUp .5s ease both;
        }
        @keyframes fadeUp {
            from { opacity:0; transform:translateY(24px); }
            to   { opacity:1; transform:translateY(0); }
        }
        .check-circle {
            width: 90px; height: 90px;
            background: #dcfce7;
            border-radius: 50%;
            display: flex; align-items:center; justify-content:center;
            margin: 0 auto 24px;
            font-size: 2.6rem;
            color: var(--green);
        }
        h1 { font-size: 1.8rem; font-weight: 700; color: #111; margin-bottom: 12px; }
        p  { color: #6b7280; line-height: 1.7; margin-bottom: 8px; }
        .name { color: var(--red); font-weight: 600; }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 32px;
            padding: 12px 28px;
            background: var(--red);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: .95rem;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: background .2s;
        }
        .btn:hover { background: #96281B; }
        .btn-outline {
            background: transparent;
            color: var(--red);
            border: 2px solid var(--red);
            margin-left: 12px;
        }
        .btn-outline:hover { background: #fee2e2; }
    </style>
</head>
<body>
<nav class="navbar">
    <span class="brand"><i class="fa-solid fa-droplet"></i> LifeFlow</span>
    <a href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-right-from-bracket"></i> Logout
    </a>
</nav>

<div class="content">
    <div class="card">
        <div class="check-circle">
            <i class="fa-solid fa-check"></i>
        </div>
        <h1>Thank You for Donating!</h1>
        <p>
            Dear <span class="name"><%= currentUser.getFullName() %></span>,<br/>
            your blood donation has been successfully recorded.
        </p>
        <p>Your generosity saves lives. Every drop counts! ❤️</p>

        <div>
            <a href="${pageContext.request.contextPath}/user/dashboard.jsp" class="btn">
                <i class="fa-solid fa-house"></i> Go to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/donate-blood" class="btn btn-outline">
                <i class="fa-solid fa-plus"></i> Donate Again
            </a>
        </div>
    </div>
</div>
</body>
</html>
