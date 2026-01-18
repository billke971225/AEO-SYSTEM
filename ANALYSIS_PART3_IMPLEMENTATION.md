# AI SEO 博客生成器 - 实现细节与数据流

## 第三部分：技术实现细节

### 1. 前端架构

#### 1.1 页面组件结构

```
src/pages/
├── Websites.tsx          # 网站管理
│   ├── 网站列表查询
│   ├── 添加网站表单
│   ├── 国家选择器
│   └── 重新分析按钮
│
├── Topics.tsx            # 主题管理
│   ├── 网站选择器
│   ├── 主题生成对话框
│   │   ├─ 国家多选
│   │   └─ 生成类型选择
│   ├── 主题列表（按状态分类）
│   ├── 测试按钮
│   └── 生成博客按钮
│
├── Blogs.tsx             # 博客管理
│   ├── 博客列表
│   ├── 状态过滤
│   └── 查看/编辑按钮
│
├── Competitors.tsx       # 竞品分析
│   ├── 竞品添加表单
│   ├── 竞品列表
│   └── 分析按钮
│
├── PainPoints.tsx        # 痛点库
│   ├── 痛点列表
│   ├── 分类过滤
│   ├── 严重度评分
│   └── 频率显示
│
├── Holidays.tsx          # 假期日历
│   ├── 假期列表
│   ├── 同步按钮
│   └── 礼物相关度评分
│
├── AEOArticles.tsx       # AEO文章库
│   ├── 文章列表
│   ├── 状态过滤
│   └── 事实密度评分
│
└── Settings.tsx          # 设置
    ├── AI模型选择
    └── API配置
```

#### 1.2 数据管理流程

```
React Component
    ↓
useQuery (TanStack React Query)
    ├─ 缓存管理
    ├─ 自动重新获取
    └─ 错误处理
    ↓
useBackend Hook
    ├─ callFunction()
    └─ 特定业务函数
    ↓
Supabase Client
    ├─ functions.invoke()
    └─ from().select()
    ↓
Supabase Backend
```

#### 1.3 useBackend Hook实现

```typescript
// src/hooks/useBackend.ts

export const useBackend = () => {
  const callFunction = async (functionName: string, body: Record<string, unknown>) => {
    // 调用Supabase Edge Function
    const { data, error } = await supabase.functions.invoke(functionName, { body });
    if (error) throw error;
    return data;
  };

  return {
    // 网站爬取
    crawlWebsite: (websiteId, url) => 
      callFunction("website-crawler", { website_id: websiteId, url }),
    
    // 网站分析
    analyzeWebsite: (websiteId) => 
      callFunction("ai-analyzer", { website_id: websiteId, model: primaryModel }),
    
    // 主题生成
    generateTopics: (websiteId, type, countries) => 
      callFunction("topic-generator", { 
        website_id: websiteId, 
        generation_type: type, 
        target_countries: countries, 
        model: primaryModel 
      }),
    
    // AI测试
    testTopic: (topicId) => 
      callFunction("ai-auditor", { topic_id: topicId, model: testerModel }),
    
    // 博客生成
    generateBlog: (topicId) => 
      callFunction("blog-generator", { topic_id: topicId, model: primaryModel }),
    
    // 竞品分析
    analyzeCompetitor: (competitorId) => 
      callFunction("competitor-analyzer", { competitor_id: competitorId, model: primaryModel }),
    
    // 假期同步
    seedHolidays: (year, countries) => 
      callFunction("holiday-seeder", { year, countries, model: primaryModel })
  };
};
```

### 2. Edge Functions详解

#### 2.1 website-crawler函数

**输入：**
```json
{
  "website_id": "uuid",
  "url": "https://example.com"
}
```

**处理流程：**

```
1. 更新网站状态为 "crawling"

2. 策略1：Shopify产品API
   ├─ 尝试 /products.json
   ├─ 解析产品列表
   └─ 提取产品信息

3. 策略2：HTML爬虫
   ├─ 使用Cheerio解析HTML
   ├─ 提取meta标签
   │  ├─ title
   │  ├─ description
   │  └─ keywords
   ├─ 提取body文本
   └─ 限制文本大小（10000字符）

4. 保存到数据库
   ├─ crawled_data (JSONB)
   │  ├─ products: []
   │  ├─ meta: {}
   │  └─ raw_text: ""
   └─ status: "crawled"
```

**关键代码：**

```typescript
// 策略1：Shopify API
const productsUrl = url.endsWith("/") ? `${url}products.json` : `${url}/products.json`;
const response = await fetch(productsUrl, {
  headers: { "User-Agent": "Mozilla/5.0..." }
});
if (response.ok) {
  const data = await response.json();
  crawledData.products = data.products || [];
}

// 策略2：HTML爬虫
const $ = cheerio.load(html);
crawledData.meta = {
  title: $("title").text() || "",
  description: $('meta[name="description"]').attr("content") || "",
  keywords: $('meta[name="keywords"]').attr("content") || ""
};
crawledData.raw_text = $('body').text().replace(/\s+/g, ' ').trim().substring(0, 10000);
```

#### 2.2 ai-analyzer函数

**输入：**
```json
{
  "website_id": "uuid",
  "model": "google/gemini-3-pro-preview"
}
```

**处理流程：**

```
1. 读取网站的crawled_data

2. 构建分析提示词
   ├─ 网站URL
   ├─ Meta信息
   ├─ 产品样本
   └─ 文本样本

3. 调用AI API
   ├─ 模型：Gemini/GPT
   ├─ 任务：分析网站
   └─ 输出格式：JSON

4. 解析AI响应
   ├─ 提取JSON
   ├─ 验证必需字段
   │  ├─ products
   │  ├─ target_scenarios
   │  ├─ target_audiences
   │  └─ key_selling_points
   └─ 处理错误

5. 保存到数据库
   ├─ website_analysis表
   └─ 更新网站状态为 "analyzed"
```

**AI提示词：**

```
You are an e-commerce expert. Analyze this website data and provide structured insights.

Website URL: ${website.url}
Meta Title: ${crawledData.meta?.title}
Meta Description: ${crawledData.meta?.description}

Products Sample (first 5):
${JSON.stringify(crawledData.products?.slice(0, 5))}

Raw Text Sample:
${crawledData.raw_text?.substring(0, 1000)}

Please provide a JSON response with:
1. products: Array of strings describing main product categories
2. target_scenarios: Array of strings for occasions
3. target_audiences: Array of strings for demographics
4. key_selling_points: Array of strings for USPs
5. competitor_insights: Array of strings for competitor types

IMPORTANT: Return ONLY valid JSON. No markdown formatting.
```

#### 2.3 topic-generator函数

**输入：**
```json
{
  "website_id": "uuid",
  "generation_type": "question_based" | "holiday_based",
  "target_countries": ["US", "UK", "JP"],
  "model": "google/gemini-3-pro-preview"
}
```

**处理流程：**

```
1. 读取website_analysis数据

2. 构建生成提示词
   ├─ 分析数据
   ├─ 生成类型
   ├─ 目标国家
   └─ 要求

3. 调用AI生成主题
   ├─ 生成10个主题
   ├─ 每个主题包含：
   │  ├─ title
   │  ├─ question
   │  ├─ target_scenario
   │  ├─ type
   │  └─ target_country
   └─ 输出格式：JSON数组

4. 解析和验证
   ├─ 提取JSON数组
   ├─ 验证数据完整性
   └─ 处理解析错误

5. 批量插入数据库
   ├─ topics表
   ├─ 状态：pending
   └─ 返回生成数量
```

**AI提示词示例：**

```
Based on the following website analysis, generate 10 unique blog topics.

Analysis:
${JSON.stringify(analysis)}

Generation Type: ${generation_type}
Target Countries: ${target_countries.join(", ")}

Requirements:
1. If type is "question_based", generate questions users would ask ChatGPT/Google.
2. If type is "holiday_based", connect products to upcoming holidays.
3. Focus on high intent and specific scenarios.

Output Format: JSON array of objects with fields: 
  title, question, target_scenario, type, target_country
```

#### 2.4 ai-auditor函数（AEO核心）

**输入：**
```json
{
  "topic_id": "uuid",
  "model": "openai/gpt-5.2-pro"
}
```

**处理流程：**

```
第一步：模拟用户查询
├─ 读取topic.question
├─ 直接发送给AI
└─ 获取完整响应

第二步：诊断分析
├─ 使用Gemini分析响应
├─ 检查品牌提及
├─ 检查竞品提及
├─ 分析缺失原因
└─ 生成改进方案

第三步：保存结果
├─ 插入ai_audits表
├─ 更新topics表
│  ├─ ai_test_score
│  └─ status (approved/pending)
└─ 返回诊断报告
```

**诊断提示词：**

```
You are an AEO expert. Analyze the AI's response to a user's question 
and determine why our brand was or wasn't recommended.

Our Brand: ${topic.websites.name}
Our URL: ${topic.websites.url}

Return a JSON object:
{
  "is_recommended": boolean,
  "mentioned_competitors": ["name1", "name2"],
  "missing_reason": "Why we were not mentioned",
  "action_plan": "Specific content strategy to get recommended"
}

User Question: ${topic.question}
AI Response: ${fullResponse}
```

#### 2.5 blog-generator函数

**输入：**
```json
{
  "topic_id": "uuid",
  "model": "anthropic/claude-sonnet-4.5"
}
```

**处理流程：**

```
1. 读取topic和website_analysis

2. 构建生成提示词
   ├─ 目标问题
   ├─ 产品信息
   ├─ 卖点
   └─ SEO要求

3. 调用Claude生成文章
   ├─ 模型：Claude Sonnet
   ├─ 字数：~1500字
   └─ 格式：Markdown

4. 保存到数据库
   ├─ blogs表
   ├─ 状态：draft
   ├─ 字数统计
   └─ SEO评分：85（占位符）
```

**生成提示词：**

```
Write a high-quality, SEO-optimized blog post for the following topic.

Topic: ${topic.title}
Target Question: "${topic.question}"
Target Audience: ${topic.target_scenario}
Target Country: ${topic.target_country}

Website Context:
Products: ${JSON.stringify(analysis?.products)}
Key Selling Points: ${JSON.stringify(analysis?.key_selling_points)}

Requirements:
1. Title (H1) optimized for the question.
2. Introduction with a "TL;DR" summary (bolded) for AI snippets.
3. H2 headings for main points.
4. Include a FAQ section with Schema.org friendly format.
5. Natural tone, helpful, not overly salesy.
6. Word count: ~1500 words.

Format: Markdown.
```

#### 2.6 competitor-analyzer函数

**输入：**
```json
{
  "competitor_id": "uuid",
  "model": "google/gemini-3-pro-preview"
}
```

**处理流程：**

```
1. 爬取竞品网站
   ├─ 提取推荐/评价
   ├─ 提取FAQ
   └─ 提取一般文本

2. AI分析痛点
   ├─ 分类痛点
   ├─ 评估严重度
   └─ 生成改进建议

3. 保存痛点
   ├─ pain_points表
   ├─ 分类：quality/payment/delivery/support/price/trust
   ├─ 严重度：1-5
   └─ 频率：出现次数

4. 更新竞品状态
   └─ status: "analyzed"
```

#### 2.7 holiday-seeder函数

**输入：**
```json
{
  "year": 2026,
  "countries": ["US", "UK", "JP", "KR"],
  "model": "google/gemini-3-pro-preview"
}
```

**处理流程：**

```
1. AI生成假期列表
   ├─ 官方假期
   ├─ 文化节日
   ├─ 购物节
   └─ 礼物相关度评分

2. 插入数据库
   ├─ countries表
   └─ holidays表

3. 关联主题生成
   └─ 支持holiday_based生成类型
```

### 3. 数据库查询优化

#### 3.1 关键查询

```sql
-- 查询网站及其分析
SELECT w.*, wa.products, wa.target_scenarios
FROM websites w
LEFT JOIN website_analysis wa ON w.id = wa.website_id
WHERE w.id = $1;

-- 查询主题及其测试结果
SELECT t.*, atr.ai_response, atr.mentions_our_site
FROM topics t
LEFT JOIN ai_test_results atr ON t.id = atr.topic_id
WHERE t.website_id = $1
ORDER BY t.created_at DESC;

-- 查询痛点（按严重度排序）
SELECT * FROM pain_points
WHERE competitor_id = $1
ORDER BY severity DESC, frequency DESC;

-- 查询假期（按日期排序）
SELECT h.*, c.code
FROM holidays h
JOIN countries c ON h.country_id = c.id
WHERE EXTRACT(YEAR FROM h.date) = $1
ORDER BY h.date ASC;
```

#### 3.2 索引优化

```sql
-- 已创建的索引
CREATE INDEX idx_pain_points_category ON pain_points(category);
CREATE INDEX idx_pain_points_severity ON pain_points(severity);
CREATE INDEX idx_ai_audits_country ON ai_audits(target_country);
CREATE INDEX idx_ai_audits_mentioned ON ai_audits(is_our_brand_mentioned);
CREATE INDEX idx_aeo_articles_status ON aeo_articles(status);
CREATE INDEX idx_aeo_tracking_article ON aeo_tracking(article_id);
CREATE INDEX idx_aeo_tracking_date ON aeo_tracking(test_date);

-- 建议添加的索引
CREATE INDEX idx_topics_website_status ON topics(website_id, status);
CREATE INDEX idx_blogs_website_status ON blogs(website_id, status);
CREATE INDEX idx_websites_status ON websites(status);
```

### 4. 错误处理与日志

#### 4.1 错误处理策略

```typescript
// Edge Function中的错误处理
try {
  // 业务逻辑
} catch (error) {
  console.error("Operation error:", error);
  return new Response(
    JSON.stringify({ 
      error: error.message || "Unknown error",
      details: error.stack 
    }),
    { 
      status: 500, 
      headers: { ...corsHeaders, "Content-Type": "application/json" } 
    }
  );
}

// 前端中的错误处理
const mutation = useMutation({
  mutationFn: async () => { /* ... */ },
  onError: (error) => {
    const errorMessage = error instanceof Error ? error.message : String(error);
    toast({
      title: "Error",
      description: errorMessage,
      variant: "destructive"
    });
  }
});
```

#### 4.2 日志记录

```typescript
// Edge Function中的日志
console.log(`Crawling ${url}...`);
console.log(`Found ${crawledData.products.length} products via JSON`);
console.log("AI response (first 300 chars):", content.substring(0, 300));
console.log("Analysis completed successfully");

// 前端中的日志
console.log("Blogs component rendering");
console.error("Supabase error fetching blogs:", error);
```

### 5. 性能优化

#### 5.1 缓存策略

```typescript
// React Query缓存配置
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5分钟
      gcTime: 1000 * 60 * 10,   // 10分钟
    },
  },
});
```

#### 5.2 批量操作

```typescript
// 批量插入主题
const topicsToInsert = topics.map(t => ({
  website_id,
  title: t.title,
  question: t.question,
  type: generation_type,
  target_scenario: t.target_scenario,
  target_country: t.target_country,
  status: "pending"
}));

const { error } = await supabase
  .from("topics")
  .insert(topicsToInsert);
```

#### 5.3 文本大小限制

```typescript
// 限制爬虫文本大小
crawledData.raw_text = $('body').text()
  .replace(/\s+/g, ' ')
  .trim()
  .substring(0, 10000); // 限制10000字符

// 限制AI响应处理
const content = aiData.content?.[0]?.text || "";
console.log("AI response (first 300 chars):", content.substring(0, 300));
```

