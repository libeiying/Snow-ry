# 东北旅游联调执行顺序与验收点

## 联调前准备

1. 启动后端服务，确认健康访问：`http://localhost:8080/api`（至少能命中已有接口）。  
2. 前端统一配置环境变量：  
   - `VITE_API_BASE_URL=http://localhost:8080/api`  
   - `VITE_USE_MOCK=false`  
3. 前端临时修正必错路径：  
   - 验证码：`/captcha -> /auth/captcha`  
   - 用户信息：`/user/profile/{id} -> /profile/{id}`

## 联调优先级（从高到低）

### 第一阶段：账号链路（必须先通）
1. `GET /api/auth/captcha`  
2. `POST /api/auth/login/password`  
3. `POST /api/auth/register`  
4. `GET /api/profile/{id}`

验收标准：
- 登录成功返回 token 与用户基础信息。
- 用户信息查询可按 id 取到数据。
- 页面可完成“注册 -> 登录 -> 展示用户信息”闭环。

### 第二阶段：核心浏览链路
1. `GET /api/search/travel-plan`  
2. `GET /api/subjects`  
3. `GET /api/subjects/{id}`  
4. `GET /api/articles`  
5. `GET /api/articles/{id}`

验收标准：
- 首页搜索、攻略列表/详情、文章列表/详情能展示真实后端数据。
- 关键字段（标题、图片、描述、分页）与前端组件字段名对齐。

### 第三阶段：AI 对话链路
1. `POST /api/chat`  
2. （可选）`POST /api/agent/chat`

验收标准：
- 前端聊天组件可以提交消息并渲染回复。
- 后端异常时前端有兜底提示，不出现白屏。

### 第四阶段：扩展能力补齐
1. 订单：`POST /api/orders`  
2. 支付：`POST /api/payments/mock/pay`、`POST /api/payments/mock/callback`  
3. 商品/团游：`/products*`、`/tours*`  
4. 补齐缺失接口或前端降级策略：`/home/snow-ice`、`/routes*`、`/heritage*`、`/subjects/search`

验收标准：
- 新功能链路至少完成“请求成功 + 页面可见 + 错误可感知”三项。

## 回归检查清单

1. 路由页回归：首页、攻略页、非遗页、聊天页、登录注册页。  
2. 请求回归：确认不再访问 `test-cn.your-api-server.com`。  
3. 鉴权回归：开启 JWT 拦截器后，仅放行登录、注册、验证码。  
4. 跨域回归：若跨域部署，补 CORS 或网关代理后再做浏览器验证。  

## 建议的对接分工

- 前端：统一请求层与环境配置、修正路径与 mock 开关、页面字段适配。  
- 后端：补齐缺失接口或提供替代方案、规范分页参数、恢复鉴权配置。  
- 联调负责人：维护“接口映射表 + 差异清单”，每日清理阻塞项。  
