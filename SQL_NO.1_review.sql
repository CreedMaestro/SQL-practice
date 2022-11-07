-- 담당직원이 같은 고객 필터링(customers 테이블 사용)

USE classicmodels;

SELECT *
FROM customers;
WHERE contactLastName in (
		SELECT contactLastName
        FROM customers
        GROUP BY contactLastName
        HAVING COUNT(contactLastName) > 1
)
ORDER BY contactLastName;

-- 담당직원의 번호가 1401이거나 1501인 고객의 리스트 추출 (salesRepEmployeeNumber)

SELECT *
FROM customers
WHERE salesRepEmployeeNumber IN ('1401', '1501');

-- 리스트엔 고객의 이름(customerName), 나라(country), 도시(city)가 포함되어야함

SELECT customerName, country, city, salesRepEmployeeNumber
FROM customers
WHERE salesRepEmployeeNumber IN ('1401', '1501');

-- USA, France에 거주하지않는 고객의 이름(customerName), 도시(city), 휴대전화번호 추출(phone)

SELECT customerName, country, city
FROM customers
WHERE country NOT IN ('USA', 'France');

-- 담당직원(salesRepEmployeeNumber)이 없고 독일(Germany)에 거주하지않는(country) 고객 리스트 추출

SELECT *
FRom customers
WHERE salesRepEmployeeNumber IS NULL
AND country != 'Geramany';

-- 고객(customerName) 중 Co.로 끝나는 일반 회사 전체 리스트 출력

SELECT *
FROM customers
WHERE customerName Like '%Co.';


-- '&'를 포함하고 있는 고객의 이름(customerName)에 대한 정보 추출 (고객번호, 이름)

SELECT customerNumber, customerName
FROM customers
WHERE customerName LIKE '%[&]%';


-- 고객의 카드한도(creditLimit) 비교

SELECT customername, creditLimit
FROM customers;

-- 카드 한도가 높은 고객순으로 추출(customerName, creditLimit)

SELECT customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC;

-- 고객의 카드 한도가 80000 ~ 100000 사이인 고객의 이름, 카드한도, 휴대전화번호(phone) 추출

SELECT customerName, creditLimit, phone
FROM customers
WHERE creditLimit between '80000' and '100000';

-- (카드한도가 낮은 고객순으로 추출)

SELECT customerName, creditLimit, phone
FROM customers
WHERE creditLimit between '80000' and '100000'
ORDER BY creditLimit;

-- 고객의 카드 한도를 1.2배로 증가시킨 한도를 구한 뒤, 고객의 이름, 카드 한도, 증가시킨 한도 추출

SELECT customerName, creditLimit, creditlimit*1.2
FROM customers;

-- 증가시킨 한도의 컬럼명을 increase_creditLimit으로 작성

SELECT customerName, creditLimit, 
		creditlimit*1.2 AS 'increase_creditLimit'
FROM customers;

-- 제품 주문 날짜 기준 3일 이내 배송건 (orders 테이블 사용)

SELECT *
FROM orders
WHERE (shippedDate-orderDate)<=3;

-- 제품번호(orderNumber), 주문일(orderDate), 배송일(shippedDate), 실제배송일(배송일-주문일), 상태 추출 (실제배송일의 컬럼명은 real_shipping_days로 작성)

SELECT orderNumber, orderDate, shippedDate, (shippedDate-orderDate) AS real_shipping_days
FROM orders
