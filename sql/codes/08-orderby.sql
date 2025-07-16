use lecture;
-- 특정 컬럼 기준으로 정렬함
-- asc/desc
select * from members;
-- 이름 가나다순
select * from members order by juso; 
select * from members order by name asc ;
select * from members order by name desc ;   

-- 다중 컬럼 정렬 -> 앞에 말한게 우선정렬
select * from userinfo order by
age asc,
grade desc;