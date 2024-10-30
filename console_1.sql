use lab3_10_6;


-- 创建 STUDENT 表
CREATE TABLE STUDENT (
    Sno INT PRIMARY KEY,     -- 学号
    Sname NVARCHAR(50),      -- 姓名
    Sage INT,                -- 年龄
    Sdept NVARCHAR(50)       -- 系别
);
-- 插入数据
INSERT INTO STUDENT (Sno, Sname, Sage, Sdept) VALUES
(1, '李瑜', 21, '计算机系'),
(2, '张伟', 20, '计算机系'),
(3, '王明', 22, '数学系'),
(4, '刘芳', 19, '计算机系'),
(5, '陈强', 23, '物理系'),
(6, '赵丽', 20, '数学系'),
(7, '孙浩', 22, '物理系'),
(8, '周杰', 21, '计算机系'),
(9, '李雪', 21, '物理系'),
(10, '王芳', 20, '数学系');


-- 创建 COURSE 表
CREATE TABLE COURSE (
    Cno INT PRIMARY KEY,     -- 课程编号
    Cname NVARCHAR(50)       -- 课程名称
);

-- 插入更多课程数据
INSERT INTO COURSE (Cno, Cname) VALUES
(1, '数据库'),
(2, '高等数学'),
(3, '操作系统'),
(4, '物理'),
(5, '计算机网络'),
(6, '概率论');

-- 创建 SC 表
CREATE TABLE SC (
    Sno INT,                 -- 学号
    Cno INT,                 -- 课程编号
    Grade DECIMAL(5,2),      -- 成绩
    PRIMARY KEY (Sno, Cno),
    FOREIGN KEY (Sno) REFERENCES STUDENT(Sno),
    FOREIGN KEY (Cno) REFERENCES COURSE(Cno)
);
-- 插入更多选课成绩数据
INSERT INTO SC (Sno, Cno, Grade) VALUES
(1, 1, 85.00),
(1, 2, 90.00),
(1, 3, 88.00),
(2, 2, 78.00),
(2, 4, 86.00),
(3, 1, 92.00),
(3, 5, 80.00),
(4, 1, 95.00),
(4, 2, 87.00),
(5, 3, 83.00),
(5, 6, 79.00),
(6, 2, 91.00),
(6, 6, 85.00),
(7, 4, 88.00),
(7, 5, 84.00),
(8, 1, 93.00),
(8, 3, 89.00),
(9, 4, 77.00),
(9, 6, 81.00),
(10, 2, 85.00),
(10, 5, 90.00);

-- 1.查询 STUDENT 表中的所有信息
SELECT * FROM STUDENT;

-- 1.查询 STUDENT 表中的部分信息（学号和姓名）
SELECT Sno, Sname FROM STUDENT;

-- 查询 STUDENT 表中计算机系学生的全部信息
SELECT * FROM STUDENT WHERE Sdept = '计算机系';

-- 查询 STUDENT 表中计算机系年龄在20岁以上的学生姓名
SELECT Sname FROM STUDENT WHERE Sdept = '计算机系' AND Sage > 20;



-- 连接查询：查询选修了 2 号课程的学生姓名
SELECT DISTINCT s.Sname FROM STUDENT s
JOIN SC sc ON s.Sno = sc.Sno
WHERE sc.Cno = 2;

-- 嵌套查询：查询选修了2号课程的学生名单
SELECT Sname
FROM STUDENT
WHERE Sno IN (SELECT Sno FROM SC WHERE Cno = 2);

-- 求每个学生的平均成绩
SELECT  s.Sname AS 学生姓名,AVG(sc.Grade) AS 平均成绩 FROM STUDENT s
JOIN  SC sc ON s.Sno = sc.Sno GROUP BY s.Sname;

-- 求每一门课程的平均成绩
SELECT  c.Cname AS 课程名称,AVG(sc.Grade) AS 平均成绩 FROM COURSE c
JOIN SC sc ON c.Cno = sc.Cno GROUP BY c.Cname;


-- 使用相关子查询查询没有选修 2 号课程的学生姓名
SELECT Sname FROM STUDENT s
WHERE NOT EXISTS (
    SELECT 1 FROM SC sc
    WHERE sc.Sno = s.Sno AND sc.Cno = 2
);

-- 使用不相关子查询查询没有选修 2 号课程的学生姓名
SELECT Sname FROM STUDENT
WHERE Sno NOT IN (
    SELECT Sno FROM SC
    WHERE Cno = 2
);

-- 查询选修了全部课程的学生姓名，使用 NOT EXISTS 实现全称量词
SELECT Sname FROM STUDENT s
WHERE NOT EXISTS (
    SELECT 1 FROM COURSE c
    WHERE NOT EXISTS (
        SELECT 1 FROM SC sc
        WHERE sc.Sno = s.Sno AND sc.Cno = c.Cno
    )
);

-- 查询至少选修了 1 号和 2 号课程的学生名单
SELECT s.Sname FROM STUDENT s
JOIN SC sc ON s.Sno = sc.Sno WHERE sc.Cno IN (1, 2)
GROUP BY s.Sno, s.Sname HAVING COUNT(DISTINCT sc.Cno) = 2;

-- 查询只选修了 1 号和 2 号课程的学生名单
SELECT s.Sname FROM STUDENT s
JOIN SC sc ON s.Sno = sc.Sno
GROUP BY s.Sno, s.Sname
HAVING COUNT(DISTINCT sc.Cno) = 2
   AND SUM(CASE WHEN sc.Cno NOT IN (1, 2) THEN 1 ELSE 0 END) = 0;

-- 查询选修了 3 门或 3 门以上课程的学生学号 (Sno)
SELECT s.Sno FROM STUDENT s
JOIN SC sc ON s.Sno = sc.Sno
GROUP BY s.Sno
HAVING COUNT(DISTINCT sc.Cno) >= 3;

-- 查询全部学生都选修的课程名
SELECT c.Cname FROM COURSE c
WHERE NOT EXISTS (
    SELECT 1 FROM STUDENT s
    WHERE NOT EXISTS (
        SELECT 1 FROM SC sc
        WHERE sc.Sno = s.Sno AND sc.Cno = c.Cno
    )
);

-- 查询选修了数据库（Cno = 1）和数学（Cno = 2）课程的学生名单
SELECT s.Sname FROM STUDENT s
JOIN SC sc ON s.Sno = sc.Sno WHERE sc.Cno IN (1, 2)
GROUP BY s.Sno, s.Sname
HAVING COUNT(DISTINCT sc.Cno) = 2;
