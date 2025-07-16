-- 모든 고객 목록 조회
--고객의 customer_id, first_name, last_name, country를 조회하고, customer_id 오름차순으로 정렬하세요.
select * from customers;
select
 customer_id,
 first_name,
 last_name,
 country
from customers
group by customer_id
order by customer_id asc;

-- 모든 앨범과 해당 아티스트 이름 출력
-- 각 앨범의 title과 해당 아티스트의 name을 출력하고, 앨범 제목 기준 오름차순 정렬하세요.

select * from albums;
select * from artists;
select 
	al.title,
	ar.name
from albums as al
join artists as ar on al.artist_id=ar.artist_id
order by al.title asc;

-- 트랙(곡)별 단가와 재생 시간 조회
-- tracks 테이블에서 각 곡의 name, unit_price, milliseconds를 조회하세요.
-- 5분(300,000 milliseconds) 이상인 곡만 출력하세요.
select * from tracks;
select * from playlist_track;
select
	name, 
	unit_price,
	milliseconds
from tracks
where milliseconds >=300000;


-- 국가별 고객 수 집계
-- 각 국가(country)별로 고객 수를 집계하고, 고객 수가 많은 순서대로 정렬하세요
select 
	country as 국가,
	count(customer_id) as 국가별고객수
from customers
group by country
order by 국가별고객수 desc;

-- 각 장르별 트랙 수 집계
-- 각 장르(genres.name)별로 트랙 수를 집계하고, 트랙 수 내림차순으로 정렬하세요.
select * from genres;
select * from tracks;
select * from playlist_track;
select
	g.name as 장르이름,
	count(t.track_id) as 트랙수
from genres as g
join tracks as t on g.genre_id=t.genre_id
group by g.name
order by 트랙수 desc;
