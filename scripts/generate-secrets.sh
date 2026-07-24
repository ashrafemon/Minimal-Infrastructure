#!/bin/bash
set -e

SECRETS_DIR="$(dirname "$0")/../secrets"
mkdir -p "$SECRETS_DIR"

echo "🔐 Generating secrets..."

# Database credentials
echo "leafwrap" > "$SECRETS_DIR/db_username"
openssl rand -base64 32 > "$SECRETS_DIR/db_password"
openssl rand -base64 32 > "$SECRETS_DIR/db_root_password"

# Redis
openssl rand -base64 32 > "$SECRETS_DIR/redis_password"

# RabbitMQ
echo "admin" > "$SECRETS_DIR/rabbitmq_user"
openssl rand -base64 32 > "$SECRETS_DIR/rabbitmq_password"

# pgAdmin
openssl rand -base64 32 > "$SECRETS_DIR/pgadmin_password"

# Grafana
openssl rand -base64 32 > "$SECRETS_DIR/grafana_password"

# Arcane
openssl rand -base64 32 > "$SECRETS_DIR/arcane_encryption_key"
openssl rand -base64 32 > "$SECRETS_DIR/arcane_jwt_secret"

# MinIO
echo "minioadmin" > "$SECRETS_DIR/minio_root_user"
openssl rand -base64 32 > "$SECRETS_DIR/minio_root_password"

chmod 600 "$SECRETS_DIR"/*

echo "✅ Secrets generated in $SECRETS_DIR"
echo "⚠️  Remember: NEVER commit these files to version control"
