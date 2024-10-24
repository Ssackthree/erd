테이블 drop 시 참조관계로 인해 제거가 되지 않으면
제약조건 제거용.sql 을 코드 맨 위에 두고 제약 조건을 먼저 제거해주세요.


예시 오류)
13:42:09	DROP TABLE IF EXISTS payment_type	
Error Code: 3730. Cannot drop table 'payment_type' referenced
 by a foreign key constraint 'FK_payment_type_TO_payment' on table 'payment'.	0.000 sec


24.10.24 / PM 14:00
payment 테이블이 참조 중인 payment_type_id와 payment_type의 payment_type_id 타입이 일치하지 않는 것을 수정하였습니다. => bigint
delivery 테이블이 참조 중인 delivery_rule_id와 delivery_rule 테이블의 delivery_rule_id의 데이터 타입이 일치하지 않는 것을 수정하였습니다. => bigint
