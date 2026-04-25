# 东北旅游前后端联调差异与阻塞清单

## P0 阻塞项（会直接导致联调失败）

1. 前端默认 Mock 开关开启  
   - 文件：`Sonw/snowTravel/src/api/auth.js`、`travel.js`、`travelGuide.js`、`chat.js`、`heritage.js`  
   - 现状：`USE_MOCK_DATA = true`，真实接口不被调用。

2. Base URL 策略不统一  
   - 现状：部分模块用 `'/api'`，部分模块写死 `'http://test-cn.your-api-server.com/api'`。  
   - 风险：本地开发、测试、生产环境切换困难，跨域与代理行为不一致。

3. 路径不一致  
   - `getCaptcha` 调 `/api/captcha`，后端实际是 `/api/auth/captcha`。  
   - `getUserProfile` 调 `/api/user/profile/{id}`，后端实际是 `/api/profile/{id}`。

4. 前端调用了后端不存在的接口  
   - `/location/city`、`/routes/recommended`、`/routes/{id}`、`/home/snow-ice`、`/heritage*`、`/subjects/search`。  
   - 结果：关闭 mock 后会出现 404。

## P1 高风险项（可能联调可通但行为不稳定）

1. GET 接口使用 `@RequestBody`  
   - 后端文件：`TravelGuideController`、`TourSteamController`、`ContentController`、`ProductController`、`TourController`。  
   - 风险：部分网关/客户端不会给 GET 传 body；前端当前多用 query 参数，可能出现入参丢失。

2. 分页参数命名未统一  
   - 前端：`page` + `size`（`fetchArticles`）。  
   - 后端：接收 `ProductPageQueryRequest`，字段是否叫 `size` 需再确认 DTO。

3. 前端 `GET` 请求携带 body  
   - 文件：`Sonw/snowTravel/src/api/heritage.js` 的 `getArticleDetail`。  
   - 风险：很多服务器忽略 GET body，增加兼容性问题。

## P2 上线前治理项（不一定阻塞当前联调）

1. 鉴权链路未启用  
   - 后端 `WebMvcConfiguration` 中 JWT 拦截器被注释禁用。  
   - 影响：联调阶段更方便，但无法覆盖真实鉴权场景。

2. CORS 未显式配置  
   - 当前代码未见 `addCorsMappings/@CrossOrigin/CorsFilter`。  
   - 影响：若前后端不同域名，浏览器会被跨域策略拦截。

## 建议最小改造

1. 前端统一 API 网关层  
   - 新增统一 `apiBaseUrl`（从 `VITE_API_BASE_URL` 读取），所有 `src/api/*.js` 走同一策略。  
2. 联调期统一关闭 mock  
   - 支持全局环境开关（如 `VITE_USE_MOCK=false`），避免逐文件改常量。  
3. 先修复必错路径  
   - `captcha` 和 `profile` 两个接口优先改。  
4. 按“后端现有能力”收敛前端调用  
   - 未实现接口先降级为 mock 或隐藏入口，避免页面硬报错。  
