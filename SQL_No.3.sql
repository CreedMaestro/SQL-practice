/*
-- JOIN(INNER JOIN) : ON 절의 조건을 만족하는 데이터만을 가져옴(서로 공통된 부분만 가져와 출력)
-- LEFT JOIN : 왼쪽 테이블의 데이터를 유지한 채 오른쪽 테이블의 데이터를 가져오는 JOIN
-- RIGHT JOIN : 오른쪽 테이블의 데이터를 유지한 채 왼쪽 테이블의 데이터를 가져오는 JOIN
*/

USE member;

-- bookstore, customer 테이블 조인(JOIN 구문 사용)
-- price Null값 20311.1111로 변경후 고객별 평균구매금액, 최고금액, 구매 도서개수 추출

SELECT C.name
		,ROUND(AVG(IF(B.price IS NULL, 20311.1111, B.price)),0) AS avg_price
		,MAX(IFNULL(B.price,20311.1111)) AS max_price
        ,COUNT(B.name) AS book_cnt
FROM bookstore AS B 
JOIN customer AS C
ON B.member_id = C.id
GROUP BY 1
ORDER BY 3 DESC;

SELECT B.id
		, B.name
        , B.price
        , C.name
        , C.gender
FROM bookstore AS B
JOIN customer AS C
ON B.member_id = C.id
ORDER BY B.id ;

SELECT C.name
		,SUM(price) AS sum_price
FROM bookstore AS B
JOIN customer AS C
ON B.member_id = C.id
GROUP BY 1
ORDER BY 1 ;

-- WHERE과 비교연산자 사용하여 JOIN

SELECT *
FROM bookstore AS B, customer AS C
WHERE B.member_id = C.id;

-- 고객이 구매한 도서명과 가격을 가장 높은 금액 순서로 정렬

SELECT B.name, B.price
FROM bookstore AS B
JOIN customer AS C
ON B.member_id = C.id
ORDER BY 2 DESC;

-- 고객별 도서권수와 도서구매금액 합계를 구하고 가장 높은 금액 순서로 정렬

SELECT C.name AS '고객명'
	, SUM(B.price) AS '도서구매금액'
    , COUNT(B.name) AS '도서권수'
FROM bookstore AS B
JOIN customer AS C
ON B.member_id= C.id
Group BY C.name
ORDER BY 2 DESC;

-- 고객이 구매한 도서 중 출판일이 가장 높은것들 고객별로 확인(출판일이 높은 고객순으로 정렬)

SELECT C.name AS '고객명'
	, B.name AS '도서명'
	, MAX(B.publish_date) AS '출판일'
FROM bookstore AS B
JOIN customer AS C
ON B.member_id = C.id
GROUP BY c.name
ORDER BY 3 DESC;


-- 도서 구매 기록이 있는 데이터 기준 전체 도서와 고객의 수 (bookstore, customer 매칭 기준)

SELECT COUNT(B.name) AS '도서 수'
	, COUNT(DISTINCT C.name) AS '고객 수'
FROM bookstore AS B
JOIN customer AS C
ON B.member_id = C.id;

-- 도서 전체 리스트 기준 전체 도서와 고객의 수 (bookstore기준)

SELECT COUNT(B.name) AS '도서 수'
	, COUNT(DISTINCT C.name) AS '고객 수'
FROM bookstore AS B
LEFT JOIN customer AS C
ON B.member_id = C.id;


SELECT *
FROM bookstore AS B
LEFT JOIN customer AS C
ON B.member_id = C.id;

SELECT *
FROM bookstore AS B
LEFT JOIN customer AS C
ON B.member_id = C.id;

-- 고객이 구매한 도서 중 가격이 없는 것 확인 후 리스트 요청
-- 전체 도서 가격 추출 NULL값 채우기 : 아몬드(양장)의 정가는 12000 (컬럼명 bookprice로 설정)
-- 고객의 이름이 없으면 가격은 NULL, 가격이 0이면 NULL로 저장 (컬럼명 customer_bookprice로 설정)

SELECT B.name AS book_name
	,C.name AS customer_name
	,if(B.name = '아몬드(양장)', 12000, price) AS bookprice
    ,C.name, B.price
    , CASE WHEN C.name is null THEN NULL
			WHEN price = 0 THEN NULL
            ELSE price
    END AS customer_bookprice
FROM bookstore AS B
LEFT JOIN customer AS C
ON B.member_id = C.id;

-- bookprice의 평균, customer_bookprice의 평균 구하기

SELECT B.name AS book_name
	,C.name AS customer_name
	,AVG(if(B.name = '아몬드(양장)', 12000, price)) AS avg_bookprice
    ,AVG(CASE WHEN C.name is null THEN NULL
			WHEN price = 0 THEN NULL
            ELSE price
    END) AS avg_customer_bookprice
FROM bookstore AS B
LEFT JOIN customer AS C
ON B.member_id = C.id;

/* WITH으로 임시테이블 만들기
(bookstore테이블) 도서의 금액이 20000이상인 데이터를 B라는 임시테이블로 구성하기
*/

WITH B AS (
	SELECT id, name, author, price
	FROM bookstore
	WHERE price >= 20000
)

SELECT *
FROM B;

WITH B AS (
	SELECT B.name AS book_name
		,C.name AS customer_name
		,AVG(if(B.name = '아몬드(양장)', 12000, price)) AS bookprice
		,CASE WHEN C.name is null THEN NULL
				WHEN price = 0 THEN NULL
				ELSE price
		END AS customer_bookprice
	FROM bookstore AS B
	LEFT JOIN customer AS C
	ON B.member_id = C.id
)

SELECT AVG(bookprice) AS avg_bookprice
	,AVG(customer_bookprice) AS avg_customerbookprice
FROM B;

/* 
VIEW : 가상의 테이블 → 데이터는 없고 SQL만 저장된 것
-- 뷰 생성 : CREATE VIEW 뷰이름 AS SELECT 구문;
-- 뷰 삭제 : DROP VIEW 뷰이름;
*/

-- 남성 고객의 이름, 이메일만 보여주는 뷰 생성 (customer_vw)


SELECT *
FROM customer;

CREATE VIEW customer_vw AS (
	SELECT name, email_address
    FROM customer
    WHERE gender='M'
    );
    

-- 생성한 뷰 확인(customer_vw) 

SELECT *
FROM customer_vw;

--  구매자, 도서명, 도서가격에 대한 정보를 뷰로 만들어주세요.(customer_vw -> bookinfo_vw)

  CREATE VIEW bookinfo_vw AS 
	SELECT C.name AS '구매자'
		, B.name '도서명'
		, IFNULL(B.price,12000) AS '도서가격'
    FROM customer AS C
    JOIN bookstore AS B
    ON c.id = B.member_id;
    
  

 -- 생성한 뷰 확인(bookinfo_vw) 

  SELECT *
  FROM bookinfo_vw;
  
  DROP VIEW customer_vw, bookinfo_vw;

/*
SUBQUERY : 하나의 쿼리문 안에 포함되어 있는 또다른 쿼리문 
SELECT *
FROM 테이블명
WHERE 조건절 = (SELECT *
			  FROM 테이블명);
*/


-- 평균금액보다 비싼 도서 확인(도서명, 가격) 

SELECT name AS '도서명', price AS '도서가격'
FROM bookstore
WHERE price > (SELECT ROUND(AVG(price),0) FROM bookstore);


-- Madrid에 거주하는 고객들의 주문번호 확인(서브쿼리 사용)
USE classicmodels;

SELECT orderNumber
FROM orders
WHERE customerNumber IN (SELECT customerNumber
							FROM customers
                            WHERE city = 'Madrid');

-- Madrid에 거주하는 고객들의 주문번호 확인(JOIN 사용)

SELECT O.orderNumber
FROM customers AS C
JOIN orders AS O
ON C.customerNumber = O.customerNumber
WHERE city = 'Madrid';

-- 고객별 마지막 제품 구매일자가 현재일 기준 며칠 소요되었는지 확인 (현재일  2005-06-01로 가정)

SELECT C.customerNumber
	, max(orderdate)
	, '2005-06-01'
    , datediff('2005-06-01',MAX(orderdate)) AS '소요기간'
FROM customers AS C
JOIN orders AS O
ON C.customerNumber = O.customerNumber
GROUP BY C.customerNumber;

SELECT *
	, '2005-06-01'
    , datediff('2005-06-01', max_date) AS '소요기간'
FROM (SELECT customerNumber
			,MAX(orderDate) AS 'max_date'
		FROM orders
        GROUP BY customerNumber) AS O;
-- FROM 서브 쿼리 이용시 반드시 AS 사용. 미사용시 에러

WITH O AS (
		SELECT customerNumber
			,MAX(orderDate) AS 'max_date'
		FROM orders
        GROUP BY 1
)
-- 에러. 확인 필요

-- 고객의 도서 구매 중 가장 최소금액인 것 

SELECT C.name
		, MIN(B.price) AS min_price
FROM member.bookstore AS B
JOIN member.customer AS C
ON B.member_id = C.id
GROUP BY 1;

/*
RANK OVER([PARTITION BY 컬럼명] ORDER BY 컬럼명) 
RANK() : 동점인 경우 같은 등수로 계산 
DENSE_RANK() : 동점인 경우 같은 등수로 계산 
ROW_NUMBER() : 동점인 경우에도 서로 다른 등수로 계산
*/

-- 도서의 가격에 대한 순위 확인 (가격이 낮은순서로 정렬, 가격이 없는 데이터 제거)
USE member;

SELECT name
		,price
        ,RANK() OVER(ORDER BY price) AS rn
        ,DENSE_RANK() OVER(ORDER BY price) AS dense_rn
        ,ROW_NUMBER() OVER(ORDER BY price, name) AS row_num
FROM bookstore
WHERE price IS NOT NULL;

-- 데이터 추가 삽입
INSERT INTO bookstore (name, author, price, publish_date, publisher, member_id)
VALUES ('대변동:위기,선택,변화', '재레드다이아몬드', 24800, '2019-06-10', '김영사', 3),
('날마다 구름 한 점', '개빈프레터피니', 22000, '2021-01-08','김영사' , 2);

SELECT *
FROM bookstore;

-- 출판사 별 도서의 가격에 대한 순위 확인 (가격이 낮은순서로 정렬, 출판사가 없는 데이터 제거)

SELECT publisher
		,RANK() OVER(partition by publisher order by price ASC) AS rn
        ,dense_rank() OVER(partition by publisher order by price ASC) AS dense_rn
        ,row_number() OVER(partition by publisher order by price ASC) AS row_num
FROM bookstore
WHERE publisher IS NOT NULL;

-- PARTITION BY 그룹내 순위 측정 사용 함수

-- 판매가격이 30달러 이상인 제품 중 판매가격 별 순위 확인(ROW_NUMBER, RANK, DENSE_RANK) - classicmodels.products




-- 제품라인별 판매가격에 대한 순위 확인(내림차순으로 순위 지정) - classicmodels.products



/*날짜함수
CURRENT_DATE() : 현재 날짜 추출
DAYNAME() : 요일 추출
ADD_DATE() / DATE_ADD() : 지정한 날짜를 증가하여 추출
SUB_DATE() / DATE_SUB() : 지정한 날짜를 감소하여 추출
DATE() : ‘YYYY-MM-DD’ 형식으로 변경
EXTRACT(형식 FROM 컬럼명) : 지정한 형태로 추출 (YEAR / MONTH / DAY / QUARTER / YEAR_MONTH / DAY_MINUTE 등)
DATEDIFF(날짜1, 날짜2) : 날짜1 - 날짜2
DAY(날짜) / DAYOFMONTH(날짜) : 지정한 컬럼의 Day 추출
DAYOFWEEK(날짜) : 지정한 컬럼의 Week 추출
DAYOFYEAR(날짜) : 지정한 컬럼의 Year 추출
*/
SELECT DAYNAME(CURRENT_DATE());
SELECT ADDDATE('2021-04-21', INTERVAL 1 MONTH);
SELECT ADDDATE('2021-04-21', 31);
SELECT DATE_ADD('2021-04-21', INTERVAL 31 DAY);
SELECT SUBDATE('2021-04-21', INTERVAL 1 MONTH);
SELECT SUBDATE('2021-04-21', 31);
SELECT DATE_SUB('2021-04-21', INTERVAL 31 DAY);
SELECT DATE('2021-04-21 14:32:03');
SELECT EXTRACT(YEAR FROM '2021-04-21 14:32:03');
SELECT EXTRACT(YEAR_MONTH FROM '2021-04-21 14:32:03');
SELECT EXTRACT(DAY_MINUTE FROM '2021-04-21 14:32:03');
SELECT EXTRACT(WEEK FROM '2021-04-21 14:32:03');
SELECT EXTRACT(QUARTER FROM '2021-04-21 14:32:03');
SELECT EXTRACT(DAY_HOUR FROM '2021-04-21 14:32:03');
SELECT DATEDIFF('2021-04-21', '2021-04-11');
SELECT DAYOFMONTH('2021-04-21');
SELECT DAYOFWEEK('2021-04-21');
SELECT DAYOFYEAR('2021-04-21');
SELECT SUBSTR('SUBSTR사용하기', 6, 3);
SELECT SUBSTR('SUBSTR사용하기', 6);
SELECT SUBSTR('SUBSTR사용하기', -4, 2);
SELECT CONCAT('CONCAT', ' ', 123);
SELECT CONCAT('CONCAT', NULL, '사용하기');
SELECT CONCAT_WS(NULL, 'CONCAT', '사용하기');
SELECT REVERSE('REVERSE 함수 사용하기');
SELECT LOWER('Lower 함수 사용하기');
SELECT UPPER('Upper 함수 사용하기');
SELECT TRIM('    TRIM 함수 사용하기     ');
SELECT TRIM(BOTH 'oo' FROM 'oooTRIM 함수 사용하기ooo');
SELECT LTRIM('    LTRIM 함수 사용하기    ');
SELECT TRIM(LEADING FROM '    TRIM 함수 사용하기    ');
SELECT RTRIM('    RTRIM 함수 사용하기    ');
SELECT TRIM(TRAILING FROM '    TRIM 함수 사용하기    ');
SELECT LEFT('LEFT 함수 사용하기', 4);
SELECT RIGHT('RIGHT 함수 사용하기', 4);
SELECT LENGTH('length function');
SELECT LPAD('LPAD', 6, '*');
SELECT LPAD('LPAD', 3, '*');
SELECT RPAD('RPAD', 6, '*');

-- 월별 주문건수 확인 


-- 현재일 기준 도서가 출판된지 얼마나 지났는지, 도서 출판일의 분기 확인(출판일자가 없는 데이터 제거)



-- 응용) 위 쿼리를 뷰로 만들기 (bookstore_datediff_vw)
CREATE VIEW bookstore_datediff_vw AS 
SELECT current_date() AS date_current
			, publish_date
            , DATEDIFF(current_date(),publish_date) AS date_diff
            , quarter(publish_date) AS quarter
FROM member.bookstore
WHERE publish_date IS NOT NULL;