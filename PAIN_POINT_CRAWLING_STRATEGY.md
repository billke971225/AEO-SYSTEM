# 痛点爬取策略与技术实现

## 🎯 爬取目标平台

### 1. 搜索引擎平台
```javascript
// Google Search API - 获取竞争对手相关内容
const googleSearchSources = {
  api: "Google Custom Search API",
  endpoint: "https://www.googleapis.com/customsearch/v1",
  targets: [
    "site:competitor1.com + 关键词",
    "site:competitor2.com + 节假日关键词", 
    "竞争对手品牌名 + 痛点关键词",
    "行业关键词 + 问题词汇"
  ],
  advantages: ["官方API", "稳定可靠", "支持站点限定"],
  limitations: ["每日100次免费", "付费后$5/1000次"]
}

// Bing Search API - 备用搜索源
const bingSearchSources = {
  api: "Bing Web Search API",
  endpoint: "https://api.bing.microsoft.com/v7.0/search",
  advantages: ["微软官方", "相对便宜", "支持多语言"],
  pricing: "$3/1000次查询"
}
```

### 2. 社交媒体平台
```javascript
// Reddit API - 获取用户真实痛点
const redditSources = {
  api: "Reddit API",
  endpoint: "https://www.reddit.com/api/v1/",
  targets: [
    "r/relationships + 祝福视频",
    "r/LongDistance + 情侣祝福", 
    "r/wedding + 婚礼祝福",
    "r/birthday + 生日惊喜"
  ],
  data_points: [
    "用户抱怨和问题",
    "热门评论中的痛点",
    "求助帖子的需求",
    "成功案例的要素"
  ]
}

// Twitter/X API - 实时趋势和痛点
const twitterSources = {
  api: "Twitter API v2",
  endpoint: "https://api.twitter.com/2/",
  targets: [
    "祝福视频 + 抱怨词汇",
    "节假日 + 问题关键词",
    "竞争对手品牌提及",
    "相关话题标签"
  ]
}
```

### 3. 问答平台
```javascript
// Quora 内容爬取
const quoraSources = {
  method: "Web Scraping (Puppeteer)",
  targets: [
    "How to make birthday videos",
    "Best blessing video services",
    "Problems with video greetings",
    "节假日祝福视频制作"
  ],
  data_extraction: [
    "问题标题中的痛点",
    "高赞回答中的解决方案",
    "用户评论中的抱怨",
    "相关问题推荐"
  ]
}

// Stack Overflow (技术痛点)
const stackOverflowSources = {
  api: "Stack Exchange API",
  endpoint: "https://api.stackexchange.com/2.3/",
  targets: [
    "video processing issues",
    "personalization problems", 
    "delivery challenges"
  ]
}
```

### 4. 电商平台评论
```javascript
// Amazon 产品评论分析
const amazonSources = {
  method: "Web Scraping + Amazon API",
  targets: [
    "个性化视频产品评论",
    "祝福卡片产品评论",
    "节假日礼品评论",
    "竞争对手产品页面"
  ],
  pain_points: [
    "1-2星评论中的问题",
    "Q&A部分的疑问",
    "评论中的改进建议"
  ]
}

// Etsy 手工祝福产品
const etsySources = {
  method: "Etsy API + Web Scraping",
  targets: [
    "personalized video messages",
    "custom birthday videos",
    "holiday greeting videos"
  ]
}
```

## 🔧 技术实现方案

### 1. 核心爬取引擎
```typescript
// supabase/functions/pain-point-crawler/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.7.1";

interface CrawlingConfig {
  competitors: string[];
  keywords: string[];
  countries: string[];
  platforms: string[];
  max_results_per_platform: number;
}

interface PainPoint {
  source: string;
  platform: string;
  content: string;
  sentiment: number;
  relevance_score: number;
  country_code: string;
  extracted_at: string;
}

class PainPointCrawler {
  private googleApiKey: string;
  private bingApiKey: string;
  private redditClientId: string;
  private twitterBearerToken: string;

  constructor() {
    this.googleApiKey = Deno.env.get("GOOGLE_SEARCH_API_KEY") || "";
    this.bingApiKey = Deno.env.get("BING_SEARCH_API_KEY") || "";
    this.redditClientId = Deno.env.get("REDDIT_CLIENT_ID") || "";
    this.twitterBearerToken = Deno.env.get("TWITTER_BEARER_TOKEN") || "";
  }

  async crawlGoogleSearch(query: string, country: string): Promise<PainPoint[]> {
    const searchUrl = `https://www.googleapis.com/customsearch/v1?key=${this.googleApiKey}&cx=${Deno.env.get("GOOGLE_CSE_ID")}&q=${encodeURIComponent(query)}&gl=${country}&num=10`;
    
    try {
      const response = await fetch(searchUrl);
      const data = await response.json();
      
      return data.items?.map((item: any) => ({
        source: item.link,
        platform: "google_search",
        content: `${item.title} - ${item.snippet}`,
        sentiment: this.analyzeSentiment(item.snippet),
        relevance_score: this.calculateRelevance(item.snippet, query),
        country_code: country,
        extracted_at: new Date().toISOString()
      })) || [];
    } catch (error) {
      console.error("Google Search API error:", error);
      return [];
    }
  }

  async crawlReddit(subreddit: string, keywords: string[]): Promise<PainPoint[]> {
    const redditUrl = `https://www.reddit.com/r/${subreddit}/search.json?q=${keywords.join("+")}&sort=top&limit=25`;
    
    try {
      const response = await fetch(redditUrl, {
        headers: {
          "User-Agent": "PainPointCrawler/1.0"
        }
      });
      const data = await response.json();
      
      return data.data?.children?.map((post: any) => ({
        source: `https://reddit.com${post.data.permalink}`,
        platform: "reddit",
        content: `${post.data.title} - ${post.data.selftext}`,
        sentiment: this.analyzeSentiment(post.data.selftext),
        relevance_score: post.data.score / 100, // 标准化分数
        country_code: "US", // Reddit主要是美国用户
        extracted_at: new Date().toISOString()
      })) || [];
    } catch (error) {
      console.error("Reddit API error:", error);
      return [];
    }
  }

  async crawlTwitter(query: string, country: string): Promise<PainPoint[]> {
    const twitterUrl = `https://api.twitter.com/2/tweets/search/recent?query=${encodeURIComponent(query)}&max_results=50&tweet.fields=public_metrics,created_at`;
    
    try {
      const response = await fetch(twitterUrl, {
        headers: {
          "Authorization": `Bearer ${this.twitterBearerToken}`
        }
      });
      const data = await response.json();
      
      return data.data?.map((tweet: any) => ({
        source: `https://twitter.com/i/status/${tweet.id}`,
        platform: "twitter",
        content: tweet.text,
        sentiment: this.analyzeSentiment(tweet.text),
        relevance_score: (tweet.public_metrics.like_count + tweet.public_metrics.retweet_count) / 100,
        country_code: country,
        extracted_at: new Date().toISOString()
      })) || [];
    } catch (error) {
      console.error("Twitter API error:", error);
      return [];
    }
  }

  async crawlCompetitorWebsite(url: string): Promise<PainPoint[]> {
    // 使用 Puppeteer 爬取竞争对手网站
    try {
      const response = await fetch(url);
      const html = await response.text();
      
      // 提取关键内容（标题、描述、FAQ等）
      const painPoints = this.extractPainPointsFromHTML(html, url);
      
      return painPoints.map(content => ({
        source: url,
        platform: "competitor_website",
        content,
        sentiment: this.analyzeSentiment(content),
        relevance_score: 0.8, // 竞争对手内容相关性较高
        country_code: this.detectCountryFromURL(url),
        extracted_at: new Date().toISOString()
      }));
    } catch (error) {
      console.error("Website crawling error:", error);
      return [];
    }
  }

  private analyzeSentiment(text: string): number {
    // 简单的情感分析 (-1 到 1)
    const negativeWords = ["problem", "issue", "difficult", "hard", "expensive", "bad", "terrible", "awful"];
    const positiveWords = ["good", "great", "excellent", "amazing", "perfect", "love", "best"];
    
    const words = text.toLowerCase().split(/\s+/);
    let score = 0;
    
    words.forEach(word => {
      if (negativeWords.includes(word)) score -= 1;
      if (positiveWords.includes(word)) score += 1;
    });
    
    return Math.max(-1, Math.min(1, score / words.length));
  }

  private calculateRelevance(text: string, query: string): number {
    const queryWords = query.toLowerCase().split(/\s+/);
    const textWords = text.toLowerCase().split(/\s+/);
    
    let matches = 0;
    queryWords.forEach(qWord => {
      if (textWords.some(tWord => tWord.includes(qWord))) {
        matches++;
      }
    });
    
    return matches / queryWords.length;
  }

  private extractPainPointsFromHTML(html: string, url: string): string[] {
    // 简化的HTML内容提取
    const titleMatch = html.match(/<title>(.*?)<\/title>/i);
    const descriptionMatch = html.match(/<meta name="description" content="(.*?)"/i);
    const h1Matches = html.match(/<h1[^>]*>(.*?)<\/h1>/gi);
    const h2Matches = html.match(/<h2[^>]*>(.*?)<\/h2>/gi);
    
    const painPoints: string[] = [];
    
    if (titleMatch) painPoints.push(titleMatch[1]);
    if (descriptionMatch) painPoints.push(descriptionMatch[1]);
    if (h1Matches) painPoints.push(...h1Matches.map(h => h.replace(/<[^>]*>/g, "")));
    if (h2Matches) painPoints.push(...h2Matches.map(h => h.replace(/<[^>]*>/g, "")));
    
    return painPoints.filter(p => p.length > 10); // 过滤太短的内容
  }

  private detectCountryFromURL(url: string): string {
    const countryTLDs: Record<string, string> = {
      ".uk": "UK", ".de": "DE", ".fr": "FR", ".it": "IT", 
      ".es": "ES", ".nl": "NL", ".se": "SE", ".no": "NO",
      ".dk": "DK", ".fi": "FI", ".at": "AT", ".ch": "CH",
      ".be": "BE", ".pt": "PT", ".gr": "GR", ".pl": "PL",
      ".cz": "CZ", ".hu": "HU", ".ie": "IE", ".jp": "JP",
      ".kr": "KR", ".au": "AU", ".nz": "NZ", ".ca": "CA"
    };
    
    for (const [tld, country] of Object.entries(countryTLDs)) {
      if (url.includes(tld)) return country;
    }
    
    return "US"; // 默认美国
  }
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { headers: corsHeaders });
  }

  try {
    const { config }: { config: CrawlingConfig } = await req.json();
    const crawler = new PainPointCrawler();
    
    const allPainPoints: PainPoint[] = [];
    
    // 1. 爬取Google搜索结果
    for (const country of config.countries) {
      for (const keyword of config.keywords) {
        const googleResults = await crawler.crawlGoogleSearch(
          `${keyword} problems issues complaints`, 
          country
        );
        allPainPoints.push(...googleResults);
      }
    }
    
    // 2. 爬取Reddit
    const redditResults = await crawler.crawlReddit("relationships", config.keywords);
    allPainPoints.push(...redditResults);
    
    // 3. 爬取Twitter
    for (const country of config.countries) {
      for (const keyword of config.keywords) {
        const twitterResults = await crawler.crawlTwitter(
          `${keyword} problem issue complaint`, 
          country
        );
        allPainPoints.push(...twitterResults);
      }
    }
    
    // 4. 爬取竞争对手网站
    for (const competitor of config.competitors) {
      const competitorResults = await crawler.crawlCompetitorWebsite(competitor);
      allPainPoints.push(...competitorResults);
    }
    
    // 5. 数据清洗和去重
    const cleanedPainPoints = allPainPoints
      .filter(p => p.relevance_score > 0.3) // 过滤低相关性
      .filter(p => p.content.length > 20)   // 过滤太短内容
      .sort((a, b) => b.relevance_score - a.relevance_score) // 按相关性排序
      .slice(0, 100); // 取前100个最相关的
    
    return new Response(
      JSON.stringify({ 
        success: true,
        pain_points: cleanedPainPoints,
        total_found: allPainPoints.length,
        after_filtering: cleanedPainPoints.length
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (error) {
    console.error("Pain point crawling error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
```

## 💰 API成本估算

### 免费层级
```javascript
const freeTierLimits = {
  "Google Custom Search": "100次/天",
  "Reddit API": "60次/分钟",
  "Twitter API v2": "500,000次/月",
  "Bing Search": "1000次/月"
}
```

### 付费方案
```javascript
const paidPricing = {
  "Google Custom Search": "$5/1000次",
  "Bing Search API": "$3/1000次", 
  "Twitter API v2": "$100/月 (基础版)",
  "Reddit API": "免费但有限制",
  "Puppeteer爬取": "服务器成本约$20/月"
}
```

## 🛡️ 合规性考虑

### 1. API使用条款
- **Google**: 遵守搜索API使用条款
- **Twitter**: 遵守开发者协议
- **Reddit**: 遵守API使用规则
- **网站爬取**: 遵守robots.txt

### 2. 数据处理
- 不存储个人身份信息
- 只提取公开可见内容
- 遵守GDPR和数据保护法规

### 3. 频率限制
- 实施请求频率限制
- 使用代理轮换
- 添加随机延迟

这个痛点爬取策略结合了多个数据源，既有官方API的稳定性，也有网络爬取的灵活性，能够全面获取竞争对手和市场的痛点信息。你觉得这个技术方案怎么样？需要我详细解释任何特定部分吗？