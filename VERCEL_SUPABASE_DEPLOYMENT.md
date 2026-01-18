# Vercel + Supabase 免费部署指南

## 🎯 **部署方案**

```
前端: Vercel Hobby (免费) ✅
后端: Supabase Free (免费) ✅
总成本: $0/月 🎉
```

---

## 🚀 **详细部署步骤**

### **第1步: 部署后端到Supabase**

#### **1.1 创建Supabase项目**
```bash
# 1. 访问 https://supabase.com/dashboard
# 2. 点击 "New Project"
# 3. 填写项目信息：
#    - Name: my-aeo-system
#    - Database Password: 设置强密码
#    - Region: 选择离您最近的区域
# 4. 等待项目创建完成（约2分钟）
```

#### **1.2 获取项目配置信息**
```bash
# 在Supabase Dashboard中获取：
Project URL: https://xxx.supabase.co
Anon Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Service Role Key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### **1.3 本地配置Supabase CLI**
```bash
# 安装Supabase CLI
npm install -g @supabase/cli

# 登录Supabase
supabase login

# 链接到远程项目
supabase link --project-ref YOUR_PROJECT_REF
```

#### **1.4 部署数据库**
```bash
# 推送所有数据库迁移
supabase db push

# 验证部署状态
supabase db status
```

#### **1.5 部署Edge Functions**
```bash
# 部署核心AEO系统
supabase functions deploy aeo-closed-loop-system
supabase functions deploy real-chatgpt-tester
supabase functions deploy dynamic-pain-crawler
supabase functions deploy pain-point-analyzer

# 部署三大模块
supabase functions deploy holiday-monitor
supabase functions deploy holiday-content-generator
supabase functions deploy holiday-scheduler
supabase functions deploy scenario-expander
supabase functions deploy market-validator
supabase functions deploy multi-country-ai-auditor

# 部署用户系统
supabase functions deploy api-key-manager

# 部署内容生成
supabase functions deploy blog-generator
supabase functions deploy simple-image-generator
supabase functions deploy simple-blog-generator
supabase functions deploy simple-website-analyzer

# 部署其他功能
supabase functions deploy ai-citation-optimized-blog-generator
supabase functions deploy human-like-blog-optimizer
supabase functions deploy gemini-cultural-analyzer
supabase functions deploy gemini-pain-analyzer
```

#### **1.6 设置环境变量**
```bash
# 设置AI API密钥
supabase secrets set AI_API_TOKEN_b9832d0e3a3e=your_enter_pro_api_token

# 设置加密密钥（32字符）
supabase secrets set ENCRYPTION_SECRET=your_32_character_encryption_key_here

# 验证环境变量
supabase secrets list
```

---

### **第2步: 部署前端到Vercel**

#### **2.1 准备环境变量**
创建 `.env` 文件：
```env
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
```

#### **2.2 本地测试**
```bash
# 安装依赖
npm install

# 本地运行测试
npm run dev

# 构建测试
npm run build
```

#### **2.3 推送到GitHub**
```bash
# 添加所有文件
git add .

# 提交代码
git commit -m "Deploy AEO system to Vercel"

# 推送到GitHub
git push origin main
```

#### **2.4 部署到Vercel**

**方法1: 使用Vercel CLI（推荐）**
```bash
# 安装Vercel CLI
npm install -g vercel

# 登录Vercel
vercel login

# 部署项目
vercel

# 部署到生产环境
vercel --prod
```

**方法2: 使用Vercel Dashboard**
```bash
# 1. 访问 https://vercel.com/dashboard
# 2. 点击 "New Project"
# 3. 连接GitHub仓库
# 4. 选择您的AEO系统仓库
# 5. 配置构建设置：
#    - Framework Preset: Vite
#    - Build Command: npm run build
#    - Output Directory: dist
# 6. 添加环境变量：
#    - VITE_SUPABASE_URL
#    - VITE_SUPABASE_ANON_KEY
# 7. 点击 "Deploy"
```

---

## 🔧 **配置优化**

### **Vercel配置文件**
创建 `vercel.json`：
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### **环境变量管理**
在Vercel Dashboard中设置：
```
VITE_SUPABASE_URL=https://xxx.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
```

---

## 🧪 **部署后测试**

### **1. 基础功能测试**
```bash
# 访问部署的网站
https://your-project.vercel.app

# 测试用户注册
# 测试用户登录
# 测试API密钥管理
```

### **2. API功能测试**
```bash
# 测试网站分析
curl -X POST https://xxx.supabase.co/functions/v1/simple-website-analyzer \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"website_url": "https://example.com"}'

# 测试图片生成
curl -X POST https://xxx.supabase.co/functions/v1/simple-image-generator \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "professional image", "provider": "openai"}'
```

### **3. 高级功能测试**
- 节假日自动化页面
- 市场扩展页面
- 痛点分析页面
- AI图片生成页面

---

## 📊 **免费额度监控**

### **Vercel使用量**
- Dashboard → Analytics → 查看带宽使用
- 100GB/月限制
- 个人使用通常用不到10GB

### **Supabase使用量**
- Dashboard → Settings → Usage
- 数据库：500MB
- 带宽：2GB/月
- Edge Functions：50万次调用/月

---

## 🚨 **常见问题解决**

### **问题1: Vercel构建失败**
```bash
# 解决方案：检查package.json
npm run build  # 本地测试构建

# 检查Node.js版本
# Vercel默认使用Node.js 18
```

### **问题2: Supabase连接失败**
```bash
# 解决方案：检查环境变量
echo $VITE_SUPABASE_URL
echo $VITE_SUPABASE_ANON_KEY

# 检查Supabase项目状态
supabase status
```

### **问题3: Edge Functions部署失败**
```bash
# 解决方案：逐个部署
supabase functions deploy api-key-manager
supabase functions deploy simple-website-analyzer
# 查看错误日志
```

---

## 🎯 **部署检查清单**

### **Supabase部署检查**
- [ ] 项目创建成功
- [ ] 数据库迁移完成
- [ ] Edge Functions部署成功
- [ ] 环境变量设置完成
- [ ] API测试通过

### **Vercel部署检查**
- [ ] GitHub仓库连接
- [ ] 构建配置正确
- [ ] 环境变量设置
- [ ] 部署成功
- [ ] 网站访问正常

### **功能测试检查**
- [ ] 用户注册/登录
- [ ] API密钥管理
- [ ] 网站分析功能
- [ ] 图片生成功能
- [ ] 博客生成功能
- [ ] 高级AEO功能

---

## 🎉 **部署完成**

### **您将获得：**
- ✅ 完整的AEO系统
- ✅ 全球CDN加速
- ✅ 自动SSL证书
- ✅ GitHub自动部署
- ✅ 专业域名（.vercel.app）
- ✅ 所有高级功能

### **访问地址：**
```
网站: https://your-project.vercel.app
后端: https://xxx.supabase.co
```

### **成本：$0/月**

**这个免费方案完全支持您使用所有AEO功能！**

---

## 🚀 **一键部署脚本**

```bash
#!/bin/bash
# vercel-deploy.sh

echo "🚀 开始部署AEO系统到Vercel + Supabase..."

# 1. 部署后端
echo "☁️ 部署后端到Supabase..."
supabase db push
supabase functions deploy

# 2. 构建前端
echo "🔨 构建前端..."
npm run build

# 3. 部署到Vercel
echo "🌐 部署到Vercel..."
vercel --prod

echo "✅ 部署完成！"
echo "🔗 请在Vercel Dashboard查看部署URL"
```

**运行脚本：**
```bash
chmod +x vercel-deploy.sh
./vercel-deploy.sh
```