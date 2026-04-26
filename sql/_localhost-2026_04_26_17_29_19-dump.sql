-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: snow
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cultural_creative_comments`
--

DROP TABLE IF EXISTS `cultural_creative_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultural_creative_comments` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `product_id` bigint NOT NULL COMMENT '文创商品ID',
  `user_id` bigint DEFAULT NULL COMMENT '评论用户ID（可空，支持游客）',
  `user_nickname` varchar(64) DEFAULT NULL COMMENT '用户昵称',
  `user_avatar` varchar(255) DEFAULT NULL COMMENT '用户头像URL',
  `is_anonymous` char(1) DEFAULT '0' COMMENT '是否匿名（0否 1是）',
  `score` tinyint NOT NULL DEFAULT '5' COMMENT '评分（1~5）',
  `content` varchar(1000) NOT NULL COMMENT '评论内容',
  `images_json` json DEFAULT NULL COMMENT '评论图片JSON（0~N张）',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1隐藏 2删除）',
  `audit_status` char(1) DEFAULT '0' COMMENT '审核状态（0待审 1通过 2驳回）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_cc_comment_product_time` (`product_id`,`create_time`),
  KEY `idx_cc_comment_user` (`user_id`),
  KEY `idx_cc_comment_status` (`status`,`audit_status`),
  CONSTRAINT `fk_cc_comment_product` FOREIGN KEY (`product_id`) REFERENCES `cultural_creative_products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文创商品评论表（单层）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultural_creative_comments`
--

LOCK TABLES `cultural_creative_comments` WRITE;
/*!40000 ALTER TABLE `cultural_creative_comments` DISABLE KEYS */;
INSERT INTO `cultural_creative_comments` VALUES (1,1,10001,'雪城旅人','https://i.pravatar.cc/100?img=12','0',5,'做工很细，金属质感不错，冰箱上吸得很稳，送朋友也合适。','[{\"url\": \"https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1}]',12,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(2,1,10002,'冰雪小站','https://i.pravatar.cc/100?img=25','0',4,'包装完整，颜色和页面一致，价格也合适，整体满意。','[]',6,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(3,2,10003,'北境少女','https://i.pravatar.cc/100?img=18','0',5,'胸针很精致，冬装搭配效果很好，扣子也比较牢。','[]',9,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(4,2,10004,'旅拍阿泽','https://i.pravatar.cc/100?img=31','1',4,'细节还可以，整体偏小巧，适合别在围巾或大衣上。','[]',5,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(5,3,10005,'明信片收藏家','https://i.pravatar.cc/100?img=47','0',5,'纸张厚实，印刷颜色很漂亮，12张每张都很有特色。','[{\"url\": \"https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1}]',17,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(6,3,10006,'雪地慢行','https://i.pravatar.cc/100?img=33','0',5,'适合送朋友，信封也很有仪式感，物流速度快。','[]',8,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:55'),(7,4,10007,'城市夜游人','https://i.pravatar.cc/100?img=56','0',5,'音乐盒灯光很温柔，晚上摆在书桌边上很有氛围。','[]',11,'0','1','2026-04-25 21:52:54','2026-04-25 21:52:54'),(8,4,10008,'哈尔滨在读','https://i.pravatar.cc/100?img=61','0',4,'质感不错，底座稳，做礼物挺拿得出手。','[]',4,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(9,5,10009,'木屋晚风','https://i.pravatar.cc/100?img=41','0',5,'香味不冲，很适合冬天，点着之后房间里很治愈。','[]',14,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(10,5,10010,'森系玩家','https://i.pravatar.cc/100?img=22','1',5,'味道高级，燃烧比较稳定，复购意愿高。','[]',7,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(11,6,10011,'雪球同学','https://i.pravatar.cc/100?img=39','0',5,'玩偶手感很好，孩子很喜欢，缝线也比较细致。','[]',10,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(12,6,10012,'极地旅拍','https://i.pravatar.cc/100?img=14','0',4,'造型可爱，大小适中，送礼很合适。','[]',3,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(13,7,10013,'热饮爱好者','https://i.pravatar.cc/100?img=8','0',5,'保温效果很好，上午装热水到下午还是烫的。','[]',19,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(14,7,10014,'地铁通勤人','https://i.pravatar.cc/100?img=63','0',3,'颜值在线，容量够用，杯口清洗也方便。','[]',6,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(15,8,10015,'轻装出门','https://i.pravatar.cc/100?img=50','0',5,'帆布很厚实，图案好看，日常通勤很好搭。','[]',13,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(16,8,10016,'小满同学','https://i.pravatar.cc/100?img=29','1',4,'容量还可以，肩带长度合适，价格友好。','[]',5,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(17,9,10017,'夜读者','https://i.pravatar.cc/100?img=43','0',5,'书签质感很棒，边缘处理圆润，不刮手。','[]',16,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(18,9,10018,'图书馆常客','https://i.pravatar.cc/100?img=66','0',5,'图案有特色，厚度合适，夹页不易滑落。','[]',7,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(19,10,10019,'模型发烧友','https://i.pravatar.cc/100?img=70','0',5,'拼装说明清晰，零件契合度高，成品很有成就感。','[]',15,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55'),(20,10,10020,'亲子手作','https://i.pravatar.cc/100?img=52','0',5,'和孩子一起拼了两晚，过程很有趣，适合周末活动。','[]',9,'0','1','2026-04-25 21:52:55','2026-04-25 21:52:55');
/*!40000 ALTER TABLE `cultural_creative_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cultural_creative_products`
--

DROP TABLE IF EXISTS `cultural_creative_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultural_creative_products` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `product_code` varchar(64) DEFAULT NULL COMMENT '商品编码（可对外展示）',
  `title` varchar(128) NOT NULL COMMENT '商品标题/名称',
  `sub_title` varchar(255) DEFAULT NULL COMMENT '副标题/一句话卖点',
  `category_code` varchar(64) DEFAULT NULL COMMENT '分类编码（如冰箱贴/玩偶）',
  `category_name` varchar(64) DEFAULT NULL COMMENT '分类名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '售价',
  `market_price` decimal(10,2) DEFAULT '0.00' COMMENT '划线价/市场价',
  `stock` int DEFAULT '0' COMMENT '库存',
  `sales_count` int DEFAULT '0' COMMENT '销量',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图路径/URL（单张）',
  `images_json` json DEFAULT NULL COMMENT '商品图片JSON（多图）',
  `spec_json` json DEFAULT NULL COMMENT '参数JSON（材质/尺寸等）',
  `service_json` json DEFAULT NULL COMMENT '服务承诺JSON（发货/售后等）',
  `review_count` int DEFAULT '0' COMMENT '评论数量（冗余字段）',
  `review_score` decimal(3,2) DEFAULT '5.00' COMMENT '评论均分（1~5，冗余字段）',
  `sort_order` int DEFAULT '0' COMMENT '排序值（越小越靠前）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0上架 1下架）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cc_product_code` (`product_code`),
  KEY `idx_cc_product_status_sort` (`status`,`sort_order`,`update_time`),
  KEY `idx_cc_product_title` (`title`),
  KEY `idx_cc_product_category` (`category_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文创商品主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultural_creative_products`
--

LOCK TABLES `cultural_creative_products` WRITE;
/*!40000 ALTER TABLE `cultural_creative_products` DISABLE KEYS */;
INSERT INTO `cultural_creative_products` VALUES (1,'CC-TEST-001','哈尔滨浮雕金属创意冰箱贴·城市记忆款','冰城地标浮雕，磁力稳固，旅行纪念','fridge_magnet','冰箱贴',32.90,49.00,560,218,'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}, {\"url\": \"https://images.unsplash.com/photo-1489515217757-5fd1be406fef?auto=format&fit=crop&w=1200&q=80\", \"sort\": 3, \"isCover\": 0}]','{\"尺寸\": \"65mm*48mm\", \"工艺\": \"浮雕烤漆\", \"材质\": \"锌合金+软磁\", \"重量\": \"约42g\"}','[\"48小时内发货\", \"7天无理由退货\", \"破损包赔\"]',2,4.50,10,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','文创首发测试数据'),(2,'CC-TEST-002','中央大街雪花珐琅胸针','法式珐琅工艺，冬季穿搭点睛','pin','胸针',45.00,69.00,420,156,'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"尺寸\": \"32mm*30mm\", \"材质\": \"铜镀金+珐琅\", \"重量\": \"约9g\", \"佩戴方式\": \"蝴蝶扣\"}','[\"48小时内发货\", \"支持礼盒包装\"]',2,4.50,20,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','服饰配件类'),(3,'CC-TEST-003','冰雪大世界夜景明信片套装（12张）','精选城市夜景，附纪念信封','postcard','明信片',29.90,39.90,800,402,'https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1518998053901-5348d3961a04?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}, {\"url\": \"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1200&q=80\", \"sort\": 3, \"isCover\": 0}]','{\"工艺\": \"烫银\", \"数量\": \"12张+1信封\", \"材质\": \"350g艺术纸\", \"规格\": \"148mm*105mm\"}','[\"24小时内发货\", \"支持代写祝福卡\"]',2,5.00,30,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','纸品文创类'),(4,'CC-TEST-004','索菲亚教堂微景观音乐盒','旋转发条，暖光氛围灯','music_box','音乐盒',128.00,169.00,260,93,'https://images.unsplash.com/photo-1513883049090-d0b7439799bf?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1513883049090-d0b7439799bf?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"供电\": \"USB/电池双供电\", \"尺寸\": \"110mm*110mm*145mm\", \"材质\": \"树脂+木底座\"}','[\"72小时内发货\", \"一年质保\"]',2,4.50,40,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','摆件类'),(5,'CC-TEST-005','雪乡木屋香薰蜡烛','松木与雪松调，冬日治愈香氛','candle','香薰',58.00,89.00,350,167,'https://images.unsplash.com/photo-1603006905003-be475563bc59?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1603006905003-be475563bc59?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1493666438817-866a91353ca9?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"香调\": \"松木/雪松/琥珀\", \"净含量\": \"180g\", \"燃烧时长\": \"约36小时\"}','[\"48小时内发货\", \"支持礼盒包装\"]',2,5.00,50,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','生活方式类'),(6,'CC-TEST-006','亚布力滑雪熊玩偶','软萌造型，亲肤短绒面料','plush','玩偶',79.00,109.00,290,141,'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"材质\": \"超柔短绒+PP棉\", \"洗护\": \"建议手洗\", \"高度\": \"约28cm\"}','[\"48小时内发货\", \"7天无理由退货\"]',2,4.50,60,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','玩具类'),(7,'CC-TEST-007','北极村极光保温杯','316不锈钢，长效保温','thermos','保温杯',99.00,139.00,480,226,'https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1523362628745-0c100150b504?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"保温\": \"6小时约65℃\", \"容量\": \"480ml\", \"材质\": \"316内胆+304外壳\"}','[\"48小时内发货\", \"支持刻字定制\"]',2,4.00,70,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','实用器具类'),(8,'CC-TEST-008','松花江冬捕帆布袋','加厚帆布，通勤购物两用','tote_bag','帆布袋',39.90,59.00,620,309,'https://images.unsplash.com/photo-1591561954557-26941169b49e?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1591561954557-26941169b49e?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"尺寸\": \"360mm*380mm\", \"材质\": \"12安纯棉帆布\", \"肩带\": \"650mm\"}','[\"24小时内发货\", \"支持企业团购印刷\"]',2,4.50,80,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','文创周边类'),(9,'CC-TEST-009','冰灯剪影金属书签','镂空蚀刻，阅读伴侣','bookmark','书签',19.90,29.90,980,501,'https://images.unsplash.com/photo-1474932430478-367dbb6832c1?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1474932430478-367dbb6832c1?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}]','{\"尺寸\": \"120mm*35mm\", \"工艺\": \"激光蚀刻\", \"材质\": \"黄铜镀镍\"}','[\"24小时内发货\", \"满2件包邮\"]',2,5.00,90,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','阅读文具类'),(10,'CC-TEST-010','雪国列车拼装木质模型','亲子拼装，收藏展示','wood_model','模型',149.00,199.00,210,74,'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?auto=format&fit=crop&w=1200&q=80','[{\"url\": \"https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1, \"isCover\": 1}, {\"url\": \"https://images.unsplash.com/photo-1511497584788-876760111969?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2, \"isCover\": 0}, {\"url\": \"https://images.unsplash.com/photo-1481627834876-b7833e8f5570?auto=format&fit=crop&w=1200&q=80\", \"sort\": 3, \"isCover\": 0}]','{\"材质\": \"椴木板材\", \"片数\": \"186片\", \"完成尺寸\": \"320mm*68mm*102mm\"}','[\"72小时内发货\", \"缺件免费补发\"]',2,5.00,100,'0','admin','2026-04-25 21:52:54','admin','2026-04-25 21:52:55','模型拼装类');
/*!40000 ALTER TABLE `cultural_creative_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table`
--

DROP TABLE IF EXISTS `gen_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table` (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
  `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table`
--

LOCK TABLES `gen_table` WRITE;
/*!40000 ALTER TABLE `gen_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `gen_table_column`
--

DROP TABLE IF EXISTS `gen_table_column`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `gen_table_column` (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
  `sort` int DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='代码生成业务表字段';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `gen_table_column`
--

LOCK TABLES `gen_table_column` WRITE;
/*!40000 ALTER TABLE `gen_table_column` DISABLE KEYS */;
/*!40000 ALTER TABLE `gen_table_column` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_id` bigint NOT NULL COMMENT '订单ID（关联 orders.id）',
  `order_no` varchar(32) NOT NULL COMMENT '订单号冗余（便于按订单号查询）',
  `user_id` bigint NOT NULL COMMENT '用户ID冗余（便于分用户查询）',
  `product_id` bigint NOT NULL COMMENT '商品ID',
  `product_code` varchar(64) DEFAULT NULL COMMENT '商品编码快照',
  `product_title` varchar(128) NOT NULL COMMENT '商品标题快照',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品图片快照',
  `sku_text` varchar(255) DEFAULT NULL COMMENT '规格文案快照',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '下单时单价',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `item_amount` decimal(10,2) GENERATED ALWAYS AS ((`unit_price` * `quantity`)) STORED COMMENT '行小计',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_item_order_id` (`order_id`),
  KEY `idx_item_order_no` (`order_no`),
  KEY `idx_item_user_ctime` (`user_id`,`create_time`),
  CONSTRAINT `fk_item_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `chk_item_quantity` CHECK ((`quantity` >= 1)),
  CONSTRAINT `chk_item_unit_price` CHECK ((`unit_price` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` (`id`, `order_id`, `order_no`, `user_id`, `product_id`, `product_code`, `product_title`, `product_image`, `sku_text`, `unit_price`, `quantity`, `create_time`, `update_time`) VALUES (1,1,'2026042616184035200100',100,2,'CC-TEST-002','中央大街雪花珐琅胸针','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',NULL,45.00,1,'2026-04-26 16:18:40','2026-04-26 16:18:40'),(2,2,'2026042616224233400100',100,2,'CC-TEST-002','中央大街雪花珐琅胸针','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',NULL,45.00,2,'2026-04-26 16:22:42','2026-04-26 16:22:42'),(3,3,'2026042616383072900100',100,2,'CC-TEST-002','中央大街雪花珐琅胸针','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',NULL,45.00,3,'2026-04-26 16:38:30','2026-04-26 16:38:30');
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_payment`
--

DROP TABLE IF EXISTS `order_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_payment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `payment_no` varchar(40) NOT NULL COMMENT '支付单号（业务唯一）',
  `order_no` varchar(32) NOT NULL COMMENT '订单号',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '支付金额',
  `pay_channel` varchar(20) NOT NULL DEFAULT 'MOCK' COMMENT '支付渠道（WECHAT/ALIPAY/MOCK）',
  `pay_status` char(1) NOT NULL DEFAULT '0' COMMENT '支付状态（0待支付 1成功 2失败）',
  `transaction_no` varchar(64) DEFAULT NULL COMMENT '第三方交易号',
  `callback_payload` text COMMENT '回调原文',
  `fail_reason` varchar(255) DEFAULT NULL COMMENT '失败原因',
  `paid_time` datetime DEFAULT NULL COMMENT '支付成功时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_payment_no` (`payment_no`),
  KEY `idx_payment_order_no` (`order_no`),
  KEY `idx_payment_user_ctime` (`user_id`,`create_time`),
  KEY `idx_payment_txn_no` (`transaction_no`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` >= 0)),
  CONSTRAINT `chk_payment_status` CHECK ((`pay_status` in (_utf8mb4'0',_utf8mb4'1',_utf8mb4'2')))
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单支付流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_payment`
--

LOCK TABLES `order_payment` WRITE;
/*!40000 ALTER TABLE `order_payment` DISABLE KEYS */;
INSERT INTO `order_payment` VALUES (1,'PAY20260426163835003900100','2026042616383072900100',100,135.00,'WECHAT','1','MOCK-1777192714986-a69a95','{\"source\":\"snowTravel-payment-page\",\"payMethod\":\"WECHAT\",\"orderNo\":\"2026042616383072900100\",\"amount\":135}',NULL,'2026-04-26 16:38:35','2026-04-26 16:38:35','2026-04-26 16:38:35');
/*!40000 ALTER TABLE `order_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_no` varchar(32) NOT NULL COMMENT '订单号（业务唯一）',
  `user_id` bigint NOT NULL COMMENT '下单用户ID',
  `order_status` char(1) NOT NULL DEFAULT '0' COMMENT '订单状态（0待支付 1已支付 2已取消 3已发货 4已完成）',
  `pay_status` char(1) NOT NULL DEFAULT '0' COMMENT '支付状态（0未支付 1已支付）',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单总金额（商品总额）',
  `pay_amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '实付金额',
  `receiver_name` varchar(64) NOT NULL COMMENT '收货人',
  `receiver_phone` varchar(20) NOT NULL COMMENT '收货电话',
  `receiver_address` varchar(255) NOT NULL COMMENT '收货地址',
  `remark` varchar(255) DEFAULT NULL COMMENT '订单备注',
  `pay_time` datetime DEFAULT NULL COMMENT '支付时间',
  `cancel_time` datetime DEFAULT NULL COMMENT '取消时间',
  `ship_time` datetime DEFAULT NULL COMMENT '发货时间',
  `finish_time` datetime DEFAULT NULL COMMENT '完成时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_orders_order_no` (`order_no`),
  KEY `idx_orders_user_status_ctime` (`user_id`,`order_status`,`create_time`),
  KEY `idx_orders_create_time` (`create_time`),
  CONSTRAINT `chk_orders_pay_amount` CHECK ((`pay_amount` >= 0)),
  CONSTRAINT `chk_orders_pay_status` CHECK ((`pay_status` in (_utf8mb4'0',_utf8mb4'1'))),
  CONSTRAINT `chk_orders_status` CHECK ((`order_status` in (_utf8mb4'0',_utf8mb4'1',_utf8mb4'2',_utf8mb4'3',_utf8mb4'4'))),
  CONSTRAINT `chk_orders_total_amount` CHECK ((`total_amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'2026042616184035200100',100,'2','0',45.00,45.00,'张三','13800138000','黑龙江省哈尔滨市道里区中央大街','',NULL,NULL,NULL,NULL,'2026-04-26 16:18:40','2026-04-26 16:18:50'),(2,'2026042616224233400100',100,'2','0',90.00,90.00,'默认收货人','13800138000','黑龙江省哈尔滨市道里区中央大街','',NULL,NULL,NULL,NULL,'2026-04-26 16:22:42','2026-04-26 16:37:15'),(3,'2026042616383072900100',100,'1','1',135.00,135.00,'默认收货人','13800138000','黑龙江省哈尔滨市道里区中央大街','',NULL,NULL,NULL,NULL,'2026-04-26 16:38:30','2026-04-26 16:38:35');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shopping_cart`
--

DROP TABLE IF EXISTS `shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shopping_cart` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` bigint NOT NULL COMMENT '用户ID（关联 sys_user.user_id）',
  `product_id` bigint NOT NULL COMMENT '商品ID（关联 cultural_creative_products.id）',
  `product_code` varchar(64) DEFAULT NULL COMMENT '商品编码快照',
  `product_title` varchar(128) NOT NULL COMMENT '商品标题快照',
  `product_sub_title` varchar(255) DEFAULT NULL COMMENT '商品副标题快照',
  `product_image` varchar(255) DEFAULT NULL COMMENT '商品封面图快照',
  `sku_text` varchar(255) DEFAULT NULL COMMENT '规格文案快照（如颜色/尺寸）',
  `unit_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '加入购物车时单价快照',
  `quantity` int NOT NULL DEFAULT '1' COMMENT '购买数量',
  `is_checked` char(1) NOT NULL DEFAULT '1' COMMENT '勾选状态（1选中 0未选中）',
  `item_amount` decimal(10,2) GENERATED ALWAYS AS ((`unit_price` * `quantity`)) STORED COMMENT '行小计（单价*数量）',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '记录状态（0正常 1失效 2已下单）',
  `invalid_reason` varchar(255) DEFAULT NULL COMMENT '失效原因（如下架/库存不足）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cart_user_product` (`user_id`,`product_id`),
  KEY `idx_cart_user_status_update` (`user_id`,`status`,`update_time`),
  KEY `idx_cart_user_checked_status` (`user_id`,`is_checked`,`status`),
  KEY `idx_cart_product` (`product_id`),
  CONSTRAINT `chk_cart_checked` CHECK ((`is_checked` in (_utf8mb4'0',_utf8mb4'1'))),
  CONSTRAINT `chk_cart_quantity` CHECK ((`quantity` >= 1)),
  CONSTRAINT `chk_cart_status` CHECK ((`status` in (_utf8mb4'0',_utf8mb4'1',_utf8mb4'2')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shopping_cart`
--

LOCK TABLES `shopping_cart` WRITE;
/*!40000 ALTER TABLE `shopping_cart` DISABLE KEYS */;
INSERT INTO `shopping_cart` (`id`, `user_id`, `product_id`, `product_code`, `product_title`, `product_sub_title`, `product_image`, `sku_text`, `unit_price`, `quantity`, `is_checked`, `status`, `invalid_reason`, `create_time`, `update_time`) VALUES (5,100,2,'CC-TEST-002','中央大街雪花珐琅胸针','法式珐琅工艺，冬季穿搭点睛','https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=1200&q=80',NULL,45.00,3,'1','2',NULL,'2026-04-26 16:18:27','2026-04-26 16:38:30');
/*!40000 ALTER TABLE `shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='参数配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` VALUES (1,'主框架页-默认皮肤样式名称','sys.index.skinName','skin-blue','Y','admin','2026-04-25 10:31:33','',NULL,'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow'),(2,'用户管理-账号初始密码','sys.user.initPassword','123456','Y','admin','2026-04-25 10:31:33','',NULL,'初始化密码 123456'),(3,'主框架页-侧边栏主题','sys.index.sideTheme','theme-dark','Y','admin','2026-04-25 10:31:33','',NULL,'深色主题theme-dark，浅色主题theme-light'),(4,'账号自助-验证码开关','sys.account.captchaEnabled','true','Y','admin','2026-04-25 10:31:33','',NULL,'是否开启验证码功能（true开启，false关闭）'),(5,'账号自助-是否开启用户注册功能','sys.account.registerUser','true','Y','admin','2026-04-25 10:31:33','admin','2026-04-25 11:28:22','是否开启注册用户功能（true开启，false关闭）'),(6,'用户登录-黑名单列表','sys.login.blackIPList','','Y','admin','2026-04-25 10:31:33','',NULL,'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dept`
--

DROP TABLE IF EXISTS `sys_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dept` (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
  `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `leader` varchar(20) DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=200 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='部门表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dept`
--

LOCK TABLES `sys_dept` WRITE;
/*!40000 ALTER TABLE `sys_dept` DISABLE KEYS */;
INSERT INTO `sys_dept` VALUES (100,0,'0','若依科技',0,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(101,100,'0,100','深圳总公司',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(102,100,'0,100','长沙分公司',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(103,101,'0,100,101','研发部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(104,101,'0,100,101','市场部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(105,101,'0,100,101','测试部门',3,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(106,101,'0,100,101','财务部门',4,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(107,101,'0,100,101','运维部门',5,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(108,102,'0,100,102','市场部门',1,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL),(109,102,'0,100,102','财务部门',2,'若依','15888888888','ry@qq.com','0','0','admin','2026-04-25 10:31:31','',NULL);
/*!40000 ALTER TABLE `sys_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_data`
--

DROP TABLE IF EXISTS `sys_dict_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_data` (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int DEFAULT '0' COMMENT '字典排序',
  `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典数据表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_data`
--

LOCK TABLES `sys_dict_data` WRITE;
/*!40000 ALTER TABLE `sys_dict_data` DISABLE KEYS */;
INSERT INTO `sys_dict_data` VALUES (1,1,'男','0','sys_user_sex','','','Y','0','admin','2026-04-25 10:31:32','',NULL,'性别男'),(2,2,'女','1','sys_user_sex','','','N','0','admin','2026-04-25 10:31:32','',NULL,'性别女'),(3,3,'未知','2','sys_user_sex','','','N','0','admin','2026-04-25 10:31:32','',NULL,'性别未知'),(4,1,'显示','0','sys_show_hide','','primary','Y','0','admin','2026-04-25 10:31:32','',NULL,'显示菜单'),(5,2,'隐藏','1','sys_show_hide','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'隐藏菜单'),(6,1,'正常','0','sys_normal_disable','','primary','Y','0','admin','2026-04-25 10:31:32','',NULL,'正常状态'),(7,2,'停用','1','sys_normal_disable','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'停用状态'),(8,1,'正常','0','sys_job_status','','primary','Y','0','admin','2026-04-25 10:31:32','',NULL,'正常状态'),(9,2,'暂停','1','sys_job_status','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'停用状态'),(10,1,'默认','DEFAULT','sys_job_group','','','Y','0','admin','2026-04-25 10:31:32','',NULL,'默认分组'),(11,2,'系统','SYSTEM','sys_job_group','','','N','0','admin','2026-04-25 10:31:32','',NULL,'系统分组'),(12,1,'是','Y','sys_yes_no','','primary','Y','0','admin','2026-04-25 10:31:32','',NULL,'系统默认是'),(13,2,'否','N','sys_yes_no','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'系统默认否'),(14,1,'通知','1','sys_notice_type','','warning','Y','0','admin','2026-04-25 10:31:32','',NULL,'通知'),(15,2,'公告','2','sys_notice_type','','success','N','0','admin','2026-04-25 10:31:32','',NULL,'公告'),(16,1,'正常','0','sys_notice_status','','primary','Y','0','admin','2026-04-25 10:31:32','',NULL,'正常状态'),(17,2,'关闭','1','sys_notice_status','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'关闭状态'),(18,99,'其他','0','sys_oper_type','','info','N','0','admin','2026-04-25 10:31:32','',NULL,'其他操作'),(19,1,'新增','1','sys_oper_type','','info','N','0','admin','2026-04-25 10:31:32','',NULL,'新增操作'),(20,2,'修改','2','sys_oper_type','','info','N','0','admin','2026-04-25 10:31:32','',NULL,'修改操作'),(21,3,'删除','3','sys_oper_type','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'删除操作'),(22,4,'授权','4','sys_oper_type','','primary','N','0','admin','2026-04-25 10:31:32','',NULL,'授权操作'),(23,5,'导出','5','sys_oper_type','','warning','N','0','admin','2026-04-25 10:31:32','',NULL,'导出操作'),(24,6,'导入','6','sys_oper_type','','warning','N','0','admin','2026-04-25 10:31:32','',NULL,'导入操作'),(25,7,'强退','7','sys_oper_type','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'强退操作'),(26,8,'生成代码','8','sys_oper_type','','warning','N','0','admin','2026-04-25 10:31:32','',NULL,'生成操作'),(27,9,'清空数据','9','sys_oper_type','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'清空操作'),(28,1,'成功','0','sys_common_status','','primary','N','0','admin','2026-04-25 10:31:32','',NULL,'正常状态'),(29,2,'失败','1','sys_common_status','','danger','N','0','admin','2026-04-25 10:31:32','',NULL,'停用状态'),(30,1,'上架','0','biz_tour_group_status','','success','Y','0','admin','2026-04-25 22:22:19','',NULL,'tour_groups.status=0'),(31,2,'下架','1','biz_tour_group_status','','info','N','0','admin','2026-04-25 22:22:19','',NULL,'tour_groups.status=1'),(32,1,'正常','0','biz_tour_group_detail_status','','primary','Y','0','admin','2026-04-25 22:22:19','',NULL,'tour_group_details.status=0'),(33,2,'停用','1','biz_tour_group_detail_status','','danger','N','0','admin','2026-04-25 22:22:19','',NULL,'tour_group_details.status=1'),(100,1,'待支付','0','biz_order_status','','warning','Y','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status=0'),(101,2,'已支付','1','biz_order_status','','primary','N','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status=1'),(102,3,'已取消','2','biz_order_status','','danger','N','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status=2'),(103,4,'已发货','3','biz_order_status','','info','N','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status=3'),(104,5,'已完成','4','biz_order_status','','success','N','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status=4'),(105,1,'未支付','0','biz_pay_status','','warning','Y','0','admin','2026-04-26 16:02:40','',NULL,'orders.pay_status=0'),(106,2,'已支付','1','biz_pay_status','','success','N','0','admin','2026-04-26 16:02:40','',NULL,'orders.pay_status=1'),(107,1,'微信支付','WECHAT','biz_pay_channel','','success','Y','0','admin','2026-04-26 16:37:52','',NULL,'微信支付渠道'),(108,2,'支付宝','ALIPAY','biz_pay_channel','','primary','N','0','admin','2026-04-26 16:37:52','',NULL,'支付宝支付渠道');
/*!40000 ALTER TABLE `sys_dict_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict_type`
--

DROP TABLE IF EXISTS `sys_dict_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict_type` (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`),
  UNIQUE KEY `dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='字典类型表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict_type`
--

LOCK TABLES `sys_dict_type` WRITE;
/*!40000 ALTER TABLE `sys_dict_type` DISABLE KEYS */;
INSERT INTO `sys_dict_type` VALUES (1,'用户性别','sys_user_sex','0','admin','2026-04-25 10:31:32','',NULL,'用户性别列表'),(2,'菜单状态','sys_show_hide','0','admin','2026-04-25 10:31:32','',NULL,'菜单状态列表'),(3,'系统开关','sys_normal_disable','0','admin','2026-04-25 10:31:32','',NULL,'系统开关列表'),(4,'任务状态','sys_job_status','0','admin','2026-04-25 10:31:32','',NULL,'任务状态列表'),(5,'任务分组','sys_job_group','0','admin','2026-04-25 10:31:32','',NULL,'任务分组列表'),(6,'系统是否','sys_yes_no','0','admin','2026-04-25 10:31:32','',NULL,'系统是否列表'),(7,'通知类型','sys_notice_type','0','admin','2026-04-25 10:31:32','',NULL,'通知类型列表'),(8,'通知状态','sys_notice_status','0','admin','2026-04-25 10:31:32','',NULL,'通知状态列表'),(9,'操作类型','sys_oper_type','0','admin','2026-04-25 10:31:32','',NULL,'操作类型列表'),(10,'系统状态','sys_common_status','0','admin','2026-04-25 10:31:32','',NULL,'登录状态列表'),(11,'旅游团上架状态','biz_tour_group_status','0','admin','2026-04-25 22:22:19','',NULL,'tour_groups.status 字典'),(12,'旅游团详情状态','biz_tour_group_detail_status','0','admin','2026-04-25 22:22:19','',NULL,'tour_group_details.status 字典'),(100,'订单状态','biz_order_status','0','admin','2026-04-26 16:02:40','',NULL,'orders.order_status 字典'),(101,'支付状态','biz_pay_status','0','admin','2026-04-26 16:02:40','',NULL,'orders.pay_status 字典'),(102,'支付渠道','biz_pay_channel','0','admin','2026-04-26 16:37:52','',NULL,'order_payment.pay_channel 字典');
/*!40000 ALTER TABLE `sys_dict_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job`
--

DROP TABLE IF EXISTS `sys_job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job` (
  `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
  `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
  `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`job_id`,`job_name`,`job_group`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job`
--

LOCK TABLES `sys_job` WRITE;
/*!40000 ALTER TABLE `sys_job` DISABLE KEYS */;
INSERT INTO `sys_job` VALUES (1,'系统默认（无参）','DEFAULT','ryTask.ryNoParams','0/10 * * * * ?','3','1','1','admin','2026-04-25 10:31:33','',NULL,''),(2,'系统默认（有参）','DEFAULT','ryTask.ryParams(\'ry\')','0/15 * * * * ?','3','1','1','admin','2026-04-25 10:31:33','',NULL,''),(3,'系统默认（多参）','DEFAULT','ryTask.ryMultipleParams(\'ry\', true, 2000L, 316.50D, 100)','0/20 * * * * ?','3','1','1','admin','2026-04-25 10:31:33','',NULL,''),(100,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','0 */1 * * * ?','3','1','0','admin','2026-04-26 16:13:39','',NULL,'每分钟执行一次，自动取消超过15分钟未支付订单');
/*!40000 ALTER TABLE `sys_job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_job_log`
--

DROP TABLE IF EXISTS `sys_job_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_job_log` (
  `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
  `job_name` varchar(64) NOT NULL COMMENT '任务名称',
  `job_group` varchar(64) NOT NULL COMMENT '任务组名',
  `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
  `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
  `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
  `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`job_log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='定时任务调度日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_job_log`
--

LOCK TABLES `sys_job_log` WRITE;
/*!40000 ALTER TABLE `sys_job_log` DISABLE KEYS */;
INSERT INTO `sys_job_log` VALUES (1,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：65毫秒','0','','2026-04-26 16:14:00'),(2,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：17毫秒','0','','2026-04-26 16:15:00'),(3,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:16:00'),(4,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：16毫秒','0','','2026-04-26 16:17:00'),(5,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 16:18:00'),(6,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 16:19:00'),(7,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:20:00'),(8,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:21:00'),(9,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：14毫秒','0','','2026-04-26 16:22:00'),(10,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:23:00'),(11,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:24:00'),(12,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:25:00'),(13,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：19毫秒','0','','2026-04-26 16:27:00'),(14,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 16:28:00'),(15,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：34毫秒','0','','2026-04-26 16:29:00'),(16,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:30:00'),(17,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:31:00'),(18,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:32:00'),(19,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：11毫秒','0','','2026-04-26 16:33:00'),(20,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:34:00'),(21,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 16:35:00'),(22,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:36:00'),(23,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:37:00'),(24,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 16:39:00'),(25,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:40:00'),(26,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 16:41:00'),(27,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：11毫秒','0','','2026-04-26 16:42:00'),(28,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：12毫秒','0','','2026-04-26 16:43:00'),(29,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：0毫秒','0','','2026-04-26 16:44:00'),(30,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 16:45:00'),(31,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：11毫秒','0','','2026-04-26 16:46:00'),(32,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:47:00'),(33,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：12毫秒','0','','2026-04-26 16:48:00'),(34,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 16:49:00'),(35,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 16:50:00'),(36,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：15毫秒','0','','2026-04-26 16:51:00'),(37,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：11毫秒','0','','2026-04-26 16:52:00'),(38,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:53:00'),(39,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 16:54:00'),(40,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:55:00'),(41,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 16:56:00'),(42,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 16:57:00'),(43,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：10毫秒','0','','2026-04-26 16:58:00'),(44,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：0毫秒','0','','2026-04-26 16:59:00'),(45,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：0毫秒','0','','2026-04-26 17:00:00'),(46,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：3毫秒','0','','2026-04-26 17:01:00'),(47,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:02:00'),(48,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:03:00'),(49,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：9毫秒','0','','2026-04-26 17:04:00'),(50,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 17:05:00'),(51,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:06:00'),(52,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 17:07:00'),(53,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：2毫秒','0','','2026-04-26 17:08:00'),(54,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：0毫秒','0','','2026-04-26 17:09:00'),(55,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:10:00'),(56,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 17:11:00'),(57,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：7毫秒','0','','2026-04-26 17:12:00'),(58,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：0毫秒','0','','2026-04-26 17:13:00'),(59,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：2毫秒','0','','2026-04-26 17:14:00'),(60,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：3毫秒','0','','2026-04-26 17:15:00'),(61,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 17:16:00'),(62,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:17:00'),(63,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:18:00'),(64,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:19:00'),(65,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:20:00'),(66,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 17:21:00'),(67,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:22:00'),(68,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:23:00'),(69,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:24:00'),(70,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：6毫秒','0','','2026-04-26 17:25:00'),(71,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：5毫秒','0','','2026-04-26 17:26:00'),(72,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：8毫秒','0','','2026-04-26 17:27:00'),(73,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：4毫秒','0','','2026-04-26 17:28:00'),(74,'订单超时自动取消','DEFAULT','orderTask.cancelTimeoutOrders()','订单超时自动取消 总共耗时：3毫秒','0','','2026-04-26 17:29:00');
/*!40000 ALTER TABLE `sys_job_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_logininfor`
--

DROP TABLE IF EXISTS `sys_logininfor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_logininfor` (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`),
  KEY `idx_sys_logininfor_s` (`status`),
  KEY `idx_sys_logininfor_lt` (`login_time`)
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统访问记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_logininfor`
--

LOCK TABLES `sys_logininfor` WRITE;
/*!40000 ALTER TABLE `sys_logininfor` DISABLE KEYS */;
INSERT INTO `sys_logininfor` VALUES (100,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 10:56:17'),(101,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 11:27:57'),(102,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','注册成功','2026-04-25 11:36:07'),(103,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-25 11:36:14'),(104,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 11:36:19'),(105,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-04-25 11:44:13'),(106,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-25 12:09:56'),(107,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 12:10:01'),(108,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 13:41:44'),(109,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 14:45:36'),(110,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','退出成功','2026-04-25 15:02:16'),(111,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-25 15:16:50'),(112,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 15:16:53'),(113,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-25 15:17:12'),(114,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 15:17:15'),(115,'23033101','127.0.0.1','内网IP','Chrome 14','Windows 10','0','注册成功','2026-04-25 20:13:12'),(116,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-25 20:40:03'),(117,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 20:40:08'),(118,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 21:21:14'),(119,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-25 22:18:02'),(120,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-26 14:32:54'),(121,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-26 14:34:01'),(122,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-26 14:34:05'),(123,'23033112','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-26 15:32:40'),(124,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','1','验证码已失效','2026-04-26 16:17:27'),(125,'admin','127.0.0.1','内网IP','Chrome 14','Windows 10','0','登录成功','2026-04-26 16:17:31');
/*!40000 ALTER TABLE `sys_logininfor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_menu`
--

DROP TABLE IF EXISTS `sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_menu` (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
  `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
  `order_num` int DEFAULT '0' COMMENT '显示顺序',
  `path` varchar(200) DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) DEFAULT '' COMMENT '路由名称',
  `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
  `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2006 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='菜单权限表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_menu`
--

LOCK TABLES `sys_menu` WRITE;
/*!40000 ALTER TABLE `sys_menu` DISABLE KEYS */;
INSERT INTO `sys_menu` VALUES (1,'系统管理',0,1,'system',NULL,'','',1,0,'M','0','0','','system','admin','2026-04-25 10:31:31','',NULL,'系统管理目录'),(2,'系统监控',0,2,'monitor',NULL,'','',1,0,'M','0','0','','monitor','admin','2026-04-25 10:31:31','',NULL,'系统监控目录'),(3,'系统工具',0,3,'tool',NULL,'','',1,0,'M','0','0','','tool','admin','2026-04-25 10:31:31','',NULL,'系统工具目录'),(4,'若依官网',0,4,'http://ruoyi.vip',NULL,'','',0,0,'M','0','0','','guide','admin','2026-04-25 10:31:31','',NULL,'若依官网地址'),(100,'用户管理',1,1,'user','system/user/index','','',1,0,'C','0','0','system:user:list','user','admin','2026-04-25 10:31:31','',NULL,'用户管理菜单'),(101,'角色管理',1,2,'role','system/role/index','','',1,0,'C','0','0','system:role:list','peoples','admin','2026-04-25 10:31:31','',NULL,'角色管理菜单'),(102,'菜单管理',1,3,'menu','system/menu/index','','',1,0,'C','0','0','system:menu:list','tree-table','admin','2026-04-25 10:31:31','',NULL,'菜单管理菜单'),(103,'部门管理',1,4,'dept','system/dept/index','','',1,0,'C','0','0','system:dept:list','tree','admin','2026-04-25 10:31:31','',NULL,'部门管理菜单'),(104,'岗位管理',1,5,'post','system/post/index','','',1,0,'C','0','0','system:post:list','post','admin','2026-04-25 10:31:31','',NULL,'岗位管理菜单'),(105,'字典管理',1,6,'dict','system/dict/index','','',1,0,'C','0','0','system:dict:list','dict','admin','2026-04-25 10:31:31','',NULL,'字典管理菜单'),(106,'参数设置',1,7,'config','system/config/index','','',1,0,'C','0','0','system:config:list','edit','admin','2026-04-25 10:31:31','',NULL,'参数设置菜单'),(107,'通知公告',1,8,'notice','system/notice/index','','',1,0,'C','0','0','system:notice:list','message','admin','2026-04-25 10:31:31','',NULL,'通知公告菜单'),(108,'日志管理',1,9,'log','','','',1,0,'M','0','0','','log','admin','2026-04-25 10:31:31','',NULL,'日志管理菜单'),(109,'在线用户',2,1,'online','monitor/online/index','','',1,0,'C','0','0','monitor:online:list','online','admin','2026-04-25 10:31:31','',NULL,'在线用户菜单'),(110,'定时任务',2,2,'job','monitor/job/index','','',1,0,'C','0','0','monitor:job:list','job','admin','2026-04-25 10:31:31','',NULL,'定时任务菜单'),(111,'数据监控',2,3,'druid','monitor/druid/index','','',1,0,'C','0','0','monitor:druid:list','druid','admin','2026-04-25 10:31:31','',NULL,'数据监控菜单'),(112,'服务监控',2,4,'server','monitor/server/index','','',1,0,'C','0','0','monitor:server:list','server','admin','2026-04-25 10:31:31','',NULL,'服务监控菜单'),(113,'缓存监控',2,5,'cache','monitor/cache/index','','',1,0,'C','0','0','monitor:cache:list','redis','admin','2026-04-25 10:31:31','',NULL,'缓存监控菜单'),(114,'缓存列表',2,6,'cacheList','monitor/cache/list','','',1,0,'C','0','0','monitor:cache:list','redis-list','admin','2026-04-25 10:31:31','',NULL,'缓存列表菜单'),(115,'表单构建',3,1,'build','tool/build/index','','',1,0,'C','0','0','tool:build:list','build','admin','2026-04-25 10:31:31','',NULL,'表单构建菜单'),(116,'代码生成',3,2,'gen','tool/gen/index','','',1,0,'C','0','0','tool:gen:list','code','admin','2026-04-25 10:31:31','',NULL,'代码生成菜单'),(117,'系统接口',3,3,'swagger','tool/swagger/index','','',1,0,'C','0','0','tool:swagger:list','swagger','admin','2026-04-25 10:31:31','',NULL,'系统接口菜单'),(500,'操作日志',108,1,'operlog','monitor/operlog/index','','',1,0,'C','0','0','monitor:operlog:list','form','admin','2026-04-25 10:31:31','',NULL,'操作日志菜单'),(501,'登录日志',108,2,'logininfor','monitor/logininfor/index','','',1,0,'C','0','0','monitor:logininfor:list','logininfor','admin','2026-04-25 10:31:31','',NULL,'登录日志菜单'),(1000,'用户查询',100,1,'','','','',1,0,'F','0','0','system:user:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1001,'用户新增',100,2,'','','','',1,0,'F','0','0','system:user:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1002,'用户修改',100,3,'','','','',1,0,'F','0','0','system:user:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1003,'用户删除',100,4,'','','','',1,0,'F','0','0','system:user:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1004,'用户导出',100,5,'','','','',1,0,'F','0','0','system:user:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1005,'用户导入',100,6,'','','','',1,0,'F','0','0','system:user:import','#','admin','2026-04-25 10:31:31','',NULL,''),(1006,'重置密码',100,7,'','','','',1,0,'F','0','0','system:user:resetPwd','#','admin','2026-04-25 10:31:31','',NULL,''),(1007,'角色查询',101,1,'','','','',1,0,'F','0','0','system:role:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1008,'角色新增',101,2,'','','','',1,0,'F','0','0','system:role:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1009,'角色修改',101,3,'','','','',1,0,'F','0','0','system:role:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1010,'角色删除',101,4,'','','','',1,0,'F','0','0','system:role:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1011,'角色导出',101,5,'','','','',1,0,'F','0','0','system:role:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1012,'菜单查询',102,1,'','','','',1,0,'F','0','0','system:menu:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1013,'菜单新增',102,2,'','','','',1,0,'F','0','0','system:menu:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1014,'菜单修改',102,3,'','','','',1,0,'F','0','0','system:menu:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1015,'菜单删除',102,4,'','','','',1,0,'F','0','0','system:menu:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1016,'部门查询',103,1,'','','','',1,0,'F','0','0','system:dept:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1017,'部门新增',103,2,'','','','',1,0,'F','0','0','system:dept:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1018,'部门修改',103,3,'','','','',1,0,'F','0','0','system:dept:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1019,'部门删除',103,4,'','','','',1,0,'F','0','0','system:dept:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1020,'岗位查询',104,1,'','','','',1,0,'F','0','0','system:post:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1021,'岗位新增',104,2,'','','','',1,0,'F','0','0','system:post:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1022,'岗位修改',104,3,'','','','',1,0,'F','0','0','system:post:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1023,'岗位删除',104,4,'','','','',1,0,'F','0','0','system:post:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1024,'岗位导出',104,5,'','','','',1,0,'F','0','0','system:post:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1025,'字典查询',105,1,'#','','','',1,0,'F','0','0','system:dict:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1026,'字典新增',105,2,'#','','','',1,0,'F','0','0','system:dict:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1027,'字典修改',105,3,'#','','','',1,0,'F','0','0','system:dict:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1028,'字典删除',105,4,'#','','','',1,0,'F','0','0','system:dict:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1029,'字典导出',105,5,'#','','','',1,0,'F','0','0','system:dict:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1030,'参数查询',106,1,'#','','','',1,0,'F','0','0','system:config:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1031,'参数新增',106,2,'#','','','',1,0,'F','0','0','system:config:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1032,'参数修改',106,3,'#','','','',1,0,'F','0','0','system:config:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1033,'参数删除',106,4,'#','','','',1,0,'F','0','0','system:config:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1034,'参数导出',106,5,'#','','','',1,0,'F','0','0','system:config:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1035,'公告查询',107,1,'#','','','',1,0,'F','0','0','system:notice:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1036,'公告新增',107,2,'#','','','',1,0,'F','0','0','system:notice:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1037,'公告修改',107,3,'#','','','',1,0,'F','0','0','system:notice:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1038,'公告删除',107,4,'#','','','',1,0,'F','0','0','system:notice:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1039,'操作查询',500,1,'#','','','',1,0,'F','0','0','monitor:operlog:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1040,'操作删除',500,2,'#','','','',1,0,'F','0','0','monitor:operlog:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1041,'日志导出',500,3,'#','','','',1,0,'F','0','0','monitor:operlog:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1042,'登录查询',501,1,'#','','','',1,0,'F','0','0','monitor:logininfor:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1043,'登录删除',501,2,'#','','','',1,0,'F','0','0','monitor:logininfor:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1044,'日志导出',501,3,'#','','','',1,0,'F','0','0','monitor:logininfor:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1045,'账户解锁',501,4,'#','','','',1,0,'F','0','0','monitor:logininfor:unlock','#','admin','2026-04-25 10:31:31','',NULL,''),(1046,'在线查询',109,1,'#','','','',1,0,'F','0','0','monitor:online:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1047,'批量强退',109,2,'#','','','',1,0,'F','0','0','monitor:online:batchLogout','#','admin','2026-04-25 10:31:31','',NULL,''),(1048,'单条强退',109,3,'#','','','',1,0,'F','0','0','monitor:online:forceLogout','#','admin','2026-04-25 10:31:31','',NULL,''),(1049,'任务查询',110,1,'#','','','',1,0,'F','0','0','monitor:job:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1050,'任务新增',110,2,'#','','','',1,0,'F','0','0','monitor:job:add','#','admin','2026-04-25 10:31:31','',NULL,''),(1051,'任务修改',110,3,'#','','','',1,0,'F','0','0','monitor:job:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1052,'任务删除',110,4,'#','','','',1,0,'F','0','0','monitor:job:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1053,'状态修改',110,5,'#','','','',1,0,'F','0','0','monitor:job:changeStatus','#','admin','2026-04-25 10:31:31','',NULL,''),(1054,'任务导出',110,6,'#','','','',1,0,'F','0','0','monitor:job:export','#','admin','2026-04-25 10:31:31','',NULL,''),(1055,'生成查询',116,1,'#','','','',1,0,'F','0','0','tool:gen:query','#','admin','2026-04-25 10:31:31','',NULL,''),(1056,'生成修改',116,2,'#','','','',1,0,'F','0','0','tool:gen:edit','#','admin','2026-04-25 10:31:31','',NULL,''),(1057,'生成删除',116,3,'#','','','',1,0,'F','0','0','tool:gen:remove','#','admin','2026-04-25 10:31:31','',NULL,''),(1058,'导入代码',116,4,'#','','','',1,0,'F','0','0','tool:gen:import','#','admin','2026-04-25 10:31:31','',NULL,''),(1059,'预览代码',116,5,'#','','','',1,0,'F','0','0','tool:gen:preview','#','admin','2026-04-25 10:31:31','',NULL,''),(1060,'生成代码',116,6,'#','','','',1,0,'F','0','0','tool:gen:code','#','admin','2026-04-25 10:31:31','',NULL,''),(2000,'旅游团管理',0,5,'travel',NULL,NULL,'',1,0,'M','0','0',NULL,'cascader','admin','2026-04-25 22:18:24','',NULL,''),(2001,'旅游团管理',2000,1,'tourGroup','business/tourGroup/index','','',1,0,'C','0','0','business:tourGroup:list','guide','admin','2026-04-25 22:22:19','',NULL,'旅游团管理菜单'),(2002,'旅游团查询',2001,1,'','','','',1,0,'F','0','0','business:tourGroup:query','#','admin','2026-04-25 22:22:19','',NULL,''),(2003,'旅游团新增',2001,2,'','','','',1,0,'F','0','0','business:tourGroup:add','#','admin','2026-04-25 22:22:19','',NULL,''),(2004,'旅游团修改',2001,3,'','','','',1,0,'F','0','0','business:tourGroup:edit','#','admin','2026-04-25 22:22:19','',NULL,''),(2005,'旅游团删除',2001,4,'','','','',1,0,'F','0','0','business:tourGroup:remove','#','admin','2026-04-25 22:22:19','',NULL,'');
/*!40000 ALTER TABLE `sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_notice`
--

DROP TABLE IF EXISTS `sys_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_notice` (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
  `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob COMMENT '公告内容',
  `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='通知公告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_notice`
--

LOCK TABLES `sys_notice` WRITE;
/*!40000 ALTER TABLE `sys_notice` DISABLE KEYS */;
INSERT INTO `sys_notice` VALUES (1,'温馨提醒：2018-07-01 若依新版本发布啦','2',_binary '新版本内容','0','admin','2026-04-25 10:31:33','',NULL,'管理员'),(2,'维护通知：2018-07-01 若依系统凌晨维护','1',_binary '维护内容','0','admin','2026-04-25 10:31:33','',NULL,'管理员');
/*!40000 ALTER TABLE `sys_notice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_oper_log`
--

DROP TABLE IF EXISTS `sys_oper_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_oper_log` (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) DEFAULT '' COMMENT '模块标题',
  `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
  `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
  `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`),
  KEY `idx_sys_oper_log_bt` (`business_type`),
  KEY `idx_sys_oper_log_s` (`status`),
  KEY `idx_sys_oper_log_ot` (`oper_time`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='操作日志记录';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_oper_log`
--

LOCK TABLES `sys_oper_log` WRITE;
/*!40000 ALTER TABLE `sys_oper_log` DISABLE KEYS */;
INSERT INTO `sys_oper_log` VALUES (100,'参数管理',2,'com.snow.web.controller.system.SysConfigController.edit()','PUT',1,'admin','研发部门','/system/config','127.0.0.1','内网IP','{\"configId\":5,\"configKey\":\"sys.account.registerUser\",\"configName\":\"账号自助-是否开启用户注册功能\",\"configType\":\"Y\",\"configValue\":\"true\\n\",\"createBy\":\"admin\",\"createTime\":\"2026-04-25 10:31:33\",\"params\":{},\"remark\":\"是否开启注册用户功能（true开启，false关闭）\",\"updateBy\":\"admin\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-25 11:28:22',58),(101,'菜单管理',1,'com.snow.web.controller.system.SysMenuController.add()','POST',1,'admin','研发部门','/system/menu','127.0.0.1','内网IP','{\"children\":[],\"createBy\":\"admin\",\"icon\":\"cascader\",\"isCache\":\"0\",\"isFrame\":\"1\",\"menuName\":\"旅游团管理\",\"menuType\":\"M\",\"orderNum\":5,\"params\":{},\"parentId\":0,\"path\":\"travel\",\"status\":\"0\",\"visible\":\"0\"}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-25 22:18:24',58),(102,'旅游团管理',2,'com.snow.web.controller.business.TourGroupManageController.edit()','PUT',1,'admin','研发部门','/business/tourGroup','127.0.0.1','内网IP','{\"detail\":{\"bookingNotes\":\"<p>预订须知：请携带有效证件；冬季注意保暖；如遇极端天气可能调整行程。</p>\",\"costExcludes\":\"<p>费用不含：个人消费、单房差、部分景区内小交通</p>\",\"costIncludes\":\"<p>费用包含：车辆、酒店、导游服务、部分门票（以出团通知为准）</p>\",\"createTime\":\"2026-04-25 21:01:16\",\"groupId\":1,\"highlights\":\"<p>亮点： - 经典冰雪线路，一次打卡多地 - 赠送滑雪体验（以当天雪场开放为准） - 夜游雪乡（天气/交通可能调整）</p>\",\"id\":1,\"imagesJson\":\"[{\\\"path\\\":\\\"https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":1},{\\\"path\\\":\\\"https://images.unsplash.com/photo-1542704792-e30dac463c90?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":2},{\\\"path\\\":\\\"/profile/upload/2026/04/25/pexels-andyhvu-3244513_20260425223556A001.jpg\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":3}]\",\"itineraryText\":\"<p><strong>行程概览</strong></p><p>D1 抵达后自由活动</p><p>D2 哈尔滨市区/冰雪主题景点</p><p>D3 雪乡全天</p><p>D4 亚布力滑雪</p><p>D5 返程</p>\",\"params\":{},\"status\":\"0\",\"updateTime\":\"2026-04-25 21:01:16\"},\"group\":{\"coverImage\":\"https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80\",\"createTime\":\"2026-04-25 21:01:16\",\"days\":5,\"departureCity\":\"哈尔滨\",\"destinationCity\":\"雪乡\",\"groupCode\":\"TG-TEST-001\",\"id\":1,\"minPrice\":2699,\"nights\":4,\"params\":{},\"sortOrder\":10,\"status\":\"0\",\"subTitle\":\"冰雪王国经典路线｜滑雪+雪乡夜景\",\"tags\":\"雪乡,滑雪,冰雪大世界\",\"title\":\"哈尔滨-雪乡-亚布力 5天4晚跟团游\",\"updateTime\":\"2026-04-25 21:01:16\"}}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-25 22:36:03',95),(103,'旅游团管理',2,'com.snow.web.controller.business.TourGroupManageController.edit()','PUT',1,'admin','研发部门','/business/tourGroup','127.0.0.1','内网IP','{\"detail\":{\"bookingNotes\":\"<p>预订须知：部分场馆需提前预约；请遵守当地参观规定。</p>\",\"costExcludes\":\"<p>费用不含：餐食、个人消费、部分门票</p>\",\"costIncludes\":\"<p>费用包含：用车、住宿、导游服务</p>\",\"createTime\":\"2026-04-25 21:01:16\",\"groupId\":3,\"highlights\":\"<p>亮点： - 历史人文讲解更深入 - 轻松行程，适合亲子/长辈 - 城市美食自由探索</p>\",\"id\":3,\"imagesJson\":\"[{\\\"path\\\":\\\"/profile/upload/2026/04/25/屏幕截图 2026-04-25 225616_20260425225638A003.png\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":1}]\",\"itineraryText\":\"<p><strong>行程概览</strong></p><p>D1 沈阳历史文化</p><p>D2 前往丹东+江景</p><p>D3 返程</p>\",\"params\":{},\"status\":\"0\",\"updateTime\":\"2026-04-25 21:01:16\"},\"group\":{\"coverImage\":\"https://images.unsplash.com/photo-1543349689-9a4d426bee8e?auto=format&fit=crop&w=1200&q=80\",\"createTime\":\"2026-04-25 21:01:16\",\"days\":3,\"departureCity\":\"沈阳\",\"destinationCity\":\"丹东\",\"groupCode\":\"TG-TEST-003\",\"id\":3,\"minPrice\":1599,\"nights\":2,\"params\":{},\"sortOrder\":30,\"status\":\"0\",\"subTitle\":\"故宫博物院｜鸭绿江断桥｜人文讲解\",\"tags\":\"历史,人文,小众\",\"title\":\"沈阳-丹东 3天2晚历史人文之旅\",\"updateTime\":\"2026-04-25 21:01:16\"}}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-25 22:56:43',53),(104,'旅游团管理',2,'com.snow.web.controller.business.TourGroupManageController.edit()','PUT',1,'admin','研发部门','/business/tourGroup','127.0.0.1','内网IP','{\"detail\":{\"bookingNotes\":\"<p>预订须知：部分场馆需提前预约；请遵守当地参观规定。</p>\",\"costExcludes\":\"<p>费用不含：餐食、个人消费、部分门票</p>\",\"costIncludes\":\"<p>费用包含：用车、住宿、导游服务</p>\",\"createTime\":\"2026-04-25 21:01:16\",\"groupId\":3,\"highlights\":\"<p>亮点： - 历史人文讲解更深入 - 轻松行程，适合亲子/长辈 - 城市美食自由探索</p>\",\"id\":3,\"imagesJson\":\"[{\\\"path\\\":\\\"/profile/upload/2026/04/25/屏幕截图 2026-04-25 225616_20260425225638A003.png\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":1}]\",\"itineraryText\":\"<p><strong>行程概览</strong></p><p>D1 沈阳历史文化</p><p>D2 前往丹东+江景</p><p>D3 返程</p>\",\"params\":{},\"status\":\"0\",\"updateTime\":\"2026-04-25 22:56:43\"},\"group\":{\"coverImage\":\"/profile/upload/2026/04/25/屏幕截图 2026-04-25 225616_20260425225711A004.png\",\"createTime\":\"2026-04-25 21:01:16\",\"days\":3,\"departureCity\":\"沈阳\",\"destinationCity\":\"丹东\",\"groupCode\":\"TG-TEST-003\",\"id\":3,\"minPrice\":1599,\"nights\":2,\"params\":{},\"sortOrder\":30,\"status\":\"0\",\"subTitle\":\"故宫博物院｜鸭绿江断桥｜人文讲解\",\"tags\":\"历史,人文,小众\",\"title\":\"沈阳-丹东 3天2晚历史人文之旅\",\"updateTime\":\"2026-04-25 22:56:43\"}}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-25 22:57:15',47),(105,'旅游团管理',2,'com.snow.web.controller.business.TourGroupManageController.edit()','PUT',1,'admin','研发部门','/business/tourGroup','127.0.0.1','内网IP','{\"detail\":{\"bookingNotes\":\"<p>预订须知：如需泡温泉请自备泳衣；高海拔/低温请注意身体状况。</p>\",\"costExcludes\":\"<p>费用不含：个人消费、餐食（若未包含）、部分二消项目</p>\",\"costIncludes\":\"<p>费用包含：用车、酒店、导游/司兼导、基础保险</p>\",\"createTime\":\"2026-04-25 21:01:16\",\"groupId\":2,\"highlights\":\"<p>亮点： - 小团慢游，节奏更舒适 - 温泉放松+雾凇观赏 - 酒店升级（以实际库存为准）</p>\",\"id\":2,\"imagesJson\":\"[{\\\"path\\\":\\\"https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":1},{\\\"path\\\":\\\"https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":2}]\",\"itineraryText\":\"<p><strong>行程概览</strong></p><p>D1 集合出发</p><p>D2 长白山景区</p><p>D3 温泉/雾凇</p><p>D4 返程</p>\",\"params\":{},\"status\":\"0\",\"updateTime\":\"2026-04-25 21:01:16\"},\"group\":{\"coverImage\":\"https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80\",\"createTime\":\"2026-04-25 21:01:16\",\"days\":4,\"departureCity\":\"长春\",\"destinationCity\":\"长白山\",\"groupCode\":\"TG-TEST-002\",\"id\":2,\"minPrice\":3299,\"nights\":3,\"params\":{},\"sortOrder\":20,\"status\":\"0\",\"subTitle\":\"温泉+雾凇｜酒店升级｜2-6人小团\",\"tags\":\"长白山,温泉,雾凇\",\"title\":\"长白山-雾凇岛 4天3晚轻奢小团\",\"updateTime\":\"2026-04-25 21:01:16\"}}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-26 14:34:18',101),(106,'旅游团管理',2,'com.snow.web.controller.business.TourGroupManageController.edit()','PUT',1,'admin','研发部门','/business/tourGroup','127.0.0.1','内网IP','{\"detail\":{\"bookingNotes\":\"<p>预订须知：极寒环境请做好保暖；部分体验受天气影响。</p>\",\"costExcludes\":\"<p>费用不含：个人消费、餐食、保暖装备租赁</p>\",\"costIncludes\":\"<p>费用包含：用车、住宿、导游服务</p>\",\"createTime\":\"2026-04-25 21:01:16\",\"groupId\":4,\"highlights\":\"<p>亮点： - 极寒体验与打卡 - 星空摄影氛围感 - 北极村地标合影</p>\",\"id\":4,\"imagesJson\":\"[{\\\"path\\\":\\\"https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":1},{\\\"path\\\":\\\"https://images.unsplash.com/photo-1459478309853-2c33a60058e7?auto=format&fit=crop&w=1200&q=80\\\",\\\"alt\\\":\\\"\\\",\\\"sort\\\":2}]\",\"itineraryText\":\"<p><strong>行程概览</strong></p><p>D1 抵达漠河</p><p>D2 北极村深度</p><p>D3 返程</p>\",\"params\":{},\"status\":\"0\",\"updateTime\":\"2026-04-25 21:01:16\"},\"group\":{\"coverImage\":\"https://images.unsplash.com/photo-1459478309853-2c33a60058e7?auto=format&fit=crop&w=1200&q=80\",\"createTime\":\"2026-04-25 21:01:16\",\"days\":3,\"departureCity\":\"哈尔滨\",\"destinationCity\":\"漠河\",\"groupCode\":\"TG-TEST-004\",\"id\":4,\"minPrice\":2199,\"nights\":2,\"params\":{},\"sortOrder\":40,\"status\":\"0\",\"subTitle\":\"北纬53°｜极寒体验｜星空摄影\",\"tags\":\"漠河,北极村,摄影\",\"title\":\"漠河-北极村 3天2晚极光追光团\",\"updateTime\":\"2026-04-25 21:01:16\"}}','{\"msg\":\"操作成功\",\"code\":200}',0,NULL,'2026-04-26 14:35:06',42);
/*!40000 ALTER TABLE `sys_oper_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_post`
--

DROP TABLE IF EXISTS `sys_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_post` (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='岗位信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_post`
--

LOCK TABLES `sys_post` WRITE;
/*!40000 ALTER TABLE `sys_post` DISABLE KEYS */;
INSERT INTO `sys_post` VALUES (1,'ceo','董事长',1,'0','admin','2026-04-25 10:31:31','',NULL,''),(2,'se','项目经理',2,'0','admin','2026-04-25 10:31:31','',NULL,''),(3,'hr','人力资源',3,'0','admin','2026-04-25 10:31:31','',NULL,''),(4,'user','普通员工',4,'0','admin','2026-04-25 10:31:31','',NULL,'');
/*!40000 ALTER TABLE `sys_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
  `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'超级管理员','admin',1,'1',1,1,'0','0','admin','2026-04-25 10:31:31','',NULL,'超级管理员'),(2,'普通角色','common',2,'2',1,1,'0','0','admin','2026-04-25 10:31:31','',NULL,'普通角色');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_dept`
--

DROP TABLE IF EXISTS `sys_role_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_dept` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`,`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和部门关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_dept`
--

LOCK TABLES `sys_role_dept` WRITE;
/*!40000 ALTER TABLE `sys_role_dept` DISABLE KEYS */;
INSERT INTO `sys_role_dept` VALUES (2,100),(2,101),(2,105);
/*!40000 ALTER TABLE `sys_role_dept` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_menu`
--

DROP TABLE IF EXISTS `sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_menu` (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='角色和菜单关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_menu`
--

LOCK TABLES `sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sys_role_menu` DISABLE KEYS */;
INSERT INTO `sys_role_menu` VALUES (1,2001),(1,2002),(1,2003),(1,2004),(1,2005),(2,1),(2,2),(2,3),(2,4),(2,100),(2,101),(2,102),(2,103),(2,104),(2,105),(2,106),(2,107),(2,108),(2,109),(2,110),(2,111),(2,112),(2,113),(2,114),(2,115),(2,116),(2,117),(2,500),(2,501),(2,1000),(2,1001),(2,1002),(2,1003),(2,1004),(2,1005),(2,1006),(2,1007),(2,1008),(2,1009),(2,1010),(2,1011),(2,1012),(2,1013),(2,1014),(2,1015),(2,1016),(2,1017),(2,1018),(2,1019),(2,1020),(2,1021),(2,1022),(2,1023),(2,1024),(2,1025),(2,1026),(2,1027),(2,1028),(2,1029),(2,1030),(2,1031),(2,1032),(2,1033),(2,1034),(2,1035),(2,1036),(2,1037),(2,1038),(2,1039),(2,1040),(2,1041),(2,1042),(2,1043),(2,1044),(2,1045),(2,1046),(2,1047),(2,1048),(2,1049),(2,1050),(2,1051),(2,1052),(2,1053),(2,1054),(2,1055),(2,1056),(2,1057),(2,1058),(2,1059),(2,1060);
/*!40000 ALTER TABLE `sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
  `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) DEFAULT '' COMMENT '密码',
  `status` char(1) DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,103,'admin','若依','00','ry@163.com','15888888888','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-04-26 16:17:31','admin','2026-04-25 10:31:31','','2026-04-26 16:17:31','管理员'),(2,105,'ry','若依','00','ry@qq.com','15666666666','1','','$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2','0','0','127.0.0.1','2026-04-25 10:31:31','admin','2026-04-25 10:31:31','',NULL,'测试员'),(100,NULL,'23033112','23033112','00','','','0','','$2a$10$d9zlSVUYOBfBRvj30uob/.mVoYx4ggJhQ/bLH/JqPMcuiS4py0Ynu','0','0','127.0.0.1','2026-04-26 15:32:41','','2026-04-25 11:36:07','','2026-04-26 15:32:40',NULL),(101,NULL,'23033101','23033101','00','','','0','','$2a$10$ARN.V0tCcxJfZAyGZaiCsOk0U3qOKodsSxvOLQfHMBV/5.Eg12VgC','0','0','',NULL,'','2026-04-25 20:13:12','',NULL,NULL);
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_post`
--

DROP TABLE IF EXISTS `sys_user_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_post` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`,`post_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户与岗位关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_post`
--

LOCK TABLES `sys_user_post` WRITE;
/*!40000 ALTER TABLE `sys_user_post` DISABLE KEYS */;
INSERT INTO `sys_user_post` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`,`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户和角色关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1),(2,2);
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour_group_details`
--

DROP TABLE IF EXISTS `tour_group_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour_group_details` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_id` bigint NOT NULL COMMENT '旅游团ID',
  `highlights` text COMMENT '亮点（可纯文本/markdown）',
  `itinerary_text` longtext COMMENT '行程介绍（富文本）',
  `cost_includes` longtext COMMENT '费用包含（富文本）',
  `cost_excludes` longtext COMMENT '费用不含（富文本）',
  `booking_notes` longtext COMMENT '预订须知/退改政策（富文本）',
  `images_json` json DEFAULT NULL COMMENT '图片集JSON（多张图片路径/元数据）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tour_group_details_group_id` (`group_id`),
  CONSTRAINT `fk_tour_group_details_group` FOREIGN KEY (`group_id`) REFERENCES `tour_groups` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游团详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour_group_details`
--

LOCK TABLES `tour_group_details` WRITE;
/*!40000 ALTER TABLE `tour_group_details` DISABLE KEYS */;
INSERT INTO `tour_group_details` VALUES (1,1,'<p>亮点： - 经典冰雪线路，一次打卡多地 - 赠送滑雪体验（以当天雪场开放为准） - 夜游雪乡（天气/交通可能调整）</p>','<p><strong>行程概览</strong></p><p>D1 抵达后自由活动</p><p>D2 哈尔滨市区/冰雪主题景点</p><p>D3 雪乡全天</p><p>D4 亚布力滑雪</p><p>D5 返程</p>','<p>费用包含：车辆、酒店、导游服务、部分门票（以出团通知为准）</p>','<p>费用不含：个人消费、单房差、部分景区内小交通</p>','<p>预订须知：请携带有效证件；冬季注意保暖；如遇极端天气可能调整行程。</p>','[{\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1}, {\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1542704792-e30dac463c90?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2}, {\"alt\": \"\", \"path\": \"/profile/upload/2026/04/25/pexels-andyhvu-3244513_20260425223556A001.jpg\", \"sort\": 3}]','0','2026-04-25 21:01:16','2026-04-25 22:36:02'),(2,2,'<p>亮点： - 小团慢游，节奏更舒适 - 温泉放松+雾凇观赏 - 酒店升级（以实际库存为准）</p>','<p><strong>行程概览</strong></p><p>D1 集合出发</p><p>D2 长白山景区</p><p>D3 温泉/雾凇</p><p>D4 返程</p>','<p>费用包含：用车、酒店、导游/司兼导、基础保险</p>','<p>费用不含：个人消费、餐食（若未包含）、部分二消项目</p>','<p>预订须知：如需泡温泉请自备泳衣；高海拔/低温请注意身体状况。</p>','[{\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1}, {\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2}]','0','2026-04-25 21:01:16','2026-04-26 14:34:18'),(3,3,'<p>亮点： - 历史人文讲解更深入 - 轻松行程，适合亲子/长辈 - 城市美食自由探索</p>','<p><strong>行程概览</strong></p><p>D1 沈阳历史文化</p><p>D2 前往丹东+江景</p><p>D3 返程</p>','<p>费用包含：用车、住宿、导游服务</p>','<p>费用不含：餐食、个人消费、部分门票</p>','<p>预订须知：部分场馆需提前预约；请遵守当地参观规定。</p>','[{\"alt\": \"\", \"path\": \"/profile/upload/2026/04/25/屏幕截图 2026-04-25 225616_20260425225638A003.png\", \"sort\": 1}]','0','2026-04-25 21:01:16','2026-04-25 22:57:15'),(4,4,'<p>亮点： - 极寒体验与打卡 - 星空摄影氛围感 - 北极村地标合影</p>','<p><strong>行程概览</strong></p><p>D1 抵达漠河</p><p>D2 北极村深度</p><p>D3 返程</p>','<p>费用包含：用车、住宿、导游服务</p>','<p>费用不含：个人消费、餐食、保暖装备租赁</p>','<p>预订须知：极寒环境请做好保暖；部分体验受天气影响。</p>','[{\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80\", \"sort\": 1}, {\"alt\": \"\", \"path\": \"https://images.unsplash.com/photo-1459478309853-2c33a60058e7?auto=format&fit=crop&w=1200&q=80\", \"sort\": 2}]','0','2026-04-25 21:01:16','2026-04-26 14:35:06');
/*!40000 ALTER TABLE `tour_group_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tour_groups`
--

DROP TABLE IF EXISTS `tour_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tour_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `group_code` varchar(64) DEFAULT NULL COMMENT '团编号（可对外展示/对接）',
  `title` varchar(128) NOT NULL COMMENT '旅游团标题/名称',
  `sub_title` varchar(255) DEFAULT NULL COMMENT '副标题/一句话卖点',
  `departure_city` varchar(64) DEFAULT NULL COMMENT '出发地（城市名）',
  `destination_city` varchar(64) DEFAULT NULL COMMENT '目的地（城市名）',
  `days` int DEFAULT '0' COMMENT '行程天数',
  `nights` int DEFAULT '0' COMMENT '行程夜数',
  `min_price` decimal(10,2) DEFAULT '0.00' COMMENT '起价（用于列表展示）',
  `cover_image` varchar(255) DEFAULT NULL COMMENT '封面图路径/URL（单张）',
  `tags` varchar(255) DEFAULT NULL COMMENT '标签（逗号分隔）',
  `sort_order` int DEFAULT '0' COMMENT '排序值（越小越靠前）',
  `status` char(1) DEFAULT '0' COMMENT '状态（0上架 1下架）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tour_group_code` (`group_code`),
  KEY `idx_tour_group_status_sort` (`status`,`sort_order`,`update_time`),
  KEY `idx_tour_group_title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游团主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tour_groups`
--

LOCK TABLES `tour_groups` WRITE;
/*!40000 ALTER TABLE `tour_groups` DISABLE KEYS */;
INSERT INTO `tour_groups` VALUES (1,'TG-TEST-001','哈尔滨-雪乡-亚布力 5天4晚跟团游','冰雪王国经典路线｜滑雪+雪乡夜景','哈尔滨','雪乡',5,4,2699.00,'https://images.unsplash.com/photo-1548013146-72479768bada?auto=format&fit=crop&w=1200&q=80','雪乡,滑雪,冰雪大世界',10,'0','2026-04-25 21:01:16','2026-04-25 22:36:02'),(2,'TG-TEST-002','长白山-雾凇岛 4天3晚轻奢小团','温泉+雾凇｜酒店升级｜2-6人小团','长春','长白山',4,3,3299.00,'https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80','长白山,温泉,雾凇',20,'0','2026-04-25 21:01:16','2026-04-26 14:34:18'),(3,'TG-TEST-003','沈阳-丹东 3天2晚历史人文之旅','故宫博物院｜鸭绿江断桥｜人文讲解','沈阳','丹东',3,2,1599.00,'/profile/upload/2026/04/25/屏幕截图 2026-04-25 225616_20260425225711A004.png','历史,人文,小众',30,'0','2026-04-25 21:01:16','2026-04-25 22:57:15'),(4,'TG-TEST-004','漠河-北极村 3天2晚极光追光团','北纬53°｜极寒体验｜星空摄影','哈尔滨','漠河',3,2,2199.00,'https://images.unsplash.com/photo-1459478309853-2c33a60058e7?auto=format&fit=crop&w=1200&q=80','漠河,北极村,摄影',40,'0','2026-04-25 21:01:16','2026-04-26 14:35:06');
/*!40000 ALTER TABLE `tour_groups` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-26 17:29:20
