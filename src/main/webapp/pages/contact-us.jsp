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
