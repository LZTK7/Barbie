# Barbie - 网上衣橱电商平台

基于 JavaWeb 的服装电商平台，在传统电商基础上增加了虚拟衣橱管理、搭配预览和待购状态流转功能。


## 技术栈

| 技术 | 版本 |
|------|------|
| JDK | 17 |
| Tomcat | 10.1.53 |
| MySQL | 8.0 |
| 后端 | Servlet + JSP |
| 前端 | HTML + CSS + JavaScript |
| 构建 | Maven |
| 版本控制 | Git |


## 主要功能

| 模块 | 功能 |
|------|------|
| 用户 | 注册、登录、角色区分（普通用户/管理员） |
| 商品 | 浏览、搜索（分词匹配）、分类筛选、价格排序 |
| 购物车 | 加购、修改数量、勾选/全选、结算 |
| 订单 | 独立订单生成、确认收货、删除 |
| 衣橱 | 订单自动同步、手动导入（图片上传）、删除 |
| 搭配 | 创建/编辑、人形三段预览、搜索待购、待购状态流转 |
| 后台 | 商品管理（增删改查）、用户管理 |


## 搭配状态流转

搜索添加 → 待加购 → 一键加购 → 待购买 → 结算 → 待收货 → 确认收货 → 已拥有


## 快速启动

### 1. 导入数据库

```sql
CREATE DATABASE barbie DEFAULT CHARACTER SET utf8mb4;
USE barbie;
-- 执行项目中的 clozbuy.sql
```

### 2. 修改数据库密码

`src/main/java/com/barbie/util/DBUtil.java`

```java
private static final String PASSWORD = "你的MySQL密码";
```

### 3. 配置 Tomcat

- IDEA 配置 Tomcat 10.1.x
- 部署 Barbie:war exploded
- 访问路径：/Barbie

### 4. 启动项目

访问：http://localhost:8080/Barbie


## 测试账号

| 角色 | 用户名 | 密码 |
|------|--------|------|
| 普通用户 | test | 123456 |
| 管理员 | admin | 123456 |


## 项目结构

```
Barbie/
├── src/main/java/com/barbie/
│   ├── model/          # 实体类 (7个)
│   ├── dao/            # 数据访问层 (6个)
│   ├── servlet/        # 控制器 (22个)
│   ├── util/           # 工具类 (3个)
│   └── filter/         # 过滤器 (1个)
├── src/main/webapp/
│   ├── pages/          # JSP页面 (14个)
│   ├── uploads/        # 图片存储
│   └── WEB-INF/web.xml
└── pom.xml
```


## 数据表

| 表名 | 说明 |
|------|------|
| users | 用户表 |
| products | 商品表 |
| cart | 购物车表 |
| orders | 订单表 |
| order_items | 订单商品表 |
| wardrobe | 虚拟衣橱表 |
| looks | 搭配表 |


JavaWeb 课程设计作品


## 日期

2026年6月
