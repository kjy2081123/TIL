use lecture;
select * from sales;
select * from customers;
select* from products;
-- 각 고객의 주문정보(c.id, c.type,c.name,총주문횟수,총주문금액,최근주문일)

select
    c.customer_id,
    c.customer_name,
    c.customer_type,
    COUNT(s.id) AS 총주문횟수,
    COALESCE(SUM(s.total_amount), 0) AS 총주문금액,
    ROUND(COALESCE(AVG(s.total_amount), 0), 0) AS 평균주문금액,
    COALESCE(MAX(s.order_date), '주문없음') AS 최근주문일
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.customer_type
ORDER BY 총주문금액 DESC;

-- 각 카테고리별 평균매출중 50 이상
select
category as 카테고리,
format(avg(total_amount),0) as 평균매출
from sales 
group by category
having avg(total_amount) >500000;

select
*
from (
	select
category as 카테고리,
format(avg(total_amount),0) as 평균매출
from sales 
group by category)
as category_summary
having avg(total_amount) >=500000;

SELECT
    category AS 카테고리,
    FORMAT(AVG(total_amount), 0) AS 평균매출
FROM
    sales
GROUP BY
    category
HAVING
    AVG(total_amount) >= 500000;


-- 1. 카테고리별 매출 분석 후 필터링(카테고리명,주문건수,총매출,0<=저단가<400000<=중단가<800000<고단가)
select
category as 카테고리,
count(id) as 주문건수,
FORMAT(SUM(total_amount), 0) AS 총매출,
FORMAT(AVG(total_amount), 0) AS 평균매출,
case
	when avg(total_amount) >= 800000 then '고단가'
    when avg(total_amount) >= 400000 then '중단가'
    else '저단가'
end as 단가구분
from sales
group by category;


-- 영업사원별 성과등급 분류(사원명,총매출액,주문건수,평균주문액,매출등급,주문등급)/ 
-- 매출등급- 총매출(0<c<=백<b<=3백<=a<=5백<=s)
-- 주문등급- 주문건수(0<=c<15<=b<30<=a)
select
sales_rep as 사원이름,
count(id) as 주문건수,
FORMAT(SUM(total_amount), 0) AS 총매출,
FORMAT(AVG(total_amount), 0) AS 평균매출,
case
	when sum(total_amount)>= 5000000 then 's'
    when sum(total_amount)>= 3000000 then 'a'
    when sum(total_amount)>= 1000000 then 'b'
    when sum(total_amount)>0 then 'c'
end as 매출등급,
case
	when avg(total_amount)>=30 then 'a'
	when avg(total_amount)>=15 then 'b'
    when avg(total_amount)>=0 then 'c'
end as 주문등급
from sales 
 group by 사원이름
 order by 평균매출 desc;




