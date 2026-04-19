CREATE DATABASE IF NOT EXISTS auraluxe
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;

USE auraluxe;

-- ── Table: users ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    user_id      VARCHAR(50)  NOT NULL,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20)  NOT NULL,
    password     VARCHAR(255) NOT NULL,
    role         VARCHAR(20)  NOT NULL DEFAULT 'user',
    address      VARCHAR(300)          DEFAULT NULL,
    img_link     VARCHAR(300)          DEFAULT NULL,
    PRIMARY KEY  (user_id),
    UNIQUE KEY uq_email (email),
    UNIQUE KEY uq_phone (phone_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Table: products (makeup specific, no discount) ────────────
CREATE TABLE IF NOT EXISTS products (
    product_id   VARCHAR(50)   NOT NULL,
    product_name VARCHAR(255)  NOT NULL,
    category     VARCHAR(100)  NOT NULL,
    shade        VARCHAR(100)           DEFAULT NULL,
    brand        VARCHAR(100)           DEFAULT NULL,
    features     TEXT                   DEFAULT NULL,
    net_weight   VARCHAR(100)           DEFAULT NULL,
    shelf_life   VARCHAR(100)           DEFAULT NULL,
    price        DECIMAL(10,2) NOT NULL,
    image        VARCHAR(300)  NOT NULL,
    PRIMARY KEY  (product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Table: carts (no cart_id, composite primary key) ──────────
CREATE TABLE IF NOT EXISTS carts (
    user_id    VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity   INT         NOT NULL DEFAULT 1,
    PRIMARY KEY (user_id, product_id),
    CONSTRAINT fk_cart_user    FOREIGN KEY (user_id)
        REFERENCES users (user_id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_product FOREIGN KEY (product_id)
        REFERENCES products (product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Table: orders ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
    order_id     VARCHAR(50)   NOT NULL,
    user_id      VARCHAR(50)   NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status       ENUM('Pending','Processing','Shipped','Delivered','Cancelled')
                               NOT NULL DEFAULT 'Pending',
    city         VARCHAR(100)           DEFAULT NULL,
    address      TEXT                   DEFAULT NULL,
    payment      VARCHAR(50)            DEFAULT NULL,
    created_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY  (order_id),
    CONSTRAINT fk_order_user FOREIGN KEY (user_id)
        REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Table: order_products ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_products (
    order_id   VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    quantity   INT         NOT NULL DEFAULT 1,
    PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_op_order   FOREIGN KEY (order_id)
        REFERENCES orders (order_id) ON DELETE CASCADE,
    CONSTRAINT fk_op_product FOREIGN KEY (product_id)
        REFERENCES products (product_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ── Table: inquiry ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS inquiry (
    inquiry_id VARCHAR(50)  NOT NULL,
    user_id    VARCHAR(50)           DEFAULT NULL,
    subject    VARCHAR(255) NOT NULL,
    message    TEXT         NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (inquiry_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
