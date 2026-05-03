<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Blood Donation System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; text-align: center; padding: 50px; }
        .error-container { background: #fff; padding: 30px; border-radius: 8px; display: inline-block; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { margin-top: 0; }
        a { color: #0056b3; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="error-container">
    <h1>Oops! Something went wrong.</h1>
    
    <%
        // Check if there is a specific error message passed as an attribute
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null && !errorMessage.isEmpty()) {
    %>
        <p><strong>Error Details:</strong> <%= errorMessage %></p>
    <%
        } else if (exception != null) {
    %>
        <p><strong>System Exception:</strong> <%= exception.getMessage() %></p>
    <%
        } else {
    %>
        <p>An unexpected error occurred. Please try again later.</p>
    <%
        }
    %>

    <br>
    <a href="${pageContext.request.contextPath}/">Return to Home</a>
</div>

</body>
</html>
