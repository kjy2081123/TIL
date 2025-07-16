use practice;
show tables ;
select *from userinfo;
alter table userinfo add column age int default 20;
update userinfo set age=30 where id between 28 and 33;
select * from userinfo order by nickname asc ;
select * from userinfo  where email like '%@gmail.com' order by age asc ;

-- 나이 많은 사람중 폰번 오름차순 3명의 이름. 폰번, 나이만 확인
select nickname, age, phone
from userinfo
order by age desc, phone
limit 3 ;
select * from userinfo order by age asc ;
-- 이름 오름차순, 가장 이름이 빠른 사람 한명 제외하고 3명만 조회
select * from userinfo order by nickname limit 3 offset 1; -- -> 페이지네이션
