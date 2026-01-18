# 市场扩展和需求发现策略

## 概述

基于现有AI SEO系统，设计一个**市场扩展和需求发现模块**，帮助发现新的目标客户、探索未开发的使用场景，并布局竞争对手没有涉及的领域。

## 核心理念

### 从"基于现有"到"探索未知"

```
当前模式：
网站分析 → 现有产品 → 现有场景 → 生成主题

扩展模式：
网站分析 → 产品潜力 → 场景扩展 → 需求发现 → 竞争空白 → 新主题
```

---

## 功能设计

### 1. 场景扩展引擎

#### 1.1 多维度场景映射

```
产品：祝福视频
├─ 当前场景：生日祝福
└─ 扩展场景：
   ├─ 情感表达：表白、求婚、道歉、感谢
   ├─ 娱乐互动：整蛊、恶作剧、惊喜
   ├─ 商务场景：企业祝福、团队激励
   ├─ 教育场景：毕业祝福、升学鼓励
   ├─ 健康关怀：康复祝福、减肥鼓励
   └─ 节日营销：各国特色节日

产品：环保礼品
├─ 当前场景：圣诞礼物
└─ 扩展场景：
   ├─ 企业场景：员工福利、客户答谢
   ├─ 教育场景：环保教育、学校奖品
   ├─ 社交场景：聚会礼品、邻里关系
   ├─ 健康场景：健身奖励、戒烟礼品
   └─ 投资场景：ESG投资、绿色理财
```

#### 1.2 AI驱动的场景发现

**新增Edge Function: `scenario-expander`**

```typescript
// 输入：现有产品和场景
{
  "website_id": "uuid",
  "products": ["祝福视频", "个性化卡片"],
  "current_scenarios": ["生日", "节日祝福"],
  "expansion_type": "creative" | "market_research" | "competitor_gap"
}

// AI提示词：
"Based on these products and current use cases, discover 20 new potential scenarios where these products could be valuable. Think creatively about:

1. Emotional moments (celebrations, milestones, relationships)
2. Business applications (marketing, HR, customer service)  
3. Educational uses (learning, motivation, recognition)
4. Health & wellness (recovery, motivation, mental health)
5. Social situations (community, networking, cultural events)
6. Seasonal opportunities (holidays, weather, cultural seasons)

For each scenario, provide:
- scenario_name: Clear name
- target_audience: Who would use this
- use_case: Specific application
- market_size: estimated demand (1-10)
- competition_level: how crowded (1-10)
- cultural_relevance: which countries/cultures"

// 输出：20个新场景
[
  {
    "scenario_name": "求婚视频",
    "target_audience": "准备求婚的男女",
    "use_case": "制作浪漫的求婚视频，增加成功率",
    "market_size": 8,
    "competition_level": 3,
    "cultural_relevance": ["US", "UK", "JP", "KR"]
  },
  {
    "scenario_name": "企业年会祝福",
    "target_audience": "HR经理、活动策划",
    "use_case": "为员工制作个性化年会祝福视频",
    "market_size": 7,
    "competition_level": 2,
    "cultural_relevance": ["US", "UK", "DE", "JP"]
  }
]
```

### 2. 节假日营销引擎

#### 2.1 全球节假日数据库扩展

**增强 `holiday-seeder` 功能：**

```typescript
// 当前：只有主要节假日
// 扩展：包含所有可能的营销机会

const expandedHolidayPrompt = `
Generate a comprehensive list of marketing opportunities for ${year} in ${countries}:

1. **官方节假日**: Christmas, New Year, National Days
2. **文化节日**: Valentine's Day, Mother's Day, Father's Day
3. **宗教节日**: Easter, Diwali, Chinese New Year, Ramadan
4. **商业节日**: Black Friday, Singles Day, Prime Day
5. **季节性机会**: Back to School, Summer Vacation, Winter Sports
6. **生活里程碑**: Graduation Season, Wedding Season, Tax Season
7. **健康意识日**: World Health Day, Mental Health Awareness
8. **环保意识日**: Earth Day, World Environment Day
9. **职业相关日**: Teacher's Day, Nurse's Day, Boss's Day
10. **特殊群体节日**: Children's Day, Senior Citizens Day

For each opportunity, include:
- name: Event name
- date: Specific date or date range
- country_code: Target country
- category: Type of opportunity
- gift_relevance: 1-10 score
- target_demographics: Who celebrates
- marketing_angle: How to position products
- competition_intensity: 1-10 how competitive
- cultural_sensitivity: Any cultural considerations
`;
```

#### 2.2 节假日主题自动生成

**新增功能：基于节假日自动生成营销主题**

```
每月自动执行：
1. 扫描未来3个月的节假日
2. 为每个节假日生成5-10个营销主题
3. 自动测试AI推荐率
4. 优先推荐高潜力、低竞争的主题

示例输出：
┌─────────────────────────────────────────────────────────────┐
│ 2026年3月营销机会                                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ 🌸 White Day (3月14日) - 日本/韩国                          │
│ ├─ "Best White Day gifts for girlfriend in Japan"          │
│ ├─ "White Day vs Valentine's Day gift ideas"               │
│ └─ "Korean White Day traditions and gifts"                 │
│                                                             │
│ 🍀 St. Patrick's Day (3月17日) - 美国/爱尔兰               │
│ ├─ "Green gifts for St. Patrick's Day"                     │
│ ├─ "Irish-themed party supplies and decorations"           │
│ └─ "Eco-friendly St. Patrick's Day celebrations"           │
│                                                             │
│ 🌱 Spring Equinox (3月20日) - 全球                         │
│ ├─ "Spring cleaning eco-friendly products"                 │
│ ├─ "New beginnings gifts for spring"                       │
│ └─ "Gardening gifts for spring enthusiasts"                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 3. 竞争空白发现引擎

#### 3.1 竞争对手内容分析

**新增Edge Function: `competitor-gap-analyzer`**

```typescript
// 分析竞争对手没有布局的领域
const gapAnalysisPrompt = `
Analyze the competitive landscape for these products: ${products}

Based on competitor analysis data:
${competitorData}

Identify content gaps and opportunities:

1. **未覆盖的使用场景**: What use cases are competitors not addressing?
2. **未服务的人群**: What demographics are underserved?
3. **未开发的关键词**: What search terms have low competition?
4. **未利用的节假日**: What holidays/events are competitors ignoring?
5. **未进入的地理市场**: What countries/regions are underserved?
6. **未解决的痛点**: What customer problems are not being addressed?

For each gap, provide:
- opportunity_type: Type of gap
- description: What's missing
- target_keywords: Potential search terms
- estimated_traffic: Search volume potential
- competition_level: How competitive (1-10)
- implementation_difficulty: How hard to execute (1-10)
- roi_potential: Expected return (1-10)
`;

// 输出示例：
[
  {
    "opportunity_type": "未覆盖场景",
    "description": "求婚视频制作服务",
    "target_keywords": ["proposal video", "marriage proposal ideas", "romantic video"],
    "estimated_traffic": 15000,
    "competition_level": 2,
    "implementation_difficulty": 4,
    "roi_potential": 9
  },
  {
    "opportunity_type": "未服务人群", 
    "description": "企业HR部门的员工激励视频",
    "target_keywords": ["employee motivation video", "corporate recognition", "HR video tools"],
    "estimated_traffic": 8000,
    "competition_level": 1,
    "implementation_difficulty": 3,
    "roi_potential": 8
  }
]
```

### 4. 需求验证系统

#### 4.1 多渠道需求验证

```
发现新场景后，通过多种方式验证需求：

1. **AI测试验证**
   ├─ 生成相关问题
   ├─ 测试AI推荐率
   └─ 分析搜索意图

2. **搜索趋势分析**
   ├─ Google Trends数据
   ├─ 关键词搜索量
   └─ 季节性趋势

3. **社交媒体监听**
   ├─ Reddit讨论热度
   ├─ Twitter话题趋势
   └─ TikTok内容分析

4. **竞争对手监控**
   ├─ 竞品新增内容
   ├─ 广告投放情况
   └─ 用户评论分析
```

#### 4.2 需求评分系统

```
每个新发现的场景都会获得综合评分：

需求评分 = (
  搜索量 × 0.3 +
  AI推荐潜力 × 0.25 +
  竞争强度(反向) × 0.2 +
  实施难度(反向) × 0.15 +
  文化适配度 × 0.1
) × 100

评分结果：
├─ 90-100分：立即执行
├─ 80-89分：优先考虑
├─ 70-79分：中期规划
├─ 60-69分：长期观察
└─ <60分：暂不考虑
```

---

## 实施方案

### 阶段1：场景扩展引擎

**新增数据库表：**

```sql
-- 场景扩展表
CREATE TABLE scenario_expansions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  website_id UUID REFERENCES websites(id),
  scenario_name TEXT NOT NULL,
  target_audience TEXT,
  use_case TEXT,
  market_size INTEGER, -- 1-10
  competition_level INTEGER, -- 1-10
  cultural_relevance TEXT[], -- 国家代码数组
  status TEXT DEFAULT 'discovered', -- discovered, validated, implemented
  created_at TIMESTAMP DEFAULT NOW()
);

-- 机会评分表
CREATE TABLE market_opportunities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  website_id UUID REFERENCES websites(id),
  opportunity_type TEXT, -- scenario, holiday, gap, demographic
  description TEXT,
  target_keywords TEXT[],
  estimated_traffic INTEGER,
  competition_level INTEGER,
  roi_potential INTEGER,
  validation_score INTEGER, -- 综合评分
  status TEXT DEFAULT 'pending', -- pending, testing, validated, implemented
  created_at TIMESTAMP DEFAULT NOW()
);
```

**新增Edge Functions：**

```
supabase/functions/
├─ scenario-expander/     # 场景扩展
├─ holiday-opportunity/   # 节假日机会发现
├─ competitor-gap/        # 竞争空白分析
├─ demand-validator/      # 需求验证
└─ opportunity-scorer/    # 机会评分
```

### 阶段2：前端界面扩展

**新增页面：Market Expansion**

```typescript
// src/pages/MarketExpansion.tsx
const MarketExpansion = () => {
  return (
    <div className="space-y-6">
      <Tabs defaultValue="scenarios">
        <TabsList>
          <TabsTrigger value="scenarios">场景扩展</TabsTrigger>
          <TabsTrigger value="holidays">节假日机会</TabsTrigger>
          <TabsTrigger value="gaps">竞争空白</TabsTrigger>
          <TabsTrigger value="opportunities">机会评分</TabsTrigger>
        </TabsList>
        
        <TabsContent value="scenarios">
          <ScenarioExpansion />
        </TabsContent>
        
        <TabsContent value="holidays">
          <HolidayOpportunities />
        </TabsContent>
        
        <TabsContent value="gaps">
          <CompetitorGaps />
        </TabsContent>
        
        <TabsContent value="opportunities">
          <OpportunityScoring />
        </TabsContent>
      </Tabs>
    </div>
  );
};
```

### 阶段3：自动化工作流

**每月自动执行：**

```
1. 场景扩展分析
   ├─ 基于网站更新发现新场景
   ├─ 分析用户行为数据
   └─ 生成扩展建议

2. 节假日机会扫描
   ├─ 扫描未来3个月节假日
   ├─ 生成营销主题
   └─ 自动AI测试

3. 竞争空白监控
   ├─ 分析竞品新内容
   ├─ 发现内容空白
   └─ 评估机会价值

4. 需求验证更新
   ├─ 更新搜索趋势数据
   ├─ 重新评分机会
   └─ 推荐优先级调整
```

---

## 使用场景示例

### 场景1：祝福视频服务扩展

```
当前状态：
├─ 产品：个性化祝福视频
├─ 主要场景：生日祝福
└─ 目标客户：个人用户

系统分析后发现：
├─ 🆕 求婚场景：市场大，竞争少
├─ 🆕 企业年会：B2B市场，利润高
├─ 🆕 道歉视频：情感需求，独特定位
└─ 🆕 宠物纪念：细分市场，忠诚度高

生成新主题：
├─ "Best proposal video ideas for 2026"
├─ "Corporate year-end celebration videos"
├─ "How to make an apology video that works"
└─ "Pet memorial videos for grieving owners"

AI测试结果：
├─ 求婚视频：推荐率85% ✅
├─ 企业年会：推荐率72% ✅
├─ 道歉视频：推荐率45% ❌
└─ 宠物纪念：推荐率91% ✅

优先执行：宠物纪念 > 求婚视频 > 企业年会
```

### 场景2：节假日主动营销

```
系统发现：
├─ 3月14日：White Day (日本/韩国)
├─ 3月17日：St. Patrick's Day (美国/爱尔兰)
├─ 3月20日：Spring Equinox (全球)
└─ 3月31日：Easter Sunday (西方国家)

自动生成主题：
├─ "White Day gifts that Japanese women actually want"
├─ "Green and eco-friendly St. Patrick's Day party ideas"
├─ "Spring cleaning with sustainable products"
└─ "Easter gifts for environmentally conscious families"

提前2个月开始：
├─ 1月：生成主题，AI测试
├─ 2月：优化内容，发布博客
├─ 3月：节假日期间，流量高峰
└─ 4月：分析效果，总结经验
```

### 场景3：竞争空白布局

```
竞争对手分析发现：
├─ 竞品A：专注圣诞节，忽略其他节日
├─ 竞品B：只做个人市场，没有B2B
├─ 竞品C：英语市场，没有亚洲本地化
└─ 竞品D：传统营销，没有AI优化

我们的机会：
├─ 🎯 亚洲节日营销（White Day, 中秋节）
├─ 🎯 B2B企业市场（年会、团建、培训）
├─ 🎯 多语言本地化（日语、韩语内容）
└─ 🎯 AI驱动个性化（智能推荐、自动生成）

执行策略：
├─ 优先布局：亚洲节日（竞争最少）
├─ 中期发展：B2B市场（利润最高）
├─ 长期规划：多语言（壁垒最强）
└─ 持续优势：AI技术（差异化最大）
```

---

## 预期效果

### 量化指标

```
市场扩展效果：
├─ 目标客户群体：扩大200%
├─ 可服务场景：增加300%
├─ 内容主题数量：增加500%
├─ 搜索流量：提升150%
├─ 转化率：提升80%
└─ 竞争优势：建立护城河

节假日营销效果：
├─ 全年营销机会：从12个增加到50+个
├─ 季节性流量峰值：提升300%
├─ 品牌曝光度：增加400%
├─ 客户获取成本：降低40%
└─ 客户生命周期价值：提升120%
```

### 定性优势

```
战略优势：
├─ 🏆 先发优势：抢占竞争对手未布局的领域
├─ 🎯 精准定位：发现真实存在但未被满足的需求
├─ 🌍 全球化：利用各国文化差异创造机会
├─ 🤖 AI驱动：用技术优势建立竞争壁垒
└─ 📈 可持续：建立持续发现新机会的能力
```

---

## 总结

这个市场扩展策略将帮助系统：

1. **突破现有局限**：从基于现有产品到探索未知需求
2. **发现新机会**：场景扩展、节假日营销、竞争空白
3. **验证需求真实性**：多维度验证，避免盲目投入
4. **建立竞争优势**：抢占竞争对手未布局的领域
5. **实现可持续增长**：建立持续发现新机会的能力

这不仅是一个SEO工具的升级，更是一个**市场机会发现和验证平台**！