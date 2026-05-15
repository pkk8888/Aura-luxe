<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Premium Makeup Collection</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<!-- ============================================================
     HERO
     ============================================================ -->
<section class="al-hero">
    <div class="al-hero__deco al-hero__deco--1"></div>
    <div class="al-hero__deco al-hero__deco--2"></div>
    <div class="al-hero__deco al-hero__deco--3">A</div>

    <div class="al-hero__inner">
        <div class="al-hero__content">
            <h1 class="al-hero__title">
                Redefine Your
                <em>Beauty Story</em>
            </h1>
            <p class="al-hero__desc">
                Discover premium makeup crafted with luxurious formulas.
                From statement lips to luminous skin — every product is a
                masterpiece designed for you.
            </p>
            <div class="al-hero__actions">
                <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-btn al-btn--solid">
                    Shop Now
                </a>
            </div>
        </div>

        <div class="al-hero__visual">
            <div class="al-hero__img-wrap">
                <div class="al-hero__img-bg"></div>
                <img src="${pageContext.request.contextPath}/images/hero-product.png"
                    alt="AuraLuxe Hero Product"
                    style="width:100%; height:100%; object-fit:cover; border-radius:50% 40% 50% 40%;" />
            </div>
        </div>
    </div>
</section>


<!-- ============================================================
     MARQUEE STRIP
     ============================================================ -->
<div class="al-marquee-strip">
    <div class="al-marquee-inner">
        <span>Free Shipping Over Rs 2000</span><span class="al-marquee-sep">✦</span>
        <span>New Arrivals Every Week</span><span class="al-marquee-sep">✦</span>
        <span>Cruelty Free Vegan</span><span class="al-marquee-sep">✦</span>
        <span>100% Authentic Products</span><span class="al-marquee-sep">✦</span>
        <span>Premium Makeup Collection</span><span class="al-marquee-sep">✦</span>
        <span>Free Shipping Over Rs 2000</span><span class="al-marquee-sep">✦</span>
        <span>New Arrivals Every Week</span><span class="al-marquee-sep">✦</span>
        <span>Cruelty Free &amp; Vegan</span><span class="al-marquee-sep">✦</span>
        <span>100% Authentic Products</span><span class="al-marquee-sep">✦</span>
        <span>Premium Makeup Collection</span><span class="al-marquee-sep">✦</span>
    </div>
</div>





<!-- ============================================================
     TESTIMONIALS
     ============================================================ -->
<section class="al-testimonials">
    <div class="al-container">
        <div class="al-testimonials__head">
            <span class="al-section-label">Reviews</span>
            <h2 class="al-section-title">Loved by Thousands</h2>
        </div>

        <div class="al-testimonials__grid">
            <div class="al-testi-card">
                <p class="al-testi-card__text">
                    "The Velvet Rose lipstick is absolutely stunning. Long-lasting, moisturising,
                    and the shade is perfect. I've never received so many compliments!"
                </p>
                <div class="al-testi-card__author">
                    <div class="al-testi-card__avatar">P</div>
                    <div>
                        <div class="al-testi-card__name">Prakriti Karki</div>
                        <div class="al-testi-card__role">Verified Buyer</div>
                    </div>
                </div>
            </div>

            <div class="al-testi-card">
                <p class="al-testi-card__text">
                    "The foundation gives me the most natural finish. Lightweight and buildable —
                    I finally found my holy-grail product. Will never switch."
                </p>
                <div class="al-testi-card__author">
                    <div class="al-testi-card__avatar">S</div>
                    <div>
                        <div class="al-testi-card__name">Swechha Khadka</div>
                        <div class="al-testi-card__role">Verified Buyer</div>
                    </div>
                </div>
            </div>

            <div class="al-testi-card">
                <p class="al-testi-card__text">
                    "Fast shipping, beautiful packaging, and the serum is liquid gold for skin.
                    AuraLuxe is now my go-to brand for everything beauty."
                </p>
                <div class="al-testi-card__author">
                    <div class="al-testi-card__avatar">P</div>
                    <div>
                        <div class="al-testi-card__name">Pranisha KC</div>
                        <div class="al-testi-card__role">Verified Buyer</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>


<jsp:include page="/components/footer.jsp" />

</body>
</html>