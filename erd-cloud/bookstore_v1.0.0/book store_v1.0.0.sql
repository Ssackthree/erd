CREATE TABLE `book` (
	`book_id`	bigint	NOT NULL,
	`publisher_id`	int	NOT NULL,
	`book_name`	varchar(255)	NOT NULL,
	`book_index`	varchar(255)	NOT NULL,
	`book_info`	text	NOT NULL,
	`book_isbn`	varchar(20)	NOT NULL,
	`publication_date`	timestamp	NOT NULL,
	`regular_price`	int	NOT NULL,
	`sale_price`	int	NOT NULL,
	`is_packed`	boolean	NOT NULL,
	`stock`	int	NOT NULL,
	`detail_img`	text	NULL
);

CREATE TABLE `member` (
	`customer_id`	bigint	NOT NULL,
	`member_login_id`	varchar(20)	NOT NULL,
	`member_password`	varchar(255)	NOT NULL,
	`member_birth`	varchar(8)	NOT NULL,
	`member_created_at`	timestamp	NOT NULL,
	`member_last_login_at`	timestamp	NULL,
	`member_status`	enum()	NOT NULL	COMMENT '활성, 휴먼, 탈퇴',
	`is_admin`	boolean	NOT NULL,
	`point`	int	NOT NULL	DEFAULT 0,
	`member_grade_id`	int	NOT NULL
);

CREATE TABLE `review` (
	`review_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`score`	int	NOT NULL,
	`review_created_at`	timestamp	NOT NULL,
	`review_contetn`	text	NOT NULL
);

CREATE TABLE `shoppingcart` (
	`shoppingcart_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL
);

CREATE TABLE `member_coupon` (
	`member_coupon_id`	int	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`coupon_id`	bigint	NOT NULL,
	`coupon_created_at`	timestamp	NOT NULL,
	`coupon_expired_at`	timestamp	NOT NULL,
	`coupon_is_used`	boolean	NOT NULL,
	`coupon_ussed_at`	timestamp	NOT NULL
);

CREATE TABLE `point_detail` (
	`point_id`	bigint	NOT NULL,
	`point_save_rule_id`	bigint	NULL,
	`customer_id`	bigint	NOT NULL,
	`point_amount`	int	NOT NULL,
	`point_change_date`	timestamp	NOT NULL,
	`point_change_reason`	varchar(50)	NOT NULL
);

CREATE TABLE `order` (
	`order_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL,
	`point_id`	bigint	NOT NULL,
	`ordered_date`	timestamp	NOT NULL
);

CREATE TABLE `category` (
	`category_id`	int	NOT NULL,
	`category_name`	varchar(20)	NOT NULL,
	`super_category_id`	bigint	NULL
);

CREATE TABLE `book_category` (
	`book_category_id`	bigint	NOT NULL,
	`category_id`	int	NOT NULL,
	`book_id`	bigint	NOT NULL
);

CREATE TABLE `author` (
	`author_id`	bigint	NOT NULL,
	`author_name`	varchar(20)	NOT NULL,
	`author_info`	varchar(255)	NOT NULL
);

CREATE TABLE `publisher` (
	`publisher_id`	int	NOT NULL,
	`publisher_name`	varchar(30)	NOT NULL
);

CREATE TABLE `Tag` (
	`tag_id`	int	NOT NULL,
	`tag_name`	varchar(30)	NOT NULL
);

CREATE TABLE `book_tag` (
	`book_tag_id`	int	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`tag_id2`	int	NOT NULL
);

CREATE TABLE `like` (
	`like_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`customer_id`	bigint	NOT NULL
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
	`order_book_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`coupon_id`	bigint	NULL,
	`book_id`	bigint	NOT NULL,
	`quantity`	int	NOT NULL,
	`bookprice_at_order`	int	NOT NULL	COMMENT '도서의 판매가가 변경 될 수 있으므로, 해당 주문 시 도서 가격을 저장함.(기록용)'
);

CREATE TABLE `order_status` (
	`order_status_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`order_status_name`	enum('pending', 'in_shipping', 'completed', 'returned', 'canceled')	NOT NULL	DEFAULT pending	COMMENT '대기 , 배송중, 완료, 반품, 주문취소',
	`order_status_created_at`	timestamp	NOT NULL
);

CREATE TABLE `delivery_rule` (
	`delivery_rule`	int	NOT NULL,
	`delivery_rule_name`	varchar(30)	NOT NULL,
	`delivery_fee`	int	NOT NULL,
	`delivery_discount_cost`	int	NULL	COMMENT 'ex) 3만원 이상 무료배송',
	`delivery_rule_is_selected`	boolean	NOT NULL	COMMENT '현재 사용중인  배송 정책 판단',
	`delivery_rule_created_at`	timestamp	NOT NULL
);

CREATE TABLE `packaging` (
	`packaging_id`	bigint	NOT NULL,
	`packaging_name`	varchar(20)	NOT NULL,
	`packaging_price`	int	NOT NULL
);

CREATE TABLE `refund` (
	`refund_id`	bigint	NOT NULL,
	`order_book_id`	bigint	NOT NULL,
	`refund_quantity`	int	NOT NULL,
	`refund_reason`	enum()	NOT NULL,
	`refund_price`	int	NOT NULL
);

CREATE TABLE `order_detail_packaging` (
	`order_detail_packaging`	bigint	NOT NULL,
	`oder_book_id`	bigint	NOT NULL,
	`packaging_id`	bigint	NOT NULL,
	`packaging_quantity`	int	NOT NULL
);

CREATE TABLE `shoppingcart_detail` (
	`shoppingcart_detail_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`shoppingcart_id`	bigint	NOT NULL,
	`book_quantitty`	int	NOT NULL
);

CREATE TABLE `point_save_rule` (
	`point_save_rule_id`	bigint	NOT NULL,
	`point_save_rule_name`	varchar(30)	NOT NULL,
	`point_save_amount`	int	NOT NULL	DEFAULT 0	COMMENT '각 정책에 따른 포인트 적립량',
	`point_save_rule_generate_date`	timestamp	NULL,
	`point_save_rule_is_selected`	boolean	NOT NULL,
	`point_save_type`	enum()	NOT NULL	COMMENT '퍼센트, 정수'
);

CREATE TABLE `coupon` (
	`coupon_id`	bigint	NOT NULL,
	`coupon_name`	varchar(30)	NOT NULL,
	`coupon_description`	text	NOT NULL,
	`coupon_min_order_price`	int	NOT NULL,
	`max_discount_price`	int	NOT NULL,
	`coupon_discount_price`	int	NOT NULL	COMMENT '얼마나 할인 해줄 지',
	`coupon_type`	enum()	NOT NULL	COMMENT '퍼센트, 금액',
	`coupon_effective_period`	int	NOT NULL,
	`coupon_effective_period_unit`	enum()	NOT NULL	COMMENT '단위 : 일.월,년',
	`book_id`	bigint	NULL,
	`category_id`	int	NULL
);

CREATE TABLE `payment` (
	`payment_id`	bigint	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`payment_created_at`	timestamp	NOT NULL,
	`payment_amount`	int	NOT NULL,
	`payment_type`	enum()	NOT NULL,
	`payment_key`	varchar(200)	NULL,
	`payment_type_id`	int	NOT NULL
);

CREATE TABLE `delivery` (
	`delivery_id`	bigint	NOT NULL,
	`delivery_rule`	int	NOT NULL,
	`order_id`	bigint	NOT NULL,
	`delivery_set_date`	timestamp	NULL,
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

CREATE TABLE `review_image` (
	`review_image_id`	bigint	NOT NULL,
	`review_image_url`	text	NULL,
	`review_id`	bigint	NOT NULL
);

CREATE TABLE `book_thumbnail_image` (
	`book_thumbnail_image_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`book_thumbnail_image_url`	text	NULL
);

CREATE TABLE `book_detail_image` (
	`book_detail_image_id`	bigint	NOT NULL,
	`book_id`	bigint	NOT NULL,
	`book_detail_image`	text	NULL
);

CREATE TABLE `member_grade` (
	`member_grade_id`	int	NOT NULL,
	`member_grade_name`	varchar(20)	NOT NULL
);

CREATE TABLE `payment_type` (
	`payment_type_id`	int	NOT NULL,
	`payment_type_name`	varchar(30)	NOT NULL
);

ALTER TABLE `book` ADD CONSTRAINT `PK_BOOK` PRIMARY KEY (
	`book_id`
);

ALTER TABLE `member` ADD CONSTRAINT `PK_MEMBER` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `review` ADD CONSTRAINT `PK_REVIEW` PRIMARY KEY (
	`review_id`
);

ALTER TABLE `shoppingcart` ADD CONSTRAINT `PK_SHOPPINGCART` PRIMARY KEY (
	`shoppingcart_id`
);

ALTER TABLE `member_coupon` ADD CONSTRAINT `PK_MEMBER_COUPON` PRIMARY KEY (
	`member_coupon_id`
);

ALTER TABLE `point_detail` ADD CONSTRAINT `PK_POINT_DETAIL` PRIMARY KEY (
	`point_id`
);

ALTER TABLE `order` ADD CONSTRAINT `PK_ORDER` PRIMARY KEY (
	`order_id`
);

ALTER TABLE `category` ADD CONSTRAINT `PK_CATEGORY` PRIMARY KEY (
	`category_id`
);

ALTER TABLE `book_category` ADD CONSTRAINT `PK_BOOK_CATEGORY` PRIMARY KEY (
	`book_category_id`
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
	`book_tag_id`
);

ALTER TABLE `like` ADD CONSTRAINT `PK_LIKE` PRIMARY KEY (
	`like_id`
);

ALTER TABLE `address` ADD CONSTRAINT `PK_ADDRESS` PRIMARY KEY (
	`registered_address_id`
);

ALTER TABLE `customer` ADD CONSTRAINT `PK_CUSTOMER` PRIMARY KEY (
	`customer_id`
);

ALTER TABLE `order_detail` ADD CONSTRAINT `PK_ORDER_DETAIL` PRIMARY KEY (
	`order_book_id`
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

ALTER TABLE `shoppingcart_detail` ADD CONSTRAINT `PK_SHOPPINGCART_DETAIL` PRIMARY KEY (
	`shoppingcart_detail_id`
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

ALTER TABLE `review_image` ADD CONSTRAINT `PK_REVIEW_IMAGE` PRIMARY KEY (
	`review_image_id`
);

ALTER TABLE `book_thumbnail_image` ADD CONSTRAINT `PK_BOOK_THUMBNAIL_IMAGE` PRIMARY KEY (
	`book_thumbnail_image_id`
);

ALTER TABLE `book_detail_image` ADD CONSTRAINT `PK_BOOK_DETAIL_IMAGE` PRIMARY KEY (
	`book_detail_image_id`
);

ALTER TABLE `member_grade` ADD CONSTRAINT `PK_MEMBER_GRADE` PRIMARY KEY (
	`member_grade_id`
);

ALTER TABLE `payment_type` ADD CONSTRAINT `PK_PAYMENT_TYPE` PRIMARY KEY (
	`payment_type_id`
);

ALTER TABLE `member` ADD CONSTRAINT `FK_customer_TO_member_1` FOREIGN KEY (
	`customer_id`
)
REFERENCES `customer` (
	`customer_id`
);

