-- 전자제품을(sales) 구매한 고객의 정보(customers)
select * from sales;
select 
	customer_id,
	customer_name,
	customer_type
from customers c
where customer_id in (
	select customer_id from sales where category = '전자제품'
);

select 
	customer_id,
	customer_name,
	customer_type
from customers
where exists (
	select 1 from sales s where s.customer_id=c.customer_id and category = '전자제품'
); -- 효율이 더 좋음

-- exists(~한적이 있는)
-- 전자제품과 의류를 모두 구매해본적이 있고 50 이상 구매한 이력이 있는 고객
select 
	customer_id,
	customer_name,
	customer_type
from customers c
where exists (
	select 1 from sales s where s.customer_id=c.customer_id and category = '전자제품'
    and s.total_amount >= 500000
)
and exists (
select 1 from sales s where s.customer_id=c.customer_id and category = '의류'
    and s.total_amount >= 500000
);