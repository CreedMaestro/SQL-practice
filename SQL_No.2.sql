/*
-- DISTINCT : 중복제거
SELECT DISTINCT 컬럼명
*/

USE member;

-- bookstore 테이블에 적재되어있는 작가 리스트 확인(중복제거)

SELECT DISTINCT author
FROM bookstore;


-- bookstore 테이블에 적재되어있는 출판사와 작가가 중복되지않게 추출

SELECT DISTINCT publisher, author
FROM bookstore;

/*
IF 구문
    IF(조건, 참일 때 반환 값, 거짓일 때 반환 값)
*/


-- 정가와 세일 구분 -> 2만원이상 도서는 세일로 구분

SELECT name
		, price
        ,if(price>=20000, '세일', '정가') AS '프로모션'
FROM bookstore
WHERE price IS NOT NULL;


-- 정가와 세일 구분 -> 2만원이상 도서는 세일로 구분 후 세일인 도서 리스트 추출

SELECT name
		, price
        ,if(price>=20000, '세일', '정가') AS '프로모션'
FROM bookstore
-- WHERE if(price >=20000, '세일', '정가') = '세일';
WHERE price >=20000;


-- 책제목별로 길이가 15이면 책제목을, 그렇지않으면 0추출

SELECT name
		,length(name) AS '책제목길이'
			,if(length(name) = 15, name, 0) AS '길이15이상'
FROM bookstore;

/*
CASE ~  WHEN 구문
    CASE 
    WHEN '조건1' THEN '조건1 반환값'
    WHEN '조건2' THEN '조건2 반환값'
    ELSE '만족하는 조건이 없을 때 반환값'
    END
*/


-- 가격의 범위 지정(0~9900, 10000~19900, ...)

SELECT name, price
		, CASE WHEN price Between 0 and 9900 THEN '1만원미만'
				WHEN price between 10000 and 19900 THEN '1만원 이상 ~ 2만원 미만'
                WHEN price between 20000 and 29900 THEN '2만원 이상 ~ 3만원 미만'
                WHEN price IS NULL THEN '해당없음'
                ELSE '3만원 이상'
                END AS price
FROM bookstore;

-- WHERE price IS NOT NULL;

-- CASE WHEN 구문으로 도서명, 출판일, 출판년도 추출(publish_month라는 임시컬럼 생성)
-- 2021년 이후 출판, 2020년 출판, 2019년 출판, 2019년 이전 출판, 해당없음

SELECT name
	, publish_date
    , CASE WHEN publish_date >= '2021-01-01' THEN '2021년 이후 출판'
			WHEN publish_date >= '2020-01-01' THEN '2020년 출판'
			WHEN publish_date >= '2019-01-01' THEN '2019년 출판'
            WHEN publish_date IS NULL THEN '해당없음'
			ELSE '2019년 이전 출판'
			END '출판연도'
FROM bookstore;


/*
-- NULL데이터 처리
IFNULL(컬럼1, 변경값)
컬럼1의 값이 NULL이면 변경값을 반환,
컬럼1의 값이 NULL이 아니면 컬럼1 값 반환

COALESCE(컬럼1, 컬럼2, 컬럼3 ...)
컬럼1에 NULL이 있다면 컬럼2를, 
컬럼2에 NULL이 있다면 컬럼3을 출력
>> 전부 다 NULL이라면 NULL을 출력
*/

-- 가격이 없는 더미데이터를 제외한 도서리스트 전달 요청

SELECT *
FROM bookstore
WHERE price IS NOT NULL;

-- 가격이 없는 데이터를 전체 도서 금액의 평균으로 대체(AVG사용)

SELECT AVG(price) -- 20311.1111
FROM bookstore

SELECT name
		, price
        , ROUND(ifnull(price, 20311.1111), 0) AS '도서가격'
FROM bookstore;

-- 평균을 구한 뒤, 그 값을 가져와 대체하는 방식

SELECT name
		, ROUND(ifnull(price, (SELECT AVG(price)
								FROM bookstore)), 0) AS '도서가격'
FROM bookstore;


-- NULL값을 대체하는 부분에서 평균을 구해서 대체하는 방식(서브쿼리)



--  가격이 없는 데이터를 전체 도서 금액의 합계로 대체(SUM사용)



-- SUM함수만 ifnull에 넣게되면 어떻게 될까?


-- 그룹을 안해서 발생한 이슈면 그룹핑을 하게되면? (NULL 연산)



-- 서브쿼리 사용시


-- 출판사가 없는 경우 -로 표기되도록 추출


-- 출판사가 없으면 출판일로, 출판일이 없으면 '-'로 표기되도록 추출


/*
집계함수
COUNT(컬럼명) - NULL값을 제외한 행의 개수
SUM(컬럼명) - 지정한 컬럼명 값의 합계
AVG(컬럼명) - 지정한 컬럼명 값의 평균
MAX(컬럼명) - 지정한 컬럼명 값 중 가장 큰 값
MIN(컬럼명) - 지정한 컬럼명 값 증 가장 작은 값
*/



-- 전체 행의 개수, 출판사의 개수 추출

SELECT COUNT(id), count(publisher)
FROM bookstore;


-- 도서의 이름이 아몬드(양장)인 도서에 대해 전체 행의 개수, 출판사의 개수 추출

SELECT name, COUNT(id) AS '행의 개수', count(publisher) AS '출판사 개수'
FROM bookstore
WHERE name = '아몬드(양장)';
-- WHERE name LIKE '아몬드%';

-- 전체 도서의 가격의 합계 추출

SELECT SUM(price) AS SUM_price
FROM bookstore;

-- 테이블 내 도서의 평균 가격 추출(AVG함수 사용)

SELECT AVG(price) AS AVG_price
FROM bookstore;

-- 기준이 도서 개수의 평균가격으로 지정되어있으면?

SELECT SUM(price)/COUNT(name) AS avg_price
FROM bookstore;

-- 가장 오래된 출판일 확인

SELECT min(publish_date) AS min_pub_date
FROM bookstore;

-- 테이블 내 도서 목록 중 최고가격 추출;

SELECT MAX(price) AS MAX_price
FROM bookstore;

-- 유발하라리 작가의 도서 개수 추출(집계함수(COUNT), 조건절 사용))

SELECT count(name) AS cnt
FROM bookstore
WHERE author = '유발하라리'

-- 유발하라리, 한스로슬링 작가의 도서 개수 추출(집계함수(COUNT), 조건절 사용))

SELECT COUNT(if(author = '유발하라리', 1, NULL)) AS '유발하라리도서개수'
		,SUM(if(author = '한스로슬링', 1, 0)) AS '한스로슬링도서개수'
From bookstore;



-- 유발하라리, 한스로슬링 작가의 도서개수를 분리해주세요.(GROUP BY)

SELECT author, count(name) AS cnt
FROM bookstore
WHERE author IN ('유발하라리', '한스로슬링')
GROUP BY author;

-- 유발하라리 작가의 도서 개수 추출(집계함수(sum), 조건문 사용))

SELECT author, SUM(if(author='유발하라리', 1, 0)) AS cnt
FROM bookstore;


-- 작가가 유발하라리이거나, 출판사가 한빛미디어인 도서의 개수(CASE WHEN, SUM 시용)

SELECT author
	,CASE WHEN author = '유발하라리' THEN  '유발하라리' AS '유발하라리도서'
			WHEN publisher = '한빛미디어' THEN '한빛미디어' AS '한빛미디어 도서'
            END
FROM bookstore;

/*
-- GROUP BY : 특정 컬럼을 기준으로 그룹화
SELECT 컬럼명, 집계함수
FROM 테이블명
[WHERE 조건식]
GROUP BY 그룹화할 컬럼명
*/



-- 출판사, 도서명, 도서가격 전체 데이터(오름차순정렬)

SELECT publisher, name, price
FROM bookstore
ORDER BY 1,2,3;

-- 출판사별로 도서의 개수가 몇 권인지 체크

SELECT ifnull(publisher, '알수없음') AS '출판사'
		,COUNT(name) AS '도서의개수'
FROM bookstore
GROUP BY publisher;

-- 출판사별 도서금액 합계 확인

SELECT publisher, SUM(price) AS '도서금액 합계'
FROM bookstore
group by publisher;


-- 출판사별로 도서가 몇권 있는지 수량파악 

SELECT publisher, COUNT(name) AS '도서개수'
FROM bookstore
GROUP BY publisher;

-- 출판사가 비어있는 데이터는 제외

SELECT publisher, COUNT(name) AS '도서개수'
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher;

-- 출판사별로 도서의 가격의 합계는 어느정도일까?

SELECT publisher, sum(price) AS '도서금액 합계'
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher;

-- 출판사별로 도서의 가격의 합계가 높은 순으로 나열

SELECT publisher, sum(price) AS '도서금액 합계'
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher
ORDER BY price DESC;

-- 중복과 NULL이 없는 출판사 추출(DISTINCT)

SELECT DISTINCT publisher
FROM bookstore
WHERE publisher IS NOT NULL;


-- 중복과 NULL이 없는 출판사 추출(GROUP BY)

SELECT publisher
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher;

-- 중복과 NULL이 없는 출판사 중 도서금액의 합계(DISTINCT를 사용한다면)
-- 집계함수 & DISTINCT >>> 에러

SELECT DISTINCT publisher, SUM(price) AS '도서금액합계'
FROM bookstore
WHERE publisher IS NOT NULL;

-- 중복과 NULL이 없는 출판사 중 도서금액의 합계(GROUP BY를 사용한다면)

SELECT publisher, SUM(price) AS '도서금액합계'
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher;

-- 출판사별 도서의 개수 중 총 개수가 3보다 작은 값들 추출

SELECT publisher, COUNT(name) AS '도서의개수'
FROM bookstore
GROUP BY publisher
HAVING COUNT(name) < 3
ORDER BY 2 DESC;

-- 한빛미디어 출판사(publisher)의 정보를 추출 (만약 별칭으로 조건을 준다면)
-- 별칭으로 WHERE절 조건을 줄 시 에러

SELECT name, publisher AS publisher_name
FROM bookstore
WHERE publisher_name = '한빛미디어';


-- 도서별(name) 금액 합계가 2만원 이상인 도서와 금액 확인 (GROUP BY, SUM)

SELECT name, SUM(price) AS sum_price
FROM bookstore
GROUP BY name
HAVING SUM(price) >=20000;

SELECT name, price
FROM bookstore
WHERE price >= 20000;

-- 출판사별로 도서가 몇권 있는지 수량파악 
-- 전체 출판사, 출판사가 들어있는 데이터의 개수 추출
-- 출판사가 비어있는 데이터는 제외
-- 출판사별로 도서의 가격의 합계는 어느정도일까?
-- 합계가 50000원 이상인 데이터만 추출

SELECT publisher
	, COUNT(name) AS cnt
    , SUM(price) AS sum_price
FROM bookstore
WHERE publisher IS NOT NULL
GROUP BY publisher
HAVING SUm(price) >= 50000
ORDER BY 3;



-- 도서가격의 평균금액을 정수로 형변환(CAST)
-- 결과값 동일, 편한 문법으로 활용

SELECT CAST(AVG(price) AS unsigned) AS avg_price1
	,ROUND(AVG(price), 0) AS avg_price2
FROM bookstore;




/*
SELECT *
FROM 테이블1
UNION ALL  -- 완전한 쿼리문 2개를 UNION으로 합침
SELECT *
FROM 테이블 2

SELECT *
FROM 테이블1
UNION DISTINCT -- 중복 제거
SELECT *
FROM 테이블 2
*/


-- 작가의 이름과 고객의 이름을 같은 컬럼으로 합쳐 나타내기 (컬럼명은 user로 설정)

SELECT name AS user, id
FROM customer
UNION ALL
SELECT author, id
FROM bookstore;

-- 작가의 이름과 고객의 이름을 같은 컬럼으로 합쳐 나타내기 (컬럼명은 user로 설정, 중복제거)

SELECT name AS user, id
FROM customer
UNION DISTINCT
SELECT author, id
FROM bookstore;