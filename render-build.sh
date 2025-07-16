#!/bin/bash

echo "🚀 Starting PillowGaming build process..."

# Install all dependencies including devDependencies
echo "📦 Installing all dependencies..."
npm install

# Verify vite is available
if ! command -v npx vite &> /dev/null; then
    echo "⚠️  Vite not found, installing globally..."
    npm install -g vite
fi

# Build frontend
echo "🔨 Building frontend with Vite..."
npx vite build

# Build backend
echo "⚡ Building backend with esbuild..."
npx esbuild server/index.ts --platform=node --packages=external --bundle --format=esm --outdir=dist

# Verify build outputs
if [ ! -d "dist/public" ]; then
    echo "❌ Frontend build failed - dist/public not found"
    exit 1
fi

if [ ! -f "dist/index.js" ]; then
    echo "❌ Backend build failed - dist/index.js not found"
    exit 1
fi

echo "✅ Build completed successfully!"
echo "Frontend: dist/public"
echo "Backend: dist/index.js"