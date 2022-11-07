/* 
-- 데이터베이스 생성
CREATE DATABASE 데이터베이스명;

-- 어떤 데이터베이스를 사용할 것인지 선언 
USE 데이터베이스명; 

-- 데이터베이스 목록 조회
SHOW databases; 

-- 테이블 생성 
CREATE TABEL 테이블명 (
    컬럼명 데이터타입 제약조건
    컬럼명 데이터타입 제약조건
    컬럼명 데이터타입 제약조건
);
*/

-- [Quiz]
-- member라는 데이터베이스 생성하기 
CREATE DATABASE member;




-- member 데이터베이스 사용 선언
USE member;

-- 데이터베이스 목록조회하기
SHOW DATABASES;

-- customer 테이블 생성하기
-- 컬럼명 : id , name, email, gender
-- id는 숫자로 구성, 데이터가 추가될 때마다 자동으로 1개씩 증가
-- name, email은 문자열로 구성되어 있으며 필수값
-- gender는 집합안에 요소를 선택할 수 있도록 구성 (ex. ’M’, ‘F’)
-- PRIMARY KEY(PK)는 id

CREATE TABLE customer (
	id int auto_increment primary key,
	name varchar(20) not null,
	email varchar(30) not null,
	gender enum('M','F')
);

-----------------------------------------------------
DESC customer;


/*
-- 테이블 조회
DESC 테이블;

-- 현재 데이터베이스의 모든 테이블 조회 
SHOW tables;

-- 컬럼 추가 
ALTER TABLE 테이블명 
ADD 컬럼명 데이터타입;

-- 컬럼 타입 수정 
ALTER TABLE 테이블명 
MODIFY 컬럼명 데이터타입;

-- 컬럼명 수정
ALTER TABLE 테이블명 
CHANGE 기존컬럼명 변경할컬럼명 (데이터타입);

-- 컬럼 삭제
ALTER TABLE 테이블명 
DROP COLUMN 컬럼명;
*/

-- [Quiz]
-- customer 테이블에 birthday 컬럼 추가하기 *(날짜 타입으로 구성)
ALTER TABLE customer
ADD birthday date;

DESC customer;
-- enum 타입이었던 gender컬럼을 char로 변경 *(길이는 1로 설정)
ALTER TABLE customer
MODIFY gender char(1);

-- email 컬럼을 email_address으로 변경하기 *(text 타입으로 변경)

ALTER TABLE customer
CHANGE email email_address text;

-- birthday 컬럼 삭제하기
ALTER TABLE customer
DROP COLUMN birthday;

DESC customer;


---------------------------------------------------

/* 
-- 데이터베이스 삭제
DROP DATABASE 데이터베이스명;

-- 테이블 삭제
DROP TABLE 테이블명;

-- 테이블 초기화
TRUNCATE TABLE 테이블명;

*/

-- [Quiz]
-- member 데이터베이스 삭제
DROP database member;

-- customer 테이블 삭제
DROP tables customer;


---------------------------------------------------


/* 
-- 컬럼 조회
SELECT *
FROM 테이블명;


-- 행 삽입
INSERT INTO 테이블명 (컬럼1, 컬럼2, 컬럼3, … ) 
VALUES(데이터 값1,'데이터 값2, 데이터 값3, … );

INSERT INTO 테이블명 
VALUES(데이터 값1,'데이터 값2, 데이터 값3, … );
데이터 값을 생략할 수 있는 필드
- NULL 저장 가능 컬럼 
- DEFAULT 제약 조건이 설정된 컬럼
- AUTO_INCREMENT 키워드가 설정된 컬럼


-- 테이블의 컬럼 값 수정
UPDATE 테이블명 
SET 컬럼명 = 변경할내용 
[WHERE 조건];


-- DELETE 문을 사용하여 테이블의 행 삭제
DELETE FROM 테이블명 
[WHERE 조건절];

*/

SELECT *
FROM customer;

-- [Quiz]
-- 컬럼에 맞춰 데이터 삽입 하기 *(기존 컬럼 id, name, email_address, gender)

INSERT INTO customer (id, name, email, gender)
VALUES(1, 'ironman', 'ironman@avengers.com', 'M'),
(2, 'captain', 'captain@avengers.com', 'M'),
(3, 'blackwidow', 'blackwidow@avengers.com', 'F'),
(4, 'thor', 'tor@avengers.com', 'M')



-- 이름이 ‘thor’인 고객의 이메일 수정하기

UPDATE customer
SET email = 'thor@avengers.com'
WHERE name = 'thor'

-- 이름이 'captain' 고객의 데이터 삭제하기

DELETE *
FROM customer
where name = 'captain';



-- 전체데이터 삭제(테이블은 유지)



-- 데이터생성 쿼리 실행하여 데이터 적재 후 추가 진행

SELECT *
FROM bookstore;

SELECT name, price
FROM bookstore;

/*
-- 데이터 필터링
SELECT 컬럼명
FROM 테이블명
[WHERE 조건절]


-- 비교 연산자
 A = 'value' : A와 'value’는 같다
 A !=(<>) 'value’ : A와 'value’는 같지않다
 A > n : A가 n보다 크다
 A >= n	: A가 n보다 크거나 같다
 A < n : A가 n보다 작다
 A <= n	: A가 n보다 작거나 같다
*/

-- [Quiz]
-- bookstore 테이블 전체 조회

SELECT *
FROM bookstore;

-- bookstore 테이블 name, price 조회
SELECT name, price
FROM bookstore;

-- name이 thor인 고객의정보 확인(customer테이블)
SELECT *
FROM customer
WHERE name ='thor';

-- name이 Thor인 고객의정보 확인(customer테이블)



-- 출판사가 김영사인 책 제목 조회

SELECT *
FROM bookstore
WHERE publisher = '김영사';


-- 유발하라리가 쓴 책이 아닌 도서 목록 추출

SELECT *
FROM bookstore
WHERE author!='유발하라리';


-- 가격이 20000원 이상인 도서 목록 추출
SELECT *
FROM bookstore
WHERE price>=20000;



-- 출판일이 2019년 이전인 도서 목록 추출

SELECT *
FROM bookstore
WHERE publish_date<='2019-01-01';


-----------------------------------------------------


/* 
-- 논리연산자
 AND : 앞의 조건과 뒤의 조건을 둘 다 만족해야 참 
 OR : 앞의 조건이나 뒤의 조건 중 하나라도 만족해야 참 
 LIKE : 조회 조건의 값이 명확하지 않을 때, 유사한 값을 찾으려 할 때 사용
 BETWEEN A AND B : 최소값과 최대값을 지정한 값의 범위 내에 있는 값들을 검색하기 위해 사용
 IS NULL : 해당 값을 NULL 값과 비교할 때 사용
 IN : 여러개 값 리스트중 하나의 값이라도 만족하는 해당 결과를 출력할 때 사용
 NOT : 논리 연산자의 의미를 반전시킴 
*/



-- 출판사가 김영사이고 정가 2만원 이상의 도서 목록 추출
SELECT *
FROM bookstore
WHERE publisher = '김영사' and price >=20000;

-- 김영사 출판사 도서 중 유발하라리가 출판한 도서의 이름과 가격 
SELECT name, price
FROM bookstore
WHERE publisher = '김영사' and author = '유발하라리';

-- 출판사가 김영사거나 정가 2만원 이상의 도서 목록 추출
 SELECT *
 FROM bookstore
 WHERE publisher = '김영사' or price >=20000;

-- 작가의 이름이 마이클로 시작하는 책 제목, 작가 이름 추출

SELECT name, author
FROM bookstore
WHERE author LIKE '마이클%'

-- 작가의 이름이 마이클로 시작하고 총 길이가 5인 작가 이름 추출
SELECT name, author, length(author)
FROM bookstore
WHERE author LIKE '마이클%'
AND length(author) 

-- 2017년 ~ 2019년 사이에 발간된 도서 목록 추출(Between 사용)
SELECT *
FROM bookstore
WHERE publish_date between '2017-01-01' and '2019-12-31';



-- 2017년 ~ 2019년 사이에 발간된 도서 목록 추출(AND 사용)
SELECT *
FROM bookstore
WHERE publish_date >='2017-01-01' 
and publish_date <='2019-12-31';


-- 출판사가 지정되지않아 알 수 없는 값이 있는지 확인(NULL 체크)
SELECT *
FROM bookstore
WHERE publisher is NULL

-- 출판사를 알 수 있는 도서 목록 추출
SELECT *
FROM bookstore
WHERE publisher is NOT NULL

-- 금액이 없는 것을 수정해야되는 상황

SELECT *
FROM bookstore
WHERE price IS NULL;

-- 작가가 유발하라리, 한스로슬링인 도서 목록 추출

SELECT *
FROM bookstore
WHERE author IN ('유발하라리', '한스로슬링');

-- 작가가 유발하라리, 한스로슬링이 아니고 2만원 이하 도서 목록 추출

SELECT *
FROM bookstore
WHERE author NOT IN ('유발하라리', '한스로슬링');
AND price <=20000;


/*
-- 산술연산자 : +, -, *, /
우선순위 () > *, / > +, -



-- AS(Alias)
SELECT 컬럼명 AS 별칭



-- Wildcard
% : 조건을 포함하는 모든 문자를 의미(0개 이상의 문자)
_ :  1개의 문자를 의미
%와 _ 자체를 검색하고 싶은 경우 : \(역슬래시)와 함께 사용



-- ORDER BY
SELECT 컬럼명
FROM 테이블명
[WHERE 조건절]
[ORDER BY 컬럼명]

오름차순 : ORDER BY 컬럼명 DESC;
내림차순 : ORDER BY 컬럼명 (ASC);

*/


-- 도서 가격이 1.2배 상승 예정(도서명, 정가, 상승가)

SELECT name AS '도서명',
		price AS '정가',
        price*1.2 AS '상승가'
FROM member.bookstore
WHERE price IS NOT NULL;
        


-- 출판일이 2일씩 지연되었다고 가정(도서명, 출판일, 지연 출판일)

SELECT name,
		publish_date,
        publish_date+2
FROM bookstore
WHERE publish_date;

-- 지연출판일에 대해 late_publish_date로 별칭 부여, 출판일이 없는 데이터 제거

SELECT name,
		publish_date,
        publish_date+2 AS 'late_publish_date'
FROM bookstore
WHERE publish_date IS NOT NULL;


-- 출판일이 10일 지연되었다고 가정 (날짜함수에 산술연산자를 사용하게되면 타입이 달라짐)

SELECT name,
		publish_date,
        publish_date+10
FROM bookstore
WHERE publish_date;

-- 2021년에 출판된 도서에 대해 name을 #2021*bookname으로 별칭 부여

SELECT name AS '#2021*bookname'
FROM bookstore
WHERE publish_date between '2021-01-01' and '2021-12-31';

-- 도서 제목 중 _가 포함된 도서 목록 조회

SELECT *
FROM bookstore
WHERE name LIKE '%\_%';

-- 2018년 이후 도서 중 가격이 만원 이상이고 출판사가 김영사, 한빛미디어인 데이터 추출(도서명, 출판사, 가격)

SELECT name, publisher, price
FROM bookstore
WHERE publish_date >= '2018-01-01' 
AND price >= '10000' 
AND publisher IN ('김영사', '한빛미디어');


-- 가격이 높은 순으로 정렬

SELECT *
FROM bookstore
order by price DESC ;

-- 김영사에서 출판된 도서 중 출판일 순서대로 출력

SELECT *
FROM bookstore
WHERE publisher = '김영사'
ORDER BY publish_date;