-- any: 여러 값들 중 하나라도 만족하면 true(or)
-- vip 고객들의 최소주문액보다 높은 모든 주문
select s.total_amount
from sales s
inner join customers c on s.customer_id=c.customer_id
where c.customer_type= 'vip';


select 
	customer_id,
    product_name,
    total_amount,
    '일반 고객이지만 vip 최소보다 높음' as 구분
from sales
where total_amount> any (
-- vip들의 모든 주문금액들(vector)
	select s.total_amount
    from sales s
    inner join customers c on s.customer_id=c.customer_id
    where c.customer_type='vip'
    ) and
customer_id not in (select customer_id from customers where customer_type = 'vip')
order by total_amount desc;


select 
	customer_id,
    product_name,
    total_amount,
    '일반 고객이지만 vip 최소보다 높음' as 구분
from sales
where total_amount> (
	select min(s.total_amount) from sales s
    inner join customers c on s.customer_id=c.customer_id
    where c.customer_type='vip'
    ) and
customer_id not in (select customer_id from customers where customer_type = 'vip')
order by total_amount desc;

-- 어떤 지역 평균 매출액보다도 주문금액이 높은 주문들
select * from sales;
select 
	region,
    product_name,
    total_amount,
    '어떤 지역의 평균 매출액보다도 높은 주문들' as 구분
from sales s
where total_amount> any( -- 2. ~보다 하나라도 더 크면 만족
	-- 각 지역별 평균 매출액
	select avg(total_amount) from sales s
    group by region
)
order by total_amount desc;


-- all : 벡터의 모든 값들이 조건을 만족해야함.
-- 모든 부서의 평균연봉보다높은 연봉을 받는 사람
select *
from employees
where salary > all (
	select avg(salary)
    from employees
    group by departmend_id
);
