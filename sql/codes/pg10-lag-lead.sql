-- lag: 이전값을 가져옴
with monthly_sales as (
	select
		date_trunc('month',order_date)as 월,
		sum(amount) as 월매출
	from orders
	group by 월 
)
select
	to_char(월,'yyyy-mm')as 년월,
	월매출,
	lag(월매출,1) over(order by 월) as 전월매출,
	월매출 - lag(월매출,1) over(order by 월) as 증감액,
	case
		when lag(월매출,1) over(order by 월) is null then null
		else round(
		(월매출-lag(월매출,1) over(order by 월))*100/ lag(월매출,1) over(order by 월)
		,2) 
	end as 증감률
from monthly_sales
order by 월;

select* from orders;


-- 고객별 다음구매 예측 // 고객별 파티션사용
(customerid,/주문일,다음구매일,구매주기(일수),차기구매금액,차기구매액수와의 최근구매액간 금액차이)
-- order by customer_id, order_date limit 10;

select
customer_id as 고객id,
order_date as 주문일,
lead(order_date,1) over (partition by customer_id order by order_date) as 다음구매일, 
(lead(order_date,1) over (partition by customer_id order by order_date) - order_date) as 구매간격,
lead(amount,1) over (partition by customer_id order by  order_date) as 차기구매금액,
lead(amount,1) over (partition by customer_id order by  order_date) - amount as 차기구매금액과의차이
from orders
where customer_id='CUST-000001'
order by customer_id, order_date limit 10;



-- (고객id,주문일,금액,구매순서(row_number))
-- 이전구매간격, 다음구매간격
-- 금액변화= 이번구매-종전구매
-- 누적구매금액(sum over)
-- 누적평균구매금액(avg over)

select
row_number() over (partition by customer_id order by order_date) as 구매순서,
customer_id as 고객id,
order_date as 주문일,
amount as 주문액,
(order_date-lag(order_date,1)over(partition by customer_id order by order_date)) as 이전구매와의간격,
lead(order_date,1) over (partition by customer_id order by order_date) as 다음구매일, 
(lead(order_date,1) over (partition by customer_id order by order_date) - order_date) as 다음구매와의간격,
lead(amount,1) over (partition by customer_id order by  order_date) as 차기구매금액,
(amount-lag(amount,1)over (partition by customer_id order by  order_date)) as 종전구매금액과의차이,
lead(amount,1) over (partition by customer_id order by  order_date) - amount as 차기구매금액과의차이,
sum(amount) over (partition by customer_id order by  order_date) as 누적구매금액,
avg(amount) over (partition by customer_id order by  order_date) as  누적구매금액의평균
from orders
order by customer_id, order_date limit 10;