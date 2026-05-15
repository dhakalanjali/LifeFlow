<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    boolean isAdmin = currentUser != null && "admin".equals(currentUser.getRole());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | LifeFlow Blood Bank</title>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --red: #c0392b;
            --red-dark: #a93226;
            --red-light: #f9ebea;
            --bg: #f0f2f5;
            --white: #ffffff;
            --text: #2c3e50;
            --text-muted: #7f8c8d;
            --border: #e8ecef;
            --shadow: 0 2px 12px rgba(0,0,0,0.08);
            --green: #27ae60;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Nunito', sans-serif; background: var(--bg); color: var(--text); display: flex; min-height: 100vh; line-height: 1.7; }

        /* ── SIDEBAR (admin only) ── */
        .sidebar { width: 240px; background: var(--red-dark); min-height: 100vh; position: fixed; left: 0; top: 0; display: flex; flex-direction: column; z-index: 100; }
        .sidebar-logo { padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.15); display: flex; align-items: center; gap: 10px; }
        .sidebar-logo .logo-icon { width: 38px; height: 38px; background: white; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .sidebar-logo span { color: white; font-size: 18px; font-weight: 800; }
        .sidebar-section { padding: 16px 14px 6px; font-size: 10px; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 1.5px; font-weight: 700; }
        .sidebar-menu { padding: 0 10px; flex: 1; }
        .sidebar-menu a { display: flex; align-items: center; gap: 10px; padding: 10px 14px; color: rgba(255,255,255,0.75); text-decoration: none; border-radius: 8px; font-size: 13.5px; font-weight: 600; margin-bottom: 2px; transition: all 0.2s; }
        .sidebar-menu a:hover { background: rgba(255,255,255,0.15); color: white; }
        .sidebar-menu a.active { background: white; color: var(--red-dark); font-weight: 800; }
        .sidebar-menu a .icon { font-size: 16px; width: 20px; text-align: center; }
        .sidebar-footer { padding: 16px 10px; border-top: 1px solid rgba(255,255,255,0.15); }
        .sidebar-footer a { display: flex; align-items: center; gap: 10px; padding: 10px 14px; color: rgba(255,255,255,0.6); text-decoration: none; border-radius: 8px; font-size: 13px; font-weight: 600; transition: all 0.2s; }
        .sidebar-footer a:hover { background: rgba(255,255,255,0.15); color: white; }

        /* ── MAIN ── */
        .main { flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
        .main.with-sidebar { margin-left: 240px; }

        /* ── WHITE NAVBAR (guest/user only) ── */
        .navbar { background-color: #ffffff; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; position: sticky; top: 0; z-index: 200; box-shadow: 0 2px 15px rgba(0,0,0,0.1); }
        .navbar .logo { color: #C0392B; font-size: 22px; font-weight: 800; text-decoration: none; }
        .navbar .nav-links { display: flex; align-items: center; }
        .navbar .nav-links a { color: #2C3E50; text-decoration: none; margin-left: 20px; font-size: 15px; font-weight: 600; transition: color 0.2s; }
        .navbar .nav-links a:hover { color: #C0392B; }
        .navbar .nav-links a.active { color: #C0392B; font-weight: 700; }
        .btn-nav-login { background-color: #C0392B !important; color: white !important; padding: 8px 20px; border-radius: 25px; font-weight: 800 !important; }
        .btn-nav-login:hover { background-color: black !important; }
        .btn-nav-register { background-color: transparent !important; color: #C0392B !important; padding: 8px 20px; border-radius: 25px; border: 2px solid #C0392B; font-weight: 800 !important; }
        .btn-nav-register:hover { background-color: black !important; color: white !important; border-color: black !important; }

        /* ── ADMIN TOPBAR ── */
        .admin-topbar { background: var(--white); padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 1px 4px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 50; border-bottom: 3px solid var(--red); }
        .admin-topbar h2 { font-size: 18px; font-weight: 800; color: var(--text); }
        .topbar-admin { display: flex; align-items: center; gap: 10px; background: #fdecea; padding: 6px 14px 6px 8px; border-radius: 50px; }
        .admin-avatar { width: 32px; height: 32px; background: var(--red); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 14px; font-weight: 700; }
        .admin-name { font-size: 13px; font-weight: 700; color: var(--red-dark); }

        /* ── HERO ── */
        .hero { background: linear-gradient(135deg, var(--red-dark) 0%, var(--red) 60%, #e74c3c 100%); color: white; padding: 5rem 2rem; text-align: center; position: relative; overflow: hidden; }
        .hero::before { content: ''; position: absolute; inset: 0; background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23ffffff' fill-opacity='0.04'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/svg%3E"); }
        .hero-inner { position: relative; max-width: 700px; margin: 0 auto; }
        .hero-tag { display: inline-flex; align-items: center; gap: 6px; background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.2); color: #fca5a5; font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; padding: 5px 14px; border-radius: 20px; margin-bottom: 16px; }
        .hero h1 { font-size: 2.5rem; font-weight: 800; margin-bottom: 1rem; }
        .hero p { font-size: 1rem; opacity: 0.85; margin-bottom: 2rem; }
        .hero-btn { display: inline-block; background: white; color: var(--red); padding: 0.85rem 2.5rem; border-radius: 50px; font-weight: 800; text-decoration: none; font-size: 0.95rem; transition: all 0.2s; }
        .hero-btn:hover { background: var(--red-light); transform: translateY(-2px); }

        /* ── STATS STRIP ── */
        .stats-strip { background: var(--white); display: flex; justify-content: center; flex-wrap: wrap; box-shadow: var(--shadow); }
        .stat-item { flex: 1; min-width: 130px; text-align: center; padding: 2rem 1rem; border-right: 1px solid var(--border); }
        .stat-item:last-child { border-right: none; }
        .stat-item .num { font-size: 2rem; font-weight: 800; color: var(--red); }
        .stat-item .lbl { font-size: 0.82rem; color: var(--text-muted); margin-top: 4px; font-weight: 600; }

        /* ── SECTIONS ── */
        .section-wrapper { max-width: 1100px; margin: 0 auto; padding: 4rem 2rem; }
        .section-title { text-align: center; margin-bottom: 3rem; }
        .section-title h2 { font-size: 1.8rem; font-weight: 800; color: var(--text); margin-bottom: 0.5rem; }
        .section-title p { color: var(--text-muted); font-size: 0.95rem; max-width: 560px; margin: 0 auto; }
        .section-title .divider { width: 50px; height: 4px; background: var(--red); margin: 1rem auto 0; border-radius: 2px; }

        /* ── ABOUT GRID ── */
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: center; }
        .about-text h2 { font-size: 1.6rem; font-weight: 800; color: var(--text); margin-bottom: 1rem; }
        .about-text p { color: var(--text-muted); margin-bottom: 1rem; font-size: 0.95rem; }
        .about-text .highlight { color: var(--red); font-weight: 700; }
        .about-image { background: linear-gradient(135deg, var(--red-light), #fde8e8); border-radius: 16px; height: 320px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 1rem; border: 2px dashed #e0b0b0; }
        .about-image .big-icon { font-size: 5rem; }
        .about-image p { color: var(--text-muted); font-size: 0.9rem; font-weight: 600; }

        /* ── MISSION ── */
        .mission-section { background: var(--white); }
        .mission-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        .mission-card { background: var(--bg); border-radius: 14px; padding: 2rem 1.5rem; text-align: center; transition: all 0.2s; border-top: 4px solid transparent; }
        .mission-card:hover { transform: translateY(-4px); box-shadow: var(--shadow); border-top-color: var(--red); }
        .mission-card .icon { font-size: 2.5rem; margin-bottom: 1rem; }
        .mission-card h3 { font-size: 1rem; font-weight: 800; color: var(--text); margin-bottom: 0.75rem; }
        .mission-card p { font-size: 0.88rem; color: var(--text-muted); }

        /* ── SERVICES ── */
        .services-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.25rem; }
        .service-item { background: var(--white); border-radius: 14px; padding: 1.5rem; display: flex; gap: 1rem; align-items: flex-start; box-shadow: var(--shadow); transition: all 0.2s; border-left: 4px solid transparent; }
        .service-item:hover { transform: translateY(-2px); border-left-color: var(--red); }
        .svc-icon { font-size: 1.6rem; flex-shrink: 0; width: 46px; height: 46px; background: var(--red-light); border-radius: 10px; display: flex; align-items: center; justify-content: center; }
        .service-item h3 { font-size: 0.95rem; font-weight: 800; color: var(--text); margin-bottom: 0.4rem; }
        .service-item p { font-size: 0.86rem; color: var(--text-muted); }

        /* ── AWARENESS ── */
        .awareness-section { background: var(--red-light); }
        .awareness-list { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem; margin-top: 2rem; }
        .awareness-item { background: var(--white); border-radius: 12px; padding: 1.25rem; display: flex; gap: 0.75rem; align-items: flex-start; box-shadow: var(--shadow); }
        .awareness-item .check { color: var(--green); font-size: 1.2rem; flex-shrink: 0; margin-top: 2px; }
        .awareness-item p { font-size: 0.88rem; color: var(--text); }
        .awareness-item strong { color: var(--red); }

        /* ── CTA ── */
        .cta-section { background: linear-gradient(135deg, var(--red-dark), var(--red)); color: white; text-align: center; padding: 4rem 2rem; }
        .cta-section h2 { font-size: 2rem; font-weight: 800; margin-bottom: 1rem; }
        .cta-section p { font-size: 0.95rem; opacity: 0.9; max-width: 500px; margin: 0 auto 2rem; }
        .cta-buttons { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }
        .cta-btn-primary { background: white; color: var(--red); padding: 0.85rem 2rem; border-radius: 50px; font-weight: 800; text-decoration: none; transition: all 0.2s; }
        .cta-btn-primary:hover { background: var(--red-light); transform: translateY(-2px); }
        .cta-btn-outline { background: transparent; color: white; padding: 0.85rem 2rem; border-radius: 50px; font-weight: 700; text-decoration: none; border: 2px solid rgba(255,255,255,0.6); transition: all 0.2s; }
        .cta-btn-outline:hover { background: rgba(255,255,255,0.15); }

        /* ── FOOTER ── */
        footer { background: #1a252f; color: rgba(255,255,255,0.65); text-align: center; padding: 1.5rem; font-size: 0.85rem; font-weight: 600; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }
        footer a:hover { color: white; }

        /* ── RESPONSIVE ── */
        @media(max-width: 900px) {
            .about-grid { grid-template-columns: 1fr; }
            .mission-cards { grid-template-columns: 1fr 1fr; }
        }
        @media(max-width: 768px) {
            .sidebar { display: none; }
            .main.with-sidebar { margin-left: 0; }
            .navbar { padding: 15px 20px; }
            .hero h1 { font-size: 1.8rem; }
            .services-grid, .awareness-list, .mission-cards { grid-template-columns: 1fr; }
            .section-wrapper { padding: 2.5rem 1rem; }
        }
    </style>
</head>
<body>

<!-- ── ADMIN SIDEBAR ── -->
<% if(isAdmin) { %>
<aside class="sidebar">
    <div class="sidebar-logo">
        <div class="logo-icon">🩸</div>
        <span>LifeFlow</span>
    </div>
    <div class="sidebar-section">Admin Panel</div>
    <nav class="sidebar-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard"><span class="icon">🏠</span> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/manageUsers"><span class="icon">👥</span> Manage Users</a>
        <a href="${pageContext.request.contextPath}/manageCamps.jsp"><span class="icon">⛺</span> Manage Camps</a>
        <a href="${pageContext.request.contextPath}/manageBloodStock.jsp"><span class="icon">🩸</span> Blood Stock</a>
        <a href="${pageContext.request.contextPath}/bloodRequest"><span class="icon">🔍</span> Search Blood</a>
        <a href="${pageContext.request.contextPath}/reports.jsp"><span class="icon">📊</span> Reports</a>
        <a href="${pageContext.request.contextPath}/admin/recorddonation"><span class="icon">🩸</span> Record Donation</a>
        <a href="${pageContext.request.contextPath}/about.jsp" class="active"><span class="icon">ℹ️</span> About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp"><span class="icon">📞</span> Contact</a>
    </nav>
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout"><span class="icon">🚪</span> Logout</a>
    </div>
</aside>
<% } %>

<!-- ── MAIN ── -->
<div class="main <%= isAdmin ? "with-sidebar" : "" %>">

    <!-- ADMIN TOPBAR -->
    <% if(isAdmin) { %>
    <header class="admin-topbar">
        <h2>ℹ️ About</h2>
        <div class="topbar-admin">
            <div class="admin-avatar">A</div>
            <span class="admin-name">Admin</span>
        </div>
    </header>
    <% } else { %>
    <!-- WHITE NAVBAR for guests and regular users -->
    <nav class="navbar">
        <a href="index.jsp" class="logo">🩸 LifeFlow</a>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="about.jsp" class="active">About</a>
            <a href="contact.jsp">Contact</a>
            <% if(currentUser != null) { %>
            <a href="<%=request.getContextPath()%>/userDashboard.jsp">My Dashboard</a>
            <a href="<%=request.getContextPath()%>/logout" class="btn-nav-login">Logout</a>
            <% } else { %>
            <a href="<%=request.getContextPath()%>/login" class="btn-nav-login">Login</a>
            <a href="<%=request.getContextPath()%>/register" class="btn-nav-register">Register</a>
            <% } %>
        </div>
    </nav>
    <% } %>

    <!-- HERO -->
    <section class="hero">
        <div class="hero-inner">
            <div class="hero-tag">🩸 Est. 2005 · Kathmandu</div>
            <h1>Saving Lives, One Drop at a Time</h1>
            <p>LifeFlow Blood Bank has been at the heart of emergency healthcare in Kathmandu since 2005, connecting donors with patients who need it most.</p>
            <a href="contact.jsp" class="hero-btn">Contact Us</a>
        </div>
    </section>

    <!-- STATS STRIP -->
    <div class="stats-strip">
        <div class="stat-item"><div class="num">12,400+</div><div class="lbl">Units Donated</div></div>
        <div class="stat-item"><div class="num">3,200+</div><div class="lbl">Lives Saved</div></div>
        <div class="stat-item"><div class="num">850+</div><div class="lbl">Registered Donors</div></div>
        <div class="stat-item"><div class="num">18+</div><div class="lbl">Partner Hospitals</div></div>
    </div>

    <!-- ABOUT -->
    <section>
        <div class="section-wrapper">
            <div class="about-grid">
                <div class="about-text">
                    <h2>About LifeFlow Blood Bank</h2>
                    <p>LifeFlow Blood Bank is a <span class="highlight">non-profit healthcare organisation</span> based in Kathmandu, dedicated to maintaining a safe and adequate supply of blood for patients across the city's hospitals and clinics.</p>
                    <p>Founded in 2005, we work closely with the Ministry of Health and private healthcare providers to ensure that blood of all types is available when and where it is needed most. Our team of trained medical professionals and volunteers operate 24 hours a day, 7 days a week.</p>
                    <p>We believe that <span class="highlight">every donation matters</span>. A single blood donation can save up to three lives, and our mission is to make the donation process as simple, safe, and accessible as possible for everyone.</p>
                </div>
                <div class="about-image">
                    <div class="big-icon">🩸</div>
                    <p>LifeFlow Blood Bank, Kathmandu</p>
                </div>
            </div>
        </div>
    </section>

    <!-- MISSION -->
    <section class="mission-section">
        <div class="section-wrapper">
            <div class="section-title">
                <h2>Our Mission &amp; Values</h2>
                <p>Everything we do is guided by three core principles that put patients and donors first.</p>
                <div class="divider"></div>
            </div>
            <div class="mission-cards">
                <article class="mission-card"><div class="icon">❤️</div><h3>Save Lives</h3><p>Our primary goal is to ensure that no patient is denied life-saving blood due to shortage.</p></article>
                <article class="mission-card"><div class="icon">👥</div><h3>Community First</h3><p>We actively engage with local communities to raise awareness about blood donation.</p></article>
                <article class="mission-card"><div class="icon">🛡️</div><h3>Safety &amp; Trust</h3><p>All donated blood undergoes rigorous testing following Ministry of Health and WHO guidelines.</p></article>
            </div>
        </div>
    </section>

    <!-- SERVICES -->
    <section>
        <div class="section-wrapper">
            <div class="section-title">
                <h2>Our Services</h2>
                <p>We offer a comprehensive range of blood-related services to hospitals, clinics, and individuals.</p>
                <div class="divider"></div>
            </div>
            <div class="services-grid">
                <article class="service-item"><div class="svc-icon">🩸</div><div><h3>Blood Collection</h3><p>Regular donation drives at our centre and mobile units across Kathmandu.</p></div></article>
                <article class="service-item"><div class="svc-icon">📋</div><div><h3>Blood Request Processing</h3><p>Fast-track processing of blood requests. Emergency requests handled within 30 minutes.</p></div></article>
                <article class="service-item"><div class="svc-icon">🔬</div><div><h3>Blood Screening &amp; Testing</h3><p>All donations are tested for infectious diseases and blood type compatibility.</p></div></article>
                <article class="service-item"><div class="svc-icon">🚑</div><div><h3>Emergency Supply</h3><p>24/7 emergency blood supply service for critical care units across Kathmandu.</p></div></article>
                <article class="service-item"><div class="svc-icon">📚</div><div><h3>Donor Education</h3><p>Workshops and online resources to educate the public about blood donation.</p></div></article>
                <article class="service-item"><div class="svc-icon">📊</div><div><h3>Stock Reporting</h3><p>Real-time blood stock monitoring and reporting for partner hospitals.</p></div></article>
            </div>
        </div>
    </section>

    <!-- AWARENESS -->
    <section class="awareness-section">
        <div class="section-wrapper">
            <div class="section-title">
                <h2>Blood Donation Awareness</h2>
                <p>Understanding the facts about blood donation helps encourage more people to give.</p>
                <div class="divider"></div>
            </div>
            <div class="awareness-list">
                <div class="awareness-item"><span class="check">✓</span><p><strong>One donation saves up to 3 lives.</strong> Your single donation can be separated into red cells, platelets, and plasma.</p></div>
                <div class="awareness-item"><span class="check">✓</span><p><strong>Donation takes only 45–60 minutes.</strong> The actual blood draw takes around 10 minutes.</p></div>
                <div class="awareness-item"><span class="check">✓</span><p><strong>O- is the universal donor type.</strong> It can be given to any patient in an emergency.</p></div>
                <div class="awareness-item"><span class="check">✓</span><p><strong>You can donate every 12 weeks.</strong> Healthy adults aged 17–66 can donate up to four times per year.</p></div>
                <div class="awareness-item"><span class="check">✓</span><p><strong>Blood cannot be manufactured.</strong> There is no artificial substitute for human blood.</p></div>
                <div class="awareness-item"><span class="check">✓</span><p><strong>Demand never stops.</strong> Every day, hospitals in Nepal use around 5,000 units of blood.</p></div>
            </div>
        </div>
    </section>

    <!-- CTA -->
    <section class="cta-section">
        <h2>Ready to Make a Difference?</h2>
        <p>Whether you need blood urgently or want to become a donor, we are here to help 24 hours a day.</p>
        <div class="cta-buttons">
            <a href="<%=request.getContextPath()%>/register" class="cta-btn-primary">Register Now</a>
            <a href="contact.jsp" class="cta-btn-outline">Contact Us</a>
        </div>
    </section>

    <footer>
        <p>&copy; 2026 LifeFlow Blood Bank &mdash; <a href="contact.jsp">Contact Us</a></p>
    </footer>

</div>
</body>
</html>
