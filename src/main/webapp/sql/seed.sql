USE auraluxe;

-- ── Sample Makeup Products ─────────────────────────────────────
INSERT INTO products
    (product_id, product_name, category, shade, brand,
     features, net_weight, shelf_life, price, image)
VALUES
(
    'PRD001',
    'Velvet Matte Lipstick',
    'Lipstick',
    'Ruby Red',
    'MAC',
    'Long-lasting matte finish with rich intense pigmentation. Comfortable hydrating formula that keeps lips soft all day. Does not feather or bleed throughout the day.',
    '3.0g',
    '24 months',
    1200.00,
    'macLipstick.jpg'
),
(
    'PRD002',
    'Flawless Fit Foundation SPF 15',
    'Foundation',
    'Ivory 02',
    'L''Oreal',
    'Buildable medium to full coverage with a natural skin finish. Lightweight formula with SPF 15 sun protection. Suitable for all skin types including sensitive skin.',
    '30ml',
    '24 months',
    2200.00,
    'FlawlessFoundation.jpg'
),
(
    'PRD003',
    'Nude Glam Eyeshadow Palette',
    'Eyeshadow',
    'Warm Nudes',
    'NYX',
    '12 ultra-pigmented shades ranging from matte to shimmer. Highly blendable and crease-proof formula. Cruelty free and vegan certified.',
    '14.2g',
    '30 months',
    3500.00,
    'NudeEyeshadow.jpg'
),
(
    'PRD004',
    'Glow Setter Highlighter',
    'Highlighter',
    'Rose Gold',
    'Fenty Beauty',
    'Intense blinding glow with a buttery smooth texture. Buildable intensity from subtle to blinding. Universally flattering on all skin tones.',
    '8.0g',
    '24 months',
    2800.00,
    'fentyHighlighter.jpg'
),
(
    'PRD005',
    'Volume Boost Mascara',
    'Mascara',
    'Blackest Black',
    'Maybelline',
    'Volumising and lengthening formula for dramatic lashes. Smudge-proof and flake-free for up to 12 hours. Enriched with vitamin B5 for lash health.',
    '10ml',
    '12 months',
    950.00,
    'mascara.jpg'
),
(
    'PRD006',
    'Satin Blush',
    'Blush',
    'Peach Sorbet',
    'Charlotte Tilbury',
    'Silky smooth buildable colour with a healthy satin glow. Natural flushed finish that mimics real skin. Long lasting wear up to 8 hours.',
    '6.0g',
    '24 months',
    3200.00,
    'blush.jpg'
),
(
    'PRD007',
    'Precision Liquid Eyeliner',
    'Eyeliner',
    'Jet Black',
    'Urban Decay',
    'Ultra fine tip for precise sharp lines. 24 hour waterproof and fade-proof formula. Vegan and cruelty free certified.',
    '1.7ml',
    '18 months',
    1650.00,
    'eyeliner.jpg'
),
(
    'PRD008',
    'Pore Perfecting Primer',
    'Primer',
    'Translucent',
    'Smashbox',
    'Smooths pores and fine lines for a flawless base. Oil-free formula extends makeup wear up to 12 hours. Lightweight and breathable finish.',
    '30ml',
    '24 months',
    2600.00,
    'primer.jpg'
),
(
    'PRD009',
    'Cherry Lip Oil',
    'Lip Gloss',
    'Cherry Drizzle',
    'Rare Beauty',
    'Non-sticky high-shine lip oil infused with marula and jojoba oils. Plumping and deeply nourishing. Gives a glossy juicy lip look.',
    '5.5ml',
    '18 months',
    1800.00,
    'Cherrylipoil.jpg'
),
(
    'PRD010',
    'Sculpt and Define Contour Kit',
    'Contour',
    'Medium',
    'Anastasia Beverly Hills',
    'Duo contour and highlight compact. Matte contour shade plus a complementary shimmer highlight. Buildable pigment for subtle to dramatic sculpting results.',
    '12.0g',
    '30 months',
    4100.00,
    'contour.jpg'
    ),
    (
    'PRD011',
    'Glow Radiance Serum',
    'Skincare',
    NULL,
    'AuraLuxe',
    'Lightweight serum that boosts radiance and hydration. Enriched with Vitamin C and hyaluronic acid for glowing skin.',
    '30ml',
    '24 months',
    1499.00,
    'serum.jpg'
);
