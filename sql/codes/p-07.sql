-- 종합 정보 표시
-- id
-- name
-- 닉네임 (NULL -> '미설정')
-- 출생년도 (19xx년생)
-- 나이 (TIMESTAMPDIFF 로 나이만 표시)
-- 점수 (소수 1자리 반올림, Null -> 0)
-- 등급 (A >= 90 / B >= 80 / C >= 70 / D)
-- 상태 (is_active 가 1 이면 '활성' / 0 '비활성')
-- 연령대 (청년 < 30 < 청장년 < 50 < 장년)
use practice;
create table dt_demo2 as select * from lecture.dt_demo;
select * from dt_demo2;
select
	id,
    name,
    ifnull(nickname, '미설정') as 닉네임,
    date_format(birth,'%Y년생') as 출생년도,
    timestampdiff(year,birth,curdate()) as 나이,
   coalesce(null,round (score,1),0) as 점수, -- null 이면 점수를 0으로 표기하고, 아니면 소수점 한자리까지만 기입함.
	CASE
		WHEN score >= 90 THEN 'A'
        WHEN score >= 80 THEN 'B'
        WHEN score >= 70 THEN 'C'
        else 'D'
	end as 등급,
    case
		when timestampdiff(year, birth, curdate()) < 30 then '청년'
        when timestampdiff(year, birth, curdate()) < 50 then '청년'
        else '장년'
	end as 연령대
from dt_demo2;

select coalesce(null,1,null); -- null이 아닌값을 표시할것
        
