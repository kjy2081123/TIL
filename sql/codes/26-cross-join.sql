-- 카트레티시안 곱( 모든경우의 수 조합)
select 
	c.customer_name,
    p.product_name,
    p.category,
    p.selling_price
from customers c
cross join products p
where c.customer_type= 'vip'
order by c.customer_name, p.category;

-- 구매하지 않은 상품 추천
select 
	c.customer_name as 고객명,
    p.product_name as 미구매상품
from customers c
cross join products p
-- vip이며 구매하지 않은 상품만
where c.customer_type='vip' 
	and not exists (
	select 1 from sales s
    where s.customer_id=c.customer_id
    and s.product_id=p.product_id
)
order by 고객명;























