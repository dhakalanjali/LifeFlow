<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("userRole") == null){
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>LifeFlow - Admin Dashboard</title>
    <style>
        body { font-family: Arial; background: #f5f5f5; }
        .navbar { background: #C0392B; padding: 15px 30px; }
        .navbar h1 { color: white; }
        .container { max-width: 900px; margin: 40px auto; padding: 20px; }
        .welcome { background: white; padding: 30px; border-radius: 10px; text-align: center; }
        .welcome h2 { color: #C0392B; }
    </style>
</head>
<body>
<div class="navbar">
    <h1>🩸 LifeFlow — Admin Dashboard</h1>
</div>
<div class="container">
    <div class="welcome">
        <h2>Welcome Admin <%= session.getAttribute("userName") %>! 👋</h2>
        <p>You are logged in successfully!</p>
        <br>
        <a href="manageBloodStock.jsp">Manage Blood Stock</a> |
        <a href="logout">Logout</a>
    </div>
</div>
</body>
</html>