-- 모든 제품의 평균 구매 가격(buyprice)(products 테이블 사용)
USE classicmodels;

SELECT AVG(buyprice)
FROM products;

--  Classic Cars의 제품라인에 대해 가장 높은 구매가격과 낮은 구매 가격 확인(buyPrice)

SELECT MAX(buyprice), MIN(buyprice)
FROM products;
WHERE productLIne = 'Classic Cars'

-- 각 제품 공급업체(productVendor)별로 중복되는 제품코드는 없는지 확인
-- (제품 공급업체, 전체행 개수, 제품코드 개수(productCode)) - 제품코드 개수가 많은 것 순서로 정렬

SELECT productVendor
	, COUNT(*) AS '전체행의개수'
    , COUNT(productCode) AS '제품코드개수'
FROM products
GROUP BY 1
ORDER BY 3 DESC;

-- 주문 상태(status)에 어떤 값들이 있는지 확인(orders 테이블 사용)(GROUP BY)

SELECT status, COUNT(orderNumber) AS cnt
FROM orders
GROUP BY status;
-- GROUP BY 1;

SELECT DISTINCT status
FROM orders;

-- 주문 상태 중 배송완료(Shipped), 취소(Cancelled), 보류(On Hold)의 상태의 현황 추출(COUNT와 IF사용)

SELECT -- status
	COUNT(if(status= 'Shipped', 1, NULL)) AS 'Shipped'
    ,COUNT(if(status= 'Cancelled', 1, NULL)) AS 'Cancelled'
    ,COUNT(if(status= 'ON Hold', 1, NULL)) AS 'ON Hold'
FROM orders


-- GROUP BY 사용;

SELECT status, COUNT(*) AS cnt
FROM orders
WHERE status IN ('Shipped', 'Cancelled', 'ON Hold')
GROUP BY status;

-- 주문번호를 기준으로, 주문 총액 추출(orderdetails 테이블 사용)

SELECT orderNumber, SUM(quantityOrdered*priceEach) AS SUM_price
FROM orderdetails
GROUP BY orderNUmber

-- 주문번호를 기준으로 주문 총액이 10000원 이상이고 주문수량이 500건 이상인 데이터 내림차순으로 추출(주문 번호, 주문 수량, 주문 총액)
-- (orderdetails 테이블 사용)

SELECT orderNumber
	, SUM(quantityOrdered*priceEach) AS SUM_price
	, SUM(quantityOrdered) AS cnt
FROM orderdetails
GROUP BY 1
-- WHERE SUM_price >= 10000	AND (productCode*quantityOrdered) >=500;  집계함수 WHERE 불가
-- HAVING SUM_price >= 10000	AND (productCode*quantityOrdered) >=500; 해빙 별칭 불가
HAVING SUM(quantityOrdered*priceEach) >= 10000
AND SUM(quantityOrdered) >= 500
ORDER BY 2 DESC,3 DESC;
        
-- 가장 많이 주문된 제품의 순서로 출력(제품코드, 주문된 수량)

SELECT productCode, MAX(quantityOrdered) AS '주문된수량'
FROM orderdetails
GROUP BY 1 
ORDER BY 2 DESC;


-- 1000개 이상의 재고(quantityInStock)가 남아있는 제품 확인

SELECT *
FROM products
GROUP BY productCode
HAVING quantityInStock >= 1000

-- 제품라인(productLine)별 평균 MSRP이 100이하인 제품라인 확인(최종 결과값은 정수형)

SELECT productLine
	,CAST(AVG(MSRP) AS UNSIGNED) AS avg_MSRP  -- CAST 정수형 변환
FROM products
GROUP BY 1
HAVING AVG(MSRP) <= 100;
