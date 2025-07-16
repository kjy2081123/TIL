-- 카테고리별 매출(피벗테이블 행=카테고리, 값=매출액)
use lecture;
select
	category as 카테고리,
    count(*) as 주문건수,
    sum(total_amount) as 총매출,
    avg(total_amount) as 평균매출
from sales
group by category
order by 총매출 desc;

select * from sales;
create table sales;
-- 지역별 매출 분석
select 
	region as 지역,
	count(*) as 주문건수,
    sum(total_amount) as 매출액,
    count(DISTINCT customer_id) as 고객수,
    count(*)/ count(DISTINCT customer_id) as 고객당주문수,
    round(sum(total_amount)/ count(distinct customer_id)) as 고객당평균매출
from sales
group by region;

-- 다중 grouping
select
	region as 지역,
    category as 카테고리,
    count(*) as 주문건수,
    sum(total_amount) as 총매출액,
    round(avg(total_amount)) as 평균매출액
from sales
group by region, category
order by 지역, 총매출액 desc;

-- 영업사원 월별 성과
select * from sales;
select
    date_format(order_date, '%Y-%m') as 월,
    sales_rep as 사원,
    count(*) as 주문건수,
    sum(total_amount) as 월매출액,
    round(avg(total_amount)) as 평균매출액
from sales
group by sales_rep, date_format(order_date, '%Y-%m')
order by 월,월매출액 desc;

-- mau 측정
select
	date_format(order_date, '%Y-%m') as 월,
    count(*) as 주문건수,
    sum(total_amount) as 월매출액,
    count(distinct customer_id) as 월활성고객수
from sales
group by date_format(order_date, '%Y-%m');

-- 요일별 매출 패턴
select 
	dayname(order_date) as 요일,
	dayofweek(order_date) as 요일번호,
	count(*) as 주문건수,
    sum(total_amount) as 총매출액,
    round(avg(total_amount)) as 평균매출액
from sales
group by 요일,요일번호
order by 총매출액 desc;