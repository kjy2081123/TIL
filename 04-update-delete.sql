select * from members;
update members set name= '임임임', email= 'im@3.com' where id=4; -- 이름이 같으면 모두 수정될 가능성이 있음.

-- delete (삭제)/ 모든 데이터의 삭제도 가능
delete  from members where id=3;