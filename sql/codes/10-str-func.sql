use lecture;
-- 길이
select length('hello sql');
select name, char_length (name) as 이름길이 from dt_demo;

-- 연결
select concat('hello','sql','!');
select concat(name, '(', score, ')') as info from dt_demo;

-- 대소문자변환

select 
	nickname,
	upper(nickname) as UN,
    lower(nickname) as LN
from dt_demo ; 

-- 부분문자열 추출
select substring('hello sql!', 2,4) ;
select left('hello sql!',5);
select right('hello sql!',5);
select
	description,
    concat(
		substring(description,1,5), '...'
	) as intro,
	concat(
		left(description,3),
        '...',
        right(description,3)
	) as summary
from dt_demo;

-- 문자열 치환
select replace ('a@test.com', 'test.com', 'gmail.com');
select
	description,
	replace(description, '학생', '**') as secret
from dt_demo;
-- 

