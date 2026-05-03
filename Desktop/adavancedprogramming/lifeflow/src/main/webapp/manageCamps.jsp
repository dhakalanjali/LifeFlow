<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Camps - Blood Donation System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; }
        .container { max-width: 800px; margin: auto; background: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h2 { color: #c0392b; border-bottom: 2px solid #e74c3c; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border: 1px solid #ddd; text-align: left; }
        th { background-color: #e74c3c; color: white; }
        .btn { padding: 8px 12px; background-color: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn:hover { background-color: #2ecc71; }
        .btn-danger { background-color: #c0392b; }
        .btn-danger:hover { background-color: #e74c3c; }
    </style>
</head>
<body>

<div class="container">
    <h2>Manage Donation Camps</h2>
    
    <div style="margin-bottom: 15px; text-align: right;">
        <button class="btn">+ Add New Camp</button>
    </div>

    <!-- Placeholder for dynamic table data -->
    <table>
        <thead>
            <tr>
                <th>Camp ID</th>
                <th>Name</th>
                <th>Location</th>
                <th>Date</th>
                <th>Organizer</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>101</td>
                <td>City Hospital Drive</td>
                <td>Central Park Plaza</td>
                <td>2024-05-15</td>
                <td>Red Cross Society</td>
                <td>
                    <button class="btn">Edit</button>
                    <button class="btn btn-danger">Delete</button>
                </td>
            </tr>
            <tr>
                <td>102</td>
                <td>University Blood Camp</td>
                <td>Main Campus Gym</td>
                <td>2024-06-02</td>
                <td>Student Union</td>
                <td>
                    <button class="btn">Edit</button>
                    <button class="btn btn-danger">Delete</button>
                </td>
            </tr>
        </tbody>
    </table>
</div>

</body>
</html>
