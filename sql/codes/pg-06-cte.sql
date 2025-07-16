-- cte(common table expression)  

-- 평균주문액보다 큰 주문들의 고객정보


explain analyze;
-- 1단계:평균주문액 계산
with avg_order as(
	select avg(amount) as avg_amount
	from orders
)
--2단계: 평균보다 큰 주문 찾기
select c.customer_name, o.amount,ao.avg_amount
from customers c
join orders o on c.customer_id=o.customer_id
join avg_order ao on o.amount >ao.avg_amount
limit 10;

--1. 각 지역별 고객 수와 주문 수를 계산하세요
--2. 지역별 평균 주문 금액도 함께 표시하세요
--3. 고객 수가 많은 지역 순으로 정렬하세요
:-- 전구: 힌트:
- 먼저 지역별 기본 통계를 CTE로 만들어보세요
- 그 다음 고객 수 기준으로 정렬하세요
지역    고객수   주문수   평균주문금액
서울    143     7,234   567,890
부산    141     6,987   534,123
대구    140     6,876   545,678

select * from customers;
select * from orders;

with region_summary as (
SELECT
    c.region as 지역,
    COUNT(DISTINCT c.customer_id) AS 고객수,
    COUNT(o.order_id) AS 주문수,
	coalesce(avg(o.amount),0) as 평균주문금액
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.region
)
SELECT
   지역명,
   고객수,
   주문수,
   round(평균주문금액) as 평균주문금액
FROM region_summary
order by 고객수 desc;


WITH region_summary AS (
	SELECT
		c.region AS 지역명,
		COUNT(DISTINCT c.customer_id) AS 고객수,
		COUNT(o.order_id) AS 주문수,
		COALESCE(AVG(o.amount), 0) AS 평균주문금액
	FROM customers c
	LEFT JOIN orders o ON c.customer_id=o.customer_id
	GROUP BY c.region
)
SELECT
	지역명,
	고객수,
	주문수,
	ROUND(평균주문금액) AS 평균주문금액
FROM region_summary
ORDER BY 고객수 DESC;



SELECT
    c.region,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COUNT(o.order_id) AS order_count
FROM
    customers c
LEFT JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.region
ORDER BY
    customer_count desc;

select * from products;
select * from orders;
select* from customers;

-- 2-1. 각 상품의 총 판매량과 총 매출액을 계산하세요
SELECT
    p.product_name,
    SUM(o.quantity) AS 총판매량,
    SUM(o.amount) AS 총매출
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
    p.product_name;


select

from products p

-- 2-2.상품 카테고리별로 그룹화하여 표시하세요
select 
	p.category,
	SUM(o.quantity) AS 총판매량,
    SUM(o.amount) AS 총매출
from orders o
join products p on o.product_id=p.product_id
group by p.category
order by 총매출 desc;



-- 2-1+2-2
with product_sales as (
select
	p.category as 카테고리,
	p.product_name as 상품명,
	p.price as 상품가격,
	SUM(o.quantity) AS 총판매량,
    SUM(o.amount) AS 총매출,
	count(o.order_id) as 주문건수,
	avg(o.amount) as 평균주문액
from products p
left join orders o on p.product_id=o.product_id
group by p.category, p.product_name,p.price
),
category_total as(
select
	카테고리,
	sum(총매출)
	from product_sales
	group by 카테고리
)
select 
	ps.카테고리,
	ps. 상품명,
	ps. 총매출,
	ct.카테고리,
	round(ps.총매출*100/ ct.카테고리,2) as 카테고리매출비중
from product_sales ps
inner join category_total ct on ps.카테고리=ct.카테고리;
-- 2-3. 각 카테고리 내에서 매출액이 높은 순서로 정렬하세요
SELECT
    p.product_name as 상품명,
    AVG(o.amount) AS 평균주문액
FROM
    orders o
JOIN
    products p ON o.product_id = p.product_id
GROUP BY
    p.product_name
ORDER BY
	카테고리, 총매출액 desc;


-- 고객 구매금액에 따라 vip,일반,신규로 나눠 등급통계작성(등급,등급별 회원수,등급별 구매액 총합,등급별 평균주문건수)
-- 상위 20%:vip, 일반: 전체평균보다 높음, 신규(나머지로 나눔)
select * from customers;
select * from orders;
select * from products;
with customer_summary as(
select 
	c.customer_id as 고객id,
	count(o.order_id) as 총주문건수,
	coalesce(sum(o.amount),0) as 총구매액
from customers c
left join orders o on c.customer_id=o.customer_id
group by c.customer_id
),
tier_theresholds as (
select percentil_cont(0.8) within group(order by 총주문건수 desc);



WITH customer_summary AS (
    SELECT
        c.customer_id,
        COUNT(o.order_id) AS total_orders_count,
        COALESCE(SUM(o.amount), 0) AS total_purchase_amount
    FROM
        customers c
    LEFT JOIN
        orders o ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id
),
tier_thresholds AS (
    SELECT
        -- 상위 20% (80th percentile) 금액 계산
        PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total_purchase_amount DESC) AS vip_threshold_amount,
        -- 전체 고객의 평균 구매액 계산
        AVG(total_purchase_amount) AS avg_total_purchase_amount
    FROM
        customer_summary
),
customer_tiers AS (
    SELECT
        cs.customer_id,
        cs.total_orders_count,
        cs.total_purchase_amount,
        CASE
            WHEN cs.total_purchase_amount >= tt.vip_threshold_amount THEN 'VIP'
            WHEN cs.total_purchase_amount >= tt.avg_total_purchase_amount THEN '일반'
            ELSE '신규'
        END AS customer_tier
    FROM
        customer_summary cs, tier_thresholds tt
)
SELECT
    ct.customer_tier AS 고객_등급,
    COUNT(ct.customer_id) AS 등급별_총인원수,
    SUM(ct.total_purchase_amount) AS 등급별_구매액_총합,
    ROUND(AVG(ct.total_orders_count), 2) AS 등급별_평균주문수
FROM
    customer_tiers ct
GROUP BY
    ct.customer_tier
ORDER BY
    CASE ct.customer_tier
        WHEN 'VIP' THEN 1
        WHEN '일반' THEN 2
        WHEN '신규' THEN 3
        ELSE 4
    END;

-- 1. 고객별 총 구매 금액
with customer_total as (
	select
		customer_id,
		sum(amount) as 총구매액
	from orders
	group by customer_id
),

--2. 구매금액 기준 계산
purchase_thresholds as(
	select
		avg(총구매액) as 평균구매액,
		-- 상위 20% 구하기
		percentil_cont(0.8) within group(order by total_purchase) as vip기준
	from customer_total;
)

--3. 고객등급 분류
select
	ct.customer_id,
	ct.총구매액,
	case
		when ct.총구매액 >= pt.vip기준 then 'vip'
		when ct.총구매액 >= pt.vip기준 then '일반'
		else '신규'
	end as 등급
from customer_total ct
cross join purchase_thresholds pt;



-- 1. 고객별 총 구매 금액 + 주문수
WITH customer_total AS (
	SELECT
		customer_id,
		SUM(amount) as 총구매액,
		COUNT(*) AS 총주문수
	FROM orders
	GROUP BY customer_id
),
-- 2. 구매 금액 기준 계산
purchase_threshold AS (
	SELECT
		AVG(총구매액) AS 일반기준,
		-- 상위 20% 기준값 구하기
		PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY 총구매액) AS vip기준
	FROM customer_total
),
-- 3. 고객 등급 분류
customer_grade AS (
	SELECT
		ct.customer_id,
		ct.총구매액,
		ct.총주문수,
		CASE 
			WHEN ct.총구매액 >= pt.vip기준 THEN 'VIP'
			WHEN ct.총구매액 >= pt.일반기준 THEN '일반'
			ELSE '신규'
		END AS 등급
	FROM customer_total ct
	CROSS JOIN purchase_threshold pt
)
-- 4. 등급별 통계 출력
SELECT
	등급,
	COUNT(*) AS 등급별고객수,
	SUM(총구매액) AS 등급별총구매액,
	ROUND(AVG(총주문수), 2) AS 등급별평균주문수
FROM customer_grade
GROUP BY 등급;
