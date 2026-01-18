# 🚀 完整AEO系统 - AI引擎优化平台

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fbillke971225%2FAEO-SYSTEM&env=VITE_SUPABASE_URL,VITE_SUPABASE_ANON_KEY&envDescription=Supabase%20configuration%20required&envLink=https%3A%2F%2Fsupabase.com%2Fdashboard%2Fproject%2Funvtsbaximmlsephxkit%2Fsettings%2Fapi)

## 📋 **项目概述**

这是一个完整的AI引擎优化（AEO）平台，专为提升网站在AI搜索引擎中的排名而设计。

### **🎯 核心功能**
- 🔐 **多用户认证系统** - 安全的用户管理
- 🔑 **API密钥管理** - AES-256加密存储
- 🌐 **网站分析** - 智能网站内容分析
- 🖼️ **AI图片生成** - OpenAI DALL-E 3集成
- 📝 **AI博客生成** - GPT-3.5优化博客创建
- 📊 **数据管理** - 完整的使用统计和历史记录
- 💰 **成本控制** - 实时成本追踪和限制

### **🚀 高级AEO功能**
- 📅 **节假日自动化** - 25+国家节假日监控
- 🎯 **市场扩展** - 场景发现和验证
- 🔍 **痛点分析** - 动态竞争对手痛点爬取
- 🤖 **真实ChatGPT测试** - 不是模拟，是真实API调用
- 🔄 **AEO闭环优化** - 完整的优化循环

---

## 🏗️ **技术架构**

### **前端**
- ⚛️ React 19 + TypeScript
- 🎨 Tailwind CSS + Shadcn/ui
- 🔄 React Query + React Router
- 📱 响应式设计

### **后端**
- ☁️ Supabase (数据库 + 认证 + Edge Functions)
- 🔐 Row Level Security (RLS)
- 🔑 AES-256 API密钥加密
- 📊 实时数据同步

### **AI集成**
- 🤖 OpenAI GPT-3.5-turbo (博客生成)
- 🖼️ OpenAI DALL-E 3 (图片生成)
- 🧠 真实ChatGPT API测试
- 🌍 多国文化适配

---

## 🚀 **快速部署**

### **方法1: 一键部署（推荐）**

点击上方的 "Deploy with Vercel" 按钮，然后：

1. **登录Vercel**（用GitHub账户）
2. **配置环境变量**：
   ```
   VITE_SUPABASE_URL=https://unvtsbaximmlsephxkit.supabase.co
   VITE_SUPABASE_ANON_KEY=sb_publishable_6IFP4KlnPJtp2XISOKZX3w_uhBxJa6r
   ```
3. **点击Deploy** - 完成！

### **方法2: 手动部署**

1. **Fork此仓库**
2. **在Vercel中导入项目**
3. **设置构建配置**：
   - Framework: Vite
   - Install Command: `npm install --legacy-peer-deps`
   - Build Command: `npm run build`
   - Output Directory: `dist`
4. **添加环境变量**
5. **部署**

### **成本**: $0/月 (免费额度内)

---

## 🔧 **开发指南**

### **本地开发**
```bash
# 安装依赖
npm install --legacy-peer-deps

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build
```

### **环境变量**
创建 `.env` 文件：
```env
VITE_SUPABASE_URL=https://unvtsbaximmlsephxkit.supabase.co
VITE_SUPABASE_ANON_KEY=sb_publishable_6IFP4KlnPJtp2XISOKZX3w_uhBxJa6r
```

---

## 📊 **系统功能模块**

### **🔐 用户系统**
- 用户注册/登录
- 邮箱验证
- 密码重置
- 用户配置管理

### **🔑 API密钥管理**
- 安全加密存储
- 多服务商支持 (OpenAI, Gemini等)
- 使用统计追踪
- 成本控制

### **🌐 网站分析**
- HTML结构分析
- SEO元素提取
- 内容关键词检测
- 竞争对手分析

### **🖼️ AI图片生成**
- DALL-E 3集成
- 多种风格选择
- 自定义尺寸
- 成本追踪

### **📝 AI博客生成**
- GPT-3.5优化
- SEO友好内容
- 多种写作风格
- 字数控制

---

## 🎯 **高级AEO功能**

### **模块1: 节假日自动化**
- 25+国家节假日监控
- 自动内容生成
- 定时发布调度
- 效果追踪

### **模块2: 市场扩展**
- 场景发现引擎
- 需求验证系统
- 用户选择界面
- AI推荐算法

### **模块3: 自动话题生成**
- 基于痛点的话题生成
- 多国AI测试
- 效果评估
- 持续优化

### **AEO闭环优化**
- 真实ChatGPT测试
- 竞争对手分析
- 痛点数据爬取
- 博客优化生成
- 发布效果监控
- 持续改进循环

---

## 🔐 **安全特性**

- ✅ JWT身份验证
- ✅ Row Level Security (RLS)
- ✅ AES-256 API密钥加密
- ✅ 用户数据完全隔离
- ✅ 请求验证和限制
- ✅ 错误处理和日志记录

---

## 💰 **成本控制**

### **免费额度**
- **Vercel**: 100GB带宽/月
- **Supabase**: 500MB数据库 + 2GB带宽/月
- **预期使用**: <10GB带宽 + <50MB数据库

### **AI API成本**
- **图片生成**: ~$0.04/张 (DALL-E 3)
- **博客生成**: ~$0.002/1000字 (GPT-3.5)
- **月度预算**: $10-50 (个人使用)

---

## 📄 **许可证**

MIT License - 详见 [LICENSE](LICENSE) 文件

---

**🚀 开始使用您的AI引擎优化平台！**