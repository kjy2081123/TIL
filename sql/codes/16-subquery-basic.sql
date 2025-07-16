use lecture; 
select * from sales;
-- 매출평균보다 높은 금액을 주문한 판매데이터
select avg(total_amount) from sales;
select *from sales where total_amount > 612862;

-- 서브쿼리
select * from sales
where total_amount >(select avg(total_amount) from sales); -- 평균보다 더 주문한 


select
product_name as 이름,
total_amount as 판매액,
total_amount - (select avg(total_amount) from sales) as 평균차이
from sales
where total_amount >(select avg(total_amount) from sales);

-- 데이터 한개 나오는 경우
select avg(quantity) from sales;

-- sales에서 가장 비싼걸 시킨주문
select max(total_amount) from sales;
select* from sales where total_amount=(select max(total_amount) from sales);

-- 가장 최근 주문일의 주문 데이터
select max(order_date) from sales;
select * from sales where order_date=(select max(order_date) from sales);

-- 주문액수 평균과 가장 유사한 데이터 5개 -> 주문평균액과의 차이까지 고려하겠다는뜻
select avg(total_amount) from sales;
SELECT
    product_name,
    total_amount,
    ABS(total_amount - (SELECT AVG(total_amount) FROM sales)) AS 평균과의차이
FROM
    sales
ORDER BY
    평균과의차이 ASC -- 평균과의 차이가 작은 순서대로 정렬
LIMIT 5; -- 상위 5개만 선택



