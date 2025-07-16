use lecture;
create view customer_summary as 
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총구매액,
    COALESCE(AVG(s.total_amount), 0) AS 평균주문액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

-- 등급별 구매평균
select
customer_type,
avg(총구매액)
from customer_summary
group by customer_type;
select *from customer_summary;
-- 충성고객 -> 주문횟수 5회이상
select 
customer_id as 고객id,
customer_name as 고객이름,
customer_type as 고객유형,
주문횟수
from customer_Summary
where 주문횟수 >= 5;

-- 잠재고객 -> 최근 가입자 10명
select * from customer_summary
where 최근주문일 != '주문없음'
order by 최근주문일 desc
limit 10;

-- View 2: 카테고리별 성과 요약 View (category_performance)
-- 카테고리 별로, 총 주문건수, 총매출액, 평균주문금액, 구매고객수, 판매상품수, 매출비중(전체매출에서 해당 카테고리가 차지하는비율)
create view category_performance as 
select
	s.category,
    count(*) as 총주문건수,
    sum(s.total_amount) as 총매출액,
    avg(s.total_amount) as 평균매출액,
    count(distinct s.customer_id) as 구매고객수,
    count(distinct s.product_name) as 판매제품수,
	ROUND(SUM(s.total_amount) * 100.0 / (SELECT SUM(total_amount) FROM sales), 2) AS 매출비중
    from sales s
    group by s.category;
    select* from category_performance;


-- View 3: 월별 매출 요약 (monthly_sales )
-- 년월(24-07), 월주문건수, 월평균매출액, 월활성고객수, 월신규고객수
create view monthly_sales as
select
	date_format(s.order_date,'%Y-%M') as 년월,
    count(*) as 월주문건수,
    sum(s.total_amount) as 월매출액,
    avg(s.total_amount) as 월평균매출액,
    count(distinct s.customer_id) as 월활성고객수,
    count(distinct c.customer_id) as 월신규고객수
from sales s
left join customers c on s.customer_id=c.customer_id
and date_format(s.order_date,'%Y-%M') = date_format(c.join_date,'%Y-%M') 
group by 년월 asc;
select* from monthly_sales;

    