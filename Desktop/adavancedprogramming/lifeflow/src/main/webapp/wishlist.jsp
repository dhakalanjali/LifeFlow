<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%@ page import="com.lifeflow.lifeflow.dao.WishlistDAO" %>
<%@ page import="java.util.*" %>
<%@ page session="true" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String userName = (String) session.getAttribute("userName");
    WishlistDAO wishlistDAO = new WishlistDAO();
    List<Map<String, String>> wishlist = wishlistDAO.getWishlist(currentUser.getUserId());
%>
<!DOCTYPE html>
<html lang="en"
>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - LifeFlow</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }

        .navbar {
            background: #C0392B;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        .navbar-brand { color: white; font-size: 1.4rem; font-weight: bold; text-decoration: none; }
        .navbar-links { display: flex; gap: 15px; flex-wrap: wrap; align-items: center; }
        .navbar-links a { color: white; text-decoration: none; font-size: 0.9rem; }
        .navbar-links a:hover { text-decoration: underline; }
        .btn-logout { background: rgba(255,255,255,0.15); color: #fff; border: 1px solid rgba(255,255,255,0.35); padding: 6px 14px; border-radius: 8px; font-weight: 500; font-size: 0.85rem; }

        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        h2 { color: #C0392B; margin-bottom: 20px; }

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 15px; font-weight: bold; }
        .alert-success { background: #d4edda; color: #155724; }

        .card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #C0392B;
            color: white;
            padding: 12px 15px;
            text-align: left;
            font-size: 0.85rem;
            text-transform: uppercase;
        }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 0.9rem; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #FEF0F0; }

        .status-badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
        }
        .upcoming { background: #fff3cd; color: #856404; }
        .ongoing { background: #d4edda; color: #155724; }
        .completed { background: #f8d7da; color: #721c24; }

        .btn-remove {
            padding: 6px 14px;
            background: #C0392B;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
        }
        .btn-remove:hover { background: #a93226; }

        .empty-msg {
            text-align: center;
            padding: 50px;
            color: #888;
        }
        .empty-msg p { margin-bottom: 10px; }
        .empty-msg a {
            color: #C0392B;
            font-weight: bold;
            text-decoration: none;
        }

        @media (max-width: 768px) {
            .navbar { padding: 12px 15px; }
            .navbar-links { gap: 8px; }
            .navbar-links a { font-size: 0.8rem; }
            .container { padding: 15px; }
        }
        @media (max-width: 480px) {
            .navbar-links { display: none; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">❤️ LifeFlow</a>
    <div class="navbar-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a>
        <a href="${pageContext.request.contextPath}/requestBlood.jsp">Request Blood</a>
        <a href="${pageContext.request.contextPath}/donationHistory.jsp">Donation History</a>
        <a href="${pageContext.request.contextPath}/wishlist.jsp">My Wishlist</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">My Profile</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>⭐ My Wishlist — Donation Camps</h2>

    <% if (session.getAttribute("wishlistMsg") != null) { %>
    <div class="alert alert-success"><%= session.getAttribute("wishlistMsg") %></div>
    <% session.removeAttribute("wishlistMsg"); %>
    <% } %>

    <div class="card">
        <% if (wishlist.isEmpty()) { %>
        <div class="empty-msg">
            <p>⭐ You have not wishlisted any donation camps yet!</p>
            <p>Go to <a href="${pageContext.request.contextPath}/searchBlood.jsp">Search Blood</a> page to find and wishlist upcoming camps!</p>
        </div>
        <% } else { %>
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Camp Name</th>
                    <th>Location</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (Map<String, String> camp : wishlist) { %>
                <tr>
                    <td><%= camp.get("campName") %></td>
                    <td><%= camp.get("location") %></td>
                    <td><%= camp.get("campDate") %></td>
                    <td>
                            <span class="status-badge <%= camp.get("status") %>">
                                <%= camp.get("status") %>
                            </span>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/removeWishlist"
                              method="post" style="display:inline;">
                            <input type="hidden" name="campId" value="<%= camp.get("campId") %>">
                            <button type="submit" class="btn-remove">🗑 Remove</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>
</div>

</body>
</html>