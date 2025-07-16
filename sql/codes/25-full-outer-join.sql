-- 데이터 무결성 검사(빈 데이터 찾기)
-- left join+ right join - 중복된 데이터
select 
	'left에서' as 출처, 
	c.customer_name,
    s.product_name




from customers c
left join sales s on c.customer_id=s.customer_id
union
select
'right에서' as 출처, 
	c.customer_name,
    s.product_name
from customers c 
right join sales s on c.customer_id=s.customer_id
where c.customer_id is null