create database lab2_9_28;

use lab2_9_28;
-- 基本表的建立
-- 创建学生表 student
CREATE TABLE student (
    xh INT PRIMARY KEY,  -- 学号，主键
    xm NVARCHAR(50),     -- 姓名
    xb NVARCHAR(10),     -- 性别
    nl INT,              -- 年龄
    xi NVARCHAR(50)      -- 所在系
);

-- 创建课程表 course
CREATE TABLE course (
    kch INT PRIMARY KEY,  -- 课程号，主键
    kcmc NVARCHAR(100),   -- 课程名称
    xxkc NVARCHAR(100),   -- 先修课程
    xf DECIMAL(3, 1)      -- 学分
);

-- 创建选课表 sc
CREATE TABLE sc (
    xh INT,                    -- 学号
    kch INT,                   -- 课程号
    grade DECIMAL(4, 1),       -- 成绩
    PRIMARY KEY (xh, kch),     -- 主键
    FOREIGN KEY (xh) REFERENCES student(xh),  -- 外键，引用 student 表的 xh
    FOREIGN KEY (kch) REFERENCES course(kch)  -- 外键，引用 course 表的 kch
);
--在选课表中增加一列“任课教师rkjs”
ALTER TABLE sc
ADD rkjs NVARCHAR(50);
--在选课表中删除“任课教师”列
ALTER TABLE sc
DROP COLUMN rkjs;

-- 更改 xm 列的属性，不允许为空值且修改长度
ALTER TABLE student
ALTER COLUMN xm CHAR(10) NOT NULL;

CREATE TABLE #TempTable (
    id INT PRIMARY KEY,
    name NVARCHAR(50)
);
DROP TABLE #TempTable;
--在学生表中以学生的姓名建立降序索引
CREATE INDEX idx_student_name_desc ON student (xm DESC);

-- 以课程名（kcmc）建立升序索引
CREATE INDEX idx_course_name_asc ON course (kcmc ASC);

-- 以学分（xf）建立降序索引
CREATE INDEX idx_course_credit_desc ON course (xf DESC);

-- 删除学生表中以学生姓名为降序的索引
DROP INDEX idx_student_name_desc ON student;
-- 删除课程表中的课程名升序和学分降序的索引
DROP INDEX idx_course_name_asc ON course;
DROP INDEX idx_course_credit_desc ON course;

--建立数学系学生的视图
CREATE VIEW C_Student
AS
SELECT xh AS Sno,
       xm AS Sname,
       nl AS Sage,
       xi AS Sdept
FROM student
WHERE xi = N'数学'
WITH CHECK OPTION;

SELECT Sname, Sage FROM C_Student WHERE Sage < 20;

UPDATE C_Student SET Sname = '黄海' WHERE Sno = '5';

DELETE FROM student WHERE xh = '9' AND xi = N'数学';