<div align="center">

# 🗄 MySql · 课程实验脚本

**MySQL 课程实验 SQL 脚本合集**

[![MySQL](https://img.shields.io/badge/MySQL-8.x-4479A1?style=flat-square&logo=mysql&logoColor=white)](https://www.mysql.com/)

</div>

---

## 📄 文件说明

| 文件 | 内容 |
|---|---|
| `console_1.sql` | 控制台练习一 |
| `console_2.sql` | 控制台练习二 |
| `lab2_9_28.sql` | 实验二（9 月 28 日） |
| `lab5-10-25.sql` | 实验五（10 月 25 日） |
| `ycudata.sql` | 示例数据集（建表 + 数据） |

## 🚀 使用方法

**方式一：命令行导入**

```bash
mysql -u root -p < ycudata.sql
mysql -u root -p 你的数据库名 < lab2_9_28.sql
```

**方式二：MySQL 客户端内执行**

```sql
source /path/to/lab2_9_28.sql;
```

**方式三：图形化工具**（Navicat / DataGrip / Workbench）
直接打开 `.sql` 文件，选择数据库后执行。

## 📝 说明

本仓库是 MySQL 课程的学习与实验记录，脚本主要覆盖：建表与约束、数据增删改查、多表查询、子查询、事务与索引等基础内容。
