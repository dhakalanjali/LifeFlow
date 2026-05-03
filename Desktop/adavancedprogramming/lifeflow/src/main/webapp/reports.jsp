<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.lifeflow.dao.BloodRequestDAO" %>
<%@ page import="com.lifeflow.model.BloodRequest" %>
<%--
    reports.jsp
    Author: Pritam Rai
    Module: Admin Reports Dashboard
    Description: Displays blood stock, request statistics, and recent activity.
    Tribhuvan University - Blood Bank Management System
--%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="LifeFlow Blood Bank admin dashboard - view blood stock levels, request statistics, and manage blood request records.">
    <title>Reports | LifeFlow Blood Bank</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #c0392b;
            --dark-red: #96281b;
            --light-red: #f9ebea;
            --accent-red: #e74c3c;
            --white: #ffffff;
            --light-gray: #f4f6f7;
            --mid-gray: #bdc3c7;
            --dark-gray: #2c3e50;
            --text-muted: #7f8c8d;
            --success-green: #27ae60;
            --warning-orange: #e67e22;
            --info-blue: #2980b9;
            --sidebar-width: 240px;
            --border-radius: 8px;
            --shadow: 0 2px 12px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--light-gray); color: var(--dark-gray); }

        /* NAV */
        nav { background-color: var(--primary-red); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 200; }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-brand span { color: var(--white); font-size: 1.3rem; font-weight: 700; }
        .nav-links { display: flex; list-style: none; gap: 0.5rem; align-items: center; }
        .nav-links a { color: rgba(255,255,255,0.88); text-decoration: none; padding: 0.5rem 1rem; border-radius: var(--border-radius); font-size: 0.95rem; transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { background-color: rgba(255,255,255,0.2); color: var(--white); }
        .hamburger { display: none; flex-direction: column; cursor: pointer; gap: 5px; }
        .hamburger span { width: 25px; height: 3px; background: var(--white); border-radius: 3px; }

        /* DASHBOARD LAYOUT */
        .dashboard-layout { display: flex; min-height: calc(100vh - 64px); }

        /* SIDEBAR */
        .sidebar { width: var(--sidebar-width); background-color: var(--dark-gray); color: var(--white); padding: 1.5rem 0; flex-shrink: 0; }
        .sidebar-header { padding: 0 1.25rem 1.25rem; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 1rem; }
        .sidebar-header h3 { font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; color: var(--mid-gray); }
        .sidebar-nav { list-style: none; }
        .sidebar-nav li a { display: flex; align-items: center; gap: 10px; padding: 0.75rem 1.25rem; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 0.92rem; transition: var(--transition); border-left: 3px solid transparent; }
        .sidebar-nav li a:hover, .sidebar-nav li a.active { background-color: rgba(255,255,255,0.08); color: var(--white); border-left-color: var(--accent-red); }
        .sidebar-nav li a .icon { font-size: 1rem; width: 20px; text-align: center; }
        .sidebar-divider { height: 1px; background: rgba(255,255,255,0.1); margin: 0.75rem 1.25rem; }

        /* MAIN CONTENT */
        .main-content { flex: 1; padding: 2rem; overflow-x: hidden; }
        .page-title { margin-bottom: 1.75rem; }
        .page-title h1 { font-size: 1.6rem; color: var(--dark-gray); }
        .page-title p { color: var(--text-muted); font-size: 0.92rem; margin-top: 0.25rem; }

        /* STATS CARDS ROW */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.25rem; margin-bottom: 2rem; }
        .stat-card { background: var(--white); border-radius: 12px; padding: 1.25rem 1.5rem; box-shadow: var(--shadow); display: flex; align-items: center; gap: 1rem; border-top: 4px solid transparent; transition: var(--transition); }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        .stat-card.red   { border-top-color: var(--primary-red); }
        .stat-card.green { border-top-color: var(--success-green); }
        .stat-card.orange{ border-top-color: var(--warning-orange); }
        .stat-card.blue  { border-top-color: var(--info-blue); }
        .stat-icon { font-size: 2rem; width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; border-radius: 10px; flex-shrink: 0; }
        .stat-card.red   .stat-icon { background: var(--light-red); }
        .stat-card.green .stat-icon { background: #eafaf1; }
        .stat-card.orange .stat-icon { background: #fef5e7; }
        .stat-card.blue  .stat-icon { background: #ebf5fb; }
        .stat-info .stat-value { font-size: 1.8rem; font-weight: 700; line-height: 1; }
        .stat-card.red   .stat-value { color: var(--primary-red); }
        .stat-card.green .stat-value { color: var(--success-green); }
        .stat-card.orange .stat-value { color: var(--warning-orange); }
        .stat-card.blue  .stat-value { color: var(--info-blue); }
        .stat-info .stat-label { font-size: 0.82rem; color: var(--text-muted); margin-top: 4px; }

        /* BLOOD STOCK SECTION */
        .section-card { background: var(--white); border-radius: 12px; box-shadow: var(--shadow); padding: 1.5rem; margin-bottom: 1.75rem; }
        .section-card h2 { font-size: 1.1rem; color: var(--dark-gray); margin-bottom: 1.25rem; padding-bottom: 0.75rem; border-bottom: 2px solid var(--light-gray); display: flex; align-items: center; gap: 8px; }
        .blood-stock-grid { display: grid; grid-template-columns: repeat(8, 1fr); gap: 0.75rem; }
        .blood-type-card { text-align: center; padding: 1rem 0.5rem; border-radius: 10px; border: 2px solid var(--light-gray); transition: var(--transition); cursor: default; }
        .blood-type-card:hover { border-color: var(--primary-red); background: var(--light-red); }
        .blood-type-card .blood-label { font-size: 1.2rem; font-weight: 700; color: var(--primary-red); }
        .blood-type-card .blood-units { font-size: 0.78rem; color: var(--text-muted); margin-top: 4px; }
        .blood-type-card .stock-bar { height: 6px; background: var(--light-gray); border-radius: 3px; margin-top: 8px; overflow: hidden; }
        .blood-type-card .stock-fill { height: 100%; border-radius: 3px; transition: width 0.6s ease; }
        .fill-high   { background: var(--success-green); }
        .fill-medium { background: var(--warning-orange); }
        .fill-low    { background: var(--accent-red); }

        /* SEARCH / FILTER BAR */
        .filter-bar { display: flex; gap: 1rem; align-items: center; flex-wrap: wrap; margin-bottom: 1.25rem; }
        .filter-bar input, .filter-bar select { padding: 0.55rem 0.9rem; border: 1.5px solid var(--mid-gray); border-radius: var(--border-radius); font-size: 0.9rem; font-family: inherit; outline: none; transition: var(--transition); }
        .filter-bar input:focus, .filter-bar select:focus { border-color: var(--primary-red); }
        .filter-bar input { flex: 1; min-width: 180px; }
        .btn-filter { padding: 0.55rem 1.25rem; background: var(--primary-red); color: var(--white); border: none; border-radius: var(--border-radius); font-size: 0.9rem; cursor: pointer; font-family: inherit; transition: var(--transition); }
        .btn-filter:hover { background: var(--dark-red); }

        /* REPORTS TABLE */
        .table-wrapper { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; font-size: 0.9rem; }
        thead tr { background-color: var(--light-red); }
        thead th { padding: 0.85rem 1rem; text-align: left; font-weight: 600; color: var(--dark-red); font-size: 0.82rem; text-transform: uppercase; letter-spacing: 0.5px; white-space: nowrap; }
        tbody tr { border-bottom: 1px solid var(--light-gray); transition: background 0.2s; }
        tbody tr:hover { background-color: #fdfafa; }
        tbody td { padding: 0.85rem 1rem; color: var(--dark-gray); vertical-align: middle; }
        .badge-status { padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .status-pending   { background: #fef5e7; color: #d35400; }
        .status-fulfilled { background: #eafaf1; color: #1e8449; }
        .status-cancelled { background: #f2f3f4; color: #7f8c8d; }
        .status-critical  { background: #fdecea; color: #c0392b; }
        .blood-group-badge { background: var(--light-red); color: var(--primary-red); padding: 2px 8px; border-radius: 4px; font-weight: 700; font-size: 0.85rem; }
        .no-data { text-align: center; padding: 2rem; color: var(--text-muted); font-style: italic; }

        /* PAGINATION */
        .pagination { display: flex; justify-content: flex-end; align-items: center; gap: 0.5rem; margin-top: 1rem; }
        .pagination button { padding: 0.4rem 0.85rem; border: 1.5px solid var(--mid-gray); background: var(--white); border-radius: var(--border-radius); cursor: pointer; font-size: 0.88rem; transition: var(--transition); }
        .pagination button:hover, .pagination button.active { background: var(--primary-red); color: var(--white); border-color: var(--primary-red); }

        /* SR-ONLY - visually hidden but accessible to screen readers */
        .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); white-space: nowrap; border: 0; }

        /* SELECT ARROW - consistent with other pages */
        select {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%237f8c8d' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.9rem center;
            padding-right: 2.2rem;
            cursor: pointer;
        }

        /* FOOTER */
        footer { background-color: var(--dark-gray); color: rgba(255,255,255,0.7); text-align: center; padding: 1.25rem; font-size: 0.85rem; }

        /* RESPONSIVE */
        @media (max-width: 1100px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .blood-stock-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 900px) {
            .sidebar { display: none; }
            .dashboard-layout { flex-direction: column; }
        }
        @media (max-width: 768px) {
            nav { padding: 0 1rem; }
            .nav-links { display: none; flex-direction: column; position: absolute; top: 64px; left: 0; right: 0; background-color: var(--dark-red); padding: 1rem; gap: 0.25rem; }
            .nav-links.open { display: flex; }
            .hamburger { display: flex; }
            .main-content { padding: 1rem; }
            .stats-grid { grid-template-columns: 1fr 1fr; }
            .blood-stock-grid { grid-template-columns: repeat(4, 1fr); }
        }
        @media (max-width: 480px) {
            .stats-grid { grid-template-columns: 1fr; }
            .blood-stock-grid { grid-template-columns: repeat(2, 1fr); }
        }
    </style>
</head>
<body>

<nav role="navigation" aria-label="Main navigation">
    <a href="index.jsp" class="nav-brand">
        <span>&#129656; LifeFlow Blood Bank</span>
    </a>
    <div class="hamburger" id="hamburger" role="button" tabindex="0" aria-label="Toggle navigation">
        <span></span><span></span><span></span>
    </div>
    <ul class="nav-links" id="navLinks">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="requestBlood.jsp">Request Blood</a></li>
        <li><a href="reports.jsp" class="active" aria-current="page">Reports</a></li>
        <li><a href="about.jsp">About</a></li>
        <li><a href="contact.jsp">Contact</a></li>
    </ul>
</nav>

<div class="dashboard-layout">

    <!-- SIDEBAR NAVIGATION -->
    <aside class="sidebar" role="complementary" aria-label="Dashboard sidebar">
        <div class="sidebar-header">
            <h3>Dashboard</h3>
        </div>
        <ul class="sidebar-nav">
            <li><a href="#overview" class="active"><span class="icon">&#128202;</span> Overview</a></li>
            <li><a href="#bloodStock"><span class="icon">&#129656;</span> Blood Stock</a></li>
            <li><a href="#requests"><span class="icon">&#128203;</span> All Requests</a></li>
            <li><a href="#donations"><span class="icon">&#128137;</span> Donations</a></li>
        </ul>
        <div class="sidebar-divider"></div>
        <ul class="sidebar-nav">
            <li><a href="requestBlood.jsp"><span class="icon">&#10133;</span> New Request</a></li>
            <li><a href="contact.jsp"><span class="icon">&#128222;</span> Contact</a></li>
        </ul>
    </aside>

    <!-- MAIN DASHBOARD CONTENT -->
    <main class="main-content" role="main">

        <div class="page-title">
            <h1>&#128202; Reports &amp; Dashboard</h1>
            <p>Overview of blood bank activity, stock levels, and request history</p>
        </div>

        <!-- STATISTICS CARDS -->
        <section id="overview" aria-labelledby="statsHeading">
            <h2 id="statsHeading" class="sr-only">Statistics Overview</h2>
            <div class="stats-grid">
                <div class="stat-card red">
                    <div class="stat-icon">&#129656;</div>
                    <div class="stat-info">
                        <div class="stat-value">342</div>
                        <div class="stat-label">Total Blood Units</div>
                    </div>
                </div>
                <div class="stat-card green">
                    <div class="stat-icon">&#10003;</div>
                    <div class="stat-info">
                        <div class="stat-value">128</div>
                        <div class="stat-label">Requests Fulfilled</div>
                    </div>
                </div>
                <div class="stat-card orange">
                    <div class="stat-icon">&#8987;</div>
                    <div class="stat-info">
                        <div class="stat-value">14</div>
                        <div class="stat-label">Pending Requests</div>
                    </div>
                </div>
                <div class="stat-card blue">
                    <div class="stat-icon">&#128137;</div>
                    <div class="stat-info">
                        <div class="stat-value">89</div>
                        <div class="stat-label">Total Donors</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- BLOOD STOCK SECTION -->
        <section class="section-card" id="bloodStock" aria-labelledby="stockHeading">
            <h2 id="stockHeading">&#129656; Current Blood Stock Levels</h2>
            <div class="blood-stock-grid">
                <!-- Each card shows blood type, units, and a visual stock bar -->
                <div class="blood-type-card" role="article" aria-label="Blood type A positive: 45 units">
                    <div class="blood-label">A+</div>
                    <div class="blood-units">45 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-high" style="width:90%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type A negative: 12 units">
                    <div class="blood-label">A-</div>
                    <div class="blood-units">12 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-medium" style="width:40%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type B positive: 38 units">
                    <div class="blood-label">B+</div>
                    <div class="blood-units">38 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-high" style="width:76%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type B negative: 8 units">
                    <div class="blood-label">B-</div>
                    <div class="blood-units">8 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-low" style="width:16%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type AB positive: 22 units">
                    <div class="blood-label">AB+</div>
                    <div class="blood-units">22 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-medium" style="width:44%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type AB negative: 5 units">
                    <div class="blood-label">AB-</div>
                    <div class="blood-units">5 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-low" style="width:10%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type O positive: 60 units">
                    <div class="blood-label">O+</div>
                    <div class="blood-units">60 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-high" style="width:100%"></div></div>
                </div>
                <div class="blood-type-card" role="article" aria-label="Blood type O negative: 18 units">
                    <div class="blood-label">O-</div>
                    <div class="blood-units">18 units</div>
                    <div class="stock-bar"><div class="stock-fill fill-medium" style="width:36%"></div></div>
                </div>
            </div>
        </section>

        <!-- REQUESTS TABLE SECTION -->
        <section class="section-card" id="requests" aria-labelledby="requestsHeading">
            <h2 id="requestsHeading">&#128203; Blood Request Records</h2>

            <!-- Search and Filter Bar -->
            <div class="filter-bar" role="search" aria-label="Filter blood requests">
                <input type="text"
                       id="searchInput"
                       placeholder="Search by patient name or hospital..."
                       aria-label="Search requests"
                       oninput="filterTable()">
                <select id="filterBloodGroup" aria-label="Filter by blood group" onchange="filterTable()">
                    <option value="">All Blood Groups</option>
                    <option value="A+">A+</option>
                    <option value="A-">A-</option>
                    <option value="B+">B+</option>
                    <option value="B-">B-</option>
                    <option value="AB+">AB+</option>
                    <option value="AB-">AB-</option>
                    <option value="O+">O+</option>
                    <option value="O-">O-</option>
                </select>
                <select id="filterStatus" aria-label="Filter by status" onchange="filterTable()">
                    <option value="">All Statuses</option>
                    <option value="Pending">Pending</option>
                    <option value="Fulfilled">Fulfilled</option>
                    <option value="Cancelled">Cancelled</option>
                </select>
                <button class="btn-filter" onclick="resetFilters()">Reset</button>
            </div>

            <!-- Reports Table -->
            <div class="table-wrapper">
                <table id="requestsTable" aria-label="Blood request records table">
                    <thead>
                        <tr>
                            <th scope="col">Request ID</th>
                            <th scope="col">Patient Name</th>
                            <th scope="col">Blood Group</th>
                            <th scope="col">Hospital</th>
                            <th scope="col">Urgency</th>
                            <th scope="col">Request Date</th>
                            <th scope="col">Status</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <%
                            BloodRequestDAO dao = new BloodRequestDAO();
                            List<BloodRequest> requests = dao.getAllRequests();
                            
                            if (requests != null && !requests.isEmpty()) {
                                for (BloodRequest br : requests) {
                        %>
                        <tr>
                            <td>#REQ-<%= String.format("%03d", br.getRequestId()) %></td>
                            <td><%= br.getPatientName() %></td>
                            <td><span class="blood-group-badge"><%= br.getBloodGroup() %></span></td>
                            <td><%= br.getHospitalName() %></td>
                            <td>
                                <% String uClass = br.isCritical() ? "status-critical" : (br.getUrgencyLevel().equals("Urgent") ? "status-pending" : "status-fulfilled"); %>
                                <span class="badge-status <%= uClass %>"><%= br.getUrgencyLevel() %></span>
                            </td>
                            <td><%= br.getRequestDate() %></td>
                            <td>
                                <% String sClass = br.getStatus().equals("Fulfilled") ? "status-fulfilled" : (br.getStatus().equals("Cancelled") ? "status-cancelled" : "status-pending"); %>
                                <span class="badge-status <%= sClass %>"><%= br.getStatus() %></span>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <!-- Static sample data for demonstration when DB is empty-->
                        <tr>
                            <td>#REQ-001</td>
                            <td>Ram Bahadur</td>
                            <td><span class="blood-group-badge">O+</span></td>
                            <td>Durga Mata Hospital</td>
                            <td><span class="badge-status status-critical">Critical</span></td>
                            <td>2024-11-10</td>
                            <td><span class="badge-status status-fulfilled">Fulfilled</span></td>
                        </tr>
                        <tr>
                            <td>#REQ-002</td>
                            <td>Sita Khadka</td>
                            <td><span class="blood-group-badge">B+</span></td>
                            <td>Bir Hospital</td>
                            <td><span class="badge-status status-pending">Urgent</span></td>
                            <td>2024-11-12</td>
                            <td><span class="badge-status status-pending">Pending</span></td>
                        </tr>
                        <tr>
                            <td>#REQ-003</td>
                            <td>Hari Bahadur</td>
                            <td><span class="blood-group-badge">A-</span></td>
                            <td>Patan Hospital</td>
                            <td><span class="badge-status status-pending">Normal</span></td>
                            <td>2024-11-13</td>
                            <td><span class="badge-status status-fulfilled">Fulfilled</span></td>
                        </tr>
                        <tr>
                            <td>#REQ-004</td>
                            <td>Gita Devi</td>
                            <td><span class="blood-group-badge">AB-</span></td>
                            <td>Norvic Hospital</td>
                            <td><span class="badge-status status-critical">Critical</span></td>
                            <td>2024-11-14</td>
                            <td><span class="badge-status status-pending">Pending</span></td>
                        </tr>
                        <tr>
                            <td>#REQ-005</td>
                            <td>Sherpa Tenzing</td>
                            <td><span class="blood-group-badge">O-</span></td>
                            <td>Teaching Hospital</td>
                            <td><span class="badge-status status-pending">Urgent</span></td>
                            <td>2024-11-15</td>
                            <td><span class="badge-status status-cancelled">Cancelled</span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination controls -->
            <div class="pagination" aria-label="Table pagination">
                <button onclick="changePage(1)" class="active" aria-label="Page 1">1</button>
                <button onclick="changePage(2)" aria-label="Page 2">2</button>
                <button onclick="changePage(3)" aria-label="Page 3">3</button>
            </div>
        </section>

    </main>
</div>

<footer role="contentinfo">
    <p>&copy; 2024 LifeFlow Blood Bank Management System &mdash; Tribhuvan University</p>
</footer>

<script>
    // Mobile nav toggle
    document.getElementById('hamburger').addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('open');
    });

    // Filter table rows based on search input and dropdowns
    function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const bloodGroup = document.getElementById('filterBloodGroup').value.toLowerCase();
        const status = document.getElementById('filterStatus').value.toLowerCase();
        const rows = document.querySelectorAll('#tableBody tr');

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            const matchSearch = text.includes(search);
            const matchBlood = bloodGroup === '' || text.includes(bloodGroup);
            const matchStatus = status === '' || text.includes(status);
            row.style.display = (matchSearch && matchBlood && matchStatus) ? '' : 'none';
        });
    }

    // Reset all filters
    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('filterBloodGroup').value = '';
        document.getElementById('filterStatus').value = '';
        filterTable();
    }

    // Placeholder pagination handler
    function changePage(page) {
        document.querySelectorAll('.pagination button').forEach((btn, i) => {
            btn.classList.toggle('active', i + 1 === page);
        });
        // In a real implementation, this would reload data for the selected page
    }
</script>
</body>
</html>
