#!/usr/bin/env bash
set -euo pipefail

# Load environment configuration if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ -f "${WORKSPACE_ROOT}/.env.deploy" ]; then
  echo "📄 Loading configuration from ${WORKSPACE_ROOT}/.env.deploy..."
  # shellcheck source=/dev/null
  source "${WORKSPACE_ROOT}/.env.deploy"
fi

# Verify required tools
command -v gcloud >/dev/null 2>&1 || { echo "❌ Error: 'gcloud' CLI is required but not installed."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Error: 'docker' is required but not installed."; exit 1; }

# Parameter defaults
PROJECT_ID="${GCP_PROJECT_ID:-$(gcloud config get-value project 2>/dev/null || echo '')}"
REGION="${GCP_REGION:-us-central1}"
ARTIFACT_REPO="${GCP_ARTIFACT_REPO:-chat-app}"
SERVICE_NAME="${GCP_SERVICE_NAME:-chat-server}"
JOB_NAME="${GCP_JOB_NAME:-chat-server-migrate}"
TAG="$(date +%Y%m%d%H%M%S)-$(git rev-parse --short HEAD 2>/dev/null || echo 'local')"

if [ -z "${PROJECT_ID}" ]; then
  echo "❌ Error: GCP_PROJECT_ID is not set. Run 'gcloud config set project <ID>' or set GCP_PROJECT_ID."
  exit 1
fi

IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REPO}/${SERVICE_NAME}:${TAG}"
IMAGE_LATEST="${REGION}-docker.pkg.dev/${PROJECT_ID}/${ARTIFACT_REPO}/${SERVICE_NAME}:latest"

echo "============================================================"
echo "🚀 Deploying Serverpod Backend to Google Cloud Run"
echo "Project:  ${PROJECT_ID}"
echo "Region:   ${REGION}"
echo "Image:    ${IMAGE_URI}"
echo "============================================================"

# Ensure Artifact Registry repository exists
echo "📦 Verifying Artifact Registry repository '${ARTIFACT_REPO}'..."
if ! gcloud artifacts repositories describe "${ARTIFACT_REPO}" --location="${REGION}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "Creating Artifact Registry repository '${ARTIFACT_REPO}'..."
  gcloud artifacts repositories create "${ARTIFACT_REPO}" \
    --repository-format=docker \
    --location="${REGION}" \
    --project="${PROJECT_ID}" \
    --description="Docker repository for Chat App services"
fi

# Configure Docker credentials for GCP
echo "🔑 Configuring Docker authentication for Google Cloud..."
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet

# Build Docker image
echo "🔨 Building Serverpod multi-stage production container..."
cd "${WORKSPACE_ROOT}"
docker build \
  --platform linux/amd64 \
  -f server/chat_server/Dockerfile \
  -t "${IMAGE_URI}" \
  -t "${IMAGE_LATEST}" \
  .

# Push Docker image
echo "⬆️ Pushing container image to Artifact Registry..."
docker push "${IMAGE_URI}"
docker push "${IMAGE_LATEST}"

# Step 1: Execute Database Migrations via Cloud Run Job
echo "🗄️ Configuring and running Cloud Run Migration Job '${JOB_NAME}'..."
MIGRATE_ARGS="--mode=production,--apply-migrations,--role=maintenance"

# Check if Cloud SQL connection is defined
CLOUDSQL_FLAG=""
if [ -n "${CLOUD_SQL_INSTANCE:-}" ]; then
  CLOUDSQL_FLAG="--set-cloudsql-instances=${CLOUD_SQL_INSTANCE}"
fi

# Create or update migration job
if gcloud run jobs describe "${JOB_NAME}" --region="${REGION}" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "Updating existing migration job..."
  # shellcheck disable=SC2086
  gcloud run jobs update "${JOB_NAME}" \
    --image="${IMAGE_URI}" \
    --region="${REGION}" \
    --project="${PROJECT_ID}" \
    --args="${MIGRATE_ARGS}" \
    ${CLOUDSQL_FLAG} \
    --quiet
else
  echo "Creating new migration job..."
  # shellcheck disable=SC2086
  gcloud run jobs create "${JOB_NAME}" \
    --image="${IMAGE_URI}" \
    --region="${REGION}" \
    --project="${PROJECT_ID}" \
    --args="${MIGRATE_ARGS}" \
    ${CLOUDSQL_FLAG} \
    --quiet
fi

echo "⏳ Executing database migrations..."
gcloud run jobs execute "${JOB_NAME}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}" \
  --wait

echo "✅ Migrations completed successfully."

# Step 2: Deploy Cloud Run Service
echo "🌐 Deploying Serverpod Service '${SERVICE_NAME}' to Cloud Run..."
# shellcheck disable=SC2086
gcloud run deploy "${SERVICE_NAME}" \
  --image="${IMAGE_URI}" \
  --region="${REGION}" \
  --project="${PROJECT_ID}" \
  --platform=managed \
  --allow-unauthenticated \
  --port=8080 \
  --min-instances=1 \
  --max-instances=10 \
  --concurrency=80 \
  --session-affinity \
  --timeout=3600 \
  ${CLOUDSQL_FLAG} \
  --quiet

SERVICE_URL="$(gcloud run services describe "${SERVICE_NAME}" --region="${REGION}" --project="${PROJECT_ID}" --format="value(status.url)")"

echo "============================================================"
echo "🎉 Serverpod Backend deployed successfully!"
echo "Service URL: ${SERVICE_URL}"
echo "WebSocket Endpoint: wss://${SERVICE_URL#https://}/websocket"
echo "============================================================"
