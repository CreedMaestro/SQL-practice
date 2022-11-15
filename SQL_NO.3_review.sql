/*
여러개의 테이블 조인하여 다양한 데이터 추출해보기
-- 특정 고객이 주문한 제품명 확인
-- 상품의 재고 파악

*/

USE classicmodels;

-- 제품별 제품에 대한 설명 확인
-- 제품코드(productCode), 제품명(productName), 제품 설명(productDescription), 제품라인설명

SELECT P.productCode
		,P.productName
        ,P.productDescription
        ,PL.textDescription
FROM products AS P
JOin productlines AS PL
ON P.productLine = PL.productLine;


-- 주문 현황 파악 
-- 주문 번호(orderNumber), 주문 상태(status), 총 판매금액(주문 수량(quantityOrdered) * 각 금액(priceEach)) 확인

SELECT O.orderNumber
		, O.status
        , SUM(OD.quantityOrdered * priceeach) AS '총 판매금액'
FROM orders AS O
JOIN orderdetails AS OD
ON O.orderNumber = OD.orderNumber
GROUP BY 1,2;


-- 3개의 테이블 JOIN 
-- 주문번호(orderNumber), 주문일자(orderDate), 제품이름(productName), 판매수량(quantityOrdered), 가격 확인(priceEach) 
-- (제품, 주문, 주문상세 테이블)


select O.orderNumber
		,O.orderDate
        ,P.productName
        ,OD.quantityOrdered
        ,OD.priceEach
from orderdetails AS OD
JOIN orders AS O
ON o.orderNumber = OD.orderNumber
JOIN products AS P
ON OD.productCode = P.productCode;


-- 일별 매출액 조회
-- 주문일(orderdate) 기준 주문, 판매금액(주문 수량(quantityOrdered) * 각 금액(priceEach)) 확인
-- 가장 오래된 날짜순서로 정렬

SELECT O.orderdate
		, SUM(OD.quantityOrdered* priceEach) AS '판매금액'
FROM orders AS O
JOIN orderdetails AS OD
ON O.orderNumber = OD.orderNumber
GROUP BY 1
ORDER BY 1 ;

-- S10_2016의 제품코드(productcode) 중 권장소비자가격(MSRP)이 해당 제품 가격보다 큰 제품의 판매가격 확인
-- 주문번호, 제품이름, 권장소비자가격, 각 금액, 제품코드

SELECT OD.orderNumber
		,P.productName
        ,P.msrp
        ,p.buyprice
        ,p.productCode
FROM products AS P
JOIN orderdetails AS OD
ON p.productcode = OD.productcode
WHERE p.productCode = 's10_2016'
AND p.MSRP >= P.buyprice;



--  고객번호 기준 배송상태가 취소되지않은 건(전체 리스트 확인)
-- 고객번호, 고객이름, 주문번호, 상태

SELECT C.customerNumber
		,C.customerName
        ,O.ordernumber
        ,O.status
FROM customers AS C
LEFT JOIN orders AS O
ON C.customerNumber = O.customerNumber
AND o.status !='cancelled';
-- AND 전체 리스트 출력

-- 고객번호 기준 배송상태가 취소되지않은 건(취소되지않은건만 확인)

SELECT C.customerNumber
		,C.customerName
        ,O.ordernumber
        ,O.status
FROM customers AS C
LEFT JOIN orders AS O
ON C.customerNumber = O.customerNumber
WHERE o.status !='cancelled'
-- WHERE 해당 건만 출력

-- 일별 매출액 확인 (주문일, 판매액) - 날짜별, 가격낮은순으로 정렬

SELECT O.orderdate, (OD.quantityOrdered*priceeach) AS '매출액'
FROM orderdetails AS OD
JOIN orders AS O
ON O.ordernumber = OD.ordernumber
GROUP BY 1
ORDER BY 1,2;


-- 월별  매출액 확인 (주문일, 판매액) - 날짜별, 가격낮은순으로 정렬




-- 주간 매출액 확인 (주문일, 판매액) - 날짜별, 가격낮은순으로 정렬



-- 연도별 매출액 확인 (주문일, 판매액) - 날짜별, 가격낮은순으로 정렬
