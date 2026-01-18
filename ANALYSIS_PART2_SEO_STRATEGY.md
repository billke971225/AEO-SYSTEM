# AI SEO 博客生成器 - SEO优化策略详解

## 第二部分：SEO优化与AEO策略

### 1. AEO（AI Engine Optimization）核心概念

AEO是针对AI搜索引擎（ChatGPT、Gemini、Perplexity等）的优化策略，与传统SEO不同：

| 维度 | 传统SEO | AEO |
|------|--------|-----|
| **目标** | 搜索排名 | AI推荐/提及 |
| **关键指标** | 排名位置、点击率 | 提及率、推荐位置 |
| **内容特点** | 关键词密度、反链 | 事实密度、唯一标识 |
| **优化方向** | 页面优化、链接建设 | 内容权威性、Schema标记 |
| **测试方式** | 工具检测 | 直接提问AI |

### 2. 系统的AEO优化流程

#### 2.1 主题生成的SEO策略

**问题生成算法：**

```
输入：
  - 产品信息（从website_analysis）
  - 目标受众
  - 目标国家
  - 生成类型（question_based / holiday_based）

处理流程：
  1. 产品-场景映射
     产品 → 使用场景 → 用户问题
     例：礼物 → 圣诞节 → "What are the best Christmas gifts for..."
  
  2. 国家-语言适配
     国家代码 → 语言 → 文化习惯 → 本地化问题
     例：JP → 日语习惯 → "ホワイトデーのギフトは..."
  
  3. 问题多样化
     生成10个不同角度的问题：
     - 产品特性问题
     - 使用场景问题
     - 对比问题
     - 推荐问题
     - 价格问题

输出：
  - 10个高意图问题
  - 每个问题关联目标场景
  - 每个问题关联目标国家
```

**代码实现：** `supabase/functions/topic-generator/index.ts`

```typescript
const prompt = `
  Based on the following website analysis, generate 10 unique blog topics.
  
  Analysis: ${JSON.stringify(analysis)}
  
  Generation Type: ${generation_type || "question_based"}
  Target Countries: ${target_countries?.join(", ") || "US, UK"}
  
  Requirements:
  1. If type is "question_based", generate questions users would ask ChatGPT/Google.
  2. If type is "holiday_based", connect products to upcoming holidays.
  3. Focus on high intent and specific scenarios.
  
  Output Format: JSON array of objects with fields: 
    title, question, target_scenario, type, target_country
`;
```

#### 2.2 AI测试与诊断（核心AEO逻辑）

**两阶段诊断模型：**

```
第一阶段：模拟用户查询
┌─────────────────────────────────────────┐
│ 直接将用户问题发送给AI                   │
│ 例：topic.question = "Best Christmas gifts for..."
│                                         │
│ AI返回：完整的推荐列表                   │
└─────────────────────────────────────────┘
                    ↓
第二阶段：诊断分析
┌─────────────────────────────────────────┐
│ 使用Gemini分析AI响应                     │
│                                         │
│ 检查项：                                 │
│ 1. is_our_brand_mentioned                │
│    ├─ 是否提到我们的品牌                 │
│    └─ 提到的位置（第几个推荐）           │
│                                         │
│ 2. is_competitor_mentioned               │
│    ├─ 提到了哪些竞品                     │
│    └─ 竞品的排名位置                     │
│                                         │
│ 3. missing_reason                        │
│    ├─ 为什么没有提到我们                 │
│    ├─ 缺乏事实密度                       │
│    ├─ 缺少Schema标记                     │
│    ├─ 内容权威性不足                     │
│    └─ 缺少唯一标识语                     │
│                                         │
│ 4. action_plan                           │
│    └─ 具体改进方案                       │
└─────────────────────────────────────────┘
```

**代码实现：** `supabase/functions/ai-auditor/index.ts`

```typescript
// 第一步：模拟用户查询
const aiResponse = await fetch("https://api.enter.pro/code/api/v1/ai/messages", {
  method: "POST",
  body: JSON.stringify({
    model: model,
    messages: [
      { role: "user", content: topic.question }
    ]
  })
});

// 第二步：诊断分析
const diagnosisResponse = await fetch("https://api.enter.pro/code/api/v1/ai/messages", {
  method: "POST",
  body: JSON.stringify({
    model: "google/gemini-3-pro-preview",
    messages: [
      {
        role: "system",
        content: `You are an AEO expert. Analyze why our brand was/wasn't recommended.
        
        Our Brand: ${topic.websites.name}
        Our URL: ${topic.websites.url}
        
        Return JSON: {
          "is_recommended": boolean,
          "mentioned_competitors": ["name1", "name2"],
          "missing_reason": "Why we were not mentioned",
          "action_plan": "Specific content strategy"
        }`
      },
      {
        role: "user",
        content: `User Question: ${topic.question}\n\nAI Response:\n${fullResponse}`
      }
    ]
  })
});
```

#### 2.3 博客内容的SEO优化

**内容结构优化：**

```
生成的博客文章结构：

1. H1标题（优化问题）
   ├─ 包含目标关键词
   ├─ 直接回答用户问题
   └─ 长度：50-60字符

2. 介绍段落 + TL;DR
   ├─ TL;DR加粗（便于AI摘要）
   ├─ 快速总结核心答案
   └─ 提高AI引用概率

3. H2小节（3-5个）
   ├─ 每个小节深入讨论一个方面
   ├─ 包含相关关键词
   └─ 自然融入产品推荐

4. FAQ部分（Schema.org格式）
   ├─ 常见问题
   ├─ 详细答案
   └─ JSON-LD标记

5. 产品推荐
   ├─ 自然融入内容
   ├─ 不过度销售
   └─ 提供真实价值
```

**代码实现：** `supabase/functions/blog-generator/index.ts`

```typescript
const prompt = `
  Write a high-quality, SEO-optimized blog post for the following topic.
  
  Topic: ${topic.title}
  Target Question: "${topic.question}"
  Target Audience: ${topic.target_scenario || "General"}
  Target Country: ${topic.target_country || "US"}
  
  Website Context:
  Products: ${JSON.stringify(analysis?.products)}
  Key Selling Points: ${JSON.stringify(analysis?.key_selling_points)}
  
  Requirements:
  1. Title (H1) optimized for the question.
  2. Introduction with a "TL;DR" summary (bolded) for AI snippets.
  3. H2 headings for main points.
  4. Include a FAQ section with Schema.org friendly format.
  5. Natural tone, helpful, not overly salesy but recommending our products.
  6. Word count: ~1500 words.
  
  Format: Markdown.
`;
```

### 3. 痛点库的竞争优势

**痛点提取流程：**

```
竞品网站 → 爬虫提取内容 → AI分析 → 痛点分类 → 痛点库

痛点分类维度：
├─ quality（质量）
│  └─ 产品质量问题、耐用性
├─ payment（支付）
│  └─ 支付方式、退款政策
├─ delivery（配送）
│  └─ 配送速度、运费、追踪
├─ support（客服）
│  └─ 响应速度、解决能力
├─ price（价格）
│  └─ 价格过高、无优惠
└─ trust（信任）
   └─ 品牌信誉、安全性

痛点评分：
├─ severity: 1-5（严重程度）
├─ frequency: 出现次数
└─ source: 来源（竞品网站、Reddit等）
```

**应用场景：**

1. **内容创作灵感**
   - 针对竞品痛点创作解决方案文章
   - 突出自身优势

2. **产品改进**
   - 识别市场需求
   - 优化产品特性

3. **营销文案**
   - 强调竞品缺陷
   - 突出自身优势

### 4. 假期营销策略

**假期-主题-内容的三层映射：**

```
假期库（holidays表）
  ├─ 名称：Christmas
  ├─ 日期：2026-12-25
  ├─ 国家：US, UK, DE
  ├─ 类型：gift-giving
  └─ 礼物相关度：9/10
        ↓
主题生成（holiday_based）
  ├─ 自动关联假期
  ├─ 生成假期相关问题
  │  └─ "Best Christmas gifts for..."
  ├─ 目标场景：holiday shopping
  └─ 目标国家：US, UK, DE
        ↓
博客内容
  ├─ 针对假期优化
  ├─ 时间敏感性强
  ├─ 高转化潜力
  └─ 自然融入产品推荐
```

**假期营销优势：**
- 时间敏感性强
- 用户搜索意图明确
- 转化率高
- 多国家覆盖

### 5. SEO评分系统

**博客SEO评分（seo_score字段）：**

```
评分维度（总分100）：

1. 内容质量（30分）
   ├─ 字数（1500字）
   ├─ 结构完整性
   └─ 信息深度

2. 关键词优化（20分）
   ├─ 标题关键词
   ├─ 小节关键词
   └─ 自然分布

3. 技术SEO（20分）
   ├─ Meta描述
   ├─ Schema标记
   └─ 内部链接

4. 用户体验（15分）
   ├─ 可读性
   ├─ 段落长度
   └─ 列表使用

5. AEO优化（15分）
   ├─ 事实密度
   ├─ 唯一标识语
   └─ AI友好格式

当前实现：固定85分（占位符）
```

### 6. 事实密度与唯一标识语

**事实密度（Fact Density）：**

```
定义：文章中包含的具体、可验证的信息比例

高事实密度示例：
"According to a 2024 survey by XYZ Institute, 78% of customers 
prefer eco-friendly packaging, with an average willingness to 
pay 15% premium."

低事实密度示例：
"Many customers like eco-friendly products."

AEO优化：
- 包含具体数据和统计
- 引用权威来源
- 提供可验证的信息
- 增加AI引用概率
```

**唯一标识语（Unique Identifiers）：**

```
定义：品牌或产品的独特表述方式

示例：
- 品牌标语
- 产品特有功能描述
- 创始人故事
- 独特的价值主张

AEO优化：
- 在文章中自然融入
- 增加品牌识别度
- 提高AI提及概率
- 建立品牌差异化
```

### 7. Schema.org标记优化

**FAQ Schema示例：**

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What are the best Christmas gifts for tech lovers?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Tech lovers typically appreciate innovative gadgets..."
      }
    }
  ]
}
```

**优化效果：**
- 提高AI理解
- 增加特色片段机会
- 改善搜索可见性

### 8. 多国家/多语言SEO策略

**国家适配流程：**

```
选择目标国家（target_countries）
        ↓
为每个国家生成本地化主题
  ├─ 语言适配
  ├─ 文化习惯
  ├─ 本地假期
  └─ 本地竞品
        ↓
生成国家特定的博客
  ├─ 语言：本地语言
  ├─ 货币：本地货币
  ├─ 假期：本地假期
  └─ 参考：本地竞品
        ↓
AEO测试
  ├─ 使用本地AI模型
  ├─ 模拟本地用户查询
  └─ 测试本地推荐率
```

**支持的国家：**
- 北美：US, CA
- 欧洲：UK, DE, FR, IT, ES, NL, SE, CH, NO, DK, FI, IE, BE, AT
- 亚太：JP, KR, SG, AU, NZ
- 中东：IL

