DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
	admin_id BIGINT NOT NULL AUTO_INCREMENT,
	admin_login_id VARCHAR(20) NOT NULL,
	admin_password VARCHAR(255) NOT NULL COMMENT '암호화된 키 사용',
	admin_name VARCHAR(20) NOT NULL,
	PRIMARY KEY (admin_id)
);

-- CUSTOMER 테이블 생성

DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
	customer_id BIGINT NOT NULL AUTO_INCREMENT,
	customer_name VARCHAR(20) NOT NULL,
	customer_phone_number VARCHAR(13) NOT NULL,
	customer_email VARCHAR(50) NOT NULL,
	PRIMARY KEY (customer_id)
);

-- PUBLISHER 테이블 생성
DROP TABLE IF EXISTS publisher;

CREATE TABLE publisher (
	publisher_id BIGINT NOT NULL AUTO_INCREMENT,
	publisher_name VARCHAR(30) NOT NULL,
	publisher_is_used BOOLEAN NOT NULL,
	PRIMARY KEY (publisher_id)
);

-- MEMBER_GRADE 테이블 생성
DROP TABLE IF EXISTS member_grade;

CREATE TABLE member_grade (
	member_grade_id BIGINT NOT NULL AUTO_INCREMENT,
	member_grade_name VARCHAR(20) NOT NULL,
	member_grade_is_used BOOLEAN NOT NULL,
	member_grade_create_at DATETIME NOT NULL,
	member_grade_point_save FLOAT NULL,
	
	PRIMARY KEY (member_grade_id)
);

-- BOOK 테이블 생성
DROP TABLE IF EXISTS book;

CREATE TABLE book (
	book_id BIGINT NOT NULL AUTO_INCREMENT,
	publisher_id BIGINT NOT NULL,
	book_name VARCHAR(255) NOT NULL,
	book_index VARCHAR(255) NOT NULL,
	book_info TEXT NOT NULL,
	book_isbn VARCHAR(20) NOT NULL UNIQUE,
    book_status VARCHAR(20) NOT NULL DEFAULT '판매 중'
	publication_date DATETIME NOT NULL,
	regular_price INT NOT NULL,
	sale_price INT NOT NULL,
	is_packed BOOLEAN NOT NULL,
	stock INT NOT NULL,
	book_thumbnail_image_url TEXT NOT NULL,
	book_view_count INT NOT NULL DEFAULT 0,
	book_discount INT NULL,
	PRIMARY KEY (book_id),
    
      -- publisher_id를 publisher 테이블의 publisher_id와 연결하는 외래 키
    CONSTRAINT FK_publisher_TO_book FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)

);

-- MEMBER 테이블 생성
DROP TABLE IF EXISTS member;

CREATE TABLE member (
	customer_id BIGINT NOT NULL,
	member_grade_id BIGINT NOT NULL,
	member_login_id VARCHAR(20) NOT NULL UNIQUE,
	member_password VARCHAR(255) NOT NULL COMMENT '암호화된 키 사용',
	member_birthdate VARCHAR(8) NOT NULL,
	member_created_at DATETIME NOT NULL,
	member_last_login_at DATETIME NULL,
	member_status VARCHAR(10) NOT NULL DEFAULT 'ACTIVE' COMMENT '활성, 휴면, 탈퇴',
	member_point INT NOT NULL DEFAULT 0 COMMENT '음수가 되는 상황 처리 필요',
	PRIMARY KEY (customer_id),
    
     -- customer_id를 customer 테이블의 customer_id와 연결하는 외래 키   
    CONSTRAINT FK_customer_TO_member FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    
        -- member_grade_id를 member_grade 테이블의 member_grade_id와 연결하는 외래 키
    CONSTRAINT FK_member_grade_TO_member FOREIGN KEY (member_grade_id) REFERENCES member_grade(member_grade_id)
);

-- COUPON_RULE 테이블 생성
DROP TABLE IF EXISTS coupon_rule;

CREATE TABLE coupon_rule (
	coupon_rule_id BIGINT NOT NULL AUTO_INCREMENT,
	coupon_type TINYINT NOT NULL,
	coupon_min_order_price INT NOT NULL,
	max_discount_price INT NOT NULL,
	coupon_discount_price INT NOT NULL,
	coupon_rule_name VARCHAR(20) NOT NULL,
	coupon_is_used BOOLEAN NOT NULL,
	coupon_rule_created_at DATETIME,

	PRIMARY KEY (coupon_rule_id)
);

-- COUPON 테이블 생성
DROP TABLE IF EXISTS coupon;

CREATE TABLE coupon (
	coupon_id BIGINT NOT NULL AUTO_INCREMENT,
	coupon_rule_id BIGINT NOT NULL,
	coupon_name VARCHAR(30) NOT NULL,
	coupon_description TEXT NOT NULL,
	coupon_effective_period INT NULL,
	coupon_effective_period_unit TINYINT NULL COMMENT '단위 : 일.월,년',
	coupon_create_at DATETIME NOT NULL,
	coupon_expired_at DATETIME NULL,
	PRIMARY KEY (coupon_id),
    
    CONSTRAINT FK_coupon_rule_TO_coupon FOREIGN KEY (coupon_rule_id) REFERENCES coupon_rule(coupon_rule_id)
);


-- MEMBER_COUPON 테이블 생성
DROP TABLE IF EXISTS member_coupon;

CREATE TABLE member_coupon (
	member_coupon_id BIGINT NOT NULL AUTO_INCREMENT,
	customer_id BIGINT NOT NULL,
	coupon_id BIGINT NOT NULL,
	member_coupon_created_at DATETIME NOT NULL,
	member_coupon_expired_at DATETIME NOT NULL COMMENT '쿠폰 만료일이 현재 시간 이전이면, 만료된 쿠폰으로 간주',
	member_coupon_used_at DATETIME NULL,
	PRIMARY KEY (member_coupon_id),
    
    -- customer 외래키 연결 --
    CONSTRAINT FK_customer_TO_member_coupon FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    
    -- 쿠폰 외래키 연결 --
    CONSTRAINT FK_coupon_TO_member_coupon FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
);

-- DELIVERY_RULE 테이블 생성
DROP TABLE IF EXISTS delivery_rule;

CREATE TABLE delivery_rule (
	delivery_rule_id BIGINT NOT NULL AUTO_INCREMENT,
	delivery_rule_name VARCHAR(30) NOT NULL,
	delivery_fee INT NOT NULL,
	delivery_discount_cost INT NULL COMMENT 'ex) 3만원 이상 무료배송',
	delivery_rule_is_selected BOOLEAN NOT NULL COMMENT '현재 사용중인 배송 정책 판단',
	delivery_rule_created_at DATETIME NOT NULL,
	PRIMARY KEY (delivery_rule_id)
);

-- ORDERS 테이블 생성 (ORDER를 ORDERS로 변경)
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
	orders_id BIGINT NOT NULL AUTO_INCREMENT,
	customer_id BIGINT NOT NULL,
	member_coupon_id BIGINT NULL,
    delivery_rule_id BIGINT NULL,
	ordered_date DATETIME NOT NULL,
	order_total_price INT NOT NULL COMMENT '총 책 금액 + 포장 금액',
	order_number VARCHAR(20) NOT NULL COMMENT '년월일 + 임의값',
    delivery_set_date DATETIME NULL,
    order_invoice_number VARCHAR(12) NULL,
    receiver_name VARCHAR(20) NOT NULL,
    receiver_phone_number VARCHAR(13) NOT NULL,
    order_request VARCHAR(200) NOT NULL,
    delivery_address_roadname VARCHAR(30) NOT NULL,
    delivery_address_detail VARCHAR(35) NOT NULL,
    delivery_postal_number VARCHAR(5) NOT NULL,


    PRIMARY KEY (orders_id),
    
       -- customer_id를 member 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_orders FOREIGN KEY (customer_id) REFERENCES member(customer_id),

    -- member_coupon_id를 member_coupon 테이블의 member_coupon_id와 연결하는 외래 키
    CONSTRAINT FK_member_coupon_TO_orders FOREIGN KEY (member_coupon_id) REFERENCES member_coupon(member_coupon_id),

    -- delivery_rule_id를 delivery_rule 테이블의 delivery_rule_id와 연결하는 외래 키
    CONSTRAINT FK_delivery_rule_TO_orders FOREIGN KEY (delivery_rule_id) REFERENCES delivery_rule(delivery_rule_id)
);

-- REVIEW 테이블 생성
DROP TABLE IF EXISTS review;

CREATE TABLE review (
	orders_id BIGINT NOT NULL AUTO_INCREMENT,
	book_id BIGINT NOT NULL,
	customer_id BIGINT NOT NULL,
	review_rate INT NOT NULL,
	review_title VARCHAR(50) NOT NULL,
	review_content TEXT NOT NULL,
	review_created_at DATETIME NOT NULL,
	review_image_url TEXT NULL,
	PRIMARY KEY (orders_id, book_id),
    
   -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_review FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_review FOREIGN KEY (book_id) REFERENCES book(book_id),

    -- customer_id를 customer 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_review FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);


-- CATEGORY 테이블 생성
DROP TABLE IF EXISTS category;

CREATE TABLE category (
	category_id BIGINT NOT NULL AUTO_INCREMENT,
	category_name VARCHAR(20) NOT NULL,
	super_category_id BIGINT NULL,
    category_is_used BOOLEAN NOT NULL DEFAULT true	COMMENT '카테고리를 사용중인지 확인(미사용 시 false)',
	PRIMARY KEY (category_id),
    
    -- category 자기참조를 위한 외래키 연결) --
    CONSTRAINT FK_super_category_TO_category FOREIGN KEY (super_category_id) REFERENCES category(category_id) 
);

-- BOOK_CATEGORY 테이블 생성
DROP TABLE IF EXISTS book_category;

CREATE TABLE book_category (
	category_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (category_id, book_id),
    
        -- category_id를 category 테이블의 category_id와 연결하는 외래 키
    CONSTRAINT FK_category_TO_book_category FOREIGN KEY (category_id) REFERENCES category(category_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_book_category FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- AUTHOR 테이블 생성
DROP TABLE IF EXISTS author;

CREATE TABLE author (
	author_id BIGINT NOT NULL AUTO_INCREMENT,
	author_name VARCHAR(20) NOT NULL,
	author_info VARCHAR(255) NOT NULL,
	PRIMARY KEY (author_id)
);

-- TAG 테이블 생성
DROP TABLE IF EXISTS tag;

CREATE TABLE tag (
	tag_id BIGINT NOT NULL AUTO_INCREMENT,
	tag_name VARCHAR(30) NOT NULL,
	PRIMARY KEY (tag_id)
);

-- BOOK_TAG 테이블 생성
DROP TABLE IF EXISTS book_tag;

CREATE TABLE book_tag (
	book_id BIGINT NOT NULL,
	tag_id BIGINT NOT NULL,
	PRIMARY KEY (book_id, tag_id),
    
    
    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_book_tag FOREIGN KEY (book_id) REFERENCES book(book_id),

    -- tag_id를 tag 테이블의 tag_id와 연결하는 외래 키
    CONSTRAINT FK_tag_TO_book_tag FOREIGN KEY (tag_id) REFERENCES tag(tag_id)
);

-- BOOK_LIKE 테이블 생성
DROP TABLE IF EXISTS book_like;

CREATE TABLE book_like (
	customer_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (customer_id, book_id),
    
    
    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_book_like FOREIGN KEY (book_id) REFERENCES book(book_id),

    -- customer_id를 tag 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_book_like FOREIGN KEY (customer_id) REFERENCES member(customer_id)
);

-- ADDRESS 테이블 생성
DROP TABLE IF EXISTS address;

CREATE TABLE address (
	registered_address_id BIGINT NOT NULL AUTO_INCREMENT,
	customer_id BIGINT NOT NULL,
	address_alias VARCHAR(15) NULL,
	address_roadname VARCHAR(30) NOT NULL,
	address_detail VARCHAR(35) NOT NULL,
	address_postal_number VARCHAR(5) NOT NULL,
	PRIMARY KEY (registered_address_id),
    
       -- customer_id를 member 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_address FOREIGN KEY (customer_id) REFERENCES member(customer_id)
);

-- ORDER_DETAIL 테이블 생성
DROP TABLE IF EXISTS order_detail;

CREATE TABLE order_detail (
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	member_coupon_id BIGINT NULL,
	quantity INT NOT NULL,
	bookprice_at_order INT NOT NULL COMMENT '도서의 판매가가 변경 될 수 있으므로, 해당 주문 시 도서 가격을 저장함.(기록용)',
	PRIMARY KEY (orders_id, book_id),
    
     -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_order_detail FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_order_detail FOREIGN KEY (book_id) REFERENCES book(book_id),

    -- member_coupon_id를 member_coupon 테이블의 member_coupon_id와 연결하는 외래 키
    CONSTRAINT FK_member_coupon_TO_order_detail FOREIGN KEY (member_coupon_id) REFERENCES member_coupon(member_coupon_id)
);

-- ORDER_STATUS 테이블 생성
DROP TABLE IF EXISTS order_status;

CREATE TABLE order_status (
	order_status_id BIGINT NOT NULL AUTO_INCREMENT,
	order_status_name ENUM('PENDING', 'IN_SHOPPING', 'COMPLETED', 'RETURNED', 'CANCELED') NOT NULL DEFAULT 'PENDING' COMMENT '대기, 배송중, 완료, 반품, 주문취소',
	PRIMARY KEY (order_status_id)
);

-- PACKAGING 테이블 생성
DROP TABLE IF EXISTS packaging;

CREATE TABLE packaging (
	packaging_id BIGINT NOT NULL AUTO_INCREMENT,
	packaging_name VARCHAR(20) NOT NULL,
	packaging_price INT NOT NULL,
	packaging_image_url TEXT NULL,
	PRIMARY KEY (packaging_id)
);

-- REFUND_REASON 테이블 생성
DROP TABLE IF EXISTS refund_reason;

CREATE TABLE refund_reason (
	refund_reason_id BIGINT NOT NULL AUTO_INCREMENT,
	refund_reason_name VARCHAR(20) NOT NULL,
	refund_reason_is_used BOOLEAN NOT NULL,
	refund_reason_created_at DATETIME NOT NULL,
	refund_delivery_fee INT NOT NULL,
	PRIMARY KEY (refund_reason_id)
);

-- REFUND 테이블 생성
DROP TABLE IF EXISTS refund;

CREATE TABLE refund (
	refund_id BIGINT NOT NULL AUTO_INCREMENT,
	refund_reason_id BIGINT NOT NULL,
	refund_quantity INT NOT NULL,
	refund_price INT NOT NULL,
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (refund_id),
    
        -- refund_reason_id를 refund_reason 테이블의 refund_reason_id와 연결하는 외래 키
    CONSTRAINT FK_refund_reason_TO_refund FOREIGN KEY (refund_reason_id) REFERENCES refund_reason(refund_reason_id),

   -- order_id와 book_id를 composite key로 사용하기 위해 OrderDetail에서 가져옵니다.
    CONSTRAINT FK_order_detail_TO_refund FOREIGN KEY (orders_id, book_id) REFERENCES order_detail(orders_id, book_id)
);

-- ORDER_DETAIL_PACKAGING 테이블 생성
DROP TABLE IF EXISTS order_detail_packaging;

CREATE TABLE order_detail_packaging (
	order_detail_packaging_id BIGINT NOT NULL AUTO_INCREMENT,
	packaging_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	packaging_quantity INT NOT NULL,
	PRIMARY KEY (order_detail_packaging_id),
    
       -- packaging_id를 packaging 테이블의 packaging_id와 연결하는 외래 키
    CONSTRAINT FK_packaging_TO_order_detail_packaging FOREIGN KEY (packaging_id) REFERENCES packaging(packaging_id),

    -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_order_detail_packaging FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_order_detail_packaging FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- SHOPPINGCART 테이블 생성
DROP TABLE IF EXISTS shoppingcart;

CREATE TABLE shoppingcart (
	customer_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	book_quantity INT NOT NULL,
	PRIMARY KEY (customer_id, book_id),
    
       -- customer_id를 member 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_shoppingcart FOREIGN KEY (customer_id) REFERENCES member(customer_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_shoppingcart FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- POINT_SAVE_RULE 테이블 생성
DROP TABLE IF EXISTS point_save_rule;

CREATE TABLE point_save_rule (
	point_save_rule_id BIGINT NOT NULL AUTO_INCREMENT,
	point_save_rule_name VARCHAR(30) NOT NULL,
	point_save_amount INT NOT NULL COMMENT '각 정책에 따른 포인트 적립량',
	point_save_rule_generate_date DATETIME NOT NULL,
	point_save_rule_is_selected BOOLEAN NOT NULL,
	point_save_type ENUM('PERCENT', 'INTEGER') NOT NULL COMMENT '퍼센트, 정수',
	PRIMARY KEY (point_save_rule_id)
);

-- POINT_HISTORY 테이블 생성
DROP TABLE IF EXISTS point_history;

CREATE TABLE point_history (
	point_history_id BIGINT NOT NULL AUTO_INCREMENT,
	point_save_rule_id BIGINT NULL,
	customer_id BIGINT NOT NULL,
	point_amount INT NOT NULL COMMENT '+,- 로 기록, 정수 값이 음수가 될 수 있음',
	point_change_date DATETIME NOT NULL,
	point_change_reason VARCHAR(50) NOT NULL COMMENT '사용, 적립 etc',
	PRIMARY KEY (point_history_id),
    
       -- customer_id를 customer 테이블의 customer_id와 연결하는 외래 키
    CONSTRAINT FK_customer_TO_point_history FOREIGN KEY (customer_id) REFERENCES customer(customer_id),

    -- point_save_rule_id를 point_save_rule 테이블의 point_save_rule_id와 연결하는 외래 키
    CONSTRAINT FK_point_save_rule_TO_point_history FOREIGN KEY (point_save_rule_id) REFERENCES point_save_rule(point_save_rule_id)
);

-- PAYMENT_TYPE 테이블 생성
DROP TABLE IF EXISTS payment_type;

CREATE TABLE payment_type (
	payment_type_id BIGINT NOT NULL AUTO_INCREMENT,
	payment_type_name VARCHAR(30) NOT NULL,
	payment_type_is_used BOOLEAN NOT NULL,
	payment_type_created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (payment_type_id)
);

-- PAYMENT 테이블 생성
DROP TABLE IF EXISTS payment;

CREATE TABLE payment (
	payment_id BIGINT NOT NULL AUTO_INCREMENT,
	orders_id BIGINT NOT NULL,
	payment_type_id BIGINT NOT NULL,
	payment_created_at DATETIME NOT NULL,
	payment_amount INT NOT NULL,
	payment_key VARCHAR(200) NULL,
	payment_status ENUM('COMPLETE', 'CANCEL') NOT NULL COMMENT '완료, 취소',
	PRIMARY KEY (payment_id),
    
       -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_payment FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- payment_type_id를 payment_type 테이블의 payment_type_id와 연결하는 외래 키
    CONSTRAINT FK_payment_type_TO_payment FOREIGN KEY (payment_type_id) REFERENCES payment_type(payment_type_id)
);

-- BOOK_AUTHOR 테이블 생성
DROP TABLE IF EXISTS book_author;

CREATE TABLE book_author (
	book_author_id BIGINT NOT NULL AUTO_INCREMENT,
	book_id BIGINT NOT NULL,
	author_id BIGINT NOT NULL,
	PRIMARY KEY (book_author_id),
    
      -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_book_author FOREIGN KEY (book_id) REFERENCES book(book_id),

    -- author_id를 author 테이블의 author_id와 연결하는 외래 키
    CONSTRAINT FK_author_TO_book_author FOREIGN KEY (author_id) REFERENCES author(author_id)
);

DROP TABLE IF EXISTS point_order;
CREATE TABLE point_order (
	point_history_id BIGINT NOT NULL,
	orders_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id),
    
        -- point_history_id를 point_history 테이블의 point_history_id와 연결하는 외래 키
    CONSTRAINT FK_point_history_TO_point_order FOREIGN KEY (point_history_id) REFERENCES point_history(point_history_id),

    -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_point_order FOREIGN KEY (orders_id) REFERENCES orders(orders_id)
);

-- ORDER_TO_STATUS_MAPPING 테이블 생성
DROP TABLE IF EXISTS order_to_status_mapping;

CREATE TABLE order_to_status_mapping (
	orders_id BIGINT NOT NULL,
	order_status_id BIGINT NOT NULL,
	order_status_created_at DATETIME NOT NULL,
	PRIMARY KEY (orders_id, order_status_id),
    
       -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_order_status_mapping FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- order_status_id를 order_status 테이블의 order_status_id와 연결하는 외래 키
    CONSTRAINT FK_order_status_TO_order_status_mapping FOREIGN KEY (order_status_id) REFERENCES order_status(order_status_id)
);

-- CATEGORY_COUPON 테이블 생성
DROP TABLE IF EXISTS category_coupon;

CREATE TABLE category_coupon (
    coupon_id BIGINT NOT NULL,
    category_id BIGINT NOT NULL,
    PRIMARY KEY (coupon_id),
    
        -- coupon_id를 coupon 테이블의 coupon_id와 연결하는 외래 키
    CONSTRAINT FK_coupon_TO_category_coupon FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id),
    
    -- category_id를 category 테이블의 category_id와 연결하는 외래 키
    CONSTRAINT FK_category_TO_category_coupon FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- BOOK_COUPON 테이블 생성
DROP TABLE IF EXISTS book_coupon;

CREATE TABLE book_coupon (
	coupon_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (coupon_id), -- coupon_id를 기본 키로 설정
    
        -- coupon_id를 coupon 테이블의 coupon_id와 연결하는 외래 키
    CONSTRAINT FK_coupon_TO_book_coupon FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_book_coupon FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- POINT_REVIEW 테이블 생성
DROP TABLE IF EXISTS point_review;

CREATE TABLE point_review (
	point_history_id BIGINT NOT NULL AUTO_INCREMENT,
	orders_id BIGINT NOT NULL,
	book_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id),
    
      -- point_history_id를 point_history 테이블의 point_history_id와 연결하는 외래 키
    CONSTRAINT FK_point_history_TO_point_review FOREIGN KEY (point_history_id) REFERENCES point_history(point_history_id),

    -- orders_id를 orders 테이블의 orders_id와 연결하는 외래 키
    CONSTRAINT FK_orders_TO_point_review FOREIGN KEY (orders_id) REFERENCES orders(orders_id),

    -- book_id를 book 테이블의 book_id와 연결하는 외래 키
    CONSTRAINT FK_book_TO_point_review FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- POINT_REFUND 테이블 생성
DROP TABLE IF EXISTS point_refund;

CREATE TABLE point_refund (
	point_history_id BIGINT NOT NULL AUTO_INCREMENT,
	refund_id BIGINT NOT NULL,
	PRIMARY KEY (point_history_id),
    
        -- point_history_id를 point_history 테이블의 point_history_id와 연결하는 외래 키
    CONSTRAINT FK_point_history_TO_point_refund FOREIGN KEY (point_history_id) REFERENCES point_history(point_history_id),
    
        -- refund_id를 refund 테이블의 refund_id와 연결하는 외래 키
    CONSTRAINT FK_refund_TO_point_refund FOREIGN KEY (refund_id) REFERENCES refund(refund_id)
);
