# 前后端现状与优化落地方案

## 1. 背景与目标

当前项目状态：

- 用户端参考仓库：`E:/projectManager/feiyi/Northeast-travel`
- 业务数据库设计：`E:/projectManager/20260425102606/Snow/sql/business_schema_ruoyi_style.sql`
- Snow 当前基线：若依框架已搭建，管理端登录注册已打通，业务域后端未完整落地

本文目标：

- 明确前端当前具备能力与缺失项（按用户旅程）
- 明确后端需补齐模块/API/数据契约（对齐业务库）
- 给出前端页面与交互优化方案
- 给出 P0/P1/P2 实施路线与验收标准

---

## 2. 前端现状与缺口（按用户旅程）

> 说明：`Northeast-travel` 当前主要是后端 API 工程，不是可直接评审的独立前端页面工程（未发现 `package.json` 与前端页面目录结构）。

### 2.1 登录注册

**已有能力**

- Snow 管理端已接通 `/login`、`/register`、`/captchaImage`、`/getInfo`
- 登录/注册页面已有初步视觉改造（背景、卡片、动效）

**关键缺失**

- 仍偏“后台登录体验”，非“用户端认证体系”（短信登录、找回密码、协议同意等）
- 缺少异常场景设计（验证码失败、网络超时、账号风控提示）

**优先级**：P0

### 2.2 发现内容（首页/列表）

**已有能力**

- 存在内容查询型 API 雏形（行程、攻略、文章、商品）

**关键缺失**

- 缺少用户端首页聚合接口（Banner/推荐/分区）
- 缺少真实用户端页面工程与组件体系
- 部分接口风格不统一（如 `GET + body`），影响前端接入稳定性

**优先级**：P0

### 2.3 详情决策（行程/攻略）

**已有能力**

- 有详情查询接口雏形（按 ID 查询）

**关键缺失**

- 详情页信息架构未标准化（亮点、费用、库存、退改、保障）
- 缺少从“详情 -> 下单”的转化组件与埋点设计

**优先级**：P1（如以成交为核心可上调到 P0）

### 2.4 下单支付

**已有能力**

- 数据表结构完整：`orders`、`order_items`、`payment_records`
- 有 mock 支付入口

**关键缺失**

- 下单用户未接真实登录态（存在写死用户 ID 风险）
- 支付仅 mock，幂等与回调安全策略未完善
- 前端缺少支付失败恢复、轮询回查、补单策略

**优先级**：P0

### 2.5 个人中心/消息

**已有能力**

- 聊天表结构已设计：`chat_conversations`、`chat_messages`

**关键缺失**

- 订单管理、资料维护、消息会话等用户中心能力尚未落地
- 评价域缺少数据表（后续口碑功能无法直接开发）

**优先级**：P1

---

## 3. 后端补齐蓝图（若依风格）

## 3.1 数据库业务域拆分（已存在）

- 行程域：`destinations`、`travel_plans`、`travel_plan_highlights`
- 攻略域：`travel_guides`、`travel_guide_images`、`travel_guide_tags`
- 非遗域：`heritage_articles`、`heritage_items`
- 会话域：`chat_conversations`、`chat_messages`
- 交易域：`orders`、`order_items`、`payment_records`
- 用户域：复用 `sys_user`
- 评价域：缺表，需新增

## 3.2 业务模块建议

建议新增用户端 API 命名空间：`/app/*`，与管理端接口隔离。

- `app/auth`：登录、注册、验证码、用户信息
- `app/travel`：目的地、行程列表、行程详情
- `app/content`：攻略、非遗
- `app/order`：下单、订单列表、订单详情、取消订单
- `app/payment`：发起支付、回调处理、状态查询
- `app/chat`：会话创建、消息读写
- `app/review`：评价发布与查询（补表后）

每个域按若依风格落地：

- `controller` + `service` + `mapper` + `domain/entity` + `vo/dto`

## 3.3 最小可用 API（MVP）

- 认证：
  - `POST /app/auth/login`
  - `POST /app/auth/register`
  - `GET /app/auth/captcha`
  - `GET /app/user/profile`
- 发现：
  - `GET /app/home`
  - `GET /app/destinations`
  - `GET /app/travel-plans`
  - `GET /app/travel-plans/{id}`
  - `GET /app/guides`
  - `GET /app/guides/{id}`
  - `GET /app/heritage/articles`
  - `GET /app/heritage/articles/{id}`
- 交易：
  - `POST /app/orders`
  - `GET /app/orders`
  - `GET /app/orders/{id}`
  - `POST /app/orders/{id}/cancel`
  - `POST /app/payments/pay`
  - `POST /app/payments/callback`
  - `GET /app/payments/{orderNo}/status`
- 会话：
  - `POST /app/chat/conversations`
  - `GET /app/chat/conversations`
  - `GET /app/chat/conversations/{id}/messages`
  - `POST /app/chat/conversations/{id}/messages`

## 3.4 若依集成点（必须落实）

- 鉴权权限：`@PreAuthorize` + 角色权限点
- 分页统一：`startPage()` + `getDataTable()`
- 文件上传：复用 `/common/upload`
- 字典治理：订单状态、支付状态、业务类型统一字典
- 操作日志：关键交易接口 `@Log`
- 响应统一：统一 `code/msg/data` 结构

## 3.5 当前高风险项

- JWT 拦截被禁用（需优先恢复）
- 下单用户来源未接登录态
- 验证码接口不应返回明文验证码
- 支付回调需幂等与防重放
- 查询接口规范不统一（建议全部改为 query 参数）

---

## 4. 前端页面与交互优化方案

## 4.1 设计目标

从“可用”升级为“可信赖、可转化”，重点优化：

- 信息层级清晰
- 页面视觉一致
- 关键路径流畅（浏览 -> 详情 -> 下单 -> 支付）

## 4.2 页面优先改造顺序

1. 登录/注册：品牌统一 + 错误恢复
2. 首页/列表：推荐流 + 筛选 + 骨架屏
3. 详情页：亮点分层 + 价格库存 + 强 CTA
4. 下单/支付：步骤化 + 失败可恢复
5. 个人中心：订单管理与会话入口

## 4.3 设计系统最小规范

- 色彩语义：主色/中性色/状态色（成功/警告/失败）
- 字体层级：H1/H2/H3/Body/Caption
- 间距系统：8px 栅格（8/16/24/32/48）
- 组件规范：按钮、输入框、卡片、空态、错误态、Skeleton
- 动效策略：仅用于反馈与引导，不堆砌装饰

## 4.4 响应式策略

- 桌面：`>=1200`
- 平板：`768-1199`
- 手机：`<768`

重点检查：

- 表单与验证码区域不换行错位
- 详情页 CTA 在移动端可见且不遮挡
- 列表卡片在窄屏保持可读

---

## 5. 实施路线图（P0/P1/P2）

## 5.1 P0（第一阶段：先打通业务闭环）

- 恢复鉴权拦截并校验登录态
- 修复下单用户来源（从 token 解析用户）
- 统一查询接口规范（避免 `GET + body`）
- 落地首页/列表/详情/下单最小 API
- 前端完成关键页面首版：登录、首页、详情、下单

**P0 验收**

- 用户可完成：登录 -> 浏览 -> 下单
- 接口鉴权生效，未授权请求被拦截
- 移动端关键页面无严重错位

## 5.2 P1（第二阶段：稳定性与体验）

- 支付状态查询 + 回调幂等
- 订单管理（列表/详情/取消）
- 聊天会话读写 + 历史分页
- 组件视觉一致性收口

**P1 验收**

- 浏览 -> 下单 -> 支付状态回查链路跑通
- 支付重复回调不会重复改单
- 错误提示可读、可恢复

## 5.3 P2（第三阶段：增长与运营）

- 新增评价表与评价接口
- 首页推荐运营位
- 埋点与漏斗分析（曝光/点击/下单/支付）

**P2 验收**

- 可观察转化漏斗
- 可按内容运营持续迭代

---

## 6. 建议下一步执行顺序

1. 先冻结 API 规范（路径、入参、返回、错误码）
2. 后端按域并行开发 `travel/content/order/payment`
3. 前端先做高转化页面：`首页 -> 详情 -> 下单`
4. 联调阶段补齐异常流与状态流（尤其支付）
5. 最后统一视觉与组件规范，避免返工

---

## 7. 前端已有功能与后端表映射（补全版）

本节聚焦当前 `Snow-ui` 已实现能力（以 `src/api` 与 `src/views` 为准），回答三个问题：

- 现在前端到底已经有什么功能
- 这些功能对应后端哪些接口与数据表
- 功能模块该如何按“管理域 vs 业务域”拆分

## 7.1 现有前端功能结论

当前 `Snow-ui` 绝大多数是若依后台管理模块，不是用户端业务前台。主要分为：

- 认证与个人信息：登录、注册、个人中心
- 系统管理：用户、角色、菜单、部门、岗位、字典、参数、公告
- 监控运维：在线用户、登录日志、操作日志、任务调度、缓存、服务监控
- 开发工具：代码生成、表单构建、Swagger

这意味着：**前端已覆盖“平台治理能力”，但尚未覆盖“东北旅游业务闭环能力”**。

## 7.2 前端功能 -> 后端接口 -> 主要数据表映射

### A. 认证与个人中心（已可用）

- 前端 API：
  - `/login`、`/register`、`/captchaImage`、`/getInfo`、`/logout`
  - `/system/user/profile`、`/system/user/profile/updatePwd`、`/system/user/profile/avatar`
- 主要后端控制器：
  - `SysLoginController`、`SysRegisterController`、`CaptchaController`、`SysProfileController`
- 主要数据表：
  - `sys_user`
  - `sys_user_role`（用户角色关联）
  - `sys_role`（权限归属）

### B. 用户与权限管理（已可用）

- 前端 API：
  - `/system/user/*`
  - `/system/role/*`
  - `/system/menu/*`
  - `/system/dept/*`
  - `/system/post/*`
- 主要后端控制器：
  - `SysUserController`、`SysRoleController`、`SysMenuController`、`SysDeptController`、`SysPostController`
- 主要数据表：
  - `sys_user`、`sys_role`、`sys_menu`、`sys_dept`、`sys_post`
  - `sys_user_role`、`sys_role_menu`、`sys_role_dept`

### C. 字典、参数、公告（已可用）

- 前端 API：
  - `/system/dict/type/*`
  - `/system/dict/data/*`
  - `/system/config/*`
  - `/system/notice/*`
- 主要后端控制器：
  - `SysDictTypeController`、`SysDictDataController`、`SysConfigController`、`SysNoticeController`
- 主要数据表：
  - `sys_dict_type`、`sys_dict_data`
  - `sys_config`
  - `sys_notice`

### D. 运维监控（已可用）

- 前端 API：
  - `/monitor/online/*`
  - `/monitor/logininfor/*`
  - `/monitor/operlog/*`
  - `/monitor/job/*`、`/monitor/jobLog/*`
  - `/monitor/server/*`、`/monitor/cache/*`
- 主要后端控制器：
  - `SysUserOnlineController`、`SysLogininforController`、`SysOperlogController`
  - `JobController/JobLogController`（若依定时任务模块）
  - `ServerController`、`CacheController`
- 主要数据表：
  - `sys_logininfor`、`sys_oper_log`
  - `sys_job`、`sys_job_log`
  - 在线会话相关缓存（Redis，非固定业务表）

### E. 开发工具（已可用）

- 前端 API：
  - `/tool/gen/*`
- 主要后端控制器：
  - `GenController`（代码生成模块）
- 主要数据表：
  - `gen_table`、`gen_table_column`

## 7.3 业务库表当前与前端覆盖关系

### 已有前端入口（间接或部分）

- 用户相关：复用 `sys_user`（登录注册/资料）

### 目前尚无对应前端业务模块（核心缺口）

- 行程域：
  - `destinations`
  - `travel_plans`
  - `travel_plan_highlights`
- 攻略域：
  - `travel_guides`
  - `travel_guide_images`
  - `travel_guide_tags`
- 非遗域：
  - `heritage_articles`
  - `heritage_items`
- 交易域：
  - `orders`
  - `order_items`
  - `payment_records`
- 会话域：
  - `chat_conversations`
  - `chat_messages`

结论：**业务表已设计完成，但 Snow 前端当前并没有这些表对应的业务页面与 API 调用层。**

## 7.4 功能模块划分建议（落地结构）

建议将能力拆为两条线并行，避免后台功能和用户业务相互污染：

- 管理域（保留现状，继续走若依标准）：
  - `system/*`、`monitor/*`、`tool/*`
- 业务域（新增用户端）：
  - `app-auth`：用户认证与资料
  - `app-travel`：目的地/行程列表/行程详情
  - `app-content`：攻略与非遗
  - `app-order`：下单/订单管理
  - `app-payment`：支付与状态回查
  - `app-chat`：AI 会话
  - `app-review`：评价（补表后）

前端目录建议（示意）：

- `src/views/app/home`
- `src/views/app/travel`
- `src/views/app/guide`
- `src/views/app/order`
- `src/views/app/profile`
- `src/api/app/*.js`

后端路由建议（示意）：

- `/app/home`
- `/app/travel-plans`
- `/app/guides`
- `/app/orders`
- `/app/payments`
- `/app/chat`

## 7.5 当前差距的本质

当前并不是“前端页面太少”这么简单，而是：

1. 已有前端是“管理后台能力”，不是“业务前台能力”
2. 已有数据库是“业务模型优先”，但尚未形成“前后端业务链路”
3. 缺少“功能域划分 + API 命名规范 + 页面信息架构”的统一基线

因此后续应优先做：**业务域建模统一 -> API 契约统一 -> 前台页面落地**，而不是继续在管理端页面做局部美化。

