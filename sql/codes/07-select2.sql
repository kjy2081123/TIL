-- select 컬럼 from 테이블 where 조건 order by 정렬기준 limit 개수

use lecture; 
create table students (
	id int auto_increment primary key,
    name varchar (20),
    age int
    );
desc students;
insert into students (name, age) values
('kwon',29),
('park',19),
('lee',39),
('woo',28),
('kwak',17),
('woo',15),
('yoon',49),
('yeon',67),
('kim',97),
('hong',88);


select * from  students;
desc students;
select * from students where name='hong';
select * from studetns where age >= 17;
select * from students where id <>2 ;
select * from students where id != 2 ;
select * from students where age between 20 and 50;

-- 문자열패턴(% ->있을수도 없을수도 ->정환히 개수만큼 있음.)
-- 홍씨만 찾기
select * from students where name like 'hong%';
-- '윤' 글자가 들어가는 사람 ->윤으로 시작하는 사람
select * from students where name like 'yoon%';
-- 이름이 한글자인 이씨
select * from students where name like 'lee';

-- 테이블 구조 변경
