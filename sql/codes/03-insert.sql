use lecture;
desc members;
-- 데이터 입력(create)
insert into members (name, email) values('권주용','k@a.com'); -- insert와 values의 순서 맞춰주기
insert into members (name, email) values('김김김','2@a.com'); 
insert into members (email,name) values('y@a.com','양양양'), ('p@a.com', '박박박'); -- 여러데이터 삽입시 순서 잘 맞출것

-- 데이터 확인(read)/전체에서
select * from members;

-- 단일 데이터 조회
select * from members where id=1; 