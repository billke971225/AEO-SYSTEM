# 痛点爬取API配置指南

## 🔑 API密钥配置

### 1. Google Custom Search API
```bash
# 1. 访问 Google Cloud Console
# https://console.cloud.google.com/

# 2. 创建项目或选择现有项目

# 3. 启用 Custom Search API
# https://console.cloud.google.com/apis/library/customsearch.googleapis.com

# 4. 创建API密钥
# 导航到 "凭据" > "创建凭据" > "API密钥"

# 5. 创建自定义搜索引擎
# https://cse.google.com/cse/
# 添加要搜索的网站或选择"搜索整个网络"

# 6. 在Supabase中设置环境变量
GOOGLE_SEARCH_API_KEY=your_google_api_key_here
GOOGLE_CSE_ID=your_custom_search_engine_id_here
```

### 2. Bing Search API
```bash
# 1. 访问 Azure Portal
# https://portal.azure.com/

# 2. 创建 Bing Search v7 资源
# 搜索 "Bing Search v7" > 创建

# 3. 获取API密钥
# 资源 > 密钥和终结点

# 4. 在Supabase中设置环境变量
BING_SEARCH_API_KEY=your_bing_api_key_here
```

### 3. Reddit API (可选)
```bash
# 1. 访问 Reddit App Preferences
# https://www.reddit.com/prefs/apps

# 2. 创建新应用
# 选择 "script" 类型

# 3. 获取客户端ID和密钥
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_client_secret
```

### 4. Twitter API v2 (可选)
```bash
# 1. 访问 Twitter Developer Portal
# https://developer.twitter.com/

# 2. 创建应用并申请API访问

# 3. 获取Bearer Token
TWITTER_BEARER_TOKEN=your_twitter_bearer_token
```

## 💰 成本估算和免费额度

### Google Custom Search API
```javascript
const googlePricing = {
  free_tier: "100 queries/day",
  paid_tier: "$5 per 1,000 queries",
  monthly_estimate: {
    light_usage: "$0 (within free tier)",
    medium_usage: "$15-30/month (3,000-6,000 queries)",
    heavy_usage: "$50-100/month (10,000-20,000 queries)"
  }
}
```

### Bing Search API
```javascript
const bingPricing = {
  free_tier: "1,000 queries/month",
  paid_tier: "$3 per 1,000 queries",
  monthly_estimate: {
    light_usage: "$0 (within free tier)",
    medium_usage: "$9-18/month (3,000-6,000 queries)",
    heavy_usage: "$30-60/month (10,000-20,000 queries)"
  }
}
```

### Reddit API
```javascript
const redditPricing = {
  free_tier: "60 requests/minute, 600 requests/10 minutes",
  cost: "Free for non-commercial use",
  limitations: "Rate limited, requires user agent"
}
```

## 🛠️ Supabase环境变量设置

### 在Supabase Dashboard中设置
1. 进入你的Supabase项目
2. 导航到 Settings > API
3. 在 "Environment Variables" 部分添加：

```bash
# 搜索API密钥
GOOGLE_SEARCH_API_KEY=your_google_api_key
GOOGLE_CSE_ID=your_cse_id
BING_SEARCH_API_KEY=your_bing_api_key

# 社交媒体API (可选)
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_secret
TWITTER_BEARER_TOKEN=your_twitter_token

# 爬取配置
CRAWLING_USER_AGENT=PainPointCrawler/1.0 (Educational Purpose)
MAX_CONCURRENT_REQUESTS=3
REQUEST_DELAY_MS=1000
```

## 🔧 本地开发配置

### .env.local 文件
```bash
# 创建 .env.local 文件 (不要提交到Git)
GOOGLE_SEARCH_API_KEY=your_google_api_key
GOOGLE_CSE_ID=your_cse_id
BING_SEARCH_API_KEY=your_bing_api_key
REDDIT_CLIENT_ID=your_reddit_client_id
TWITTER_BEARER_TOKEN=your_twitter_token
```

### 本地测试脚本
```typescript
// test-pain-point-crawler.ts
const testConfig = {
  competitors: [
    "https://www.fiverr.com/categories/video-animation/video-messages",
    "https://www.cameo.com",
    "https://www.memmo.me"
  ],
  keywords: [
    "personalized video message",
    "custom birthday video", 
    "blessing video service",
    "video greeting card"
  ],
  countries: ["US", "UK", "DE"],
  platforms: ["google", "bing", "reddit"],
  max_results_per_platform: 20,
  context: "scenario" as const
};

// 测试API调用
async function testCrawler() {
  const response = await fetch("http://localhost:54321/functions/v1/pain-point-crawler", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${process.env.SUPABASE_ANON_KEY}`
    },
    body: JSON.stringify({ config: testConfig })
  });
  
  const result = await response.json();
  console.log("Crawling results:", result);
}

testCrawler();
```

## 🚀 部署和使用

### 1. 部署Edge Function
```bash
# 在项目根目录运行
npx supabase functions deploy pain-point-crawler
```

### 2. 测试部署
```bash
# 测试函数是否正常工作
curl -X POST 'https://your-project.supabase.co/functions/v1/pain-point-crawler' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "config": {
      "competitors": ["https://example.com"],
      "keywords": ["test keyword"],
      "countries": ["US"],
      "platforms": ["google"],
      "max_results_per_platform": 5,
      "context": "test"
    }
  }'
```

### 3. 集成到现有系统
```typescript
// 在其他Edge Functions中调用
const crawlPainPoints = async (config: CrawlingConfig) => {
  const response = await fetch(`${Deno.env.get("SUPABASE_URL")}/functions/v1/pain-point-crawler`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")}`
    },
    body: JSON.stringify({ config })
  });
  
  return await response.json();
};
```

## 🛡️ 安全和合规性

### 1. API密钥安全
- 永远不要在客户端代码中暴露API密钥
- 使用Supabase环境变量存储敏感信息
- 定期轮换API密钥
- 设置API使用限制和监控

### 2. 爬取合规性
```typescript
// robots.txt 检查
const checkRobotsTxt = async (domain: string): Promise<boolean> => {
  try {
    const robotsResponse = await fetch(`${domain}/robots.txt`);
    const robotsText = await robotsResponse.text();
    
    // 检查是否允许爬取
    return !robotsText.includes("Disallow: /");
  } catch {
    return true; // 如果没有robots.txt，假设允许
  }
};

// 请求频率限制
const rateLimiter = {
  requests: new Map<string, number[]>(),
  
  canMakeRequest(domain: string, maxPerMinute: number = 10): boolean {
    const now = Date.now();
    const requests = this.requests.get(domain) || [];
    
    // 清理1分钟前的请求
    const recentRequests = requests.filter(time => now - time < 60000);
    
    if (recentRequests.length >= maxPerMinute) {
      return false;
    }
    
    recentRequests.push(now);
    this.requests.set(domain, recentRequests);
    return true;
  }
};
```

### 3. 数据处理合规
- 不存储个人身份信息
- 遵守GDPR和数据保护法规
- 只处理公开可见的内容
- 提供数据删除机制

## 📊 监控和优化

### 1. API使用监控
```typescript
// API使用统计
interface APIUsageStats {
  google_queries: number;
  bing_queries: number;
  reddit_requests: number;
  daily_cost: number;
  success_rate: number;
}

// 记录API使用情况
const logAPIUsage = async (platform: string, cost: number, success: boolean) => {
  await supabase
    .from("api_usage_logs")
    .insert({
      platform,
      cost,
      success,
      timestamp: new Date().toISOString()
    });
};
```

### 2. 性能优化
- 实施缓存机制减少重复请求
- 使用批量处理提高效率
- 设置合理的超时时间
- 实施重试机制处理临时失败

这个配置指南涵盖了痛点爬取系统的完整设置流程。你需要我详细解释任何特定部分吗？