# Docker Development Stack

A complete local development and production environment with databases, messaging, storage, management UIs, reverse proxy, CI/CD, monitoring, and security scanning.

## Stack Overview

| Category | Services |
|----------|----------|
| **Databases** | MySQL, MongoDB, PostgreSQL |
| **Cache** | Redis + Redis Insight |
| **Messaging** | RabbitMQ |
| **Storage** | MinIO (S3-compatible) |
| **Email Testing** | Mailpit |
| **Management UIs** | phpMyAdmin, pgAdmin, Arcane (Docker management) |
| **Reverse Proxy** | Nginx Proxy Manager with SSL |
| **Monitoring** | Uptime Kuma |
| **CI/CD** | Jenkins |
| **Security** | Trivy (vulnerability scanner) |
| **Backup** | Automated volume backups |

## Services

| Service | Image | Ports | Description |
|---------|-------|-------|-------------|
| MySQL | mysql:9.3 | 3306 | Relational database |
| MongoDB | mongo:8.0.15 | 27018 | Document database |
| PostgreSQL | postgres:16 | 5432 | Relational database |
| Redis | redis:7 | 6379 | In-memory cache/store |
| Redis Insight | redis/redisinsight:latest | 6789 | Redis web UI |
| RabbitMQ | rabbitmq:4-management | 5672, 15672 | Message broker with management UI |
| Mailpit | axllent/mailpit:latest | 8025, 1025 | SMTP testing server with web UI |
| MinIO | minio/minio:latest | 9000, 9001 | S3-compatible object storage |
| phpMyAdmin | phpmyadmin:latest | 3456 | MySQL web UI |
| pgAdmin | dpage/pgadmin4 | 5050 | PostgreSQL web UI |
| Arcane | ghcr.io/getarcaneapp/manager:latest | 3552 | Docker container management UI |
| Nginx Proxy Manager | jc21/nginx-proxy-manager:latest | 80, 443, 81 | Reverse proxy with SSL and web UI |
| Uptime Kuma | louislam/uptime-kuma:latest | 3001 | Uptime monitoring and alerting |
| Jenkins | Custom image (jenkins/jenkins:lts + Docker tools) | 8080, 50000 | CI/CD automation server |
| Trivy | aquasec/trivy:latest | 4954 | Vulnerability scanner for containers and IaC |
| Docker Socket Proxy | tecnativa/docker-socket-proxy:latest | - | Secure Docker access for Jenkins |
| Backup | offen/docker-volume-backup:latest | - | Automated volume backups |

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- OpenSSL (for secret generation)

## Quick Start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Server
   ```

2. **Generate secrets**
   ```bash
   bash scripts/generate-secrets.sh
   ```
   This creates all required secret files in `./secrets/` with secure random values.

3. **Start all services**
   ```bash
   docker compose up -d
   ```
   On first run, the custom Jenkins image will be built automatically.

4. **Verify services are running**
   ```bash
   docker compose ps
   ```

## Pre-pull Images

To avoid timeout issues during `docker compose up`, pre-pull all required images:

```bash
docker pull dpage/pgadmin4
docker pull rabbitmq:4-management
docker pull tecnativa/docker-socket-proxy:latest
docker pull axllent/mailpit:latest
docker pull mysql:9.3
docker pull redis:7
docker pull redis/redisinsight:latest
docker pull offen/docker-volume-backup:latest
docker pull louislam/uptime-kuma:latest
docker pull minio/minio:latest
docker pull postgres:16
docker pull mongo:8.0.15
docker pull phpmyadmin:latest
docker pull ghcr.io/getarcaneapp/manager:latest
docker pull jc21/nginx-proxy-manager:latest
docker pull aquasec/trivy:0.63.0
```

## Directory Structure

```
.
├── docker-compose.yml          # Main compose file with includes, networks, volumes, secrets
├── compose/                    # Modular service definitions
│   ├── databases.yml           # MySQL, MongoDB, PostgreSQL
│   ├── cache.yml               # Redis, Redis Insight
│   ├── messaging.yml           # RabbitMQ
│   ├── storage.yml             # MinIO
│   ├── email.yml               # Mailpit
│   ├── management.yml          # phpMyAdmin, pgAdmin, Arcane
│   ├── proxy.yml               # Nginx Proxy Manager
│   ├── monitoring.yml          # Uptime Kuma
│   ├── ci.yml                  # Jenkins + Docker Socket Proxy
│   ├── security.yml            # Trivy
│   └── backup.yml              # Backup service
├── jenkins/
│   └── Dockerfile              # Custom Jenkins image with Docker CLI + Compose
├── scripts/
│   └── generate-secrets.sh     # Generate all required secrets
├── secrets/                    # Docker secrets (gitignored)
│   ├── db_username
│   ├── db_password
│   ├── db_root_password
│   ├── redis_password
│   ├── rabbitmq_user
│   ├── rabbitmq_password
│   ├── pgadmin_password
│   ├── arcane_encryption_key
│   ├── arcane_jwt_secret
│   ├── minio_root_user
│   └── minio_root_password
├── backups/                    # Backup storage
├── .gitignore
└── README.md
```

## Compose Structure

The stack uses the `include` directive to split services into modular Compose files:

| File | Services |
|------|----------|
| `docker-compose.yml` | Main file: shared networks, volumes, secrets, and includes |
| `compose/databases.yml` | MySQL, MongoDB, PostgreSQL |
| `compose/cache.yml` | Redis, Redis Insight |
| `compose/messaging.yml` | RabbitMQ |
| `compose/storage.yml` | MinIO |
| `compose/email.yml` | Mailpit |
| `compose/management.yml` | phpMyAdmin, pgAdmin, Arcane |
| `compose/proxy.yml` | Nginx Proxy Manager |
| `compose/monitoring.yml` | Uptime Kuma |
| `compose/ci.yml` | Jenkins + Docker Socket Proxy |
| `compose/security.yml` | Trivy |
| `compose/backup.yml` | Backup |

To run a specific group only:
```bash
docker compose -f docker-compose.yml -f compose/databases.yml up -d
```

## Secret Management

All credentials are stored as Docker secrets in `./secrets/`. These files are gitignored and should never be committed.

### Generating Secrets

```bash
bash scripts/generate-secrets.sh
```

### Secret Files

| Secret File | Used By | Purpose |
|-------------|---------|---------|
| `db_username` | MySQL, MongoDB, Postgres | Database username |
| `db_password` | MySQL, MongoDB, Postgres | Database password |
| `db_root_password` | MySQL | MySQL root password |
| `redis_password` | Redis | Redis authentication password |
| `rabbitmq_user` | RabbitMQ | RabbitMQ username |
| `rabbitmq_password` | RabbitMQ | RabbitMQ password |
| `pgadmin_password` | pgAdmin | pgAdmin web UI password |
| `arcane_encryption_key` | Arcane | Arcane encryption key (32+ chars) |
| `arcane_jwt_secret` | Arcane | Arcane JWT signing secret (32+ chars) |
| `minio_root_user` | MinIO | MinIO root username |
| `minio_root_password` | MinIO | MinIO root password |

### Rotating Secrets

1. Update the secret file content
2. Restart the affected service:
   ```bash
   docker compose up -d --force-recreate <service-name>
   ```

## Service URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| phpMyAdmin | http://localhost:3456 | Uses MySQL root credentials |
| Redis Insight | http://localhost:6789 | Uses Redis password |
| pgAdmin | http://localhost:5050 | Email: admin@example.com, Password: see `secrets/pgadmin_password` |
| RabbitMQ Management | http://localhost:15672 | Username: admin, Password: see `secrets/rabbitmq_password` |
| Mailpit UI | http://localhost:8025 | No auth required |
| Mailpit SMTP | localhost:1025 | No auth required |
| MinIO API | http://localhost:9000 | Access Key: minioadmin, Secret: see `secrets/minio_root_password` |
| MinIO Console | http://localhost:9001 | Access Key: minioadmin, Secret: see `secrets/minio_root_password` |
| Arcane | http://localhost:3552 | Set during first login |
| Nginx Proxy Manager | http://localhost:81 | Default: admin@example.com / changeme |
| Uptime Kuma | http://localhost:3001 | Create admin account on first login |
| Jenkins | http://localhost:8080 | Initial admin password from container logs |
| Trivy | http://localhost:4954 | Server mode for vulnerability scanning |

## Database Connection Strings

### MySQL
```
mysql://root:<db_root_password>@localhost:3306
```

### PostgreSQL
```
postgresql://<db_username>:<db_password>@localhost:5432/postgres
```

### MongoDB
```
mongodb://<db_username>:<db_password>@localhost:27018
```

### Redis
```
redis://:<redis_password>@localhost:6379
```

### RabbitMQ (AMQP)
```
amqp://admin:<rabbitmq_password>@localhost:5672
```

### MinIO (S3-compatible)
```
Endpoint: localhost:9000
Access Key: minioadmin
Secret Key: <minio_root_password>
```

## Nginx Proxy Manager

NPM provides a web UI for managing reverse proxies, SSL certificates, and access control.

### Accessing the UI
- **Admin UI**: `http://localhost:81`
- **Default credentials**: `admin@example.com` / `changeme` (change on first login)

### Adding a Proxy Host

1. Open NPM UI at `http://localhost:81`
2. Go to **Hosts** → **Proxy Hosts** → **Add Proxy Host**
3. Fill in:
   - **Domain**: your domain name (e.g., `app.yourdomain.com`)
   - **Forward to**: `http://localhost:3000` (your upstream service)
   - **Forward Port**: the port your app runs on
4. Under **SSL** tab:
   - Enable **SSL**
   - Choose **Let's Encrypt** (if using public domain) or **Custom** (if using Cloudflare Origin cert)
   - For Let's Encrypt: enter your email and agree to terms
   - For Cloudflare Origin cert: paste certificate and private key
5. Save

### Using Cloudflare with NPM

**Option A: Let's Encrypt (Easiest)**
- Set Cloudflare SSL/TLS mode to **"Full"** or **"Full (strict)"**
- Ensure DNS A record points to your server IP
- NPM will automatically issue and renew Let's Encrypt certs

**Option B: Cloudflare Origin Certificates (Most Secure)**
1. Generate Origin certificate in Cloudflare Dashboard → SSL/TLS → Origin Server
2. In NPM: **SSL** → **Certificates** → **Add SSL Certificate** → **Custom**
3. Paste Cloudflare certificate and private key
4. Set Cloudflare SSL/TLS mode to **"Full (strict)"**

## Uptime Kuma

Uptime Kuma monitors the availability of your services and sends alerts when they go down.

### Accessing the UI
- **URL**: `http://localhost:3001`
- Create an admin account on first visit

### Adding a Monitor

1. Open Uptime Kuma at `http://localhost:3001`
2. Click **"Add New Monitor"**
3. Fill in:
   - **Monitor Type**: HTTP(s), TCP, Ping, DNS, etc.
   - **Friendly Name**: e.g., "My Website"
   - **URL/IP**: `http://localhost:3000` or your domain
   - **Check Interval**: how often to check (e.g., 60 seconds)
4. Under **"Alert Contacts"**, add notification methods: Email, Slack, Discord, Telegram, Webhook, etc.
5. Save

### Example Monitors

| Monitor Type | Target | Port |
|--------------|--------|------|
| HTTP(s) | MySQL | http://localhost:3306 |
| HTTP(s) | Redis | http://localhost:6379 |
| HTTP(s) | MongoDB | http://localhost:27018 |
| HTTP(s) | Postgres | http://localhost:5432 |
| HTTP(s) | RabbitMQ | http://localhost:15672 |
| HTTP(s) | MinIO | http://localhost:9000 |
| HTTP(s) | Arcane | http://localhost:3552 |
| TCP | MySQL | 3306 |
| TCP | Redis | 6379 |
| TCP | Postgres | 5432 |

## Jenkins

Jenkins is an open-source CI/CD automation server for building, testing, and deploying applications.

### Accessing Jenkins
- **URL**: `http://localhost:8080`
- **Initial Setup**: Get the initial admin password from the container logs:
  ```bash
  docker compose logs jenkins | grep "initial admin password"
  ```
- Paste the password in the browser to unlock Jenkins and create an admin user.

### Docker Integration

Jenkins connects to Docker via a **Docker Socket Proxy** (`jenkins-docker-proxy`), which provides controlled access to the Docker daemon. This allows Jenkins to:
- Build Docker images
- Run `docker compose` commands
- Push images to registries
- Start/stop/manipulate containers

**Why Socket Proxy instead of direct socket mount:**
- Limits Jenkins to only the Docker permissions it actually needs
- Blocks dangerous operations like host filesystem access and kernel-level actions
- Follows the security principle of least privilege
- Still supports all `docker compose` operations needed for your CI/CD pipelines

### Custom Jenkins Image

Jenkins uses a custom image based on `jenkins/jenkins:lts` (`jenkins/Dockerfile`) that includes:
- Docker CLI (`docker`)
- Docker Compose (`docker-compose`)
- Required tools for building and deploying containers

The image is built from `jenkins/Dockerfile` when you run `docker compose up -d`.

### Recommended Plugins

After setup, install these plugins via **Manage Jenkins** → **Plugins**:
- **Docker Pipeline** - Build Docker images in pipelines
- **Docker Commons** - Docker-related utilities
- **Git** - Git integration
- **GitHub Integration** - GitHub webhooks and PR triggers
- **Blue Ocean** - Modern UI for pipelines

### Security Note
- Port `50000` is for Jenkins agents. Only expose it if you use external agents.
- The `jenkins_data` volume contains all Jenkins configuration and job history. Back it up regularly.

### Resource Limits
- Memory: 1GB limit
- CPU: 0.5 cores limit

## Trivy

Trivy is a vulnerability scanner for containers, filesystems, and infrastructure-as-code. It scans for known vulnerabilities (CVEs), misconfigurations, and secrets.

### Scanning Docker Images

```bash
# Scan an image
docker compose exec trivy trivy image mysql:9.3

# Scan with severity filter
docker compose exec trivy trivy image --severity HIGH,CRITICAL mysql:9.3

# Scan and output JSON
docker compose exec trivy trivy image --format json mysql:9.3 > scan-report.json
```

### Scanning the Filesystem

```bash
docker compose exec trivy trivy fs .
```

### Scanning IaC Files

```bash
docker compose exec trivy trivy config .
```

### Using Trivy in CI/CD (Jenkins)

Add a Trivy scanning stage to your Jenkins pipeline:

```groovy
pipeline {
    agent any
    stages {
        stage('Scan Image') {
            steps {
                sh 'docker compose exec trivy trivy image --exit-code 1 --severity CRITICAL myapp:latest'
            }
        }
    }
}
```

### Resource Limits
- Memory: 512MB limit
- CPU: 0.5 cores limit

## Backup

Automated backups run daily at 2:00 AM. Backups are stored in `./backups/` and retained for 7 days.

### Manual Backup

```bash
docker compose up -d backup
```

### Restore from Backup

```bash
docker compose down
# Extract backup archive and copy data to volume directories
docker compose up -d
```

### Backup Contents

The backup service includes volumes from:
- MySQL, Redis, MongoDB, PostgreSQL
- RabbitMQ, Mailpit, MinIO
- Arcane

## Resource Limits

All services have CPU and memory limits defined to prevent resource exhaustion.

## Health Checks

Most services include health checks to ensure they're running properly.

## Common Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs -f <service-name>

# Restart a service
docker compose restart <service-name>

# Recreate a service (e.g., after secret rotation)
docker compose up -d --force-recreate <service-name>

# Check service status
docker compose ps
```

## Security Notes

- All secrets are stored in `./secrets/` with `600` permissions
- No `.env` file is used; all sensitive data is in Docker secrets
- `secrets/` directory is gitignored
- Use different secrets for development, staging, and production
- Rotate secrets periodically (recommended: every 90 days)
- Jenkins uses a Docker Socket Proxy to limit host access
- NPM admin UI (port 81) should be secured in production
