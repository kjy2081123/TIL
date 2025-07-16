use lecture;
select * from dt_demo;

-- 현재 날짜/시간

select NOW() as 지금시간;
select current_timestamp();

-- 날짜
select curdate();

-- 시간
select curtime();
select current_time();

select 
	name,
    birth as 원본,
    date_format(birth, '%Y년 %m월 %d일') as 한국식, 
    date_format(birth, '%Y-%M') as 년월, 
    date_format(birth,'%M %d %Y') as  영미식, 
    date_format(birth, '%W') as 요일번호 , 
    date_format(birth, '%W' ) as 요일이름 
from dt_demo;

select 
	created_at as 원본시간,
    date_format(created_at, '%Y-%m-%d %H:%i') as 분까지만,
    date_format(created_at, '%p %h:%i')as 12시간
    from dt_demo;
    
-- 날짜 계산
select 
	name,
    birth,
    datediff(curdate(),birth) as 살아온날들,
    timestampdiff(year,birth, curdate()) 
    from dt_demo;
    
-- 더하기빼기
select 
	name, birth,
    date_add(birth, interval 100 day) as 백일후,
    date_add(birth, INTERVAL 1 YEAR) as 돌,
    date_sub(curdate(), interval 10 month) as 등장
from dt_demo;


-- 계정 생성후 경과 시간
select 
	name, created_at,
    timestampdiff(hour, created_at, NOW()) as 가입후시간,
    timestampdiff(day, created_at, NOW()) as 가입후일수 
from dt_demo ;


-- 날짜 추출
select
	name,birth,
    year(birth),
    month(birth),
    day(birth),
    dayofweek(birth) as 요일번호,
    quarter(birth) as 분기
from dt_demo;

-- 월별, 연도별
select
	year(birth) as 출생년도,
    count(*) as 인원수
from dt_demo
group by year(birth)
order by 출생년도;

select
	(year(birth


    
    