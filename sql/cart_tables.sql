
DROP TABLE IF EXISTS `order_item`;
DROP TABLE IF EXISTS `orders`;

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
  KEY `idx_orders_user_status_ctime` (`user_id`, `order_status`, `create_time`),
  KEY `idx_orders_create_time` (`create_time`),

  CONSTRAINT `chk_orders_status` CHECK (`order_status` in ('0','1','2','3','4')),
  CONSTRAINT `chk_orders_pay_status` CHECK (`pay_status` in ('0','1')),
  CONSTRAINT `chk_orders_total_amount` CHECK (`total_amount` >= 0),
  CONSTRAINT `chk_orders_pay_amount` CHECK (`pay_amount` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单主表';

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
  KEY `idx_item_user_ctime` (`user_id`, `create_time`),

  CONSTRAINT `fk_item_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `chk_item_quantity` CHECK (`quantity` >= 1),
  CONSTRAINT `chk_item_unit_price` CHECK (`unit_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单明细表';

-- =========================================================
-- 订单典型语句（最小闭环）
-- =========================================================

-- 1) 创建订单主表记录（在事务中）
-- INSERT INTO orders
--   (order_no, user_id, order_status, pay_status, total_amount, pay_amount, receiver_name, receiver_phone, receiver_address, remark)
-- VALUES
--   (?, ?, '0', '0', ?, ?, ?, ?, ?, ?);

-- 2) 批量写入订单明细（来源：购物车已选）
-- INSERT INTO order_item
--   (order_id, order_no, user_id, product_id, product_code, product_title, product_image, sku_text, unit_price, quantity)
-- SELECT
--   ?, ?, user_id, product_id, product_code, product_title, product_image, sku_text, unit_price, quantity
-- FROM shopping_cart
-- WHERE user_id = ? AND status = '0' AND is_checked = '1';

-- 3) 支付成功更新
-- UPDATE orders
-- SET order_status = '1',
--     pay_status = '1',
--     pay_time = CURRENT_TIMESTAMP,
--     update_time = CURRENT_TIMESTAMP
-- WHERE order_no = ? AND user_id = ? AND pay_status = '0';

-- 4) 取消订单
-- UPDATE orders
-- SET order_status = '2',
--     cancel_time = CURRENT_TIMESTAMP,
--     update_time = CURRENT_TIMESTAMP
-- WHERE order_no = ? AND user_id = ? AND order_status = '0';

-- 5) 用户订单列表
-- SELECT id, order_no, order_status, pay_status, total_amount, pay_amount, create_time
-- FROM orders
-- WHERE user_id = ?
-- ORDER BY create_time DESC, id DESC;

-- =========================================================
-- 字典初始化（订单模块）
-- 说明：
-- 1) 可重复执行，不会插入重复字典项
-- 2) 与 orders.order_status / orders.pay_status 对齐
-- =========================================================

-- 1) 字典类型：订单状态
INSERT INTO sys_dict_type
  (dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
SELECT
  '订单状态', 'biz_order_status', '0', 'admin', NOW(), '', NULL, 'orders.order_status 字典'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_type WHERE dict_type = 'biz_order_status'
);

-- 2) 字典类型：支付状态
INSERT INTO sys_dict_type
  (dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
SELECT
  '支付状态', 'biz_pay_status', '0', 'admin', NOW(), '', NULL, 'orders.pay_status 字典'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_type WHERE dict_type = 'biz_pay_status'
);

-- 3) 字典数据：订单状态（0待支付 1已支付 2已取消 3已发货 4已完成）
INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 1, '待支付', '0', 'biz_order_status', '', 'warning', 'Y', '0', 'admin', NOW(), '', NULL, 'orders.order_status=0'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_order_status' AND dict_value = '0'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 2, '已支付', '1', 'biz_order_status', '', 'primary', 'N', '0', 'admin', NOW(), '', NULL, 'orders.order_status=1'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_order_status' AND dict_value = '1'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 3, '已取消', '2', 'biz_order_status', '', 'danger', 'N', '0', 'admin', NOW(), '', NULL, 'orders.order_status=2'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_order_status' AND dict_value = '2'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 4, '已发货', '3', 'biz_order_status', '', 'info', 'N', '0', 'admin', NOW(), '', NULL, 'orders.order_status=3'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_order_status' AND dict_value = '3'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 5, '已完成', '4', 'biz_order_status', '', 'success', 'N', '0', 'admin', NOW(), '', NULL, 'orders.order_status=4'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_order_status' AND dict_value = '4'
);

-- 4) 字典数据：支付状态（0未支付 1已支付）
INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 1, '未支付', '0', 'biz_pay_status', '', 'warning', 'Y', '0', 'admin', NOW(), '', NULL, 'orders.pay_status=0'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_pay_status' AND dict_value = '0'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 2, '已支付', '1', 'biz_pay_status', '', 'success', 'N', '0', 'admin', NOW(), '', NULL, 'orders.pay_status=1'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_pay_status' AND dict_value = '1'
);

-- =========================================================
-- 支付流水表（用于支付页展示与回调审计）
-- =========================================================
DROP TABLE IF EXISTS `order_payment`;

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
  KEY `idx_payment_user_ctime` (`user_id`, `create_time`),
  KEY `idx_payment_txn_no` (`transaction_no`),
  CONSTRAINT `chk_payment_status` CHECK (`pay_status` in ('0','1','2')),
  CONSTRAINT `chk_payment_amount` CHECK (`amount` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单支付流水表';

-- 字典类型：支付渠道
INSERT INTO sys_dict_type
  (dict_name, dict_type, status, create_by, create_time, update_by, update_time, remark)
SELECT
  '支付渠道', 'biz_pay_channel', '0', 'admin', NOW(), '', NULL, 'order_payment.pay_channel 字典'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_type WHERE dict_type = 'biz_pay_channel'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 1, '微信支付', 'WECHAT', 'biz_pay_channel', '', 'success', 'Y', '0', 'admin', NOW(), '', NULL, '微信支付渠道'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_pay_channel' AND dict_value = 'WECHAT'
);

INSERT INTO sys_dict_data
  (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, update_by, update_time, remark)
SELECT 2, '支付宝', 'ALIPAY', 'biz_pay_channel', '', 'primary', 'N', '0', 'admin', NOW(), '', NULL, '支付宝支付渠道'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_pay_channel' AND dict_value = 'ALIPAY'
);

-- =========================================================
-- 定时任务初始化（15分钟未支付自动取消）
-- 执行后可在系统任务管理里看到并修改 cron
-- =========================================================
INSERT INTO sys_job
  (job_name, job_group, invoke_target, cron_expression, misfire_policy, concurrent, status, create_by, create_time, remark)
SELECT
  '订单超时自动取消',
  'DEFAULT',
  'orderTask.cancelTimeoutOrders()',
  '0 */1 * * * ?',
  '3',
  '1',
  '0',
  'admin',
  NOW(),
  '每分钟执行一次，自动取消超过15分钟未支付订单'
WHERE NOT EXISTS (
  SELECT 1 FROM sys_job WHERE invoke_target = 'orderTask.cancelTimeoutOrders()'
);
