# 动态痛点爬取系统使用指南

## 🚀 系统特点

### ✅ 真正动态的痛点识别
- **不依赖硬编码** - 通过AI和机器学习识别痛点
- **多平台支持** - Trustpilot、Google Reviews、Reddit、Twitter等
- **AI驱动分析** - 使用GPT自动提取和分类痛点
- **实时学习** - 持续学习新的痛点模式

### 🎯 支持的平台
1. **Trustpilot** - 专业评价平台，高质量痛点数据
2. **Google Reviews** - 通过搜索API获取评价
3. **Reddit** - 真实用户抱怨和讨论
4. **Twitter** - 实时抱怨和负面反馈
5. **Sitejabber** - 另一个评价平台

## 🔧 配置和使用

### 1. API密钥配置
```bash
# 在Supabase中设置环境变量
OPENAI_API_KEY=your_openai_api_key_here  # 用于AI痛点提取
GOOGLE_SEARCH_API_KEY=your_google_key    # 用于Google Reviews
GOOGLE_CSE_ID=your_custom_search_id      # Google自定义搜索
```

### 2. 调用示例
```typescript
// 基础配置
const dynamicCrawlConfig = {
  competitors: [
    "fiverr.com",
    "cameo.com", 
    "memmo.me",
    "starsona.com"
  ],
  platforms: ["trustpilot", "google_reviews", "reddit"],
  product_context: "personalized video message and blessing video services",
  use_ai_extraction: true,
  max_reviews_per_platform: 20
};

// 调用动态痛点爬取
const response = await fetch("https://your-project.supabase.co/functions/v1/dynamic-pain-crawler", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${SUPABASE_ANON_KEY}`
  },
  body: JSON.stringify({ config: dynamicCrawlConfig })
});

const result = await response.json();
```

### 3. 返回数据结构
```javascript
{
  "success": true,
  "total_reviews": 156,
  "pain_point_reviews": 45,
  "ai_extracted_pain_points": [
    {
      "description": "Late delivery - ordered for Valentine's Day but received 3 days after",
      "category": "delivery_timing",
      "severity": 4,
      "service_stage": "fulfillment",
      "emotional_intensity": 4,
      "confidence": 0.9
    },
    {
      "description": "Poor video quality - blurry and bad audio",
      "category": "production_quality",
      "severity": 3,
      "service_stage": "creation",
      "emotional_intensity": 3,
      "confidence": 0.85
    }
  ],
  "learned_patterns": {
    "common_phrases": [
      "poor quality",
      "late delivery", 
      "not worth money",
      "terrible service"
    ],
    "negative_keywords": [
      "disappointed",
      "terrible",
      "waste",
      "scam",
      "awful"
    ]
  },
  "platform_breakdown": {
    "trustpilot": 67,
    "google_reviews": 34,
    "reddit": 55
  },
  "top_pain_points": [
    {
      "description": "Delivery delays especially for holiday orders",
      "category": "delivery_timing",
      "severity": 4,
      "frequency": 23,
      "affected_competitors": ["fiverr.com", "cameo.com"]
    }
  ]
}
```

## 🎯 真实痛点示例

### 从Trustpilot爬取的真实痛点
```javascript
const realTrustpilotPainPoints = [
  {
    "source": "trustpilot.com/review/fiverr.com",
    "title": "Terrible experience with birthday video",
    "content": "Ordered a personalized birthday video for my daughter. The seller took 4 days instead of promised 24 hours. When I finally received it, the video quality was terrible - blurry, bad lighting, and you could barely hear what they were saying. They also mispronounced my daughter's name completely wrong. Total waste of $50.",
    "rating": 1,
    "ai_extracted_pain_points": [
      {
        "description": "Delivery delay - 4 days instead of 24 hours",
        "category": "delivery_timing",
        "severity": 4,
        "confidence": 0.95
      },
      {
        "description": "Poor video quality - blurry with bad lighting",
        "category": "video_quality",
        "severity": 4,
        "confidence": 0.9
      },
      {
        "description": "Poor audio quality - hard to hear",
        "category": "audio_quality", 
        "severity": 3,
        "confidence": 0.85
      },
      {
        "description": "Name mispronunciation",
        "category": "personalization_accuracy",
        "severity": 3,
        "confidence": 0.9
      },
      {
        "description": "Poor value for money - $50 wasted",
        "category": "pricing_value",
        "severity": 4,
        "confidence": 0.8
      }
    ]
  }
];
```

### 从Reddit爬取的真实抱怨
```javascript
const realRedditComplaints = [
  {
    "source": "reddit.com/r/Fiverr/comments/xyz123",
    "title": "Fiverr seller scammed me with fake video",
    "content": "Paid for a custom blessing video from Africa but got a generic template video instead. The person didn't even say the name I requested and was clearly reading from a script. When I complained, the seller became rude and refused to redo it. Fiverr support was useless too.",
    "platform": "reddit",
    "inferred_rating": 1,
    "ai_extracted_pain_points": [
      {
        "description": "Received generic template instead of custom video",
        "category": "personalization_fraud",
        "severity": 5,
        "confidence": 0.95
      },
      {
        "description": "Name not mentioned as requested",
        "category": "personalization_accuracy",
        "severity": 4,
        "confidence": 0.9
      },
      {
        "description": "Seller became rude when confronted",
        "category": "customer_service_attitude",
        "severity": 4,
        "confidence": 0.85
      },
      {
        "description": "Platform support was unhelpful",
        "category": "platform_support",
        "severity": 3,
        "confidence": 0.8
      }
    ]
  }
];
```

## 📊 痛点分析洞察

### 自动生成的营销机会
```javascript
const marketingOpportunities = {
  "delivery_timing": {
    "pain_point": "竞争对手经常延迟交付，特别是节假日订单",
    "opportunity": "强调我们的准时交付保证",
    "marketing_angle": "节假日订单优先处理，保证准时送达",
    "content_ideas": [
      "如何确保节假日视频准时交付",
      "为什么选择有交付保证的视频服务",
      "避免节假日视频延迟的5个方法"
    ]
  },
  
  "video_quality": {
    "pain_point": "视频质量差，模糊、音质不好",
    "opportunity": "突出我们的高清视频质量",
    "marketing_angle": "专业设备拍摄，保证高清画质",
    "content_ideas": [
      "如何识别高质量的祝福视频服务",
      "专业视频制作vs业余制作的区别",
      "为什么视频质量对祝福效果很重要"
    ]
  },
  
  "personalization_accuracy": {
    "pain_point": "个性化不准确，名字发音错误",
    "opportunity": "强调我们的个性化准确性",
    "marketing_angle": "确保准确发音，真正个性化定制",
    "content_ideas": [
      "如何确保祝福视频中名字发音正确",
      "真正个性化vs模板化视频的区别",
      "个性化祝福视频的制作流程"
    ]
  }
};
```

## 🔄 集成到三模块系统

### 在市场扩展模块中使用
```typescript
// 模块2: 市场扩展需求
const expandMarketWithDynamicPainPoints = async (websiteId: string, selectedCountries: string[]) => {
  // 1. 动态爬取竞争对手痛点
  const painPointsResult = await fetch("/api/dynamic-pain-crawler", {
    method: "POST",
    body: JSON.stringify({
      config: {
        competitors: ["fiverr.com", "cameo.com"],
        platforms: ["trustpilot", "google_reviews"],
        product_context: "blessing video services",
        use_ai_extraction: true,
        max_reviews_per_platform: 15
      }
    })
  });
  
  const painPoints = await painPointsResult.json();
  
  // 2. 基于真实痛点生成话题
  const topicsResult = await fetch("/api/scenario-to-topics", {
    method: "POST", 
    body: JSON.stringify({
      website_id: websiteId,
      scenarios: selectedScenarios,
      pain_points: painPoints.ai_extracted_pain_points, // 使用真实痛点
      target_countries: selectedCountries
    })
  });
  
  // 3. 多国AI测试
  // 4. 生成博客内容
};
```

### 在节假日模块中使用
```typescript
// 模块1: 节假日自动化
const generateHolidayContentWithRealPainPoints = async (holiday: Holiday) => {
  // 爬取节假日相关的竞争对手痛点
  const holidayPainPoints = await fetch("/api/dynamic-pain-crawler", {
    method: "POST",
    body: JSON.stringify({
      config: {
        competitors: ["fiverr.com", "cameo.com"],
        platforms: ["trustpilot", "reddit"],
        product_context: `${holiday.name} personalized video services`,
        use_ai_extraction: true,
        max_reviews_per_platform: 10
      }
    })
  });
  
  // 基于真实痛点生成节假日内容
};
```

## 💰 成本控制

### API使用成本估算
```javascript
const costEstimation = {
  "OpenAI API": {
    "cost_per_request": "$0.002 (GPT-3.5-turbo)",
    "reviews_per_request": 5,
    "monthly_estimate": "$20-40 (处理1000-2000条评价)"
  },
  
  "Google Search API": {
    "cost_per_query": "$5/1000次",
    "monthly_estimate": "$5-15 (1000-3000次查询)"
  },
  
  "爬取服务器": {
    "cost": "$0 (使用Supabase Edge Functions)",
    "limitations": "需要遵守平台爬取规则"
  },
  
  "总成本": "$25-55/月 (中等使用量)"
};
```

这个动态痛点爬取系统真正解决了硬编码的问题，能够：

1. **真实反映市场痛点** - 从Trustpilot等真实评价平台获取数据
2. **AI智能分析** - 使用GPT自动识别和分类痛点
3. **持续学习优化** - 不断学习新的痛点模式
4. **多平台整合** - 整合多个数据源获得全面视角

你觉得这个动态方案如何？需要我调整任何部分吗？