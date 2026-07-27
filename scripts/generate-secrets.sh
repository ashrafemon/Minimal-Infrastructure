#!/bin/bash
set -e

SECRETS_DIR="$(dirname "$0")/../secrets"
mkdir -p "$SECRETS_DIR"

echo "🔐 Generating secrets..."

# Database credentials
printf '%s' "leafwrap" > "$SECRETS_DIR/db_username"
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/db_password"
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/db_root_password"

# Redis
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/redis_password"

# RabbitMQ
printf '%s' "admin" > "$SECRETS_DIR/rabbitmq_user"
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/rabbitmq_password"

# pgAdmin
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/pgadmin_password"

# Arcane
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/arcane_encryption_key"
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/arcane_jwt_secret"

# MinIO
printf '%s' "minioadmin" > "$SECRETS_DIR/minio_root_user"
openssl rand -hex 32 | tr -d '\n' > "$SECRETS_DIR/minio_root_password"

chmod 600 "$SECRETS_DIR"/*

echo "✅ Secrets generated in $SECRETS_DIR"
echo "⚠️  Remember: NEVER commit these files to version control"
