#!/bin/bash

# 🚀 AEO系统一键部署脚本
# 使用方法: chmod +x deploy.sh && ./deploy.sh

echo "🚀 开始部署完整AEO系统..."
echo "📋 项目信息:"
echo "   - Supabase项目ID: unvtsbaximmlsephxkit"
echo "   - 项目URL: https://unvtsbaximmlsephxkit.supabase.co"
echo ""

# 检查必要工具
echo "🔍 检查部署工具..."

if ! command -v npm &> /dev/null; then
    echo "❌ npm未安装，请先安装Node.js"
    exit 1
fi

if ! command -v supabase &> /dev/null; then
    echo "📦 安装Supabase CLI..."
    npm install -g @supabase/cli
fi

if ! command -v vercel &> /dev/null; then
    echo "📦 安装Vercel CLI..."
    npm install -g vercel
fi

echo "✅ 工具检查完成"
echo ""

# 检查环境变量
echo "🔧 检查环境变量..."
if [ ! -f ".env" ]; then
    echo "❌ .env文件不存在"
    exit 1
fi

if grep -q "需要从您的Supabase Dashboard获取" .env; then
    echo "⚠️  请先配置.env文件中的VITE_SUPABASE_ANON_KEY"
    echo "   1. 访问: https://supabase.com/dashboard/project/unvtsbaximmlsephxkit/settings/api"
    echo "   2. 复制anon public密钥到.env文件"
    echo "   3. 重新运行此脚本"
    exit 1
fi

echo "✅ 环境变量检查完成"
echo ""

# 构建前端
echo "🔨 构建前端应用..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ 前端构建失败"
    exit 1
fi

echo "✅ 前端构建成功"
echo ""

# 部署到Supabase
echo "☁️  部署后端到Supabase..."

# 检查是否已登录
if ! supabase projects list &> /dev/null; then
    echo "🔐 请登录Supabase..."
    supabase login
fi

# 链接项目
echo "🔗 链接Supabase项目..."
supabase link --project-ref unvtsbaximmlsephxkit

# 部署数据库
echo "🗄️  部署数据库..."
supabase db push

if [ $? -ne 0 ]; then
    echo "❌ 数据库部署失败"
    exit 1
fi

# 设置环境变量
echo "🔑 设置Supabase环境变量..."
echo "请输入32字符的加密密钥（用于API密钥加密）:"
read -s ENCRYPTION_SECRET

if [ ${#ENCRYPTION_SECRET} -ne 32 ]; then
    echo "❌ 加密密钥必须是32字符"
    exit 1
fi

supabase secrets set ENCRYPTION_SECRET=$ENCRYPTION_SECRET

# 部署Edge Functions
echo "⚡ 部署Edge Functions..."
supabase functions deploy api-key-manager
supabase functions deploy simple-website-analyzer  
supabase functions deploy simple-image-generator
supabase functions deploy simple-blog-generator

echo "✅ 后端部署完成"
echo ""

# 部署到Vercel
echo "🌐 部署前端到Vercel..."

# 检查是否已登录
if ! vercel whoami &> /dev/null; then
    echo "🔐 请登录Vercel..."
    vercel login
fi

# 部署项目
vercel --prod

if [ $? -ne 0 ]; then
    echo "❌ Vercel部署失败"
    exit 1
fi

echo ""
echo "🎉 部署完成！"
echo ""
echo "📋 部署信息:"
echo "   - 前端: 请查看Vercel输出的URL"
echo "   - 后端: https://unvtsbaximmlsephxkit.supabase.co"
echo "   - 管理面板: https://supabase.com/dashboard/project/unvtsbaximmlsephxkit"
echo ""
echo "🧪 下一步:"
echo "   1. 访问前端网站测试注册/登录"
echo "   2. 添加OpenAI API密钥"
echo "   3. 测试图片和博客生成功能"
echo ""
echo "💰 成本: $0/月 (免费额度内)"
echo "🎯 您的完整AEO系统已准备就绪！"