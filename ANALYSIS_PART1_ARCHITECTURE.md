# AI SEO 博客生成器 - 完整技术分析

## 第一部分：系统架构与工作流程

### 1. 项目概述

这是一个**AI驱动的SEO博客生成系统**，专门针对**AEO（AI Engine Optimization）**优化。系统通过以下核心流程实现：

1. **网站爬取与分析** → 2. **主题生成** → 3. **AI测试与诊断** → 4. **博客内容生成** → 5. **AEO追踪**

### 2. 技术栈

**前端：**
- React 19.1.1 + TypeScript
- Vite 7.1.4（构建工具）
- React Router 7.8.2（路由）
- TanStack React Query 5.86.0（数据管理）
- Tailwind CSS 3.4.17（样式）
- Shadcn/ui（UI组件库）
- i18next（国际化）

**后端：**
- Supabase（数据库 + Edge Functions）
- PostgreSQL（数据存储）
- Deno（Edge Functions运行时）
- 外部AI API（Google Gemini, OpenAI GPT, Anthropic Claude）

**数据库：**
- PostgreSQL with pgvector（向量搜索）
- 11个核心表 + 5个AEO专用表

### 3. 核心数据流架构

```
┌─────────────────────────────────────────────────────────────────┐
│                    用户界面层 (React)                            │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐       │
│  │Websites  │Topics    │Blogs     │Competitors│PainPoints│       │
│  │页面      │页面      │页面      │页面      │页面      │       │
│  └──────────┴──────────┴──────────┴──────────┴──────────┘       │
└─────────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│                  API层 (useBackend Hook)                         │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ callFunction() → Supabase.functions.invoke()            │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│              Supabase Edge Functions (Deno)                      │
│  ┌──────────────┬──────────────┬──────────────┐                 │
│  │website-      │ai-analyzer   │topic-        │                 │
│  │crawler       │              │generator     │                 │
│  ├──────────────┼──────────────┼──────────────┤                 │
│  │blog-         │ai-auditor    │competitor-   │                 │
│  │generator     │              │analyzer      │                 │
│  ├──────────────┼──────────────┼──────────────┤                 │
│  │holiday-      │chatgpt-      │              │                 │
│  │seeder        │tester        │              │                 │
│  └──────────────┴──────────────┴──────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────────┐
│              外部服务集成                                        │
│  ┌──────────────┬──────────────┬──────────────┐                 │
│  │AI API        │网站爬虫      │数据库        │                 │
│  │(Gemini/GPT)  │(Cheerio)     │(PostgreSQL)  │                 │
│  └──────────────┴──────────────┴──────────────┘                 │
└─────────────────────────────────────────────────────────────────┘
```

### 4. 数据库表结构

#### 核心表（11个）

| 表名 | 用途 | 关键字段 |
|------|------|--------|
| **websites** | 目标网站管理 | id, url, name, crawled_data, status, target_countries |
| **website_analysis** | 网站分析结果 | id, website_id, products, target_scenarios, target_audiences, key_selling_points |
| **topics** | 博客主题 | id, website_id, title, question, type, status, ai_test_score |
| **blogs** | 生成的博客 | id, topic_id, website_id, title, content, status, seo_score |
| **ai_test_results** | AI测试结果 | id, topic_id, ai_response, mentions_our_site, mentions_competitors |
| **competitors** | 竞争对手 | id, name, url, status, crawled_data |
| **pain_points** | 竞品痛点库 | id, competitor_id, content, category, severity, frequency |
| **countries** | 国家/地区 | id, code, name, is_target_market |
| **holidays** | 假期日历 | id, country_id, name, date, gift_relevance_score |
| **site_content** | 网站内容向量 | id, url, content, embedding(768维) |
| **simulated_queries** | 模拟查询 | id, query_text, ai_response, is_recommended |

#### AEO专用表（5个）

| 表名 | 用途 | 关键字段 |
|------|------|--------|
| **ai_audits** | AI审计记录 | id, query, target_country, ai_model, ai_response, is_our_brand_mentioned, diagnosis |
| **aeo_articles** | AEO优化文章 | id, title, content, target_query_id, target_pain_points, fact_density_score |
| **aeo_tracking** | AEO追踪监测 | id, article_id, query, ai_model, is_mentioned, mention_position |
| **geo_blogs** | 地理位置博客 | id, title, content, target_query, status |
| **site_content** | 内容向量存储 | id, url, content, embedding |

### 5. 工作流程详解

#### 流程1：网站爬取与分析

```
用户输入网站URL + 选择目标国家
        ↓
[website-crawler] Edge Function
  ├─ 尝试获取 /products.json (Shopify)
  ├─ 爬取首页HTML (Cheerio)
  ├─ 提取meta信息、产品列表、文本内容
  └─ 保存到 websites.crawled_data
        ↓
[ai-analyzer] Edge Function
  ├─ 读取 crawled_data
  ├─ 调用AI API (Gemini/GPT)
  ├─ 提示词：分析产品、目标场景、目标受众、卖点
  ├─ 解析JSON响应
  └─ 保存到 website_analysis 表
        ↓
网站状态更新为 "analyzed"
```

**关键代码位置：**
- 爬虫：`supabase/functions/website-crawler/index.ts`
- 分析：`supabase/functions/ai-analyzer/index.ts`

#### 流程2：主题生成（SEO策略核心）

```
用户选择网站 + 生成类型 + 目标国家
        ↓
[topic-generator] Edge Function
  ├─ 读取 website_analysis 数据
  ├─ 根据生成类型：
  │  ├─ question_based: 生成用户会问的问题
  │  └─ holiday_based: 基于假期生成主题
  ├─ 调用AI API生成10个主题
  ├─ 每个主题包含：
  │  ├─ title: 博客标题
  │  ├─ question: 目标问题
  │  ├─ target_scenario: 使用场景
  │  ├─ target_country: 目标国家
  │  └─ type: 生成类型
  └─ 批量插入 topics 表，状态为 "pending"
        ↓
用户在Topics页面查看生成的主题
```

**SEO策略：**
- 针对不同国家的搜索习惯生成问题
- 结合产品特性和目标受众
- 支持假期营销主题

#### 流程3：AI测试与诊断（AEO核心）

```
用户点击"测试"按钮
        ↓
[ai-auditor] Edge Function
  ├─ 第一步：模拟用户查询
  │  └─ 直接将 topic.question 发送给AI
  │
  ├─ 第二步：诊断分析
  │  ├─ 调用Gemini分析AI响应
  │  ├─ 检查是否提到我们的品牌
  │  ├─ 检查提到的竞品
  │  ├─ 分析未被推荐的原因
  │  └─ 生成改进方案
  │
  ├─ 第三步：保存审计结果
  │  ├─ 插入 ai_audits 表
  │  ├─ 更新 topics 表的 ai_test_score
  │  └─ 根据结果更新 status (approved/pending)
  │
  └─ 返回诊断报告
        ↓
主题状态更新：
  ├─ 如果被推荐 → status = "approved", score = 10
  └─ 如果未被推荐 → status = "pending", score = 3
```

**诊断逻辑：**
- 检查品牌提及率
- 分析竞品提及
- 识别缺失原因（缺乏事实密度、缺少Schema等）
- 生成改进方案

#### 流程4：博客内容生成

```
用户点击"生成博客"（仅限approved主题）
        ↓
[blog-generator] Edge Function
  ├─ 读取 topic 和 website_analysis
  ├─ 构建提示词：
  │  ├─ 目标问题
  │  ├─ 产品信息
  │  ├─ 卖点
  │  └─ SEO要求
  ├─ 调用Claude生成1500字文章
  ├─ 文章结构：
  │  ├─ H1标题（优化问题）
  │  ├─ 介绍 + TL;DR（AI摘要）
  │  ├─ H2小节
  │  ├─ FAQ部分（Schema.org格式）
  │  └─ 自然推荐产品
  └─ 保存到 blogs 表，状态为 "draft"
        ↓
用户在Blogs页面查看生成的文章
```

**SEO优化点：**
- TL;DR加粗便于AI摘要
- FAQ部分支持Schema.org
- 自然融入产品推荐
- 针对目标国家的语言和文化

#### 流程5：竞品分析与痛点提取

```
用户添加竞品URL
        ↓
[competitor-analyzer] Edge Function
  ├─ 爬取竞品网站
  ├─ 提取关键内容：
  │  ├─ 用户评价/推荐
  │  ├─ FAQ部分
  │  └─ 一般文本
  ├─ 调用AI分析痛点
  ├─ 提取痛点分类：
  │  ├─ quality（质量）
  │  ├─ payment（支付）
  │  ├─ delivery（配送）
  │  ├─ support（客服）
  │  ├─ price（价格）
  │  └─ trust（信任）
  └─ 保存到 pain_points 表
        ↓
用户在PainPoints页面查看痛点库
```

**痛点评分：**
- severity: 1-5（严重程度）
- frequency: 出现次数
- category: 痛点分类

#### 流程6：假期营销主题生成

```
用户点击"同步假期"
        ↓
[holiday-seeder] Edge Function
  ├─ 调用AI生成目标国家的假期列表
  ├─ 包含信息：
  │  ├─ 假期名称
  │  ├─ 日期
  │  ├─ 国家代码
  │  ├─ 假期类型
  │  └─ 礼物相关度评分(1-10)
  ├─ 插入 countries 表
  └─ 插入 holidays 表
        ↓
基于假期生成主题
  ├─ 在topic-generator中选择 "holiday_based"
  ├─ 系统自动关联假期
  └─ 生成假期相关的营销主题
```

### 6. 页面功能映射

| 页面 | 功能 | 关键操作 |
|------|------|--------|
| **Websites** | 网站管理 | 添加网站、选择目标国家、爬取分析 |
| **Topics** | 主题管理 | 生成主题、测试主题、查看诊断 |
| **Blogs** | 博客管理 | 查看生成的博客、编辑、发布 |
| **Competitors** | 竞品分析 | 添加竞品、爬取分析、提取痛点 |
| **PainPoints** | 痛点库 | 按分类查看痛点、严重度评分 |
| **Holidays** | 假期日历 | 同步假期、查看营销机会 |
| **AEOArticles** | AEO文章库 | 查看优化文章、发布追踪 |
| **Settings** | 设置 | AI模型选择、API配置 |

