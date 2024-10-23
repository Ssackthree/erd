-- ADMIN 테이블 생성
DROP TABLE IF EXISTS admin;

CREATE TABLE admin (
	admin_id BIGINT NOT NULL,
	admin_login_id VARCHAR(20) NOT NULL,
	admin_password VARCHAR(255) NOT NULL COMMENT '암호화된 키 사용',
	admin_name VARCHAR(20) NOT NULL,
	PRIMARY KEY (admin_id)
);

-- CUSTOMER 테이블 생성
DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
	customer_id BIGINT NOT NULL,
	customer_name VARCHAR(20) NOT NULL,
	customer_phone_number VARCHAR(13) NOT NULL,
	customer_email VARCHAR(50) NOT NULL,
	PRIMARY KEY (customer_id)
);

-- BOOK 테이블 생성
DROP TABLE IF EXISTS book;

CREATE TABLE book (
	book_id BIGINT NOT NULL,
	publisher_id BIGINT NOT NULL,
	book_name VARCHAR(255) NOT NULL,
	book_index VARCHAR(255) NOT NULL,
	book_info TEXT NOT NULL,
	book_isbn VARCHAR(20) NOT NULL,
	publication_date DATETIME NOT NULL,
	regular_price INT NOT NULL,
	sale_price INT NOT NULL,
	is_packed BOOLEAN NOT NULL,
	stock INT NOT NULL,
	book_thumbnail_image_url TEXT NOT NULL,
	book_view_count BIGINT NOT NULL DEFAULT 0,
	book_discount INT NULL,
	PRIMARY KEY (book_id)
);

-- MEMBER 테이블 생성
DROP TABLE IF EXISTS member;

CREATE TABLE member (
	customer_id BIGINT NOT NULL,
	member_grade_id BIGINT NOT NULL,
	member_login_id VARCHAR(20) NOT NULL,
	member_password VARCHAR(255) NOT NULL COMMENT '암호화된 키 사용',
	member_birthdate VARCHAR(8) NOT NULL,
	member_created_at DATETIME NOT NULL,
	member_last_login_at DATETIME NULL,
	member_status ENUM('ACTIVE', 'SLEEP', 'WITHDRAW') NOT NULL DEFAULT 'ACTIVE' COMMENT '활성, 휴면, 탈퇴',
	member_point INT NOT NULL DEFAULT 0 COMMENT '음수가 되는 상황 처리 필요',
	PRIMARY KEY (customer_id)
);

-- REVIEW 테이블 생성
DROP TABLE IF EXISTS review;

CREATE TABLE review (
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	customer_id BIGINT NOT NULL,
	review_rate INT NOT NULL,
	review_title VARCHAR(50) NOT NULL,
	review_content TEXT NOT NULL,
	review_created_at DATETIME NOT NULL,
	review_image_url TEXT NULL,
	PRIMARY KEY (orders_id, book_id)
);

-- MEMBER_COUPON 테이블 생성
DROP TABLE IF EXISTS member_coupon;

CREATE TABLE member_coupon (
	member_coupon_id BIGINT NOT NULL,
	customer_id BIGINT NOT NULL,
	coupon_id BIGINT NOT NULL,
	member_coupon_created_at DATETIME NOT NULL,
	member_coupon_expired_at DATETIME NOT NULL COMMENT '쿠폰 만료일이 현재 시간 이전이면, 만료된 쿠폰으로 간주',
	member_coupon_used_at DATETIME NULL,
	PRIMARY KEY (member_coupon_id)
);

-- POINT_HISTORY 테이블 생성
DROP TABLE IF EXISTS point_history;

CREATE TABLE point_history (
	point_history_id BIGINT NOT NULL,
	point_save_rule_id BIGINT NULL,
	customer_id BIGINT NOT NULL,
	point_amount INT NOT NULL COMMENT '+,- 로 기록, 정수 값이 음수가 될 수 있음',
	point_change_date DATETIME NOT NULL,
	point_change_reason VARCHAR(50) NOT NULL COMMENT '사용, 적립 etc',
	PRIMARY KEY (point_history_id)
);

-- ORDERS 테이블 생성 (ORDER를 ORDERS로 변경)
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
	orders_id BIGINT NOT NULL,
	customer_id BIGINT NOT NULL,
	member_coupon_id BIGINT NULL,
	ordered_date DATETIME NOT NULL,
	order_total_price INT NOT NULL COMMENT '총 책 금액 + 포장 금액',
	order_number VARCHAR(20) NOT NULL COMMENT '년월일 + 임의값',
	PRIMARY KEY (orders_id)
);

-- CATEGORY 테이블 생성
DROP TABLE IF EXISTS category;

CREATE TABLE category (
	category_id BIGINT NOT NULL,
	category_name VARCHAR(20) NOT NULL,
	super_category_id BIGINT NULL,
	PRIMARY KEY (category_id)
);

-- BOOK_CATEGORY 테이블 생성
DROP TABLE IF EXISTS book_category;

CREATE TABLE book_category (
	category_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (category_id, book_id)
);

-- AUTHOR 테이블 생성
DROP TABLE IF EXISTS author;

CREATE TABLE author (
	author_id BIGINT NOT NULL,
	author_name VARCHAR(20) NOT NULL,
	author_info VARCHAR(255) NOT NULL,
	PRIMARY KEY (author_id)
);

-- PUBLISHER 테이블 생성
DROP TABLE IF EXISTS publisher;

CREATE TABLE publisher (
	publisher_id BIGINT NOT NULL,
	publisher_name VARCHAR(30) NOT NULL,
	publisher_is_used BOOLEAN NOT NULL,
	PRIMARY KEY (publisher_id)
);

-- TAG 테이블 생성
DROP TABLE IF EXISTS tag;

CREATE TABLE tag (
	tag_id BIGINT NOT NULL,
	tag_name VARCHAR(30) NOT NULL,
	PRIMARY KEY (tag_id)
);

-- BOOK_TAG 테이블 생성
DROP TABLE IF EXISTS book_tag;

CREATE TABLE book_tag (
	book_id BIGINT NOT NULL,
	tag_id BIGINT NOT NULL,
	PRIMARY KEY (book_id, tag_id)
);

-- BOOK_LIKE 테이블 생성
DROP TABLE IF EXISTS book_like;

CREATE TABLE book_like (
	customer_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (customer_id, book_id)
);

-- ADDRESS 테이블 생성
DROP TABLE IF EXISTS address;

CREATE TABLE address (
	registered_address_id BIGINT NOT NULL,
	customer_id BIGINT NOT NULL,
	address_alias VARCHAR(15) NULL,
	address_roadname VARCHAR(30) NOT NULL,
	address_detail VARCHAR(35) NOT NULL,
	address_postal_number VARCHAR(5) NOT NULL,
	PRIMARY KEY (registered_address_id)
);

-- ORDER_DETAIL 테이블 생성
DROP TABLE IF EXISTS order_detail;

CREATE TABLE order_detail (
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	member_coupon_id BIGINT NULL,
	quantity INT NOT NULL,
	bookprice_at_order INT NOT NULL COMMENT '도서의 판매가가 변경 될 수 있으므로, 해당 주문 시 도서 가격을 저장함.(기록용)',
	PRIMARY KEY (orders_id, book_id)
);

-- ORDER_STATUS 테이블 생성
DROP TABLE IF EXISTS order_status;

CREATE TABLE order_status (
	order_status_id BIGINT NOT NULL,
	order_status_name ENUM('PENDING', 'IN_SHOPPING', 'COMPLETED', 'RETURNED', 'CANCELED') NOT NULL DEFAULT 'PENDING' COMMENT '대기, 배송중, 완료, 반품, 주문취소',
	PRIMARY KEY (order_status_id)
);

-- DELIVERY_RULE 테이블 생성
DROP TABLE IF EXISTS delivery_rule;

CREATE TABLE delivery_rule (
	delivery_rule_id BIGINT NOT NULL,
	delivery_rule_name VARCHAR(30) NOT NULL,
	delivery_fee INT NOT NULL,
	delivery_discount_cost INT NULL COMMENT 'ex) 3만원 이상 무료배송',
	delivery_rule_is_selected BOOLEAN NOT NULL COMMENT '현재 사용중인 배송 정책 판단',
	delivery_rule_created_at DATETIME NOT NULL,
	PRIMARY KEY (delivery_rule_id)
);

-- PACKAGING 테이블 생성
DROP TABLE IF EXISTS packaging;

CREATE TABLE packaging (
	packaging_id BIGINT NOT NULL,
	packaging_name VARCHAR(20) NOT NULL,
	packaging_price INT NOT NULL,
	packaging_image_url TEXT NULL,
	PRIMARY KEY (packaging_id)
);

-- REFUND 테이블 생성
DROP TABLE IF EXISTS refund;

CREATE TABLE refund (
	refund_id BIGINT NOT NULL,
	refund_reason_id BIGINT NOT NULL,
	refund_quantity INT NOT NULL,
	refund_price INT NOT NULL,
	order_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (refund_id)
);

-- ORDER_DETAIL_PACKAGING 테이블 생성
DROP TABLE IF EXISTS order_detail_packaging;

CREATE TABLE order_detail_packaging (
	order_detail_packaging_id BIGINT NOT NULL,
	packaging_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	packaging_quantity INT NOT NULL,
	PRIMARY KEY (order_detail_packaging_id)
);

-- SHOPPINGCART 테이블 생성
DROP TABLE IF EXISTS shoppingcart;

CREATE TABLE shoppingcart (
	customer_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	book_quantity INT NOT NULL,
	PRIMARY KEY (customer_id, book_id)
);

-- POINT_SAVE_RULE 테이블 생성
DROP TABLE IF EXISTS point_save_rule;

CREATE TABLE point_save_rule (
	point_save_rule_id BIGINT NOT NULL,
	point_save_rule_name VARCHAR(30) NOT NULL,
	point_save_amount INT NOT NULL DEFAULT 0 COMMENT '각 정책에 따른 포인트 적립량',
	point_save_rule_generate_date DATETIME NOT NULL,
	point_save_rule_is_selected BOOLEAN NOT NULL,
	point_save_type ENUM('PERCENT', 'INTEGER') NOT NULL COMMENT '퍼센트, 정수',
	PRIMARY KEY (point_save_rule_id)
);

-- COUPON 테이블 생성
DROP TABLE IF EXISTS coupon;

CREATE TABLE coupon (
	coupon_id BIGINT NOT NULL,
	coupon_rule_id BIGINT NOT NULL,
	coupon_name VARCHAR(30) NOT NULL,
	coupon_description TEXT NOT NULL,
	coupon_effective_period INT NULL,
	coupon_effective_period_unit ENUM('DAY', 'MONTH', 'YEAR') NULL COMMENT '단위 : 일.월,년',
	coupon_create_at DATETIME NOT NULL,
	coupon_expired_at DATETIME NULL,
	PRIMARY KEY (coupon_id)
);

-- PAYMENT 테이블 생성
DROP TABLE IF EXISTS payment;

CREATE TABLE payment (
	payment_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	payment_type_id INT NOT NULL,
	payment_created_at DATETIME NOT NULL,
	payment_amount INT NOT NULL,
	payment_key VARCHAR(200) NULL,
	payment_status ENUM('COMPLETE', 'CANCEL') NOT NULL COMMENT '완료, 취소',
	PRIMARY KEY (payment_id)
);

-- DELIVERY 테이블 생성
DROP TABLE IF EXISTS delivery;

CREATE TABLE delivery (
	delivery_id BIGINT NOT NULL,
	delivery_rule_id INT NOT NULL,
	orders_id BIGINT NOT NULL,
	delivery_set_date DATETIME NULL,
	order_invoice_number VARCHAR(12) NOT NULL,
	receiver_phone_number VARCHAR(13) NOT NULL,
	order_request VARCHAR(200) NOT NULL,
	delivery_address_roadname VARCHAR(30) NOT NULL,
	delivery_address_detail VARCHAR(35) NOT NULL,
	delivery_postal_number VARCHAR(5) NOT NULL,
	PRIMARY KEY (delivery_id)
);

-- BOOK_AUTHOR 테이블 생성
DROP TABLE IF EXISTS book_author;

CREATE TABLE book_author (
	book_author_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	author_id BIGINT NOT NULL,
	PRIMARY KEY (book_author_id)
);

-- MEMBER_GRADE 테이블 생성
DROP TABLE IF EXISTS member_grade;

CREATE TABLE member_grade (
	member_grade_id BIGINT NOT NULL,
	member_grade_name VARCHAR(20) NOT NULL,
	member_grade_discount INT NULL COMMENT '회원등급에 따른 할인률',
	member_grade_condition INT NOT NULL,
	member_grade_condition_type ENUM('POINT', 'ORDER_COUNT') NOT NULL COMMENT '포인트, 주문수',
	PRIMARY KEY (member_grade_id)
);

-- PAYMENT_TYPE 테이블 생성
DROP TABLE IF EXISTS payment_type;

CREATE TABLE payment_type (
	payment_type_id BIGINT NOT NULL,
	payment_type_name VARCHAR(20) NOT NULL,
	payment_type_description TEXT NULL,
	PRIMARY KEY (payment_type_id)
);

-- REFUND_REASON 테이블 생성
DROP TABLE IF EXISTS refund_reason;

CREATE TABLE refund_reason (
	refund_reason_id BIGINT NOT NULL,
	refund_reason_name VARCHAR(20) NOT NULL,
	PRIMARY KEY (refund_reason_id)
);

-- COUPON_RULE 테이블 생성
DROP TABLE IF EXISTS coupon_rule;

CREATE TABLE coupon_rule (
	coupon_rule_id BIGINT NOT NULL,
	coupon_rule_name VARCHAR(30) NOT NULL,
	coupon_rule_type ENUM('AMOUNT', 'PERCENT') NOT NULL COMMENT '금액 할인, 비율 할인',
	coupon_rule_amount INT NOT NULL COMMENT '할인 금액',
	coupon_rule_discount_percent INT NOT NULL COMMENT '할인 비율',
	PRIMARY KEY (coupon_rule_id)
);

-- DISCOUNT 테이블 생성
DROP TABLE IF EXISTS discount;

CREATE TABLE discount (
	discount_id BIGINT NOT NULL,
	discount_name VARCHAR(30) NOT NULL,
	discount_amount INT NOT NULL COMMENT '할인 금액',
	PRIMARY KEY (discount_id)
);


DROP TABLE IF EXISTS point_order;
CREATE TABLE point_order (
	point_history_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id, orders_id)
);

-- ORDER_TO_STATUS_MAPPING 테이블 생성
DROP TABLE IF EXISTS order_to_status_mapping;

CREATE TABLE order_to_status_mapping (
	orders_id BIGINT NOT NULL,
	order_status_id BIGINT NOT NULL,
	order_status_created_at DATETIME NOT NULL,
	PRIMARY KEY (orders_id, order_status_id)
);

-- CATEGORY_COUPON 테이블 생성
DROP TABLE IF EXISTS category_coupon;

CREATE TABLE category_coupon (
	coupon_id BIGINT NOT NULL,
	category_id BIGINT NOT NULL,
	PRIMARY KEY (coupon_id, category_id)
);

-- BOOK_COUPON 테이블 생성
DROP TABLE IF EXISTS book_coupon;

CREATE TABLE book_coupon (
	coupon_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (coupon_id, book_id)
);

-- POINT_REVIEW 테이블 생성
DROP TABLE IF EXISTS point_review;

CREATE TABLE point_review (
	point_history_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id, orders_id, book_id)
);

-- POINT_REFUND 테이블 생성
DROP TABLE IF EXISTS point_refund;

CREATE TABLE point_refund (
	point_history_id BIGINT NOT NULL,
	refund_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id, refund_id)
);