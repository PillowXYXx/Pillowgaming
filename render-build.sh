#!/bin/bash

echo "🚀 Starting PillowGaming build process..."

# Install all dependencies including devDependencies
echo "📦 Installing all dependencies..."
npm install

# Verify vite is available and install if needed
echo "🔍 Checking vite installation..."
if ! npx vite --version &> /dev/null; then
    echo "⚠️  Vite not working, installing globally..."
    npm install -g vite@latest
fi

# Set NODE_ENV for build
export NODE_ENV=production

# Build frontend with explicit config
echo "🔨 Building frontend with Vite..."
npx vite build --config vite.config.ts

# Build backend
echo "⚡ Building backend with esbuild..."
npx esbuild server/index.ts --platform=node --packages=external --bundle --format=esm --outdir=dist

# Check what was actually built
echo "📁 Checking build outputs..."
ls -la dist/ || echo "No dist directory found"
find . -name "index.html" -type f | head -5

# Verify build outputs exist (check multiple possible locations)
if [ ! -d "dist/public" ] && [ ! -f "dist/index.html" ] && [ ! -d "client/dist" ]; then
    echo "❌ Frontend build failed - no frontend build found"
    echo "Expected: dist/public/ or dist/index.html or client/dist/"
    exit 1
fi

if [ ! -f "dist/index.js" ]; then
    echo "❌ Backend build failed - dist/index.js not found"
    exit 1
fi

echo "✅ Build completed successfully!"
echo "Frontend: dist/public"
echo "Backend: dist/index.js"