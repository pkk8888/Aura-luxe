package util;

/**
 * StringUtils
 * Central store for all constants used across AuraLuxe.
 * Update DB_USER and DB_PASS if your MySQL has a password.
 */
public class StringUtils {

    // ── Database connection ────────────────────────────────────────
    public static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    public static final String CONN_URL = "jdbc:mysql://localhost:3306/auraluxe"
                                        + "?useSSL=false&serverTimezone=UTC";
    public static final String DB_USER  = "root";
    public static final String DB_PASS  = "";
    public static final String HOME_PAGE = "/pages/home.jsp";
    // ── SQL: Users ─────────────────────────────────────────────────
    public static final String INSERT_USER =
        "INSERT INTO users (user_id, full_name, email, phone_number, password, role) " +
        "VALUES (?, ?, ?, ?, ?, ?)";

    public static final String GET_USER_LOGIN =
        "SELECT user_id, password, role FROM users WHERE user_id = ?";

    public static final String GET_USER_BY_ID =
        "SELECT * FROM users WHERE user_id = ?";

    public static final String CHECK_DUP_USERID =
        "SELECT user_id FROM users WHERE user_id = ?";

    public static final String CHECK_DUP_EMAIL =
        "SELECT user_id FROM users WHERE email = ?";

    public static final String CHECK_DUP_PHONE =
        "SELECT user_id FROM users WHERE phone_number = ?";

    public static final String UPDATE_USER_PROFILE =
        "UPDATE users SET full_name = ?, address = ? WHERE user_id = ?";

    public static final String UPDATE_USER_PASSWORD =
        "UPDATE users SET password = ? WHERE user_id = ?";

    public static final String DELETE_USER =
        "DELETE FROM users WHERE user_id = ?";

    public static final String GET_ALL_USERS =
        "SELECT user_id, full_name, email, phone_number " +
        "FROM users WHERE role = 'user'";

    // ── SQL: Products ──────────────────────────────────────────────
    public static final String INSERT_PRODUCT =
        "INSERT INTO products " +
        "(product_id, product_name, category, shade, brand, features, net_weight, shelf_life, price, image) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String GET_ALL_PRODUCTS =
        "SELECT * FROM products";

    public static final String GET_PRODUCT_BY_ID =
        "SELECT * FROM products WHERE product_id = ?";

    public static final String SEARCH_PRODUCTS =
        "SELECT * FROM products WHERE product_name LIKE ?";

    public static final String UPDATE_PRODUCT =
        "UPDATE products SET product_name=?, category=?, shade=?, brand=?, " +
        "features=?, net_weight=?, shelf_life=?, price=?, image=? " +
        "WHERE product_id=?";

    public static final String DELETE_PRODUCT =
        "DELETE FROM products WHERE product_id = ?";

    // ── SQL: Cart (composite PK, no cart_id) ──────────────────────
    public static final String ADD_TO_CART =
        "INSERT INTO carts (user_id, product_id, quantity) VALUES (?, ?, ?)";

    public static final String CHECK_CART_EXISTS =
        "SELECT quantity FROM carts WHERE user_id = ? AND product_id = ?";

    public static final String GET_CART_ITEMS =
        "SELECT p.product_id, p.product_name, p.price, p.image, c.quantity " +
        "FROM carts c " +
        "JOIN products p ON c.product_id = p.product_id " +
        "WHERE c.user_id = ?";

    public static final String GET_CART_COUNT =
        "SELECT COUNT(*) AS total FROM carts WHERE user_id = ?";

    public static final String REMOVE_FROM_CART =
        "DELETE FROM carts WHERE user_id = ? AND product_id = ?";

    public static final String CLEAR_CART =
        "DELETE FROM carts WHERE user_id = ?";

    // ── SQL: Orders ────────────────────────────────────────────────
    public static final String INSERT_ORDER =
        "INSERT INTO orders (order_id, user_id, total_amount, status, city, address, payment) " +
        "VALUES (?, ?, ?, 'Pending', ?, ?, ?)";

    public static final String INSERT_ORDER_PRODUCT =
        "INSERT INTO order_products (order_id, product_id, quantity) VALUES (?, ?, ?)";

    public static final String GET_ALL_ORDERS =
        "SELECT o.order_id, o.user_id, u.full_name, o.total_amount, " +
        "o.status, o.payment, o.created_at " +
        "FROM orders o JOIN users u ON o.user_id = u.user_id";

    public static final String UPDATE_ORDER_STATUS =
        "UPDATE orders SET status = ? WHERE order_id = ?";

    // ── SQL: Inquiry ───────────────────────────────────────────────
    public static final String INSERT_INQUIRY =
        "INSERT INTO inquiry (inquiry_id, user_id, subject, message) " +
        "VALUES (?, ?, ?, ?)";

    public static final String GET_ALL_INQUIRIES =
        "SELECT * FROM inquiry ORDER BY created_at DESC";

    // ── Session keys ───────────────────────────────────────────────
    public static final String SESSION_USER_ID  = "userID";
    public static final String SESSION_IS_ADMIN = "isAdmin";

    // ── Roles ──────────────────────────────────────────────────────
    public static final String ROLE_ADMIN = "admin";
    public static final String ROLE_USER  = "user";

    // ── Page paths ─────────────────────────────────────────────────
    public static final String LOGIN_PAGE    = "/pages/login.jsp";
    public static final String REGISTER_PAGE = "/pages/register.jsp";
    public static final String ADMIN_PAGE    = "/pages/order_list.jsp";
    public static final String ERROR_PAGE    = "/pages/error.jsp";

    // ── Servlet paths ──────────────────────────────────────────────
    public static final String FETCH_PRODUCTS_SERVLET = "/FetchProductsServlet";
    public static final String LOGIN_SERVLET          = "/LoginServlet";
    public static final String LOGOUT_SERVLET         = "/LogoutServlet";
    public static final String REGISTER_SERVLET       = "/RegisterServlet";

    // ── Error messages ─────────────────────────────────────────────
    public static final String ERR_INVALID_LOGIN     = "Incorrect User ID or Password. Please try again.";
    public static final String ERR_USER_NOT_FOUND    = "No account found with that User ID. Please register first.";
    public static final String ERR_SERVER            = "A server error occurred. Please try again later.";
    public static final String ERR_DUP_USERID        = "That User ID is already taken. Please choose another.";
    public static final String ERR_DUP_EMAIL         = "An account with that email already exists.";
    public static final String ERR_DUP_PHONE         = "An account with that phone number already exists.";
    public static final String ERR_PASSWORD_MISMATCH = "Passwords do not match. Please try again.";
    public static final String ERR_CART_DUPLICATE    = "This product is already in your bag.";
    public static final String ERR_EMPTY_CART        = "Your bag is empty. Add products before checking out.";
}
