use practice;
select * from userinfo;
insert into userinfo (nickname, phone, email) values
('안철수', '01112345378', 'kim@test.com'),
('이영희', NULL, 'lee@gmail.com'),
('박민수', '01612345637', NULL),
('최영수', '01745367894', 'choi@naver.com') ;
select * from userinfo where id >3; 
select * from userinfo where phone like '010__%';
select * from userinfo where nickname like '%수';
select * from userinfo  where email like '@gmail.com' or email like '%naver.com';
select * from userinfo where nickname in('안철수','박민수');
select * from userinfo where email is null;
select * from userinfo where phone like '010%';
-- 이름에 '??'가 있고, 폰번호 010, gmail 쓰는 사람
select * from userinfo where nickname Like '%e%' and
phone like '010%' and
email like '%gmail.com' ;
-- 성 김/이 중 하나, 지메일씀
select * from userinfo where 
nickname like '안%' OR
nickname like '이%' 
and email like '%gmail.com' ;

alter table userinfo add column grade varchar(1) default 'b';
update userinfo set grade ='a' where id between 28 and 30 ;
update userinfo set grade ='c' where id between 34 and 36 ;

-- 다중 컬럼 정렬 -> 앞에 말한게 우선정렬
select * from userinfo order by
age asc,
grade desc;
