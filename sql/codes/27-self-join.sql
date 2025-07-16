select * from employees;
-- 동일한 테이블을 left join= self join
select
	상사.name as 상사명,
    직원.name as 직원명
from employees 상사
left join employees 직원 on 직원.id= 상사.id+1;
select* from sales;
select * from products;
select * from customers;
-- 고객 간 구매패턴 유사성
-- <손님1, 손님2, 공통구매카테고리수, 공통카테고리이름(group_concat)>
select
	c1.customer_name,
    s1.category,
    s1.product_name,
    c2.customer_name, 
    s2.product_name,
    s2.category,
    count(distinct s1.category) as 공통구매카테고리수,
    group_concat(distinct s1.category ORDER BY s1.category) as 공통카테고리
-- 1번 손님의 구매 데이터
from customers c1
inner join sales s1 on c1.customer_id=s1.customer_id
-- 2번 손님의 구매 데이터
inner join customers c2 on c1.customer_id < c2.customer_id -- 1번 손님과 다른사람 (2번)을 고르는 중
inner join sales s2 on c2.customer_id=s2.customer_id -- 2번 의 구매 데이터
	and s1.category=s2.category
group by c1.customer_id, c1.customer_name, c2.customer_id, c2.customer_name
order by 공통구매카테고리수 desc;

SELECT
  c1.customer_name AS 고객1,
  c2.customer_name AS 고객2,
  COUNT(DISTINCT s1.category) AS 공통구매카테고리수,
  GROUP_CONCAT(DISTINCT s1.category ORDER BY s1.category) AS 공통구매카테고리-- 정렬 추가
FROM customers AS c1
JOIN sales AS s1 ON c1.customer_id = s1.customer_id
JOIN customers AS c2 ON c1.customer_id < c2.customer_id
JOIN sales AS s2 ON c2.customer_id = s2.customer_id
  AND s1.category = s2.category -- 이 조건이 두 고객이 공통 카테고리를 구매했음을 필터링합니다.
GROUP BY
  c1.customer_id,
  c1.customer_name,
  c2.customer_id,
  c2.customer_name
ORDER BY
  공통구매카테고리수 DESC;
  