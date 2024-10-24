테이블 drop 시 참조관계로 인해 제거가 되지 않으면
제약조건 제거용.sql 을 코드 맨 위에 두고 제약 조건을 먼저 제거해주세요.


예시 오류)
13:42:09	DROP TABLE IF EXISTS payment_type	
Error Code: 3730. Cannot drop table 'payment_type' referenced
 by a foreign key constraint 'FK_payment_type_TO_payment' on table 'payment'.	0.000 sec