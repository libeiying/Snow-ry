-- Northeast travel schema v2
-- Generated from doc/database-redesign-from-frontend.md

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Drop child tables first
DROP TABLE IF EXISTS payment_records;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS chat_messages;
DROP TABLE IF EXISTS chat_conversations;
DROP TABLE IF EXISTS heritage_items;
DROP TABLE IF EXISTS heritage_articles;
DROP TABLE IF EXISTS travel_guide_tags;
DROP TABLE IF EXISTS travel_guide_images;
DROP TABLE IF EXISTS travel_guides;
DROP TABLE IF EXISTS travel_plan_highlights;
DROP TABLE IF EXISTS travel_plans;
DROP TABLE IF EXISTS destinations;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS users;

-- 1) users and sessions
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  phone VARCHAR(20) NOT NULL UNIQUE COMMENT '手机号（登录账号）',
  username VARCHAR(64) NOT NULL COMMENT '用户名',
  password_hash VARCHAR(255) NOT NULL COMMENT '密码哈希',
  nickname VARCHAR(64) NULL COMMENT '昵称',
  real_name VARCHAR(64) NULL COMMENT '真实姓名',
  avatar_url VARCHAR(255) NULL COMMENT '头像URL',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户主表';

CREATE TABLE user_sessions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  user_id BIGINT NOT NULL COMMENT '用户ID',
  token VARCHAR(512) NOT NULL COMMENT '登录令牌/JWT',
  expires_at DATETIME NOT NULL COMMENT '令牌过期时间',
  client_ip VARCHAR(45) NULL COMMENT '客户端IP',
  user_agent VARCHAR(255) NULL COMMENT '客户端UA',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_user_id (user_id),
  INDEX idx_token (token(128)),
  CONSTRAINT fk_user_sessions_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户会话表';

-- 2) destination and plan
CREATE TABLE destinations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  city_name VARCHAR(64) NOT NULL COMMENT '城市名',
  province_name VARCHAR(64) NULL COMMENT '省份名',
  region_level TINYINT NOT NULL DEFAULT 2 COMMENT '层级：1省，2市',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  UNIQUE KEY uk_city_province (city_name, province_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='目的地字典表';

CREATE TABLE travel_plans (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  title VARCHAR(128) NOT NULL COMMENT '行程标题',
  summary VARCHAR(1000) NULL COMMENT '行程摘要',
  origin_destination_id BIGINT NOT NULL COMMENT '出发地ID',
  target_destination_id BIGINT NOT NULL COMMENT '目的地ID',
  start_time DATETIME NOT NULL COMMENT '开始时间',
  end_time DATETIME NOT NULL COMMENT '结束时间',
  estimated_cost_per_person DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '人均预估费用',
  cover_image_url VARCHAR(255) NULL COMMENT '封面图URL',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1上架，0下架',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_plan_search (origin_destination_id, target_destination_id, start_time, end_time),
  CONSTRAINT fk_plan_origin FOREIGN KEY (origin_destination_id) REFERENCES destinations(id),
  CONSTRAINT fk_plan_target FOREIGN KEY (target_destination_id) REFERENCES destinations(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅行计划主表';

CREATE TABLE travel_plan_highlights (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  plan_id BIGINT NOT NULL COMMENT '行程ID',
  highlight_text VARCHAR(128) NOT NULL COMMENT '行程亮点',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_plan_id (plan_id),
  CONSTRAINT fk_plan_highlight_plan FOREIGN KEY (plan_id) REFERENCES travel_plans(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅行计划亮点表';

-- 3) travel guides (subjects)
CREATE TABLE travel_guides (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  title VARCHAR(128) NOT NULL COMMENT '攻略标题',
  short_desc VARCHAR(500) NULL COMMENT '简述',
  detail_text TEXT NULL COMMENT '详情正文',
  location_city VARCHAR(64) NULL COMMENT '关联城市',
  cover_image_url VARCHAR(255) NULL COMMENT '封面图URL',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1上架，0下架',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游攻略主表';

CREATE TABLE travel_guide_images (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  guide_id BIGINT NOT NULL COMMENT '攻略ID',
  image_url VARCHAR(255) NOT NULL COMMENT '图片URL',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_guide_id (guide_id),
  CONSTRAINT fk_guide_image_guide FOREIGN KEY (guide_id) REFERENCES travel_guides(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游攻略图片表';

CREATE TABLE travel_guide_tags (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  guide_id BIGINT NOT NULL COMMENT '攻略ID',
  tag_name VARCHAR(64) NOT NULL COMMENT '标签名',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_guide_tag (guide_id, tag_name),
  CONSTRAINT fk_guide_tag_guide FOREIGN KEY (guide_id) REFERENCES travel_guides(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='旅游攻略标签表';

-- 4) heritage articles
CREATE TABLE heritage_articles (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  title VARCHAR(200) NOT NULL COMMENT '文章标题',
  content TEXT NOT NULL COMMENT '文章正文',
  author_name VARCHAR(64) NULL COMMENT '作者名',
  publish_date DATE NULL COMMENT '发布日期',
  cover_image_url VARCHAR(255) NULL COMMENT '封面图URL',
  status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1发布，0下线',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_publish_date (publish_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='非遗文章主表';

CREATE TABLE heritage_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  article_id BIGINT NOT NULL COMMENT '文章ID',
  item_name VARCHAR(128) NOT NULL COMMENT '非遗项目名',
  item_desc VARCHAR(1000) NULL COMMENT '非遗项目描述',
  image_url VARCHAR(255) NULL COMMENT '图片URL',
  sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_article_id (article_id),
  CONSTRAINT fk_heritage_item_article FOREIGN KEY (article_id) REFERENCES heritage_articles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='非遗文章项目明细表';

-- 5) chat
CREATE TABLE chat_conversations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  user_id BIGINT NULL COMMENT '用户ID（游客可空）',
  title VARCHAR(128) NULL COMMENT '会话标题',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_chat_user (user_id),
  CONSTRAINT fk_chat_conv_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI聊天会话表';

CREATE TABLE chat_messages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  conversation_id BIGINT NOT NULL COMMENT '会话ID',
  role_type TINYINT NOT NULL COMMENT '角色：1用户，2助手',
  content TEXT NOT NULL COMMENT '消息内容',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_conv_time (conversation_id, created_at),
  CONSTRAINT fk_chat_msg_conv FOREIGN KEY (conversation_id) REFERENCES chat_conversations(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI聊天消息表';

-- 6) order and payment
CREATE TABLE orders (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  order_no VARCHAR(64) NOT NULL UNIQUE COMMENT '订单号',
  user_id BIGINT NOT NULL COMMENT '下单用户ID',
  total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
  order_status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1待支付，2已支付，3已取消，4已完成',
  contact_name VARCHAR(64) NULL COMMENT '联系人姓名',
  contact_phone VARCHAR(20) NULL COMMENT '联系人手机号',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_order_user (user_id),
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单主表';

CREATE TABLE order_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  order_id BIGINT NOT NULL COMMENT '订单ID',
  biz_type TINYINT NOT NULL COMMENT '业务类型：1行程，2跟团，3商品',
  biz_id BIGINT NOT NULL COMMENT '业务对象ID',
  item_name VARCHAR(128) NOT NULL COMMENT '条目名称快照',
  unit_price DECIMAL(10,2) NOT NULL COMMENT '单价快照',
  quantity INT NOT NULL DEFAULT 1 COMMENT '购买数量',
  travel_date DATE NULL COMMENT '出行日期',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_order_item_order (order_id),
  CONSTRAINT fk_order_item_order FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单条目明细表';

CREATE TABLE payment_records (
  id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
  order_id BIGINT NOT NULL COMMENT '订单ID',
  payment_channel VARCHAR(32) NOT NULL DEFAULT 'mock' COMMENT '支付渠道编码',
  payment_status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1待支付，2成功，3失败',
  transaction_no VARCHAR(64) NULL COMMENT '三方交易号',
  paid_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '实付金额',
  paid_at DATETIME NULL COMMENT '支付完成时间',
  callback_payload TEXT NULL COMMENT '回调原始报文',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0否，1是',
  INDEX idx_pay_order (order_id),
  INDEX idx_txn_no (transaction_no),
  CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='支付流水表';

SET FOREIGN_KEY_CHECKS = 1;
