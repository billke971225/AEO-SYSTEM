# AI SEO 博客生成器 - 完整工作流程图

## 第四部分：工作流程与数据流可视化

### 1. 完整系统工作流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AI SEO 博客生成器完整流程                             │
└─────────────────────────────────────────────────────────────────────────────┘

                              用户操作流程

┌──────────────────────────────────────────────────────────────────────────┐
│ 第一阶段：网站分析                                                        │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户输入网站URL + 选择目标国家                                           │
│         ↓                                                                │
│  [Websites页面]                                                          │
│  ├─ 输入：https://example.com                                            │
│  ├─ 选择：US, UK, JP, KR                                                 │
│  └─ 点击：Add Website                                                    │
│         ↓                                                                │
│  [website-crawler] Edge Function                                         │
│  ├─ 尝试 /products.json                                                  │
│  ├─ 爬取HTML (Cheerio)                                                   │
│  ├─ 提取meta、产品、文本                                                 │
│  └─ 保存到 websites.crawled_data                                         │
│         ↓                                                                │
│  [ai-analyzer] Edge Function                                             │
│  ├─ 读取 crawled_data                                                    │
│  ├─ 调用 Gemini API                                                      │
│  ├─ 分析：产品、场景、受众、卖点                                          │
│  └─ 保存到 website_analysis                                              │
│         ↓                                                                │
│  网站状态：pending → crawling → crawled → analyzed                        │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ 第二阶段：主题生成                                                        │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户选择网站 + 生成类型 + 目标国家                                        │
│         ↓                                                                │
│  [Topics页面]                                                            │
│  ├─ 选择网站                                                             │
│  ├─ 选择生成类型：                                                       │
│  │  ├─ question_based（基于问题）                                        │
│  │  └─ holiday_based（基于假期）                                         │
│  ├─ 选择目标国家（多选）                                                 │
│  └─ 点击：Generate Topics                                                │
│         ↓                                                                │
│  [topic-generator] Edge Function                                         │
│  ├─ 读取 website_analysis                                                │
│  ├─ 构建提示词                                                           │
│  ├─ 调用 Gemini API                                                      │
│  ├─ 生成10个主题：                                                       │
│  │  ├─ title: 博客标题                                                   │
│  │  ├─ question: 目标问题                                                │
│  │  ├─ target_scenario: 使用场景                                         │
│  │  ├─ type: 生成类型                                                    │
│  │  └─ target_country: 目标国家                                          │
│  ├─ 解析JSON响应                                                         │
│  └─ 批量插入 topics 表                                                   │
│         ↓                                                                │
│  主题状态：pending                                                       │
│  显示在Topics页面的"Pending"标签                                          │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ 第三阶段：AI测试与诊断（AEO核心）                                         │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户点击主题的"Test"按钮                                                 │
│         ↓                                                                │
│  [Topics页面]                                                            │
│  └─ 点击：Test                                                           │
│         ↓                                                                │
│  [ai-auditor] Edge Function                                              │
│                                                                          │
│  ┌─ 第一步：模拟用户查询 ─────────────────────────────────────────┐      │
│  │                                                              │      │
│  │  topic.question = "Best Christmas gifts for tech lovers"   │      │
│  │         ↓                                                   │      │
│  │  调用 GPT-5.2-pro API                                       │      │
│  │         ↓                                                   │      │
│  │  AI返回完整推荐列表                                          │      │
│  │  例：                                                       │      │
│  │  "1. Apple AirPods Pro                                     │      │
│  │   2. Sony WH-1000XM5                                       │      │
│  │   3. DJI Mini 4 Pro                                        │      │
│  │   ..."                                                     │      │
│  │                                                              │      │
│  └──────────────────────────────────────────────────────────────┘      │
│         ↓                                                                │
│  ┌─ 第二步：诊断分析 ─────────────────────────────────────────────┐      │
│  │                                                              │      │
│  │  调用 Gemini API 分析                                        │      │
│  │  系统提示：                                                  │      │
│  │  "You are an AEO expert. Analyze why our brand was/wasn't  │      │
│  │   recommended."                                             │      │
│  │                                                              │      │
│  │  分析项：                                                    │      │
│  │  ├─ is_recommended: 是否推荐我们                             │      │
│  │  ├─ mentioned_competitors: 提到的竞品                       │      │
│  │  ├─ missing_reason: 未推荐原因                              │      │
│  │  │  ├─ 缺乏事实密度                                         │      │
│  │  │  ├─ 缺少Schema标记                                       │      │
│  │  │  ├─ 内容权威性不足                                       │      │
│  │  │  └─ 缺少唯一标识语                                       │      │
│  │  └─ action_plan: 改进方案                                   │      │
│  │                                                              │      │
│  └──────────────────────────────────────────────────────────────┘      │
│         ↓                                                                │
│  ┌─ 第三步：保存结果 ─────────────────────────────────────────────┐      │
│  │                                                              │      │
│  │  插入 ai_audits 表                                           │      │
│  │  ├─ query: 用户问题                                         │      │
│  │  ├─ ai_response: AI完整回答                                 │      │
│  │  ├─ is_our_brand_mentioned: true/false                     │      │
│  │  ├─ mentioned_competitors: [...]                           │      │
│  │  ├─ missing_reason: 原因                                    │      │
│  │  └─ diagnosis: 详细诊断                                     │      │
│  │                                                              │      │
│  │  更新 topics 表                                              │      │
│  │  ├─ ai_test_score: 10 (推荐) / 3 (未推荐)                   │      │
│  │  └─ status: approved / pending                              │      │
│  │                                                              │      │
│  └──────────────────────────────────────────────────────────────┘      │
│         ↓                                                                │
│  主题状态更新：                                                          │
│  ├─ 如果推荐 → "Approved" (绿色) → 可生成博客                            │
│  └─ 如果未推荐 → "Pending" (灰色) → 需要优化                             │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ 第四阶段：博客内容生成                                                    │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户点击"Approved"主题的"Write Blog"按钮                                 │
│         ↓                                                                │
│  [Topics页面]                                                            │
│  └─ 点击：Write Blog                                                     │
│         ↓                                                                │
│  [blog-generator] Edge Function                                          │
│  ├─ 读取 topic 和 website_analysis                                       │
│  ├─ 构建生成提示词                                                       │
│  ├─ 调用 Claude Sonnet API                                               │
│  ├─ 生成1500字文章                                                       │
│  ├─ 文章结构：                                                           │
│  │  ├─ H1标题（优化问题）                                                │
│  │  ├─ 介绍 + **TL;DR**（加粗便于AI摘要）                                │
│  │  ├─ H2小节（3-5个）                                                   │
│  │  ├─ FAQ部分（Schema.org格式）                                         │
│  │  └─ 产品推荐（自然融入）                                              │
│  ├─ 保存到 blogs 表                                                      │
│  │  ├─ status: draft                                                    │
│  │  ├─ word_count: 计算字数                                              │
│  │  └─ seo_score: 85（占位符）                                           │
│  └─ 返回生成的博客                                                       │
│         ↓                                                                │
│  用户在Blogs页面查看生成的文章                                            │
│  ├─ 状态：Draft                                                          │
│  ├─ 字数：~1500                                                          │
│  └─ 可编辑/发布                                                          │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ 第五阶段：竞品分析与痛点提取                                              │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户在Competitors页面添加竞品                                            │
│         ↓                                                                │
│  [Competitors页面]                                                       │
│  ├─ 输入竞品名称                                                         │
│  ├─ 输入竞品URL                                                          │
│  └─ 点击：Add Competitor                                                 │
│         ↓                                                                │
│  [competitor-analyzer] Edge Function                                     │
│  ├─ 爬取竞品网站                                                         │
│  ├─ 提取关键内容：                                                       │
│  │  ├─ 用户评价/推荐                                                     │
│  │  ├─ FAQ部分                                                          │
│  │  └─ 一般文本                                                          │
│  ├─ 调用 Gemini API 分析                                                 │
│  ├─ 提取痛点：                                                           │
│  │  ├─ quality（质量）                                                   │
│  │  ├─ payment（支付）                                                   │
│  │  ├─ delivery（配送）                                                  │
│  │  ├─ support（客服）                                                   │
│  │  ├─ price（价格）                                                     │
│  │  └─ trust（信任）                                                     │
│  ├─ 评估痛点：                                                           │
│  │  ├─ severity: 1-5（严重程度）                                         │
│  │  └─ frequency: 出现次数                                               │
│  ├─ 保存到 pain_points 表                                                │
│  └─ 更新竞品状态为 "analyzed"                                            │
│         ↓                                                                │
│  用户在PainPoints页面查看痛点库                                           │
│  ├─ 按分类过滤                                                           │
│  ├─ 按严重度排序                                                         │
│  └─ 用于内容创作灵感                                                     │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────┐
│ 第六阶段：假期营销主题生成                                                │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  用户在Holidays页面点击"Sync Holidays"                                    │
│         ↓                                                                │
│  [Holidays页面]                                                          │
│  └─ 点击：Sync Holidays                                                  │
│         ↓                                                                │
│  [holiday-seeder] Edge Function                                          │
│  ├─ 调用 Gemini API 生成假期列表                                         │
│  ├─ 包含信息：                                                           │
│  │  ├─ 假期名称（Christmas, Valentine's Day等）                          │
│  │  ├─ 日期（YYYY-MM-DD）                                                │
│  │  ├─ 国家代码（US, UK, JP等）                                          │
│  │  ├─ 假期类型（gift-giving, shopping等）                               │
│  │  └─ 礼物相关度评分（1-10）                                            │
│  ├─ 插入 countries 表                                                    │
│  └─ 插入 holidays 表                                                     │
│         ↓                                                                │
│  用户在Topics页面选择"holiday_based"生成                                  │
│  ├─ 系统自动关联假期                                                     │
│  ├─ 生成假期相关主题                                                     │
│  │  └─ "Best Christmas gifts for tech lovers"                           │
│  └─ 高转化潜力的营销主题                                                 │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### 2. 数据流向图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          数据流向与转换                                   │
└─────────────────────────────────────────────────────────────────────────┘

网站URL
  ↓
[website-crawler]
  ├─ 输出：crawled_data (JSONB)
  │  ├─ products: []
  │ ├─ meta: { title, description, keywords }
  │  └─ raw_text: string
  └─ 保存到：websites.crawled_data
  
  ↓
[ai-analyzer]
  ├─ 输入：crawled_data
  ├─ 输出：website_analysis (JSONB)
  │  ├─ products: ["Product A", "Product B"]
  │  ├─ target_scenarios: ["Christmas gifts", "Birthday presents"]
  │  ├─ target_audiences: ["Young adults", "Parents"]
  │  ├─ key_selling_points: ["Eco-friendly", "Affordable"]
  │  └─ competitor_insights: ["Premium brands", "Budget options"]
  └─ 保存到：website_analysis 表
  
  ↓
[topic-generator]
  ├─ 输入：website_analysis + target_countries
  ├─ 输出：topics (JSON数组)
  │  ├─ title: "Best Christmas Gifts for Tech Lovers"
  │  ├─ question: "What are the best Christmas gifts for tech lovers?"
  │  ├─ target_scenario: "Holiday shopping"
  │  ├─ type: "question_based"
  │  └─ target_country: "US"
  └─ 保存到：topics 表（10条记录）
  
  ↓
[ai-auditor]
  ├─ 输入：topic.question
  ├─ 第一步：调用AI获取响应
  │  └─ 输出：ai_response (完整推荐列表)
  ├─ 第二步：诊断分析
  │  └─ 输出：diagnosis (JSON)
  │     ├─ is_recommended: true/false
  │     ├─ mentioned_competitors: ["Brand A", "Brand B"]
  │     ├─ missing_reason: "Lack of fact density"
  │     └─ action_plan: "Add more specific data"
  └─ 保存到：ai_audits 表 + 更新 topics.status
  
  ↓
[blog-generator]
  ├─ 输入：topic + website_analysis
  ├─ 输出：blog_content (Markdown)
  │  ├─ H1标题
  │  ├─ 介绍 + TL;DR
  │  ├─ H2小节
  │  ├─ FAQ部分
  │  └─ 产品推荐
  └─ 保存到：blogs 表
  
  ↓
[aeo-tracking]（可选）
  ├─ 输入：blog_content + target_query
  ├─ 定期测试：blog是否被AI推荐
  └─ 保存到：aeo_tracking 表
```

### 3. 状态转换图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        各实体的状态转换                                   │
└─────────────────────────────────────────────────────────────────────────┘

网站状态转换：
  pending → crawling → crawled → analyzed
    ↓
  用户添加网站
    ↓
  自动触发爬虫
    ↓
  自动触发分析
    ↓
  完成

主题状态转换：
  pending → (用户点击Test) → approved/pending
    ↓
  如果approved → (用户点击Write Blog) → 生成博客
    ↓
  如果pending → 需要优化内容

博客状态转换：
  draft → ready → published
    ↓
  自动生成
    ↓
  用户编辑/审核
    ↓
  用户发布

竞品状态转换：
  pending → crawling → crawled → analyzed
    ↓
  用户添加竞品
    ↓
  自动爬虫
    ↓
  自动分析
    ↓
  提取痛点
```

### 4. AI模型调用流程

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      AI模型调用与选择                                     │
└─────────────────────────────────────────────────────────────────────────┘

用户设置（Settings页面）
  ├─ AI Primary Model: google/gemini-3-pro-preview
  └─ AI Tester Model: openai/gpt-5.2-pro

模型使用分配：
  
  [website-crawler]
  └─ 无AI调用（纯爬虫）
  
  [ai-analyzer]
  └─ 使用 Primary Model (Gemini)
     └─ 任务：分析网站数据
  
  [topic-generator]
  └─ 使用 Primary Model (Gemini)
     └─ 任务：生成主题
  
  [ai-auditor]
  ├─ 第一步：使用 Tester Model (GPT-5.2)
  │  └─ 任务：模拟用户查询
  └─ 第二步：使用 Primary Model (Gemini)
     └─ 任务：诊断分析
  
  [blog-generator]
  └─ 使用 Claude Sonnet
     └─ 任务：生成博客内容
  
  [competitor-analyzer]
  └─ 使用 Primary Model (Gemini)
     └─ 任务：分析竞品痛点
  
  [holiday-seeder]
  └─ 使用 Primary Model (Gemini)
     └─ 任务：生成假期列表

API调用统计：
  ├─ 每个网站分析：2次API调用（爬虫+分析）
  ├─ 每个主题生成：1次API调用
  ├─ 每个主题测试：2次API调用（查询+诊断）
  ├─ 每个博客生成：1次API调用
  ├─ 每个竞品分析：1次API调用
  └─ 假期同步：1次API调用
```

### 5. 数据库关系图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        数据库表关系                                       │
└─────────────────────────────────────────────────────────────────────────┘

websites (网站)
  ├─ 1:1 → website_analysis (网站分析)
  ├─ 1:N → topics (主题)
  ├─ 1:N → blogs (博客)
  └─ 1:N → site_content (网站内容)

website_analysis (网站分析)
  └─ N:1 ← websites

topics (主题)
  ├─ N:1 ← websites
  ├─ N:1 ← countries (可选)
  ├─ N:1 ← holidays (可选)
  ├─ 1:N → ai_test_results (AI测试结果)
  └─ 1:N → blogs (博客)

ai_test_results (AI测试结果)
  └─ N:1 ← topics

blogs (博客)
  ├─ N:1 ← topics
  └─ N:1 ← websites

competitors (竞品)
  └─ 1:N → pain_points (痛点)

pain_points (痛点)
  └─ N:1 ← competitors

countries (国家)
  ├─ 1:N → holidays (假期)
  └─ 1:N → topics (可选)

holidays (假期)
  ├─ N:1 ← countries
  └─ 1:N → topics (可选)

ai_audits (AI审计)
  └─ 独立表（记录所有AI查询）

aeo_articles (AEO文章)
  ├─ N:1 ← ai_audits (可选)
  └─ 1:N → aeo_tracking (追踪)

aeo_tracking (AEO追踪)
  └─ N:1 ← aeo_articles
```

### 6. 用户操作流程总结

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      用户操作完整流程                                     │
└─────────────────────────────────────────────────────────────────────────┘

新用户入门流程：

1. 添加网站
   Websites → Add Website → 输入URL + 选择国家 → 自动爬取分析

2. 生成主题
   Topics → 选择网站 → Generate Topics → 选择类型和国家 → 生成10个主题

3. 测试主题
   Topics → 点击Test → AI测试 → 查看诊断报告 → 主题状态更新

4. 生成博客
   Topics → 点击Write Blog (仅限approved) → 自动生成 → 查看博客

5. 竞品分析（可选）
   Competitors → Add Competitor → 自动分析 → 查看痛点库

6. 假期营销（可选）
   Holidays → Sync Holidays → 基于假期生成主题

7. 发布管理
   Blogs → 查看生成的博客 → 编辑 → 发布

高级用户流程：

1. 多网站管理
   ├─ 添加多个网站
   ├─ 为每个网站生成主题
   ├─ 批量测试主题
   └─ 批量生成博客

2. 竞品监控
   ├─ 添加多个竞品
   ├─ 定期分析竞品
   ├─ 追踪痛点变化
   └─ 基于痛点优化内容

3. AEO优化
   ├─ 查看AI审计结果
   ├─ 根据诊断改进内容
   ├─ 重新测试
   └─ 追踪发布后的推荐率

4. 国际化扩展
   ├─ 为不同国家生成主题
   ├─ 本地化内容
   ├─ 多语言发布
   └─ 追踪各国推荐率
```

