CREATE TABLE `book` (
	`book_id`	bigint	NOT NULL,
	`publisher_id`	int	NOT NULL,
	`book_name`	varchar(255)	NOT NULL,
	`book_index`	varchar(255)	NOT NULL,
	`book_info`	text	NOT NULL,
	`book_isbn`	varchar(20)	NOT NULL,
	`publication_date`	datetime	NOT NULL,
	`regular_price`	int	NOT NULL,
	`sale_price`	int	NOT NULL,
	`is_packed`	boolean	NOT NULL,
	`stock`	int	NOT NULL,
	`book_thumbnail_image_url`	text	NOT NULL,
	`book_view_count`	bigint	NOT NULL	DEFAULT 0,
	`book_discount`	int	NULL
);

CREATE TABLE `member` (
	`customer_id`	bigint	NOT NULL,
	`member_grade_id`	int	NOT NULL,
	`member_login_id`	varchar(20)	NOT NULL,
	`member_password`	varchar(255)	NOT NULL	COMMENT '암호화된 키 사용',
	`member_birthdate`	varchar(8)	NOT NULL,
	`member_created_at`	datetime	NOT NULL,
	`member_last_login_at`	datetime	NULL,
	`member_status`	enum('ACTIVE','SLEEP','WITHDRAW')	NOT NULL	DEFAULT 'ACTIVE'	COMMENT '활성, 휴먼, 탈퇴',
	`member_point`	int	NOT NULL	DEFAULT 0	COMMENT '음수가 되는 상황 처리 필요'
);

CREATE TABLE `review` (
	`order_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`review_rate`	int	NOT NULL,
	`review_title`	varchar(50)	NOT NULL,
	`review_content`	text	NOT NULL,
	`review_created_at`	datetime	NOT NULL,
	`review_image_url`	text	NULL
);

CREATE TABLE `member_coupon` (
	`member_coupon_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`coupon_id`	bigint	NOT NULL,
	`member_coupon_created_at`	datetime	NOT NULL,
	`member_coupon_expired_at`	datetime	NOT NULL	COMMENT '쿠폰 만료일이 현재 시간 이전이면, 만료된 쿠폰으로 간주',
	`member_coupon_used_at`	datetime	NULL
);

CREATE TABLE `point_history` (
	`point_history_id`	bigint	NOT NULL,
	`point_save_rule_id`	bigint	NULL,
	`customer_id`	bigint	NOT NULL,
	`point_amount`	int	NOT NULL	COMMENT '+,- 로 기록, 정수 값이 음수가 될 수 있음',
	`point_change_date`	datetime	NOT NULL,
	`point_change_reason`	varchar(50)	NOT NULL	COMMENT '사용, 적립 etc'
);

CREATE TABLE `order` (
	`order_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`member_coupon_id`	bigint	NULL,
	`ordered_date`	datetime	NOT NULL,
	`order_total_price`	int	NOT NULL	COMMENT '총 책 금액 +  포장 금액',
	`order_number`	varchar(20)	NOT NULL	COMMENT '년월일 + 임의값'
);

CREATE TABLE `category` (
	`category_id`	bigint	NOT NULL,
	`category_name`	varchar(20)	NOT NULL,
	`super_category_id`	bigint	NULL
);

CREATE TABLE `book_category` (
	`category_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `author` (
	`author_id`	bigint	NOT NULL,
	`author_name`	varchar(20)	NOT NULL,
	`author_info`	varchar(255)	NOT NULL
);

CREATE TABLE `publisher` (
	`publisher_id`	bigint	NOT NULL,
	`publisher_name`	varchar(30)	NOT NULL,
	`publisher_is_used`	boolean	NOT NULL
);

CREATE TABLE `Tag` (
	`tag_id`	bigint	NOT NULL,
	`tag_name`	varchar(30)	NOT NULL
);

CREATE TABLE `book_tag` (
	`book_id`	bigint	NOT NULL,
	`tag_id`	bigint	NOT NULL
);

CREATE TABLE `book_like` (
	`customer_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `address` (
	`registered_address_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`address_alias`	varchar(15)	NULL,
	`address_roadname`	varchar(30)	NOT NULL,
	`address_detail`	varchar(35)	NOT NULL,
	`address_postal_number`	varchar(5)	NOT NULL
);

CREATE TABLE `customer` (
	`customer_id`	bigint	NOT NULL,
	`customer_name`	varchar(20)	NOT NULL,
	`customer_phone_number`	varchar(13)	NOT NULL,
	`customer_email`	varchar(50)	NOT NULL
);

CREATE TABLE `order_detail` (
	`order_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`member_coupon_id`	bigint	NULL,
	`quantity`	int	NOT NULL,
	`bookprice_at_order`	int	NOT NULL	COMMENT '도서의 판매가가 변경 될 수 있으므로, 해당 주문 시 도서 가격을 저장함.(기록용)'
);

CREATE TABLE `order_status` (
	`order_status_id`	bigint	NOT NULL,
	`order_status_name`	enum('PEENDING', 'IN_SHOPPING', 'COMPLETED', 'RETURNED', 'CANCELED')	NOT NULL	DEFAULT 'PENDING'	COMMENT '대기 , 배송중, 완료, 반품, 주문취소'
);

CREATE TABLE `delivery_rule` (
	`delivery_rule`	bigint	NOT NULL,
	`delivery_rule_name`	varchar(30)	NOT NULL,
	`delivery_fee`	int	NOT NULL,
	`delivery_discount_cost`	int	NULL	COMMENT 'ex) 3만원 이상 무료배송',
	`delivery_rule_is_selected`	boolean	NOT NULL	COMMENT '현재 사용중인  배송 정책 판단',
	`delivery_rule_created_at`	datetime	NOT NULL
);

CREATE TABLE `packaging` (
	`packaging_id`	bigint	NOT NULL,
	`packaging_name`	varchar(20)	NOT NULL,
	`packaging_price`	int	NOT NULL,
	`packaging_image_url`	text	NULL
);

CREATE TABLE `refund` (
	`refund_id`	bigint	NOT NULL,
	`refund_reason_id`	bigint	NOT NULL,
	`refund_quantity`	int	NOT NULL,
	`refund_price`	int	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `order_detail_packaging` (
	`order_detail_packaging`	bigint	NOT NULL,
	`packaging_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`packaging_quantity`	int	NOT NULL
);

CREATE TABLE `shoppingcart` (
	`customer_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`book_quantitty`	int	NOT NULL
);

CREATE TABLE `point_save_rule` (
	`point_save_rule_id`	bigint	NOT NULL,
	`point_save_rule_name`	varchar(30)	NOT NULL,
	`point_save_amount`	int	NOT NULL	DEFAULT 0	COMMENT '각 정책에 따른 포인트 적립량',
	`point_save_rule_generate_date`	datetime	NOT NULL,
	`point_save_rule_is_selected`	boolean	NOT NULL,
	`point_save_type`	enum('PERCENT', 'INTEGER')	NOT NULL	COMMENT '퍼센트, 정수'
);

CREATE TABLE `coupon` (
	`coupon_id`	bigint	NOT NULL,
	`coupon_rule_id`	bigint	NOT NULL,
	`coupon_name`	varchar(30)	NOT NULL,
	`coupon_description`	text	NOT NULL,
	`coupon_effective_period`	int	NULL,
	`coupon_effective_period_unit`	enum('DAY', 'MONTH', 'YEAR')	NULL	COMMENT '단위 : 일.월,년',
	`coupon_create_at`	datetime	NOT NULL,
	`coupon_expired_at`	datetime	NULL
);

CREATE TABLE `payment` (
	`payment_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`payment_created_at`	datetime	NOT NULL,
	`payment_amount`	int	NOT NULL,
	`payment_type`	enum('CREDIT_CARD','TOSS')	NOT NULL,
	`payment_key`	varchar(200)	NULL,
	`payment_type_id`	int	NOT NULL,
	`payment_status`	enum('COMPLETE', 'CANCEL')	NOT NULL	COMMENT '완료, 취소'
);

CREATE TABLE `delivery` (
	`delivery_id`	bigint	NOT NULL,
	`delivery_rule`	int	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`delivery_set_date`	datetime	NULL,
	`order_invoice_number`	varchar(12)	NOT NULL,
	`receiver_phone_number`	varchar(13)	NOT NULL,
	`order_request`	varchar(200)	NOT NULL,
	`delivery_address_roadname`	varchar(30)	NOT NULL,
	`delivery_address_detail`	varchar(35)	NOT NULL,
	`delivery_postal_number`	varchar(5)	NOT NULL
);

CREATE TABLE `book_author` (
	`book_author_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`author_id2`	bigint	NOT NULL
);

CREATE TABLE `member_grade` (
	`member_grade_id`	bigint	NOT NULL,
	`member_grade_name`	varchar(20)	NOT NULL,
	`member_grade_is_used`	boolean	NOT NULL,
	`member_grade_create_at`	datetime	NOT NULL,
	`member_grade_point_save`	float	NULL
);

CREATE TABLE `payment_type` (
	`payment_type_id`	bigint	NOT NULL,
	`payment_type_name`	varchar(30)	NOT NULL,
	`payment_type_is_used`	boolean	NOT NULL,
	`payment_type_created_at`	datetime	NOT NULL
);

CREATE TABLE `refund_reason` (
	`refund_reason_id`	bigint	NOT NULL,
	`refund_reason_name`	varchar(20)	NOT NULL,
	`refund_reason_is_used`	boolean	NOT NULL,
	`refund_reason_created_at`	datetime	NOT NULL,
	`refund_delivery_fee`	int	NOT NULL
);

CREATE TABLE `point_order` (
	`point_history_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL
);

CREATE TABLE `order_to_status_mapping` (
	`order_id`	bigint	NOT NULL,
	`order_status_id`	bigint	NOT NULL,
	`order_status_created_at`	datetime	NOT NULL
);

CREATE TABLE `category_coupon` (
	`coupon_id`	bigint	NOT NULL,
	`category_id`	bigint	NOT NULL
);

CREATE TABLE `book_coupon` (
	`coupon_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `admin` (
	`admin_id`	bigint	NOT NULL,
	`admin_login_id`	varchar(20)	NOT NULL,
	`admin_login_password`	varchar(20)	NOT NULL
);

CREATE TABLE `coupon_rule` (
	`coupon_rule_id`	bigint	NOT NULL,
	`coupon_type`	enum()	NOT NULL,
	`coupon_min_order_price`	int	NOT NULL,
	`max_discount_price`	int	NOT NULL,
	`coupon_discount_price`	int	NOT NULL,
	`coupon_rule_name`	varchar(20)	NOT NULL,
	`coupon_is_used`	boolean	NOT NULL,
	`coupon_rule_created_at`	datetime	NOT NULL
);

CREATE TABLE `point_review` (
	`point_history_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `point_refund` (
	`point_history_id`	bigint	NOT NULL,
	`refund_id`	bigint	NOT NULL
);

CREATE TABLE `discount` (
	`discount_id`	VARCHAR(255)	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`book_discount_log`	int	NOT NULL,
	`book_discount_date`	timestamp	NOT NULL
);

ALTER TABLE `book` ADD CONSTRAINT `PK_BOOK` PRIMARY KEY (
	`book_id`
);

ALTER TABLE `member` ADD CONSTRAINT `PK_MEMBER` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `review` ADD CONSTRAINT `PK_REVIEW` PRIMARY KEY (
	`order_id`,
	`book_id`
);

ALTER TABLE `member_coupon` ADD CONSTRAINT `PK_MEMBER_COUPON` PRIMARY KEY (
	`member_coupon_id`
);

ALTER TABLE `point_history` ADD CONSTRAINT `PK_POINT_HISTORY` PRIMARY KEY (
	`point_history_id`
);

ALTER TABLE `order` ADD CONSTRAINT `PK_ORDER` PRIMARY KEY (
	`order_id`
);

ALTER TABLE `category` ADD CONSTRAINT `PK_CATEGORY` PRIMARY KEY (
	`category_id`
);

ALTER TABLE `book_category` ADD CONSTRAINT `PK_BOOK_CATEGORY` PRIMARY KEY (
	`category_id`,
	`book_id`
);

ALTER TABLE `author` ADD CONSTRAINT `PK_AUTHOR` PRIMARY KEY (
	`author_id`
);

ALTER TABLE `publisher` ADD CONSTRAINT `PK_PUBLISHER` PRIMARY KEY (
	`publisher_id`
);

ALTER TABLE `Tag` ADD CONSTRAINT `PK_TAG` PRIMARY KEY (
	`tag_id`
);

ALTER TABLE `book_tag` ADD CONSTRAINT `PK_BOOK_TAG` PRIMARY KEY (
	`book_id`,
	`tag_id`
);

ALTER TABLE `book_like` ADD CONSTRAINT `PK_BOOK_LIKE` PRIMARY KEY (
	`customer_id`,
	`book_id`
);

ALTER TABLE `address` ADD CONSTRAINT `PK_ADDRESS` PRIMARY KEY (
	`registered_address_id`
);

ALTER TABLE `customer` ADD CONSTRAINT `PK_CUSTOMER` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `order_detail` ADD CONSTRAINT `PK_ORDER_DETAIL` PRIMARY KEY (
	`order_id`,
	`book_id`
);

ALTER TABLE `order_status` ADD CONSTRAINT `PK_ORDER_STATUS` PRIMARY KEY (
	`order_status_id`
);

ALTER TABLE `delivery_rule` ADD CONSTRAINT `PK_DELIVERY_RULE` PRIMARY KEY (
	`delivery_rule`
);

ALTER TABLE `packaging` ADD CONSTRAINT `PK_PACKAGING` PRIMARY KEY (
	`packaging_id`
);

ALTER TABLE `refund` ADD CONSTRAINT `PK_REFUND` PRIMARY KEY (
	`refund_id`
);

ALTER TABLE `order_detail_packaging` ADD CONSTRAINT `PK_ORDER_DETAIL_PACKAGING` PRIMARY KEY (
	`order_detail_packaging`
);

ALTER TABLE `shoppingcart` ADD CONSTRAINT `PK_SHOPPINGCART` PRIMARY KEY (
	`customer_id`,
	`book_id`
);

ALTER TABLE `point_save_rule` ADD CONSTRAINT `PK_POINT_SAVE_RULE` PRIMARY KEY (
	`point_save_rule_id`
);

ALTER TABLE `coupon` ADD CONSTRAINT `PK_COUPON` PRIMARY KEY (
	`coupon_id`
);

ALTER TABLE `payment` ADD CONSTRAINT `PK_PAYMENT` PRIMARY KEY (
	`payment_id`
);

ALTER TABLE `delivery` ADD CONSTRAINT `PK_DELIVERY` PRIMARY KEY (
	`delivery_id`
);

ALTER TABLE `book_author` ADD CONSTRAINT `PK_BOOK_AUTHOR` PRIMARY KEY (
	`book_author_id`
);

ALTER TABLE `member_grade` ADD CONSTRAINT `PK_MEMBER_GRADE` PRIMARY KEY (
	`member_grade_id`
);

ALTER TABLE `payment_type` ADD CONSTRAINT `PK_PAYMENT_TYPE` PRIMARY KEY (
	`payment_type_id`
);

ALTER TABLE `refund_reason` ADD CONSTRAINT `PK_REFUND_REASON` PRIMARY KEY (
	`refund_reason_id`
);

ALTER TABLE `point_order` ADD CONSTRAINT `PK_POINT_ORDER` PRIMARY KEY (
	`point_history_id`
);

ALTER TABLE `order_to_status_mapping` ADD CONSTRAINT `PK_ORDER_TO_STATUS_MAPPING` PRIMARY KEY (
	`order_id`,
	`order_status_id`
);

ALTER TABLE `category_coupon` ADD CONSTRAINT `PK_CATEGORY_COUPON` PRIMARY KEY (
	`coupon_id`
);

ALTER TABLE `book_coupon` ADD CONSTRAINT `PK_BOOK_COUPON` PRIMARY KEY (
	`coupon_id`
);

ALTER TABLE `admin` ADD CONSTRAINT `PK_ADMIN` PRIMARY KEY (
	`admin_id`
);

ALTER TABLE `coupon_rule` ADD CONSTRAINT `PK_COUPON_RULE` PRIMARY KEY (
	`coupon_rule_id`
);

ALTER TABLE `point_review` ADD CONSTRAINT `PK_POINT_REVIEW` PRIMARY KEY (
	`point_history_id`
);

ALTER TABLE `point_refund` ADD CONSTRAINT `PK_POINT_REFUND` PRIMARY KEY (
	`point_history_id`
);

ALTER TABLE `discount` ADD CONSTRAINT `PK_DISCOUNT` PRIMARY KEY (
	`discount_id`
);

ALTER TABLE `member` ADD CONSTRAINT `FK_customer_TO_member_1` FOREIGN KEY (
	`customer_id`
)
REFERENCES `customer` (
	`customer_id`
);

ALTER TABLE `review` ADD CONSTRAINT `FK_order_detail_TO_review_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `order_detail` (
	`order_id`
);

ALTER TABLE `review` ADD CONSTRAINT `FK_order_detail_TO_review_2` FOREIGN KEY (
	`book_id`
)
REFERENCES `order_detail` (
	`book_id`
);

ALTER TABLE `book_category` ADD CONSTRAINT `FK_category_TO_book_category_1` FOREIGN KEY (
	`category_id`
)
REFERENCES `category` (
	`category_id`
);

ALTER TABLE `book_category` ADD CONSTRAINT `FK_book_TO_book_category_1` FOREIGN KEY (
	`book_id`
)
REFERENCES `book` (
	`book_id`
);

ALTER TABLE `book_tag` ADD CONSTRAINT `FK_book_TO_book_tag_1` FOREIGN KEY (
	`book_id`
)
REFERENCES `book` (
	`book_id`
);

ALTER TABLE `book_tag` ADD CONSTRAINT `FK_Tag_TO_book_tag_1` FOREIGN KEY (
	`tag_id`
)
REFERENCES `Tag` (
	`tag_id`
);

ALTER TABLE `book_like` ADD CONSTRAINT `FK_member_TO_book_like_1` FOREIGN KEY (
	`customer_id`
)
REFERENCES `member` (
	`customer_id`
);

ALTER TABLE `book_like` ADD CONSTRAINT `FK_book_TO_book_like_1` FOREIGN KEY (
	`book_id`
)
REFERENCES `book` (
	`book_id`
);

ALTER TABLE `order_detail` ADD CONSTRAINT `FK_order_TO_order_detail_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `order` (
	`order_id`
);

ALTER TABLE `order_detail` ADD CONSTRAINT `FK_book_TO_order_detail_1` FOREIGN KEY (
	`book_id`
)
REFERENCES `book` (
	`book_id`
);

ALTER TABLE `shoppingcart` ADD CONSTRAINT `FK_member_TO_shoppingcart_1` FOREIGN KEY (
	`customer_id`
)
REFERENCES `member` (
	`customer_id`
);

ALTER TABLE `shoppingcart` ADD CONSTRAINT `FK_book_TO_shoppingcart_1` FOREIGN KEY (
	`book_id`
)
REFERENCES `book` (
	`book_id`
);

ALTER TABLE `point_order` ADD CONSTRAINT `FK_point_history_TO_point_order_1` FOREIGN KEY (
	`point_history_id`
)
REFERENCES `point_history` (
	`point_history_id`
);

ALTER TABLE `order_to_status_mapping` ADD CONSTRAINT `FK_order_TO_order_to_status_mapping_1` FOREIGN KEY (
	`order_id`
)
REFERENCES `order` (
	`order_id`
);

ALTER TABLE `order_to_status_mapping` ADD CONSTRAINT `FK_order_status_TO_order_to_status_mapping_1` FOREIGN KEY (
	`order_status_id`
)
REFERENCES `order_status` (
	`order_status_id`
);

ALTER TABLE `category_coupon` ADD CONSTRAINT `FK_coupon_TO_category_coupon_1` FOREIGN KEY (
	`coupon_id`
)
REFERENCES `coupon` (
	`coupon_id`
);

ALTER TABLE `book_coupon` ADD CONSTRAINT `FK_coupon_TO_book_coupon_1` FOREIGN KEY (
	`coupon_id`
)
REFERENCES `coupon` (
	`coupon_id`
);

ALTER TABLE `point_review` ADD CONSTRAINT `FK_point_history_TO_point_review_1` FOREIGN KEY (
	`point_history_id`
)
REFERENCES `point_history` (
	`point_history_id`
);

ALTER TABLE `point_refund` ADD CONSTRAINT `FK_point_history_TO_point_refund_1` FOREIGN KEY (
	`point_history_id`
)
REFERENCES `point_history` (
	`point_history_id`
);

