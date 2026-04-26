# Module 3: Docker & Containers

## Learning Objectives

By the end of this module, you will:
- ✅ Understand container concepts
- ✅ Install and use Docker
- ✅ Create Docker images with Dockerfiles
- ✅ Manage containers (start, stop, logs)
- ✅ Use Docker Compose for multi-container apps
- ✅ Understand networking and volumes

## What are Containers?

Containers are lightweight, portable units that package an application with all its dependencies.

### Containers vs Virtual Machines

```
┌─────────────────────────────────────────────────────────┐
│                      Virtual Machine                    │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐       │
│  │   App 1    │  │   App 2    │  │   App 3    │       │
│  ├────────────┤  ├────────────┤  ├────────────┤       │
│  │   Bin/Lib  │  │   Bin/Lib  │  │   Bin/Lib  │       │
│  ├────────────┤  ├────────────┤  ├────────────┤       │
│  │    Guest OS │  │    Guest OS │  │    Guest OS │       │
│  ├────────────┤  ├────────────┤  ├────────────┤       │
│  │  Hypervisor │  │  Hypervisor │  │  Hypervisor │       │
│  └────────────┘  └────────────┘  └────────────┘       │
│                        Host OS                         │
│                   (Heavy, Slow)                         │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                      Containers                         │
│  ┌────────┐ ┌────────┐ ┌────────┐                      │
│  │  App 1 │ │  App 2 │ │  App 3 │                      │
│  └────────┘ └────────┘ └────────┘                      │
│  ┌────────┴─┴────────┴─┴────────┤                      │
│  │         Shared OS             │                      │
│  └───────────────┬───────────────┘                      │
│                  │                                      │
│            Docker Engine                                │
│           ┌──────┴──────┐                               │
│           │   Host OS   │                               │
│           │  (Lightweight, Fast)                         │
│           └─────────────┘                               │
└─────────────────────────────────────────────────────────┘
```

## Installing Docker

### macOS
```bash
# Download from docker.com or:
brew install --cask docker
```

### Windows
Download Docker Desktop from [docker.com](https://docker.com)

### Linux (Ubuntu)
```bash
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
```

## Docker Concepts

### Key Terms

| Term | Description |
|------|-------------|
| **Image** | A read-only template for creating containers |
| **Container** | A running instance of an image |
| **Dockerfile** | Script to build an image |
| **Registry** | Storage for images (Docker Hub) |
| **Volume** | Persistent data storage |

### Docker Architecture

```
┌──────────────┐      ┌──────────────┐
│   CLI        │ ───▶ │ Docker Daemon │
│ (docker CLI) │      │  (dockerd)    │
└──────────────┘      └───────┬───────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
              ┌──────────┐        ┌──────────┐
              │ Containers │       │  Images  │
              └──────────┘        └──────────┘
```

## Essential Docker Commands

### Images

```bash
docker images                    # List local images
docker pull nginx:latest        # Download image
docker rmi image_name           # Remove image
docker build -t myapp .        # Build from Dockerfile
docker tag myapp v1.0          # Tag an image
docker push myrepo/myapp:v1    # Upload to registry
```

### Containers

```bash
docker ps                        # Running containers
docker ps -a                    # All containers
docker run nginx                # Run container
docker run -d nginx             # Run in background
docker run -p 8080:80 nginx     # Map ports
docker run --name myapp nginx   # Name the container
docker run -it ubuntu bash     # Interactive terminal
docker start container_name     # Start stopped container
docker stop container_name    # Stop container
docker restart container_name   # Restart container
docker rm container_name       # Remove container
docker logs container_name     # View logs
docker logs -f container_name   # Follow logs
docker exec -it container bash # Enter container
```

### Advanced

```bash
docker run --rm image          # Auto-remove after exit
docker run -v /host:/container # Mount volume
docker run --network host     # Host networking
docker inspect container      # Container details
docker stats                  # Resource usage
docker system df              # Disk usage
docker system prune           # Clean unused resources
```

## Creating Docker Images

### Basic Dockerfile

```dockerfile
# syntax=docker/dockerfile:1
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "server.js"]
```

### Dockerfile Instructions

| Instruction | Description | Example |
|-------------|-------------|---------|
| FROM | Base image | FROM node:18 |
| RUN | Execute command | RUN npm install |
| COPY | Copy files | COPY ./src /app |
| ADD | Copy (advanced) | ADD archive.tar /app |
| WORKDIR | Set directory | WORKDIR /app |
| EXPOSE | Declare port | EXPOSE 3000 |
| ENV | Environment var | ENV PORT=3000 |
| CMD | Default command | CMD ["npm", "start"] |
| ENTRYPOINT | Main process | ENTRYPOINT ["python"] |

### Building Images

```bash
docker build -t myapp:1.0 .
docker build -t myapp:latest -f Dockerfile.prod .
docker build --no-cache -t myapp .
```

### .dockerignore

```gitignore
node_modules
npm-debug.log
.git
.gitignore
*.md
.env
.env.local
dist
build
```

## Docker Networking

### Network Types

```bash
docker network ls                    # List networks
docker network create mynet         # Create network
docker run --network mynet nginx   # Connect to network
```

### Bridge Network (Default)
```bash
docker network create --driver bridge my-bridge
docker run --network my-bridge -d app
```

### Port Mapping
```bash
# Host port : Container port
docker run -p 8080:80 nginx        # localhost:8080 → nginx:80
docker run -p 3000:3000 node-app   # localhost:3000 → app:3000
```

## Docker Volumes

### Types of Volumes

```bash
# Anonymous volume
docker run -v /data nginx

# Named volume (recommended)
docker run -v my-data:/data nginx

# Bind mount (host directory)
docker run -v $(pwd):/data nginx
docker run -v /host/path:/container/path nginx
```

### Volume Commands

```bash
docker volume ls                 # List volumes
docker volume create myvol       # Create volume
docker volume inspect myvol     # Inspect volume
docker volume rm myvol          # Remove volume
docker volume prune             # Remove unused volumes
```

## Docker Compose

Docker Compose manages multi-container applications.

### docker-compose.yml

```yaml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DB_HOST=db
    depends_on:
      - db
    volumes:
      - ./data:/app/data

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
      - POSTGRES_DB=myapp
    volumes:
      - db-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  db-data:
```

### Compose Commands

```bash
docker-compose up                 # Start services
docker-compose up -d             # Start in background
docker-compose down              # Stop and remove
docker-compose down -v           # Also remove volumes
docker-compose build             # Build images
docker-compose logs -f           # Follow logs
docker-compose ps                # Status
docker-compose exec web bash     # Shell into service
docker-compose restart           # Restart all
docker-compose scale web=3       # Scale service
```

## Best Practices

### Image Optimization

```dockerfile
# Use specific tags
FROM node:18-alpine

# Multi-stage builds
FROM node:18-alpine AS builder
WORKDIR /app
COPY . .
RUN npm ci

FROM node:18-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]

# Layer ordering (least frequent → most)
FROM python:3.11-slim
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
```

### Security

```dockerfile
# Don't run as root
USER node

# Use health checks
HEALTHCHECK --interval=30s CMD curl -f http://localhost/health || exit 1
```

## Common Issues

| Problem | Solution |
|---------|----------|
| Port already in use | Change port mapping |
| Out of disk space | docker system prune |
| Container won't start | docker logs to check errors |
| Permission denied | Use named volumes or fix permissions |
| Image not found | docker pull the image |

---

**← [Back to Module 2](../02-linux-essentials/README.md)** | **[Lab: Containerize a Web App →](./labs/lab-03-containerize-webapp.md)**