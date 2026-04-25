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
            <div class="al-hero__badge">
                <span class="al-hero__badge-dot"></span>
                New Collection 2026
            </div>
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
                <a href="#collections" class="al-btn al-btn--light">
                    View Collections
                </a>
            </div>
        </div>

        <div class="al-hero__visual">
            <div class="al-hero__img-wrap">
                <div class="al-hero__img-bg"></div>
                <img src="${pageContext.request.contextPath}/images/hero-product.png"
                    alt="AuraLuxe Hero Product"
                    style="width:100%; height:100%; object-fit:cover; border-radius:50% 40% 50% 40%;" />
                <div class="al-hero__stat al-hero__stat--1">
                    <div class="al-hero__stat-num">500+</div>
                    <div class="al-hero__stat-label">Products</div>
                </div>
                <div class="al-hero__stat al-hero__stat--2">
                    <div class="al-hero__stat-num">4.9★</div>
                    <div class="al-hero__stat-label">Rating</div>
                </div>
            </div>
        </div>
    </div>
    <!-- Scroll hint REMOVED -->
</section>


<!-- ============================================================
     MARQUEE STRIP
     ============================================================ -->
<div class="al-marquee-strip">
    <div class="al-marquee-inner">
        <span>Free Shipping Over Rs 2000</span><span class="al-marquee-sep">✦</span>
        <span>New Arrivals Every Week</span><span class="al-marquee-sep">✦</span>
        <span>Cruelty Free &amp; Vegan</span><span class="al-marquee-sep">✦</span>
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
     CATEGORIES
     ============================================================ -->
<section class="al-categories" id="collections">
    <div class="al-container">
        <div class="al-categories__head">
            <span class="al-section-label">Browse by Category</span>
            <h2 class="al-section-title">Shop by Collection</h2>
            <p class="al-section-sub" style="margin: 0 auto;">
                Explore our curated categories crafted to elevate every look —
                from everyday glow to show-stopping glamour.
            </p>
        </div>

        <div class="al-categories__grid">
            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=lips"
               class="al-cat-card al-cat-card--lips">
                <div class="al-cat-card__img">
                    <img src="${pageContext.request.contextPath}/images/category-lips.jpg"
                         alt="Lip Colour" style="width:100%; height:100%; object-fit:cover;" />
                </div>
                <div class="al-cat-card__body">
                    <div class="al-cat-card__name">Lip Colour</div>
                    <div class="al-cat-card__count">Lipsticks, Glosses &amp; More</div>
                </div>
                <div class="al-cat-card__arrow">→</div>
            </a>

            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=eyes"
               class="al-cat-card al-cat-card--eyes">
                <div class="al-cat-card__img">
                    <img src="${pageContext.request.contextPath}/images/category-eye.jpg"
                         alt="Eye Makeup" style="width:100%; height:100%; object-fit:cover;" />
                </div>
                <div class="al-cat-card__body">
                    <div class="al-cat-card__name">Eye Makeup</div>
                    <div class="al-cat-card__count">Mascara, Liner &amp; Shadows</div>
                </div>
                <div class="al-cat-card__arrow">→</div>
            </a>

            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=face"
               class="al-cat-card al-cat-card--face">
                <div class="al-cat-card__img">
                    <img src="${pageContext.request.contextPath}/images/category-face.jpg"
                         alt="Face" style="width:100%; height:100%; object-fit:cover;" />
                </div>
                <div class="al-cat-card__body">
                    <div class="al-cat-card__name">Face</div>
                    <div class="al-cat-card__count">Foundation, Blush &amp; Contour</div>
                </div>
                <div class="al-cat-card__arrow">→</div>
            </a>

            <a href="${pageContext.request.contextPath}/FetchProductsServlet?category=skincare"
               class="al-cat-card al-cat-card--skin">
                <div class="al-cat-card__img">
                    <img src="${pageContext.request.contextPath}/images/category-skincare.jpg"
                         alt="Skincare" style="width:100%; height:100%; object-fit:cover;" />
                </div>
                <div class="al-cat-card__body">
                    <div class="al-cat-card__name">Skincare</div>
                    <div class="al-cat-card__count">Serums, Moisturisers &amp; More</div>
                </div>
                <div class="al-cat-card__arrow">→</div>
            </a>
        </div>
    </div>
</section>


<!-- ============================================================
     FEATURED PRODUCTS - Now connected to real DB products
     ============================================================ -->
<section class="al-products">
    <div class="al-container">
        <div class="al-products__head">
            <div>
                <span class="al-section-label">Bestsellers</span>
                <h2 class="al-section-title">Featured Products</h2>
            </div>
            <a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-btn al-btn--outline">
                View All
            </a>
        </div>

        <%
            // Show cart message if any
            String cartMsg = request.getParameter("cartMsg");
            if ("added".equals(cartMsg)) {
        %>
            <div style="background:#d4edda; color:#155724; padding:10px 16px; border-radius:8px; margin-bottom:16px; text-align:center;">
                ✓ Product added to cart!
            </div>
        <% } else if ("updated".equals(cartMsg)) { %>
            <div style="background:#d4edda; color:#155724; padding:10px 16px; border-radius:8px; margin-bottom:16px; text-align:center;">
                ✓ Cart updated!
            </div>
        <% } %>

        <div class="al-products__grid">
            <!-- Card 1 -->
            <div class="al-prod-card al-prod-card--1">
                <div class="al-prod-card__img">
                    <img src="${pageContext.request.contextPath}/images/lipstick.jpg"
                         alt="Velvet Rose Lip Crème"
                         style="width:100%; height:100%; object-fit:cover;" />
                    <span class="al-prod-card__badge">Bestseller</span>
                   
                </div>
                <div class="al-prod-card__body">
                    <div class="al-prod-card__cat">Lipstick</div>
                    <div class="al-prod-card__name">Velvet Rose Lip Crème</div>
                    <div class="al-prod-card__stars">★★★★★</div>
                    <div class="al-prod-card__footer">
                        <span class="al-prod-card__price">Rs 850</span>
                        <form method="post" action="${pageContext.request.contextPath}/AddToCartServlet" style="display:inline;">
                            <input type="hidden" name="productId" value="PRD001" />
                           <button type="submit" class="al-prod-card__add" onclick="event.stopPropagation()">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="al-prod-card al-prod-card--2">
                <div class="al-prod-card__img">
                    <img src="${pageContext.request.contextPath}/images/foundation.jpg"
                         alt="Luminous Skin Foundation"
                         style="width:100%; height:100%; object-fit:cover;" />
                    <span class="al-prod-card__badge">New</span>
           
                </div>
                <div class="al-prod-card__body">
                    <div class="al-prod-card__cat">Foundation</div>
                    <div class="al-prod-card__name">Luminous Skin Foundation</div>
                    <div class="al-prod-card__stars">★★★★★</div>
                    <div class="al-prod-card__footer">
                        <span class="al-prod-card__price">Rs 1,299</span>
                        <form method="post" action="${pageContext.request.contextPath}/AddToCartServlet" style="display:inline;">
                            <input type="hidden" name="productId" value="PRD002" />
                            <button type="submit" class="al-prod-card__add">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Card 3 -->
            <div class="al-prod-card al-prod-card--3">
                <div class="al-prod-card__img">
                    <img src="${pageContext.request.contextPath}/images/mascara.jpg"
                         alt="Drama Queen Mascara"
                         style="width:100%; height:100%; object-fit:cover;" />
                    <!-- Heart/Wishlist REMOVED -->
                </div>
                <div class="al-prod-card__body">
                    <div class="al-prod-card__cat">Eye Makeup</div>
                    <div class="al-prod-card__name">Volume Boost Mascara</div>
                    <div class="al-prod-card__stars">★★★★☆</div>
                    <div class="al-prod-card__footer">
                        <span class="al-prod-card__price">Rs 699</span>
                        <form method="post" action="${pageContext.request.contextPath}/AddToCartServlet" style="display:inline;">
                            <input type="hidden" name="productId" value="PRD005" />
                            <button type="submit" class="al-prod-card__add">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Card 4 -->
            <div class="al-prod-card al-prod-card--4">
                <div class="al-prod-card__img">
                    <img src="${pageContext.request.contextPath}/images/serum.jpg"
                         alt="Glow Radiance Serum"
                         style="width:100%; height:100%; object-fit:cover;" />
                    <span class="al-prod-card__badge">Popular</span>
                    <!-- Heart/Wishlist REMOVED -->
                </div>
                <div class="al-prod-card__body">
                    <div class="al-prod-card__cat">Skincare</div>
                    <div class="al-prod-card__name">Glow Radiance Serum</div>
                    <div class="al-prod-card__stars">★★★★★</div>
                    <div class="al-prod-card__footer">
                        <span class="al-prod-card__price">Rs 1,499</span>
                        <form method="post" action="${pageContext.request.contextPath}/AddToCartServlet" style="display:inline;">
                            <input type="hidden" name="productId" value="4" />
                            <button type="submit" class="al-prod-card__add">Add to Cart</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>


<!-- ============================================================
     ABOUT / BRAND STORY
     ============================================================ -->
<section class="al-about" id="about">
    <div class="al-container">
        <div class="al-about__inner">
            <div class="al-about__body">
                <span class="al-section-label">Our Story</span>
                <h2 class="al-section-title">Beauty Crafted with Purpose</h2>
                <div class="al-section-sub">
                    AuraLuxe was born from a belief that every woman deserves makeup
                    that feels as good as it looks. We combine science and artistry
                    to bring you formulas that are kind to your skin and bold in expression.
                </div>
                <p>
                    Each product in our collection is dermatologist-tested, cruelty-free,
                    and crafted with the finest ingredients sourced from around the world.
                    We believe beauty should be inclusive, empowering, and effortless.
                </p>
                <div class="al-about__cta">
                    <a href="#" class="al-btn al-btn--light">Learn More</a>
                </div>
            </div>

            <div class="al-about__stats">
                <div class="al-about__stat">
                    <div class="al-about__stat-num">10K+</div>
                    <div class="al-about__stat-label">Happy Customers</div>
                </div>
                <div class="al-about__stat">
                    <div class="al-about__stat-num">500+</div>
                    <div class="al-about__stat-label">Products</div>
                </div>
                <div class="al-about__stat">
                    <div class="al-about__stat-num">100%</div>
                    <div class="al-about__stat-label">Cruelty Free</div>
                </div>
                <div class="al-about__stat">
                    <div class="al-about__stat-num">5★</div>
                    <div class="al-about__stat-label">Avg. Rating</div>
                </div>
            </div>
        </div>
    </div>
</section>


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
                <div class="al-testi-card__stars">★★★★★</div>
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
                <div class="al-testi-card__stars">★★★★★</div>
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
                <div class="al-testi-card__stars">★★★★★</div>
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

<!-- READY TO GLOW SECTION REMOVED -->

<jsp:include page="/components/footer.jsp" />

</body>
</html>
