use lecture;
select
*,
(
	select customer_name from customers C
    where c.customer_id=s.customer_id
) as 주문고객이름,
(
	select customer_type from customers c
    where c.customer_id=s.customer_id
) as 고객등급
from sales s;

-- join -> customer+sales
select 
	*
from customers C inner join sales s on c.customer_id= s.customer_id
where s.total_amount >=500000
order by s.total_amount desc;

-- 모든 고객의 구매 현황 분석(구매이력 없어도 해보자) -> customer+sales표의 형태로
select
c.customer_id,
c.customer_name,
c.customer_type,
count(c.customer_id) as 주문횟수,
format(sum(s.total_amount),0) as 총구매액
from customers C
-- left join-> 왼쪽 테이블의 모든데이터와+ 공통되는 오른쪽 데이터| 공통되는 데이터가 존재하지 않아도 나타남.
left join sales s on c.customer_id = s.customer_id
group by c.customer_id, c.customer_name, c.customer_type;

-- where s.id is null; -- 한번도 주문을 안한 유저목록


select 
c.customer_id,
c.customer_name,
c.customer_type,
count(s.id) as 구매건수,
coalesce(format(sum(s.total_amount),0),0) as 총구매액,
coalesce(format(avg(s.total_amount),0),0) as 평균구매액,
case -- count(*): 구매건수
	when count(s.id)= 0 then '잠재고객'
    when count(s.id)>= 5 then '충성고객'
    when count(s.id)>=3 then '일반고객'
    else '신규고객'
end as 활성도
from customers C
left join sales s on c.customer_id=s.customer_id
group by c.customer_id;

use lecture;
select
	*
from customers c inner join sales s on c.customer_id= s.customer_id
where s.total_amount >= 500000
order by s.total_amount desc;


insert into sales(id,order_date,product_name,category,customer_id,product_id,quantity) 
values(121,'2025-07-04','건전지','전자제품','illusion','o0878',35);

-- left join -왼쪽( from 뒤에 온)테이블은 모두 나옴
select 
'2.left join' as 구분,
count(*) as 줄수,
count(*) as 고객수
from customer c
left join sales s on c.customer_id=s.customer_id;


-- inner join= 교집합
select 
 '1. inner join' as 구분,
count(*) as 줄수,
count(distinct c.customer_id) as 고객수
from customers c
inner join sales s on c.customer_id= s.customer_id
union 
select 
 '2. left join' as 구분,
count(*) as 줄수,
count(distinct c.customer_id) as 고객수
from customers c	
inner join sales s on c.customer_id= s.customer_id
union

SELECT
  '3. 전체 고객수' AS 구분,
  COUNT(*) AS 행수,
  COUNT(*) AS 고객수
FROM customers;


