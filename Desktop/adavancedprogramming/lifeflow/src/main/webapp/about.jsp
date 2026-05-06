<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lifeflow.lifeflow.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | LifeFlow Blood Bank</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --primary-red: #c0392b; --dark-red: #96281b; --light-red: #f9ebea;
            --accent-red: #e74c3c; --white: #ffffff; --light-gray: #f4f6f7;
            --mid-gray: #bdc3c7; --dark-gray: #2c3e50; --text-muted: #7f8c8d;
            --success-green: #27ae60; --border-radius: 8px;
            --shadow: 0 2px 12px rgba(0,0,0,0.1); --transition: all 0.3s ease;
        }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: var(--light-gray); color: var(--dark-gray); line-height: 1.7; }
        nav { background-color: var(--primary-red); padding: 0 2rem; display: flex; align-items: center; justify-content: space-between; height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.2); position: sticky; top: 0; z-index: 100; }
        .nav-brand { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .nav-brand span { color: var(--white); font-size: 1.3rem; font-weight: 700; }
        .nav-links { display: flex; list-style: none; gap: 0.5rem; align-items: center; }
        .nav-links a { color: rgba(255,255,255,0.88); text-decoration: none; padding: 0.5rem 1rem; border-radius: var(--border-radius); font-size: 0.95rem; transition: var(--transition); }
        .nav-links a:hover, .nav-links a.active { background-color: rgba(255,255,255,0.2); color: var(--white); }
        .hamburger { display: none; flex-direction: column; cursor: pointer; gap: 5px; }
        .hamburger span { width: 25px; height: 3px; background: var(--white); border-radius: 3px; }
        .hero { background: linear-gradient(135deg, var(--dark-red) 0%, var(--primary-red) 60%, #e74c3c 100%); color: var(--white); padding: 5rem 2rem; text-align: center; }
        .hero h1 { font-size: 2.5rem; font-weight: 700; margin-bottom: 1rem; }
        .hero p { font-size: 1.1rem; opacity: 0.9; max-width: 600px; margin: 0 auto 2rem; }
        .hero-btn { display: inline-block; background: var(--white); color: var(--primary-red); padding: 0.85rem 2.5rem; border-radius: 50px; font-weight: 700; text-decoration: none; font-size: 1rem; transition: var(--transition); }
        .hero-btn:hover { background: var(--light-red); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.2); }
        .stats-strip { background: var(--white); display: flex; justify-content: center; flex-wrap: wrap; box-shadow: var(--shadow); }
        .stat-item { flex: 1; min-width: 130px; text-align: center; padding: 2rem 1rem; border-right: 1px solid var(--light-gray); }
        .stat-item:last-child { border-right: none; }
        .stat-item .num { font-size: 2.2rem; font-weight: 700; color: var(--primary-red); }
        .stat-item .lbl { font-size: 0.85rem; color: var(--text-muted); margin-top: 4px; }
        .section-wrapper { max-width: 1100px; margin: 0 auto; padding: 4rem 2rem; }
        .section-title { text-align: center; margin-bottom: 3rem; }
        .section-title h2 { font-size: 1.9rem; color: var(--dark-gray); margin-bottom: 0.5rem; }
        .section-title p { color: var(--text-muted); font-size: 1rem; max-width: 560px; margin: 0 auto; }
        .section-title .divider { width: 60px; height: 4px; background: var(--primary-red); margin: 1rem auto 0; border-radius: 2px; }
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 3rem; align-items: center; }
        .about-text h2 { font-size: 1.7rem; color: var(--dark-gray); margin-bottom: 1rem; }
        .about-text p { color: var(--text-muted); margin-bottom: 1rem; font-size: 0.97rem; }
        .about-text .highlight { color: var(--primary-red); font-weight: 600; }
        .about-image-placeholder { background: linear-gradient(135deg, var(--light-red), #fde8e8); border-radius: 16px; height: 320px; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 1rem; border: 2px dashed var(--mid-gray); }
        .about-image-placeholder .big-icon { font-size: 5rem; }
        .about-image-placeholder p { color: var(--text-muted); font-size: 0.9rem; }
        .mission-section { background: var(--white); }
        .mission-cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.5rem; }
        .mission-card { background: var(--light-gray); border-radius: 12px; padding: 2rem 1.5rem; text-align: center; transition: var(--transition); border-top: 4px solid transparent; }
        .mission-card:hover { transform: translateY(-4px); box-shadow: var(--shadow); border-top-color: var(--primary-red); }
        .mission-card .icon { font-size: 2.5rem; margin-bottom: 1rem; }
        .mission-card h3 { font-size: 1.1rem; color: var(--dark-gray); margin-bottom: 0.75rem; }
        .mission-card p { font-size: 0.9rem; color: var(--text-muted); }
        .services-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.25rem; }
        .service-item { background: var(--white); border-radius: 12px; padding: 1.5rem; display: flex; gap: 1rem; align-items: flex-start; box-shadow: var(--shadow); transition: var(--transition); }
        .service-item:hover { transform: translateY(-2px); }
        .service-item .svc-icon { font-size: 1.8rem; flex-shrink: 0; width: 48px; height: 48px; background: var(--light-red); border-radius: 10px; display: flex; align-items: center; justify-content: center; }
        .service-item h3 { font-size: 1rem; color: var(--dark-gray); margin-bottom: 0.4rem; }
        .service-item p { font-size: 0.88rem; color: var(--text-muted); }
        .awareness-section { background: var(--light-red); }
        .awareness-list { display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem; margin-top: 2rem; }
        .awareness-item { background: var(--white); border-radius: 10px; padding: 1.25rem; display: flex; gap: 0.75rem; align-items: flex-start; }
        .awareness-item .check { color: var(--success-green); font-size: 1.2rem; flex-shrink: 0; margin-top: 2px; }
        .awareness-item p { font-size: 0.9rem; color: var(--dark-gray); }
        .awareness-item strong { color: var(--primary-red); }
        .cta-section { background: linear-gradient(135deg, var(--dark-red), var(--primary-red)); color: var(--white); text-align: center; padding: 4rem 2rem; }
        .cta-section h2 { font-size: 2rem; margin-bottom: 1rem; }
        .cta-section p { font-size: 1rem; opacity: 0.9; max-width: 500px; margin: 0 auto 2rem; }
        .cta-buttons { display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap; }
        .cta-btn-primary { background: var(--white); color: var(--primary-red); padding: 0.85rem 2rem; border-radius: 50px; font-weight: 700; text-decoration: none; transition: var(--transition); }
        .cta-btn-primary:hover { background: var(--light-red); transform: translateY(-2px); }
        .cta-btn-outline { background: transparent; color: var(--white); padding: 0.85rem 2rem; border-radius: 50px; font-weight: 600; text-decoration: none; border: 2px solid rgba(255,255,255,0.7); transition: var(--transition); }
        .cta-btn-outline:hover { background: rgba(255,255,255,0.15); }
        footer { background-color: var(--dark-gray); color: rgba(255,255,255,0.7); text-align: center; padding: 1.25rem; font-size: 0.85rem; }
        footer a { color: rgba(255,255,255,0.85); text-decoration: none; }
        @media (max-width: 900px) {
            .about-grid { grid-template-columns: 1fr; }
            .mission-cards { grid-template-columns: 1fr 1fr; }
            .stats-strip { flex-wrap: wrap; }
            .stat-item { min-width: 130px; border-right: none; border-bottom: 1px solid var(--light-gray); }
        }
        @media (max-width: 768px) {
            nav { padding: 0 1rem; }
            .nav-links { display: none; flex-direction: column; position: absolute; top: 64px; left: 0; right: 0; background-color: var(--dark-red); padding: 1rem; gap: 0.25rem; }
            .nav-links.open { display: flex; }
            .hamburger { display: flex; }
            .hero h1 { font-size: 1.8rem; }
            .services-grid { grid-template-columns: 1fr; }
            .awareness-list { grid-template-columns: 1fr; }
            .mission-cards { grid-template-columns: 1fr; }
            .section-wrapper { padding: 2.5rem 1rem; }
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
        <%
            if(currentUser != null && "admin".equals(currentUser.getRole())) {
        %>
        <li><a href="<%=request.getContextPath()%>/adminDashboard.jsp">Admin Dashboard</a></li>
        <li><a href="<%=request.getContextPath()%>/manageBloodStock.jsp">Blood Stock</a></li>
        <li><a href="about.jsp" class="active">About</a></li>
        <li><a href="contact.jsp">Contact</a></li>
        <li><a href="<%=request.getContextPath()%>/logout">Logout</a></li>
        <% } else { %>
        <li><a href="index.jsp">Home</a></li>
        <li><a href="requestBlood.jsp">Request Blood</a></li>
        <li><a href="reports.jsp">Reports</a></li>
        <li><a href="about.jsp" class="active">About</a></li>
        <li><a href="contact.jsp">Contact</a></li>
        <% if(currentUser != null) { %>
        <li><a href="<%=request.getContextPath()%>/logout">Logout</a></li>
        <% } else { %>
        <li><a href="<%=request.getContextPath()%>/login">Login</a></li>
        <% } %>
        <% } %>
    </ul>
</nav>

<header class="hero" role="banner">
    <h1>Saving Lives, One Drop at a Time</h1>
    <p>LifeFlow Blood Bank has been at the heart of emergency healthcare in Kathmandu since 2005, connecting donors with patients who need it most.</p>
    <a href="requestBlood.jsp" class="hero-btn">Request Blood Now</a>
</header>

<section class="stats-strip" aria-label="Organisation statistics">
    <div class="stat-item"><div class="num">12,400+</div><div class="lbl">Units Donated</div></div>
    <div class="stat-item"><div class="num">3,200+</div><div class="lbl">Lives Saved</div></div>
    <div class="stat-item"><div class="num">850+</div><div class="lbl">Registered Donors</div></div>
    <div class="stat-item"><div class="num">18+</div><div class="lbl">Partner Hospitals</div></div>
</section>

<section aria-labelledby="aboutHeading">
    <div class="section-wrapper">
        <div class="about-grid">
            <div class="about-text">
                <h2 id="aboutHeading">About LifeFlow Blood Bank</h2>
                <p>LifeFlow Blood Bank is a <span class="highlight">non-profit healthcare organisation</span> based in Kathmandu, dedicated to maintaining a safe and adequate supply of blood for patients across the city's hospitals and clinics.</p>
                <p>Founded in 2005, we work closely with the Ministry of Health and private healthcare providers to ensure that blood of all types is available when and where it is needed most. Our team of trained medical professionals and volunteers operate 24 hours a day, 7 days a week.</p>
                <p>We believe that <span class="highlight">every donation matters</span>. A single blood donation can save up to three lives, and our mission is to make the donation process as simple, safe, and accessible as possible for everyone in the community.</p>
            </div>
            <div class="about-image-placeholder" role="img" aria-label="Blood bank organisation illustration">
                <div class="big-icon">&#129656;</div>
                <p>LifeFlow Blood Bank, Kathmandu</p>
            </div>
        </div>
    </div>
</section>

<section class="mission-section" aria-labelledby="missionHeading">
    <div class="section-wrapper">
        <div class="section-title">
            <h2 id="missionHeading">Our Mission &amp; Values</h2>
            <p>Everything we do is guided by three core principles that put patients and donors first.</p>
            <div class="divider"></div>
        </div>
        <div class="mission-cards">
            <article class="mission-card">
                <div class="icon">&#10084;&#65039;</div>
                <h3>Save Lives</h3>
                <p>Our primary goal is to ensure that no patient is denied life-saving blood due to shortage. We maintain critical stock levels at all times.</p>
            </article>
            <article class="mission-card">
                <div class="icon">&#128101;</div>
                <h3>Community First</h3>
                <p>We actively engage with local communities to raise awareness about blood donation and recruit new donors from all backgrounds.</p>
            </article>
            <article class="mission-card">
                <div class="icon">&#128737;&#65039;</div>
                <h3>Safety &amp; Trust</h3>
                <p>All donated blood undergoes rigorous testing and screening. We follow Ministry of Health and WHO guidelines to ensure the highest standards of safety.</p>
            </article>
        </div>
    </div>
</section>

<section aria-labelledby="servicesHeading">
    <div class="section-wrapper">
        <div class="section-title">
            <h2 id="servicesHeading">Our Services</h2>
            <p>We offer a comprehensive range of blood-related services to hospitals, clinics, and individuals.</p>
            <div class="divider"></div>
        </div>
        <div class="services-grid">
            <article class="service-item">
                <div class="svc-icon">&#129656;</div>
                <div><h3>Blood Collection</h3><p>Regular donation drives at our centre and mobile units across Kathmandu. Walk-in and appointment-based sessions available.</p></div>
            </article>
            <article class="service-item">
                <div class="svc-icon">&#128203;</div>
                <div><h3>Blood Request Processing</h3><p>Fast-track processing of blood requests from hospitals and patients. Emergency requests handled within 30 minutes.</p></div>
            </article>
            <article class="service-item">
                <div class="svc-icon">&#128300;</div>
                <div><h3>Blood Screening &amp; Testing</h3><p>All donations are tested for infectious diseases and blood type compatibility before being added to our stock.</p></div>
            </article>
            <article class="service-item">
                <div class="svc-icon">&#128666;</div>
                <div><h3>Emergency Supply</h3><p>24/7 emergency blood supply service for critical care units, trauma centres, and surgical teams across Kathmandu.</p></div>
            </article>
            <article class="service-item">
                <div class="svc-icon">&#128218;</div>
                <div><h3>Donor Education</h3><p>Workshops, leaflets, and online resources to educate the public about the importance and process of blood donation.</p></div>
            </article>
            <article class="service-item">
                <div class="svc-icon">&#128202;</div>
                <div><h3>Stock Reporting</h3><p>Real-time blood stock monitoring and reporting for partner hospitals, ensuring transparency and preparedness.</p></div>
            </article>
        </div>
    </div>
</section>

<section class="awareness-section" aria-labelledby="awarenessHeading">
    <div class="section-wrapper">
        <div class="section-title">
            <h2 id="awarenessHeading">Blood Donation Awareness</h2>
            <p>Understanding the facts about blood donation helps break down barriers and encourages more people to give.</p>
            <div class="divider"></div>
        </div>
        <div class="awareness-list">
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>One donation saves up to 3 lives.</strong> Your single donation can be separated into red cells, platelets, and plasma.</p></div>
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>Donation takes only 45-60 minutes.</strong> The actual blood draw takes around 10 minutes. The rest is registration and recovery.</p></div>
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>O- is the universal donor type.</strong> It can be given to any patient in an emergency, making it the most critical blood type to stock.</p></div>
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>You can donate every 12 weeks.</strong> Healthy adults aged 17-66 can donate whole blood up to four times per year.</p></div>
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>Blood cannot be manufactured.</strong> There is no artificial substitute for human blood, making donors irreplaceable.</p></div>
            <div class="awareness-item"><span class="check">&#10003;</span><p><strong>Demand never stops.</strong> Every day, hospitals in Nepal use around 5,000 units of blood for patients in need.</p></div>
        </div>
    </div>
</section>

<section class="cta-section" aria-labelledby="ctaHeading">
    <h2 id="ctaHeading">Ready to Make a Difference?</h2>
    <p>Whether you need blood urgently or want to become a donor, we are here to help 24 hours a day.</p>
    <div class="cta-buttons">
        <a href="requestBlood.jsp" class="cta-btn-primary">Request Blood</a>
        <a href="contact.jsp" class="cta-btn-outline">Contact Us</a>
    </div>
</section>

<footer role="contentinfo">
    <p>&copy; 2026 LifeFlow Blood Bank Management System |
        <a href="contact.jsp">Contact Us</a>
    </p>
</footer>

<script>
    document.getElementById('hamburger').addEventListener('click', () => {
        document.getElementById('navLinks').classList.toggle('open');
    });
</script>
</body>
</html>