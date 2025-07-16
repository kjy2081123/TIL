use lecture;
select 
	name, 
    score as 원점수,
    round(score) as 반올림,
    round(score, 1) as 소수1반올림,
    ceil(score) as 올림,
    floor(score) as 내림,
    truncate(score, 1) as 소수1버림
from dt_demo;

-- 사칙연산
select
	10+5 as plus,
    10-5 as minus,
    10*5 as multiply,
    10/5 as divide,
    10 div 3 as 몫,
    10 % 3 as 나머지, 
    mod(10,3) as 나머지2, -- modulo= 나머지
    power(10,3) as 거듭제곱, -- power = 거듭제곱
    sqrt(16) as 루트,
    abs(-10) as 절댓값;

-- 조건문 if, case
select
	name, score,
    if(score>=80, '우수','보통') as 평가
from dt_demo;

select
	id,name, 
    id % 2 as 나머지,
    case
		when id % 2= 0 then '짝수'
		else '홀수'
	end as 홀짝
from dt_demo;

select 
	name, 
    ifnull(score, 0) as 점수,
    case
		when score >= 90 then 'A'
        when score>= 70 and salary >= 3000000 then 'B+'
        when score >= 80 then 'B'
        when score >= 70 then 'c'
        when score>= 70 and salary <= 3000000 then 'B+'
        else 'D'
	end as 학점
from dt_demo;

-- select * from dt_demo;

insert into dt_demo(name) values ('이상한');