# 东北旅游前后端接口映射表

## 说明
- 后端统一前缀：`/api`（见 `application.yml` 的 `server.servlet.context-path`）。
- 表中“前端URL”来自 `Sonw/snowTravel/src/api/*.js`。
- 表中“后端URL”按 Controller 注解组合得到：类级 `@RequestMapping` + 方法级 `@GetMapping/@PostMapping`。

## 已匹配接口

| 模块 | 前端函数 | 前端URL | 后端Controller方法 | 后端URL | 结果 |
| --- | --- | --- | --- | --- | --- |
| 登录验证码 | `getCaptcha` (`auth.js`) | `GET /api/captcha` | `UserLoginController.getCaptcha` | `GET /api/auth/captcha` | 路径不一致 |
| 密码登录 | `loginWithPassword` (`auth.js`) | `POST /api/auth/login/password` | `UserLoginController.login` | `POST /api/auth/login/password` | 一致 |
| 用户注册 | `register` (`auth.js`) | `POST /api/auth/register` | `UserController.register` | `POST /api/auth/register` | 一致 |
| 用户信息 | `getUserProfile` (`auth.js`) | `GET /api/user/profile/{id}` | `UserController.select` | `GET /api/profile/{id}` | 路径不一致 |
| 用户信息 | `getUserProfile` (`travel.js`) | `GET /api/user/profile/{id}` | `UserController.select` | `GET /api/profile/{id}` | 路径不一致 |
| AI聊天 | `sendChatMessage` (`chat.js`) | `POST /api/chat` | `ChatController.chat` | `POST /api/chat` | 一致 |
| 旅游计划搜索 | `searchTravelPlan` (`travel.js`) | `GET /api/search/travel-plan?...` | `TourSteamController.select` | `GET /api/search/travel-plan` | 基础路径一致（入参方式需对齐） |
| 攻略专题列表 | `getSubjects` (`travelGuide.js`) | `GET /api/subjects` | `TravelGuideController.getSubjects` | `GET /api/subjects` | 一致（入参方式需对齐） |
| 攻略专题详情 | `getSubjectById` (`travelGuide.js`) | `GET /api/subjects/{id}` | `TravelGuideController.getSubjectById` | `GET /api/subjects/{catagoryId}` | 一致（参数名拼写有误） |
| 文章列表 | `fetchArticles` (`travel.js`) | `GET /api/articles?page=&size=` | `ContentController.getContent` | `GET /api/articles` | 一致（分页参数命名待确认） |
| 文章详情 | `getArticleDetail` (`heritage.js`) | `GET /api/articles/{id}` | `ContentController.getContentById` | `GET /api/articles/{id}` | 一致（前端不应携带GET body） |

## 前端调用但后端未发现对应接口

| 前端函数 | 前端URL | 备注 |
| --- | --- | --- |
| `getCurrentLocation` (`travel.js`) | `POST /api/location/city` | 后端无 `location` 相关 Controller |
| `getRecommendedRoutes` (`travel.js`) | `GET /api/routes/recommended` | 后端无 `routes` 相关接口 |
| `getHomePageData` (`travel.js`) | `GET /api/home/snow-ice` | 后端无 `home` 相关接口 |
| `getRouteDetails` (`travel.js`) | `GET /api/routes/{id}` | 后端无 `routes` 详情接口 |
| `searchSubjects` (`travelGuide.js`) | `GET /api/subjects/search` | 后端未实现 `/subjects/search` |
| `getHeritageList` (`heritage.js`) | `GET /api/heritage` | 后端无 `heritage` Controller |
| `searchHeritage` (`heritage.js`) | `GET /api/heritage/search` | 后端无 `heritage/search` |

## 后端已提供但前端未接入（当前代码未见调用）

| 后端接口 | Controller | 备注 |
| --- | --- | --- |
| `POST /api/orders` | `OrderController.createOrder` | 订单创建 |
| `POST /api/payments/mock/pay` | `PaymentController.createPayment` | 模拟支付 |
| `POST /api/payments/mock/callback` | `PaymentController.callback` | 支付回调 |
| `GET /api/products` / `GET /api/products/{id}` | `ProductController` | 商品接口 |
| `GET /api/tours` / `GET /api/tours/{id}` | `TourController` | 团游接口 |
| `POST /api/agent/chat` | `AgentController.chat` | Agent 聊天接口 |
