-- ntile:균등하게 나눔

with customer_totals as(
	select 
		customer_id,
		sum(amount) as 총구매금액,
		count(*) as 구매횟수
	from orders
	group by customer_id
),
customer_grade as(
	select
		customer_id,
		총구매금액,
		구매횟수,
		ntile(4) over (order by 총구매금액) as 분위4,
		ntile(10) over (order by 총구매금액) as 분위10
	from customer_totals
	order by 총구매금액 desc
)
select
	c.customer_name,
	cg.총구매금액,
	cg.구매횟수,
	case
		when 분위4=1 then 'bronze'
		when 분위4=2 then 'silver'
		when 분위4=3 then 'gold'
		when 분위4=4 then 'vip'
	end as 고객등급
from customer_grade cg
inner join customers c on cg.customer_id=c.customer_id;

-- percent_rank(): 100분위 순위
select
	product_name,
	category,
	price,
	rank() over (order by price) as 가격순위,
	PERCENT_RANK() OVER (ORDER BY price) as 백분위순위,
	case
		when percent_rank() over (order by price) >= 0.9 then '최고가(상위10%)'
		when percent_rank() over (order by price) >= 0.7 then '고가(상위30%)'
		when percent_rank() over (order by price)>= 0.3 then '중간가격(상위70%)'
		else '저가(하위30%)'
	end as 가격등급
from products;


-- 최고/최저(파티션에서찾는 윈도우함수)
select
	category,
	product_name,
	price,
	first_value(product_name)over(
		partition by category
		order by price desc
		rows between unbounded preceding and unbounded following
	) as 최고가상품명,
	first_value(price) over(
		partition by category
		order by price desc
		rows between unbounded preceding and unbounded following
	) as 최고가격,
	last_value(product_name) over(
		partition by category
		order by price desc
		rows between unbounded preceding and unbounded following
	) as 최저가상품명,
	last_value(price) over(
		partition by category
		order by price desc
		rows between unbounded preceding and unbounded following
	) as 최저가격
from products;