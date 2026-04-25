<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | About Us</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css" />
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<%-- HERO --%>
<section class="ab-hero">
    <div class="ab-hero__bg-text" aria-hidden="true">AURA</div>
    <div class="ab-hero__content">
        <span class="ab-hero__eyebrow">✦ Our Story ✦</span>
        <h1 class="ab-hero__title">Beauty Crafted<br/><em>With Passion</em></h1>
        <p class="ab-hero__desc">
            AuraLuxe was born from a shared dream — five students who believed that premium beauty
            should be accessible, honest, and empowering. We are developers, designers, and dreamers
            united by our love for craft.
        </p>
        <div class="ab-hero__stats">
            <div class="ab-hero__stat"><span class="ab-hero__stat-num">5</span><span class="ab-hero__stat-label">Creators</span></div>
            <div class="ab-hero__stat-divider"></div>
            <div class="ab-hero__stat"><span class="ab-hero__stat-num">1</span><span class="ab-hero__stat-label">Vision</span></div>
            <div class="ab-hero__stat-divider"></div>
            <div class="ab-hero__stat"><span class="ab-hero__stat-num">∞</span><span class="ab-hero__stat-label">Passion</span></div>
        </div>
    </div>
    <div class="ab-hero__orb ab-hero__orb--1"></div>
    <div class="ab-hero__orb ab-hero__orb--2"></div>
</section>

<%-- MISSION --%>
<section class="ab-mission">
    <div class="ab-mission__inner">
        <div class="ab-mission__card">
            <span class="ab-mission__icon">💄</span>
            <h3 class="ab-mission__title">Our Mission</h3>
            <p class="ab-mission__text">To bring luxury beauty products to every doorstep in Nepal — curated with care, delivered with love.</p>
        </div>
        <div class="ab-mission__card">
            <span class="ab-mission__icon">✨</span>
            <h3 class="ab-mission__title">Our Vision</h3>
            <p class="ab-mission__text">A Nepal where every person can access world-class beauty products without compromise on quality or price.</p>
        </div>
        <div class="ab-mission__card">
            <span class="ab-mission__icon">🌸</span>
            <h3 class="ab-mission__title">Our Values</h3>
            <p class="ab-mission__text">Authenticity, inclusivity, and elegance guide every decision we make — from code to customer experience.</p>
        </div>
    </div>
</section>

<%-- TEAM --%>
<section class="ab-team">
    <div class="ab-team__inner">
        <div class="ab-team__header">
            <span class="ab-team__eyebrow">The People Behind AuraLuxe</span>
            <h2 class="ab-team__title">Meet Our Team</h2>
        </div>

        <div class="ab-team__grid">

            <!-- Pranisha KC -->
            <div class="ab-member" style="--clr:#c4687d;">
                <div class="ab-member__photo-wrap">
                    <img src="${pageContext.request.contextPath}/images/pranisha.jpg"
                         alt="Pranisha KC"
                         class="ab-member__photo"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                    <div class="ab-member__initial-fallback">P</div>
                    <div class="ab-member__glow"></div>
                </div>
                <div class="ab-member__info">
                    <h3 class="ab-member__name">Pranisha KC</h3>
                    <span class="ab-member__role">Backend Developer</span>
                    <p class="ab-member__desc">Powers the engine behind AuraLuxe — building robust APIs, managing server logic, and keeping everything running seamlessly.</p>
                    <div class="ab-member__tags">
                        <span>Java</span><span>Servlets</span><span>MySQL</span>
                    </div>
                </div>
            </div>

            <!-- Prakriti Karki -->
            <div class="ab-member" style="--clr:#8b2442;">
                <div class="ab-member__photo-wrap">
                    <img src="https://randomuser.me/api/portraits/women/68.jpg"
                         alt="Prakriti Karki"
                         class="ab-member__photo"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                    <div class="ab-member__initial-fallback">P</div>
                    <div class="ab-member__glow"></div>
                </div>
                <div class="ab-member__info">
                    <h3 class="ab-member__name">Prakriti Karki</h3>
                    <span class="ab-member__role">Frontend Developer</span>
                    <p class="ab-member__desc">Brings the AuraLuxe experience to life — crafting every pixel with elegance, responsiveness, and a keen eye for beauty.</p>
                    <div class="ab-member__tags">
                        <span>HTML</span><span>CSS</span><span>JSP</span>
                    </div>
                </div>
            </div>

            <!-- Swechha Khadka -->
          <div class="ab-member" style="--clr:#8b2442;">
                <div class="ab-member__photo-wrap">
                    <img src="https://randomuser.me/api/portraits/women/65.jpg"
                         alt="Swechha Khadka"
                         class="ab-member__photo"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                    <div class="ab-member__initial-fallback">S</div>
                    <div class="ab-member__glow"></div>
                </div>
                <div class="ab-member__info">
                    <h3 class="ab-member__name">Swechha Khadka</h3>
                    <span class="ab-member__role">UI/UX Designer</span>
                    <p class="ab-member__desc">The creative force shaping AuraLuxe's visual identity — from color palettes and wireframes to user journeys that feel effortless.</p>
                    <div class="ab-member__tags">
                        <span>Figma</span><span>Design</span><span>UX</span>
                    </div>
                </div>
            </div>

            <!-- Suan Shrestha -->
            <div class="ab-member" style="--clr:#c4687d;">
                <div class="ab-member__photo-wrap">
                    <img src="https://randomuser.me/api/portraits/men/32.jpg"
                         alt="Suan Shrestha"
                         class="ab-member__photo"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                    <div class="ab-member__initial-fallback">S</div>
                    <div class="ab-member__glow"></div>
                </div>
                <div class="ab-member__info">
                    <h3 class="ab-member__name">Suan Shrestha</h3>
                    <span class="ab-member__role">Database Administrator</span>
                    <p class="ab-member__desc">Architects the data foundation of AuraLuxe — designing schemas, optimizing queries, and ensuring every byte is stored safely.</p>
                    <div class="ab-member__tags">
                        <span>MySQL</span><span>SQL</span><span>ERD</span>
                    </div>
                </div>
            </div>

            <!-- Sunil Thapa -->
            <div class="ab-member" style="--clr:#8b2442;">
                <div class="ab-member__photo-wrap">
                    <img src="https://randomuser.me/api/portraits/men/52.jpg"
                         alt="Sunil Thapa"
                         class="ab-member__photo"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" />
                    <div class="ab-member__initial-fallback">S</div>
                    <div class="ab-member__glow"></div>
                </div>
                <div class="ab-member__info">
                    <h3 class="ab-member__name">Sunil Thapa</h3>
                    <span class="ab-member__role">Quality Assurance & Testing</span>
                    <p class="ab-member__desc">The last line of defence before launch — rigorously testing every feature and making sure AuraLuxe delivers a flawless experience.</p>
                    <div class="ab-member__tags">
                        <span>Testing</span><span>QA</span><span>Debugging</span>
                    </div>
                </div>
            </div>

        </div>
    </div>
</section>

<%-- CTA --%>
<section class="ab-cta">
    <div class="ab-cta__inner">
        <span class="ab-cta__eyebrow">✦ Join the Journey ✦</span>
        <h2 class="ab-cta__title">Experience AuraLuxe</h2>
        <p class="ab-cta__sub">Discover beauty products curated with love by our team.</p>
        <div class="ab-cta__btns">
            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="ab-btn ab-btn--primary">Shop Now</a>
            <a href="${pageContext.request.contextPath}/pages/contact-us.jsp" class="ab-btn ab-btn--ghost">Contact Us</a>
        </div>
    </div>
</section>

<jsp:include page="/components/footer.jsp" />

</body>
</html>
