explain
select* from large_customers where customer_type='vip';

select 10013*159/1024;

explain analyze
select * from large_customers where customer_type = 'vip';

-- seq scan: 인덱스 없고, 테이블 대부분의 행을 읽어야하고, 순차 스캔이 빠를때

-- explain의 다양한 옵션들(이 아래로 전부)
-- 버퍼 사용량 포함
explain (analyze,buffers)
select * from large_customers where loyalty_points>8000;

--verbose: 상세정보 포함 
explain (analyze,verbose,buffers)
select * from large_customers where loyalty_points>8000;

-- json 형태
explain (analyze,buffers,format json)
select * from large_customers where loyalty_points>8000;

-- 진단 
explain analyze
select 
	c.customer_name,
	count(o.order_id)
from large_customers c
left join large_orders o on c.customer_name = o.customer_id -- 잘못된 join 조건
group by c.customer_name;

-- 메모리 부족