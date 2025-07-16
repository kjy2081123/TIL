select count(*) as 매출건수 -- (*)쓰는게 일반적
from sales;
select count(customer_id)
from sales;
select 
	count(*) as 총주문건수,
    count(distinct customer_id) as 고객수, -- 중복 제거
	count(distinct product_name) as 제품수 -- 중복 제거
from sales;
-- 통계를 작성하는 방식

-- sum(총합)
select 
	format(sum(total_amount),0) as 총매출, -- 천단위 ,찍기
	sum(total_amount) as 총매출액,
    sum(quantity) as 총판매수량
from sales;
select
	sum(if(region='서울', total_amount,0)) as 서울매출,
    sum(if(category='전자제품', total_amount,0)) as 전자매출
    from sales;
    
-- avg(평균)
select 
	avg(total_amount) as 평균매출액,
    avg(quantity) as 평균판매수량,
   round(avg(unit_price)) as 평균단가
from sales;

-- min/max
select 
	min(total_amount) as 최소매출액,
    max(total_amount) as 최대매출액,
    min(order_date) as 첫주문일,
    max(order_date) as 마지막주문일
from sales;

-- 종합
select
	count(*) as 주문건수,
    sum(total_amount) as 총매출액,
    avg(total_amount) as 평균매출액,
    min(total_amount) as 최소매출액,
    max(total_amount) as 최대매출액,
    round(avg(quantity),1) as 평균수량
from sales;  

-- 서울매출만
select
	sum(total_amount) as 서울매출
from sales
where region='서울';