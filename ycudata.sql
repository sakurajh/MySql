use ycudata
-- 创建部门表
CREATE TABLE 部门 (
    部门号 INT PRIMARY KEY,
    名称 NVARCHAR(50) UNIQUE NOT NULL,
    经理名 NVARCHAR(50),
    地址 NVARCHAR(100),
    电话号 NVARCHAR(20)
);
-- 创建职工表
CREATE TABLE 职工 (
    职工号 INT PRIMARY KEY,
    姓名 NVARCHAR(50) NOT NULL,
    年龄 INT CHECK (年龄 <= 60),
    职务 NVARCHAR(50),
    工资 DECIMAL(10, 2),
    部门号 INT,
    FOREIGN KEY (部门号) REFERENCES 部门(部门号)
);

INSERT INTO 部门 (部门号, 名称, 经理名, 地址, 电话号) VALUES
    (1, '人事部', '李经理', '北京市朝阳区1号', '010-12345678'),
    (2, '财务部', '王经理', '上海市浦东新区2号', '021-23456789'),
    (3, '市场部', '张经理', '广州市天河区3号', '020-34567890'),
    (4, '技术部', '赵经理', '深圳市南山区4号', '0755-45678901'),
    (5, '研发部', '刘经理', '杭州市西湖区5号', '0571-56789012'),
    (6, '行政部', '陈经理', '南京市鼓楼区6号', '025-67890123'),
    (7, '销售部', '孙经理', '成都市武侯区7号', '028-78901234'),
    (8, '生产部', '周经理', '武汉市江汉区8号', '027-89012345'),
    (9, '供应链部', '吴经理', '西安市雁塔区9号', '029-90123456'),
    (10, '客服部', '杨经理', '长沙市雨花区10号', '0731-01234567');

INSERT INTO 职工 (职工号, 姓名, 年龄, 职务, 工资, 部门号) VALUES
    (101, '张三', 30, '助理', 5000.00, 1),
    (102, '李四', 35, '会计', 7000.00, 2),
    (103, '王五', 28, '市场专员', 6000.00, 3),
    (104, '赵六', 40, '技术员', 8000.00, 4),
    (105, '刘七', 32, '研发工程师', 9000.00, 5),
    (106, '陈八', 38, '行政主管', 6500.00, 6),
    (107, '孙九', 29, '销售代表', 5500.00, 7),
    (108, '周十', 45, '生产主管', 7500.00, 8),
    (109, '吴十一', 34, '采购员', 6800.00, 9),
    (110, '杨十二', 31, '客服专员', 5200.00, 10);


-- 2、创建用户sqlaa
CREATE LOGIN sqlaa WITH PASSWORD = '1234';
CREATE USER sqlaa FOR LOGIN sqlaa;
-- 授予sqlaa用户对职工表的 SELECT和DELETE权限
GRANT SELECT, DELETE ON 职工 TO sqlaa;

--3、创建用户sqlbb,它对关系模式职工和部门具有所有的权限（所有权限的表达）
-- 创建用户 sqlbb
CREATE LOGIN sqlbb WITH PASSWORD = '1234';
CREATE USER sqlbb FOR LOGIN sqlbb;
--给sqlbb 用户对职工的所有权限
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, REFERENCES ON 职工 TO sqlbb;
--给sqlbb 用户对部门的所有权限
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, REFERENCES ON 部门 TO sqlbb;

--4.创建用户sqlcc,对该用户sqlcc授予查找职工关系模式，更新部门关系模式的权限，同时可以将该权限进行传播，并将权限传播给用户sqlaa
-- 创建用户 sqlcc
CREATE LOGIN sqlcc WITH PASSWORD = '1234';
CREATE USER sqlcc FOR LOGIN sqlcc;

-- 给sqlcc对职工表和部门表的SELECT权限
GRANT SELECT ON 职工 TO sqlcc WITH GRANT OPTION;
GRANT UPDATE ON 部门 TO sqlcc WITH GRANT OPTION;

-- sqlcc权限传播给sqlaa
GRANT SELECT ON 职工 TO sqlaa;
GRANT UPDATE ON 部门 TO sqlaa;

--5、创建用户sqldd，它对关系模式职工修改表结构的权限
-- 创建用户sqldd
CREATE LOGIN sqldd WITH PASSWORD = '1234';
CREATE USER sqldd FOR LOGIN sqldd;
-- 授予 sqldd 权限
GRANT ALTER ON 职工 TO sqldd;

--6、收回用户sqlcc的相应权限，了解sqlaa的权限情况
-- 收回 sqlcc对职工表和部门表的权限
REVOKE SELECT ON 职工 FROM sqlcc;
REVOKE UPDATE ON 部门 FROM sqlcc;


REVOKE SELECT ON 职工 FROM sqlcc CASCADE;
REVOKE UPDATE ON 部门 FROM sqlcc CASCADE;

/*
7、创建角色role1，它的权限是对部门关系模式进行
查、插、改、删，将用户sqldd 和sqlcc归于角色role1，查看用户的权限
*/

-- 创建角色role1
CREATE ROLE role1;
-- 授予角色role1权限
GRANT SELECT, INSERT, UPDATE, DELETE ON 部门 TO role1;
--将用户 sqldd和sqlcc添加到角色 role1
ALTER ROLE role1 ADD MEMBER sqldd;
ALTER ROLE role1 ADD MEMBER sqlcc;

-- 查看角色中的成员
SELECT
    dp.name AS RoleName,
    dp2.name AS UserName
FROM
    sys.database_role_members AS drm
JOIN
    sys.database_principals AS dp ON drm.role_principal_id = dp.principal_id
JOIN
    sys.database_principals AS dp2 ON drm.member_principal_id = dp2.principal_id
WHERE
    dp.name = 'role1';

/* 以下为选做内容：
1、定义用户sqlee，具有从每个部门职工中查看最高工资，
最低工资和平均工资的权力，但他不能查看每个人的工资
*/
-- 创建用户sqlee
CREATE LOGIN sqlee WITH PASSWORD = '1234';
CREATE USER sqlee FOR LOGIN sqlee;

CREATE VIEW 部门工资统计 AS
SELECT
    部门号,
    MAX(工资) AS 最高工资,
    MIN(工资) AS 最低工资,
    AVG(工资) AS 平均工资
FROM
    职工
GROUP BY
    部门号;
-- 授予权限
GRANT SELECT ON 部门工资统计 TO sqlee;

--2.在对关系模式定义外键时，分别设置无行动和级连两种方式，并进行数据插入
--2.1  使用无行动约束
-- 删除原来职工表
DROP TABLE IF EXISTS 职工;
-- 创建职工表，设置无行动外键约束
CREATE TABLE 职工 (
    职工号 INT PRIMARY KEY,
    姓名 NVARCHAR(50) NOT NULL,
    年龄 INT CHECK (年龄 <= 60),
    职务 NVARCHAR(50),
    工资 DECIMAL(10, 2),
    部门号 INT,
    FOREIGN KEY (部门号) REFERENCES 部门(部门号) ON DELETE NO ACTION
);
-- 插入职工数据
INSERT INTO 职工 (职工号, 姓名, 年龄, 职务, 工资, 部门号) VALUES
    (101, '张三', 30, '助理', 5000.00, 1),
    (102, '李四', 35, '会计', 7000.00, 2),
    (103, '王五', 28, '市场专员', 6000.00, 3);
-- 尝试删除部门
DELETE FROM 部门 WHERE 部门号 = 1;

--2.2  使用级联约束
-- 删除原有职工表
DROP TABLE IF EXISTS 职工;
-- 创建职工表，设置级联外键约束
CREATE TABLE 职工_with_cascade (
    职工号 INT PRIMARY KEY,
    姓名 NVARCHAR(50) NOT NULL,
    年龄 INT CHECK (年龄 <= 60),
    职务 NVARCHAR(50),
    工资 DECIMAL(10, 2),
    部门号 INT,
    FOREIGN KEY (部门号) REFERENCES 部门(部门号) ON DELETE CASCADE
);
-- 插入职工数据
INSERT INTO 职工_with_cascade (职工号, 姓名, 年龄, 职务, 工资, 部门号) VALUES
    (101, '张三', 30, '助理', 5000.00, 1),
    (102, '李四', 35, '会计', 7000.00, 2),
    (103, '王五', 28, '市场专员', 6000.00, 3);
-- 删除部门
DELETE FROM 部门 WHERE 部门号 = 1;







