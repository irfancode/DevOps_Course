# Module 4: CI/CD Pipelines

## Learning Objectives

By the end of this module, you will:
- ✅ Understand CI/CD concepts
- ✅ Build pipelines with GitHub Actions
- ✅ Implement automated testing
- ✅ Deploy to cloud platforms
- ✅ Use secrets and environments

## What is CI/CD?

### CI (Continuous Integration)
Developers merge code changes frequently (multiple times daily). Each merge triggers automated tests.

### CD (Continuous Delivery/Deployment)
Code changes are automatically prepared for release to production.

```
┌─────────────────────────────────────────────────────────────────┐
│                        CI/CD Pipeline                          │
│                                                               │
│   ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌─────────┐│
│   │  Code    │───▶│  Build   │───▶│   Test   │───▶│  Deploy ││
│   │  Commit  │    │          │    │          │    │         ││
│   └──────────┘    └──────────┘    └──────────┘    └─────────┘│
│        │                                           │         │
│   Pre-commit                              ┌────────┴────────┐ │
│   checks                                  ▼                 ▼ │
│                                       Staging            Prod │
│                                                           │   │
│                                              (Continuous Delivery)
└─────────────────────────────────────────────────────────────────┘
```

## CI/CD Benefits

| Before CI/CD | After CI/CD |
|--------------|-------------|
| Manual deployments | Automated one-click deploys |
| "Works on my machine" | Consistent environments |
| Weeks between releases | Multiple deploys per day |
| Fear of changes | Confidence in changes |
| Hard to rollback | Easy rollbacks |

## GitHub Actions

GitHub Actions is GitHub's built-in CI/CD platform.

### Basic Workflow Structure

```yaml
# .github/workflows/ci.yml
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

### Workflow Syntax

```yaml
on:                              # Trigger
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * *'         # Cron trigger

jobs:                            # Jobs to run
  job1:
    runs-on: ubuntu-latest      # VM image
    steps:
      - uses: actions/checkout@v4
      - name: Step name
        run: echo "Hello"
        with:
          key: value

  job2:
    needs: job1                 # Run after job1
    runs-on: ubuntu-latest
    steps:
      - run: echo "After job1"
```

## Common Actions

### Checkout & Setup

```yaml
- uses: actions/checkout@v4

- uses: actions/setup-node@v4
  with:
    node-version: '18'
    cache: 'npm'

- uses: actions/setup-python@v5
  with:
    python-version: '3.11'

- uses: actions/setup-go@v5
  with:
    go-version: '1.21'
```

### Docker Actions

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3

- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}

- name: Build and push
  uses: docker/build-push-action@v5
  with:
    push: true
    tags: user/repo:${{ github.sha }}
```

### AWS Actions

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy to S3
  run: aws s3 sync ./dist s3://my-bucket
```

## Matrix Strategy

Run jobs across multiple configurations:

```yaml
jobs:
  test:
    strategy:
      matrix:
        node-version: [16, 18, 20]
        operating-system: [ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.operating-system }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
```

## Secrets & Variables

### Repository Secrets

```
Settings → Secrets and variables → Actions → New repository secret
```

### Using Secrets

```yaml
- name: Deploy to Server
  run: |
    echo "${{ secrets.SERVER_PASSWORD }}" | my-deploy-tool
  env:
    API_KEY: ${{ secrets.API_KEY }}
```

### Variables

```yaml
on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'staging'

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to ${{ github.event.inputs.environment }}"
```

## Environments

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: production
      url: https://myapp.com
      
  deploy-staging:
    runs-on: ubuntu-latest
    environment:
      name: staging
    if: github.ref == 'refs/heads/develop'
```

## Caching Dependencies

```yaml
- name: Cache node_modules
  uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-npm-

- name: Cache Docker layers
  uses: docker/build-push-action@v5
  with:
    cache-from: type=registry,ref=user/app:latest
    cache-to: type=inline
```

## Artifacts

Pass files between jobs:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: tar -czf dist.tar.gz ./dist
      - uses: actions/upload-artifact@v4
        with:
          name: dist
          path: dist.tar.gz
          
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: dist
      - run: tar -xzf dist.tar.gz
```

## Full Example: Node.js App

```yaml
name: Node.js CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  NODE_VERSION: '18'

jobs:
  lint-and-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          
      - name: Cache dependencies
        uses: actions/cache@v4
        with:
          path: ~/.npm
          key: ${{ runner.os }}-npm-${{ hashFiles('package-lock.json') }}
          
      - name: Install dependencies
        run: npm ci
        
      - name: Lint
        run: npm run lint
        
      - name: Test
        run: npm test -- --coverage
        
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/coverage.xml

  build-and-push:
    needs: lint-and-test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
        
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}
          
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/myapp:latest
            ${{ secrets.DOCKER_USERNAME }}/myapp:${{ github.sha }}

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        run: |
          echo "Deploying ${{ github.sha }} to production..."
          # Your deployment commands here
```

## Conditionals

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Notify on main branch
        if: github.ref == 'refs/heads/main'
        run: echo "On main branch"
        
      - name: Notify on PR
        if: github.event_name == 'pull_request'
        run: echo "This is a PR"
        
      - name: Tag release
        if: startsWith(github.ref, 'refs/tags/')
        run: echo "Creating release"
```

## Reusable Workflows

```yaml
# .github/workflows/reusable-deploy.yml
on:
  workflow_call:
    inputs:
      environment:
        required: true
        type: string
    secrets:
      deploy-key:
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Deploying to ${{ inputs.environment }}"
```

Using the reusable workflow:

```yaml
# .github/workflows/production.yml
on:
  push:
    branches: [ main ]

jobs:
  deploy-production:
    uses: .github/workflows/reusable-deploy.yml
    with:
      environment: production
    secrets:
      deploy-key: ${{ secrets.DEPLOY_KEY }}
```

## Best Practices

| Practice | Why |
|----------|-----|
| Fast feedback | Developers should know within minutes |
| Fail fast | Stop pipeline on first failure |
| Single responsibility | Each step does one thing |
| Caching | Speed up builds |
| Secrets management | Never commit secrets |
| Idempotent | Can run multiple times safely |

---

**← [Back to Module 3](../03-docker-containers/README.md)** | **[Lab: Build Your First Pipeline →](./labs/lab-04-cicd-pipeline.md)**