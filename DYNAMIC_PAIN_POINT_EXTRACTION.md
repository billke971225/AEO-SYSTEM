# 动态痛点提取策略

## 🎯 问题分析

### 当前问题
- ❌ 硬编码痛点关键词，不够灵活
- ❌ 无法适应不同行业和产品
- ❌ 缺少Trustpilot等重要评价平台
- ❌ 痛点识别过于依赖预设规则

### 解决方案
- ✅ 动态学习痛点模式
- ✅ 基于AI的痛点识别
- ✅ 多平台评价爬取
- ✅ 自适应痛点分类

## 🔍 真实痛点来源

### 1. Trustpilot 评价爬取
```javascript
const trustpilotSources = {
  "Fiverr评价": "https://www.trustpilot.com/review/fiverr.com",
  "Cameo评价": "https://www.trustpilot.com/review/cameo.com", 
  "Memmo评价": "https://www.trustpilot.com/review/memmo.me",
  "Starsona评价": "https://www.trustpilot.com/review/starsona.com",
  
  // 爬取策略
  target_elements: [
    ".review-content-wrap__text", // 评价内容
    ".star-rating", // 星级评分
    ".consumer-information__name", // 用户信息
    ".review-content-wrap__title" // 评价标题
  ],
  
  pain_point_indicators: [
    "1-2星评价的完整内容",
    "3星评价中的负面部分",
    "评价标题中的问题描述",
    "用户回复中的具体抱怨"
  ]
}
```

### 2. Google Reviews 爬取
```javascript
const googleReviewsSources = {
  search_queries: [
    "Fiverr video message reviews",
    "Cameo personalized video reviews",
    "custom video service complaints",
    "blessing video service problems"
  ],
  
  extraction_targets: [
    "Google My Business评价",
    "Google搜索结果中的评价片段",
    "相关服务商的Google评价"
  ]
}
```

### 3. 社交媒体真实抱怨
```javascript
const socialMediaComplaints = {
  "Twitter": [
    "搜索: 'fiverr video disappointed'",
    "搜索: 'cameo video terrible'", 
    "搜索: 'personalized video scam'",
    "话题标签: #FiverrFail #CameoDisappointment"
  ],
  
  "Reddit": [
    "r/Fiverr - 用户抱怨帖",
    "r/scams - 视频服务相关骗局",
    "r/mildlyinfuriating - 服务体验抱怨",
    "r/ExpectationVsReality - 期望与现实差距"
  ],
  
  "Facebook": [
    "相关群组中的抱怨帖",
    "服务商页面的负面评论",
    "用户分享的糟糕体验"
  ]
}
```

## 🤖 AI驱动的痛点识别

### 1. 使用GPT进行痛点提取
```typescript
class AIPainPointExtractor {
  async extractPainPointsWithAI(reviewText: string, productContext: string): Promise<ExtractedPainPoint[]> {
    const prompt = `
    分析以下用户评价，提取其中的具体痛点和问题。
    
    产品背景: ${productContext}
    用户评价: "${reviewText}"
    
    请以JSON格式返回痛点分析，包括：
    1. 具体痛点描述
    2. 痛点类别（自动识别，不要使用预设类别）
    3. 严重程度（1-5）
    4. 影响的服务环节
    5. 用户情感强度
    
    只返回JSON，不要其他解释。
    `;
    
    try {
      const response = await fetch("https://api.openai.com/v1/chat/completions", {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          model: "gpt-3.5-turbo",
          messages: [{ role: "user", content: prompt }],
          temperature: 0.3,
          max_tokens: 500
        })
      });
      
      const data = await response.json();
      const aiAnalysis = JSON.parse(data.choices[0].message.content);
      
      return this.formatAIExtractedPainPoints(aiAnalysis, reviewText);
    } catch (error) {
      console.error("AI痛点提取失败:", error);
      return this.fallbackPainPointExtraction(reviewText);
    }
  }
  
  private formatAIExtractedPainPoints(aiAnalysis: any, originalText: string): ExtractedPainPoint[] {
    if (!aiAnalysis.pain_points || !Array.isArray(aiAnalysis.pain_points)) {
      return [];
    }
    
    return aiAnalysis.pain_points.map((point: any) => ({
      content: point.description || originalText.substring(0, 200),
      category: point.category || "unknown",
      severity: point.severity || 1,
      service_stage: point.service_stage || "general",
      emotional_intensity: point.emotional_intensity || 1,
      source: "ai_extracted",
      confidence: point.confidence || 0.5
    }));
  }
}
```

### 2. 无监督痛点模式学习
```typescript
class PainPointPatternLearner {
  private painPointPatterns: Map<string, number> = new Map();
  
  async learnPainPointPatterns(reviews: ReviewData[]): Promise<LearnedPatterns> {
    // 1. 收集所有负面评价（1-2星）
    const negativeReviews = reviews.filter(r => r.rating <= 2);
    
    // 2. 提取常见短语和模式
    const phrases = this.extractCommonPhrases(negativeReviews);
    
    // 3. 使用TF-IDF识别重要词汇
    const importantTerms = this.calculateTFIDF(phrases);
    
    // 4. 聚类相似的抱怨
    const painPointClusters = this.clusterSimilarComplaints(negativeReviews);
    
    return {
      common_phrases: phrases,
      important_terms: importantTerms,
      pain_clusters: painPointClusters,
      learned_patterns: this.generatePatterns(painPointClusters)
    };
  }
  
  private extractCommonPhrases(reviews: ReviewData[]): string[] {
    const allText = reviews.map(r => r.content).join(" ");
    const sentences = allText.split(/[.!?]+/);
    
    // 提取2-5个词的短语
    const phrases: string[] = [];
    sentences.forEach(sentence => {
      const words = sentence.trim().split(/\s+/);
      for (let i = 0; i < words.length - 1; i++) {
        for (let len = 2; len <= Math.min(5, words.length - i); len++) {
          const phrase = words.slice(i, i + len).join(" ").toLowerCase();
          if (phrase.length > 10 && phrase.length < 50) {
            phrases.push(phrase);
          }
        }
      }
    });
    
    // 统计频率并返回高频短语
    const phraseCounts = phrases.reduce((acc, phrase) => {
      acc[phrase] = (acc[phrase] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);
    
    return Object.entries(phraseCounts)
      .filter(([phrase, count]) => count >= 3) // 至少出现3次
      .sort(([,a], [,b]) => b - a)
      .slice(0, 50)
      .map(([phrase]) => phrase);
  }
}
```

## 🌐 Trustpilot 专门爬取器

### 1. Trustpilot 评价爬取
```typescript
class TrustpilotCrawler {
  async crawlTrustpilotReviews(companyDomain: string): Promise<TrustpilotReview[]> {
    const trustpilotUrl = `https://www.trustpilot.com/review/${companyDomain}`;
    
    try {
      // 使用智能爬取策略
      const html = await this.smartScrape(trustpilotUrl);
      return this.extractTrustpilotReviews(html, companyDomain);
    } catch (error) {
      console.error(`Trustpilot爬取失败 ${companyDomain}:`, error);
      return [];
    }
  }
  
  private extractTrustpilotReviews(html: string, domain: string): TrustpilotReview[] {
    const reviews: TrustpilotReview[] = [];
    
    // Trustpilot的评价结构
    const reviewPatterns = {
      // 评价内容
      content: /<div[^>]*data-service-review-text-typography="true"[^>]*>(.*?)<\/div>/gi,
      // 星级评分
      rating: /<div[^>]*data-service-review-rating[^>]*>.*?(\d+)\s*out\s*of\s*5/gi,
      // 评价标题
      title: /<h2[^>]*data-service-review-title-typography[^>]*>(.*?)<\/h2>/gi,
      // 用户信息
      user: /<span[^>]*data-consumer-name-typography[^>]*>(.*?)<\/span>/gi,
      // 评价日期
      date: /<time[^>]*datetime="([^"]*)"[^>]*>/gi
    };
    
    // 提取评价内容
    const contentMatches = [...html.matchAll(reviewPatterns.content)];
    const ratingMatches = [...html.matchAll(reviewPatterns.rating)];
    const titleMatches = [...html.matchAll(reviewPatterns.title)];
    const userMatches = [...html.matchAll(reviewPatterns.user)];
    const dateMatches = [...html.matchAll(reviewPatterns.date)];
    
    const maxLength = Math.min(
      contentMatches.length,
      ratingMatches.length,
      titleMatches.length
    );
    
    for (let i = 0; i < maxLength; i++) {
      const content = this.cleanHtmlText(contentMatches[i]?.[1] || "");
      const rating = parseInt(ratingMatches[i]?.[1] || "5");
      const title = this.cleanHtmlText(titleMatches[i]?.[1] || "");
      const user = this.cleanHtmlText(userMatches[i]?.[1] || "Anonymous");
      const date = dateMatches[i]?.[1] || new Date().toISOString();
      
      if (content.length > 20) {
        reviews.push({
          platform: "trustpilot",
          domain: domain,
          title: title,
          content: content,
          rating: rating,
          user: user,
          date: date,
          is_pain_point: rating <= 2, // 1-2星认为是痛点
          extracted_at: new Date().toISOString()
        });
      }
    }
    
    return reviews;
  }
  
  private cleanHtmlText(html: string): string {
    return html
      .replace(/<[^>]*>/g, "") // 移除HTML标签
      .replace(/&[^;]+;/g, "") // 移除HTML实体
      .replace(/\s+/g, " ") // 标准化空格
      .trim();
  }
}
```

### 2. 多平台评价聚合
```typescript
class MultiPlatformReviewCrawler {
  private platforms = {
    trustpilot: new TrustpilotCrawler(),
    googleReviews: new GoogleReviewsCrawler(),
    sitejabber: new SitejabberCrawler(),
    bbb: new BBBCrawler() // Better Business Bureau
  };
  
  async crawlAllPlatforms(competitors: string[]): Promise<AggregatedReviews> {
    const allReviews: PlatformReview[] = [];
    
    for (const competitor of competitors) {
      const domain = this.extractDomain(competitor);
      
      // 并行爬取所有平台
      const platformPromises = Object.entries(this.platforms).map(async ([platform, crawler]) => {
        try {
          const reviews = await crawler.crawlReviews(domain);
          return reviews.map(review => ({
            ...review,
            platform: platform,
            competitor: competitor
          }));
        } catch (error) {
          console.error(`${platform} 爬取失败 ${domain}:`, error);
          return [];
        }
      });
      
      const platformResults = await Promise.all(platformPromises);
      allReviews.push(...platformResults.flat());
    }
    
    return this.aggregateAndAnalyzeReviews(allReviews);
  }
  
  private async aggregateAndAnalyzeReviews(reviews: PlatformReview[]): Promise<AggregatedReviews> {
    // 1. 过滤痛点评价（1-2星）
    const painPointReviews = reviews.filter(r => r.rating <= 2);
    
    // 2. 使用AI提取痛点
    const aiExtractor = new AIPainPointExtractor();
    const extractedPainPoints: ExtractedPainPoint[] = [];
    
    for (const review of painPointReviews) {
      const painPoints = await aiExtractor.extractPainPointsWithAI(
        review.content, 
        "personalized video message service"
      );
      extractedPainPoints.push(...painPoints);
    }
    
    // 3. 学习痛点模式
    const patternLearner = new PainPointPatternLearner();
    const learnedPatterns = await patternLearner.learnPainPointPatterns(reviews);
    
    return {
      total_reviews: reviews.length,
      pain_point_reviews: painPointReviews.length,
      extracted_pain_points: extractedPainPoints,
      learned_patterns: learnedPatterns,
      platform_breakdown: this.getPlatformBreakdown(reviews),
      competitor_analysis: this.getCompetitorAnalysis(reviews)
    };
  }
}
```

## 🔄 动态痛点更新流程

### 1. 实时痛点学习
```typescript
class DynamicPainPointSystem {
  async updatePainPointDatabase(newReviews: PlatformReview[]): Promise<void> {
    // 1. AI分析新评价
    const newPainPoints = await this.extractPainPointsFromReviews(newReviews);
    
    // 2. 更新痛点模式库
    await this.updatePainPointPatterns(newPainPoints);
    
    // 3. 重新训练分类器
    await this.retrainPainPointClassifier();
    
    // 4. 生成新的营销洞察
    await this.generateMarketingInsights(newPainPoints);
  }
  
  private async updatePainPointPatterns(painPoints: ExtractedPainPoint[]): Promise<void> {
    // 动态更新痛点识别模式
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? ""
    );
    
    for (const painPoint of painPoints) {
      await supabase
        .from("dynamic_pain_patterns")
        .upsert({
          pattern: painPoint.content.substring(0, 100),
          category: painPoint.category,
          frequency: 1,
          confidence: painPoint.confidence,
          last_seen: new Date().toISOString()
        }, {
          onConflict: "pattern",
          ignoreDuplicates: false
        });
    }
  }
}
```

## 📊 真实痛点示例输出

### 从Trustpilot爬取的真实痛点
```javascript
const realPainPointsExample = {
  "fiverr.com": [
    {
      "content": "Ordered a birthday video for my daughter, received it 3 days late and the quality was terrible. The person couldn't even pronounce her name correctly.",
      "rating": 1,
      "platform": "trustpilot",
      "ai_extracted_pain_points": [
        {
          "description": "Late delivery - 3 days delay",
          "category": "delivery_timing",
          "severity": 4,
          "service_stage": "fulfillment"
        },
        {
          "description": "Poor video quality",
          "category": "production_quality", 
          "severity": 3,
          "service_stage": "creation"
        },
        {
          "description": "Incorrect name pronunciation",
          "category": "personalization_accuracy",
          "severity": 3,
          "service_stage": "creation"
        }
      ]
    }
  ]
}
```

这样的动态系统能够：
1. **真实反映市场痛点** - 不依赖硬编码
2. **持续学习优化** - AI驱动的模式识别
3. **多平台数据整合** - Trustpilot、Google Reviews等
4. **自适应分类** - 根据实际数据动态调整

你觉得这个动态痛点提取方案如何？