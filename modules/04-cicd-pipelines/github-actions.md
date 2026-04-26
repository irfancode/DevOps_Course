# GitHub Actions

## Basic Workflow

```yaml
name: CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run tests
        run: npm test
```

## Common Actions

```yaml
# Checkout
- uses: actions/checkout@v4

# Node.js
- uses: actions/setup-node@v4
  with:
    node-version: '18'

# Python
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'

# Docker
- uses: docker/setup-buildx-action@v3
- uses: docker/login-action@v3

# AWS
- uses: aws-actions/configure-aws-credentials@v4
```

## Workflow Triggers

```yaml
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * *'
  workflow_dispatch:
  release:
    types: [published]
```

## Variables & Secrets

```yaml
env:
  NODE_VERSION: '18'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo ${{ secrets.API_KEY }}
```

---

**Next: [Jenkins Basics](./jenkins.md)**