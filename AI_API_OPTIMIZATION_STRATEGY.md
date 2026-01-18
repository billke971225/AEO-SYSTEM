# AI API优化策略 - 多引擎架构设计

## 🎯 推荐的AI引擎分配策略

### 1. **Google Gemini API** - 主力引擎 (推荐)

#### 💰 **成本优势**
- Gemini 1.5 Flash: **免费额度每天1500次请求**
- Gemini 1.5 Pro: $0.00125/1K tokens (输入) + $0.005/1K tokens (输出)
- **比GPT-3.5便宜50%，比Claude便宜80%**

#### 🚀 **适用场景**
```javascript
// 1. 痛点分析和提取 (替换OpenAI)
const geminiPainPointAnalysis = {
  model: "gemini-1.5-flash",
  cost: "免费额度内",
  advantages: ["JSON输出稳定", "多语言支持好", "速度快"],
  use_cases: [
    "竞争对手痛点提取",
    "评价情感分析", 
    "痛点分类和评分",
    "关键词提取"
  ]
};

// 2. 多国文化分析 (部分替换Claude)
const geminiCulturalAnalysis = {
  model: "gemini-1.5-pro", 
  cost: "$0.00125/1K tokens",
  advantages: ["长上下文", "多语言文化理解", "成本低"],
  use_cases: [
    "25国文化适应性分析",
    "本地化内容建议",
    "文化敏感性检测",
    "多语言话题生成"
  ]
};

// 3. 结构化数据处理
const geminiDataProcessing = {
  model: "gemini-1.5-flash",
  cost: "免费",
  advantages: ["JSON输出", "批量处理", "速度快"],
  use_cases: [
    "网站内容分析",
    "竞争对手数据提取",
    "SEO关键词分析",
    "市场趋势分析"
  ]
};
```

### 2. **Claude (Enter.pro)** - 高质量内容生成

#### 🎨 **保留用于**
```javascript
const claudeUseCases = {
  model: "claude-sonnet-4.5",
  cost: "较高但值得",
  advantages: ["内容质量最高", "长文本生成", "创意能力强"],
  use_cases: [
    "最终博客内容生成", // 核心功能，质量要求最高
    "复杂的营销策略分析",
    "高质量的节假日内容创作",
    "品牌调性内容优化"
  ]
};
```

### 3. **OpenAI GPT** - 特定推理任务

#### 🧠 **保留用于**
```javascript
const gptUseCases = {
  model: "gpt-3.5-turbo",
  cost: "$0.002/1K tokens", 
  advantages: ["推理能力强", "逻辑分析好", "生态成熟"],
  use_cases: [
    "复杂的逻辑推理分析",
    "AI审计结果的深度诊断",
    "竞争策略的逻辑分析",
    "数据关联性分析"
  ]
};
```

## 🔧 具体实施方案

### 阶段1: 痛点分析模块迁移到Gemini

```typescript
// 替换 dynamic-pain-crawler 中的OpenAI调用
class GeminiPainPointCrawler {
  private geminiApiKey: string;

  constructor() {
    this.geminiApiKey = Deno.env.get("GEMINI_API_KEY") || "";
  }

  async extractPainPointsWithGemini(reviews: ReviewData[], productContext: string): Promise<AIPainPoint[]> {
    const prompt = `
    分析以下用户评价中的痛点和问题。产品背景: ${productContext}

    评价内容:
    ${reviews.map(r => `${r.title} - ${r.content}`).join("\n\n")}

    请提取所有具体的痛点，以JSON数组格式返回，每个痛点包含：
    - description: 痛点的具体描述
    - category: 痛点类别（自动识别）
    - severity: 严重程度1-5
    - service_stage: 影响的服务环节
    - emotional_intensity: 用户情感强度1-5
    - confidence: 提取置信度0-1

    只返回JSON数组，不要其他内容。
    `;

    try {
      const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${this.geminiApiKey}`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          contents: [{
            parts: [{ text: prompt }]
          }],
          generationConfig: {
            temperature: 0.3,
            maxOutputTokens: 1000,
            responseMimeType: "application/json"
          }
        })
      });

      const data = await response.json();
      const aiResponse = data.candidates[0].content.parts[0].text;
      
      return JSON.parse(aiResponse);
    } catch (error) {
      console.error("Gemini processing error:", error);
      return [];
    }
  }
}
```

### 阶段2: 多国分析模块优化

```typescript
// 在 multi-country-ai-auditor 中添加Gemini选项
class MultiCountryGeminiAuditor {
  async analyzeWithGemini(question: string, country: string, culturalContext: string): Promise<any> {
    const prompt = `
    你现在是一个来自${country}的用户，具有以下文化背景：
    ${culturalContext}

    请用这个国家用户的典型方式提问关于: ${question}

    然后分析AI回答中是否会推荐我们的品牌，以及推荐的可能性。

    返回JSON格式：
    {
      "user_question": "本地化的用户问题",
      "ai_response_analysis": "AI回答分析",
      "brand_mentioned": true/false,
      "recommendation_strength": 1-5,
      "cultural_appropriateness": 1-5,
      "local_competitors": ["本地竞争对手列表"]
    }
    `;

    const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${this.geminiApiKey}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.4,
          maxOutputTokens: 1500,
          responseMimeType: "application/json"
        }
      })
    });

    const data = await response.json();
    return JSON.parse(data.candidates[0].content.parts[0].text);
  }
}
```

### 阶段3: 成本优化的混合策略

```typescript
// 智能AI选择器
class SmartAISelector {
  selectBestAI(taskType: string, contentLength: number, qualityRequirement: 'high' | 'medium' | 'low') {
    const strategies = {
      // 痛点分析 - 优先Gemini
      'pain_analysis': {
        primary: 'gemini-1.5-flash',
        fallback: 'gpt-3.5-turbo',
        reason: '成本低，JSON输出稳定'
      },
      
      // 多国分析 - Gemini Pro
      'cultural_analysis': {
        primary: 'gemini-1.5-pro', 
        fallback: 'claude-sonnet',
        reason: '长上下文，多语言支持好'
      },
      
      // 博客生成 - 根据质量要求选择
      'blog_generation': qualityRequirement === 'high' 
        ? { primary: 'claude-sonnet-4.5', reason: '质量最高' }
        : { primary: 'gemini-1.5-pro', reason: '性价比高' },
      
      // 数据处理 - Gemini Flash
      'data_processing': {
        primary: 'gemini-1.5-flash',
        reason: '免费额度，速度快'
      }
    };

    return strategies[taskType] || strategies['data_processing'];
  }
}
```

## 💰 成本对比分析

### 当前成本 (月度估算)
```javascript
const currentCosts = {
  "Enter.pro (Claude)": "$200-400/月", // 主要内容生成
  "OpenAI GPT-3.5": "$20-40/月",      // 痛点分析
  "Google Search": "$5-15/月",        // 搜索API
  "总计": "$225-455/月"
};
```

### 优化后成本 (月度估算)
```javascript
const optimizedCosts = {
  "Gemini 1.5 Flash": "$0/月",        // 免费额度内 (痛点分析)
  "Gemini 1.5 Pro": "$30-60/月",      // 多国分析
  "Claude (Enter.pro)": "$100-200/月", // 仅高质量内容生成
  "GPT-3.5": "$10-20/月",             // 特定推理任务
  "Google Search": "$5-15/月",        // 搜索API
  "总计": "$145-295/月"
};

const savings = {
  "月度节省": "$80-160",
  "年度节省": "$960-1920",
  "节省比例": "35-40%"
};
```

## 🚀 实施建议

### 立即可行的优化
1. **痛点分析迁移到Gemini Flash** - 立即节省$20-40/月
2. **多国分析部分使用Gemini Pro** - 节省$50-100/月
3. **数据处理任务全部用Gemini Flash** - 免费

### 渐进式优化
1. **A/B测试内容质量** - 对比Gemini Pro vs Claude的博客质量
2. **智能路由** - 根据任务复杂度自动选择AI
3. **成本监控** - 实时跟踪各AI的使用成本

### 环境变量配置
```bash
# 添加Gemini API
GEMINI_API_KEY=your_gemini_api_key

# 保留现有的
AI_API_TOKEN_b9832d0e3a3e=your_enter_pro_token  # Claude
OPENAI_API_KEY=your_openai_key                   # GPT
```

## 🎯 总结

**推荐策略**: **Gemini为主，Claude为辅，GPT特定场景**

1. **Gemini 1.5 Flash** - 处理80%的日常AI任务（免费）
2. **Gemini 1.5 Pro** - 处理复杂的多国分析（成本低）
3. **Claude Sonnet** - 仅用于最终博客生成（质量保证）
4. **GPT-3.5** - 特定的逻辑推理任务

这样可以在保证质量的同时，**节省35-40%的AI成本**，每年节省近$1000-2000。