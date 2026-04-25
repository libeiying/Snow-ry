# 用户端前端区域与数据库表映射（重构版）

## 1. 文档目标

这份文档只回答一个问题：**用户端前端每个区域，最终应该读写哪些数据库表**。  
不再混入管理后台（`system/*`、`monitor/*`、`tool/*`）内容，避免看不清业务边界。

---

## 2. 范围与前提

- 当前 Snow 里可见的大量页面能力属于若依管理端，不等于用户端业务前台。
- 本文按“用户端业务闭环”规划：浏览 -> 详情 -> 下单 -> 支付 -> 个人中心。
- 业务表名称基于现有设计文档与项目约定：
  - 行程域：`destinations`、`travel_plans`、`travel_plan_highlights`
  - 攻略域：`travel_guides`、`travel_guide_images`、`travel_guide_tags`
  - 非遗域：`heritage_articles`、`heritage_items`
  - 交易域：`orders`、`order_items`、`payment_records`
  - 会话域：`chat_conversations`、`chat_messages`
  - 用户域：`sys_user`（复用若依用户体系）

---

## 3. 一张表先看懂（区域 -> 主表）

| 用户端区域 | 页面示例 | 主读写表 | 目前状态 |
| --- | --- | --- | --- |
| 认证区 | 登录、注册、退出 | `sys_user`（扩展关联 `sys_user_role`） | 部分可用（偏后台认证） |
| 首页推荐区 | 首页 Banner、推荐卡片 | `travel_plans`、`travel_guides`、`heritage_articles` | 缺聚合接口 |
| 行程列表区 | 行程搜索、筛选列表 | `travel_plans`、`destinations`、`travel_plan_highlights` | 需要标准化查询 |
| 行程详情区 | 行程详情页 | `travel_plans`、`travel_plan_highlights` | 可查详情，字段需补齐 |
| 攻略区 | 攻略列表、攻略详情 | `travel_guides`、`travel_guide_images`、`travel_guide_tags` | 基础能力有雏形 |
| 非遗内容区 | 文章列表、文章详情 | `heritage_articles`、`heritage_items` | 列表/详情链路需统一 |
| 下单区 | 提交订单、确认订单 | `orders`、`order_items` | 有表，前端链路未完整 |
| 支付区 | 发起支付、支付结果页 | `payment_records`（关联 `orders`） | 仅 mock，需补幂等 |
| 我的订单区 | 订单列表、订单详情、取消 | `orders`、`order_items`、`payment_records` | 待建设 |
| AI 会话区 | 聊天窗口、历史会话 | `chat_conversations`、`chat_messages` | 待统一会话模型 |
| 个人中心区 | 个人资料、头像、密码 | `sys_user` | 基础可复用 |

---

## 4. 详细映射（按用户端页面区域）

## 4.1 认证区（登录/注册）

| 页面动作 | 建议接口（用户端） | 关键表 | 说明 |
| --- | --- | --- | --- |
| 手机号/账号登录 | `POST /app/auth/login` | `sys_user` | 读取账号、密码、状态 |
| 注册 | `POST /app/auth/register` | `sys_user` | 写入用户基础信息 |
| 获取当前用户 | `GET /app/user/profile` | `sys_user` | 返回昵称、头像、手机号等 |
| 退出登录 | `POST /app/auth/logout` | `sys_user` | 服务端 token 失效（缓存层） |

---

## 4.2 首页推荐区（发现页）

| 页面模块 | 建议接口（用户端） | 主表 | 说明 |
| --- | --- | --- | --- |
| 推荐行程 | `GET /app/home/recommend-plans` | `travel_plans` | 可按热度/时间排序 |
| 热门攻略 | `GET /app/home/recommend-guides` | `travel_guides` | 返回卡片信息 |
| 非遗精选 | `GET /app/home/recommend-heritage` | `heritage_articles` | 文章卡片摘要 |
| 首页聚合 | `GET /app/home` | 上述三域聚合 | 减少前端并发请求 |

---

## 4.3 行程列表区（搜索筛选）

| 页面动作 | 建议接口（用户端） | 主表 | 关联表 |
| --- | --- | --- | --- |
| 按出发地/目的地搜索 | `GET /app/travel-plans` | `travel_plans` | `destinations` |
| 展示行程亮点 | `GET /app/travel-plans`（列表内嵌） | `travel_plan_highlights` | 关联 `travel_plans` |
| 行程详情跳转 | `GET /app/travel-plans/{id}` | `travel_plans` | `travel_plan_highlights` |

---

## 4.4 攻略区

| 页面动作 | 建议接口（用户端） | 主表 | 关联表 |
| --- | --- | --- | --- |
| 攻略列表 | `GET /app/guides` | `travel_guides` | - |
| 攻略详情 | `GET /app/guides/{id}` | `travel_guides` | `travel_guide_images`、`travel_guide_tags` |
| 攻略搜索（可选） | `GET /app/guides/search` | `travel_guides` | 可基于标签表检索 |

---

## 4.5 非遗内容区

| 页面动作 | 建议接口（用户端） | 主表 | 关联表 |
| --- | --- | --- | --- |
| 文章列表 | `GET /app/heritage/articles` | `heritage_articles` | - |
| 文章详情 | `GET /app/heritage/articles/{id}` | `heritage_articles` | `heritage_items` |
| 非遗条目展示 | 详情内返回 | `heritage_items` | 按 `sort_order` 排序 |

---

## 4.6 下单与支付区

| 页面动作 | 建议接口（用户端） | 主表 | 关联表 |
| --- | --- | --- | --- |
| 创建订单 | `POST /app/orders` | `orders` | `order_items` |
| 订单详情 | `GET /app/orders/{id}` | `orders` | `order_items`、`payment_records` |
| 取消订单 | `POST /app/orders/{id}/cancel` | `orders` | - |
| 发起支付 | `POST /app/payments/pay` | `payment_records` | `orders` |
| 支付状态查询 | `GET /app/payments/{orderNo}/status` | `payment_records` | `orders` |

---

## 4.7 个人中心与我的订单

| 页面模块 | 建议接口（用户端） | 主表 | 说明 |
| --- | --- | --- | --- |
| 个人资料 | `GET/PUT /app/user/profile` | `sys_user` | 头像、昵称、手机号 |
| 我的订单列表 | `GET /app/orders` | `orders` | 按登录用户过滤 |
| 我的订单详情 | `GET /app/orders/{id}` | `orders` | 联合明细与支付记录 |

---

## 4.8 AI 会话区

| 页面动作 | 建议接口（用户端） | 主表 | 关联表 |
| --- | --- | --- | --- |
| 新建会话 | `POST /app/chat/conversations` | `chat_conversations` | - |
| 消息列表 | `GET /app/chat/conversations/{id}/messages` | `chat_messages` | `chat_conversations` |
| 发送消息 | `POST /app/chat/conversations/{id}/messages` | `chat_messages` | `chat_conversations` |

---

## 5. 你现在最关心的“反查索引”

## 5.1 从页面区域反查表

- 首页推荐：`travel_plans` / `travel_guides` / `heritage_articles`
- 行程：`travel_plans` / `travel_plan_highlights` / `destinations`
- 攻略：`travel_guides` / `travel_guide_images` / `travel_guide_tags`
- 非遗：`heritage_articles` / `heritage_items`
- 订单支付：`orders` / `order_items` / `payment_records`
- 聊天：`chat_conversations` / `chat_messages`
- 用户资料：`sys_user`

## 5.2 从表反查页面区域

- `travel_plans`：首页推荐、行程列表、行程详情
- `travel_plan_highlights`：行程列表卡片亮点、行程详情亮点
- `travel_guides`：首页攻略推荐、攻略列表、攻略详情
- `heritage_articles`：首页非遗推荐、非遗列表、文章详情
- `orders`：下单确认、我的订单、订单详情
- `payment_records`：支付页、支付结果页、订单支付状态
- `chat_messages`：AI 聊天窗口、历史消息

---

## 6. 当前缺口（避免再次混乱）

- 现在仓库里管理端信息很多，容易误以为“用户端已完成”；实际用户端业务链路并未完整落地。
- 缺少统一用户端命名空间（建议统一到 `/app/*`），导致同类能力分散在不同路径。
- 首页、订单、支付、会话虽然有表或雏形接口，但“页面区域 -> 接口 -> 表”未形成闭环。

---

## 7. 下一步执行顺序（建议）

1. 先冻结用户端接口前缀与命名（`/app/*`）。
2. 先打通三条主链路：`首页/列表`、`详情`、`下单支付`。
3. 联调时严格按本文做映射检查：页面每个字段都能追溯到具体表字段。
4. 管理端文档与用户端文档分离维护，避免再次混写。

