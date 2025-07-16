use lecture;

-- vip 고객 구매내역 조회(이름,유형,상품명,카테고리,주문금액)
select
	*,
	(select customer_type from customers c where s.customer_id=c.customer_id) as 등급
from sales s;
-- where type='VIP';
select
	*
    from customers c
    inner join sales s on c.customer_id=s.customer_id
    where c.customer_type='VIP';
    
    -- 각 등급별 구매액 평균
    select 
    c.customer_type as 고객유형,
    format(avg(s.total_amount),0) as 매출총액평균
    from customers c
    inner join sales s on c.customer_id=s.customer_id
    group by c.customer_type;
    
    
    
    select
		*,
        (select customer_type from customers c where s.customer_id=c.customer_id) as 고객등급
	from sales s;
    
    select
    c.customer_type as 고객유형,
    format(avg(s.total_amount),0) as 매출총액평균
    from customers c
    inner join sales s on c.customer_id=s.customer_id
    group by 고객유형;
		