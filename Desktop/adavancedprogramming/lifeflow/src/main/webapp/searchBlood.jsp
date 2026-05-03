<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Blood - Blood Donation System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px; }
        .search-container { max-width: 600px; margin: 40px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        h2 { color: #e74c3c; text-align: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        select, input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { width: 100%; padding: 12px; background-color: #e74c3c; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { background-color: #c0392b; }
        .results { margin-top: 30px; padding: 15px; border: 1px solid #d4edda; background-color: #e2e3e5; border-radius: 4px; }
        .success { background-color: #d4edda; color: #155724; }
    </style>
</head>
<body>

<div class="search-container">
    <h2>Search Available Blood</h2>
    
    <form action="${pageContext.request.contextPath}/bloodRequest" method="POST">
        <div class="form-group">
            <label for="bloodGroup">Blood Group</label>
            <select id="bloodGroup" name="bloodGroup" required>
                <option value="">Select Blood Group</option>
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
            <label for="location">Location</label>
            <input type="text" id="location" name="location" placeholder="Enter city or area" required>
        </div>

        <button type="submit" class="btn-submit">Search</button>
    </form>

    <%
        String successMessage = (String) request.getAttribute("successMessage");
        if (successMessage != null) {
    %>
        <div class="results success">
            <h4>Results:</h4>
            <p><%= successMessage %></p>
            <p><strong>Note:</strong> This is a simulation. In a real system, available donors and banks would be listed here.</p>
        </div>
    <%
        }
    %>
</div>

</body>
</html>
