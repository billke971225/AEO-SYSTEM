# 多用户认证系统部署指南

## 🎯 **完成状态**

✅ **用户认证系统** - 完整的登录/注册功能
✅ **API密钥管理** - 加密存储和管理用户API密钥
✅ **数据隔离** - 每个用户只能访问自己的数据
✅ **AI图片生成器集成** - 支持用户认证的图片生成
✅ **前端界面** - 完整的多用户管理界面
✅ **数据库架构** - 完整的RLS策略和用户隔离

---

## 🚀 **部署步骤**

### **1. 数据库迁移**

按顺序运行以下迁移文件：

```bash
# 1. 基础多用户认证表
supabase/migrations/20260117000007_multi_user_auth_system.sql

# 2. 用户使用统计函数
supabase/migrations/20260117000008_user_usage_functions.sql
```

### **2. Edge Functions部署**

部署API密钥管理函数：

```bash
# 部署API密钥管理器
supabase functions deploy api-key-manager

# 部署AI图片生成器（已更新支持用户认证）
supabase functions deploy ai-image-generator
```

### **3. 环境变量配置**

创建 `.env` 文件：

```env
# Supabase配置
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# 加密密钥（32字符）
ENCRYPTION_SECRET=your_32_character_encryption_secret

# 外部API配置（可选，用户可以自己添加）
OPENAI_API_KEY=your_openai_key
GEMINI_API_KEY=your_gemini_key
NANEBANAEN_API_URL=your_nanebanaen_url
CLOUDINARY_CLOUD_NAME=your_cloudinary_name
```

### **4. 前端部署**

```bash
# 安装依赖
npm install

# 构建项目
npm run build

# 部署到您的托管平台
npm run deploy
```

---

## 🔐 **安全配置**

### **API密钥加密**

系统使用AES-256加密存储用户API密钥：

```typescript
// 加密过程
const encryptedKey = await keyManager.encryptAPIKey(userApiKey);

// 解密过程（仅在使用时）
const decryptedKey = await keyManager.decryptAPIKey(encryptedKey);
```

### **行级安全策略**

所有用户数据表都启用了RLS：

```sql
-- 用户只能访问自己的数据
CREATE POLICY "用户访问自己的API密钥" ON user_api_keys
FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "用户访问自己的图片" ON generated_images
FOR ALL USING (auth.uid() = user_id);
```

---

## 🎨 **使用流程**

### **用户注册/登录**

1. 访问 `/multi-user` 路由
2. 新用户注册或现有用户登录
3. 系统自动创建用户配置文件

### **API密钥配置**

1. 登录后进入"API密钥"标签
2. 添加各种服务的API密钥：
   - OpenAI (GPT, DALL-E)
   - Google Gemini
   - Nanebanaen (Stable Diffusion)
   - Cloudinary (图片处理)

### **图片生成**

1. 配置API密钥后
2. 调用AI图片生成器
3. 系统自动使用用户的API密钥
4. 记录使用统计和成本

---

## 📊 **数据库架构**

### **核心表结构**

```sql
-- 用户配置表
user_profiles (id, email, full_name, company_name, website_url)

-- API密钥表（加密存储）
user_api_keys (user_id, api_provider, api_key_encrypted, usage_count)

-- 用户品牌设置
user_brand_settings (user_id, brand_name, logo_url, watermark_settings)

-- 使用统计表
user_usage_stats (user_id, date, images_generated, total_cost)

-- 审计日志
user_audit_logs (user_id, action_type, action_details, created_at)
```

### **存储桶配置**

```sql
-- 用户上传文件
user-uploads/[user_id]/[filename]

-- 处理后的图片
processed-images/[user_id]/[filename]
```

---

## 🔧 **API使用示例**

### **添加API密钥**

```javascript
const response = await fetch('/functions/v1/api-key-manager', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${userToken}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    action: 'store',
    provider: 'openai',
    api_key: 'sk-...',
    key_name: '我的OpenAI密钥'
  })
});
```

### **生成AI图片**

```javascript
const response = await fetch('/functions/v1/ai-image-generator', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${userToken}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    topic: '人工智能发展趋势',
    image_suggestions: [
      {
        type: 'infographic',
        description: 'AI发展时间线图表',
        alt_text: 'AI发展历程信息图',
        caption: '人工智能技术发展重要节点'
      }
    ],
    generation_method: 'gemini_nanebanaen',
    quality_level: 'high'
  })
});
```

---

## 📈 **使用限制和成本控制**

### **默认限制**

- 每月图片生成：1000张
- 每月成本限制：$50
- 存储空间：1GB

### **成本追踪**

系统自动追踪每个用户的：
- API调用次数
- 图片生成数量
- 月度成本
- 存储使用量

---

## 🔍 **监控和日志**

### **用户操作审计**

所有用户操作都会记录：
- 登录/登出
- API密钥添加/删除
- 图片生成
- 成本消费

### **使用统计**

用户可以查看：
- 月度使用统计
- 成本分析
- API调用历史
- 生成内容历史

---

## 🛠️ **故障排除**

### **常见问题**

1. **API密钥解密失败**
   - 检查 `ENCRYPTION_SECRET` 环境变量
   - 确保密钥长度至少32字符

2. **用户认证失败**
   - 检查Supabase配置
   - 验证JWT令牌有效性

3. **RLS策略阻止访问**
   - 确保用户已登录
   - 检查数据库策略配置

### **调试命令**

```sql
-- 检查用户API密钥
SELECT api_provider, is_active, usage_count 
FROM user_api_keys 
WHERE user_id = 'user-uuid';

-- 检查使用统计
SELECT * FROM user_usage_stats 
WHERE user_id = 'user-uuid' 
ORDER BY date DESC;
```

---

## 🎉 **完成！**

现在您有了一个完整的多用户AI博客生成系统：

✅ **安全的用户认证**
✅ **加密的API密钥存储**
✅ **完整的数据隔离**
✅ **用户友好的界面**
✅ **成本控制和监控**
✅ **审计日志和统计**

每个用户都可以安全地管理自己的API密钥和生成内容，系统确保数据完全隔离和安全！