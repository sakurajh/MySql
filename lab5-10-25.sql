use [lab5-10-25];

create table student(
    Sno int,
    Sname varchar(20),
    Ssex varchar(20),
    Sage int,
    Sdept varchar(20),
    primary key(Sno)
)

insert into student(Sno, Sname, Ssex, Sage, Sdept)
values (201215121, '李勇', '男', 20, '数学与信息技术学院'),
       (201215122, '刘晨', '女', 19, '美术系'),
       (201215123, '王敏', '女', 18, '音乐系'),
       (201215124, '张立', '男', 19, '体育系'),
       (201215125, '张立', '男', 19, '体育系'),
       (201215126, '李明', '男', 20, '数学与信息技术学院'),
       (201215127, '王芳美', '女', 19, '美术系'),
       (201215128, '陈军', '男', 19, '计算机科学系'),
       (201215129, '张华', '男', 18, '物理系'),
       (201215130, '王芳', '女', 19, '数学与信息技术学院'),
       (201215131, '刘洋', '男', 20, '美术系'),
       (201215132, '张强', '男', 19, '数学与信息技术学院'),
       (201215133, '王艳', '女', 18, '机电系'),
       (201215134, '陈明', '男', 20, '美术系');

create table sc(
    Sno int,
    Cno int,


    primary key(Sno, Cno),
    foreign key(Sno) references student(Sno)
)

insert into sc(Sno, Cno, Grade)
values (201215121, 1, 90),
       (201215121, 2, 80),
       (201215121, 3, 85),
       (201215122, 2, 85),
       (201215122, 3, 90),
       (201215123, 1, 78),
       (201215124, 1, 78),
       (201215124, 2, 82),
       (201215123, 2, 82),
       (201215123, 3, 85),
       (201215125, 2, 75),
       (201215125, 3, 78),
       (201215126, 1, 88),
       (201215126, 3, 90),
       (201215127, 1, 90),
       (201215127, 2, 85),
       (201215127, 3, 88),
       (201215128, 1, 82),
       (201215128, 2, 85),
       (201215128, 3, 90),
       (201215129, 1, 90),
       (201215129, 2, 85),
       (201215129, 3, 88),
       (201215130, 1, 78),
       (201215130, 2, 82),
       (201215130, 3, 85),
       (201215131, 1, 90),
       (201215131, 2, 85),
       (201215131, 3, 88),
       (201215132, 1, 78),
       (201215132, 2, 82),
       (201215132, 3, 85),
       (201215133, 1, 90),
       (201215133, 2, 85),
       (201215133, 3, 88),
       (201215134, 1, 78),
       (201215134, 2, 82),
       (201215134, 3, 85);

-- 1、基于学生—课程数据库创建一存储过程，用于检索数据库中某个专业学生的人数，带有一个输入参数，用于指定专业。
create procedure pro_s  @stu_sdept  varchar(20)
as
select count(*) as 人数 from student
where Sdept = @stu_sdept

-- 2、存储过程的执行
execute pro_s '数学与信息技术学院'


--3、基于学生-课程数据库创建一存储过程，该过程带有一个输入参数，一个输出参数。
-- 其中输入参数用于指定学生的学号，输出参数用于返回学生的平均成绩。
create procedure pro_stu  @stu_sno int,@stu_avg float output
as
  select @stu_avg = avg(Grade)
  from student,sc
  where student. sno = sc. sno and student.sno=@stu_sno

--4、存储过程的执行
declare @stuavg float
execute pro_stu 201215132,@stuavg output
select @stuavg
declare @stuavg float
execute pro_stu 201215122,@stuavg output
select @stuavg
--5、在pubs数据库中建立一个存储过程，用于检索数据库中某一价位的图书信息。
-- 参数有两个，用于指定图书价格的上下限。如果找到满足条件的图书，则返回0，否则返回1。
create table titles(
  title_id varchar(6) not null,
  title varchar(80) not null,
  price money null
)
insert into titles
values
('BU1032','安徒生童话',19.99),
('BU2075','计算机科学与技术',15.95),
('PS1372','C缺陷与陷阱',8.95),
('PS2091','天使',37.99),
('PS2106','平凡的生活',27.99),
('PS3333','数据结构',49.95),
('TC3218','美丽的国王',17.95),
('TC4203','忙碌的日子',29.99),
('TC7777','通信原理',11.95)
--5、在pubs数据库中建立一个存储过程，用于检索数据库中某一价位的图书信息。
-- 参数有两个，用于指定图书价格的上下限。如果找到满足条件的图书，则返回0，否则返回1。
create procedure pro_title @pro_minnprice money,
                            @pro_maxprice money
as
begin
  if exists (select price from titles
             where price >= @pro_minnprice and price <= @pro_maxprice)
  begin
    select title, price from titles
    where price >= @pro_minnprice and price <= @pro_maxprice
    return 0
  end
  else
  begin
    return 1
  end
end

--6、存储过程的执行
declare @result int
exec @result = pro_title @pro_minnprice = 10, @pro_maxprice = 30
print '结果为: ' + cast(@result as varchar)

--7、存储过程的删除
drop procedure pro_title
drop procedure pro_s
drop procedure pro_stu

SELECT name
FROM sys.procedures
ORDER BY name;

