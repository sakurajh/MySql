CREATE DATABASE ycudata;
GO

USE ycudata;
-- 创建职工表
CREATE TABLE 职工 (
    职工号 INT PRIMARY KEY,
    姓名 NVARCHAR(50),
    年龄 INT,
    职务 NVARCHAR(50),
    工资 DECIMAL(10, 2),
    部门号 INT
);
-- 创建部门表
CREATE TABLE 部门 (
    部门号 INT PRIMARY KEY,
    名称 NVARCHAR(50),
    经理名 NVARCHAR(50),
    地址 NVARCHAR(100),
    电话号 NVARCHAR(15)
);

-- 向部门表插入数据
INSERT INTO 部门 (部门号, 名称, 经理名, 地址, 电话号) VALUES
(1, '人事部', '张经理', '北京', '010-12345678'),
(2, '财务部', '李经理', '上海', '021-23456789'),
(3, '研发部', '王经理', '深圳', '0755-34567890'),
(4, '市场部', '赵经理', '广州', '020-45678901'),
(5, '客服部', '钱经理', '杭州', '0571-56789012');

-- 向职工表插入数据
INSERT INTO 职工 (职工号, 姓名, 年龄, 职务, 工资, 部门号) VALUES
(101, '李华', 30, '人事专员', 6000.00, 1),
(102, '王芳', 28, '财务专员', 6500.00, 2),
(103, '张强', 35, '研发工程师', 8000.00, 3),
(104, '赵丽', 25, '市场助理', 5000.00, 4),
(105, '钱杰', 40, '客服经理', 7000.00, 5),
(106, '孙梅', 32, '人事经理', 9000.00, 1),
(107, '周伟', 29, '财务经理', 9500.00, 2),
(108, '吴娜', 27, '研发助理', 4800.00, 3),
(109, '郑飞', 31, '市场专员', 5200.00, 4),
(110, '何婷', 26, '客服专员', 4500.00, 5);


CREATE LOGIN sqlaa WITH PASSWORD = '1234';
CREATE USER sqlaa FOR LOGIN sqlaa;
GRANT SELECT, DELETE ON 职工 TO sqlaa;

CREATE LOGIN sqlbb WITH PASSWORD = '1234';
-- 创建用户
CREATE USER sqlbb FOR LOGIN sqlbb;
-- 授予所有有效权限
GRANT SELECT, INSERT, UPDATE, DELETE ON 职工 TO sqlbb;
GRANT SELECT, INSERT, UPDATE, DELETE ON 部门 TO sqlbb;



CREATE LOGIN sqltcc WITH PASSWORD = '1234';
CREATE USER sqltcc FOR LOGIN sqltcc;
-- 授予查找职工表的权限并使其可传播
GRANT SELECT ON 职工 TO sqltcc WITH GRANT OPTION;
-- 授予更新部门表的权限并使其可传播
GRANT UPDATE ON 部门 TO sqltcc WITH GRANT OPTION;
-- 将权限传播给用户 sqlaa
GRANT SELECT ON 职工 TO sqlaa;
GRANT UPDATE ON 部门 TO sqlaa;


CREATE LOGIN selectdd WITH PASSWORD = '1234';
CREATE USER selectdd FOR LOGIN selectdd;
GRANT ALTER ON 职工 TO selectdd;

--  还有一问未解决
SELECT *
FROM sys.database_permissions
WHERE grantee_principal_id = USER_ID('sqlaa');


CREATE ROLE role1;
GRANT SELECT, INSERT, UPDATE, DELETE ON 部门 TO role1;

EXEC sp_addrolemember 'role1', 'sqldd';
EXEC sp_addrolemember 'role1', 'sqlcc';

--添加唯一约束
ALTER TABLE 部门
ADD CONSTRAINT UQ_部门名称 UNIQUE (名称);
--添加外键
ALTER TABLE 职工
ADD CONSTRAINT FK_职工部门 FOREIGN KEY (部门号) REFERENCES 部门(部门号);
-- 添加年龄不超过60岁的约束
ALTER TABLE 职工
ADD CONSTRAINT CHK_年龄 CHECK (年龄 <= 60);


CREATE LOGIN sqlee WITH PASSWORD = '1234';
CREATE USER sqlee FOR LOGIN sqlee;
CREATE VIEW 部门工资统计 AS
SELECT
    部门号,
    MAX(工资) AS 最高工资,
    MIN(工资) AS 最低工资,
    AVG(工资) AS 平均工资
FROM 职工
GROUP BY 部门号;
GRANT SELECT ON 部门工资统计 TO sqlee;
DENY SELECT ON 职工(工资) TO sqlee;  -- 仅针对工资列


