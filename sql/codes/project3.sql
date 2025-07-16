-- 월별 매출 및 전월 대비 증감률
-- 각 연월(YYYY-MM)별 총 매출과, 전월 대비 매출 증감률을 구하세요.
--결과는 연월 오름차순 정렬하세요.
select * from 
select* from playlist_track;
select * from invoice_items;
select * from invoices;
select * from customers;

-- 1. 연월별 총매출 / 2. 연월 매출 옆에 전월 매출 대비 /3. 증감률 표시
with monthlysales as (
	select 
		TO_CHAR(i.invoice_date, 'YYYY-MM') as 월별매출,
		sum(ii.unit_price*ii.quantity) as 월별총매출
	from invoices as i
	join invoice_items as ii on i.invoice_id=ii.invoice_id
	group by 월별매출
	order by 월별매출
),
monthlysaleswithprevious as (
	select 
		월별매출,
		월별총매출,
		lag(월별총매출,1,0) over(order by 월별매출) as 전월매출
	from monthlysales
)
select 
		월별매출,
		월별총매출,
		전월매출,
		ROUND(
        CASE
            WHEN 전월매출 = 0 THEN NULL
            ELSE (월별총매출 - 전월매출) * 100.0 / 전월매출
        END,
        2
    ) AS sales_growth_rate
from monthlysaleswithprevious
order by 월별매출 asc;


-- 장르별 상위 3개 아티스트 및 트랙 수
-- 각 장르별로 트랙 수가 가장 많은 상위 3명의 아티스트(artist_id, name, track_count)를 구하세요.
-- 동점일 경우 아티스트 이름 오름차순 정렬.

select * from genres;
select * from tracks;
select * from playlists;

--1. 아티스트별 트랙수 집계
with artisttrackcounts as (
	select 
		ar.artist_id as 아티스트id,
		ar.name as 아티스트이름,
		count(t.track_id) as 아티스트별트랙수
	from artists as ar
	join albums as al on ar.artist_id=al.artist_id
	join tracks as t on al.album_id=t.album_id
	group by 
		ar.artist_id,
		ar.names
),
--2단계: 장르별 아티스트의 트랙수
genreartisttrackcounts as (
 	select
	 	g.genre_id,
		g.name as 장르명,
		ar.artist_id as 아티스트id,
		ar.name as 아티스트명,
		count(t.track_id) as 장르내트랙수
	from
		genres as g
	join tracks as t on g.genre_id=t.genre_id
	join albums as al on t.album_id= al.album_id
	join artists as ar on al.artist_id=ar.artist_id
	group by 
		g.genre_id,
		장르명,
		아티스트id,
		아티스트명
),
rankedgenreartists as (

)


WITH GenreArtistTrackCounts AS (
    -- 1단계: 각 장르 내에서 아티스트별 트랙 수 집계
    -- 한 아티스트가 여러 장르의 곡을 가질 수 있으므로, 장르별로 다시 집계해야 함.
    SELECT
        g.genre_id,
        g.name AS 장르명,           -- 장르명 별칭 명확히 지정
        ar.artist_id AS 아티스트id, -- 아티스트id 별칭 명확히 지정
        ar.name AS 아티스트명,      -- 아티스트명 별칭 명확히 지정
        COUNT(t.track_id) AS track_count_in_genre
    FROM
        genres AS g
    JOIN
        tracks AS t ON g.genre_id = t.genre_id
    JOIN
        albums AS al ON t.album_id = al.album_id
    JOIN
        artists AS ar ON al.artist_id = ar.artist_id
    GROUP BY
        g.genre_id,
        g.name,
        ar.artist_id,
        ar.name
),
RankedGenreArtists AS (
    -- 2단계: 각 장르 내에서 아티스트의 순위 매기기
    SELECT
        장르명,
        아티스트id,
        아티스트명,
        track_count_in_genre,
        ROW_NUMBER() OVER (
            PARTITION BY 장르명
            ORDER BY track_count_in_genre DESC, 아티스트명 ASC -- 아티스트명 별칭 사용
        ) AS rnk
    FROM
        GenreArtistTrackCounts
)
-- 3단계: 최종 결과 선택 (상위 3위 이내 필터링)
SELECT
    장르명,
    아티스트id,
    아티스트명,
    track_count_in_genre AS 트랙수 -- 최종적으로 '트랙수'로 별칭 재지정
FROM
    RankedGenreArtists
WHERE
    rnk <= 3
ORDER BY
    장르명 ASC,
    트랙수 DESC,
    아티스트명 ASC;


-- 고객별 누적 구매액 및 등급 산출
-- 각 고객의 누적 구매액을 구하고,
-- 상위 20%는 'VIP', 하위 20%는 'Low', 나머지는 'Normal' 등급을 부여하세요.


WITH CustomerTotalPurchases AS (
    SELECT
        c.customer_id AS 고객id, 
        c.first_name,
        c.last_name,
        SUM(ii.unit_price * ii.quantity) AS 총구매액 
    FROM
        customers AS c
    JOIN
        invoices AS i ON c.customer_id = i.customer_id
    JOIN
        invoice_items AS ii ON i.invoice_id = ii.invoice_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
RankedCustomers AS (
    SELECT
        고객id,           
        first_name,
        last_name,
        총구매액,         
        NTILE(5) OVER (ORDER BY 총구매액 DESC) AS ntile_group 
    FROM
        CustomerTotalPurchases
)
SELECT
    고객id,           
    first_name,
    last_name,
    총구매액,         
    CASE
        WHEN ntile_group = 1 THEN 'VIP'    
        WHEN ntile_group = 5 THEN 'Low'     
        ELSE 'Normal'                     
    END AS 고객등급 
FROM
    RankedCustomers
ORDER BY
    총구매액 DESC;

-- 최근 1년간 월별 신규 고객 및 잔존 고객
--최근 1년(마지막 인보이스 기준 12개월) 동안,
--각 월별 신규 고객 수와 해당 월에 구매한 기존 고객 수를 구하세요.

WITH MaxInvoiceDate AS (
    SELECT MAX(invoice_date) AS max_date
    FROM invoices
),
CustomerPurchaseInfo AS (
    SELECT
        c.customer_id,
        MIN(i.invoice_date) OVER (PARTITION BY c.customer_id) AS first_purchase_date,
        i.invoice_date AS current_purchase_date
    FROM
        customers AS c
    JOIN
        invoices AS i ON c.customer_id = i.customer_id
    JOIN
        MaxInvoiceDate AS mid ON 1=1
    WHERE
        i.invoice_date >= (mid.max_date - INTERVAL '11 MONTHS')
        AND i.invoice_date <= mid.max_date
),
MonthlyCategorizedCustomers AS (
    SELECT
        TO_CHAR(current_purchase_date, 'YYYY-MM') AS 구매시기, 
        customer_id,
        CASE
            WHEN TO_CHAR(first_purchase_date, 'YYYY-MM') = TO_CHAR(current_purchase_date, 'YYYY-MM')
            THEN 'New'
            ELSE 'Existing'
        END AS customer_type
    FROM
        CustomerPurchaseInfo
    GROUP BY
        TO_CHAR(current_purchase_date, 'YYYY-MM'), 
        customer_id,
        TO_CHAR(first_purchase_date, 'YYYY-MM')
)
SELECT
    구매시기, 
    COUNT(CASE WHEN customer_type = 'New' THEN customer_id END) AS 신규고객,
    COUNT(CASE WHEN customer_type = 'Existing' THEN customer_id END) AS 잔존고객
FROM
    MonthlyCategorizedCustomers
GROUP BY
    구매시기 
ORDER BY
    구매시기 ASC;

select * from customers;
select * from invoices;