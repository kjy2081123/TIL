select avg(amount) from orders; -- 전체구매액 평균

select * from orders;
-- 고객별 구매액 평균
select
	customer_id,
	avg(amount)
from orders
group by customer_id;

select
	order_id,
	customer_id,
	amount,
	avg(amount) over() as  전체평균
from orders
limit 10;

-- row_number() -> 줄세우기[row_number() over(order by 정렬기준)]
-- 주문금액이 높은 순서로

select 
	order_id,
	customer_id,
	amount,
	row_number() over (order by amount desc) as 호구번호
from orders
order by 호구번호
limit 20 offset 40;

-- 주문날짜가 최신인 순서대로 번호 매기기
select 
	order_id,
	customer_id,
	order_date,
	row_number() over (order by order_date  desc) as 최근주문일,
	rank() over(order by order_date desc) as 랭크,
	dense_rank() over(order by order_date desc) as 덴스랭크
from orders
order by 최근주문일;


select * from sales;
select * from customers;
select* from orders;
-- 각 지역에서 매출 1위 고객  row_number()로 숫자를매기고, 이 컬럼값이1인 사람
-- [지역,고객이름,총구매액]
--cte?
select
	c.region as 지역,
	c.customer_name as 고객명,
	o.
from customers c



-- 7월 매출 상위 3명 고객찾기
-- (이름,7월 매출, 순위)

with customer_rank as(
select
	c.customer_id as 고객id,
	c.customer_name as 고객명,
	sum(o.amount) as "7월매출",
	rank() over(order by sum(o.amount) desc) as 순위
from customers c
join orders o on c.customer_id=o.customer_id
where extract(month from o.order_date)=7
and extract(year from o.order_date)= 2024
group by c.customer_name,c.customer_id
)
select 
	순위,
	고객id,
	고객명,
	"7월매출" 
from customer_rank
where 순위 <=3
order by 순위;

WITH july_sales AS (
	SELECT
		customer_id,
		SUM(amount) AS 월구매액
	FROM orders
	WHERE order_date BETWEEN '2024-07-01' AND '2024-07-31'
	GROUP BY customer_id
),
ranking AS (
	SELECT
		customer_id,
		월구매액,
		ROW_NUMBER() OVER(ORDER BY 월구매액) AS 순위
	FROM july_sales
)
SELECT
	r.customer_id,
	c.customer_name,
	r.월구매액,
	r.순위
FROM ranking r
INNER JOIN customers c ON r.customer_id=c.customer_id
WHERE r.순위 <= 10;

select* from customers;
select* from products;
select * from orders;

-- 각 지역에서 총구매액1위 고객 => row_number로 숫자매기고,이 컬럼의 값이 1인사람
-- (지역, 고객이름,총구매액 )
-- cte
--1. 지역-사람별"매출데이터" 생성(지역, 고객id, 이름, 해당고객의 총 매출)
--2. 매출데이터에 새로운 열(row_num 추가
--3. 최종 데이터표시

with sales_data as (
	select
		c.region as 지역,
		c.customer_id as 고객id,
		c.customer_name as 고객이름, 
		sum(o.amount) as 총구매액
	from customers c
join orders o on c.customer_id=o.customer_id
group by c.region,c.customer_name,c.customer_id
),
ranked_customer_sales as(
	select
		지역,
		고객id,
		고객이름, 
		총구매액,
	row_number() over (partition by 지역 order by 총구매액 desc) rn
	from customer_sales
)
select
	지역,
	고객id,
	고객이름,
	총구매액	
from ranked_customer_sales
where rn=1
order by 지역;


with sales_data as (
    -- 1. 지역-사람별 "매출데이터" 생성 (지역, 고객id, 이름, 해당 고객의 총 매출)
    select -- SELECT 키워드 추가
        c.region as 지역,
        c.customer_id as 고객id,
        c.customer_name as 고객이름,
        sum(o.amount) as 총구매액
    from customers c
    join orders o on c.customer_id = o.customer_id
    group by c.region, c.customer_name, c.customer_id -- GROUP BY 절에 원본 컬럼 사용 또는 SELECT 절 순서에 맞게 사용
),
ranked_customer_sales as (
    -- 2. 매출데이터에 새로운 열(row_num) 추가
    select
        지역,
        고객id,
        고객이름,
        총구매액, -- 콤마 추가 및 컬럼명 일치
        row_number() over (partition by 지역 order by 총구매액 desc) as rn -- 'as rn' 추가 (선택 사항이지만 명확성을 위해 권장)
    from sales_data -- FROM 절에 올바른 CTE 이름 사용
)
-- 3. 최종 데이터 표시
select
    지역,
    고객이름,
    총구매액 -- 컬럼명 일치
from ranked_customer_sales -- rn 컬럼이 있는 CTE 참조
where rn = 1
order by 지역;