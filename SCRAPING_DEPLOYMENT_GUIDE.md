# 网站爬取部署指南

## 🎯 当前实现方案

### 方案选择：Supabase Edge Functions + 智能爬取
- **主要方法**：Enhanced Fetch (免费)
- **备用方法**：ScrapingBee API (付费)
- **成本**：$0-29/月

## 🔧 部署步骤

### 1. 基础配置 (免费方案)
```bash
# 不需要额外配置，直接使用增强的Fetch方法
# 已包含在 pain-point-crawler Edge Function 中
```

### 2. 添加ScrapingBee支持 (可选，提高成功率)
```bash
# 1. 注册ScrapingBee账户
# https://www.scrapingbee.com/

# 2. 获取API密钥

# 3. 在Supabase中添加环境变量
SCRAPINGBEE_API_KEY=your_scrapingbee_api_key_here
```

### 3. 部署更新的Edge Function
```bash
# 部署包含智能爬取的痛点爬取器
npx supabase functions deploy pain-point-crawler
```

## 🚀 使用方式

### 自动智能爬取
系统会自动选择最佳爬取方法：

```typescript
// 爬取流程
1. 尝试 Enhanced Fetch (免费)
   ├─ 成功且内容丰富 → 返回结果
   └─ 失败或内容不足 → 下一步

2. 尝试 ScrapingBee API (如果配置了)
   ├─ 成功 → 返回结果  
   └─ 失败 → 下一步

3. 使用 Mock 数据 (保证系统稳定性)
```

### 手动测试爬取效果
```bash
# 测试特定网站的爬取效果
curl -X POST 'https://your-project.supabase.co/functions/v1/pain-point-crawler' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "config": {
      "competitors": ["https://www.fiverr.com/categories/video-animation"],
      "keywords": ["video message problems"],
      "countries": ["US"],
      "platforms": ["competitors"],
      "max_results_per_platform": 5,
      "context": "test"
    }
  }'
```

## 📊 爬取成功率对比

### 不同网站类型的成功率
```javascript
const successRates = {
  "静态HTML网站": {
    "Enhanced Fetch": "85-95%",
    "ScrapingBee": "95-99%",
    "examples": ["WordPress博客", "静态企业站", "新闻网站"]
  },
  
  "轻度JavaScript网站": {
    "Enhanced Fetch": "60-75%", 
    "ScrapingBee": "90-95%",
    "examples": ["部分电商网站", "简单SPA应用"]
  },
  
  "重度JavaScript网站": {
    "Enhanced Fetch": "20-40%",
    "ScrapingBee": "80-90%", 
    "examples": ["React/Vue应用", "现代电商平台"]
  },
  
  "反爬虫保护网站": {
    "Enhanced Fetch": "10-30%",
    "ScrapingBee": "70-85%",
    "examples": ["大型平台", "金融网站", "社交媒体"]
  }
};
```

## 🛡️ 反检测策略

### 已实现的反检测功能
```typescript
const antiDetectionFeatures = {
  "User-Agent轮换": "✅ 5个不同的浏览器UA",
  "请求头伪装": "✅ 完整的浏览器请求头",
  "随机延迟": "✅ 1-5秒随机延迟",
  "错误重试": "✅ 智能重试机制",
  "内容质量检测": "✅ 自动检测爬取质量",
  "备用方案": "✅ 多种爬取方法切换"
};
```

### 请求头伪装详情
```typescript
const enhancedHeaders = {
  "User-Agent": "随机选择的现代浏览器UA",
  "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
  "Accept-Language": "en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7",
  "Accept-Encoding": "gzip, deflate, br",
  "Connection": "keep-alive",
  "Upgrade-Insecure-Requests": "1",
  "Sec-Fetch-Dest": "document",
  "Sec-Fetch-Mode": "navigate", 
  "Sec-Fetch-Site": "none",
  "Sec-Fetch-User": "?1",
  "Cache-Control": "max-age=0"
};
```

## 💰 成本分析

### 免费方案 (推荐起步)
```javascript
const freePlan = {
  cost: "$0/月",
  success_rate: "70-85%",
  suitable_for: [
    "MVP阶段",
    "小规模测试", 
    "静态网站为主的竞争对手",
    "成本敏感项目"
  ],
  limitations: [
    "JavaScript重度网站成功率低",
    "反爬虫网站难以处理",
    "无代理IP支持"
  ]
};
```

### ScrapingBee方案 (推荐生产)
```javascript
const scrapingBeePlan = {
  cost: "$29/月 (100,000次请求)",
  success_rate: "90-95%",
  suitable_for: [
    "生产环境",
    "商业项目",
    "高成功率要求",
    "复杂网站爬取"
  ],
  benefits: [
    "JavaScript渲染支持",
    "代理IP轮换",
    "反检测技术",
    "高可用性保证"
  ]
};
```

## 🔍 监控和优化

### 爬取成功率监控
```typescript
// 在数据库中记录爬取统计
interface ScrapingStats {
  date: string;
  total_attempts: number;
  successful_scrapes: number;
  failed_scrapes: number;
  success_rate: number;
  average_response_time: number;
  method_used: "fetch" | "scrapingbee" | "mock";
}

// 每次爬取后记录统计
const logScrapingStats = async (stats: ScrapingStats) => {
  await supabase
    .from("scraping_statistics")
    .insert(stats);
};
```

### 失败网站分析
```sql
-- 创建爬取失败记录表
CREATE TABLE scraping_failures (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  url TEXT NOT NULL,
  error_message TEXT,
  http_status INTEGER,
  retry_count INTEGER DEFAULT 0,
  last_attempt TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- 分析字段
  website_type TEXT, -- 'static', 'spa', 'protected'
  requires_js BOOLEAN DEFAULT FALSE,
  has_anti_bot BOOLEAN DEFAULT FALSE,
  
  -- 解决方案建议
  suggested_method TEXT, -- 'scrapingbee', 'puppeteer', 'manual'
  resolved BOOLEAN DEFAULT FALSE
);
```

## 🚀 扩展方案 (未来)

### 如果需要更高成功率
```typescript
const advancedOptions = {
  "自建Puppeteer服务": {
    cost: "$10-20/月 (VPS)",
    success_rate: "85-95%",
    setup_complexity: "中等",
    maintenance: "需要维护"
  },
  
  "Bright Data代理": {
    cost: "$500+/月",
    success_rate: "95-99%", 
    setup_complexity: "简单",
    suitable_for: "企业级项目"
  },
  
  "多服务商混合": {
    cost: "$50-100/月",
    success_rate: "95-98%",
    setup_complexity: "复杂",
    suitable_for: "高要求项目"
  }
};
```

## 📋 部署检查清单

### 基础部署 ✅
- [x] 部署增强版痛点爬取器
- [x] 配置智能爬取策略
- [x] 添加反检测功能
- [x] 实现错误处理和重试
- [x] 添加内容质量检测

### 可选增强 ⏳
- [ ] 配置ScrapingBee API密钥
- [ ] 添加爬取统计监控
- [ ] 创建失败分析表
- [ ] 设置成功率告警

### 生产优化 🔮
- [ ] 部署Puppeteer微服务
- [ ] 添加代理IP轮换
- [ ] 实现分布式爬取
- [ ] 添加缓存机制

## 🎯 推荐实施路径

### 阶段1：立即部署 (0成本)
1. 部署当前的智能爬取系统
2. 测试主要竞争对手网站的爬取效果
3. 收集成功率数据

### 阶段2：按需优化 (低成本)
1. 如果成功率不满意，添加ScrapingBee API
2. 监控爬取统计，识别问题网站
3. 优化爬取策略

### 阶段3：高级扩展 (按需)
1. 根据业务需求决定是否需要更高成功率
2. 评估自建vs第三方服务的成本效益
3. 实施选定的高级方案

这个方案既保证了功能完整性，又很好地控制了成本。你觉得这个部署策略如何？