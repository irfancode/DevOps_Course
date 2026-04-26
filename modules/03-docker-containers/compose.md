# Docker Compose

## docker-compose.yml

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

## Commands

```bash
docker-compose up              # Start services
docker-compose up -d            # Background
docker-compose down           # Stop
docker-compose down -v         # Remove volumes
docker-compose build           # Build images
docker-compose logs -f         # Follow logs
docker-compose ps             # Status
docker-compose exec web bash    # Shell
docker-compose restart       # Restart
docker-compose scale web=3   # Scale
```

## Networking

Services can communicate using service names:
- `web` can reach `db` at `postgres://db:5432`

## Environment Variables

```yaml
environment:
  - NODE_ENV=production     # Set value
  - DB_HOST                 # Use host env
```

## Health Checks

```yaml
services:
  db:
    image: postgres:15-alpine
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```

---

**Next: [Lab Exercises](./labs/lab-03-containerize-webapp.md)**