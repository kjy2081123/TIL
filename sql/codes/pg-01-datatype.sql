CREATE TABLE datatype_demo(
	-- mysql 에도 있음. 이름이 다를 수는 있다.
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	age INTEGER,
	salary NUMERIC(12, 2),
	is_active BOOLEAN DEFAULT TRUE,
	created_at TIMESTAMP DEFAULT NOW(),
	-- postgresql 특화 타입
	tags TEXT[],    -- 배열
	metadata JSONB,  -- JSONB JSON binary 타입
	ip_address INET, -- IP 주소 저장 전용
	location POINT,  -- 기하학 점(x, y)
	salary_range INT4RANGE -- 범위
);

INSERT INTO datatype_demo (
    name, age, salary, tags, metadata, ip_address, location, salary_range
) VALUES
(
    '김철수',
    30,
    5000000.50,
    ARRAY['개발자', 'PostgreSQL', '백엔드'],        -- 배열
    '{"department": "IT", "skills": ["SQL", "Python"], "level": "senior"}'::JSONB,  -- JSONB
    '192.168.1.100'::INET,                         -- IP 주소
    POINT(37.5665, 126.9780),                      -- 서울 좌표
    '[3000000,7000000)'::INT4RANGE                 -- 연봉 범위
),
(
    '이영희',
    28,
    4500000.00,
    ARRAY['디자이너', 'UI/UX'],
    '{"department": "Design", "skills": ["Figma", "Photoshop"], "level": "middle"}'::JSONB,
    '10.0.0.1'::INET,
    POINT(35.1796, 129.0756),                      -- 부산 좌표
    '[4000000,6000000)'::INT4RANGE
);
select *from datatype_demo;

select
	name,
	tags[1] as first_tag,
	'postgresql' = any(tags) as pg_dev
	from datatype_demo;

	-- jsonb(metadata)
select
	name,
	metadata ->> 'department' as 부서,
	metadata ->> 'skills' as 능력
from datatype_demo;

select 
	name, 
	metadata ->> 'department' as 부서
from datatype_demo
where metadata @> '{"level":"senior"}';

-- 범위(salary range)
select
	name,
	salary,
	salary_range,
	salary::int <@ salary_range as 연봉범위,
	upper(salary_range)- lower(salary_range) as 연봉폭
from datatype_demo;

-- 좌표값(location)
select
	name,
	location[0] as 위도,
	location[1] as 경도,
	point(37.505027,127.005011) <-> location as 고터거리
from datatype_demo;