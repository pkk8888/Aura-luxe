<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- ============================================================
     AuraLuxe - Reusable Footer Component
     Usage: <%@ include file="/components/footer.jsp" %>
     ============================================================ --%>

<footer class="al-footer">
    <div class="al-footer__top">
        <div class="al-footer__brand-col">
            <div class="al-footer__logo">
                <span class="al-footer__star">✦</span>
                Aura<span class="al-footer__luxe">Luxe</span>
                <span class="al-footer__star">✦</span>
            </div>
            <p class="al-footer__tagline">Premium Makeup Collection</p>
            <p class="al-footer__desc">
                Crafted for those who believe beauty is an art form.
                Every product tells a story of elegance.
            </p>
            <div class="al-footer__socials">
                <a href="#" class="al-footer__social" aria-label="Instagram">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="4"/>
                        <circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/>
                    </svg>
                </a>
                <a href="#" class="al-footer__social" aria-label="Pinterest">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12c0 4.24 2.65 7.86 6.39 9.29-.09-.78-.17-1.98.03-2.83.19-.77 1.26-5.33 1.26-5.33s-.32-.64-.32-1.59c0-1.49.87-2.6 1.94-2.6.92 0 1.36.69 1.36 1.51 0 .92-.59 2.3-.89 3.58-.25 1.07.53 1.94 1.58 1.94 1.9 0 3.36-2 3.36-4.89 0-2.56-1.84-4.35-4.47-4.35-3.04 0-4.83 2.28-4.83 4.63 0 .92.35 1.9.79 2.43.09.1.1.19.07.3-.08.33-.26 1.07-.3 1.22-.05.2-.17.24-.38.14-1.39-.65-2.26-2.68-2.26-4.32 0-3.51 2.55-6.74 7.36-6.74 3.86 0 6.86 2.75 6.86 6.42 0 3.83-2.41 6.91-5.76 6.91-1.12 0-2.18-.58-2.54-1.27l-.69 2.58c-.25.96-.93 2.16-1.39 2.89.05.01.09.02.14.02 5.52 0 10-4.48 10-10S17.52 2 12 2z"/>
                    </svg>
                </a>
                <a href="#" class="al-footer__social" aria-label="Facebook">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                        <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/>
                    </svg>
                </a>
            </div>
        </div>

        <div class="al-footer__col">
            <h4 class="al-footer__heading">Shop</h4>
            <ul class="al-footer__list">
                <li><a href="${pageContext.request.contextPath}/FetchProductsServlet" class="al-footer__link">All Products</a></li>
                <li><a href="#" class="al-footer__link">Lipsticks</a></li>
                <li><a href="#" class="al-footer__link">Foundations</a></li>
                <li><a href="#" class="al-footer__link">Eye Makeup</a></li>
                <li><a href="#" class="al-footer__link">Skincare</a></li>
            </ul>
        </div>

        <div class="al-footer__col">
            <h4 class="al-footer__heading">Help</h4>
            <ul class="al-footer__list">
                <li><a href="#" class="al-footer__link">FAQs</a></li>
                <li><a href="#" class="al-footer__link">Shipping Info</a></li>
                <li><a href="#" class="al-footer__link">Returns</a></li>
                <li><a href="#" class="al-footer__link">Track Order</a></li>
                <li><a href="#" class="al-footer__link">Contact Us</a></li>
            </ul>
        </div>

        <div class="al-footer__col">
            <h4 class="al-footer__heading">Newsletter</h4>
            <p class="al-footer__newsletter-text">Get exclusive offers and beauty tips straight to your inbox.</p>
            <form class="al-footer__form" onsubmit="return false;">
                <input type="email" class="al-footer__input" placeholder="your@email.com" />
                <button type="submit" class="al-footer__subscribe-btn">Subscribe</button>
            </form>
        </div>
    </div>

    <div class="al-footer__bottom">
        <p class="al-footer__copy">&copy; 2025 AuraLuxe. All rights reserved.</p>
        <div class="al-footer__legal">
            <a href="#" class="al-footer__legal-link">Privacy Policy</a>
            <a href="#" class="al-footer__legal-link">Terms of Service</a>
        </div>
    </div>
</footer>
