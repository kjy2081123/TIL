use lecture;
select * from sales;
-- vector -> 한줄로 이루어진 데이터
-- scala -> 한개의 데이터
-- matrix ->행과 열로 이뤄짐
select * from customers;
select customer_id from customers where customer_type = 'VIP'; -- 모든 vip의 id 뽑기

-- 모든 vip의 주문내역
select *
from sales
where customer_id in(select customer_id from customers where customer_type = 'VIP')
order by total_amount desc;

-- 1.전자제품 구매고객들의/ 2. 모든 주문내역
select distinct customer_id
from sales
where category= '전자제품';

select * from sales
where customer_id in(select distinct customer_id
from sales
where category= '전자제품')
order by customer_id, total_amount desc;

-- 평균이상 매출을 기록한 주문
