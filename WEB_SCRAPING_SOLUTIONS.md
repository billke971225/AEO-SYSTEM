# 网站爬取技术方案对比

## 🎯 爬取方案选择

### 方案1：Supabase Edge Functions + Fetch (当前实现)
```typescript
// 优势：简单、轻量、成本低
// 限制：只能爬取静态HTML，无法处理JavaScript渲染

async function crawlWithFetch(url: string): Promise<string> {
  const response = await fetch(url, {
    headers: {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    }
  });
  
  return await response.text();
}
```

**适用场景**：
- ✅ 静态HTML网站
- ✅ 简单的内容提取
- ✅ 成本敏感的项目
- ❌ JavaScript重度渲染的网站
- ❌ 需要交互的页面

---

### 方案2：Puppeteer + 独立服务器
```typescript
// 需要单独的服务器运行Puppeteer
// 通过API调用爬取服务

interface ScrapingService {
  endpoint: string;
  method: "POST";
  payload: {
    url: string;
    selectors?: string[];
    waitFor?: string;
    screenshot?: boolean;
  };
}

const puppeteerService: ScrapingService = {
  endpoint: "https://your-scraping-server.com/scrape",
  method: "POST",
  payload: {
    url: "https://target-website.com",
    selectors: ["h1", "p", ".price", ".review"],
    waitFor: ".content-loaded",
    screenshot: false
  }
};
```

**成本估算**：
- VPS服务器：$10-20/月
- 或使用Puppeteer云服务：$0.01-0.05/页面

---

### 方案3：第三方爬取API服务
```typescript
// 使用专业的爬取服务，如ScrapingBee, Scrapfly等

interface ThirdPartyScrapingAPI {
  service: "ScrapingBee" | "Scrapfly" | "Bright Data";
  pricing: string;
  features: string[];
}

const scrapingServices: ThirdPartyScrapingAPI[] = [
  {
    service: "ScrapingBee",
    pricing: "$29/月 (100,000次请求)",
    features: ["JavaScript渲染", "代理轮换", "验证码处理", "反检测"]
  },
  {
    service: "Scrapfly", 
    pricing: "$25/月 (50,000次请求)",
    features: ["智能代理", "浏览器指纹", "地理位置", "缓存"]
  },
  {
    service: "Bright Data",
    pricing: "$500/月起",
    features: ["企业级", "全球代理网络", "高成功率", "合规性"]
  }
];
```

---

### 方案4：混合方案 (推荐)
```typescript
// 根据网站类型选择不同的爬取方式

class SmartWebScraper {
  async scrapeWebsite(url: string): Promise<ScrapingResult> {
    const websiteType = await this.detectWebsiteType(url);
    
    switch (websiteType) {
      case "static":
        return await this.scrapeWithFetch(url);
      
      case "spa": // Single Page Application
        return await this.scrapeWithPuppeteerAPI(url);
      
      case "protected":
        return await this.scrapeWithThirdPartyAPI(url);
      
      default:
        return await this.scrapeWithFetch(url);
    }
  }

  private async detectWebsiteType(url: string): Promise<"static" | "spa" | "protected"> {
    try {
      // 先尝试简单fetch
      const response = await fetch(url);
      const html = await response.text();
      
      // 检查是否有大量JavaScript
      const scriptTags = (html.match(/<script/g) || []).length;
      const hasReactVue = /react|vue|angular/i.test(html);
      
      if (scriptTags > 10 || hasReactVue) {
        return "spa";
      }
      
      // 检查是否有反爬虫保护
      const hasCloudflare = html.includes("cloudflare");
      const hasRecaptcha = html.includes("recaptcha");
      
      if (hasCloudflare || hasRecaptcha) {
        return "protected";
      }
      
      return "static";
    } catch {
      return "protected";
    }
  }
}
```

## 🛠️ 具体实现方案

### 推荐方案：Supabase Edge Functions + 外部爬取服务

#### 1. 更新现有的痛点爬取器
```typescript
// supabase/functions/pain-point-crawler/index.ts (增强版)

interface ScrapingConfig {
  method: "fetch" | "puppeteer" | "api";
  timeout: number;
  retries: number;
  proxy?: boolean;
}

class EnhancedWebScraper {
  private scrapingBeeApiKey: string;
  
  constructor() {
    this.scrapingBeeApiKey = Deno.env.get("SCRAPINGBEE_API_KEY") || "";
  }

  async scrapeWebsite(url: string, config: ScrapingConfig = { method: "fetch", timeout: 10000, retries: 2 }): Promise<string> {
    for (let attempt = 0; attempt < config.retries; attempt++) {
      try {
        switch (config.method) {
          case "fetch":
            return await this.scrapeWithFetch(url, config.timeout);
          
          case "puppeteer":
            return await this.scrapeWithPuppeteerAPI(url);
          
          case "api":
            return await this.scrapeWithScrapingBee(url);
          
          default:
            return await this.scrapeWithFetch(url, config.timeout);
        }
      } catch (error) {
        console.error(`Scraping attempt ${attempt + 1} failed:`, error);
        if (attempt === config.retries - 1) throw error;
        
        // 等待后重试
        await new Promise(resolve => setTimeout(resolve, 1000 * (attempt + 1)));
      }
    }
    
    throw new Error("All scraping attempts failed");
  }

  private async scrapeWithFetch(url: string, timeout: number): Promise<string> {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);
    
    try {
      const response = await fetch(url, {
        headers: {
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
          "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
          "Accept-Language": "en-US,en;q=0.5",
          "Accept-Encoding": "gzip, deflate",
          "Connection": "keep-alive",
          "Upgrade-Insecure-Requests": "1"
        },
        signal: controller.signal
      });
      
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }
      
      return await response.text();
    } finally {
      clearTimeout(timeoutId);
    }
  }

  private async scrapeWithPuppeteerAPI(url: string): Promise<string> {
    // 调用外部Puppeteer服务
    const puppeteerServiceUrl = Deno.env.get("PUPPETEER_SERVICE_URL") || "https://your-puppeteer-service.com/scrape";
    
    const response = await fetch(puppeteerServiceUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${Deno.env.get("PUPPETEER_SERVICE_KEY")}`
      },
      body: JSON.stringify({
        url,
        waitFor: 3000,
        extractText: true,
        removeScripts: true
      })
    });
    
    const result = await response.json();
    return result.html || result.text || "";
  }

  private async scrapeWithScrapingBee(url: string): Promise<string> {
    if (!this.scrapingBeeApiKey) {
      throw new Error("ScrapingBee API key not configured");
    }
    
    const scrapingBeeUrl = `https://app.scrapingbee.com/api/v1/?api_key=${this.scrapingBeeApiKey}&url=${encodeURIComponent(url)}&render_js=false&premium_proxy=false`;
    
    const response = await fetch(scrapingBeeUrl);
    
    if (!response.ok) {
      throw new Error(`ScrapingBee API error: ${response.status}`);
    }
    
    return await response.text();
  }

  // 智能选择爬取方法
  async smartScrape(url: string): Promise<string> {
    // 1. 先尝试简单fetch
    try {
      const html = await this.scrapeWithFetch(url, 5000);
      
      // 检查内容质量
      if (this.isContentRich(html)) {
        return html;
      }
    } catch (error) {
      console.log("Fetch failed, trying alternative methods");
    }
    
    // 2. 如果fetch失败或内容不足，尝试Puppeteer
    try {
      return await this.scrapeWithPuppeteerAPI(url);
    } catch (error) {
      console.log("Puppeteer failed, trying ScrapingBee");
    }
    
    // 3. 最后尝试第三方API
    return await this.scrapeWithScrapingBee(url);
  }

  private isContentRich(html: string): boolean {
    // 检查HTML是否包含足够的内容
    const textContent = html.replace(/<[^>]*>/g, "").trim();
    const wordCount = textContent.split(/\s+/).length;
    
    return wordCount > 100 && !html.includes("Please enable JavaScript");
  }
}
```

#### 2. 创建简单的Puppeteer微服务 (可选)
```dockerfile
# Dockerfile for Puppeteer service
FROM node:18-slim

# Install Puppeteer dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

EXPOSE 3000
CMD ["node", "server.js"]
```

```javascript
// server.js - 简单的Puppeteer服务
const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
app.use(express.json());

app.post('/scrape', async (req, res) => {
  const { url, waitFor = 3000, selectors = [] } = req.body;
  
  let browser;
  try {
    browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });
    
    const page = await browser.newPage();
    await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
    
    await page.goto(url, { waitUntil: 'networkidle2' });
    await page.waitForTimeout(waitFor);
    
    let result = {};
    
    if (selectors.length > 0) {
      for (const selector of selectors) {
        const elements = await page.$$(selector);
        result[selector] = await Promise.all(
          elements.map(el => el.evaluate(node => node.textContent))
        );
      }
    } else {
      result.html = await page.content();
      result.text = await page.evaluate(() => document.body.innerText);
    }
    
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  } finally {
    if (browser) await browser.close();
  }
});

app.listen(3000, () => {
  console.log('Puppeteer service running on port 3000');
});
```

## 💰 成本对比分析

### 方案成本对比 (月度估算)
```javascript
const costComparison = {
  "Fetch Only": {
    cost: "$0",
    success_rate: "60-70%",
    suitable_for: "静态网站，博客，新闻站"
  },
  
  "VPS + Puppeteer": {
    cost: "$10-20/月",
    success_rate: "85-95%", 
    suitable_for: "中小型项目，可控成本"
  },
  
  "ScrapingBee API": {
    cost: "$29/月 (100k请求)",
    success_rate: "95-99%",
    suitable_for: "商业项目，高成功率要求"
  },
  
  "混合方案": {
    cost: "$15-35/月",
    success_rate: "90-98%",
    suitable_for: "最佳性价比，推荐方案"
  }
};
```

## 🚀 推荐实施步骤

### 阶段1：基础实现 (当前)
- ✅ 使用Fetch爬取静态网站
- ✅ 实现基本的HTML解析
- ✅ 添加错误处理和重试机制

### 阶段2：增强功能
- 🔄 添加网站类型检测
- 🔄 集成ScrapingBee API作为备用
- 🔄 实现智能爬取策略

### 阶段3：高级功能 (可选)
- ⏳ 部署Puppeteer微服务
- ⏳ 添加代理轮换
- ⏳ 实现分布式爬取

## 🛡️ 反反爬虫策略

```typescript
const antiDetectionStrategies = {
  "User-Agent轮换": [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36"
  ],
  
  "请求头伪装": {
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Accept-Encoding": "gzip, deflate",
    "Connection": "keep-alive",
    "Upgrade-Insecure-Requests": "1"
  },
  
  "频率控制": {
    "min_delay": 1000, // 最小延迟1秒
    "max_delay": 5000, // 最大延迟5秒
    "random_delay": true
  },
  
  "IP轮换": {
    "use_proxy": true,
    "proxy_rotation": true,
    "residential_proxies": false // 成本考虑
  }
};
```

**总结推荐**：
1. **当前阶段**：使用Fetch + 智能重试，成本为$0
2. **扩展阶段**：添加ScrapingBee API备用，成本约$29/月
3. **高级阶段**：部署Puppeteer服务，总成本约$35/月

这样既保证了功能完整性，又控制了成本。你觉得这个方案如何？