-- 별명 길이 확인

-- 별명 과 email 을 '-' 로 합쳐서 info (가상)컬럼으로 확인해 보기

-- 별명 은 모두 대문자로, email은 모두 소문자로 확인

-- email 에서 gmail.com 을 naver.com 으로 모두 new_email 컬럼으로 추출

-- email 앞에 붙은 단어만 username 컬럼 으로 확인  ->@ 앞에 붙어있는 것들만 보이게 한다.
-- (추가 과제 -> email 이 NULL 인 경우 'No Mail' 이라고 표시

use practice;
desc userinfo;
select * from userinfo;
select *from userinfo;
select nickname, char_length(nickname) as '글자 수' from userinfo;
select concat(nickname, '-', email) as info from userinfo;
select 
    upper(nickname) as UN,
    lower(email) as LN
from userinfo;
select replace (email, 'gmail.com','naver.com') as new_email from userinfo;
select locate('@',email) as username from userinfo;
select
	substring(
		email,1, locate('@',email) -1) as username from userinfo;  -- @앞에적혀있는것들만 추출한다

select
	email, case when email is not null
    then substring(email,1, locate('@',email)-1)
    else 'NO Mail' end as username
from userinfo;


select nickname, char_length(nickname) as '글자 수' from userinfo;
select concat(nickname,'-',email) as info from userinfo;
select 
	upper(nickname) as UN,
    lower(email) as LN
from userinfo;
select replace(email, 'gmail.com','naver.com') as new_email from userinfo;
select 
	substring( -- 추출함수
    email,1, locate('@',email) -1) as username from userinfo;
select
	email, case when email is not null
    then substring(email,1,locate('@',email)-1)
    else 'NO mail' end as username
from userinfo;

