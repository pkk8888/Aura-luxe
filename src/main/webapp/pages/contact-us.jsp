<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String successMsg = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AuraLuxe | Contact Us</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css" />
</head>
<body>

<jsp:include page="/components/navbar.jsp" />

<%-- ── HERO ─────────────────────────────────────────────────── --%>
<section class="ab-hero ab-hero--contact">
    <div class="ab-hero__bg-text" aria-hidden="true">HELLO</div>
    <div class="ab-hero__content">
        <span class="ab-hero__eyebrow">✦ Get In Touch ✦</span>
        <h1 class="ab-hero__title">We'd Love To<br/><em>Hear From You</em></h1>
        <p class="ab-hero__desc">
            Whether you have a question about your order, a product query, or just want to say hello —
            our team is always happy to help.
        </p>
    </div>
    <div class="ab-hero__orb ab-hero__orb--1"></div>
    <div class="ab-hero__orb ab-hero__orb--2"></div>
</section>

<%-- ── CONTACT BODY ────────────────────────────────────────── --%>
<section class="ct-body">
    <div class="ct-body__inner">

        <%-- Contact Info cards --%>
        <div class="ct-info">

            <div class="ct-info__card">
                <span class="ct-info__icon">📍</span>
                <h3 class="ct-info__title">Our Location</h3>
                <p class="ct-info__text">Pokhara, Gandaki Province<br/>Nepal 🇳🇵</p>
            </div>

            <div class="ct-info__card">
                <span class="ct-info__icon">📧</span>
                <h3 class="ct-info__title">Email Us</h3>
                <p class="ct-info__text">hello@auraluxe.com<br/>support@auraluxe.com</p>
            </div>

            <div class="ct-info__card">
                <span class="ct-info__icon">📞</span>
                <h3 class="ct-info__title">Call Us</h3>
                <p class="ct-info__text">+977 9805388883<br/>Mon – Sat, 10am – 6pm</p>
            </div>

            <div class="ct-info__card">
                <span class="ct-info__icon">🕐</span>
                <h3 class="ct-info__title">Working Hours</h3>
                <p class="ct-info__text">Sunday – Friday<br/>10:00 AM – 6:00 PM NPT</p>
            </div>

        </div>

        <%-- Contact Form --%>
        <div class="ct-form-wrap">
            <div class="ct-form-card">
                <div class="ct-form-card__head">
                    <h2 class="ct-form-card__title">Send Us a Message</h2>
                    <p class="ct-form-card__sub">We'll get back to you within 24 hours</p>
                </div>

                <% if ("1".equals(successMsg)) { %>
                <div class="pf-alert pf-alert--success" style="margin-bottom:20px;">
                    <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    Thank you! Your message has been sent. We'll be in touch soon.
                </div>
                <% } %>

                <form class="ct-form" id="contactForm" onsubmit="handleSubmit(event)">
                    <div class="ct-form__row">
                        <div class="ct-form__field">
                            <label class="ct-form__label">Your Name <span class="ct-req">*</span></label>
                            <input type="text" class="ct-form__input" placeholder="e.g. Prakriti Karki" required />
                        </div>
                        <div class="ct-form__field">
                            <label class="ct-form__label">Email Address <span class="ct-req">*</span></label>
                            <input type="email" class="ct-form__input" placeholder="you@example.com" required />
                        </div>
                    </div>

                    <div class="ct-form__field">
                        <label class="ct-form__label">Subject <span class="ct-req">*</span></label>
                        <select class="ct-form__input ct-form__select" required>
                            <option value="" disabled selected>Select a topic</option>
                            <option>Order Inquiry</option>
                            <option>Product Question</option>
                            <option>Return & Refund</option>
                            <option>Delivery Issue</option>
                            <option>Feedback</option>
                            <option>Other</option>
                        </select>
                    </div>

                    <div class="ct-form__field">
                        <label class="ct-form__label">Message <span class="ct-req">*</span></label>
                        <textarea class="ct-form__input ct-form__textarea" placeholder="Tell us how we can help you..." rows="5" required></textarea>
                    </div>

                    <button type="submit" class="ab-btn ab-btn--primary ct-form__btn" id="sendBtn">
                        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                            <line x1="22" y1="2" x2="11" y2="13"/>
                            <polygon points="22 2 15 22 11 13 2 9 22 2"/>
                        </svg>
                        Send Message
                    </button>
                </form>
            </div>
        </div>

    </div>
</section>

<%-- ── SOCIALS ──────────────────────────────────────────────── --%>
<section class="ct-social">
    <div class="ct-social__inner">
        <p class="ct-social__label">Follow us on social media</p>
        <div class="ct-social__links">
            <a href="#" class="ct-social__link" title="Instagram">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <rect x="2" y="2" width="20" height="20" rx="5" ry="5"/>
                    <path d="M16 11.37A4 4 0 1112.63 8 4 4 0 0116 11.37z"/>
                    <line x1="17.5" y1="6.5" x2="17.51" y2="6.5"/>
                </svg>
                Instagram
            </a>
            <a href="#" class="ct-social__link" title="Facebook">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <path d="M18 2h-3a5 5 0 00-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 011-1h3z"/>
                </svg>
                Facebook
            </a>
            <a href="#" class="ct-social__link" title="TikTok">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <path d="M9 12a4 4 0 104 4V4a5 5 0 005 5"/>
                </svg>
                TikTok
            </a>
        </div>
    </div>
</section>

<jsp:include page="/components/footer.jsp" />

<script>
function handleSubmit(e) {
    e.preventDefault();
    var btn = document.getElementById('sendBtn');
    btn.disabled = true;
    btn.innerHTML = '⏳ Sending...';
    setTimeout(function(){
        btn.innerHTML = '✓ Message Sent!';
        btn.style.background = 'linear-gradient(135deg, #27ae60, #2ecc71)';
        document.getElementById('contactForm').reset();
        setTimeout(function(){
            btn.disabled = false;
            btn.innerHTML = '<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><line x1="22" y1="2" x2="11" y2="13"/><polygon points="22 2 15 22 11 13 2 9 22 2"/></svg> Send Message';
            btn.style.background = '';
        }, 3000);
    }, 1200);
}
</script>

</body>
</html>
