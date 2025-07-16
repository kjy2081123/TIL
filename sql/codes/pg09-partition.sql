-- 체육대회 1,2,3 학년 -> 한번에 학년에서의 순위, 전체에서 순위를 확인가능함.

select	
region,
customer_id,
amount,
row_number() over(order by amount desc) as 전체순위,
row_number() over(partition by region order by amount desc),
rank() over(order by amount desc),
rank() over(partition by region order by amount desc),
dense_rank()over(order by amount desc),
dense_rank() over(partition by region order by amount desc)
from orders limit 10;


-- sum() over() -> 일별 누적 매출액

with daily_sales as(
select 	
	order_date,
	sum(amount) as 일매출
from orders 
where order_date between '2024-07-01'and '2024-07-31'
group by order_date
order by order_date
)
select
	order_date,
	일매출,
	-- 범위내에서 계속 누적
	sum(일매출) over (order by order_date) as 누적매출,
	-- 범이 내에서 파티션 바뀔때 초기화
	sum(일매출) over (
		partition by date_trunc('month',order_date)
		order by order_date
	) as 월누적매출
from daily_sales;

-- avg() over()
WITH daily_sales AS (
	SELECT
		order_date,
		SUM(amount) AS 일매출,
		COUNT(*) AS 주문수
	FROM orders
	WHERE order_date BETWEEN '2024-06-01' AND '2024-08-31'
	GROUP BY order_date
	ORDER BY order_date
)
SELECT
	order_date,
	일매출,
	주문수,
	ROUND(AVG(일매출) OVER(
		ORDER BY order_date
		ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	)) AS 이동평균7일,
	ROUND(AVG(일매출) OVER(
		ORDER BY order_date
		ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
	)) AS 이동평균3일
FROM daily_sales;





select
	region,
	order_date,
	amount,
	avg(amount) over (partition by region order by order_date) as 지역매출누적평균
from orders
where order_date between '2024-07-01' and '2024-07-02';


-- 카테고리 별 인기 상품(매출순위) TOP 5
-- CTE
-- [상품 카테고리, 상품id, 상품이름, 상품가격, 해당상품의주문건수, 해당상품판매개수, 해당상품총매출]
-- 위에서 만든 테이블에 WINDOW함수 컬럼추가 + [매출순위, 판매량순위]
-- 총데이터 표시(매출순위 1 ~ 5위 기준으로 표시)

	select * from products;
	select* from orders;
	select * from sales;
with product_sales_summary as (
select
	p.category as 카테고리,
	p.product_id as 상품id,
	p.product_name as 상품이름,
	p.price as 상품가격,
	count(o.order_id) as 해당상품의주문건수,
	sum(o.quantity) as 해당상품판매건수,
	sum(o.quantity*p.price) as 해당상품총매출
from products p
left join orders o on o.product_id=p.product_id
group by p.category, p.product_id,p.product_name,p.price
),
ranked_products as(
select
	*,
	dense_rank() over (partition by p.category order by 해당상품총매출 desc) as 매출순위,
	dense_rank() over (partition by p.category order by 해당상품판매건수 desc) as 판매량순위
from product_sales_summary
)
select
	p.category, p.product_id,p.product_name,p.price,해당상품의주문건수,해당상품판매건수,해당상품총매출
	from ranked_products
	where 매출순위 <=5;

	WITH product_sales AS (
	SELECT
		p.category,
		p.product_id,
		p.product_name,
		p.price,
		COUNT(o.order_id) AS 주문건수,
		SUM(o.quantity) AS 판매개수,
		SUM(o.amount) AS 총매출
	FROM products p
	LEFT JOIN orders o ON p.product_id = o.product_id
	GROUP BY p.category, p.product_id, p.product_name, p.price
),
ranked_products AS (
	SELECT
		*,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 총매출 DESC) AS 매출순위,
		DENSE_RANK() OVER (PARTITION BY category ORDER BY 판매개수 DESC) AS 판매량순위
	FROM product_sales
)
SELECT
	category, product_name, price, 주문건수, 판매개수, 총매출, 매출순위, 판매량순위
FROM ranked_products
WHERE 매출순위 <= 5
ORDER BY category, 매출순위;