# Lab 3: Containerize a Web App 🚢

Time: 60 minutes | Difficulty: Beginner

## Overview

In this lab, you'll take a simple Node.js web application and package it into a Docker container.

## Prerequisites

- Docker installed and running
- Basic Git knowledge

## Part 1: Create the Application

```bash
mkdir ~/my-web-app
cd ~/my-web-app

# Create package.json
cat > package.json << 'EOF'
{
  "name": "my-web-app",
  "version": "1.0.0",
  "description": "A simple web app for Docker demo",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF

# Create server.js
cat > server.js << 'EOF'
const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>Docker Demo</title></head>
      <body>
        <h1>🐳 Hello from Docker!</h1>
        <p>Your app is running in a container.</p>
        <p>Container ID: ${process.env.HOSTNAME}</p>
        <p>Current Time: ${new Date().toISOString()}</p>
      </body>
    </html>
  `);
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF
```

---

## Part 2: Create the Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

COPY . .

EXPOSE 3000

ENV PORT=3000

CMD ["node", "server.js"]
EOF
```

### Build the Image

```bash
docker build -t my-web-app:1.0 .
docker images | grep my-web-app
```

---

## Part 3: Run the Container

```bash
# Run in background
docker run -d --name web-app -p 3000:3000 my-web-app:1.0

# Check if running
docker ps

# Test the app
curl http://localhost:3000

# View logs
docker logs web-app

# Stop and remove
docker stop web-app
docker rm web-app
```

---

## Part 4: Create Docker Compose Setup

```bash
cat > docker-compose.yml << 'EOF'
version: "3.8"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    restart: unless-stopped
    
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    depends_on:
      - web
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
EOF

cat > nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        
        location / {
            proxy_pass http://web:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
EOF
```

### Run with Compose

```bash
docker-compose up -d
docker-compose ps
curl http://localhost
docker-compose down
```

---

## Part 5: Add a Database (Bonus)

```bash
cat > docker-compose.prod.yml << 'EOF'
version: "3.8"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DB_HOST=db
      - DB_PORT=5432
      - POSTGRES_PASSWORD=secretpassword
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secretpassword
      - POSTGRES_DB=webapp
    volumes:
      - db-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:
EOF
```

```bash
docker-compose -f docker-compose.prod.yml up -d
docker-compose -f docker-compose.prod.yml ps
docker-compose -f docker-compose.prod.yml down
```

---

## Cleanup

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker system prune -f
cd ~ && rm -rf ~/my-web-app
```

---

## What You Learned

- ✅ Creating a Dockerfile
- ✅ Building a Docker image
- ✅ Running containers
- ✅ Port mapping
- ✅ Environment variables
- ✅ Docker Compose for multi-container apps
- ✅ Health checks

---

**Lab Complete! 🎉**

Next: [Module 4: CI/CD Pipelines](../04-cicd-pipelines/README.md)