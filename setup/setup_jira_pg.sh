#!/usr/bin/env bash
set -euo pipefail

# Configuration
DB_NAME="jira"
DB_USER="jira"
# Define complex password
DB_PASS="complex-password" 
CONTAINER_NAME="postgres-jira"
PGDATA_DIR="$(pwd)/pgdata"

echo "-> Creating pgdata directory: $PGDATA_DIR"
mkdir -p "$PGDATA_DIR"

# Optional: match directory ownership with current Linux user
# chown -R "$(id -u)":"$(id -g)" "$PGDATA_DIR"

echo "-> Pulling PostgreSQL image (postgres:16)..."
docker pull postgres:16

# Stop and remove existing container if it exists
if docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
  echo "-> Existing container found, stopping and removing: $CONTAINER_NAME"
  docker stop "$CONTAINER_NAME" || true
  docker rm "$CONTAINER_NAME" || true
fi

echo "-> Starting new PostgreSQL container..."
docker run -d \
  --name "$CONTAINER_NAME" \
  -e POSTGRES_DB="$DB_NAME" \
  -e POSTGRES_USER="$DB_USER" \
  -e POSTGRES_PASSWORD="$DB_PASS" \
  -v "$PGDATA_DIR":/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16

echo
echo "PostgreSQL is up and running."
echo "Connection details:"
echo "  Host    : localhost"
echo "  Port    : 5432"
echo "  DB Name : $DB_NAME"
echo "  User    : $DB_USER"
echo "  Pass    : $DB_PASS"
echo
echo "Connect using psql:"
echo "  psql -h localhost -p 5432 -U $DB_USER -d $DB_NAME"
