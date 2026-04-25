# Lab 4: Build Your First Pipeline 🚀

Time: 90 minutes | Difficulty: Intermediate

## Overview

You'll create a complete CI/CD pipeline for a Node.js application using GitHub Actions.

## Part 1: Create the Application

```bash
mkdir ~/my-cicd-app
cd ~/my-cicd-app

# Initialize Git
git init
git config user.email "demo@devops.course"
git config user.name "DevOps Student"

# Create package.json
cat > package.json << 'EOF'
{
  "name": "my-cicd-app",
  "version": "1.0.0",
  "description": "CI/CD Demo Application",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "jest --coverage",
    "lint": "eslint ."
  },
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "eslint": "^8.56.0"
  }
}
EOF

# Create the app
cat > index.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

let items = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
];

app.get('/api/items', (req, res) => {
  res.json(items);
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});

module.exports = app;
EOF

# Create tests
mkdir __tests__
cat > __tests__/app.test.js << 'EOF'
const app = require('../index.js');

describe('API Tests', () => {
  test('health endpoint returns healthy', async () => {
    const response = await fetch('http://localhost:3001/health');
    const data = await response.json();
    expect(data.status).toBe('healthy');
  });
});
EOF

cat > jest.config.js << 'EOF'
module.exports = {
  testEnvironment: 'node',
  testMatch: ['**/__tests__/**/*.test.js'],
  coverageDirectory: 'coverage',
  collectCoverageFrom: ['*.js']
};
EOF

cat > .eslintrc.json << 'EOF'
{
  "env": { "node": true, "es2022": true },
  "extends": "eslint:recommended",
  "rules": {
    "no-unused-vars": "warn"
  }
}
EOF

cat > .gitignore << 'EOF'
node_modules/
coverage/
.env
*.log
EOF
```

---

## Part 2: Create Basic CI Pipeline

```bash
mkdir -p .github/workflows

cat > .github/workflows/ci.yml << 'EOF'
name: CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Lint
        run: npm run lint
        
      - name: Run tests
        run: npm test
EOF
```

---

## Part 3: Add Docker Build

```bash
cat > .github/workflows/docker.yml << 'EOF'
name: Docker Build

on:
  push:
    branches: [ main ]
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Build image
        run: |
          docker build -t myapp:${{ github.sha }} .
          docker build -t myapp:latest .
          
      - name: Test container
        run: |
          docker run -d --name test-app -p 3000:3000 myapp:latest
          sleep 5
          curl http://localhost:3000/health
          docker stop test-app
          docker rm test-app
EOF

cat > Dockerfile << 'EOF'
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
ENV PORT=3000
CMD ["node", "index.js"]
EOF
```

---

## Part 4: Add Deployment Pipeline

```bash
cat > .github/workflows/deploy.yml << 'EOF'
name: Deploy to Server

on:
  push:
    branches: [ main ]
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment'
        required: true
        default: 'staging'

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.environment || 'staging' }}
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to ${{ github.event.inputs.environment || 'staging' }}
        run: |
          echo "Deploying version ${{ github.sha }}"
          echo "Environment: ${{ github.event.inputs.environment || 'staging' }}"
          # In real life, you'd SSH to server or use deployment tool
          echo "Deployment complete!"
EOF
```

---

## Part 5: Add Artifact Passing

```bash
cat > .github/workflows/full-pipeline.yml << 'EOF'
name: Full CI/CD Pipeline

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.version.outputs.ver }}
    steps:
      - uses: actions/checkout@v4
      
      - id: version
        run: echo "ver=$(date +%Y%m%d-%H%M%S)" >> $GITHUB_OUTPUT
      
      - name: Create build info
        run: |
          echo "${{ steps.version.outputs.ver }}" > build-info.txt
          
      - name: Upload build info
        uses: actions/upload-artifact@v4
        with:
          name: build-info
          path: build-info.txt

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: npm ci
      - run: npm test

  deploy:
    needs: [build, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Download build info
        uses: actions/download-artifact@v4
        with:
          name: build-info
          
      - name: Deploy
        run: |
          echo "Building with version $(cat build-info.txt)"
          echo "Deployment successful!"
EOF
```

---

## Part 6: Push to GitHub

```bash
# Create initial commit
git add .
git commit -m "Initial commit: Node.js app with CI/CD pipeline"

# Create main branch
git branch -M main

# Create repo on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/my-cicd-app.git
git push -u origin main
```

View your Actions tab on GitHub to see your pipeline running!

---

## Part 7: Explore (Challenge)

Try adding these to your pipeline:
1. A matrix strategy for multiple Node versions
2. Caching for Docker layers
3. Slack/Discord notifications
4. Automatic deployment to a free service (Railway, Render, etc.)

---

## Cleanup

```bash
cd ~
rm -rf ~/my-cicd-app
```

---

## What You Learned

- ✅ Creating GitHub Actions workflows
- ✅ Automated testing
- ✅ Docker builds in CI
- ✅ Artifact passing between jobs
- ✅ Environment-based deployments
- ✅ Manual workflow triggers

---

**Lab Complete! 🎉**

Next: [Module 5: Cloud Fundamentals (AWS)](../05-cloud-aws/README.md)