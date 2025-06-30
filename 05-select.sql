use lecture;
select * from members; -- 모든 칼럼, 모든 조건
select * from members where id=3; -- 모든 칼럼, id
-- 이름| 이메일, 모든 조건ALTER
select name, email from members;
select name from members where name= '권주용'; -- 이름& 이름조건