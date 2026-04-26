# Dockerfile Deep Dive

## Multi-stage Builds

```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/server.js"]
```

## Optimization Tips

| Technique | Example |
|-----------|---------|
| Minimize layers | Combine RUN commands |
| Use .dockerignore | Exclude build context |
| Multi-stage builds | Reduce final image size |
| Build cache | Order by change frequency |

## Common Instructions

```dockerfile
FROM         # Base image
RUN         # Execute command
COPY        # Copy files
ADD         # Copy (with extraction)
WORKDIR     # Set directory
ENV         # Environment variable
EXPOSE      # Document port
USER       # Switch user
VOLUME      # Volume mount
ENTRYPOINT  # Main process
CMD        # Default command
```

## Best Practices

1. Use specific tags (`node:18-alpine` not `node:latest`)
2. Run as non-root user
3. Use health checks
4. Minimize image size
5. Order instructions by frequency of change

---

**Next: [Docker Compose](./compose.md)**