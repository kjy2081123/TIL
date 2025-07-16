use practice;

drop table sales;
drop table products;
drop table customers;
create table sales as select *from lecture.sales;
create table products as select*from lecture.products;
create table customers as select * from lecture.customers;
select count(*) from sales
union
select count(*) from customers;

select * from products;
select * from sales;
select * from customers;

-- 주문 거래액이 가장 높은 10건을 높은순으로 고객이름, 상품명, 주문금액
SELECT
    c.customer_name as 고객명,
    s.product_name as 상품명,
    s.total_amount as 주문금액
from customers c
inner join
    sales s ON c.customer_id = s.customer_id
ORDER BY
    s.total_amount DESC
LIMIT 10;

-- 고객 정보(등급,건수 평균 주문금액)을 평균 주문금액이 높은 순서대로 나타내자
select 
c.customer_type as 고객유형,
count(*) as 주문건수,
format(avg(s.total_amount),0) as 평균주문액
from customers c
inner join sales s on c.customer_id=s.customer_id
group by c.customer_type;

-- 모든 고객의 이름과 구매한 상품명
select 
c.customer_name as 고객명,
coalesce(s.product_name,'없음') as 상품명
from customers c
left join sales s on c.customer_id=s.customer_id
order by c.customer_name;
-- 고객 정보와 주문 정보를 모두 포함한 조회
select 
c.customer_name as 고객명,
c.customer_type as 고객등급,
c.join_date as 가입일,
s.product_name as 상품명,
s.order_Date as 주문일
from customers c
inner join sales s on c.customer_id=s.customer_id
order by 주문일 desc;

-- vip 고객들의 구매내역만 조회
select 
	*
from customers C 
inner join sales s on c.customer_id=s.customer_id
where c.customer_type='vip'
order by s.total_amount desc;

-- 건당 50만원 이상 주문한 기업 고객들 리스트
select DISTINCT
c.customer_id as 고객id,
c.customer_name as 고객명,
c.customer_type as 고객유형,
s.total_amount as 주문액
from customers c
inner join sales s on c.customer_id=s.customer_id
where c.customer_type= '기업' and s.total_amount>= 500000
order by s.total_amount desc;

-- 2024 하반기 전자제품 구매내역
select
*
from customers c
inner join sales s on c.customer_id=s.customer_id
where s.category= '전자제품' and  month (s.order_date) between 7 and 12;

-- 고객별 주문 통계 (INNER JOIN) [고객명, 유형, 주문횟수, 총구매, 평균구매, 최근주문일]
select
c.customer_id as 고객id,
c.customer_name as 고객명,
c.customer_type as 고객유형,
count(s.id) as 구매횟수,
format(sum(s.total_amount),0) as 총구매액,
format(avg(s.total_amount),0) as 평균구매액,
max(s.order_date) as 최근주문일
from customers c
inner join sales s on c.customer_id=s.customer_id
group by c.customer_id,c.customer_name,c.customer_type
order by 총구매액 desc;

-- 모든 고객의 주문 통계 (LEFT JOIN) - 주문 없는 고객도 포함
select
c.customer_id as 고객id,
c.customer_name as 고객명,
c.customer_type as 고객유형,
count(s.id) as 구매횟수,
coalesce(format(sum(s.total_amount),0,0)) as 총구매액,
coalesce(format(avg(s.total_amount),0,0)) as 평균구매액,
coalesce(format(max(s.total_amount),0,0)) as 최대구매액,
max(s.order_date) as 최근주문일,
c.join_date as 가입일
from customers c
left join sales s on c.customer_id=s.customer_id
group by c.customer_id,c.customer_name,c.customer_type,c.join_date
order by 총구매액 desc;

-- 상품 카테고리별로 고객유형분석
select 
s. category as 카테고리,
count(*) as 구매횟수,
c.customer_type as 고객유형,
s.product_name as 상품명
from customers c
inner join sales s on c.customer_id=s.customer_id
group by s.category,c.customer_type;

SELECT
  c.customer_type AS 유형,
  s.category AS 카테고리,
  COUNT(*) AS 주문건수,
  SUM(s.total_amount) AS 총매출액
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
GROUP BY s.category, c.customer_type;



-- 문제 9: 고객별 등급 분류
-- 활동등급(구매횟수) : [0(잠재고객) < 브론즈 < 3 <= 실버 < 5 <= 골드 < 10 <= 플래티넘]
-- 구매등급(구매총액) : [0(신규) < 일반 <= 10만 < 우수 <= 20만 < 최우수 < 50만 <= 로얄]

select
c.customer_id as 고객id,
c.customer_name as 고객명,
c.customer_type as 고객유형,
count(s.id) as 구매횟수, -- left join일 경우 s.id가 좋음
coalesce(format(sum(s.total_amount),0),'0') as 총구매액,
case
	when count(s.id)=0 then'잠재고객'
    when count(s.id)>=10 then '플래티넘'
    when count(s.id)>=5 then'골드'
	when count(s.id)>=3 then '실버'
    else '브론즈'
    
end as 활동등급,
case
	when coalesce(sum(s.total_amount),0)>=500000 then 'vip+'
    when coalesce(sum(s.total_amount),0)>=200000 then 'vip'
    when coalesce(sum(s.total_amount),0)>=100000 then '우수'
	when coalesce(sum(s.total_amount),0)> 0 then '일반'
    else '신규'
end as 구매등급
from customers c
    left join sales s on c.customer_id=s.customer_id
    group by c.customer_id, c.customer_name, c.customer_type;
    
    SELECT
  c.customer_id, c.customer_name, c.customer_type,
  COUNT(s.id) AS 구매횟수,
  coalesce(SUM(s.total_amount), 0) AS 총구매액,
  CASE
    WHEN COUNT(s.id) = 0 THEN '잠재고객'
    WHEN COUNT(s.id) >= 10 THEN '플래티넘'
    WHEN COUNT(s.id) >= 5 THEN '골드'
    WHEN COUNT(s.id) >= 3 THEN '실버'
    ELSE '브론즈'
  END AS 활동등급,
  CASE
    WHEN COALESCE(SUM(s.total_amount), 0) >= 5000000 THEN 'VIP+'
    WHEN COALESCE(SUM(s.total_amount), 0) >= 2000000 THEN 'VIP'
    WHEN COALESCE(SUM(s.total_amount), 0) >= 1000000 THEN '우수'
    WHEN COALESCE(SUM(s.total_amount), 0) > 0 THEN '일반'
    ELSE '신규'
  END AS 구매등급
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_type;

SELECT
    c.customer_id AS 고객id,
    c.customer_name AS 고객명,
    c.customer_type AS 고객유형,
    COUNT(s.id) AS 구매횟수, -- LEFT JOIN일 경우 s.id가 NULL이면 COUNT되지 않으므로 0으로 나옴
    COALESCE(FORMAT(SUM(s.total_amount), 0), '0') AS 총구매액, -- FORMAT 결과는 문자열이므로 COALESCE 두번째 인자도 문자열 '0'이 더 적절
    CASE
        WHEN COUNT(s.id) = 0 THEN '잠재고객' -- 수정: COUNT(s.id)=0 AND THEN 키워드 추가
        WHEN COUNT(s.id) >= 10 THEN '플래티넘' -- 수정: THEN 키워드 추가
        WHEN COUNT(s.id) >= 5 THEN '골드'     -- 수정: THEN 키워드 추가
        WHEN COUNT(s.id) >= 3 THEN '실버'     -- 수정: THEN 키워드 추가
        ELSE '브론즈'
    END AS 활동등급,
    CASE
        WHEN COALESCE(SUM(s.total_amount), 0) >= 500000 THEN 'vip+'
        WHEN COALESCE(SUM(s.total_amount), 0) >= 200000 THEN 'vip'
        WHEN COALESCE(SUM(s.total_amount), 0) >= 100000 THEN '우수'
        WHEN COALESCE(SUM(s.total_amount), 0) > 0 THEN '일반'
        ELSE '신규'
    END AS 구매등급
FROM
    customers c
LEFT JOIN
    sales s ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id, c.customer_name, c.customer_type;
    
-- 문제 10: 활성 고객 분석
-- 고객상태(최종구매일) [NULL(구매없음) | 활성고객 <= 30 < 관심고객 <= 90 < 휴면고객]별로
-- 고객수, 총주문건수, 총매출액, 평균주문금액 분석 

select 
	c.customer_id as 고객id,
    c.customer_name as 고객이름,
    count(s.id) as 총주문건수,
    coalesce(format(sum(total_amount),0)) as 총매출액,
    coalesce(format(avg(total_amount),0)) as 평균매출액,
case
	when max(order_date) is null '구매없음'
    when datediff('2024-12-31',max(s.order_date)) <=30 then '활성고객'
    when datediff('2024-12-31',max(s.order_date)) <=90 then '관심고객'
    else '휴면고객'
end as 고객상태
from customers c
left join sales s on c.customer_id=s.customer_id
group by c.customer_id, c.customer_name
) as customer_analysis
group by 고객상태 ;

