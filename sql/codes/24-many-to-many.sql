-- 24-many-to-many.sql
USE lecture;

DROP TABLE IF EXISTS students_courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;

CREATE TABLE students (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(20)
);

CREATE TABLE courses (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  classroom VARCHAR(20)  
);

-- 중간테이블 (Junction Table)  students:courses = M : N
CREATE TABLE students_courses (
  student_id INT,
  course_id INT,
  grade VARCHAR(5),
  PRIMARY KEY (student_id, course_id),  -- 복합 PK
  FOREIGN KEY(student_id) REFERENCES students(id),
  FOREIGN KEY(course_id) REFERENCES courses(id)
);

-- 데이터 삽입
INSERT INTO students VALUES
(1, '김학생'),
(2, '이학생' ),
(3, '박학생');

INSERT INTO courses VALUES
(1, 'MySQL 데이터베이스', 'A관 101호'),
(2, 'PostgreSQL 고급', 'B관 203호'),
(3, '데이터 분석', 'A관 704호');

INSERT INTO students_courses VALUES
(1, 1, 'A'),  -- 김학생이 MySQL 수강
(1, 2,'B+'), -- 김학생이 PostgreSQL 수강
(2, 1, 'A-'), -- 이학생이 MySQL 수강
(2, 3, 'B'),  -- 이학생이 데이터분석 수강
(3, 2, 'A+'), -- 박학생이 PostgreSQL 수강
(3, 3, 'A');  -- 박학생이 데이터분석 수강


-- 학생별 수강과목
SELECT
  s.name AS student_name,
  c.name AS course_name,
  sc.grade 
FROM students AS s
JOIN students_courses AS sc
  ON s.id = sc.student_id
JOIN courses AS c
  ON sc.course_id = c.id
ORDER BY
  s.name,
  c.name;

select 
s.id,
s.name,
group_concat(c.name)
from studets as s
inner join students_courses sc on s.id = sc.student_id
inner join courses c on sc.course_id=c.id
group by s.id, s.name;

SELECT
  s.id,
  s.name,
  GROUP_CONCAT(c.name)
FROM students AS s -- 테이블 이름 수정됨
INNER JOIN students_courses AS sc
  ON s.id = sc.student_id
INNER JOIN courses AS c
  ON sc.course_id = c.id
GROUP BY
  s.id,
  s.name;


-- 과목별 정리
-- (과목명, 강의실 , 수강인원, 수가학생들,학점평균(a+ 4.3/ a 4.0/ a- 3.7/ b+ 3.3/ b 3.0)

select * from students_courses;
SELECT
  group_concat(s.name) AS 학생명,
  c.id,
  c.name AS 과목명,
  c.classroom as 강의실,
  count(sc.student_id) as 수강인원,
  round(avg(case
	when sc. grade= 'a+' then 4.3
    when sc. grade= 'a' then 4.0
    when sc. grade= 'a-' then 3.7
    when sc. grade= 'b+' then 3.3
    when sc. grade= 'b' then 3.0
    else 0
    end
    ),2) as 평균학점
  
  from courses c
inner join students_courses sc on c.id = sc.course_id
inner join students s on sc.student_id=s.id
group by c.id, c.name;

















