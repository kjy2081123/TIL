-- 인덱스 조회
select
	tablename,
	indexname,
	indexdef
from pg_indexes
where tablename in ('large_orders','large_customers');

analyze large_orders;
analyze large_customers;

--실제 운영에서는 사용x(캐시날리기)
select pg_stat_reset();

explain analyze
select * from large_orders
where customer_id= 'cust-25000.'; --36504/executime: 736.059ms


explain analyze
select * from large_orders 
where amount between 800000 and 1000000; --46296/704.371ms

explain analyze 
select * from large_orders
where region ='서울'and amount >500000 and order_date> '2024-07-08'; --38587/779.279ms

explain analyze
select * from large_orders
where region='서울'
order by amount desc
limit 100; --36504/694.664ms

create index idx_orders_customer_id on large_orders(customer_id);
create index idx_orders_amount on large_orders(amount);
create index idx_orders_region on large_orders(region);

explain analyze
select* from large_orders
where customer_id='cust-10524.'; -- 87/ 0.118ms

explain analyze
select * from large_orders 
where amount between 800000 and 1000000; --39469/1102.064ms

explain analyze
select count(*) from large_orders where region='서울'; -- 3459/34.600ms

explain analyze
select* from large_orders
where region='서울' and amount>800000; --1834ms

create index idx_orders_region_amount on large_orders(region,amount);

explain analyze
select*from large_orders
where region='서울' and amount>800000; -- 723/580.510ms

create index idx_orders_id_date on large_orders(customer_id,order_date);
explain analyze
select * from large_orders
where customer_id= 'cust-25000.' --0.118ms
	and order_date>='2024-07-01'
order by order_date desc;

-- 복합인덱스 순서의 중요도
CREATE INDEX idx_orders_region_amount ON large_orders(region, amount);
CREATE INDEX idx_orders_amount_region ON large_orders(amount, region);

SELECT 
    indexname,
    pg_size_pretty(pg_relation_size(indexname::regclass)) AS index_size
FROM pg_indexes 
WHERE tablename = 'large_orders' 
  AND indexname LIKE '%region%amount%' OR indexname LIKE '%amount%region%'
ORDER BY indexname;



-- 인덱스 순서 가이드라인
-- 고유값 비율
select 
	count(distinct region) as 고유지역수,
	count(*) as 전체행수,
	round(count(distinct region)*100/count(*),2) as 선택도
from large_orders;

select 
	count(distinct amount) as 고유금액수,
	count(*) as 전체행수
from large_orders;

select
	count(distinct customer_id) as 고유고객수,
	count(*) as 전체행수
from large_orders; -- 선택도 5%