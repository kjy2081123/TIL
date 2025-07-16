use lecture;
select 
	category,
    count(*) as 주문건수,
    sum(total_amount) as 총매출액
from sales
where total_amount >= 1000000 -- 원본 데이터에 필터링을 걸고, grouping
group by category;

select 
	category,
    count(*) as 주문건수,
    sum(total_amount) as 총매출액
from sales
where total_amount >= 1000000 -- 원본 데이터에 필터를 걸고, grouping
group by category
having sum(total_amount) >= power(10,7); -- 피벗테이블에 필터 추가

-- 활성 지역 찾기( 주문건수 >=10, 고객수 >=5)
select 
	region as 지역,
    count(*) as 주문건수,
    count(distinct customer_id) as 고객수,
    sum(total_amount) as 총매출액,
    round(avg(total_amount)) as 평균주문액
from sales
group by region
having 주문건수 >= 20 and 고객수 >= 15;

select
	region
from sales
where total_amount > power(10,6);


-- 우수 영업사원
select
	sales_rep as 영업사원,
    count(*) as 사원별판매건수,
    count(distinct customer_id) as 사원별고객수,
    sum(total_amount) as 사원별총매출,
    count(distinct date_format(order_date,'%y-%m')) as 활동개월수,
	ROUND(
		SUM(total_amount) / COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m'))
	) AS 월평균매출
from sales
group by sales_rep
having 월평균매출 >= 5 * power(10, 5)
order by 월평균매출 DESC;





SELECT
	sales_rep AS 영업사원,
    COUNT(*) AS 사원별판매건수,
	COUNT(DISTINCT customer_id) AS 사원별고객수,
    SUM(total_amount) AS 사원별총매출,
    COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) AS 활동개월수,
    ROUND(
		SUM(total_amount) / COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m'))
	) AS 월평균매출
FROM sales
GROUP BY sales_rep
HAVING 월평균매출 >= 5 * power(10, 5)
ORDER BY 월평균매출 DESC;