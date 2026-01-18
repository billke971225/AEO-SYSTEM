# AI SEO 博客生成器 - 可视化工作流程指南

## 快速参考指南

### 用户界面导航

```
┌─────────────────────────────────────────────────────────────────┐
│                    应用导航菜单                                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🏠 Home (首页)                                                  │
│  ├─ 项目概览                                                     │
│  └─ 快速开始指南                                                 │
│                                                                 │
│  🌐 Websites (网站管理)                                          │
│  ├─ 添加网站                                                     │
│  ├─ 选择目标国家                                                 │
│  ├─ 查看爬取状态                                                 │
│  └─ 重新分析                                                     │
│                                                                 │
│  📝 Topics (主题管理)                                            │
│  ├─ 选择网站                                                     │
│  ├─ 生成主题                                                     │
│  │  ├─ 选择生成类型                                              │
│  │  └─ 选择目标国家                                              │
│  ├─ 查看主题列表                                                 │
│  ├─ 测试主题                                                     │
│  └─ 生成博客                                                     │
│                                                                 │
│  📄 Blogs (博客管理)                                             │
│  ├─ 查看生成的博客                                               │
│  ├─ 编辑博客                                                     │
│  └─ 发布博客                                                     │
│                                                                 │
│  🎯 Competitors (竞品分析)                                       │
│  ├─ 添加竞品                                                     │
│  ├─ 查看竞品状态                                                 │
│  └─ 分析竞品                                                     │
│                                                                 │
│  💔 Pain Points (痛点库)                                         │
│  ├─ 查看所有痛点                                                 │
│  ├─ 按分类过滤                                                   │
│  ├─ 按严重度排序                                                 │
│  └─ 用于内容创作                                                 │
│                                                                 │
│  🎄 Holidays (假期日历)                                          │
│  ├─ 同步假期                                                     │
│  ├─ 查看假期列表                                                 │
│  └─ 基于假期生成主题                                             │
│                                                                 │
│  ✨ AEO Articles (AEO文章库)                                     │
│  ├─ 查看优化文章                                                 │
│  ├─ 追踪AI推荐率                                                 │
│  └─ 查看事实密度评分                                             │
│                                                                 │
│  ⚙️ Settings (设置)                                              │
│  ├─ 选择AI模型                                                   │
│  └─ 配置API                                                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 状态指示器

```
网站状态：
  ⚪ pending    - 待处理
  🔄 crawling   - 爬取中
  ✅ crawled    - 已爬取
  ✨ analyzed   - 已分析

主题状态：
  ⚪ pending    - 待测试
  ✅ approved   - 已批准（可生成博客）
  ❌ rejected   - 已拒绝（需优化）

博客状态：
  📝 draft      - 草稿
  ✏️ ready      - 待发布
  📤 published  - 已发布

竞品状态：
  ⚪ pending    - 待分析
  🔄 crawling   - 爬取中
  ✅ crawled    - 已爬取
  ✨ analyzed   - 已分析
```

### 颜色编码

```
绿色 (default)    - 成功、已批准、已完成
蓝色 (secondary)  - 进行中、待处理
红色 (destructive)- 失败、已拒绝、错误
灰色 (outline)    - 未开始、禁用
```

## 操作流程详解

### 流程1：从零开始创建博客

```
步骤1：添加网站
┌─────────────────────────────────────────┐
│ Websites页面                             │
├─────────────────────────────────────────┤
│ 输入网站URL：https://example.com        │
│ 选择目标国家：                           │
│   ☑ United States                       │
│   ☑ United Kingdom                      │
│   ☑ Japan                               │
│   ☑ South Korea                         │
│ [Add Website]                           │
└─────────────────────────────────────────┘
         ↓
系统自动：
  1. 爬取网站
  2. 分析产品和受众
  3. 更新状态为 "analyzed"
         ↓
步骤2：生成主题
┌─────────────────────────────────────────┐
│ Topics页面                               │
├─────────────────────────────────────────┤
│ 选择网站：example.com                    │
│ [Generate Topics]                       │
│                                         │
│ 配置对话框：                             │
│ 生成类型：                               │
│   ◉ Question Based                      │
│   ○ Holiday Based                       │
│                                         │
│ 目标国家：                               │
│   ☑ United States                       │
│   ☑ United Kingdom                      │
│   ☑ Japan                               │
│   ☑ South Korea                         │
│                                         │
│ [Start Generating]                      │
└─────────────────────────────────────────┘
         ↓
系统生成10个主题：
  1. "Best Christmas Gifts for Tech Lovers"
  2. "How to Choose Eco-Friendly Gifts"
  3. "Budget-Friendly Gift Ideas"
  ... (7 more)
         ↓
步骤3：测试主题
┌─────────────────────────────────────────┐
│ Topics页面 - Pending标签                 │
├─────────────────────────────────────────┤
│ 主题卡片：                               │
│ "Best Christmas Gifts for Tech Lovers"  │
│ 问题："What are the best Christmas..."  │
│ 状态：Pending                            │
│ [Test]                                  │
└─────────────────────────────────────────┘
         ↓
系统执行AI测试：
  1. 模拟用户查询
  2. 获取AI响应
  3. 诊断分析
  4. 生成改进方案
         ↓
结果：
  ✅ 推荐 → 状态变为 "Approved"
  ❌ 未推荐 → 状态保持 "Pending"
         ↓
步骤4：生成博客
┌─────────────────────────────────────────┐
│ Topics页面 - Approved标签                │
├─────────────────────────────────────────┤
│ 主题卡片：                               │
│ "Best Christmas Gifts for Tech Lovers"  │
│ 状态：Approved ✅                        │
│ [Write Blog]                            │
└─────────────────────────────────────────┘
         ↓
系统生成博客：
  1. 读取主题和网站分析
  2. 调用Claude生成内容
  3. 保存为草稿
         ↓
步骤5：查看和发布
┌─────────────────────────────────────────┐
│ Blogs页面                                │
├─────────────────────────────────────────┤
│ 博客卡片：                               │
│ "Best Christmas Gifts for Tech Lovers"  │
│ 字数：1523                               │
│ 状态：Draft                              │
│ [View/Edit]                             │
└─────────────────────────────────────────┘
         ↓
用户可以：
  1. 查看完整内容
  2. 编辑内容
  3. 发布到网站
```

### 流程2：竞品分析与痛点提取

```
步骤1：添加竞品
┌─────────────────────────────────────────┐
│ Competitors页面                          │
├─────────────────────────────────────────┤
│ 竞品名称：Competitor A                   │
│ 竞品URL：https://competitor-a.com       │
│ [Add Competitor]                        │
└─────────────────────────────────────────┘
         ↓
系统自动分析：
  1. 爬取竞品网站
  2. 提取关键内容
  3. AI分析痛点
  4. 保存到痛点库
         ↓
步骤2：查看痛点库
┌─────────────────────────────────────────┐
│ Pain Points页面                          │
├─────────────────────────────────────────┤
│ 分类过滤：                               │
│ [All] [Quality] [Payment] [Delivery]    │
│ [Support] [Price] [Trust]                │
│                                         │
│ 痛点卡片：                               │
│ 分类：Quality                            │
│ 严重度：⭐⭐⭐⭐⭐ (5/5)                  │
│ 出现次数：3                              │
│ 内容："Product quality is inconsistent" │
│ 来源：Competitor A                       │
└─────────────────────────────────────────┘
         ↓
用于内容创作：
  1. 针对痛点创作解决方案
  2. 突出自身优势
  3. 建立竞争优势
```

### 流程3：假期营销主题生成

```
步骤1：同步假期
┌─────────────────────────────────────────┐
│ Holidays页面                             │
├─────────────────────────────────────────┤
│ [Sync Holidays]                         │
└─────────────────────────────────────────┘
         ↓
系统生成假期列表：
  - Christmas (2026-12-25)
  - Valentine's Day (2026-02-14)
  - Mother's Day (2026-05-10)
  - White Day (2026-03-14) [Japan/Korea]
  ... (更多假期)
         ↓
步骤2：基于假期生成主题
┌─────────────────────────────────────────┐
│ Topics页面                               │
├─────────────────────────────────────────┤
│ [Generate Topics]                       │
│                                         │
│ 生成类型：                               │
│   ○ Question Based                      │
│   ◉ Holiday Based                       │
│                                         │
│ 目标国家：                               │
│   ☑ United States                       │
│   ☑ Japan                               │
│   ☑ South Korea                         │
│                                         │
│ [Start Generating]                      │
└─────────────────────────────────────────┘
         ↓
系统生成假期相关主题：
  1. "Best Christmas Gifts for Tech Lovers"
  2. "Valentine's Day Gift Ideas"
  3. "White Day Gifts in Japan"
  ... (更多主题)
         ↓
特点：
  ✅ 时间敏感性强
  ✅ 用户搜索意图明确
  ✅ 转化率高
  ✅ 多国家覆盖
```

## 关键概念解释

### AEO（AI Engine Optimization）

```
传统SEO vs AEO

传统SEO：
  目标：搜索排名
  工具：关键词、反链、页面优化
  测试：SEO工具检测
  指标：排名位置、点击率

AEO：
  目标：AI推荐率
  工具：事实密度、Schema标记、唯一标识语
  测试：直接提问AI
  指标：提及率、推荐位置

系统的AEO流程：
  1. 生成主题
  2. 模拟用户查询
  3. 获取AI响应
  4. 分析为什么被推荐/未推荐
  5. 生成改进方案
  6. 优化内容
  7. 重新测试
```

### 事实密度（Fact Density）

```
低事实密度：
  "Many customers like eco-friendly products."
  
高事实密度：
  "According to a 2024 survey by XYZ Institute, 78% of customers 
   prefer eco-friendly packaging, with an average willingness to 
   pay 15% premium."

AEO优化：
  ✅ 包含具体数据
  ✅ 引用权威来源
  ✅ 提供可验证信息
  ✅ 增加AI引用概率
```

### 唯一标识语（Unique Identifiers）

```
示例：
  - 品牌标语："We make eco-friendly gifts affordable"
  - 产品特性："Our patented recycling system"
  - 创始人故事："Founded by environmental activists"
  - 价值主张："Carbon-neutral shipping included"

AEO优化：
  ✅ 自然融入内容
  ✅ 增加品牌识别度
  ✅ 提高AI提及概率
  ✅ 建立品牌差异化
```

### Schema.org标记

```
FAQ Schema示例：
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What are the best Christmas gifts?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "The best gifts depend on..."
      }
    }
  ]
}

优化效果：
  ✅ 提高AI理解
  ✅ 增加特色片段机会
  ✅ 改善搜索可见性
```

## 常见问题

### Q1：为什么我的主题没有被批准？

```
可能原因：
  1. 缺乏事实密度
     → 添加具体数据和统计
  
  2. 缺少Schema标记
     → 在FAQ部分添加JSON-LD
  
  3. 内容权威性不足
     → 引用权威来源
  
  4. 缺少唯一标识语
     → 突出品牌特色
  
  5. 竞品提及过多
     → 减少竞品提及，增加自身内容

解决方案：
  1. 查看AI审计诊断报告
  2. 根据建议优化内容
  3. 重新测试主题
```

### Q2：如何提高博客的AI推荐率？

```
优化步骤：
  1. 增加事实密度
     - 添加具体数据
     - 引用权威来源
     - 提供可验证信息
  
  2. 添加Schema标记
     - FAQ Schema
     - Product Schema
     - Organization Schema
  
  3. 突出唯一标识语
     - 品牌标语
     - 产品特性
     - 价值主张
  
  4. 优化TL;DR
     - 加粗关键信息
     - 便于AI摘要
     - 增加特色片段机会
  
  5. 自然融入产品推荐
     - 不过度销售
     - 提供真实价值
     - 与内容相关
```

### Q3：如何利用痛点库？

```
使用场景：
  1. 内容创作灵感
     - 针对痛点创作解决方案
     - 突出自身优势
  
  2. 产品改进
     - 识别市场需求
     - 优化产品特性
  
  3. 营销文案
     - 强调竞品缺陷
     - 突出自身优势
  
  4. 竞争分析
     - 了解竞品弱点
     - 制定差异化策略

最佳实践：
  ✅ 定期更新竞品分析
  ✅ 按严重度优先处理
  ✅ 基于痛点创作内容
  ✅ 追踪内容效果
```

### Q4：支持哪些国家？

```
支持的22个国家：

北美：
  - United States (US)
  - Canada (CA)

欧洲：
  - United Kingdom (UK)
  - Germany (DE)
  - France (FR)
  - Italy (IT)
  - Spain (ES)
  - Netherlands (NL)
  - Sweden (SE)
  - Switzerland (CH)
  - Norway (NO)
  - Denmark (DK)
  - Finland (FI)
  - Ireland (IE)
  - Belgium (BE)
  - Austria (AT)

亚太：
  - Japan (JP)
  - South Korea (KR)
  - Singapore (SG)
  - Australia (AU)
  - New Zealand (NZ)

中东：
  - Israel (IL)
```

## 最佳实践

### 1. 网站分析
```
✅ 选择代表性的网站
✅ 选择所有目标国家
✅ 等待分析完成后再生成主题
✅ 定期重新分析（产品变化时）
```

### 2. 主题生成
```
✅ 先生成question_based主题
✅ 后生成holiday_based主题
✅ 为每个国家生成主题
✅ 测试所有主题
```

### 3. AI测试
```
✅ 测试所有主题
✅ 查看诊断报告
✅ 根据建议优化
✅ 重新测试
```

### 4. 博客生成
```
✅ 仅为approved主题生成
✅ 编辑和审核内容
✅ 添加Schema标记
✅ 发布前测试
```

### 5. 竞品分析
```
✅ 添加主要竞品
✅ 定期更新分析
✅ 按痛点分类
✅ 基于痛点优化
```

## 性能优化建议

### 前端优化
```
✅ 使用缓存减少API调用
✅ 批量操作而不是单个操作
✅ 使用分页显示大量数据
✅ 异步加载非关键数据
```

### 后端优化
```
✅ 批量插入主题
✅ 使用索引加速查询
✅ 限制文本大小
✅ 缓存AI响应
```

### 成本优化
```
✅ 选择合适的AI模型
✅ 批量处理任务
✅ 避免重复测试
✅ 监控API使用
```

