use practice;
create table sales as select * from lecture.sales;
create table products as select * from lecture.products;
select * from products;
select * from sales;
-- 평균 이상의 매출을 기록한 주문들
select avg(total_amount) from sales;
select * from sales
 where total_amount > (select avg(total_amount) from sales);
 
 -- 최고 매출 지역/의 모든 주문들
select region
from sales
group by region
order by SUM(total_amount) 
desc limit 1;

select 
customer_id, 
product_id, 
product_name, 
category, 
quantity,
unit_price,
total_amount,
sales_rep,
region
from sales
WHERE
    id IN (SELECT id FROM sales WHERE region = '대구');

-- 재고부족(50개) 제품/의 매출 내역
select product_id from products
where stock_quantity<50;

select  
product_id,
product_name,
category
from sales
where product_name in (select product_name from products where stock_quantity < 50);

-- 상위 3개 매출 지역의 주문들
select region, format(SUM(total_amount),0) as 지역총매출
from sales
group by region
order by 지역총매출 desc
limit 3;

select 
customer_id, 
product_id, 
product_name, 
category, 
quantity,
unit_price,
total_amount,
sales_rep,
region
from sales
WHERE region IN ('대구', '인천', '부산');

-- 상반기(1/1~6/30)에 주문/한 고객들의 하반기(7/1~12/31)의 주문내역
SELECT DISTINCT customer_id
FROM sales
WHERE mONTH(order_date) BETWEEN 1 AND 6;

SELECT
    id,
    order_date,
    customer_id,
    product_id,
    product_name,
    category,
    quantity,
    unit_price,
    total_amount,
    sales_rep,
    region
FROM sales
WHERE customer_id IN (
        SELECT DISTINCT customer_id
        FROM sales
        WHERE MONTH(order_date) BETWEEN 1 AND 6
    )
    AND MONTH(order_date) BETWEEN 7 AND 12
    order by customer_id, order_date;