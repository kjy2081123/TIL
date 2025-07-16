-- data structures(graph,tree,list,hash..)

-- b-tree 인덱스 생성
create index<index_name> on<tabl_name> (<col_name>)
--범위검색 between, >,<
--정렬 order by
--부분일치 like

-- hash index
create index<index_name> on <table_name> using hash(<col>)
-- 정확한 일치 검색 = 
-- 범위x,정렬x

-- 부분 인덱스
create index <index_name> on <table_name>(<col_name>)
where 조건 = 'blah'

-- 특정 조건의 데이터만 자주검색
-- 공간/비용 절약

-- 인덱스를 사용하지 않음
select * from users where upper (name) = 'john' -- 함수 쓰인경우
select * from users where age='25' -- age는 숫자인데 문자를 넣음
select * from users like ='%김' -- like -> 앞쪽 와일드카드 쓰면 안씀
select * from users where age !=25 -- 부정조건인 경우

-- 해결방법= 인덱스를 쓰는법
create index<name> on users(upper(name)) -- 함수기반 인덱싱
--타입 잘쓰기(문자->숫자)
--전체 텍스트 검색 인덱스 고려
select * from users where age <25 or age >25; -- 부정조건을 범위조건으로 변환

--인덱스는 무조건 필요한가? ->검색성능은 오르나 저장공간을 잡아먹음/수정성능 감소
-- 실제 쿼리 패턴을 분석 -> 인덱스 설계
-- 성능 측정 => 실제 데이터