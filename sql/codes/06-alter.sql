use lecture;
desc members;
-- alter=table schemas 변경
-- 컬럼 추가
alter table members add column age int not null default 20;
alter table members add column address varchar(100) default '미입력';
-- 컬럼 이름+데이터 타입 수정
alter table members change column address juso varchar(100);

-- 컬럼 데이터 타입 수정
alter table members modify column juso varchar(50);
-- 컬럼 삭제
alter table members drop column age;
select * from members;