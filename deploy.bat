@echo off
echo 🚀 开始部署完整AEO系统...
echo 📋 项目信息:
echo    - Supabase项目ID: unvtsbaximmlsephxkit
echo    - 项目URL: https://unvtsbaximmlsephxkit.supabase.co
echo.

REM 检查必要工具
echo 🔍 检查部署工具...

where npm >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ npm未安装，请先安装Node.js
    pause
    exit /b 1
)

where supabase >nul 2>nul
if %errorlevel% neq 0 (
    echo 📦 安装Supabase CLI...
    npm install -g @supabase/cli
)

where vercel >nul 2>nul
if %errorlevel% neq 0 (
    echo 📦 安装Vercel CLI...
    npm install -g vercel
)

echo ✅ 工具检查完成
echo.

REM 检查环境变量
echo 🔧 检查环境变量...
if not exist ".env" (
    echo ❌ .env文件不存在
    pause
    exit /b 1
)

findstr "需要从您的Supabase Dashboard获取" .env >nul
if %errorlevel% equ 0 (
    echo ⚠️  请先配置.env文件中的VITE_SUPABASE_ANON_KEY
    echo    1. 访问: https://supabase.com/dashboard/project/unvtsbaximmlsephxkit/settings/api
    echo    2. 复制anon public密钥到.env文件
    echo    3. 重新运行此脚本
    pause
    exit /b 1
)

echo ✅ 环境变量检查完成
echo.

REM 构建前端
echo 🔨 构建前端应用...
npm run build

if %errorlevel% neq 0 (
    echo ❌ 前端构建失败
    pause
    exit /b 1
)

echo ✅ 前端构建成功
echo.

REM 部署到Supabase
echo ☁️  部署后端到Supabase...

REM 检查是否已登录
supabase projects list >nul 2>nul
if %errorlevel% neq 0 (
    echo 🔐 请登录Supabase...
    supabase login
)

REM 链接项目
echo 🔗 链接Supabase项目...
supabase link --project-ref unvtsbaximmlsephxkit

REM 部署数据库
echo 🗄️  部署数据库...
supabase db push

if %errorlevel% neq 0 (
    echo ❌ 数据库部署失败
    pause
    exit /b 1
)

REM 设置环境变量
echo 🔑 设置Supabase环境变量...
echo 请输入32字符的加密密钥（用于API密钥加密）:
set /p ENCRYPTION_SECRET=

supabase secrets set ENCRYPTION_SECRET=%ENCRYPTION_SECRET%

REM 部署Edge Functions
echo ⚡ 部署Edge Functions...
supabase functions deploy api-key-manager
supabase functions deploy simple-website-analyzer
supabase functions deploy simple-image-generator
supabase functions deploy simple-blog-generator

echo ✅ 后端部署完成
echo.

REM 部署到Vercel
echo 🌐 部署前端到Vercel...

REM 检查是否已登录
vercel whoami >nul 2>nul
if %errorlevel% neq 0 (
    echo 🔐 请登录Vercel...
    vercel login
)

REM 部署项目
vercel --prod

if %errorlevel% neq 0 (
    echo ❌ Vercel部署失败
    pause
    exit /b 1
)

echo.
echo 🎉 部署完成！
echo.
echo 📋 部署信息:
echo    - 前端: 请查看Vercel输出的URL
echo    - 后端: https://unvtsbaximmlsephxkit.supabase.co
echo    - 管理面板: https://supabase.com/dashboard/project/unvtsbaximmlsephxkit
echo.
echo 🧪 下一步:
echo    1. 访问前端网站测试注册/登录
echo    2. 添加OpenAI API密钥
echo    3. 测试图片和博客生成功能
echo.
echo 💰 成本: $0/月 (免费额度内)
echo 🎯 您的完整AEO系统已准备就绪！
pause