use lecture;
select 
c.customer_id,
c.customer_name,
count(s.id) as 주문횟수,
group_concat(s.product_name) as 주문제품들
from customers c
left join sales s on c.customer_id=s.customer_id
group by c.customer_id, c. customer_name;