# Secrets

This directory contains sensitive credentials used by Docker Compose services.
**These files must never be committed to version control.**

## Generating Secrets

Run the secret generation script:

```bash
bash scripts/generate-secrets.sh
```

This will create all required secret files with secure random values.

## Required Secrets

| Secret File | Used By | Purpose |
|-------------|---------|---------|
| `db_username` | MySQL, MongoDB, Postgres | Database username |
| `db_password` | MySQL, MongoDB, Postgres | Database password |
| `db_root_password` | MySQL | MySQL root password |
| `redis_password` | Redis | Redis authentication password |
| `rabbitmq_user` | RabbitMQ | RabbitMQ username |
| `rabbitmq_password` | RabbitMQ | RabbitMQ password |
| `pgadmin_password` | pgAdmin | pgAdmin web UI password |
| `grafana_password` | Grafana | Grafana admin password |
| `arcane_encryption_key` | Arcane | Arcane encryption key (32+ chars) |
| `arcane_jwt_secret` | Arcane | Arcane JWT signing secret (32+ chars) |
| `minio_root_user` | MinIO | MinIO root username |
| `minio_root_password` | MinIO | MinIO root password |

## Security Notes

- All secret files should have permissions `600` (`chmod 600 secrets/*`)
- Use different secrets for development, staging, and production
- Rotate secrets periodically (recommended: every 90 days)
- If a server is compromised, rotate all secrets immediately

## Secret Rotation

To rotate a specific secret:
1. Update the secret file content
2. Restart the affected service:
   ```bash
   docker compose up -d --force-recreate <service-name>
   ```
