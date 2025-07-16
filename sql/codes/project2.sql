-- 직원별 담당 고객 수 집계
--각 직원(employee_id, first_name, last_name)이 담당하는 고객 수를 집계하세요.
-- 고객이 한 명도 없는 직원도 모두 포함하고, 고객 수 내림차순으로 정렬하세요.
select * from employees;
select * from customers;
select * from invoices;

select 
	e.employee_id as 직원id,
	e.first_name,
	e.last_name,
	count(customer_id) as 고객수
from employees as e
left join customers as c on e.employee_id=c.support_rep_id
group by e.employee_id, e.first_name,e.last_name
order by 
	고객수 desc,
	e.employee_id asc;

-- 가장 많이 팔린 트랙 TOP 5
-- 판매량(구매된 수량)이 가장 많은 트랙 5개(track_id, name, 총 판매수량)를 출력하세요.
-- 동일 판매수량일 경우 트랙 이름 오름차순 정렬하세요.
select * from tracks;
select* from invoices;
select * from invoice_items;
select
	t.track_id as 트랙id,
	t.name as 트랙이름,
	sum(ii.quantity) as 판매수량
from invoice_items as ii
left join tracks as t on t.track_id=ii.track_id
group by t.track_id, t.name
order by 
	판매수량 desc,
	t.name asc;	


-- 2020년 이전에 가입한 고객 목록
-- 2020년 1월 1일 이전에 첫 인보이스를 발행한 고객의 customer_id, first_name, last_name, 첫구매일을 조회하세요.

select * from customers;
select * from invoices;

select
	c.customer_id as 고객id,
	c.first_name, 
	c.last_name,
	min(i.invoice_date) as 첫구매일
from customers as c
join invoices as i on c.customer_id=i.customer_id
where i.invoice_date<'2020-01-01'
group by c.customer_id, c.first_name, c.last_name
order by 첫구매일 asc;


-- 국가별 총 매출 집계 (상위 10개 국가)
-- 국가(billing_country)별 총 매출을 집계해, 매출이 많은 상위 10개 국가의 국가명과 총 매출을 출력하세요.
select * from customers;
select * from invoices;
select * from invoice_items;	
select	
	i.billing_country as 국가,
	sum(ii.unit_price*ii.quantity) as 총매출
from invoices as i
join invoice_items as ii on i.invoice_id=ii.invoice_id
group by i.billing_country
order by 총매출 desc;


-- 각 고객의 최근 구매 내역
-- 각 고객별로 가장 최근 인보이스(invoice_id, invoice_date, total) 정보를 출력하세요.
select 
	customer_id,
	invoice_id,
	invoice_date,
	total
from (
	select
		c.customer_id,
		i.invoice_id,
		i.invoice_date,
		i.total,
		row_number() over (partition by c.customer_id order by i.invoice_date desc) as rn
	from customers as c	
join invoices as i on c.customer_id=i.customer_id
) as subquerry 
where rn=1;
	