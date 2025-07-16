use lecture;
drop table dt_demo;
create table dt_demo (
	id int AUTO_INCREMENT primary key,
    name varchar(20) not null,
    nickname varchar(20),
    birth date,
    score float,
    salary decimal,
    description text,
    is_active bool default true,
    created_at datetime default current_timestamp
);
desc dt_demo;

INSERT INTO dt_demo (name, nickname, birth, score, salary, description) 
VALUES 
('김철수', 'kim', '1995-01-01', 88.75, 3500000.50, '우수한 학생입니다.'),
('이영희', 'lee', '1990-05-15', 92.30, 4200000.00, '성실하고 열심히 공부합니다.'),
('박민수', 'park', '1988-09-09', 75.80, 2800000.75, '기타 사항 없음'),
('권주용', 'kwon', '1997-07-07', 88.92, 360000, '학생'); 
show tables;
select * from dt_demo;
select * from dt_demo where score >= '80'; -- 80점 이상 조회
select * from dt_demo where description not like '%학생%'; -- %%는 무슨뜻인가?
select * from dt_demo where birth <'2000-01-01';

