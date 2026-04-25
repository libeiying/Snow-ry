-- ----------------------------
-- Northeast travel business schema
-- Notes:
-- - Reuse Ruoyi `sys_user` as App user table (user_id as FK target)
-- - No logical delete
-- - No create_by/update_by fields
-- - create_time/update_time auto-managed by MySQL
-- ----------------------------
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Drop child tables first (business only)
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

-- 1) destinations and travel plans
CREATE TABLE destinations (
  id                bigint(20)      not null auto_increment comment '主键ID',
  city_name         varchar(64)     not null                comment '城市名',
  province_name     varchar(64)     default null            comment '省份名',
  region_level      tinyint(1)      default 2               comment '层级：1省，2市',
  sort_order        int(11)         default 0               comment '排序值',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  unique key uk_city_province (city_name, province_name)
) engine=innodb comment = '目的地字典表';

CREATE TABLE travel_plans (
  id                        bigint(20)      not null auto_increment comment '主键ID',
  title                     varchar(128)    not null                comment '行程标题',
  summary                   varchar(1000)   default null            comment '行程摘要',
  origin_destination_id     bigint(20)      not null                comment '出发地ID',
  target_destination_id     bigint(20)      not null                comment '目的地ID',
  start_time                datetime        not null                comment '开始时间',
  end_time                  datetime        not null                comment '结束时间',
  estimated_cost_per_person decimal(10,2)   default 0.00            comment '人均预估费用',
  cover_image_url           varchar(255)    default null            comment '封面图URL',
  status                    char(1)         default '0'             comment '状态（0上架 1下架）',
  create_time               datetime        not null default current_timestamp comment '创建时间',
  update_time               datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_plan_search (origin_destination_id, target_destination_id, start_time, end_time),
  constraint fk_plan_origin foreign key (origin_destination_id) references destinations(id),
  constraint fk_plan_target foreign key (target_destination_id) references destinations(id)
) engine=innodb comment = '旅行计划主表';

CREATE TABLE travel_plan_highlights (
  id                bigint(20)      not null auto_increment comment '主键ID',
  plan_id           bigint(20)      not null                comment '行程ID',
  highlight_text    varchar(128)    not null                comment '行程亮点',
  sort_order        int(11)         default 0               comment '排序值',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_plan_id (plan_id),
  constraint fk_plan_highlight_plan foreign key (plan_id) references travel_plans(id)
) engine=innodb comment = '旅行计划亮点表';

-- 2) travel guides (subjects)
CREATE TABLE travel_guides (
  id                bigint(20)      not null auto_increment comment '主键ID',
  title             varchar(128)    not null                comment '攻略标题',
  short_desc        varchar(500)    default null            comment '简述',
  detail_text       text                                    comment '详情正文',
  location_city     varchar(64)     default null            comment '关联城市',
  cover_image_url   varchar(255)    default null            comment '封面图URL',
  status            char(1)         default '0'             comment '状态（0上架 1下架）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id)
) engine=innodb comment = '旅游攻略主表';

CREATE TABLE travel_guide_images (
  id                bigint(20)      not null auto_increment comment '主键ID',
  guide_id          bigint(20)      not null                comment '攻略ID',
  image_url         varchar(255)    not null                comment '图片URL',
  sort_order        int(11)         default 0               comment '排序值',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_guide_id (guide_id),
  constraint fk_guide_image_guide foreign key (guide_id) references travel_guides(id)
) engine=innodb comment = '旅游攻略图片表';

CREATE TABLE travel_guide_tags (
  id                bigint(20)      not null auto_increment comment '主键ID',
  guide_id          bigint(20)      not null                comment '攻略ID',
  tag_name          varchar(64)     not null                comment '标签名',
  sort_order        int(11)         default 0               comment '排序值',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_guide_tag (guide_id, tag_name),
  constraint fk_guide_tag_guide foreign key (guide_id) references travel_guides(id)
) engine=innodb comment = '旅游攻略标签表';

-- 3) heritage articles
CREATE TABLE heritage_articles (
  id                bigint(20)      not null auto_increment comment '主键ID',
  title             varchar(200)    not null                comment '文章标题',
  content           text            not null                comment '文章正文',
  author_name       varchar(64)     default null            comment '作者名',
  publish_date      date                                    comment '发布日期',
  cover_image_url   varchar(255)    default null            comment '封面图URL',
  status            char(1)         default '0'             comment '状态（0发布 1下线）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_publish_date (publish_date)
) engine=innodb comment = '非遗文章主表';

CREATE TABLE heritage_items (
  id                bigint(20)      not null auto_increment comment '主键ID',
  article_id        bigint(20)      not null                comment '文章ID',
  item_name         varchar(128)    not null                comment '非遗项目名',
  item_desc         varchar(1000)   default null            comment '非遗项目描述',
  image_url         varchar(255)    default null            comment '图片URL',
  sort_order        int(11)         default 0               comment '排序值',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_article_id (article_id),
  constraint fk_heritage_item_article foreign key (article_id) references heritage_articles(id)
) engine=innodb comment = '非遗文章项目明细表';

-- 4) AI chat (optional persistence)
CREATE TABLE chat_conversations (
  id                bigint(20)      not null auto_increment comment '主键ID',
  user_id           bigint(20)      default null            comment '用户ID（游客可空）',
  title             varchar(128)    default null            comment '会话标题',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_chat_user (user_id),
  constraint fk_chat_conv_user foreign key (user_id) references sys_user(user_id)
) engine=innodb comment = 'AI聊天会话表';

CREATE TABLE chat_messages (
  id                bigint(20)      not null auto_increment comment '主键ID',
  conversation_id   bigint(20)      not null                comment '会话ID',
  role_type         tinyint(1)      not null                comment '角色：1用户，2助手',
  content           text            not null                comment '消息内容',
  status            char(1)         default '0'             comment '状态（0正常 1停用）',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_conv_time (conversation_id, create_time),
  constraint fk_chat_msg_conv foreign key (conversation_id) references chat_conversations(id)
) engine=innodb comment = 'AI聊天消息表';

-- 5) orders and payments
CREATE TABLE orders (
  id                bigint(20)      not null auto_increment comment '主键ID',
  order_no          varchar(64)     not null                comment '订单号',
  user_id           bigint(20)      not null                comment '下单用户ID',
  total_amount      decimal(10,2)   not null                comment '订单总金额',
  order_status      tinyint(1)      default 1               comment '状态：1待支付，2已支付，3已取消，4已完成',
  contact_name      varchar(64)     default null            comment '联系人姓名',
  contact_phone     varchar(20)     default null            comment '联系人手机号',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  unique key uk_order_no (order_no),
  key idx_order_user (user_id),
  constraint fk_order_user foreign key (user_id) references sys_user(user_id)
) engine=innodb comment = '订单主表';

CREATE TABLE order_items (
  id                bigint(20)      not null auto_increment comment '主键ID',
  order_id          bigint(20)      not null                comment '订单ID',
  biz_type          tinyint(1)      not null                comment '业务类型：1行程，2跟团，3商品',
  biz_id            bigint(20)      not null                comment '业务对象ID',
  item_name         varchar(128)    not null                comment '条目名称快照',
  unit_price        decimal(10,2)   not null                comment '单价快照',
  quantity          int(11)         default 1               comment '购买数量',
  travel_date       date                                    comment '出行日期',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_order_item_order (order_id),
  constraint fk_order_item_order foreign key (order_id) references orders(id)
) engine=innodb comment = '订单条目明细表';

CREATE TABLE payment_records (
  id                bigint(20)      not null auto_increment comment '主键ID',
  order_id          bigint(20)      not null                comment '订单ID',
  payment_channel   varchar(32)     default 'mock'          comment '支付渠道编码',
  payment_status    tinyint(1)      default 1               comment '状态：1待支付，2成功，3失败',
  transaction_no    varchar(64)     default null            comment '三方交易号',
  paid_amount       decimal(10,2)   default 0.00            comment '实付金额',
  paid_at           datetime                                comment '支付完成时间',
  callback_payload  text                                    comment '回调原始报文',
  create_time       datetime        not null default current_timestamp comment '创建时间',
  update_time       datetime        not null default current_timestamp on update current_timestamp comment '更新时间',
  primary key (id),
  key idx_pay_order (order_id),
  key idx_txn_no (transaction_no),
  constraint fk_payment_order foreign key (order_id) references orders(id)
) engine=innodb comment = '支付流水表';

SET FOREIGN_KEY_CHECKS = 1;
